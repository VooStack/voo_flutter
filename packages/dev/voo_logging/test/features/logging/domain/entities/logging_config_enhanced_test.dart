import 'package:flutter_test/flutter_test.dart';
import 'package:voo_logging/voo_logging.dart';

void main() {
  group('LoggingConfig Enhanced Features', () {
    group('logTypeConfigs', () {
      test('should initialize with empty map by default', () {
        const config = LoggingConfig();
        expect(config.logTypeConfigs, isEmpty);
      });

      test('should initialize with custom log type configs', () {
        const config = LoggingConfig(
          logTypeConfigs: {
            LogType.network: LogTypeConfig(enableConsoleOutput: false, enableDevToolsOutput: true),
            LogType.analytics: LogTypeConfig(enableStorage: false),
          },
        );

        expect(config.logTypeConfigs.length, 2);
        expect(config.logTypeConfigs[LogType.network]?.enableConsoleOutput, false);
        expect(config.logTypeConfigs[LogType.analytics]?.enableStorage, false);
      });
    });

    group('getConfigForType', () {
      test('should return specific config when type exists', () {
        const config = LoggingConfig(logTypeConfigs: {LogType.network: LogTypeConfig(enableConsoleOutput: false, minimumLevel: LogLevel.info)});

        final networkConfig = config.getConfigForType(LogType.network);
        expect(networkConfig.enableConsoleOutput, false);
        expect(networkConfig.minimumLevel, LogLevel.info);
      });

      test('should return default config when type not exists', () {
        const config = LoggingConfig();
        final generalConfig = config.getConfigForType(LogType.general);

        expect(generalConfig.enableConsoleOutput, true);
        expect(generalConfig.enableDevToolsOutput, true);
        expect(generalConfig.enableStorage, true);
        expect(generalConfig.minimumLevel, LogLevel.verbose);
      });
    });

    group('getConfigForCategory', () {
      test('should map Network category to LogType.network', () {
        const config = LoggingConfig(logTypeConfigs: {LogType.network: LogTypeConfig(enableConsoleOutput: false)});

        final networkConfig = config.getConfigForCategory('Network');
        expect(networkConfig.enableConsoleOutput, false);
      });

      test('should map Analytics category to LogType.analytics', () {
        const config = LoggingConfig(logTypeConfigs: {LogType.analytics: LogTypeConfig(enableStorage: false)});

        final analyticsConfig = config.getConfigForCategory('Analytics');
        expect(analyticsConfig.enableStorage, false);
      });

      test('should map Performance category to LogType.performance', () {
        const config = LoggingConfig(logTypeConfigs: {LogType.performance: LogTypeConfig(minimumLevel: LogLevel.info)});

        final perfConfig = config.getConfigForCategory('Performance');
        expect(perfConfig.minimumLevel, LogLevel.info);
      });

      test('should map Error category to LogType.error', () {
        const config = LoggingConfig(logTypeConfigs: {LogType.error: LogTypeConfig(minimumLevel: LogLevel.warning)});

        final errorConfig = config.getConfigForCategory('Error');
        expect(errorConfig.minimumLevel, LogLevel.warning);
      });

      test('should map System category to LogType.system', () {
        const config = LoggingConfig(logTypeConfigs: {LogType.system: LogTypeConfig(enableDevToolsOutput: false)});

        final systemConfig = config.getConfigForCategory('System');
        expect(systemConfig.enableDevToolsOutput, false);
      });

      test('should map unknown category to LogType.general', () {
        const config = LoggingConfig();
        final generalConfig = config.getConfigForCategory('UnknownCategory');

        expect(generalConfig.enableConsoleOutput, true);
        expect(generalConfig.minimumLevel, LogLevel.verbose);
      });

      test('should map null category to LogType.general', () {
        const config = LoggingConfig();
        final generalConfig = config.getConfigForCategory(null);

        expect(generalConfig.enableConsoleOutput, true);
        expect(generalConfig.minimumLevel, LogLevel.verbose);
      });

      test('should be case insensitive for category mapping', () {
        const config = LoggingConfig(logTypeConfigs: {LogType.network: LogTypeConfig(enableConsoleOutput: false)});

        final networkConfig1 = config.getConfigForCategory('NETWORK');
        final networkConfig2 = config.getConfigForCategory('network');
        final networkConfig3 = config.getConfigForCategory('Network');

        expect(networkConfig1.enableConsoleOutput, false);
        expect(networkConfig2.enableConsoleOutput, false);
        expect(networkConfig3.enableConsoleOutput, false);
      });
    });

    group('withLogTypeConfig', () {
      test('should add new log type config', () {
        const original = LoggingConfig();
        final updated = original.withLogTypeConfig(LogType.network, const LogTypeConfig(enableConsoleOutput: false));

        expect(updated.logTypeConfigs.length, 1);
        expect(updated.logTypeConfigs[LogType.network]?.enableConsoleOutput, false);
      });

      test('should replace existing log type config', () {
        const original = LoggingConfig(logTypeConfigs: {LogType.network: LogTypeConfig(enableConsoleOutput: false, minimumLevel: LogLevel.info)});

        final updated = original.withLogTypeConfig(LogType.network, const LogTypeConfig(enableConsoleOutput: true, minimumLevel: LogLevel.debug));

        expect(updated.logTypeConfigs.length, 1);
        expect(updated.logTypeConfigs[LogType.network]?.enableConsoleOutput, true);
        expect(updated.logTypeConfigs[LogType.network]?.minimumLevel, LogLevel.debug);
      });

      test('should maintain other configs when adding new one', () {
        const original = LoggingConfig(
          logTypeConfigs: {LogType.network: LogTypeConfig(enableConsoleOutput: false), LogType.analytics: LogTypeConfig(enableStorage: false)},
        );

        final updated = original.withLogTypeConfig(LogType.error, const LogTypeConfig(minimumLevel: LogLevel.warning));

        expect(updated.logTypeConfigs.length, 3);
        expect(updated.logTypeConfigs[LogType.network]?.enableConsoleOutput, false);
        expect(updated.logTypeConfigs[LogType.analytics]?.enableStorage, false);
        expect(updated.logTypeConfigs[LogType.error]?.minimumLevel, LogLevel.warning);
      });
    });

    group('production factory', () {
      test('should create production configuration', () {
        final config = LoggingConfig.production();

        expect(config.minimumLevel, LogLevel.warning);
        expect(config.enablePrettyLogs, false);
        expect(config.showEmojis, false);
        expect(config.logTypeConfigs.length, 3);
      });

      test('should disable network console output in production', () {
        final config = LoggingConfig.production();
        final networkConfig = config.getConfigForType(LogType.network);

        expect(networkConfig.enableConsoleOutput, false);
        expect(networkConfig.enableDevToolsOutput, true);
        expect(networkConfig.minimumLevel, LogLevel.info);
      });

      test('should disable analytics console output in production', () {
        final config = LoggingConfig.production();
        final analyticsConfig = config.getConfigForType(LogType.analytics);

        expect(analyticsConfig.enableConsoleOutput, false);
        expect(analyticsConfig.enableDevToolsOutput, true);
      });

      test('should enable error console output in production', () {
        final config = LoggingConfig.production();
        final errorConfig = config.getConfigForType(LogType.error);

        expect(errorConfig.enableConsoleOutput, true);
        expect(errorConfig.enableDevToolsOutput, true);
        expect(errorConfig.minimumLevel, LogLevel.warning);
      });
    });

    group('development factory', () {
      test('should create development configuration', () {
        final config = LoggingConfig.development();

        expect(config.minimumLevel, LogLevel.verbose);
        expect(config.enablePrettyLogs, true);
        expect(config.showEmojis, true);
        expect(config.logTypeConfigs.length, 3);
      });

      test('should disable network console output in development', () {
        final config = LoggingConfig.development();
        final networkConfig = config.getConfigForType(LogType.network);

        expect(networkConfig.enableConsoleOutput, false);
        expect(networkConfig.enableDevToolsOutput, true);
        expect(networkConfig.minimumLevel, LogLevel.debug);
      });

      test('should disable analytics console output in development', () {
        final config = LoggingConfig.development();
        final analyticsConfig = config.getConfigForType(LogType.analytics);

        expect(analyticsConfig.enableConsoleOutput, false);
        expect(analyticsConfig.enableDevToolsOutput, true);
        expect(analyticsConfig.minimumLevel, LogLevel.info);
      });

      test('should disable performance console output in development', () {
        final config = LoggingConfig.development();
        final perfConfig = config.getConfigForType(LogType.performance);

        expect(perfConfig.enableConsoleOutput, false);
        expect(perfConfig.enableDevToolsOutput, true);
        expect(perfConfig.minimumLevel, LogLevel.info);
      });
    });

    group('copyWith', () {
      test('should copy with new logTypeConfigs', () {
        const original = LoggingConfig(minimumLevel: LogLevel.info, enablePrettyLogs: false);

        final updated = original.copyWith(logTypeConfigs: {LogType.network: const LogTypeConfig(enableConsoleOutput: false)});

        expect(updated.minimumLevel, LogLevel.info);
        expect(updated.enablePrettyLogs, false);
        expect(updated.logTypeConfigs.length, 1);
        expect(updated.logTypeConfigs[LogType.network]?.enableConsoleOutput, false);
      });

      test('should maintain existing logTypeConfigs when not specified', () {
        const original = LoggingConfig(
          logTypeConfigs: {LogType.network: LogTypeConfig(enableConsoleOutput: false), LogType.analytics: LogTypeConfig(enableStorage: false)},
        );

        final updated = original.copyWith(minimumLevel: LogLevel.error);

        expect(updated.minimumLevel, LogLevel.error);
        expect(updated.logTypeConfigs.length, 2);
        expect(updated.logTypeConfigs[LogType.network]?.enableConsoleOutput, false);
        expect(updated.logTypeConfigs[LogType.analytics]?.enableStorage, false);
      });
    });

    group('equality', () {
      test('should be equal with same logTypeConfigs', () {
        const config1 = LoggingConfig(logTypeConfigs: {LogType.network: LogTypeConfig(enableConsoleOutput: false)});
        const config2 = LoggingConfig(logTypeConfigs: {LogType.network: LogTypeConfig(enableConsoleOutput: false)});

        expect(config1, equals(config2));
        expect(config1.hashCode, equals(config2.hashCode));
      });

      test('should not be equal with different logTypeConfigs', () {
        const config1 = LoggingConfig(logTypeConfigs: {LogType.network: LogTypeConfig(enableConsoleOutput: false)});
        const config2 = LoggingConfig(logTypeConfigs: {LogType.network: LogTypeConfig(enableConsoleOutput: true)});

        expect(config1, isNot(equals(config2)));
      });
    });
  });
}
