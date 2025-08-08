import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:voo_core/voo_core.dart';
import 'package:voo_logging/features/logging/data/datasources/local_log_storage.dart';
import 'package:voo_logging/features/logging/data/models/log_sync_entity.dart';
import 'package:voo_logging/features/logging/domain/utils/pretty_log_formatter.dart';
import 'package:voo_logging/voo_logging.dart';

class LoggerRepositoryImpl extends LoggerRepository {
  LocalLogStorage? _storage;
  String? _currentUserId;
  String? _currentSessionId;
  LogLevel _minimumLevel = LogLevel.debug;
  bool _enabled = true;
  String? _appName;
  String? _appVersion;
  int _logCounter = 0;
  LoggingConfig _config = const LoggingConfig();
  late PrettyLogFormatter _formatter;

  final _random = Random();

  final StreamController<LogEntry> _logStreamController = StreamController<LogEntry>.broadcast();

  @override
  Stream<LogEntry> get stream async* {
    yield LogEntry(id: 'initial', timestamp: DateTime.now(), message: 'Logger streaming started', level: LogLevel.info);

    yield* _logStreamController.stream;
  }

  @override
  Future<void> initialize({
    LogLevel minimumLevel = LogLevel.debug,
    String? userId,
    String? sessionId,
    String? appName,
    String? appVersion,
    bool enabled = true,
    LoggingConfig? config,
  }) async {
    _config = config ?? LoggingConfig(minimumLevel: minimumLevel);
    _formatter = _config.formatter;
    _minimumLevel = _config.minimumLevel;
    _currentUserId = userId;
    _currentSessionId = sessionId ?? _generateSessionId();
    _appName = appName;
    _appVersion = appVersion;
    _enabled = _config.enabled;

    _storage = LocalLogStorage();

    await _logInternal(
      'VooLogger initialized',
      category: 'System',
      tag: 'Init',
      metadata: {
        'minimumLevel': _config.minimumLevel.name,
        'userId': userId,
        'sessionId': _currentSessionId,
        'appName': appName,
        'appVersion': appVersion,
        'prettyLogs': _config.enablePrettyLogs,
      },
    );
  }

  String _generateSessionId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomPart = _random.nextInt(1000);
    return '${timestamp}_$randomPart';
  }

  String _generateLogId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final counter = ++_logCounter;
    final randomPart = _random.nextInt(1000);
    return '${timestamp}_${counter}_$randomPart';
  }

  Future<void> _logInternal(
    String message, {
    LogLevel level = LogLevel.info,
    String? category,
    String? tag,
    Map<String, dynamic>? metadata,
    Object? error,
    StackTrace? stackTrace,
    String? userId,
    String? sessionId,
  }) async {
    if (!_enabled || level.priority < _minimumLevel.priority) {
      return;
    }

    final entry = LogEntry(
      id: _generateLogId(),
      timestamp: DateTime.now(),
      message: message,
      level: level,
      category: category,
      tag: tag,
      metadata: _enrichMetadata(metadata),
      error: error,
      stackTrace: stackTrace?.toString(),
      userId: userId ?? _currentUserId,
      sessionId: sessionId ?? _currentSessionId,
    );

    _logToDevTools(entry);
    if (_config.enableDevToolsJson) {
      _sendStructuredLogToDevTools(entry);
    }

    _logStreamController.add(entry);

    await _storage?.insertLog(entry).catchError((_) => null);
    
    // Sync to cloud if enabled
    final options = Voo.options;
    if (options != null && options.enableCloudSync && options.apiKey != null) {
      final syncEntity = LogSyncEntity(logEntry: entry);
      await CloudSyncManager.instance.addToQueue(syncEntity);
    }
  }

  Map<String, dynamic>? _enrichMetadata(Map<String, dynamic>? userMetadata) {
    final enriched = <String, dynamic>{};

    if (_appName != null) enriched['appName'] = _appName;
    if (_appVersion != null) enriched['appVersion'] = _appVersion;
    enriched['timestamp'] = DateTime.now().toIso8601String();

    if (userMetadata != null) {
      enriched.addAll(userMetadata);
    }

    return enriched.isEmpty ? null : enriched;
  }

  void _logToDevTools(LogEntry entry) {
    try {
      // Use pretty formatter for console output
      final formattedMessage = _formatter.format(entry);

      // Always use developer.log but with formatted output
      developer.log(
        formattedMessage,
        name: entry.category ?? 'VooLogger',
        level: entry.level.priority,
        error: _config.enablePrettyLogs ? null : entry.error, // Don't duplicate error in pretty mode
        stackTrace: _config.enablePrettyLogs ? null : (entry.stackTrace != null ? StackTrace.fromString(entry.stackTrace!) : null),
        sequenceNumber: entry.timestamp.millisecondsSinceEpoch,
        time: entry.timestamp,
        zone: Zone.current,
      );
      // ignore: empty_catches
    } catch (e) {}
  }

  void _sendStructuredLogToDevTools(LogEntry entry) {
    try {
      // Send structured log data as JSON through the standard logging mechanism
      final structuredData = {
        '__voo_logger__': true,
        'entry': {
          'id': entry.id,
          'timestamp': entry.timestamp.toIso8601String(),
          'message': entry.message,
          'level': entry.level.name,
          'category': entry.category,
          'tag': entry.tag,
          'metadata': entry.metadata,
          'error': entry.error?.toString(),
          'stackTrace': entry.stackTrace,
          'userId': entry.userId,
          'sessionId': entry.sessionId,
        },
      };

      // Send as a structured log that the DevTools extension can parse
      developer.log(jsonEncode(structuredData), name: 'VooLogger', level: entry.level.priority, time: entry.timestamp);

      // Also try postEvent for better DevTools integration
      developer.postEvent('voo_logger_event', structuredData);
    } catch (_) {
      // Silent fail - logging is best effort
    }
  }

  @override
  Future<void> verbose(String message, {String? category, String? tag, Map<String, dynamic>? metadata}) async {
    await _logInternal(message, level: LogLevel.verbose, category: category, tag: tag, metadata: metadata);
  }

  @override
  Future<void> debug(String message, {String? category, String? tag, Map<String, dynamic>? metadata}) async {
    await _logInternal(message, level: LogLevel.debug, category: category, tag: tag, metadata: metadata);
  }

  @override
  Future<void> info(String message, {String? category, String? tag, Map<String, dynamic>? metadata}) async {
    await _logInternal(message, category: category, tag: tag, metadata: metadata);
  }

  @override
  Future<void> warning(String message, {String? category, String? tag, Map<String, dynamic>? metadata}) async {
    await _logInternal(message, level: LogLevel.warning, category: category, tag: tag, metadata: metadata);
  }

  @override
  Future<void> error(String message, {Object? error, StackTrace? stackTrace, String? category, String? tag, Map<String, dynamic>? metadata}) async {
    await _logInternal(message, level: LogLevel.error, category: category, tag: tag, metadata: metadata, error: error, stackTrace: stackTrace);
  }

  @override
  Future<void> fatal(String message, {Object? error, StackTrace? stackTrace, String? category, String? tag, Map<String, dynamic>? metadata}) async {
    await _logInternal(message, level: LogLevel.fatal, category: category, tag: tag, metadata: metadata, error: error, stackTrace: stackTrace);
  }

  @override
  Future<void> log(
    String message, {
    LogLevel level = LogLevel.info,
    String? category,
    String? tag,
    Map<String, dynamic>? metadata,
    Object? error,
    StackTrace? stackTrace,
  }) async {
    await _logInternal(message, level: level, category: category, tag: tag, metadata: metadata, error: error, stackTrace: stackTrace);
  }

  @override
  Future<void> setUserId(String? userId) async => _currentUserId = userId;

  @override
  void startNewSession([String? sessionId]) {
    _currentSessionId = sessionId ?? _generateSessionId();
    info('New session started', category: 'System', tag: 'Session', metadata: {'sessionId': _currentSessionId});
  }

  Future<void> setMinimumLevel(LogLevel level) async => _minimumLevel = level;

  Future<void> setEnabled(bool enabled) async => _enabled = enabled;

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
    bool ascending = false,
  }) async =>
      await _storage?.queryLogs(
        levels: levels,
        categories: categories,
        tags: tags,
        messagePattern: messagePattern,
        startTime: startTime,
        endTime: endTime,
        userId: userId,
        sessionId: sessionId,
        limit: limit,
        offset: offset,
        ascending: ascending,
      ) ??
      [];

  @override
  Future<LogStatistics> getStatistics() async => await _storage?.getLogStatistics() ?? LogStatistics(totalLogs: 0, levelCounts: {}, categoryCounts: {});

  Future<List<String>> getCategories() async => await _storage?.getUniqueCategories() ?? [];

  Future<List<String>> getTags() async => await _storage?.getUniqueTags() ?? [];

  Future<List<String>> getSessions() async => await _storage?.getUniqueSessions() ?? [];

  @override
  Future<void> clearLogs({DateTime? olderThan, List<LogLevel>? levels, List<String>? categories}) async {
    await _storage?.clearLogs(olderThan: olderThan, levels: levels, categories: categories);
  }

  @override
  Future<String> exportLogs({List<LogLevel>? levels, DateTime? startTime, DateTime? endTime}) async =>
      await _storage?.exportLogs(levels: levels, startTime: startTime, endTime: endTime) ?? '{"logs": [], "totalLogs": 0}';

  @override
  Future<void> networkRequest(String method, String url, {Map<String, String>? headers, dynamic body, Map<String, dynamic>? metadata}) async {
    await info(
      '$method $url',
      category: 'Network',
      tag: 'Request',
      metadata: {'method': method, 'url': url, 'headers': headers, 'hasBody': body != null, ...?metadata},
    );
  }

  @override
  Future<void> networkResponse(
    int statusCode,
    String url,
    Duration duration, {
    Map<String, String>? headers,
    int? contentLength,
    Map<String, dynamic>? metadata,
  }) async {
    final level = statusCode >= 400 ? LogLevel.error : LogLevel.info;

    await log(
      'Response $statusCode for $url (${duration.inMilliseconds}ms)',
      level: level,
      category: 'Network',
      tag: 'Response',
      metadata: {'statusCode': statusCode, 'url': url, 'duration': duration.inMilliseconds, 'headers': headers, 'contentLength': contentLength, ...?metadata},
    );
  }

  @override
  Future<void> userAction(String action, {String? screen, Map<String, dynamic>? properties}) async {
    await info(
      'User action: $action',
      category: 'Analytics',
      tag: 'UserAction',
      metadata: {'action': action, 'screen': screen, 'properties': properties, 'userId': _currentUserId},
    );
  }

  void close() {
    _logStreamController.close();
  }
}
