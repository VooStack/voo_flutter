import 'package:flutter/material.dart';
import 'package:voo_core/voo_core.dart';
import 'package:voo_logging/voo_logging.dart';
import 'package:voo_analytics/voo_analytics.dart';
import 'package:voo_performance/voo_performance.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Step 1: Initialize Voo Core (optional for VooLogging, required for other plugins)
  await Voo.initializeApp(
    options: VooOptions.development(
      appName: 'VooExample',
      appVersion: '1.0.0',
      customConfig: const {
        'enableTouchTracking': true,
        'enableEventLogging': true,
        'enableAutoAppStartTrace': true,
      },
    ),
  );

  // Step 2: Initialize plugins
  // Note: VooLogging now works without explicit initialization!
  // Just call VooLogger.info() etc. and it auto-initializes.
  // Use VooLoggingPlugin.initialize() only for VooCore integration or custom config.
  await VooLoggingPlugin.initialize(
    config: LoggingConfig.development(), // Smart defaults with auto-cleanup
  );

  await VooAnalyticsPlugin.initialize(
    enableTouchTracking: true,
    enableEventLogging: true,
    enableUserProperties: true,
  );

  await VooPerformancePlugin.initialize(
    enableNetworkMonitoring: true,
    enableTraceMonitoring: true,
    enableAutoAppStartTrace: true,
  );

  // Step 3: Optionally initialize VooTelemetry for cloud syncing
  const enableCloudSync = false;

  // Step 4: Use logging - zero-config, auto-initializes if needed
  await VooLogger.verbose('VooExample app starting up...');
  await VooLogger.debug('Debug mode enabled');
  await VooLogger.info('VooExample app initialized successfully');
  await VooLogger.warning('This is a sample warning message');

  // Example with metadata
  await VooLogger.info(
    'Application started',
    category: 'System',
    tag: 'Startup',
    metadata: {
      'platform': 'Flutter',
      'environment': 'development',
      'features': ['logging', 'analytics', 'performance'],
      'cloudSyncEnabled': enableCloudSync,
    },
  );

  // Example: Analytics (works locally, syncs to cloud if telemetry is enabled)
  await VooAnalyticsPlugin.instance.logEvent(
    'app_started',
    parameters: {
      'timestamp': DateTime.now().toIso8601String(),
      'cloud_sync': enableCloudSync,
    },
  );

  // Example: Performance (works locally, syncs to cloud if telemetry is enabled)
  final startupTrace = VooPerformancePlugin.instance.newTrace(
    'app_startup_complete',
  );
  startupTrace.start();

  // Simulate some startup work
  await Future.delayed(const Duration(milliseconds: 100));

  startupTrace.putAttribute('plugins_loaded', '4');
  startupTrace.putMetric('startup_time_ms', 100);
  startupTrace.stop();

  runApp(const VooExampleApp());
}

class VooExampleApp extends StatelessWidget {
  const VooExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RouteAwareTouchTracker(
      enabled: true,
      captureScreenshots: true,
      child: MaterialApp(
        title: 'Voo Flutter Example',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        navigatorObservers: [VooAnalyticsPlugin.instance.routeObserver],
        home: const SizedBox(),
      ),
    );
  }
}
