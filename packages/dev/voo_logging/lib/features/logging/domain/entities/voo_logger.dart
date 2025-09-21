import 'package:voo_logging/features/logging/data/repositories/logger_repository_impl.dart';
import 'package:voo_logging/voo_logging.dart';
import 'package:voo_toast/voo_toast.dart';

/// VooLogger provides logging capabilities for Voo applications.
class VooLogger {
  bool _initialized = false;
  factory VooLogger() => instance;
  final LoggerRepository _repository = LoggerRepositoryImpl();
  Stream<LogEntry> get stream => _repository.stream;
  LoggerRepository get repository => _repository;
  LoggingConfig? _config;
  VooLogger._internal();

  static final VooLogger instance = VooLogger._internal();

  static LoggingConfig get config => instance._config ?? const LoggingConfig();

  /// Check if a toast should be shown for the given log level
  static bool _shouldShowToast(LogLevel level) {
    if (instance._config?.shouldNotify != true) return false;

    // Never show toasts for verbose or debug logs - they're too low-level
    if (level == LogLevel.verbose || level == LogLevel.debug) return false;

    // Only show toasts for logs at or above the configured minimum level
    return level.priority >= (instance._config?.minimumLevel.priority ?? LogLevel.info.priority);
  }

  static Future<void> initialize({String? appName, String? appVersion, String? userId, LogLevel minimumLevel = LogLevel.verbose, LoggingConfig? config, bool shouldNotify = false}) async {
    if (instance._initialized) {
      // If already initialized, just update the config
      instance._config = config ?? LoggingConfig(
        minimumLevel: minimumLevel,
        shouldNotify: shouldNotify,
      );
      return;
    }

    instance._initialized = true;
    instance._config = config ?? LoggingConfig(
      minimumLevel: minimumLevel,
      shouldNotify: shouldNotify,
    );

    await instance._repository.initialize(
      appName: appName,
      appVersion: appVersion,
      userId: userId,
      minimumLevel: instance._config!.minimumLevel,
      config: instance._config,
    );
  }

  static set config(LoggingConfig newConfig) {
    instance._config = newConfig;
  }

  static Future<void> verbose(String message, {String? category, String? tag, Map<String, dynamic>? metadata}) async {
    if (!instance._initialized) {
      throw StateError('VooLogger must be initialized before use');
    }
    await instance._repository.verbose(message, category: category, tag: tag, metadata: metadata);

    // Don't show toast for verbose logs - too low level
    // Verbose logs are primarily for detailed debugging
  }

  static Future<void> debug(String message, {String? category, String? tag, Map<String, dynamic>? metadata}) async {
    if (!instance._initialized) {
      throw StateError('VooLogger must be initialized before use');
    }
    await instance._repository.debug(message, category: category, tag: tag, metadata: metadata);

    // Don't show toast for debug logs - too low level
    // Debug logs are primarily for development debugging
  }

  static Future<void> info(String message, {String? category, String? tag, Map<String, dynamic>? metadata}) async {
    if (!instance._initialized) {
      throw StateError('VooLogger must be initialized before use');
    }
    await instance._repository.info(message, category: category, tag: tag, metadata: metadata);

    if (_shouldShowToast(LogLevel.info)) {
      VooToast.showInfo(
        message: message,
        title: category ?? 'Info',
      );
    }
  }

  static Future<void> warning(String message, {String? category, String? tag, Map<String, dynamic>? metadata}) async {
    if (!instance._initialized) {
      throw StateError('VooLogger must be initialized before use');
    }
    await instance._repository.warning(message, category: category, tag: tag, metadata: metadata);

    if (_shouldShowToast(LogLevel.warning)) {
      VooToast.showWarning(
        message: message,
        title: category ?? 'Warning',
      );
    }
  }

  static Future<void> error(String message, {Object? error, StackTrace? stackTrace, String? category, String? tag, Map<String, dynamic>? metadata}) async {
    if (!instance._initialized) {
      throw StateError('VooLogger must be initialized before use');
    }
    await instance._repository.error(message, error: error, stackTrace: stackTrace, category: category, tag: tag, metadata: metadata);

    if (_shouldShowToast(LogLevel.error)) {
      final errorMessage = error != null ? '$message: $error' : message;
      VooToast.showError(
        message: errorMessage,
        title: category ?? 'Error',
      );
    }
  }

  static Future<void> fatal(String message, {Object? error, StackTrace? stackTrace, String? category, String? tag, Map<String, dynamic>? metadata}) async {
    if (!instance._initialized) {
      throw StateError('VooLogger must be initialized before use');
    }
    await instance._repository.fatal(message, error: error, stackTrace: stackTrace, category: category, tag: tag, metadata: metadata);

    if (_shouldShowToast(LogLevel.fatal)) {
      final errorMessage = error != null ? '$message: $error' : message;
      VooToast.showError(
        message: errorMessage,
        title: category ?? 'Fatal Error',
        duration: const Duration(seconds: 10), // Longer duration for fatal errors
      );
    }
  }

  static void log(String s, {required LogLevel level, String? category, required Map<String, Object> metadata, String? tag}) {
    if (!instance._initialized) {
      throw StateError('VooLogger must be initialized before use');
    }
    instance._repository.log(s, level: level, category: category, metadata: metadata, tag: tag);
  }

  static Future<void> networkRequest(String s, String t, {required Map<String, String> headers, required Map<String, String> metadata}) async {
    if (!instance._initialized) {
      throw StateError('VooLogger must be initialized before use');
    }
    await instance._repository.networkRequest(s, t, headers: headers, metadata: metadata);
  }

  static void userAction(String s, {required String screen, required Map<String, Object> properties}) {
    if (!instance._initialized) {
      throw StateError('VooLogger must be initialized before use');
    }
    instance._repository.userAction(s, screen: screen, properties: properties);
  }

  Future<List<LogEntry>> getLogs({LogFilter? filter}) async => _repository.getLogs(filter: filter);

  Future<void> clearLogs() async {
    await _repository.clearLogs();
  }

  Future<LogStatistics> getStatistics() async => _repository.getStatistics();
}
