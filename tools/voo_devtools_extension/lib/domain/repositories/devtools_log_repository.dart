import 'package:voo_devtools_extension/core/models/log_level.dart';
import 'package:voo_devtools_extension/core/models/log_entry_model.dart';

abstract class DevToolsLogRepository {
  Stream<LogEntryModel> get logStream;
  List<LogEntryModel> getCachedLogs();
  void clearLogs();
  List<LogEntryModel> filterLogs({
    List<LogLevel>? levels,
    String? searchQuery,
    String? category,
  });
}
