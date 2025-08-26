/// Statistics about stored logs
/// Same as before, but now powered by Sembast
class LogStatistics {
  final int totalLogs;
  final Map<String, int> levelCounts;
  final Map<String, int> categoryCounts;
  final Map<String, int> tagCounts;
  final DateTime? earliestLog;
  final DateTime? latestLog;

  // Aliases for compatibility
  DateTime? get oldestLog => earliestLog;
  DateTime? get newestLog => latestLog;

  LogStatistics({
    required this.totalLogs,
    required this.levelCounts,
    required this.categoryCounts,
    Map<String, int>? tagCounts,
    this.earliestLog,
    this.latestLog,
  }) : tagCounts = tagCounts ?? {};

  /// Duration covered by logs
  Duration? get timeSpan {
    if (earliestLog == null || latestLog == null) return null;
    return latestLog!.difference(earliestLog!);
  }

  /// Logs per day average
  double? get logsPerDay {
    final span = timeSpan;
    if (span == null || span.inDays == 0) return null;
    return totalLogs / span.inDays;
  }

  /// Factory method to create empty statistics
  factory LogStatistics.empty() => LogStatistics(totalLogs: 0, levelCounts: {}, categoryCounts: {}, tagCounts: {});
}
