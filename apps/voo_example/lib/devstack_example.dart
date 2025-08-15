import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:voo_core/voo_core.dart';
import 'package:voo_logging/voo_logging.dart';
import 'package:voo_analytics/voo_analytics.dart';
import 'package:voo_performance/voo_performance.dart';
import 'package:voo_example/pages/home_page.dart';

/// Example app showing DevStack integration with environment variables
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Get DevStack credentials from environment
  final String? devStackApiKey = dotenv.env['DEVSTACK_API_KEY'];
  final String? projectId = dotenv.env['DEVSTACK_PROJECT_ID'];
  final String? organizationId = dotenv.env['DEVSTACK_ORGANIZATION_ID'];
  final String? endpoint = dotenv.env['DEVSTACK_API_ENDPOINT'];

  if (devStackApiKey == null || projectId == null || organizationId == null || endpoint == null) {
    print('ERROR: Missing required environment variables!');
    print('Please ensure .env file exists with all required values.');
    print('Copy .env.example to .env and update with your credentials.');
    return;
  }

  print('Initializing DevStack telemetry...');
  print('Endpoint: $endpoint');
  
  // Initialize DevStack telemetry
  await DevStackTelemetry.initialize(
    apiKey: devStackApiKey,
    projectId: projectId,
    organizationId: organizationId,
    endpoint: endpoint,
    enableDebugMode: false, // Set to true for debugging
    syncInterval: const Duration(seconds: 30),
    batchSize: 50,
  );

  print('✓ DevStack telemetry initialized');

  // Initialize individual plugins
  await VooLoggingPlugin.instance.initialize(
    maxEntries: 10000,
    enableConsoleOutput: true,
    enableFileStorage: true,
  );
  
  await VooAnalyticsPlugin.instance.initialize(
    enableTouchTracking: true,
    enableEventLogging: true,
    enableUserProperties: true,
  );
  
  await VooPerformancePlugin.instance.initialize(
    enableNetworkMonitoring: true,
    enableTraceMonitoring: true,
    enableAutoAppStartTrace: true,
  );

  // Initialize VooLogger
  await VooLogger.initialize(
    appName: 'VooExample',
    appVersion: '1.0.0',
    userId: 'example_user',
    minimumLevel: LogLevel.verbose,
    config: const LoggingConfig(
      enablePrettyLogs: true,
      showEmojis: true,
      showTimestamp: true,
      showColors: true,
      minimumLevel: LogLevel.verbose,
      enabled: true,
    ),
  );

  VooLogger.info('VooExample app initialized with DevStack telemetry');
  
  // Log analytics event
  VooAnalyticsPlugin.instance.logEvent('app_started', parameters: {
    'source': 'main',
    'telemetry_enabled': true,
  });

  runApp(const VooExampleApp());
}

class VooExampleApp extends StatelessWidget {
  const VooExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voo Flutter Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}