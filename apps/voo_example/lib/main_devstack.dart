import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:voo_core/voo_core.dart';
import 'package:voo_logging/voo_logging.dart';
import 'package:voo_analytics/voo_analytics.dart';
import 'package:voo_performance/voo_performance.dart';
import 'package:voo_telemetry/voo_telemetry.dart';

/// Example app configured to send telemetry to DevStack API
///
/// To use this:
/// 1. Get your API key from DevStack dashboard
/// 2. Get your Project ID from DevStack dashboard
/// 3. Get your Organization ID from DevStack dashboard
/// 4. Update the values below
/// 5. Run: flutter run lib/main_devstack.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // DevStack credentials for VooTest project
  const String devStackApiKey =
      'ds_test_V--xoos6S8Q6SlEi2Rb_wFENHFdl2gzV6mB9SfWo-Tk';
  const String projectId =
      '21d20d74-22ef-46b2-8fb2-58c4ac13eb96'; // VooTest project
  const String organizationId =
      '0d1652a4-4251-4c8b-9930-238ec735c236'; // VooStack org

  // Initialize Voo Core first
  await Voo.initializeApp(
    options: VooOptions.development(
      appName: 'VooExample-DevStack',
      appVersion: '1.0.0',
    ),
  );

  // Initialize VooTelemetry with debug mode enabled
  await VooTelemetryPlugin.initialize(
    endpoint: 'http://localhost:5001/api/v1',
    apiKey: devStackApiKey,
    batchInterval: const Duration(
      seconds: 10,
    ), // Sync every 10 seconds for testing
    maxBatchSize: 10, // Small batch size for testing
    debug: true, // Enable to see what's being sent
  );

  // Initialize individual plugins
  await VooLoggingPlugin.initialize(
    maxEntries: 10000,
    enableConsoleOutput: true,
    enableFileStorage: true,
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

  // Initialize VooLogger
  await VooLogger.initialize(
    appName: 'VooExample-DevStack',
    appVersion: '1.0.0',
    userId: 'test_user_123',
    config: const LoggingConfig(
      enablePrettyLogs: true,
      showEmojis: true,
      showTimestamp: true,
      showColors: true,
      showBorders: true,
      lineLength: 120,
      minimumLevel: LogLevel.verbose,
      enabled: true,
      enableDevToolsJson: false,
    ),
  );

  // Sync status is managed internally by VooTelemetry

  // Generate some test telemetry data
  VooLogger.info('DevStack integration initialized successfully');
  VooLogger.debug('Testing telemetry data flow to DevStack API');

  // Log with metadata that will be sent to DevStack
  VooLogger.info(
    'Application started with DevStack telemetry',
    category: 'System',
    tag: 'Startup',
    metadata: {
      'apiKey': '${devStackApiKey.substring(0, 10)}****',
      'projectId': projectId,
      'organizationId': organizationId,
      'syncEnabled': true,
    },
  );

  // Track some analytics events
  VooAnalyticsPlugin.instance.logEvent(
    'app_started',
    parameters: {'telemetry_enabled': true, 'destination': 'devstack'},
  );

  // Force a sync after a short delay to test
  Future.delayed(const Duration(seconds: 2), () async {
    if (kDebugMode) {
      print('\n=== Forcing telemetry sync to DevStack ===');
    }
    await VooTelemetryPlugin.instance.flush();

    // Debug logs are available via console output
    if (kDebugMode) {
      print('Telemetry data flushed to DevStack');
    }
  });

  runApp(const VooExampleDevStackApp());
}

class VooExampleDevStackApp extends StatelessWidget {
  const VooExampleDevStackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voo Flutter - DevStack Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('DevStack Telemetry Example'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(
              icon: const Icon(Icons.sync),
              onPressed: () async {
                if (kDebugMode) {
                  print('Manual sync triggered');
                }
                await VooTelemetryPlugin.instance.flush();
                // Status is managed internally
              },
              tooltip: 'Force Sync',
            ),
            IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                // Status is logged to console
              },
              tooltip: 'Sync Status',
            ),
          ],
        ),
        body: const VooTelemetryDemoPage(),
      ),
    );
  }
}

class VooTelemetryDemoPage extends StatefulWidget {
  const VooTelemetryDemoPage({super.key});

  @override
  State<VooTelemetryDemoPage> createState() => _VooTelemetryDemoPageState();
}

class _VooTelemetryDemoPageState extends State<VooTelemetryDemoPage> {
  int _logCounter = 0;
  int _eventCounter = 0;

  void _generateLog() {
    setState(() {
      _logCounter++;
    });

    VooLogger.info(
      'Test log #$_logCounter from DevStack demo',
      metadata: {
        'counter': _logCounter,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Generated log #$_logCounter')));
  }

  void _generateEvent() {
    setState(() {
      _eventCounter++;
    });

    VooAnalyticsPlugin.instance.logEvent(
      'test_event',
      parameters: {'counter': _eventCounter, 'source': 'devstack_demo'},
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Generated event #$_eventCounter')));
  }

  Future<void> _checkSyncStatus() async {
    // Sync status is managed internally by VooTelemetry

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('DevStack Sync Status'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: Active'),
            Text('Cloud Sync: Enabled'),
            Text('Debug Mode: Enabled'),
            Text('Telemetry is managed by VooTelemetry'),
            SizedBox(height: 8),
            Text(
              'Check console logs for detailed information',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'DevStack Telemetry Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Logs Generated: $_logCounter'),
                    Text('Events Generated: $_eventCounter'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _generateLog,
              icon: const Icon(Icons.note_add),
              label: const Text('Generate Log'),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _generateEvent,
              icon: const Icon(Icons.analytics),
              label: const Text('Generate Analytics Event'),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _checkSyncStatus,
              icon: const Icon(Icons.info_outline),
              label: const Text('Check Sync Status'),
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: () async {
                await VooTelemetryPlugin.instance.flush();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sync triggered!')),
                  );
                }
              },
              icon: const Icon(Icons.sync),
              label: const Text('Force Sync Now'),
            ),

            const SizedBox(height: 32),

            const Text(
              'Note: Update the API credentials in main_devstack.dart\nto connect to your DevStack instance.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
