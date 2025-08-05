import 'package:voo_logging/features/devtools_extension/data/datasources/devtools_log_datasource.dart';
import 'package:voo_logging/features/devtools_extension/data/datasources/simple_log_datasource.dart';
import 'package:voo_logging/features/logging/data/models/log_entry_model.dart';

/// Wrapper to make SimpleLogDataSource implement DevToolsLogDataSource
class SimpleDevToolsLogDataSource implements DevToolsLogDataSource {
  final SimpleLogDataSource _simpleDataSource;

  SimpleDevToolsLogDataSource() : _simpleDataSource = SimpleLogDataSource();

  @override
  Stream<LogEntryModel> get logStream => _simpleDataSource.logStream;

  @override
  List<LogEntryModel> getCachedLogs() => _simpleDataSource.getCachedLogs();

  @override
  void clearCache() => _simpleDataSource.clearCache();

  void dispose() => _simpleDataSource.dispose();
}
