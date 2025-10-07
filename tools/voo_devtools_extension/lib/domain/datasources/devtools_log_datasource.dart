import 'package:voo_devtools_extension/core/models/log_entry_model.dart';

/// Interface for DevTools log data source
abstract class DevToolsLogDataSource {
  /// Stream of log entries
  Stream<LogEntryModel> get logStream;

  /// Get all cached log entries
  List<LogEntryModel> getCachedLogs();

  /// Clear the log cache
  void clearCache();

  /// Dispose resources
  void dispose();
}
