import 'package:flutter_test/flutter_test.dart';
import 'package:voo_logging/voo_logging.dart';

void main() {
  group('LogTypeConfig', () {
    group('initialization', () {
      test('should create with default values', () {
        const config = LogTypeConfig();

        expect(config.enableConsoleOutput, true);
        expect(config.enableDevToolsOutput, true);
        expect(config.enableStorage, true);
        expect(config.minimumLevel, LogLevel.verbose);
      });

      test('should create with custom values', () {
        const config = LogTypeConfig(enableConsoleOutput: false, enableDevToolsOutput: false, enableStorage: false, minimumLevel: LogLevel.error);

        expect(config.enableConsoleOutput, false);
        expect(config.enableDevToolsOutput, false);
        expect(config.enableStorage, false);
        expect(config.minimumLevel, LogLevel.error);
      });
    });

    group('copyWith', () {
      test('should copy with new values', () {
        const original = LogTypeConfig();
        final copied = original.copyWith(enableConsoleOutput: false, minimumLevel: LogLevel.warning);

        expect(copied.enableConsoleOutput, false);
        expect(copied.enableDevToolsOutput, true);
        expect(copied.enableStorage, true);
        expect(copied.minimumLevel, LogLevel.warning);
      });

      test('should maintain original values when not specified', () {
        const original = LogTypeConfig(enableConsoleOutput: false, enableDevToolsOutput: false, enableStorage: false, minimumLevel: LogLevel.fatal);
        final copied = original.copyWith();

        expect(copied.enableConsoleOutput, false);
        expect(copied.enableDevToolsOutput, false);
        expect(copied.enableStorage, false);
        expect(copied.minimumLevel, LogLevel.fatal);
      });
    });

    group('equality', () {
      test('should be equal when all properties match', () {
        const config1 = LogTypeConfig(enableConsoleOutput: false, enableDevToolsOutput: true, enableStorage: false, minimumLevel: LogLevel.info);
        const config2 = LogTypeConfig(enableConsoleOutput: false, enableDevToolsOutput: true, enableStorage: false, minimumLevel: LogLevel.info);

        expect(config1, equals(config2));
        expect(config1.hashCode, equals(config2.hashCode));
      });

      test('should not be equal when any property differs', () {
        const config1 = LogTypeConfig();
        const config2 = LogTypeConfig(enableConsoleOutput: false);

        expect(config1, isNot(equals(config2)));
      });
    });

    group('use cases', () {
      test('should disable console output for network logs', () {
        const networkConfig = LogTypeConfig(enableConsoleOutput: false, enableDevToolsOutput: true, minimumLevel: LogLevel.info);

        expect(networkConfig.enableConsoleOutput, false);
        expect(networkConfig.enableDevToolsOutput, true);
      });

      test('should enable all outputs for error logs', () {
        const errorConfig = LogTypeConfig(enableConsoleOutput: true, enableDevToolsOutput: true, enableStorage: true, minimumLevel: LogLevel.warning);

        expect(errorConfig.enableConsoleOutput, true);
        expect(errorConfig.enableDevToolsOutput, true);
        expect(errorConfig.enableStorage, true);
      });

      test('should disable storage for analytics logs', () {
        const analyticsConfig = LogTypeConfig(enableStorage: false);

        expect(analyticsConfig.enableStorage, false);
        expect(analyticsConfig.enableConsoleOutput, true);
        expect(analyticsConfig.enableDevToolsOutput, true);
      });
    });
  });

  group('LogType enum', () {
    test('should have all expected types', () {
      expect(LogType.values, contains(LogType.general));
      expect(LogType.values, contains(LogType.network));
      expect(LogType.values, contains(LogType.analytics));
      expect(LogType.values, contains(LogType.performance));
      expect(LogType.values, contains(LogType.error));
      expect(LogType.values, contains(LogType.system));
    });

    test('should have correct count of types', () {
      expect(LogType.values.length, 6);
    });
  });
}
