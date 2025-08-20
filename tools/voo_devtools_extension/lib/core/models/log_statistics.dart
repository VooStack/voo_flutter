import 'package:voo_logging_devtools_extension/core/models/log_level.dart';

/// Statistics about log entries
class LogStatistics {
  final int totalLogs;
  final Map<LogLevel, int> logCountByLevel;
  final Map<String, int> logCountByCategory;
  final double logsPerSecond;
  final DateTime? firstLogTime;
  final DateTime? lastLogTime;

  const LogStatistics({
    required this.totalLogs,
    required this.logCountByLevel,
    required this.logCountByCategory,
    required this.logsPerSecond,
    this.firstLogTime,
    this.lastLogTime,
  });

  /// Create empty statistics
  factory LogStatistics.empty() {
    return LogStatistics(
      totalLogs: 0,
      logCountByLevel: {},
      logCountByCategory: {},
      logsPerSecond: 0,
      firstLogTime: null,
      lastLogTime: null,
    );
  }

  /// Get error count
  int get errorCount {
    return (logCountByLevel[LogLevel.error] ?? 0) + 
           (logCountByLevel[LogLevel.fatal] ?? 0);
  }

  /// Get warning count
  int get warningCount {
    return logCountByLevel[LogLevel.warning] ?? 0;
  }

  /// Get info count
  int get infoCount {
    return logCountByLevel[LogLevel.info] ?? 0;
  }

  /// Get debug count
  int get debugCount {
    return logCountByLevel[LogLevel.debug] ?? 0;
  }

  /// Get the most common category
  String? get mostCommonCategory {
    if (logCountByCategory.isEmpty) return null;
    
    var maxEntry = logCountByCategory.entries.first;
    for (var entry in logCountByCategory.entries) {
      if (entry.value > maxEntry.value) {
        maxEntry = entry;
      }
    }
    return maxEntry.key;
  }

  /// Create from a list of log entries
  factory LogStatistics.fromLogEntries(List<dynamic> entries) {
    if (entries.isEmpty) return LogStatistics.empty();

    final logCountByLevel = <LogLevel, int>{};
    final logCountByCategory = <String, int>{};
    
    DateTime? firstTime;
    DateTime? lastTime;

    for (final entry in entries) {
      // Count by level
      final level = entry.level as LogLevel;
      logCountByLevel[level] = (logCountByLevel[level] ?? 0) + 1;
      
      // Count by category
      final category = entry.category as String? ?? 'Uncategorized';
      logCountByCategory[category] = (logCountByCategory[category] ?? 0) + 1;
      
      // Track time range
      final timestamp = entry.timestamp as DateTime;
      if (firstTime == null || timestamp.isBefore(firstTime)) {
        firstTime = timestamp;
      }
      if (lastTime == null || timestamp.isAfter(lastTime)) {
        lastTime = timestamp;
      }
    }

    // Calculate logs per second
    double logsPerSecond = 0;
    if (firstTime != null && lastTime != null) {
      final duration = lastTime.difference(firstTime);
      if (duration.inSeconds > 0) {
        logsPerSecond = entries.length / duration.inSeconds;
      }
    }

    return LogStatistics(
      totalLogs: entries.length,
      logCountByLevel: logCountByLevel,
      logCountByCategory: logCountByCategory,
      logsPerSecond: logsPerSecond,
      firstLogTime: firstTime,
      lastLogTime: lastTime,
    );
  }
}

/// Extensions for LogStatistics
extension LogStatisticsExtensions on LogStatistics {
  /// Get a formatted summary
  String get summary {
    final parts = <String>[];
    parts.add('Total: $totalLogs');
    
    if (errorCount > 0) {
      parts.add('Errors: $errorCount');
    }
    if (warningCount > 0) {
      parts.add('Warnings: $warningCount');
    }
    
    return parts.join(' | ');
  }

  /// Check if there are any errors
  bool get hasErrors => errorCount > 0;
  
  /// Check if there are any warnings
  bool get hasWarnings => warningCount > 0;
}