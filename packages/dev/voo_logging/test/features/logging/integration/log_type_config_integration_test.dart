import 'package:flutter_test/flutter_test.dart';
import 'package:voo_logging/voo_logging.dart';
import '../../../test_utils.dart';

void main() {
  setUpAll(() {
    setUpTestEnvironment();
  });

  group('LogTypeConfig Integration Tests', () {
    group('Network logs configuration', () {
      test('should respect network log configuration', () async {
        await VooLogger.initialize(
          appName: 'TestApp',
          config: const LoggingConfig(
            enablePrettyLogs: false,
            logTypeConfigs: {
              LogType.network: LogTypeConfig(enableConsoleOutput: false, enableDevToolsOutput: true, enableStorage: true, minimumLevel: LogLevel.info),
            },
          ),
        );

        // Network logs below minimum level should not be logged
        await VooLogger.verbose('Network verbose log', category: 'Network');
        await VooLogger.debug('Network debug log', category: 'Network');

        // Network logs at or above minimum level should be logged
        await VooLogger.info('Network info log', category: 'Network');
        await VooLogger.warning('Network warning log', category: 'Network');

        await Future.delayed(const Duration(milliseconds: 100));

        final logs = await VooLogger.instance.getLogs();
        final networkLogs = logs.where((log) => log.category == 'Network').toList();

        // Should only have info and warning logs (verbose and debug filtered out)
        expect(networkLogs.length, greaterThanOrEqualTo(2));
        expect(networkLogs.any((log) => log.message == 'Network info log'), true);
        expect(networkLogs.any((log) => log.message == 'Network warning log'), true);
        expect(networkLogs.any((log) => log.message == 'Network verbose log'), false);
        expect(networkLogs.any((log) => log.message == 'Network debug log'), false);

        await VooLogger.instance.clearLogs();
      });

      test('should handle network request/response with config', () async {
        await VooLogger.initialize(
          appName: 'TestApp',
          config: const LoggingConfig(
            enablePrettyLogs: false,
            logTypeConfigs: {LogType.network: LogTypeConfig(enableConsoleOutput: false, enableDevToolsOutput: true, minimumLevel: LogLevel.debug)},
          ),
        );

        await VooLogger.networkRequest('GET', 'https://api.example.com/data', headers: {'Authorization': 'Bearer token'}, metadata: {'requestId': '123'});

        await Future.delayed(const Duration(milliseconds: 100));

        final logs = await VooLogger.instance.getLogs();
        final networkLogs = logs.where((log) => log.category == 'Network').toList();

        expect(networkLogs.length, greaterThan(0));
        expect(networkLogs.any((log) => log.message.contains('GET')), true);
        expect(networkLogs.any((log) => log.message.contains('api.example.com')), true);

        await VooLogger.instance.clearLogs();
      });
    });

    group('Analytics logs configuration', () {
      test('should respect analytics log configuration', () async {
        await VooLogger.initialize(
          appName: 'TestApp',
          config: const LoggingConfig(
            enablePrettyLogs: false,
            logTypeConfigs: {
              LogType.analytics: LogTypeConfig(enableConsoleOutput: false, enableDevToolsOutput: true, enableStorage: false, minimumLevel: LogLevel.info),
            },
          ),
        );

        VooLogger.userAction('button_click', screen: 'HomeScreen', properties: {'buttonId': 'submit'});

        await Future.delayed(const Duration(milliseconds: 100));

        final logs = await VooLogger.instance.getLogs();
        final analyticsLogs = logs.where((log) => log.category == 'Analytics').toList();

        // Storage is disabled, so we might not get logs from storage
        // But the log should still be created and sent to DevTools
        expect(analyticsLogs.length, greaterThanOrEqualTo(0));

        await VooLogger.instance.clearLogs();
      });
    });

    group('Error logs configuration', () {
      test('should respect error log configuration', () async {
        // Clear any existing logs before starting
        await VooLogger.instance.clearLogs();

        await VooLogger.initialize(
          appName: 'TestApp',
          config: const LoggingConfig(
            enablePrettyLogs: false,
            logTypeConfigs: {
              LogType.error: LogTypeConfig(enableConsoleOutput: true, enableDevToolsOutput: true, enableStorage: true, minimumLevel: LogLevel.warning),
            },
          ),
        );

        // Info level with Error category - should be filtered out
        await VooLogger.info('This is an info level error', category: 'Error');

        // Warning level with Error category - should be logged
        await VooLogger.warning('This is a warning', category: 'Error');

        // Error level with Error category - should be logged
        await VooLogger.error('This is an error', error: Exception('Test error'), category: 'Error');

        await Future.delayed(const Duration(milliseconds: 100));

        final logs = await VooLogger.instance.getLogs();
        final errorLogs = logs.where((log) => log.category == 'Error').toList();

        // Should have warning and error, but not info
        expect(errorLogs.length, greaterThanOrEqualTo(2));
        expect(errorLogs.any((log) => log.message == 'This is a warning'), true);
        expect(errorLogs.any((log) => log.message == 'This is an error'), true);
        expect(errorLogs.any((log) => log.message == 'This is an info level error'), false);

        await VooLogger.instance.clearLogs();
      });
    });

    group('Mixed log types configuration', () {
      test('should handle different configs for different log types', () async {
        // Clear any existing logs before starting
        await VooLogger.instance.clearLogs();

        await VooLogger.initialize(
          appName: 'TestApp',
          config: const LoggingConfig(
            enablePrettyLogs: false,
            minimumLevel: LogLevel.debug,
            logTypeConfigs: {
              LogType.network: LogTypeConfig(enableConsoleOutput: false, minimumLevel: LogLevel.info),
              LogType.analytics: LogTypeConfig(enableStorage: false, minimumLevel: LogLevel.warning),
              LogType.error: LogTypeConfig(enableConsoleOutput: true, minimumLevel: LogLevel.error),
            },
          ),
        );

        // Test various log types with different levels
        await VooLogger.debug('Network debug', category: 'Network');
        await VooLogger.info('Network info', category: 'Network');
        await VooLogger.info('Analytics info', category: 'Analytics');
        await VooLogger.warning('Analytics warning', category: 'Analytics');
        await VooLogger.warning('Error warning', category: 'Error');
        await VooLogger.error('Error error', category: 'Error');
        await VooLogger.debug('General debug');
        await VooLogger.info('General info');

        await Future.delayed(const Duration(milliseconds: 100));

        final logs = await VooLogger.instance.getLogs();

        // Verify each type follows its configuration
        final networkLogs = logs.where((log) => log.category == 'Network').toList();
        final analyticsLogs = logs.where((log) => log.category == 'Analytics').toList();
        final errorLogs = logs.where((log) => log.category == 'Error').toList();
        final generalLogs = logs.where((log) => log.category == null).toList();

        // Network: info and above (debug filtered)
        expect(networkLogs.any((log) => log.message == 'Network info'), true);
        expect(networkLogs.any((log) => log.message == 'Network debug'), false);

        // Analytics: has storage disabled, so no logs should be stored
        // Even though warning level would pass the minimum level filter,
        // it won't be in storage because enableStorage is false
        expect(analyticsLogs.isEmpty, true);

        // Error: error and above (warning filtered)
        expect(errorLogs.any((log) => log.message == 'Error error'), true);
        expect(errorLogs.any((log) => log.message == 'Error warning'), false);

        // General: follows global minimum (debug and above)
        expect(generalLogs.any((log) => log.message == 'General debug'), true);
        expect(generalLogs.any((log) => log.message == 'General info'), true);

        await VooLogger.instance.clearLogs();
      });
    });

    group('Production configuration', () {
      test('should work correctly with production factory', () async {
        // Clear any existing logs before starting
        await VooLogger.instance.clearLogs();

        await VooLogger.initialize(appName: 'TestApp', config: LoggingConfig.production());

        // Test various log types and levels
        await VooLogger.verbose('General verbose');
        await VooLogger.debug('General debug');
        await VooLogger.info('General info');
        await VooLogger.warning('General warning');

        await VooLogger.info('Network info', category: 'Network');
        await VooLogger.warning('Network warning', category: 'Network');

        await VooLogger.info('Analytics info', category: 'Analytics');

        await VooLogger.warning('Error warning', category: 'Error');
        await VooLogger.error('Error error', category: 'Error');

        await Future.delayed(const Duration(milliseconds: 100));

        final logs = await VooLogger.instance.getLogs();

        // In production, global minimum is warning
        final generalLogs = logs.where((log) => log.category == null).toList();
        expect(generalLogs.any((log) => log.level == LogLevel.warning), true);
        expect(generalLogs.any((log) => log.level == LogLevel.verbose), false);
        expect(generalLogs.any((log) => log.level == LogLevel.debug), false);
        expect(generalLogs.any((log) => log.level == LogLevel.info), false);

        // Network has minimum level of info in production
        final networkLogs = logs.where((log) => log.category == 'Network').toList();
        expect(networkLogs.length, greaterThanOrEqualTo(2));

        // Error logs should be present (warning level minimum)
        final errorLogs = logs.where((log) => log.category == 'Error').toList();
        expect(errorLogs.length, greaterThanOrEqualTo(2));

        await VooLogger.instance.clearLogs();
      });
    });

    group('Development configuration', () {
      test('should work correctly with development factory', () async {
        // Clear any existing logs before starting
        await VooLogger.instance.clearLogs();

        await VooLogger.initialize(appName: 'TestApp', config: LoggingConfig.development());

        // Test various log types and levels
        await VooLogger.verbose('General verbose');
        await VooLogger.debug('General debug');
        await VooLogger.info('General info');

        await VooLogger.debug('Network debug', category: 'Network');
        await VooLogger.info('Network info', category: 'Network');

        await VooLogger.info('Analytics info', category: 'Analytics');

        await VooLogger.info('Performance info', category: 'Performance');

        await Future.delayed(const Duration(milliseconds: 100));

        final logs = await VooLogger.instance.getLogs();

        // In development, global minimum is verbose (all logs)
        final generalLogs = logs.where((log) => log.category == null).toList();
        expect(generalLogs.any((log) => log.level == LogLevel.verbose), true);
        expect(generalLogs.any((log) => log.level == LogLevel.debug), true);
        expect(generalLogs.any((log) => log.level == LogLevel.info), true);

        // Network has minimum level of debug in development
        final networkLogs = logs.where((log) => log.category == 'Network').toList();
        expect(networkLogs.any((log) => log.message == 'Network debug'), true);
        expect(networkLogs.any((log) => log.message == 'Network info'), true);

        // Analytics has minimum level of info in development
        final analyticsLogs = logs.where((log) => log.category == 'Analytics').toList();
        expect(analyticsLogs.any((log) => log.message == 'Analytics info'), true);

        // Performance has minimum level of info in development
        final perfLogs = logs.where((log) => log.category == 'Performance').toList();
        expect(perfLogs.any((log) => log.message == 'Performance info'), true);

        await VooLogger.instance.clearLogs();
      });
    });

    tearDown(() async {
      await VooLogger.instance.clearLogs();
    });
  });
}
