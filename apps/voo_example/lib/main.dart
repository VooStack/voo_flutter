import 'package:flutter/material.dart';
import 'package:voo_core/voo_core.dart';
import 'package:voo_logging/voo_logging.dart';
import 'package:voo_analytics/voo_analytics.dart';
import 'package:voo_performance/voo_performance.dart';
import 'package:voo_example/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Voo.initializeApp(options: const VooOptions(enableDebugLogging: true, autoRegisterPlugins: true));

  // Initialize individual plugins
  await VooLoggingPlugin.instance.initialize(maxEntries: 10000, enableConsoleOutput: true, enableFileStorage: true);
  await VooAnalyticsPlugin.instance.initialize(enableTouchTracking: true, enableEventLogging: true, enableUserProperties: true);
  await VooPerformancePlugin.instance.initialize(enableNetworkMonitoring: true, enableTraceMonitoring: true, enableAutoAppStartTrace: true);
  // Initialize VooLogger with pretty logging configuration
  await VooLogger.initialize(
    appName: 'VooExample',
    appVersion: '1.0.0',
    userId: 'example_user',
    minimumLevel: LogLevel.verbose,
    config: const LoggingConfig(
      enablePrettyLogs: true,  // Enable pretty formatted logs
      showEmojis: true,         // Show emoji icons for log levels
      showTimestamp: true,      // Include timestamps in logs
      showColors: true,         // Use ANSI colors in console
      showBorders: true,        // Show decorative borders
      lineLength: 120,          // Maximum line width
      minimumLevel: LogLevel.verbose,
      enabled: true,
      enableDevToolsJson: false, // Disable JSON logs in console output
    ),
  );

  // Demonstrate different log levels with pretty formatting
  VooLogger.verbose('VooExample app starting up...');
  VooLogger.debug('Debug mode enabled with pretty logging');
  VooLogger.info('VooExample app initialized successfully');
  VooLogger.warning('This is a sample warning message to demonstrate formatting');
  
  // Example with metadata
  VooLogger.info(
    'Application started',
    category: 'System',
    tag: 'Startup',
    metadata: {
      'platform': 'Flutter',
      'environment': 'development',
      'features': ['logging', 'analytics', 'performance'],
    },
  );

  runApp(const VooExampleApp());
}

class VooExampleApp extends StatelessWidget {
  const VooExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voo Flutter Example',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      home: const HomePage(),
    );
  }
}
