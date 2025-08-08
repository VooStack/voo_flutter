import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_core/voo_core.dart';
import 'package:voo_performance/voo_performance.dart';
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
  
  group('VooPerformance Tests', () {
    setUp(() async {
      await Voo.initializeApp();
      // Initialize VooLogger since performance uses it
      await VooLogger.initialize();
    });

    test('should initialize VooPerformance', () async {
      await VooPerformancePlugin.instance.initialize();
      expect(VooPerformancePlugin.instance.isInitialized, true);
    });

    test('should create and track performance traces', () async {
      await VooPerformancePlugin.instance.initialize();
      
      final trace = VooPerformancePlugin.instance.newTrace('test_trace');
      trace.start();
      trace.putAttribute('test_key', 'test_value');
      trace.putMetric('test_metric', 100);
      trace.stop();
      
      expect(trace.isRunning, false);
    });

    test('should track HTTP traces', () async {
      await VooPerformancePlugin.instance.initialize();
      
      final trace = VooPerformancePlugin.instance.newHttpTrace(
        'https://example.com/api',
        'GET',
      );
      trace.start();
      trace.stop();
      
      expect(trace.attributes['url'], 'https://example.com/api');
      expect(trace.attributes['method'], 'GET');
    });

    tearDown(() {
      Voo.dispose();
    });
  });
}