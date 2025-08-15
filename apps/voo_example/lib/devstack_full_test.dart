import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:voo_core/voo_core.dart';
import 'package:voo_logging/voo_logging.dart';
import 'package:voo_analytics/voo_analytics.dart';
import 'package:voo_performance/voo_performance.dart';

/// Comprehensive test of all VooFlutter telemetry features with DevStack API
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

  print('\n===== DEVSTACK TELEMETRY FULL TEST =====\n');
  print('Initializing DevStack telemetry...');
  print('Endpoint: $endpoint');
  
  // Initialize DevStack telemetry with debug mode
  await DevStackTelemetry.initialize(
    apiKey: devStackApiKey,
    projectId: projectId,
    organizationId: organizationId,
    endpoint: endpoint,
    enableDebugMode: true,
    syncInterval: const Duration(seconds: 10),
    batchSize: 10,
  );

  print('✓ DevStack telemetry initialized\n');

  // Initialize all plugins
  print('Initializing plugins...');
  
  await VooLoggingPlugin.instance.initialize(
    maxEntries: 10000,
    enableConsoleOutput: true,
    enableFileStorage: true,
  );
  print('✓ VooLogging initialized');

  await VooAnalyticsPlugin.instance.initialize(
    enableTouchTracking: true,
    enableEventLogging: true,
    enableUserProperties: true,
  );
  print('✓ VooAnalytics initialized');

  await VooPerformancePlugin.instance.initialize(
    enableNetworkMonitoring: true,
    enableTraceMonitoring: true,
    enableAutoAppStartTrace: true,
  );
  print('✓ VooPerformance initialized\n');

  // Initialize VooLogger
  await VooLogger.initialize(
    appName: 'DevStackFullTest',
    appVersion: '1.0.0',
    userId: 'test_user_comprehensive',
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
  print('✓ VooLogger initialized\n');

  // Print initial status
  print('===== INITIAL STATUS =====');
  DevStackTelemetry.printSyncStatus();
  print('');

  // Run comprehensive tests
  await runComprehensiveTests();
  
  // Start the Flutter app
  runApp(const DevStackTestApp());
}

Future<void> runComprehensiveTests() async {
  print('===== RUNNING COMPREHENSIVE TESTS =====\n');
  
  // Test 1: Logging at all levels
  print('TEST 1: Logging at all levels');
  await testLogging();
  await Future.delayed(const Duration(seconds: 1));
  
  // Test 2: Performance metrics
  print('\nTEST 2: Performance metrics');
  await testPerformanceMetrics();
  await Future.delayed(const Duration(seconds: 1));
  
  // Test 3: Error tracking
  print('\nTEST 3: Error tracking');
  await testErrorTracking();
  await Future.delayed(const Duration(seconds: 1));
  
  // Test 4: Analytics events
  print('\nTEST 4: Analytics events');
  await testAnalyticsEvents();
  await Future.delayed(const Duration(seconds: 1));
  
  // Test 5: Network monitoring
  print('\nTEST 5: Network monitoring');
  await testNetworkMonitoring();
  await Future.delayed(const Duration(seconds: 1));
  
  // Force sync and check status
  print('\n===== FORCING SYNC =====');
  await DevStackTelemetry.forceSync();
  await Future.delayed(const Duration(seconds: 2));
  
  print('\n===== FINAL STATUS =====');
  DevStackTelemetry.printSyncStatus();
  
  // Print debug log
  print('\n===== DEBUG LOG (last 10 entries) =====');
  final debugLog = DevStackTelemetry.getDebugLog();
  final lastEntries = debugLog.length > 10 
      ? debugLog.sublist(debugLog.length - 10) 
      : debugLog;
  for (final entry in lastEntries) {
    print(entry);
  }
  
  print('\n===== TESTS COMPLETE =====');
  print('Check the DevStack API to verify all telemetry data was received.');
}

Future<void> testLogging() async {
  // Test all log levels
  VooLogger.verbose('Verbose log: Detailed debug information');
  VooLogger.debug('Debug log: Debugging application flow');
  VooLogger.info('Info log: Application started successfully');
  VooLogger.warning('Warning log: Low memory detected');
  VooLogger.error('Error log: Failed to load resource', 
    error: Exception('Resource not found'),
    stackTrace: StackTrace.current,
  );
  VooLogger.fatal('Fatal log: Critical system failure detected');
  
  // Test with metadata
  VooLogger.info('User action logged', 
    category: 'UserInteraction',
    tag: 'ButtonClick',
    metadata: {
      'buttonId': 'submit_btn',
      'screen': 'LoginScreen',
      'timestamp': DateTime.now().toIso8601String(),
    },
  );
  
  print('  ✓ Logged 7 messages at various levels');
}

Future<void> testPerformanceMetrics() async {
  final performancePlugin = VooPerformancePlugin.instance;
  
  // Start a custom trace
  final trace = performancePlugin.newTrace('database_query');
  trace.start();
  
  // Simulate some work
  await Future.delayed(const Duration(milliseconds: 250));
  
  // Add attributes to the trace
  trace.putAttribute('rowCount', '150');
  trace.putAttribute('cacheHit', 'true');
  
  // Stop the trace
  trace.stop();
  
  // Test network request monitoring
  await VooLogger.networkRequest(
    'GET',
    'https://api.example.com/users',
    headers: {'Authorization': 'Bearer token'},
    metadata: {'userId': 'test123'},
  );
  
  await Future.delayed(const Duration(milliseconds: 100));
  
  await VooLogger.networkResponse(
    200,
    'https://api.example.com/users',
    const Duration(milliseconds: 100),
    headers: {'Content-Type': 'application/json'},
    contentLength: 2048,
    metadata: {'cached': false},
  );
  
  print('  ✓ Created performance trace with attributes');
  print('  ✓ Logged network request/response');
}

Future<void> testErrorTracking() async {
  // Test different error types
  try {
    throw ArgumentError('Invalid argument provided');
  } catch (e, stack) {
    VooLogger.error('Argument error caught', 
      error: e, 
      stackTrace: stack,
      category: 'Validation',
    );
  }
  
  try {
    // Simulate null reference
    String? nullString;
    nullString!.length; // This will throw
  } catch (e, stack) {
    VooLogger.error('Null reference error', 
      error: e, 
      stackTrace: stack,
      category: 'NullSafety',
    );
  }
  
  try {
    // Simulate async error
    await Future.error('Async operation failed');
  } catch (e, stack) {
    VooLogger.error('Async error caught', 
      error: e, 
      stackTrace: stack,
      category: 'Async',
      metadata: {'operation': 'data_fetch'},
    );
  }
  
  print('  ✓ Tracked 3 different error types with stack traces');
}

Future<void> testAnalyticsEvents() async {
  final analytics = VooAnalyticsPlugin.instance;
  
  // Log various analytics events
  analytics.logEvent('app_opened', parameters: {
    'source': 'deep_link',
    'campaign': 'test_campaign',
  });
  
  analytics.logEvent('screen_viewed', parameters: {
    'screen_name': 'HomeScreen',
    'screen_class': 'HomePage',
  });
  
  analytics.logEvent('button_clicked', parameters: {
    'button_id': 'purchase_btn',
    'item_id': 'product_123',
    'item_name': 'Test Product',
    'price': 9.99,
  });
  
  analytics.logEvent('search_performed', parameters: {
    'search_term': 'flutter telemetry',
    'results_count': 42,
  });
  
  analytics.logEvent('purchase_completed', parameters: {
    'transaction_id': 'txn_${DateTime.now().millisecondsSinceEpoch}',
    'value': 29.99,
    'currency': 'USD',
    'items': ['item1', 'item2'],
  });
  
  // Set user properties
  analytics.setUserProperty('user_type', 'premium');
  analytics.setUserProperty('account_created', DateTime.now().toIso8601String());
  
  // Log user action
  VooLogger.userAction('feature_used',
    screen: 'SettingsScreen',
    properties: {
      'feature': 'dark_mode',
      'enabled': true,
    },
  );
  
  print('  ✓ Logged 5 analytics events');
  print('  ✓ Set 2 user properties');
  print('  ✓ Logged user action');
}

Future<void> testNetworkMonitoring() async {
  // Simulate multiple API calls
  final endpoints = [
    '/api/users',
    '/api/products',
    '/api/orders',
    '/api/settings',
  ];
  
  for (final endpoint in endpoints) {
    await VooLogger.networkRequest(
      'GET',
      'https://api.devstack.com$endpoint',
      headers: {
        'Authorization': 'Bearer token',
        'X-Request-ID': 'req_${DateTime.now().millisecondsSinceEpoch}',
      },
      metadata: {
        'endpoint': endpoint,
        'index': endpoints.indexOf(endpoint).toString(),
      },
    );
    
    await Future.delayed(const Duration(milliseconds: 50));
    
    await VooLogger.networkResponse(
      200,
      'https://api.devstack.com$endpoint',
      Duration(milliseconds: 50 + endpoints.indexOf(endpoint) * 10),
      headers: {'Content-Type': 'application/json'},
      contentLength: 1024 + endpoints.indexOf(endpoint) * 512,
      metadata: {'cached': endpoints.indexOf(endpoint) % 2 == 0},
    );
  }
  
  print('  ✓ Monitored ${endpoints.length} network requests');
}

class DevStackTestApp extends StatelessWidget {
  const DevStackTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevStack Telemetry Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TestDashboard(),
    );
  }
}

class TestDashboard extends StatefulWidget {
  const TestDashboard({super.key});

  @override
  State<TestDashboard> createState() => _TestDashboardState();
}

class _TestDashboardState extends State<TestDashboard> {
  int _logCount = 0;
  int _eventCount = 0;
  int _errorCount = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DevStack Telemetry Test'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () async {
              await DevStackTelemetry.forceSync();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sync triggered')),
              );
            },
            tooltip: 'Force Sync',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Statistics',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Text('Logs Generated: $_logCount'),
                    Text('Events Tracked: $_eventCount'),
                    Text('Errors Captured: $_errorCount'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: [
                  _buildTestButton(
                    'Generate Log',
                    Icons.note_add,
                    Colors.blue,
                    () {
                      setState(() => _logCount++);
                      VooLogger.info('Test log #$_logCount from dashboard');
                      _showSnackBar('Log generated');
                    },
                  ),
                  _buildTestButton(
                    'Track Event',
                    Icons.analytics,
                    Colors.green,
                    () {
                      setState(() => _eventCount++);
                      VooAnalyticsPlugin.instance.logEvent(
                        'test_event_$_eventCount',
                        parameters: {'index': _eventCount},
                      );
                      _showSnackBar('Event tracked');
                    },
                  ),
                  _buildTestButton(
                    'Simulate Error',
                    Icons.error,
                    Colors.red,
                    () {
                      setState(() => _errorCount++);
                      try {
                        throw Exception('Test error #$_errorCount');
                      } catch (e, stack) {
                        VooLogger.error('Dashboard error', 
                          error: e, 
                          stackTrace: stack,
                        );
                      }
                      _showSnackBar('Error logged');
                    },
                  ),
                  _buildTestButton(
                    'Check Status',
                    Icons.info,
                    Colors.orange,
                    () async {
                      final status = DevStackTelemetry.getSyncStatus();
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Sync Status'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Queue Size: ${status['queueSize']}'),
                              Text('Is Syncing: ${status['isSyncing']}'),
                              Text('Cloud Sync: ${status['cloudSyncEnabled']}'),
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
                    },
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                print('\n===== RUNNING ALL TESTS AGAIN =====\n');
                await runComprehensiveTests();
                _showSnackBar('All tests completed - check console');
              },
              child: const Text('Run All Tests Again'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTestButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Card(
      color: color.withOpacity(0.1),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }
}