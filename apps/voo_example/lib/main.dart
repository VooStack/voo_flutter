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
  await VooLogger.initialize(appName: 'VooExample', appVersion: '1.0.0', userId: 'example_user', minimumLevel: LogLevel.debug);

  VooLogger.info('VooExample app initialized');

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
