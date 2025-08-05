import 'package:flutter/material.dart';
import 'package:voo_logging/voo_logging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize VooLogger
  await VooLogger.initialize(appName: 'Voo Logging Example', appVersion: '1.0.0', userId: 'user123');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Voo Logging Example',
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
    home: const LoggingExamplePage(),
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
                  value: _selectedLevel,
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
                  value: _selectedCategory,
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
          ListTile(leading: const Icon(Icons.person), title: const Text('Log User Action'), onTap: _logUserAction),
          ListTile(leading: const Icon(Icons.error_outline), title: const Text('Simulate Error'), onTap: _simulateError),
          ListTile(leading: const Icon(Icons.speed), title: const Text('Log Performance Metric'), onTap: _logPerformance),
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
    // Log the request
    await VooLogger.networkRequest(
      'GET',
      'https://api.example.com/users',
      headers: {'Authorization': 'Bearer token123', 'Content-Type': 'application/json'},
      metadata: {'userId': 'user123', 'requestId': DateTime.now().millisecondsSinceEpoch.toString()},
    );

    // Log the response
    await VooLogger.networkResponse(
      200,
      'https://api.example.com/users',
      const Duration(milliseconds: 1234),
      headers: {'Content-Type': 'application/json', 'X-Request-ID': '12345'},
      contentLength: 2048,
      metadata: {'itemCount': 25, 'cached': false},
    );

    _showSnackBar('Network request logged');
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
    VooLogger.performance(
      'DatabaseQuery',
      const Duration(milliseconds: 456),
      metrics: {'rowCount': 1000, 'cacheHit': false, 'queryType': 'SELECT', 'table': 'users'},
    );

    _showSnackBar('Performance metric logged');
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
