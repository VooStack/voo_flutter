import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_example/main.dart';
import 'package:voo_example/pages/home_page.dart';
import 'package:voo_example/pages/logging_page.dart';
import 'package:voo_example/pages/analytics_page.dart';
import 'package:voo_example/pages/performance_page.dart';
import 'package:voo_example/pages/network_page.dart';
import 'package:voo_core/voo_core.dart';
import 'package:voo_logging/voo_logging.dart';
import 'package:voo_analytics/voo_analytics.dart';
import 'package:voo_performance/voo_performance.dart';

void main() {
  setUpAll(() async {
    // Initialize Voo packages for testing
    await Voo.initializeApp(
      options: const VooOptions(
        enableDebugLogging: true,
        autoRegisterPlugins: true,
      ),
    );
    
    await VooLoggingPlugin.instance.initialize();
    await VooAnalyticsPlugin.instance.initialize();
    await VooPerformancePlugin.instance.initialize();
    
    await VooLogger.initialize(
      appName: 'VooExampleTest',
      appVersion: '1.0.0',
      userId: 'test_user',
      minimumLevel: LogLevel.debug,
    );
  });

  group('VooExampleApp Widget Tests', () {
    testWidgets('App builds and displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const VooExampleApp());
      
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(HomePage), findsOneWidget);
    });
  });

  group('HomePage Widget Tests', () {
    testWidgets('HomePage displays all feature cards', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(),
        ),
      );

      expect(find.text('Voo Flutter Examples'), findsOneWidget);
      expect(find.text('VooFlutter Integration'), findsOneWidget);
      
      // Check all feature cards
      expect(find.text('Logging'), findsOneWidget);
      expect(find.text('Analytics'), findsOneWidget);
      expect(find.text('Performance'), findsOneWidget);
      expect(find.text('Network Interceptors'), findsOneWidget);
      
      // Check icons
      expect(find.byIcon(Icons.bug_report), findsOneWidget);
      expect(find.byIcon(Icons.analytics), findsOneWidget);
      expect(find.byIcon(Icons.speed), findsOneWidget);
      expect(find.byIcon(Icons.network_check), findsOneWidget);
    });

    testWidgets('Feature cards are tappable', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(),
        ),
      );

      // Find all InkWell widgets (feature cards)
      final inkWells = find.byType(InkWell);
      expect(inkWells, findsNWidgets(4));
    });
  });

  group('LoggingPage Widget Tests', () {
    testWidgets('LoggingPage displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoggingPage(),
        ),
      );

      expect(find.text('Logging Example'), findsOneWidget);
      expect(find.text('Create Log Entry'), findsOneWidget);
      expect(find.text('Recent Logs'), findsOneWidget);
      
      // Check for input field
      expect(find.byType(TextField), findsOneWidget);
      
      // Check for dropdown
      expect(find.byType(DropdownButtonFormField<LogLevel>), findsOneWidget);
      
      // Check for action chips
      expect(find.text('Test Debug'), findsOneWidget);
      expect(find.text('Test Info'), findsOneWidget);
      expect(find.text('Test Warning'), findsOneWidget);
      expect(find.text('Test Error'), findsOneWidget);
      expect(find.text('Test Exception'), findsOneWidget);
    });

    testWidgets('Log level dropdown works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoggingPage(),
        ),
      );

      // Find and tap the dropdown
      final dropdown = find.byType(DropdownButtonFormField<LogLevel>);
      await tester.tap(dropdown);
      await tester.pumpAndSettle();
      
      // Verify all log levels are available
      expect(find.text('DEBUG'), findsWidgets);
      expect(find.text('INFO'), findsWidgets);
      expect(find.text('WARNING'), findsWidgets);
      expect(find.text('ERROR'), findsWidgets);
    });
  });

  group('AnalyticsPage Widget Tests', () {
    testWidgets('AnalyticsPage displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AnalyticsPage(),
        ),
      );

      expect(find.text('Analytics Example'), findsOneWidget);
      expect(find.text('Enable Touch Tracking'), findsOneWidget);
      expect(find.text('Interaction Statistics'), findsOneWidget);
      expect(find.text('Interactive Touch Area'), findsOneWidget);
      expect(find.text('Recent Touch Events'), findsOneWidget);
      
      // Check for switch
      expect(find.byType(Switch), findsOneWidget);
      
      // Check for statistics cards
      expect(find.text('Taps'), findsOneWidget);
      expect(find.text('Long Press'), findsOneWidget);
      expect(find.text('Swipes'), findsOneWidget);
    });

    testWidgets('Touch tracking toggle works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AnalyticsPage(),
        ),
      );

      final switchWidget = find.byType(Switch);
      expect(switchWidget, findsOneWidget);
      
      // Toggle the switch
      await tester.tap(switchWidget);
      await tester.pump();
      
      // Switch should still be present
      expect(switchWidget, findsOneWidget);
    });
  });

  group('PerformancePage Widget Tests', () {
    testWidgets('PerformancePage displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PerformancePage(),
        ),
      );

      expect(find.text('Performance Example'), findsOneWidget);
      expect(find.text('Real-time Performance'), findsOneWidget);
      expect(find.text('Performance Statistics'), findsOneWidget);
      expect(find.text('Performance Testing'), findsOneWidget);
      expect(find.text('Network Metrics'), findsOneWidget);
      
      // Check for metric rows
      expect(find.text('CPU Usage'), findsOneWidget);
      expect(find.text('Memory'), findsOneWidget);
      expect(find.text('FPS'), findsOneWidget);
      
      // Check for action buttons
      expect(find.text('Heavy Operation'), findsOneWidget);
      expect(find.text('Network Request'), findsOneWidget);
      expect(find.text('Custom Trace'), findsOneWidget);
    });

    testWidgets('Performance metrics display', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PerformancePage(),
        ),
      );

      // Check for progress indicators
      expect(find.byType(LinearProgressIndicator), findsNWidgets(3));
      
      // Check for stat cards
      expect(find.text('Total Traces'), findsOneWidget);
      expect(find.text('Avg Response'), findsOneWidget);
      expect(find.text('Network Calls'), findsOneWidget);
    });
  });

  group('NetworkPage Widget Tests', () {
    testWidgets('NetworkPage displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NetworkPage(),
        ),
      );

      expect(find.text('Network Interceptors Example'), findsOneWidget);
      expect(find.text('Test Network Requests'), findsOneWidget);
      expect(find.text('Request History'), findsOneWidget);
      
      // Check for request buttons
      expect(find.text('GET'), findsOneWidget);
      expect(find.text('POST'), findsOneWidget);
      expect(find.text('PUT'), findsOneWidget);
      expect(find.text('DELETE'), findsOneWidget);
      expect(find.text('Fail (404)'), findsOneWidget);
      
      // Check for info card
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('Request buttons are present and enabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NetworkPage(),
        ),
      );

      // Find all elevated buttons
      final buttons = find.byType(ElevatedButton);
      expect(buttons, findsNWidgets(5)); // GET, POST, PUT, DELETE, Fail
    });
  });

  group('Package Integration Tests', () {
    test('VooLogger functionality', () async {
      // Test logging
      await VooLogger.debug('Test debug message');
      await VooLogger.info('Test info message');
      await VooLogger.warning('Test warning message');
      await VooLogger.error('Test error message');
      
      // Test statistics
      final stats = await VooLogger.getStatistics();
      expect(stats, isNotNull);
      
      // Test export
      final exported = await VooLogger.exportLogs();
      expect(exported, isNotNull);
    });

    test('Analytics functionality', () async {
      // Track a touch event
      final event = TouchEvent(
        id: 'test_event',
        timestamp: DateTime.now(),
        position: const Offset(50, 50),
        screenName: 'TestScreen',
        type: TouchType.tap,
        metadata: const {'test': true},
      );
      
      final analyticsRepo = VooAnalyticsPlugin.instance.repository;
      if (analyticsRepo != null) {
        await analyticsRepo.logTouchEvent(event);
      }
      
      // Log a regular event
      await VooAnalyticsPlugin.instance.logEvent(
        'test_event',
        parameters: {'value': 42},
      );
      
      // Test heat map generation
      final heatMap = await VooAnalyticsPlugin.instance.getHeatMapData();
      expect(heatMap, isNotNull);
    });

    test('Performance functionality', () async {
      // Create and use a trace
      final trace = VooPerformancePlugin.instance.newTrace('test_trace');
      trace.start();
      expect(trace.name, 'test_trace');
      expect(trace.isRunning, true);
      
      // Add metrics
      trace.putMetric('test_metric', 42);
      trace.putAttribute('test_attr', 'value');
      
      // Stop the trace
      trace.stop();
      expect(trace.isRunning, false);
      expect(trace.duration, isNotNull);
      
      // Test PerformanceTracker utility
      final result = await PerformanceTracker.track<int>(
        operation: 'test_op',
        operationType: 'test',
        action: () async {
          await Future.delayed(const Duration(milliseconds: 10));
          return 42;
        },
      );
      expect(result, 42);
    });
  });
}