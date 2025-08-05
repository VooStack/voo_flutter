import 'package:voo_logging/features/logging/domain/entities/log_entry.dart';
import 'package:voo_logging/features/logging/domain/entities/log_statistics.dart';

extension LogStatisticsExtensions on LogStatistics {
  static LogStatistics fromLogs(List<LogEntry> logs) {
    final levelCounts = <String, int>{};
    final categoryCounts = <String, int>{};
    final tagCounts = <String, int>{};
    DateTime? earliestLog;
    DateTime? latestLog;

    for (final log in logs) {
      // Count by level
      final levelName = log.level.name;
      levelCounts[levelName] = (levelCounts[levelName] ?? 0) + 1;

      // Count by category
      if (log.category != null) {
        categoryCounts[log.category!] = (categoryCounts[log.category!] ?? 0) + 1;
      }

      // Count by tag
      if (log.tag != null) {
        tagCounts[log.tag!] = (tagCounts[log.tag!] ?? 0) + 1;
      }

      // Track time range
      if (earliestLog == null || log.timestamp.isBefore(earliestLog)) {
        earliestLog = log.timestamp;
      }
      if (latestLog == null || log.timestamp.isAfter(latestLog)) {
        latestLog = log.timestamp;
      }
    }

    return LogStatistics(
      totalLogs: logs.length,
      levelCounts: levelCounts,
      categoryCounts: categoryCounts,
      tagCounts: tagCounts,
      earliestLog: earliestLog,
      latestLog: latestLog,
    );
  }
}
