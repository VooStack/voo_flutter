import 'package:flutter_test/flutter_test.dart';
import 'package:voo_logging/voo_logging.dart';
import '../../../../test_utils.dart';

void main() {
  group('VooLogger', () {
    setUpAll(() async {
      setUpTestEnvironment();
    });

    setUp(() async {
      await VooLogger.initialize(appName: 'TestApp', config: const LoggingConfig(enablePrettyLogs: false));
    });

    tearDown(() async {
      await VooLogger.instance.clearLogs();
    });

    group('logging methods', () {
      test('verbose logs correctly (no shouldNotify - too low level)', () async {
        await VooLogger.verbose('Test verbose message');

        final logs = await VooLogger.instance.getLogs();
        expect(logs.length, greaterThan(0));
        expect(logs.first.message, 'Test verbose message');
        expect(logs.first.level, LogLevel.verbose);
      });

      test('debug logs correctly (no shouldNotify - too low level)', () async {
        await VooLogger.debug('Test debug message');

        final logs = await VooLogger.instance.getLogs();
        expect(logs.length, greaterThan(0));
        expect(logs.first.message, 'Test debug message');
        expect(logs.first.level, LogLevel.debug);
      });

      test('info accepts shouldNotify parameter', () async {
        await VooLogger.info('Test info message');

        final logs = await VooLogger.instance.getLogs();
        expect(logs.length, greaterThan(0));
        expect(logs.first.message, 'Test info message');
        expect(logs.first.level, LogLevel.info);
      });

      test('warning accepts shouldNotify parameter', () async {
        await VooLogger.warning('Test warning message');

        final logs = await VooLogger.instance.getLogs();
        expect(logs.length, greaterThan(0));
        expect(logs.first.message, 'Test warning message');
        expect(logs.first.level, LogLevel.warning);
      });

      test('error accepts shouldNotify parameter', () async {
        await VooLogger.error('Test error message', error: Exception('Test exception'));

        final logs = await VooLogger.instance.getLogs();
        expect(logs.length, greaterThan(0));
        expect(logs.first.message, 'Test error message');
        expect(logs.first.level, LogLevel.error);
        expect(logs.first.error, isNotNull);
      });

      test('fatal accepts shouldNotify parameter', () async {
        await VooLogger.fatal('Test fatal message', error: Exception('Fatal exception'));

        final logs = await VooLogger.instance.getLogs();
        expect(logs.length, greaterThan(0));
        expect(logs.first.message, 'Test fatal message');
        expect(logs.first.level, LogLevel.fatal);
        expect(logs.first.error, isNotNull);
      });
    });

    group('initialization', () {
      test('should not have shouldNotify in initialize method', () {
        expect(() => VooLogger.initialize(appName: 'TestApp', config: const LoggingConfig()), returnsNormally);
      });

      test('LoggingConfig should not have shouldNotify field', () {
        const config = LoggingConfig();

        expect(config.enablePrettyLogs, isTrue);
        expect(config.showEmojis, isTrue);
        expect(config.showTimestamp, isTrue);
        expect(config.showColors, isTrue);
        expect(config.enabled, isTrue);
      });
    });

    group('logging with metadata', () {
      test('should log with category and tag', () async {
        await VooLogger.info('Test message with metadata', category: 'TestCategory', tag: 'TestTag', metadata: {'key': 'value'});

        final logs = await VooLogger.instance.getLogs();
        expect(logs.length, greaterThan(0));
        expect(logs.first.message, 'Test message with metadata');
        expect(logs.first.category, 'TestCategory');
        expect(logs.first.tag, 'TestTag');
        expect(logs.first.metadata?['key'], 'value');
      });
    });

    group('log stream', () {
      test('should stream logs when created', () async {
        final logs = <LogEntry>[];
        final subscription = VooLogger.instance.stream.listen(logs.add);

        await VooLogger.info('Stream test 1');
        await VooLogger.warning('Stream test 2');

        await Future.delayed(const Duration(milliseconds: 100));

        expect(logs.length, greaterThanOrEqualTo(2));
        expect(logs.any((log) => log.message == 'Stream test 1'), isTrue);
        expect(logs.any((log) => log.message == 'Stream test 2'), isTrue);

        await subscription.cancel();
      });
    });

    group('log filtering', () {
      test('should filter logs by level', () async {
        await VooLogger.verbose('Verbose log');
        await VooLogger.debug('Debug log');
        await VooLogger.info('Info log');
        await VooLogger.warning('Warning log');
        await VooLogger.error('Error log');

        const filter = LogFilter(levels: [LogLevel.warning, LogLevel.error, LogLevel.fatal]);
        final logs = await VooLogger.instance.getLogs(filter: filter);

        expect(logs.every((log) => log.level == LogLevel.warning || log.level == LogLevel.error || log.level == LogLevel.fatal), isTrue);
      });

      test('should filter logs by category', () async {
        await VooLogger.info('Category test 1', category: 'Auth');
        await VooLogger.info('Category test 2', category: 'Network');
        await VooLogger.info('Category test 3', category: 'Auth');

        const filter = LogFilter(categories: ['Auth']);
        final logs = await VooLogger.instance.getLogs(filter: filter);

        expect(logs.every((log) => log.category == 'Auth'), isTrue);
        expect(logs.length, greaterThanOrEqualTo(2));
      });
    });

    group('error handling', () {
      test('should log error with stack trace', () async {
        final error = Exception('Test exception');
        final stackTrace = StackTrace.current;

        await VooLogger.error('Error with stack trace', error: error, stackTrace: stackTrace);

        final logs = await VooLogger.instance.getLogs();
        expect(logs.length, greaterThan(0));
        expect(logs.first.error, isNotNull);
        expect(logs.first.stackTrace, isNotNull);
      });
    });

    group('statistics', () {
      test('should track log statistics', () async {
        await VooLogger.verbose('Verbose');
        await VooLogger.debug('Debug');
        await VooLogger.info('Info');
        await VooLogger.warning('Warning');
        await VooLogger.error('Error');

        final stats = await VooLogger.instance.getStatistics();

        expect(stats.totalLogs, greaterThanOrEqualTo(5));
        expect(stats.levelCounts[LogLevel.verbose.name], greaterThanOrEqualTo(1));
        expect(stats.levelCounts[LogLevel.debug.name], greaterThanOrEqualTo(1));
        expect(stats.levelCounts[LogLevel.info.name], greaterThanOrEqualTo(1));
        expect(stats.levelCounts[LogLevel.warning.name], greaterThanOrEqualTo(1));
        expect(stats.levelCounts[LogLevel.error.name], greaterThanOrEqualTo(1));
      });
    });

    group('clear logs', () {
      test('should clear all logs', () async {
        await VooLogger.info('Log to be cleared');
        await VooLogger.warning('Another log to be cleared');

        var logs = await VooLogger.instance.getLogs();
        expect(logs.length, greaterThan(0));

        await VooLogger.instance.clearLogs();

        logs = await VooLogger.instance.getLogs();
        expect(logs.length, 0);
      });
    });
  });
}
