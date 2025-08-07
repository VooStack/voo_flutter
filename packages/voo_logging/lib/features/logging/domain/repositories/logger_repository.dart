import 'package:voo_logging/voo_logging.dart';

abstract class LoggerRepository {
  Stream<LogEntry> get stream;
  Future<void> initialize({String? appName, String? appVersion, String? userId, LogLevel minimumLevel = LogLevel.verbose});

  Future<void> verbose(String message, {String? category, String? tag, Map<String, dynamic>? metadata});
  Future<void> debug(String message, {String? category, String? tag, Map<String, dynamic>? metadata});
  Future<void> info(String message, {String? category, String? tag, Map<String, dynamic>? metadata});
  Future<void> warning(String message, {String? category, String? tag, Map<String, dynamic>? metadata});
  Future<void> error(String message, {Object? error, StackTrace? stackTrace, String? category, String? tag, Map<String, dynamic>? metadata});

  Future getStatistics();

  Future exportLogs();

  Future<void> clearLogs();

  void setUserId(String newUserId);

  void startNewSession();

  Future<void> networkResponse(int i, String s, Duration duration, {Map<String, String> headers, int contentLength, Map<String, Object> metadata});

  void userAction(String s, {String screen, Map<String, Object> properties});

  Future<void> fatal(String message, {Object? error, StackTrace? stackTrace, String? category, String? tag, Map<String, dynamic>? metadata});

  void log(String s, {LogLevel level, String? category, Map<String, Object> metadata, String? tag});

  Future<void> networkRequest(String s, String t, {Map<String, String> headers, Map<String, String> metadata});
}
