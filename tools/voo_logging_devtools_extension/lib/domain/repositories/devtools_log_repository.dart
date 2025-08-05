import 'package:voo_logging/core/domain/enums/log_level.dart';
import 'package:voo_logging/features/logging/data/models/log_entry_model.dart';

abstract class DevToolsLogRepository {
  Stream<LogEntryModel> get logStream;
  List<LogEntryModel> getCachedLogs();
  void clearLogs();
  List<LogEntryModel> filterLogs({List<LogLevel>? levels, String? searchQuery, String? category});
}
