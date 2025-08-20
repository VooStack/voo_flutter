import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:voo_core/voo_core.dart';
import 'package:voo_performance/voo_performance.dart';

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

  group('VooPerformancePlugin', () {
    setUp(() async {
      // Reset Voo before each test
      Voo.dispose();
      
      // Initialize Voo first
      await Voo.initializeApp(
        options: const VooOptions(
          enableDebugLogging: false,
        ),
      );
    });

    tearDown(() {
      // Clean up after each test
      VooPerformancePlugin.instance.dispose();
      Voo.dispose();
    });

    test('should be singleton', () {
      final instance1 = VooPerformancePlugin.instance;
      final instance2 = VooPerformancePlugin.instance;
      expect(identical(instance1, instance2), true);
    });

    test('should have correct name and version', () {
      final plugin = VooPerformancePlugin.instance;
      expect(plugin.name, 'voo_performance');
      expect(plugin.version, '0.0.1');
    });

    test('should throw error if Voo not initialized', () async {
      Voo.dispose(); // Dispose Voo to test error case
      
      expect(
        () async => await VooPerformancePlugin.instance.initialize(),
        throwsA(isA<VooException>().having(
          (e) => e.code,
          'code',
          'core-not-initialized',
        )),
      );
    });

    test('should initialize successfully', () async {
      await VooPerformancePlugin.instance.initialize(
        enableNetworkMonitoring: true,
        enableTraceMonitoring: true,
        enableAutoAppStartTrace: false, // Disable auto trace for testing
      );

      expect(VooPerformancePlugin.instance.isInitialized, true);
    });

    test('should not initialize twice', () async {
      await VooPerformancePlugin.instance.initialize(
        enableAutoAppStartTrace: false,
      );
      
      // Second initialization should return immediately
      await VooPerformancePlugin.instance.initialize();
      
      expect(VooPerformancePlugin.instance.isInitialized, true);
    });

    test('should create new trace', () async {
      await VooPerformancePlugin.instance.initialize(
        enableAutoAppStartTrace: false,
      );
      
      final trace = VooPerformancePlugin.instance.newTrace('test_operation');
      
      expect(trace, isNotNull);
      expect(trace.name, 'test_operation');
      expect(trace.isRunning, false);
    });

    test('should throw error when creating trace without initialization', () {
      expect(
        () => VooPerformancePlugin.instance.newTrace('test'),
        throwsA(isA<VooException>().having(
          (e) => e.code,
          'code',
          'not-initialized',
        )),
      );
    });

    test('should create HTTP trace', () async {
      await VooPerformancePlugin.instance.initialize(
        enableAutoAppStartTrace: false,
      );
      
      final trace = VooPerformancePlugin.instance.newHttpTrace(
        'https://api.example.com/users',
        'GET',
      );
      
      expect(trace.name, 'http_GET');
      expect(trace.attributes['url'], 'https://api.example.com/users');
      expect(trace.attributes['method'], 'GET');
    });

    test('should record trace', () async {
      await VooPerformancePlugin.instance.initialize(
        enableAutoAppStartTrace: false,
      );
      
      final trace = VooPerformancePlugin.instance.newTrace('test_trace');
      trace.start();
      
      await Future.delayed(const Duration(milliseconds: 100));
      
      trace.stop();
      
      // Trace should be recorded
      expect(trace.duration, isNotNull);
      expect(trace.duration!.inMilliseconds, greaterThanOrEqualTo(100));
    });

    test('should record trace with attributes and metrics', () async {
      await VooPerformancePlugin.instance.initialize(
        enableAutoAppStartTrace: false,
      );
      
      final trace = VooPerformancePlugin.instance.newTrace('complex_trace');
      trace.putAttribute('user_id', '123');
      trace.putAttribute('action', 'purchase');
      trace.putMetric('items', 5);
      trace.putMetric('total', 100);
      
      trace.start();
      await Future.delayed(const Duration(milliseconds: 50));
      trace.stop();
      
      expect(trace.attributes['user_id'], '123');
      expect(trace.attributes['action'], 'purchase');
      expect(trace.metrics['items'], 5);
      expect(trace.metrics['total'], 100);
    });

    test('should record network metric', () async {
      await VooPerformancePlugin.instance.initialize(
        enableAutoAppStartTrace: false,
      );
      
      final metric = NetworkMetric(
        id: 'metric-1',
        url: 'https://api.example.com/data',
        method: 'POST',
        statusCode: 201,
        duration: const Duration(milliseconds: 250),
        requestSize: 1024,
        responseSize: 2048,
        timestamp: DateTime.now(),
        metadata: {
          'cache': 'miss',
        },
      );
      
      await VooPerformancePlugin.instance.recordNetworkMetric(metric);
      
      final metrics = VooPerformancePlugin.instance.getNetworkMetrics();
      expect(metrics, isNotEmpty);
      expect(metrics.last.url, 'https://api.example.com/data');
      expect(metrics.last.statusCode, 201);
    });

    test('should get metrics summary', () async {
      await VooPerformancePlugin.instance.initialize(
        enableAutoAppStartTrace: false,
      );
      
      // Add some network metrics
      for (int i = 0; i < 5; i++) {
        await VooPerformancePlugin.instance.recordNetworkMetric(
          NetworkMetric(
            id: 'metric-$i',
            url: 'https://api.example.com/endpoint$i',
            method: 'GET',
            statusCode: i == 3 ? 404 : 200,
            duration: Duration(milliseconds: 100 * (i + 1)),
            requestSize: 100,
            responseSize: 500,
            timestamp: DateTime.now(),
          ),
        );
      }
      
      final summary = VooPerformancePlugin.instance.getMetricsSummary();
      
      expect(summary['network']['total_requests'], 5);
      expect(summary['network']['average_response_time_ms'], 300); // (100+200+300+400+500)/5
      expect(summary['network']['error_rate'], 0.2); // 1 error out of 5
      expect(summary['traces']['active_traces'], greaterThanOrEqualTo(0));
    });

    test('should filter network metrics by date', () async {
      await VooPerformancePlugin.instance.initialize(
        enableAutoAppStartTrace: false,
      );
      
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final tomorrow = now.add(const Duration(days: 1));
      
      await VooPerformancePlugin.instance.recordNetworkMetric(
        NetworkMetric(
          id: 'old-metric',
          url: 'https://api.example.com/old',
          method: 'GET',
          statusCode: 200,
          duration: const Duration(milliseconds: 100),
          requestSize: 0,
          responseSize: 0,
          timestamp: yesterday,
        ),
      );
      
      await VooPerformancePlugin.instance.recordNetworkMetric(
        NetworkMetric(
          id: 'current-metric',
          url: 'https://api.example.com/current',
          method: 'GET',
          statusCode: 200,
          duration: const Duration(milliseconds: 100),
          requestSize: 0,
          responseSize: 0,
          timestamp: now,
        ),
      );
      
      final filtered = VooPerformancePlugin.instance.getNetworkMetrics(
        startDate: now.subtract(const Duration(hours: 1)),
        endDate: tomorrow,
      );
      
      expect(filtered.length, 1);
      expect(filtered.first.url, 'https://api.example.com/current');
    });

    test('should clear metrics', () async {
      await VooPerformancePlugin.instance.initialize(
        enableAutoAppStartTrace: false,
      );
      
      // Add some metrics
      await VooPerformancePlugin.instance.recordNetworkMetric(
        NetworkMetric(
          id: 'test-metric',
          url: 'test',
          method: 'GET',
          statusCode: 200,
          duration: const Duration(milliseconds: 100),
          requestSize: 0,
          responseSize: 0,
          timestamp: DateTime.now(),
        ),
      );
      
      VooPerformancePlugin.instance.clearMetrics();
      
      final metrics = VooPerformancePlugin.instance.getNetworkMetrics();
      expect(metrics, isEmpty);
    });

    test('should get info', () async {
      await VooPerformancePlugin.instance.initialize(
        enableAutoAppStartTrace: false,
      );
      
      final info = VooPerformancePlugin.instance.getInfo();
      
      expect(info['name'], 'voo_performance');
      expect(info['version'], '0.0.1');
      expect(info['initialized'], true);
      expect(info['metrics'], isNotNull);
      expect(info['metrics']['network'], isNotNull);
      expect(info['metrics']['traces'], isNotNull);
    });

    test('should handle onCoreInitialized', () {
      VooPerformancePlugin.instance.onCoreInitialized();
      // Should not throw
      expect(true, true);
    });

    test('should dispose properly', () async {
      await VooPerformancePlugin.instance.initialize(
        enableAutoAppStartTrace: false,
      );
      expect(VooPerformancePlugin.instance.isInitialized, true);
      
      VooPerformancePlugin.instance.dispose();
      
      expect(VooPerformancePlugin.instance.isInitialized, false);
    });

    test('should auto-create app start trace when enabled', () async {
      await VooPerformancePlugin.instance.initialize(
        enableAutoAppStartTrace: true,
      );
      
      // Wait for auto trace to complete
      await Future.delayed(const Duration(milliseconds: 150));
      
      final summary = VooPerformancePlugin.instance.getMetricsSummary();
      expect(summary['traces']['total_traces'], greaterThan(0));
    });
  });

  group('PerformanceTrace', () {
    test('should create trace with name', () {
      final trace = PerformanceTrace(
        name: 'test_trace',
        startTime: DateTime.now(),
      );
      
      expect(trace.name, 'test_trace');
      expect(trace.id, isNotEmpty);
      expect(trace.startTime, isNotNull);
      expect(trace.isRunning, false);
    });

    test('should start and stop trace', () async {
      final trace = PerformanceTrace(
        name: 'timed_trace',
        startTime: DateTime.now(),
      );
      
      trace.start();
      expect(trace.isRunning, true);
      
      await Future.delayed(const Duration(milliseconds: 100));
      
      trace.stop();
      expect(trace.isRunning, false);
      expect(trace.duration, isNotNull);
      expect(trace.duration!.inMilliseconds, greaterThanOrEqualTo(100));
    });

    test('should add attributes', () {
      final trace = PerformanceTrace(
        name: 'attributed_trace',
        startTime: DateTime.now(),
      );
      
      trace.putAttribute('key1', 'value1');
      trace.putAttribute('key2', 'value2');
      
      expect(trace.attributes['key1'], 'value1');
      expect(trace.attributes['key2'], 'value2');
    });

    test('should add metrics', () {
      final trace = PerformanceTrace(
        name: 'metric_trace',
        startTime: DateTime.now(),
      );
      
      trace.putMetric('count', 42);
      trace.putMetric('score', 99);
      
      expect(trace.metrics['count'], 42);
      expect(trace.metrics['score'], 99);
    });

    test('should call stop callback', () async {
      bool callbackCalled = false;
      
      final trace = PerformanceTrace(
        name: 'callback_trace',
        startTime: DateTime.now(),
      );
      
      trace.setStopCallback((t) async {
        callbackCalled = true;
        expect(t, trace);
      });
      
      trace.start();
      trace.stop();
      
      await Future.delayed(const Duration(milliseconds: 10));
      expect(callbackCalled, true);
    });
  });

  group('NetworkMetric', () {
    test('should create network metric', () {
      final metric = NetworkMetric(
        id: 'net-123',
        url: 'https://api.example.com/users',
        method: 'GET',
        statusCode: 200,
        duration: const Duration(milliseconds: 150),
        requestSize: 256,
        responseSize: 1024,
        timestamp: DateTime(2024, 1, 1),
        metadata: {
          'cache': 'hit',
        },
      );
      
      expect(metric.id, 'net-123');
      expect(metric.url, 'https://api.example.com/users');
      expect(metric.method, 'GET');
      expect(metric.statusCode, 200);
      expect(metric.duration.inMilliseconds, 150);
      expect(metric.requestSize, 256);
      expect(metric.responseSize, 1024);
      expect(metric.timestamp, DateTime(2024, 1, 1));
      expect(metric.metadata?['cache'], 'hit');
      expect(metric.isError, false);
      expect(metric.isSuccess, true);
    });

    test('should convert to map', () {
      final metric = NetworkMetric(
        id: 'net-456',
        url: 'https://api.example.com/data',
        method: 'POST',
        statusCode: 201,
        duration: const Duration(milliseconds: 200),
        requestSize: 512,
        responseSize: 2048,
        timestamp: DateTime(2024, 1, 1, 12, 0, 0),
      );
      
      final map = metric.toMap();
      
      expect(map['id'], 'net-456');
      expect(map['url'], 'https://api.example.com/data');
      expect(map['method'], 'POST');
      expect(map['status_code'], 201);
      expect(map['duration_ms'], 200);
      expect(map['request_size'], 512);
      expect(map['response_size'], 2048);
      expect(map['timestamp'], '2024-01-01T12:00:00.000');
    });

    test('should create from map', () {
      final map = {
        'id': 'net-789',
        'url': 'https://api.example.com/test',
        'method': 'PUT',
        'status_code': 204,
        'duration_ms': 300,
        'request_size': 128,
        'response_size': 0,
        'timestamp': '2024-01-01T12:00:00.000',
        'metadata': {'header': 'value'},
      };
      
      final metric = NetworkMetric.fromMap(map);
      
      expect(metric.id, 'net-789');
      expect(metric.url, 'https://api.example.com/test');
      expect(metric.method, 'PUT');
      expect(metric.statusCode, 204);
      expect(metric.duration.inMilliseconds, 300);
      expect(metric.requestSize, 128);
      expect(metric.responseSize, 0);
      expect(metric.metadata?['header'], 'value');
    });
    
    test('should identify error status codes', () {
      final successMetric = NetworkMetric(
        id: '1',
        url: 'test',
        method: 'GET',
        statusCode: 200,
        duration: const Duration(milliseconds: 100),
        timestamp: DateTime.now(),
      );
      
      final errorMetric = NetworkMetric(
        id: '2',
        url: 'test',
        method: 'GET',
        statusCode: 404,
        duration: const Duration(milliseconds: 100),
        timestamp: DateTime.now(),
      );
      
      expect(successMetric.isSuccess, true);
      expect(successMetric.isError, false);
      expect(errorMetric.isSuccess, false);
      expect(errorMetric.isError, true);
    });
  });
}