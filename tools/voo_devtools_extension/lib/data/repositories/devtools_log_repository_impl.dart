import 'package:voo_logging/core/domain/enums/log_level.dart';
import 'package:voo_logging/features/logging/data/models/log_entry_model.dart';
import 'package:voo_logging_devtools_extension/domain/datasources/devtools_log_datasource.dart';
import 'package:voo_logging_devtools_extension/domain/repositories/devtools_log_repository.dart';

class DevToolsLogRepositoryImpl implements DevToolsLogRepository {
  final DevToolsLogDataSource dataSource;

  DevToolsLogRepositoryImpl({required this.dataSource});

  @override
  Stream<LogEntryModel> get logStream => dataSource.logStream;

  @override
  List<LogEntryModel> getCachedLogs() => dataSource.getCachedLogs();

  @override
  void clearLogs() => dataSource.clearCache();

  @override
  List<LogEntryModel> filterLogs({List<LogLevel>? levels, String? searchQuery, String? category}) {
    var logs = getCachedLogs();

    if (levels != null && levels.isNotEmpty) {
      logs = logs.where((log) => levels.contains(log.level)).toList();
    }

    if (category != null && category.isNotEmpty) {
      logs = logs.where((log) => log.category == category).toList();
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      logs = logs
          .where(
            (log) =>
                log.message.toLowerCase().contains(query) ||
                (log.category?.toLowerCase().contains(query) ?? false) ||
                (log.tag?.toLowerCase().contains(query) ?? false) ||
                (log.error?.toString().toLowerCase().contains(query) ?? false),
          )
          .toList();
    }

    return logs;
  }
}
