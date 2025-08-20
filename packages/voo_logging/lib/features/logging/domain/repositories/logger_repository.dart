import 'package:voo_logging/voo_logging.dart';

abstract class LoggerRepository {
  Stream<LogEntry> get stream;
  Future<void> initialize({
    String? appName, 
    String? appVersion, 
    String? userId, 
    LogLevel minimumLevel = LogLevel.verbose,
    LoggingConfig? config,
  });

  Future<void> verbose(String message, {String? category, String? tag, Map<String, dynamic>? metadata});
  Future<void> debug(String message, {String? category, String? tag, Map<String, dynamic>? metadata});
  Future<void> info(String message, {String? category, String? tag, Map<String, dynamic>? metadata});
  Future<void> warning(String message, {String? category, String? tag, Map<String, dynamic>? metadata});
  Future<void> error(String message, {Object? error, StackTrace? stackTrace, String? category, String? tag, Map<String, dynamic>? metadata});
  Future<void> fatal(String message, {Object? error, StackTrace? stackTrace, String? category, String? tag, Map<String, dynamic>? metadata});
  
  void log(String s, {required LogLevel level, String? category, required Map<String, Object> metadata, String? tag});
  
  Future<void> networkRequest(String s, String t, {required Map<String, String> headers, required Map<String, String> metadata});
  Future<void> networkResponse(int i, String s, Duration duration, {required Map<String, String> headers, required int contentLength, required Map<String, Object> metadata});
  
  void userAction(String s, {required String screen, required Map<String, Object> properties});
  
  Future<LogStatistics> getStatistics();
  Future<List<LogEntry>> getLogs({LogFilter? filter});
  Future<List<Map<String, dynamic>>> exportLogs();
  Future<void> clearLogs();
  
  void setUserId(String newUserId);
  void startNewSession();
}