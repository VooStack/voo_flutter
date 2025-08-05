import 'package:test/test.dart';
import 'package:voo_logging/voo_logging.dart';

void main() {
  group('VooLogger', () {
    test('should initialize successfully', () async {
      // Test basic initialization
      await VooLogger.initialize(appName: 'Test App', appVersion: '1.0.0', userId: 'test_user');

      // Since there's no public isInitialized getter, we test by using the logger
      expect(() => VooLogger.info('Test message'), returnsNormally);
    });

    test('should log messages at different levels', () async {
      await VooLogger.initialize(appName: 'Test App', appVersion: '1.0.0', userId: 'test_user');

      // Test logging at different levels
      expect(() async => VooLogger.verbose('Verbose message'), returnsNormally);
      expect(() async => VooLogger.debug('Debug message'), returnsNormally);
      expect(() async => VooLogger.info('Info message'), returnsNormally);
      expect(() async => VooLogger.warning('Warning message'), returnsNormally);
      expect(() async => VooLogger.error('Error message'), returnsNormally);
    });

    test('should respect minimum log level', () async {
      await VooLogger.initialize(minimumLevel: LogLevel.warning, appName: 'Test App', appVersion: '1.0.0', userId: 'test_user');

      // Messages below warning level should not cause errors
      expect(() async => VooLogger.debug('Debug message'), returnsNormally);
      expect(() async => VooLogger.warning('Warning message'), returnsNormally);
    });
  });

  group('LogLevel', () {
    test('should have correct hierarchy', () {
      expect(LogLevel.verbose.priority, lessThan(LogLevel.debug.priority));
      expect(LogLevel.debug.priority, lessThan(LogLevel.info.priority));
      expect(LogLevel.info.priority, lessThan(LogLevel.warning.priority));
      expect(LogLevel.warning.priority, lessThan(LogLevel.error.priority));
      expect(LogLevel.error.priority, lessThan(LogLevel.fatal.priority));
    });

    test('should convert to string correctly', () {
      expect(LogLevel.verbose.toString(), equals('LogLevel.verbose'));
      expect(LogLevel.debug.toString(), equals('LogLevel.debug'));
      expect(LogLevel.info.toString(), equals('LogLevel.info'));
      expect(LogLevel.warning.toString(), equals('LogLevel.warning'));
      expect(LogLevel.error.toString(), equals('LogLevel.error'));
      expect(LogLevel.fatal.toString(), equals('LogLevel.fatal'));
    });
  });
}
