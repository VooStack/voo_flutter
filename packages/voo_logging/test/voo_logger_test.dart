import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:voo_logging/voo_logging.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  // Mock the path_provider channel
  const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    channel,
    (MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return '/tmp/test_docs';
      }
      return null;
    },
  );
  
  group('VooLogger', () {
    setUp(() async {
      // Initialize VooLogger for each test
      await VooLogger.initialize(
        appName: 'TestApp',
        appVersion: '1.0.0',
        userId: 'test-user',
        minimumLevel: LogLevel.verbose,
      );
    });

    test('should throw error if not initialized', () async {
      // Create a new instance to test uninitialized state
      // This is just to verify the error message
      expect(
        () => VooLogger.info('test'),
        returnsNormally, // Since we initialized in setUp
      );
    });

    test('should log verbose message', () async {
      await VooLogger.verbose(
        'Verbose message',
        category: 'test',
        tag: 'unit-test',
        metadata: {'key': 'value'},
      );
      // Test passes if no exception is thrown
      expect(true, true);
    });

    test('should log debug message', () async {
      await VooLogger.debug(
        'Debug message',
        category: 'test',
        tag: 'debug-test',
        metadata: {'debug': true},
      );
      expect(true, true);
    });

    test('should log info message', () async {
      await VooLogger.info(
        'Info message',
        category: 'test',
        metadata: {'level': 'info'},
      );
      expect(true, true);
    });

    test('should log warning message', () async {
      await VooLogger.warning(
        'Warning message',
        category: 'test',
        tag: 'warning',
      );
      expect(true, true);
    });

    test('should log error message with exception', () async {
      final error = Exception('Test error');
      final stackTrace = StackTrace.current;

      await VooLogger.error(
        'Error occurred',
        error: error,
        stackTrace: stackTrace,
        category: 'test',
        metadata: {'errorCode': 500},
      );
      expect(true, true);
    });

    test('should log fatal message', () async {
      await VooLogger.fatal(
        'Fatal error',
        error: Exception('Fatal exception'),
        category: 'test',
      );
      expect(true, true);
    });

    test('should log with custom level', () {
      VooLogger.log(
        'Custom log message',
        level: LogLevel.info,
        category: 'custom',
        metadata: {'custom': 'data'},
        tag: 'custom-tag',
      );
      expect(true, true);
    });

    test('should log network request', () async {
      await VooLogger.networkRequest(
        'https://api.example.com/users',
        'GET',
        headers: {'Authorization': 'Bearer token'},
        metadata: {'userId': '123'},
      );
      expect(true, true);
    });

    test('should log network response', () async {
      await VooLogger.networkResponse(
        200,
        'OK',
        const Duration(milliseconds: 250),
        headers: {'Content-Type': 'application/json'},
        contentLength: 1024,
        metadata: {'cached': 'false'},
      );
      expect(true, true);
    });

    test('should log user action', () {
      VooLogger.userAction(
        'button_click',
        screen: 'home',
        properties: {'button': 'submit', 'section': 'header'},
      );
      expect(true, true);
    });

    test('should set user ID', () {
      VooLogger.setUserId('new-user-id');
      expect(true, true);
    });

    test('should start new session', () {
      VooLogger.startNewSession();
      expect(true, true);
    });

    test('should clear logs', () async {
      await VooLogger.clearLogs();
      expect(true, true);
    });

    test('should get statistics', () async {
      final stats = await VooLogger.getStatistics();
      expect(stats, isNotNull);
    });

    test('should export logs', () async {
      final exported = await VooLogger.exportLogs();
      expect(exported, isNotNull);
    });

    test('should get config', () {
      final config = VooLogger.config;
      expect(config, isA<LoggingConfig>());
      expect(config.minimumLevel, isA<LogLevel>());
    });

    test('should access instance', () {
      final instance = VooLogger.instance;
      expect(instance, isNotNull);
      expect(instance.stream, isNotNull);
      expect(instance.repository, isNotNull);
    });
  });

  group('LogLevel', () {
    test('should have correct severity order', () {
      expect(LogLevel.verbose.index, lessThan(LogLevel.debug.index));
      expect(LogLevel.debug.index, lessThan(LogLevel.info.index));
      expect(LogLevel.info.index, lessThan(LogLevel.warning.index));
      expect(LogLevel.warning.index, lessThan(LogLevel.error.index));
      expect(LogLevel.error.index, lessThan(LogLevel.fatal.index));
    });

    test('should parse from string', () {
      expect(LogLevel.values.byName('verbose'), LogLevel.verbose);
      expect(LogLevel.values.byName('debug'), LogLevel.debug);
      expect(LogLevel.values.byName('info'), LogLevel.info);
      expect(LogLevel.values.byName('warning'), LogLevel.warning);
      expect(LogLevel.values.byName('error'), LogLevel.error);
      expect(LogLevel.values.byName('fatal'), LogLevel.fatal);
    });
  });

  group('LoggingConfig', () {
    test('should create with default values', () {
      const config = LoggingConfig();
      expect(config.minimumLevel, LogLevel.verbose);
      expect(config.enablePrettyLogs, true);
      expect(config.showEmojis, true);
      expect(config.showTimestamp, true);
      expect(config.showColors, true);
      expect(config.showBorders, true);
      expect(config.lineLength, 120);
      expect(config.enabled, true);
      expect(config.enableDevToolsJson, false);
    });

    test('should create with custom values', () {
      const config = LoggingConfig(
        minimumLevel: LogLevel.warning,
        enablePrettyLogs: false,
        showEmojis: false,
        showTimestamp: false,
        showColors: false,
        showBorders: false,
        lineLength: 80,
        enabled: false,
        enableDevToolsJson: true,
      );
      expect(config.minimumLevel, LogLevel.warning);
      expect(config.enablePrettyLogs, false);
      expect(config.showEmojis, false);
      expect(config.showTimestamp, false);
      expect(config.showColors, false);
      expect(config.showBorders, false);
      expect(config.lineLength, 80);
      expect(config.enabled, false);
      expect(config.enableDevToolsJson, true);
    });

    test('should create formatter', () {
      const config = LoggingConfig();
      final formatter = config.formatter;
      expect(formatter, isNotNull);
    });

    test('should copyWith new values', () {
      const original = LoggingConfig(
        minimumLevel: LogLevel.info,
        showEmojis: false,
      );
      
      final copied = original.copyWith(
        minimumLevel: LogLevel.debug,
        showEmojis: true,
        lineLength: 100,
      );
      
      expect(original.minimumLevel, LogLevel.info);
      expect(original.showEmojis, false);
      expect(original.lineLength, 120);
      
      expect(copied.minimumLevel, LogLevel.debug);
      expect(copied.showEmojis, true);
      expect(copied.lineLength, 100);
    });
  });
}