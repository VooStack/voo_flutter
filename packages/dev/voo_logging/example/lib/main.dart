import 'package:flutter/material.dart';
import 'package:voo_logging/voo_logging.dart';
import 'package:dio/dio.dart';
import 'package:voo_core/voo_core.dart';
import 'package:voo_toast/voo_toast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Voo Core first
  await Voo.initializeApp(
    options: const VooOptions(
      appName: 'VooLoggingExample',
      autoRegisterPlugins: true,
    ),
  );

  // Initialize VooLogging with toast notifications
  await VooLogger.initialize(
    appName: 'VooLoggingExample',
    minimumLevel: LogLevel.verbose,
    config: const LoggingConfig(
      enablePrettyLogs: true,
      showEmojis: true,
      showTimestamp: true,
      showColors: true,
      enabled: true,
      shouldNotify: true, // Enable toast notifications
    ),
  );

  // Initialize VooToast only if not already initialized
  // This ensures we don't override an existing instance
  try {
    // Try to access the instance - if it doesn't exist, it will create one
    VooToastController.instance;
  } catch (_) {
    // If there's an issue, explicitly initialize
    VooToastController.init();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VooLogging Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const VooToastOverlay(child: LoggingDemoScreen()),
    );
  }
}

class LoggingDemoScreen extends StatefulWidget {
  const LoggingDemoScreen({super.key});

  @override
  State<LoggingDemoScreen> createState() => _LoggingDemoScreenState();
}

class _LoggingDemoScreenState extends State<LoggingDemoScreen> {
  late final Dio dio;
  List<LogEntry> recentLogs = [];
  bool toastEnabled = true;

  @override
  void initState() {
    super.initState();

    // Set up Dio with VooLogging interceptor
    dio = Dio();
    // Note: Add dio interceptor if available in VooLogging

    // Listen to log stream
    VooLogger.instance.stream.listen((log) {
      setState(() {
        recentLogs.insert(0, log);
        if (recentLogs.length > 20) {
          recentLogs.removeLast();
        }
      });
    });
  }

  void _logVerbose() {
    VooLogger.verbose('This is a verbose message');
  }

  void _logDebug() {
    VooLogger.debug('This is a debug message');
  }

  void _logInfo() {
    VooLogger.info('This is an info message');
  }

  void _logWarning() {
    VooLogger.warning('This is a warning message');
  }

  void _logError() {
    VooLogger.error(
      'This is an error message',
      error: Exception('Sample exception'),
      stackTrace: StackTrace.current,
    );
  }

  Future<void> _makeNetworkRequest() async {
    try {
      await dio.get('https://jsonplaceholder.typicode.com/posts/1');
      VooLogger.info('Network request completed successfully');
    } catch (e) {
      VooLogger.error('Network request failed', error: e);
    }
  }

  Future<void> _clearLogs() async {
    await VooLogger.instance.clearLogs();
    setState(() {
      recentLogs.clear();
    });
  }

  String _getLogLevelIcon(LogLevel level) {
    switch (level) {
      case LogLevel.verbose:
        return '📝';
      case LogLevel.debug:
        return '🐛';
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
      case LogLevel.fatal:
        return '💀';
    }
  }

  Color _getLogLevelColor(LogLevel level) {
    switch (level) {
      case LogLevel.verbose:
        return Colors.grey.shade600;
      case LogLevel.debug:
        return Colors.grey;
      case LogLevel.info:
        return Colors.blue;
      case LogLevel.warning:
        return Colors.orange;
      case LogLevel.error:
        return Colors.red;
      case LogLevel.fatal:
        return Colors.red.shade900;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VooLogging Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(
              toastEnabled
                  ? Icons.notifications_active
                  : Icons.notifications_off,
            ),
            onPressed: () {
              setState(() {
                toastEnabled = !toastEnabled;
              });
              // Update config without reinitializing
              VooLogger.config = LoggingConfig(
                enablePrettyLogs: true,
                showEmojis: true,
                showTimestamp: true,
                showColors: true,
                enabled: true,
                shouldNotify: toastEnabled,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Toast notifications ${toastEnabled ? 'enabled' : 'disabled'}',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            tooltip: toastEnabled ? 'Disable toast' : 'Enable toast',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearLogs,
            tooltip: 'Clear logs',
          ),
        ],
      ),
      body: Column(
        children: [
          // Control buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _logVerbose,
                  child: const Text('Log Verbose'),
                ),
                ElevatedButton(
                  onPressed: _logDebug,
                  child: const Text('Log Debug'),
                ),
                ElevatedButton(
                  onPressed: _logInfo,
                  child: const Text('Log Info'),
                ),
                ElevatedButton(
                  onPressed: _logWarning,
                  child: const Text('Log Warning'),
                ),
                ElevatedButton(
                  onPressed: _logError,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Log Error'),
                ),
                ElevatedButton(
                  onPressed: _makeNetworkRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Make API Call'),
                ),
              ],
            ),
          ),
          const Divider(),
          // Log display
          Expanded(
            child: recentLogs.isEmpty
                ? const Center(
                    child: Text(
                      'No logs yet. Try pressing some buttons!',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: recentLogs.length,
                    itemBuilder: (context, index) {
                      final log = recentLogs[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: Text(
                            _getLogLevelIcon(log.level),
                            style: const TextStyle(fontSize: 20),
                          ),
                          title: Text(
                            log.message,
                            style: TextStyle(
                              color: _getLogLevelColor(log.level),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                log.timestamp.toString().split('.').first,
                                style: const TextStyle(fontSize: 12),
                              ),
                              if (log.error != null)
                                Text(
                                  'Error: ${log.error}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                ),
                            ],
                          ),
                          isThreeLine: log.error != null,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
