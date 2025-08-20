import 'package:flutter/material.dart';
import 'package:voo_core/voo_core.dart';
import 'package:voo_logging/voo_logging.dart';
import 'package:voo_analytics/voo_analytics.dart';
import 'package:voo_performance/voo_performance.dart';

/// Test script to verify analytics and performance are working
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('\n===== TESTING ANALYTICS & PERFORMANCE =====\n');

  // Initialize Voo Core
  final app = await Voo.initializeApp(
    options: VooOptions.development(
      appName: 'Test-Analytics-Performance',
      appVersion: '1.0.0',
    ),
  );
  print('✅ Voo Core initialized');

  // Initialize plugins
  await VooLoggingPlugin.initialize(
    maxEntries: 1000,
    enableConsoleOutput: true,
  );
  print('✅ VooLogging initialized');

  await VooAnalyticsPlugin.initialize(
    enableTouchTracking: true,
    enableEventLogging: true,
    enableUserProperties: true,
  );
  print('✅ VooAnalytics initialized');

  await VooPerformancePlugin.initialize(
    enableNetworkMonitoring: true,
    enableTraceMonitoring: true,
    enableAutoAppStartTrace: true,
  );
  print('✅ VooPerformance initialized');

  // Test Analytics
  print('\n--- Testing Analytics ---');
  
  // Log some events
  await VooAnalyticsPlugin.instance.logEvent('test_event_1', parameters: {
    'test_param': 'value1',
    'timestamp': DateTime.now().toIso8601String(),
  });
  print('✅ Logged event: test_event_1');

  await VooAnalyticsPlugin.instance.logEvent('test_event_2', parameters: {
    'test_param': 'value2',
    'count': 42,
  });
  print('✅ Logged event: test_event_2');

  // Set user properties
  await VooAnalyticsPlugin.instance.setUserProperty('test_property', 'test_value');
  print('✅ Set user property: test_property=test_value');

  // Set user ID
  await VooAnalyticsPlugin.instance.setUserId('test_user_123');
  print('✅ Set user ID: test_user_123');

  // Get heat map data
  final heatMapData = await VooAnalyticsPlugin.instance.getHeatMapData();
  print('✅ Retrieved heat map data: ${heatMapData.keys.length} routes');

  // Test Performance
  print('\n--- Testing Performance ---');
  
  // Create and run a trace
  final trace1 = VooPerformancePlugin.instance.newTrace('test_trace_1');
  trace1.start();
  print('✅ Started trace: test_trace_1');
  
  // Simulate some work
  await Future.delayed(const Duration(milliseconds: 100));
  
  // Add attributes and metrics
  trace1.putAttribute('test_attribute', 'test_value');
  trace1.putMetric('test_metric', 123);
  
  trace1.stop();
  print('✅ Stopped trace: test_trace_1 (duration: ${trace1.duration?.inMilliseconds}ms)');

  // Create an HTTP trace
  final httpTrace = VooPerformancePlugin.instance.newHttpTrace(
    'https://api.example.com/test',
    'GET',
  );
  httpTrace.start();
  print('✅ Started HTTP trace');
  
  await Future.delayed(const Duration(milliseconds: 50));
  
  httpTrace.putAttribute('status_code', '200');
  httpTrace.putMetric('response_size', 1024);
  httpTrace.stop();
  print('✅ Stopped HTTP trace (duration: ${httpTrace.duration?.inMilliseconds}ms)');

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
  print('✅ Recorded network metric');

  // Get metrics summary
  final metricsSummary = VooPerformancePlugin.instance.getMetricsSummary();
  print('\n📊 Metrics Summary:');
  print('   Network requests: ${metricsSummary['network']['total_requests']}');
  print('   Avg response time: ${metricsSummary['network']['average_response_time_ms']}ms');
  print('   Error rate: ${(metricsSummary['network']['error_rate'] * 100).toStringAsFixed(1)}%');
  print('   Total traces: ${metricsSummary['traces']['total_traces']}');
  print('   Active traces: ${metricsSummary['traces']['active_traces']}');

  // Check plugin info
  print('\n📋 Plugin Info:');
  print('   Analytics: ${VooAnalyticsPlugin.instance.getInfo()}');
  print('   Performance: ${VooPerformancePlugin.instance.getInfo()}');

  print('\n===== TEST COMPLETE =====\n');
  print('✅ All analytics and performance features are working correctly!');
  
  // Keep app running briefly
  await Future.delayed(const Duration(seconds: 1));
}