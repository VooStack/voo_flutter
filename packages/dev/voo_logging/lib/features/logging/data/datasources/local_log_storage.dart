// lib/src/storage/log_storage.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:voo_logging/core/domain/enums/log_level.dart';
import 'package:voo_logging/features/logging/data/models/log_entry_model.dart';
import 'package:voo_logging/features/logging/data/models/log_entry_model_extensions.dart';
import 'package:voo_logging/features/logging/domain/entities/log_entry.dart';
import 'package:voo_logging/features/logging/domain/entities/log_entry_extensions.dart';
import 'package:voo_logging/features/logging/domain/entities/log_statistics.dart';

/// Handles persistent storage of log entries using Sembast
///
/// Why Sembast over SQLite?
/// - Works on ALL platforms (including web!)
/// - NoSQL structure perfect for our metadata-rich logs
/// - No native dependencies to worry about
/// - Great performance with automatic indexing
class LocalLogStorage {
  static LocalLogStorage? _instance;
  static Database? _database;
  static bool _webStorageError = false;

  // Store references - think of these as "tables" in SQL
  static final _logsStore = intMapStoreFactory.store('logs');
  static final _metadataStore = stringMapStoreFactory.store('metadata');

  /// Get the singleton instance
  factory LocalLogStorage() {
    _instance ??= LocalLogStorage._internal();
    return _instance!;
  }

  // Private constructor prevents external instantiation
  LocalLogStorage._internal();

  /// Check if web storage has encountered an error
  bool get hasWebStorageError => _webStorageError;

  /// Helper to safely find records with web error handling
  Future<List<RecordSnapshot<int, Map<String, Object?>>>> _safeFindLogs(Database db, {Finder? finder}) async {
    try {
      return await _logsStore.find(db, finder: finder);
    } catch (e) {
      if (kIsWeb && (e.toString().contains('IdbCursor') || e.toString().contains('LegacyJavaScriptObject'))) {
        _webStorageError = true;
        return [];
      }
      rethrow;
    }
  }

  /// Get database instance (lazy initialization)
  /// Why lazy? We don't want to open DB until we actually need it
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// Initialize the database
  /// Handles both web and mobile/desktop platforms
  Future<Database> _initDatabase() async {
    DatabaseFactory dbFactory;
    String dbPath;

    if (kIsWeb) {
      // Web: Use IndexedDB through sembast_web
      dbFactory = databaseFactoryWeb;
      dbPath = 'voo_logs.db';
    } else {
      // Mobile/Desktop: Use file system through sembast_io
      dbFactory = databaseFactoryIo;

      // Get proper application documents directory
      final appDocDir = await getApplicationDocumentsDirectory();
      final dbDirectory = Directory(path.join(appDocDir.path, 'voo_logging'));

      // Create directory if it doesn't exist
      if (!dbDirectory.existsSync()) {
        dbDirectory.createSync(recursive: true);
      }

      dbPath = path.join(dbDirectory.path, 'voo_logs.db');
    }

    // Open database
    final db = await dbFactory.openDatabase(dbPath);

    // Initialize metadata if first time
    await _initializeMetadata(db);

    return db;
  }

  /// Initialize metadata store with app info
  /// Why? Helps track database schema version and app context
  Future<void> _initializeMetadata(Database db) async {
    final existingVersion = await _metadataStore.record('schema_version').get(db);

    if (existingVersion == null) {
      // First time setup
      await _metadataStore.record('schema_version').put(db, {'version': 1});
      await _metadataStore.record('created_at').put(db, {'timestamp': DateTime.now().toIso8601String()});
    }
  }

  /// Insert a single log entry
  /// Why auto-increment key? Sembast handles unique IDs for us
  Future<void> insertLog(LogEntry entry) async {
    final db = await database;

    // Convert to Map and add auto-generated timestamp key for sorting
    final data = entry.toModel().toJson();

    // Use timestamp as key for natural ordering
    // Add microseconds to handle multiple logs in same millisecond
    final key = entry.timestamp.millisecondsSinceEpoch * 1000 + entry.timestamp.microsecond;

    await _logsStore.record(key).put(db, data);
  }

  /// Batch insert multiple log entries
  /// Why batch? Much faster than individual inserts, especially on web
  Future<void> insertLogs(List<LogEntry> entries) async {
    final db = await database;

    // Use transaction for consistency
    await db.transaction((txn) async {
      for (final entry in entries) {
        final data = entry.toModel().toJson();
        final key = entry.timestamp.millisecondsSinceEpoch * 1000 + entry.timestamp.microsecond;

        await _logsStore.record(key).put(txn, data);
      }
    });
  }

  /// Query logs with flexible filtering
  /// This is where Sembast really shines - flexible querying without SQL
  ///
  /// How Sembast filtering works:
  /// - Filter.equals(): Exact match
  /// - Filter.matches(): Regex/pattern matching
  /// - Filter.greaterThan()/lessThan(): Range queries
  /// - Filter.and()/or(): Combine conditions
  Future<List<LogEntry>> queryLogs({
    List<LogLevel>? levels,
    List<String>? categories,
    List<String>? tags,
    String? messagePattern,
    DateTime? startTime,
    DateTime? endTime,
    String? userId,
    String? sessionId,
    int limit = 1000,
    int offset = 0,
    bool ascending = false, // Most recent first by default
  }) async {
    final db = await database;

    // Build filters list
    final filters = <Filter>[];

    // Level filtering
    // Using Filter.custom() for checking if value is in a list
    if (levels != null && levels.isNotEmpty) {
      final levelNames = levels.map((l) => l.name).toList();
      filters.add(
        Filter.custom((record) {
          final level = (record.value as Map<String, dynamic>?)?['level'] as String?;
          return level != null && levelNames.contains(level);
        }),
      );
    }

    // Category filtering
    if (categories != null && categories.isNotEmpty) {
      filters.add(
        Filter.custom((record) {
          final category = (record.value as Map<String, dynamic>?)?['category'] as String?;
          return category != null && categories.contains(category);
        }),
      );
    }

    // Tag filtering
    if (tags != null && tags.isNotEmpty) {
      filters.add(
        Filter.custom((record) {
          final tag = (record.value as Map<String, dynamic>?)?['tag'] as String?;
          return tag != null && tags.contains(tag);
        }),
      );
    }

    // Message pattern matching
    // Why custom filter? Sembast doesn't have LIKE, so we use regex
    if (messagePattern != null && messagePattern.isNotEmpty) {
      filters.add(
        Filter.custom((record) {
          final message = (record.value as Map<String, dynamic>?)?['message'] as String;
          return message.toLowerCase().contains(messagePattern.toLowerCase());
        }),
      );
    }

    // Time range filtering
    if (startTime != null) {
      filters.add(Filter.greaterThanOrEquals('timestamp', startTime.millisecondsSinceEpoch));
    }

    if (endTime != null) {
      filters.add(Filter.lessThanOrEquals('timestamp', endTime.millisecondsSinceEpoch));
    }

    // User filtering
    if (userId != null) {
      filters.add(Filter.equals('userId', userId));
    }

    // Session filtering
    if (sessionId != null) {
      filters.add(Filter.equals('sessionId', sessionId));
    }

    // Combine all filters with AND
    Filter? combinedFilter;
    if (filters.isNotEmpty) {
      combinedFilter = filters.length == 1 ? filters.first : Filter.and(filters);
    }

    // Create finder with filter and sorting
    final finder = Finder(
      filter: combinedFilter,
      sortOrders: [
        // Sort by key (which is timestamp-based) in descending order
        SortOrder(Field.key, ascending),
      ],
      limit: limit,
      offset: offset,
    );

    // Execute query with error handling for web IndexedDB issues
    final records = await _safeFindLogs(db, finder: finder);

    // Convert records back to LogEntry objects
    return records.map((record) {
      final data = Map<String, dynamic>.from(record.value);
      return LogEntryModel.fromJson(data).toEntity();
    }).toList();
  }

  /// Get statistics about logs
  /// Demonstrates Sembast's aggregation capabilities
  Future<LogStatistics> getLogStatistics() async {
    final db = await database;

    // Get all records for analysis with web error handling
    final allRecords = await _safeFindLogs(db);

    // Count by level
    final levelCounts = <String, int>{};
    final categoryCounts = <String, int>{};
    DateTime? earliestLog, latestLog;

    for (final record in allRecords) {
      final data = record.value;

      // Level counts
      final level = data['level']! as String;
      levelCounts[level] = (levelCounts[level] ?? 0) + 1;

      // Category counts
      final category = data['category'] as String?;
      if (category != null) {
        categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
      }

      // Date range
      final timestamp = DateTime.parse(data['timestamp']! as String);
      if (earliestLog == null || timestamp.isBefore(earliestLog)) {
        earliestLog = timestamp;
      }
      if (latestLog == null || timestamp.isAfter(latestLog)) {
        latestLog = timestamp;
      }
    }

    // Sort categories by count (most frequent first)
    final sortedCategories = Map.fromEntries(categoryCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value)));

    return LogStatistics(
      totalLogs: allRecords.length,
      levelCounts: levelCounts,
      categoryCounts: sortedCategories,
      earliestLog: earliestLog,
      latestLog: latestLog,
    );
  }

  /// Get unique values for filtering UI
  /// Why? Powers dropdown filters in DevTools extension
  Future<List<String>> getUniqueCategories() async {
    final db = await database;

    // Find all records with non-null categories
    final finder = Finder(filter: Filter.notEquals('category', null));

    final records = await _safeFindLogs(db, finder: finder);

    // Extract unique categories
    final categories = records.map((record) => record.value['category']! as String).toSet().toList();

    categories.sort();
    return categories;
  }

  Future<List<String>> getUniqueTags() async {
    final db = await database;

    final finder = Finder(filter: Filter.notEquals('tag', null));

    final records = await _safeFindLogs(db, finder: finder);

    final tags = records.map((record) => record.value['tag']! as String).toSet().toList();

    tags.sort();
    return tags;
  }

  Future<List<String>> getUniqueSessions() async {
    final db = await database;

    final finder = Finder(
      filter: Filter.notEquals('sessionId', null),
      sortOrders: [SortOrder(Field.key, false)], // Most recent first
      limit: 50, // Don't overwhelm the UI
    );

    final records = await _safeFindLogs(db, finder: finder);

    // Get unique session IDs while preserving recent-first order
    final sessionIds = <String>[];
    final seen = <String>{};

    for (final record in records) {
      final sessionId = record.value['sessionId']! as String;
      if (!seen.contains(sessionId)) {
        sessionIds.add(sessionId);
        seen.add(sessionId);
      }
    }

    return sessionIds;
  }

  /// Clear logs with optional filtering
  /// Sembast makes this clean with its filtering system
  Future<void> clearLogs({DateTime? olderThan, List<LogLevel>? levels, List<String>? categories}) async {
    final db = await database;

    final filters = <Filter>[];

    if (olderThan != null) {
      filters.add(Filter.lessThan('timestamp', olderThan.millisecondsSinceEpoch));
    }

    if (levels != null && levels.isNotEmpty) {
      final levelNames = levels.map((l) => l.name).toList();
      filters.add(
        Filter.custom((record) {
          final level = (record.value as Map<String, dynamic>?)?['level'] as String?;
          return level != null && levelNames.contains(level);
        }),
      );
    }

    if (categories != null && categories.isNotEmpty) {
      filters.add(
        Filter.custom((record) {
          final category = (record.value as Map<String, dynamic>?)?['category'] as String?;
          return category != null && categories.contains(category);
        }),
      );
    }

    // Create finder with combined filters
    Filter? combinedFilter;
    if (filters.isNotEmpty) {
      combinedFilter = filters.length == 1 ? filters.first : Filter.and(filters);
    }

    if (combinedFilter != null) {
      // Delete matching records
      await _logsStore.delete(db, finder: Finder(filter: combinedFilter));
    } else {
      // Clear all logs if no conditions
      await _logsStore.delete(db);
    }
  }

  /// Export logs to JSON
  /// Perfect for external analysis or backup
  Future<String> exportLogs({List<LogLevel>? levels, DateTime? startTime, DateTime? endTime}) async {
    final logs = await queryLogs(
      levels: levels,
      startTime: startTime,
      endTime: endTime,
      limit: 10000, // Large limit for export
    );

    final exportData = {
      'exportDate': DateTime.now().toIso8601String(),
      'totalLogs': logs.length,
      'platform': kIsWeb ? 'web' : 'mobile',
      'logs': logs.map((log) => log.toModel().toJson()).toList(),
    };

    return jsonEncode(exportData);
  }

  /// Get database info
  /// Useful for debugging and monitoring
  Future<Map<String, dynamic>> getDatabaseInfo() async {
    final db = await database;

    final totalLogs = await _logsStore.count(db);
    final metadata = await _metadataStore.find(db);

    return {
      'totalLogs': totalLogs,
      'platform': kIsWeb ? 'web' : 'mobile',
      'metadata': Map.fromEntries(metadata.map((record) => MapEntry(record.key, record.value))),
    };
  }

  /// Perform automatic cleanup based on retention settings.
  ///
  /// - [maxLogs]: Maximum number of logs to retain. Oldest logs are deleted first.
  /// - [retentionDays]: Maximum age of logs in days. Logs older than this are deleted.
  Future<int> performCleanup({int? maxLogs, int? retentionDays}) async {
    final db = await database;
    int totalDeleted = 0;

    // First, delete logs older than retention period
    if (retentionDays != null && retentionDays > 0) {
      final cutoffDate = DateTime.now().subtract(Duration(days: retentionDays));
      final cutoffTimestamp = cutoffDate.millisecondsSinceEpoch;

      // Find logs older than cutoff using custom filter on parsed timestamp
      final oldLogsFinder = Finder(
        filter: Filter.custom((record) {
          final data = record.value as Map<String, dynamic>?;
          if (data == null) return false;
          final timestampStr = data['timestamp'] as String?;
          if (timestampStr == null) return false;
          try {
            final timestamp = DateTime.parse(timestampStr);
            return timestamp.millisecondsSinceEpoch < cutoffTimestamp;
          } catch (_) {
            return false;
          }
        }),
      );

      final deletedByAge = await _logsStore.delete(db, finder: oldLogsFinder);
      totalDeleted += deletedByAge;
    }

    // Then, enforce maxLogs limit by deleting oldest entries
    if (maxLogs != null && maxLogs > 0) {
      final currentCount = await _logsStore.count(db);
      if (currentCount > maxLogs) {
        final excessCount = currentCount - maxLogs;

        // Find the oldest logs (sorted by key ascending, which is timestamp-based)
        final oldestLogsFinder = Finder(
          sortOrders: [SortOrder(Field.key)], // Ascending = oldest first
          limit: excessCount,
        );

        final oldestRecords = await _safeFindLogs(db, finder: oldestLogsFinder);
        for (final record in oldestRecords) {
          await _logsStore.record(record.key).delete(db);
          totalDeleted++;
        }
      }
    }

    return totalDeleted;
  }

  /// Get the current log count
  Future<int> getLogCount() async {
    final db = await database;
    return _logsStore.count(db);
  }
}
