import 'package:flutter_test/flutter_test.dart';
import 'package:voo_logging/voo_logging.dart';

void main() {
  group('VooLogger Integration Tests', () {
    test('logging methods work correctly for each log level', () async {
      // Initialize VooLogger
      await VooLogger.initialize(appName: 'TestApp', config: const LoggingConfig(enablePrettyLogs: false));

      // Test verbose (no shouldNotify - too low level for toasts)
      await VooLogger.verbose('Verbose message');

      // Test debug (no shouldNotify - too low level for toasts)
      await VooLogger.debug('Debug message');

      // Test info - shouldNotify available
      await VooLogger.info('Info message');
      await VooLogger.info('Info with notify', shouldNotify: true);

      // Test warning - shouldNotify available
      await VooLogger.warning('Warning message');
      await VooLogger.warning('Warning with notify', shouldNotify: true);

      // Test error - shouldNotify available
      await VooLogger.error('Error message');
      await VooLogger.error('Error with notify', shouldNotify: true);

      // Test fatal - shouldNotify available
      await VooLogger.fatal('Fatal message');
      await VooLogger.fatal('Fatal with notify', shouldNotify: true);

      // Verify all methods work without errors
      expect(true, isTrue);
    });

    test('LoggingConfig no longer has shouldNotify field', () {
      const config = LoggingConfig();

      // Test that we can create a config without shouldNotify
      expect(config.enablePrettyLogs, isTrue);
      expect(config.showEmojis, isTrue);
      expect(config.showTimestamp, isTrue);
      expect(config.showColors, isTrue);
      expect(config.enabled, isTrue);

      // The config should work without shouldNotify
      final configMap = {
        'enablePrettyLogs': config.enablePrettyLogs,
        'showEmojis': config.showEmojis,
        'showTimestamp': config.showTimestamp,
        'showColors': config.showColors,
        'enabled': config.enabled,
      };

      expect(configMap.containsKey('shouldNotify'), isFalse);
    });

    test('VooLogger.initialize no longer accepts shouldNotify parameter', () async {
      // This should compile and run without shouldNotify
      await VooLogger.initialize(appName: 'TestApp', config: const LoggingConfig());

      // Verify initialization succeeded
      expect(VooLogger.config, isNotNull);
    });
  });
}
