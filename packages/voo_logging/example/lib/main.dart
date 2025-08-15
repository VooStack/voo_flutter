import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:voo_analytics/voo_analytics.dart';
import 'package:voo_core/voo_core.dart';
import 'package:voo_logging/voo_logging.dart';
import 'package:voo_logging_example/analytics_example.dart';
import 'package:voo_logging_example/dio_example.dart';
import 'package:voo_logging_example/performance_example.dart';
import 'package:voo_performance/voo_performance.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Voo Core
  await Voo.initializeApp();

  // Initialize VooLogger
  await VooLogger.initialize(appName: 'Voo Logging Example', appVersion: '1.0.0', userId: 'user123');

  // Initialize VooAnalytics
  await VooAnalyticsPlugin.instance.initialize();

  // Initialize VooPerformance
  await VooPerformancePlugin.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => RouteAwareTouchTracker(
    child: MaterialApp(
      title: 'Voo Logging Example',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      navigatorObservers: [VooAnalyticsPlugin.instance.routeObserver],
      initialRoute: '/',
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case '/':
            page = const LoggingExamplePage();
            break;
          case '/dio':
            page = const DioExampleScreen();
            break;
          case '/analytics':
            page = const AnalyticsExamplePage();
            break;
          case '/performance':
            page = const PerformanceExamplePage();
            break;
          default:
            page = const LoggingExamplePage();
        }
        return MaterialPageRoute(builder: (context) => page, settings: settings);
      },
    ),
  );
}

class LoggingExamplePage extends StatefulWidget {
  const LoggingExamplePage({super.key});

  @override
  State<LoggingExamplePage> createState() => _LoggingExamplePageState();
}

class _LoggingExamplePageState extends State<LoggingExamplePage> {
  final _messageController = TextEditingController();
  String _selectedLevel = 'info';
  String _selectedCategory = 'General';

  final List<String> _logLevels = ['verbose', 'debug', 'info', 'warning', 'error', 'fatal'];
  final List<String> _categories = ['General', 'Network', 'Database', 'UI', 'Analytics'];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: const Text('Voo Logging Example')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCustomLogSection(),
          const SizedBox(height: 24),
          _buildQuickActionsSection(),
          const SizedBox(height: 24),
          _buildScenarioSection(),
          const SizedBox(height: 24),
          _buildLogManagementSection(),
        ],
      ),
    ),
  );

  Widget _buildCustomLogSection() => Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Custom Log Entry', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          TextField(
            controller: _messageController,
            decoration: const InputDecoration(labelText: 'Log Message', border: OutlineInputBorder(), hintText: 'Enter your log message'),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedLevel,
                  decoration: const InputDecoration(labelText: 'Log Level', border: OutlineInputBorder()),
                  items: _logLevels.map((level) => DropdownMenuItem(value: level, child: Text(level.toUpperCase()))).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedLevel = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                  items: _categories.map((category) => DropdownMenuItem(value: category, child: Text(category))).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(onPressed: _logCustomMessage, icon: const Icon(Icons.send), label: const Text('Send Log')),
          ),
        ],
      ),
    ),
  );

  Widget _buildQuickActionsSection() => Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Log Actions', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: () => _quickLog(LogLevel.verbose),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                child: const Text('Verbose'),
              ),
              ElevatedButton(
                onPressed: () => _quickLog(LogLevel.debug),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text('Debug'),
              ),
              ElevatedButton(
                onPressed: () => _quickLog(LogLevel.info),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Info'),
              ),
              ElevatedButton(
                onPressed: () => _quickLog(LogLevel.warning),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text('Warning'),
              ),
              ElevatedButton(
                onPressed: () => _quickLog(LogLevel.error),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Error'),
              ),
              ElevatedButton(
                onPressed: () => _quickLog(LogLevel.fatal),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                child: const Text('Fatal'),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _buildScenarioSection() => Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Common Scenarios', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          ListTile(leading: const Icon(Icons.network_wifi), title: const Text('Simulate Network Request'), onTap: _simulateNetworkRequest),
          ListTile(leading: const Icon(Icons.cloud_download), title: const Text('Simulate Multiple API Calls'), onTap: _simulateMultipleApiCalls),
          ListTile(
            leading: const Icon(Icons.http),
            title: const Text('Dio Interceptor Example'),
            subtitle: const Text('Test real HTTP requests with auto-logging'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pushNamed(context, '/dio');
            },
          ),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('Analytics Example'),
            subtitle: const Text('Test touch tracking and custom events'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pushNamed(context, '/analytics');
            },
          ),
          ListTile(
            leading: const Icon(Icons.speed),
            title: const Text('Performance Example'),
            subtitle: const Text('Test performance traces and metrics'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pushNamed(context, '/performance');
            },
          ),
          ListTile(leading: const Icon(Icons.person), title: const Text('Log User Action'), onTap: _logUserAction),
          ListTile(leading: const Icon(Icons.error_outline), title: const Text('Simulate Error'), onTap: _simulateError),
          ListTile(leading: const Icon(Icons.speed), title: const Text('Log Performance Metric'), onTap: _logPerformance),
          ListTile(leading: const Icon(Icons.timer), title: const Text('Track Async Operation'), onTap: _trackAsyncOperation),
          ListTile(leading: const Icon(Icons.speed), title: const Text('Log Large Error'), onTap: _logLargeError),
          ListTile(leading: const Icon(Icons.bug_report), title: const Text('Generate Multiple Logs'), onTap: _generateMultipleLogs),
        ],
      ),
    ),
  );

  Widget _buildLogManagementSection() => Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Log Management', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(onPressed: _viewStatistics, icon: const Icon(Icons.bar_chart), label: const Text('View Statistics')),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(onPressed: _exportLogs, icon: const Icon(Icons.download), label: const Text('Export Logs')),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _clearLogs,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear Logs'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(onPressed: _changeUser, icon: const Icon(Icons.person_outline), label: const Text('Change User')),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  void _logCustomMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a message')));
      return;
    }

    final level = LogLevel.values.firstWhere((l) => l.name == _selectedLevel);

    VooLogger.log(
      message,
      level: level,
      category: _selectedCategory,
      tag: 'CustomLog',
      metadata: {'source': 'manual_input', 'timestamp': DateTime.now().toIso8601String()},
    );

    _messageController.clear();
    _showSnackBar('Log sent: $message');
  }

  void _quickLog(LogLevel level) {
    final messages = {
      LogLevel.verbose: 'This is a verbose message with detailed debugging info',
      LogLevel.debug: 'Debug: Component initialized successfully',
      LogLevel.info: 'User performed an action',
      LogLevel.warning: 'Warning: Approaching memory limit',
      LogLevel.error: 'Error: Failed to load resource',
      LogLevel.fatal: 'Fatal: Critical system failure',
    };

    VooLogger.log(messages[level]!, level: level, category: 'QuickAction', metadata: {'timestamp': DateTime.now().toIso8601String(), 'example': true});

    _showSnackBar('${level.name.toUpperCase()} log sent');
  }

  Future<void> _simulateNetworkRequest() async {
    // Example of using the NetworkInterceptor
    const interceptor = VooNetworkInterceptor();

    // Log the request
    await interceptor.onRequest(
      method: 'GET',
      url: 'https://api.example.com/users',
      headers: {'Authorization': 'Bearer token123', 'Content-Type': 'application/json'},
      metadata: {'userId': 'user123', 'requestId': DateTime.now().millisecondsSinceEpoch.toString()},
    );

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1234));

    // Log the response
    await interceptor.onResponse(
      statusCode: 200,
      url: 'https://api.example.com/users',
      duration: const Duration(milliseconds: 1234),
      headers: {'Content-Type': 'application/json', 'X-Request-ID': '12345'},
      body: {'users': <dynamic>[], 'total': 25},
      contentLength: 2048,
      metadata: {'itemCount': 25, 'cached': false},
    );

    _showSnackBar('Network request logged with interceptor');
  }

  Future<void> _simulateMultipleApiCalls() async {
    final random = Random();
    final endpoints = ['/api/users', '/api/products', '/api/orders', '/api/analytics', '/api/settings'];

    final methods = ['GET', 'POST', 'PUT', 'DELETE'];

    for (int i = 0; i < 10; i++) {
      final endpoint = endpoints[random.nextInt(endpoints.length)];
      final method = methods[random.nextInt(methods.length)];
      final statusCode = random.nextBool() ? 200 : (random.nextBool() ? 404 : 500);
      final duration = Duration(milliseconds: random.nextInt(3000) + 100);

      // Log request
      await VooLogger.networkRequest(
        method,
        'https://api.example.com$endpoint',
        headers: {'Authorization': 'Bearer token', 'X-Request-ID': 'req_$i'},
        metadata: {'attempt': '${i + 1}'},
      );

      // Simulate delay
      await Future.delayed(Duration(milliseconds: random.nextInt(100)));

      // Log response
      await VooLogger.networkResponse(
        statusCode,
        'https://api.example.com$endpoint',
        duration,
        headers: {'Content-Type': 'application/json'},
        contentLength: random.nextInt(10000),
        metadata: {'cached': random.nextBool()},
      );
    }

    _showSnackBar('10 API calls simulated');
  }

  void _logUserAction() {
    VooLogger.userAction(
      'button_click',
      screen: 'LoggingExamplePage',
      properties: {'button': 'log_user_action', 'timestamp': DateTime.now().toIso8601String(), 'sessionDuration': 300},
    );

    _showSnackBar('User action logged');
  }

  void _simulateError() {
    try {
      throw Exception('This is a simulated error for demonstration');
    } catch (e, stackTrace) {
      VooLogger.error(
        'An error occurred in the example app',
        error: e,
        stackTrace: stackTrace,
        category: 'Error',
        tag: 'SimulatedError',
        metadata: {'errorType': e.runtimeType.toString(), 'screen': 'LoggingExamplePage'},
      );
    }

    _showSnackBar('Error logged with stack trace');
  }

  void _logPerformance() {
    // Log performance as info with metadata
    VooLogger.info(
      'DatabaseQuery completed in 456ms',
      category: 'Performance',
      metadata: {'duration_ms': 456, 'rowCount': 1000, 'cacheHit': false, 'queryType': 'SELECT', 'table': 'users'},
    );

    _showSnackBar('Performance metrics logged');
  }

  Future<void> _trackAsyncOperation() async {
    try {
      // Track operation with timing
      final stopwatch = Stopwatch()..start();

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 1500));

      stopwatch.stop();

      // Simulate random success/failure
      final result = Random().nextBool() ? 'User data fetched successfully' : 'Failed to fetch user data';

      await VooLogger.info(
        'API call completed in ${stopwatch.elapsedMilliseconds}ms',
        category: 'Performance',
        metadata: {'endpoint': '/api/user/profile', 'method': 'GET', 'duration_ms': stopwatch.elapsedMilliseconds, 'result': result},
      );

      _showSnackBar('Operation tracked: $result');
    } catch (e) {
      _showSnackBar('Operation failed: $e');
    }

    // Example of tracking synchronous operation
    final stopwatch = Stopwatch()..start();
    int sum = 0;
    for (int i = 0; i < 1000000; i++) {
      sum += i;
    }
    stopwatch.stop();

    await VooLogger.info(
      'Sync calculation completed in ${stopwatch.elapsedMilliseconds}ms',
      category: 'Performance',
      metadata: {'iterations': 1000000, 'algorithm': 'linear', 'duration_ms': stopwatch.elapsedMilliseconds, 'result': sum},
    );
  }

  Future<void> _logLargeError() async {
    final largeError = StringBuffer('This is a very large error message. ' * 1000);
    try {
      throw Exception(largeError.toString());
    } catch (e, stackTrace) {
      await VooLogger.error(
        'Large error occurred in the example app',
        error: e,
        stackTrace: stackTrace,
        category: 'LargeError',
        tag: 'LargeErrorTest',
        metadata: {'errorSize': largeError.length, 'screen': 'LoggingExamplePage'},
      );
    }

    _showSnackBar('Large error logged with stack trace');
  }

  Future<void> _generateMultipleLogs() async {
    final categories = ['Network', 'Database', 'UI', 'Analytics', 'System'];
    const levels = LogLevel.values;

    for (int i = 0; i < 20; i++) {
      final category = categories[i % categories.length];
      final level = levels[i % levels.length];

      VooLogger.log(
        'Generated log #${i + 1}: Sample ${level.name} message',
        level: level,
        category: category,
        tag: 'BatchLog',
        metadata: {'index': i, 'batch': true, 'timestamp': DateTime.now().toIso8601String()},
      );
    }

    _showSnackBar('Generated 20 logs');
  }

  Future<void> _viewStatistics() async {
    final stats = await VooLogger.getStatistics();

    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Statistics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Logs: ${stats.totalLogs}'),
            const SizedBox(height: 8),
            const Text('By Level:'),
            // ...stats.levelCounts.entries.map((e) => Text('  ${e.key}: ${e.value}')),
            const SizedBox(height: 8),
            const Text('By Category:'),
            // ...stats.categoryCounts.entries.take(5).map((e) => Text('  ${e.key}: ${e.value}')),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
      ),
    );
  }

  Future<void> _exportLogs() async {
    final jsonLogs = await VooLogger.exportLogs();

    // In a real app, you would save this to a file
    debugPrint('Exported logs: ${jsonLogs.substring(0, 200)}...');

    _showSnackBar('Logs exported (check console)');
  }

  Future<void> _clearLogs() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Logs?'),
        content: const Text('This will delete all stored logs. This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await VooLogger.clearLogs();
      _showSnackBar('All logs cleared');
    }
  }

  void _changeUser() {
    final newUserId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    VooLogger.setUserId(newUserId);
    VooLogger.startNewSession();

    VooLogger.info('User changed', category: 'System', metadata: {'oldUserId': 'user123', 'newUserId': newUserId});

    _showSnackBar('User changed to: $newUserId');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
