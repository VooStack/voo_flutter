import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:voo_core/voo_core.dart';
import 'package:voo_logging/voo_logging.dart';
import 'package:voo_analytics/voo_analytics.dart';
import 'package:voo_performance/voo_performance.dart';

/// Test script to verify analytics and performance are working
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    print('\n===== TESTING ANALYTICS & PERFORMANCE =====\n');
  }

  // Initialize Voo Core
  await Voo.initializeApp(
    options: VooOptions.development(appName: 'Test-Analytics-Performance', appVersion: '1.0.0'),
  );
  if (kDebugMode) {
    print('✅ Voo Core initialized');
  }

  // Initialize plugins
  await VooLoggingPlugin.initialize(maxEntries: 1000, enableConsoleOutput: true);

  await VooAnalyticsPlugin.initialize(enableTouchTracking: true, enableEventLogging: true, enableUserProperties: true);

  await VooPerformancePlugin.initialize(enableNetworkMonitoring: true, enableTraceMonitoring: true, enableAutoAppStartTrace: true);

  // Test Analytics

  // Log some events
  await VooAnalyticsPlugin.instance.logEvent('test_event_1', parameters: {'test_param': 'value1', 'timestamp': DateTime.now().toIso8601String()});

  await VooAnalyticsPlugin.instance.logEvent('test_event_2', parameters: {'test_param': 'value2', 'count': 42});

  // Set user properties
  await VooAnalyticsPlugin.instance.setUserProperty('test_property', 'test_value');

  // Set user ID
  await VooAnalyticsPlugin.instance.setUserId('test_user_123');

  // Get heat map data
  await VooAnalyticsPlugin.instance.getHeatMapData();

  // Test Performance

  // Create and run a trace
  final trace1 = VooPerformancePlugin.instance.newTrace('test_trace_1');
  trace1.start();

  // Simulate some work
  await Future.delayed(const Duration(milliseconds: 100));

  // Add attributes and metrics
  trace1.putAttribute('test_attribute', 'test_value');
  trace1.putMetric('test_metric', 123);

  trace1.stop();

  // Create an HTTP trace
  final httpTrace = VooPerformancePlugin.instance.newHttpTrace('https://api.example.com/test', 'GET');
  httpTrace.start();

  await Future.delayed(const Duration(milliseconds: 50));

  httpTrace.putAttribute('status_code', '200');
  httpTrace.putMetric('response_size', 1024);
  httpTrace.stop();

  // Record a network metric
  await VooPerformancePlugin.instance.recordNetworkMetric(
    NetworkMetric(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      url: 'https://api.example.com/test',
      method: 'POST',
      statusCode: 201,
      duration: const Duration(milliseconds: 75),
      requestSize: 512,
      responseSize: 2048,
      timestamp: DateTime.now(),
    ),
  );

  // Get metrics summary
  VooPerformancePlugin.instance.getMetricsSummary();

  // Check plugin info

  // Keep app running briefly
  await Future.delayed(const Duration(seconds: 1));
}
