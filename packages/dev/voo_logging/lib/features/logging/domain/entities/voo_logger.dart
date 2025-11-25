import 'package:voo_logging/features/logging/data/repositories/logger_repository_impl.dart';
import 'package:voo_logging/voo_logging.dart';
import 'package:voo_toast/voo_toast.dart';

/// VooLogger provides logging capabilities for Voo applications.
///
/// Supports zero-config usage - just call logging methods directly:
/// ```dart
/// VooLogger.info('Hello world'); // Auto-initializes with smart defaults
/// ```
///
/// Or initialize explicitly for more control:
/// ```dart
/// await VooLogger.ensureInitialized(config: LoggingConfig.production());
/// ```
class VooLogger {
  bool _initialized = false;
  bool _initializing = false;
  factory VooLogger() => instance;
  final LoggerRepository _repository = LoggerRepositoryImpl();
  Stream<LogEntry> get stream => _repository.stream;
  LoggerRepository get repository => _repository;
  LoggingConfig? _config;
  VooLogger._internal();

  static final VooLogger instance = VooLogger._internal();

  static LoggingConfig get config => instance._config ?? LoggingConfig.minimal();

  /// Returns true if VooLogger has been initialized.
  static bool get isInitialized => instance._initialized;

  /// Ensures VooLogger is initialized. Safe to call multiple times.
  ///
  /// This is the recommended way to explicitly initialize VooLogger when you
  /// need custom configuration. For zero-config usage, just call logging
  /// methods directly - they auto-initialize with [LoggingConfig.minimal()].
  static Future<void> ensureInitialized({
    String? appName,
    String? appVersion,
    String? userId,
    LoggingConfig? config,
  }) async {
    await initialize(appName: appName, appVersion: appVersion, userId: userId, config: config);
  }

  /// Initialize VooLogger with optional configuration.
  ///
  /// This is called automatically on first log if not explicitly called.
  /// For explicit initialization with custom config, prefer [ensureInitialized].
  static Future<void> initialize({String? appName, String? appVersion, String? userId, LoggingConfig? config}) async {
    instance._config = config ?? instance._config ?? LoggingConfig.minimal();

    if (instance._initialized) {
      // If already initialized, update the repository with new config
      await instance._repository.initialize(
        appName: appName,
        appVersion: appVersion,
        userId: userId,
        minimumLevel: instance._config!.minimumLevel,
        config: instance._config,
      );
      return;
    }

    instance._initialized = true;

    await instance._repository.initialize(
      appName: appName,
      appVersion: appVersion,
      userId: userId,
      minimumLevel: instance._config!.minimumLevel,
      config: instance._config,
    );
  }

  /// Auto-initialize if not already initialized.
  /// Uses [LoggingConfig.minimal()] which auto-detects debug/release mode.
  static Future<void> _autoInitialize() async {
    if (instance._initialized || instance._initializing) return;

    instance._initializing = true;
    try {
      await initialize();
    } finally {
      instance._initializing = false;
    }
  }

  static set config(LoggingConfig newConfig) {
    instance._config = newConfig;
  }

  /// Log a verbose message. Auto-initializes if needed.
  ///
  /// Verbose logs are for detailed debugging information.
  static Future<void> verbose(String message, {String? category, String? tag, Map<String, dynamic>? metadata}) async {
    await _autoInitialize();
    await instance._repository.verbose(message, category: category, tag: tag, metadata: metadata);
  }

  /// Log a debug message. Auto-initializes if needed.
  ///
  /// Debug logs are for development debugging.
  static Future<void> debug(String message, {String? category, String? tag, Map<String, dynamic>? metadata}) async {
    await _autoInitialize();
    await instance._repository.debug(message, category: category, tag: tag, metadata: metadata);
  }

  /// Log an info message. Auto-initializes if needed.
  static Future<void> info(String message, {String? category, String? tag, Map<String, dynamic>? metadata, bool shouldNotify = false}) async {
    await _autoInitialize();
    await instance._repository.info(message, category: category, tag: tag, metadata: metadata);

    if (shouldNotify) {
      VooToast.showInfo(message: message, title: category ?? 'Info');
    }
  }

  /// Log a warning message. Auto-initializes if needed.
  static Future<void> warning(String message, {String? category, String? tag, Map<String, dynamic>? metadata, bool shouldNotify = false}) async {
    await _autoInitialize();
    await instance._repository.warning(message, category: category, tag: tag, metadata: metadata);

    if (shouldNotify) {
      VooToast.showWarning(message: message, title: category ?? 'Warning');
    }
  }

  /// Log an error message. Auto-initializes if needed.
  static Future<void> error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? category,
    String? tag,
    Map<String, dynamic>? metadata,
    bool shouldNotify = false,
  }) async {
    await _autoInitialize();
    await instance._repository.error(message, error: error, stackTrace: stackTrace, category: category, tag: tag, metadata: metadata);

    if (shouldNotify) {
      VooToast.showError(message: message, title: category ?? 'Error');
    }
  }

  /// Log a fatal error message. Auto-initializes if needed.
  static Future<void> fatal(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? category,
    String? tag,
    Map<String, dynamic>? metadata,
    bool shouldNotify = false,
  }) async {
    await _autoInitialize();
    await instance._repository.fatal(message, error: error, stackTrace: stackTrace, category: category, tag: tag, metadata: metadata);

    if (shouldNotify) {
      VooToast.showError(
        message: message,
        title: category ?? 'Fatal Error',
        duration: const Duration(seconds: 10),
      );
    }
  }

  /// Log a message with custom level. Auto-initializes if needed.
  ///
  /// Note: This is synchronous after initialization. For async logging, use
  /// the specific level methods like [info], [error], etc.
  static Future<void> log(String s, {required LogLevel level, String? category, Map<String, Object>? metadata, String? tag}) async {
    await _autoInitialize();
    instance._repository.log(s, level: level, category: category, metadata: metadata ?? const {}, tag: tag);
  }

  /// Log a network request. Auto-initializes if needed.
  static Future<void> networkRequest(String s, String t, {required Map<String, String> headers, required Map<String, String> metadata}) async {
    await _autoInitialize();
    await instance._repository.networkRequest(s, t, headers: headers, metadata: metadata);
  }

  /// Log a user action. Auto-initializes if needed.
  ///
  /// Note: This is synchronous after initialization.
  static Future<void> userAction(String s, {required String screen, required Map<String, Object> properties}) async {
    await _autoInitialize();
    instance._repository.userAction(s, screen: screen, properties: properties);
  }

  Future<List<LogEntry>> getLogs({LogFilter? filter}) async => _repository.getLogs(filter: filter);

  Future<void> clearLogs() async {
    await _repository.clearLogs();
  }

  Future<LogStatistics> getStatistics() async => _repository.getStatistics();
}
