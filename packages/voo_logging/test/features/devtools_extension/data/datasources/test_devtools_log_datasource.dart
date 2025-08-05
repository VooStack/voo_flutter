import 'dart:async';
import 'package:voo_logging/features/devtools_extension/data/datasources/devtools_log_datasource.dart';
import 'package:voo_logging/features/logging/data/models/log_entry_model.dart';

class TestDevToolsLogDataSource implements DevToolsLogDataSource {
  final _logController = StreamController<LogEntryModel>.broadcast();
  final _cachedLogs = <LogEntryModel>[];

  @override
  Stream<LogEntryModel> get logStream => _logController.stream;

  @override
  List<LogEntryModel> getCachedLogs() => List.unmodifiable(_cachedLogs);

  @override
  void clearCache() {
    _cachedLogs.clear();
  }

  void addLog(LogEntryModel log) {
    _cachedLogs.add(log);
    _logController.add(log);
  }

  void dispose() {
    _logController.close();
  }
}
