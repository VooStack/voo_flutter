import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_core/voo_core.dart';
import 'package:voo_analytics/voo_analytics.dart';
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
  
  group('VooAnalytics Tests', () {
    setUp(() async {
      await Voo.initializeApp();
      // Initialize VooLogger since analytics uses it
      await VooLogger.initialize();
    });

    test('should initialize VooAnalytics', () async {
      await VooAnalyticsPlugin.instance.initialize();
      expect(VooAnalyticsPlugin.instance.isInitialized, true);
    });

    test('should log events', () async {
      await VooAnalyticsPlugin.instance.initialize();
      
      await VooAnalyticsPlugin.instance.logEvent(
        'test_event',
        parameters: {'test_param': 'value'},
      );
      
      // Event should be logged without throwing
      expect(VooAnalyticsPlugin.instance.isInitialized, true);
    });

    tearDown(() {
      Voo.dispose();
    });
  });
}