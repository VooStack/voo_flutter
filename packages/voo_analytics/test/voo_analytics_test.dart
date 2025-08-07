import 'package:flutter_test/flutter_test.dart';
import 'package:voo_core/voo_core.dart';
import 'package:voo_analytics/voo_analytics.dart';

void main() {
  group('VooAnalytics Tests', () {
    setUp(() async {
      await Voo.initializeApp();
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