import 'package:flutter_test/flutter_test.dart';
import 'package:voo_core/voo_core.dart';
import 'package:voo_performance/voo_performance.dart';

void main() {
  group('VooPerformance Tests', () {
    setUp(() async {
      await Voo.initializeApp();
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