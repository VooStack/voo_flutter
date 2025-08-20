import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:voo_core/voo_core.dart';
import 'package:voo_logging/voo_logging.dart';
import 'package:voo_analytics/voo_analytics.dart';

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

  group('VooAnalyticsPlugin', () {
    setUp(() async {
      // Reset Voo before each test
      Voo.dispose();
      
      // Initialize Voo first
      await Voo.initializeApp(
        options: const VooOptions(
          enableDebugLogging: false,
        ),
      );
      
      // Initialize VooLogger which is required by VooAnalytics
      await VooLogger.initialize(
        appName: 'TestApp',
        appVersion: '1.0.0',
      );
    });

    tearDown(() {
      // Clean up after each test
      VooAnalyticsPlugin.instance.dispose();
      Voo.dispose();
    });

    test('should be singleton', () {
      final instance1 = VooAnalyticsPlugin.instance;
      final instance2 = VooAnalyticsPlugin.instance;
      expect(identical(instance1, instance2), true);
    });

    test('should have correct name and version', () {
      final plugin = VooAnalyticsPlugin.instance;
      expect(plugin.name, 'voo_analytics');
      expect(plugin.version, '0.0.1');
    });

    test('should throw error if Voo not initialized', () async {
      Voo.dispose(); // Dispose Voo to test error case
      
      expect(
        () async => await VooAnalyticsPlugin.instance.initialize(),
        throwsA(isA<VooException>().having(
          (e) => e.code,
          'code',
          'core-not-initialized',
        )),
      );
    });

    test('should initialize successfully', () async {
      await VooAnalyticsPlugin.instance.initialize(
        enableTouchTracking: true,
        enableEventLogging: true,
        enableUserProperties: true,
      );

      expect(VooAnalyticsPlugin.instance.isInitialized, true);
      expect(VooAnalyticsPlugin.instance.repository, isNotNull);
    });

    test('should not initialize twice', () async {
      await VooAnalyticsPlugin.instance.initialize();
      
      // Second initialization should return immediately
      await VooAnalyticsPlugin.instance.initialize();
      
      expect(VooAnalyticsPlugin.instance.isInitialized, true);
    });

    test('should log event', () async {
      await VooAnalyticsPlugin.instance.initialize();
      
      await VooAnalyticsPlugin.instance.logEvent(
        'test_event',
        parameters: {
          'key': 'value',
          'count': 42,
        },
      );
      
      // Test passes if no exception is thrown
      expect(true, true);
    });

    test('should throw error when logging event without initialization', () {
      expect(
        () async => await VooAnalyticsPlugin.instance.logEvent('test'),
        throwsA(isA<VooException>().having(
          (e) => e.code,
          'code',
          'not-initialized',
        )),
      );
    });

    test('should set user property', () async {
      await VooAnalyticsPlugin.instance.initialize();
      
      await VooAnalyticsPlugin.instance.setUserProperty(
        'subscription',
        'premium',
      );
      
      expect(true, true);
    });

    test('should set user ID', () async {
      await VooAnalyticsPlugin.instance.initialize();
      
      await VooAnalyticsPlugin.instance.setUserId('user-123');
      
      expect(true, true);
    });

    test('should get heat map data', () async {
      await VooAnalyticsPlugin.instance.initialize();
      
      final data = await VooAnalyticsPlugin.instance.getHeatMapData(
        startDate: DateTime.now().subtract(const Duration(days: 7)),
        endDate: DateTime.now(),
      );
      
      expect(data, isA<Map<String, dynamic>>());
    });

    test('should clear data', () async {
      await VooAnalyticsPlugin.instance.initialize();
      
      await VooAnalyticsPlugin.instance.clearData();
      
      expect(true, true);
    });

    test('should get route observer', () {
      final observer = VooAnalyticsPlugin.instance.routeObserver;
      expect(observer, isNotNull);
      expect(observer, isA<AnalyticsRouteObserver>());
      
      // Should return same instance
      final observer2 = VooAnalyticsPlugin.instance.routeObserver;
      expect(identical(observer, observer2), true);
    });

    test('should get info', () async {
      await VooAnalyticsPlugin.instance.initialize(
        enableTouchTracking: true,
        enableEventLogging: false,
        enableUserProperties: true,
      );
      
      final info = VooAnalyticsPlugin.instance.getInfo();
      
      expect(info['name'], 'voo_analytics');
      expect(info['version'], '0.0.1');
      expect(info['initialized'], true);
      expect(info['features']['touchTracking'], true);
      expect(info['features']['eventLogging'], false);
      expect(info['features']['userProperties'], true);
    });

    test('should handle onCoreInitialized', () {
      VooAnalyticsPlugin.instance.onCoreInitialized();
      // Should not throw
      expect(true, true);
    });

    test('should dispose properly', () async {
      await VooAnalyticsPlugin.instance.initialize();
      expect(VooAnalyticsPlugin.instance.isInitialized, true);
      
      VooAnalyticsPlugin.instance.dispose();
      
      expect(VooAnalyticsPlugin.instance.isInitialized, false);
      expect(VooAnalyticsPlugin.instance.repository, isNull);
    });
  });

  group('TouchEvent', () {
    test('should create touch event', () {
      final event = TouchEvent(
        id: 'test-123',
        position: const Offset(100.5, 200.5),
        timestamp: DateTime(2024, 1, 1),
        type: TouchType.tap,
        screenName: 'home',
        metadata: {'action': 'click'},
      );

      expect(event.id, 'test-123');
      expect(event.position.dx, 100.5);
      expect(event.position.dy, 200.5);
      expect(event.timestamp, DateTime(2024, 1, 1));
      expect(event.type, TouchType.tap);
      expect(event.screenName, 'home');
      expect(event.metadata?['action'], 'click');
    });

    test('should convert to map', () {
      final event = TouchEvent(
        id: 'test-456',
        position: const Offset(50, 100),
        timestamp: DateTime(2024, 1, 1, 12, 0, 0),
        type: TouchType.longPress,
        screenName: 'settings',
        widgetType: 'button',
        widgetKey: 'save-btn',
      );

      final map = event.toMap();

      expect(map['id'], 'test-456');
      expect(map['x'], 50);
      expect(map['y'], 100);
      expect(map['type'], 'longPress');
      expect(map['screen_name'], 'settings');
      expect(map['widget_type'], 'button');
      expect(map['widget_key'], 'save-btn');
      expect(map['timestamp'], '2024-01-01T12:00:00.000');
    });

    test('should create from map', () {
      final map = {
        'id': 'test-789',
        'x': 75.0,
        'y': 150.0,
        'timestamp': '2024-01-01T12:00:00.000',
        'type': 'doubleTap',
        'screen_name': 'profile',
        'widget_type': 'button',
        'widget_key': 'edit-btn',
        'metadata': {'pressed': true},
      };

      final event = TouchEvent.fromMap(map);

      expect(event.id, 'test-789');
      expect(event.position.dx, 75.0);
      expect(event.position.dy, 150.0);
      expect(event.type, TouchType.doubleTap);
      expect(event.screenName, 'profile');
      expect(event.widgetType, 'button');
      expect(event.widgetKey, 'edit-btn');
      expect(event.metadata?['pressed'], true);
    });

    test('should support all touch types', () {
      expect(TouchType.values, contains(TouchType.tap));
      expect(TouchType.values, contains(TouchType.doubleTap));
      expect(TouchType.values, contains(TouchType.longPress));
      expect(TouchType.values, contains(TouchType.panStart));
      expect(TouchType.values, contains(TouchType.panUpdate));
      expect(TouchType.values, contains(TouchType.panEnd));
      expect(TouchType.values, contains(TouchType.scaleStart));
      expect(TouchType.values, contains(TouchType.scaleUpdate));
      expect(TouchType.values, contains(TouchType.scaleEnd));
    });
  });

  group('HeatMapData', () {
    test('should create heat map data', () {
      final now = DateTime.now();
      final data = HeatMapData(
        screenName: 'home',
        screenSize: const Size(375, 812),
        points: [
          const HeatMapPoint(
            position: Offset(10, 20),
            intensity: 0.8,
            count: 5,
            primaryType: TouchType.tap,
          ),
          const HeatMapPoint(
            position: Offset(30, 40),
            intensity: 0.6,
            count: 3,
            primaryType: TouchType.tap,
          ),
        ],
        startDate: now.subtract(const Duration(hours: 1)),
        endDate: now,
        totalEvents: 8,
      );

      expect(data.points.length, 2);
      expect(data.screenName, 'home');
      expect(data.screenSize.width, 375);
      expect(data.screenSize.height, 812);
      expect(data.totalEvents, 8);
    });

    test('should convert heat map data to map', () {
      final startDate = DateTime(2024, 1, 1, 10, 0, 0);
      final endDate = DateTime(2024, 1, 1, 11, 0, 0);
      
      final data = HeatMapData(
        screenName: 'dashboard',
        screenSize: const Size(400, 800),
        points: [
          const HeatMapPoint(
            position: Offset(100, 200),
            intensity: 0.9,
            count: 10,
            primaryType: TouchType.tap,
          ),
        ],
        startDate: startDate,
        endDate: endDate,
        totalEvents: 10,
      );

      final map = data.toMap();

      expect(map['screen_name'], 'dashboard');
      expect(map['screen_width'], 400);
      expect(map['screen_height'], 800);
      expect(map['total_events'], 10);
      expect(map['points'], isNotEmpty);
      expect(map['start_date'], startDate.toIso8601String());
      expect(map['end_date'], endDate.toIso8601String());
    });

    test('should create HeatMapPoint', () {
      const point = HeatMapPoint(
        position: Offset(50, 100),
        intensity: 0.75,
        count: 7,
        primaryType: TouchType.longPress,
      );

      expect(point.position.dx, 50);
      expect(point.position.dy, 100);
      expect(point.intensity, 0.75);
      expect(point.count, 7);
      expect(point.primaryType, TouchType.longPress);
      
      final map = point.toMap();
      expect(map['x'], 50);
      expect(map['y'], 100);
      expect(map['intensity'], 0.75);
      expect(map['count'], 7);
      expect(map['primary_type'], 'longPress');
    });

    test('should create HeatMapData from map', () {
      final map = {
        'screen_name': 'test',
        'screen_width': 320,
        'screen_height': 568,
        'points': [
          {
            'x': 160,
            'y': 284,
            'intensity': 0.5,
            'count': 2,
            'primary_type': 'tap',
          },
        ],
        'start_date': '2024-01-01T09:00:00.000',
        'end_date': '2024-01-01T10:00:00.000',
        'total_events': 2,
      };

      final data = HeatMapData.fromMap(map);

      expect(data.screenName, 'test');
      expect(data.screenSize.width, 320);
      expect(data.screenSize.height, 568);
      expect(data.points.length, 1);
      expect(data.points.first.position.dx, 160);
      expect(data.points.first.position.dy, 284);
      expect(data.totalEvents, 2);
    });
  });
}