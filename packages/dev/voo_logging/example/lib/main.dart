import 'package:flutter/material.dart';
import 'package:voo_logging/voo_logging.dart';
import 'package:dio/dio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize VooLogging
  await VooLogging.instance.initialize(
    appName: 'VooLoggingExample',
    enableNetworkLogging: true,
    enableDevToolsIntegration: true,
    maxStorageSize: 10 * 1024 * 1024, // 10 MB
  );
  
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
      home: const LoggingDemoScreen(),
    );
  }
}

class LoggingDemoScreen extends StatefulWidget {
  const LoggingDemoScreen({super.key});

  @override
  State<LoggingDemoScreen> createState() => _LoggingDemoScreenState();
}

class _LoggingDemoScreenState extends State<LoggingDemoScreen> {
  final logger = VooLogger('ExampleApp');
  late final Dio dio;
  List<LogEntry> recentLogs = [];
  
  @override
  void initState() {
    super.initState();
    
    // Set up Dio with VooLogging interceptor
    dio = Dio();
    dio.interceptors.add(VooLogging.instance.dioInterceptor);
    
    // Listen to log stream
    VooLogging.instance.logStream.listen((log) {
      setState(() {
        recentLogs.insert(0, log);
        if (recentLogs.length > 20) {
          recentLogs.removeLast();
        }
      });
    });
  }
  
  void _logDebug() {
    logger.debug('This is a debug message');
  }
  
  void _logInfo() {
    logger.info('This is an info message');
  }
  
  void _logWarning() {
    logger.warning('This is a warning message');
  }
  
  void _logError() {
    logger.error('This is an error message', 
      error: Exception('Sample exception'),
      stackTrace: StackTrace.current,
    );
  }
  
  Future<void> _makeNetworkRequest() async {
    try {
      await dio.get('https://jsonplaceholder.typicode.com/posts/1');
      logger.info('Network request completed successfully');
    } catch (e) {
      logger.error('Network request failed', error: e);
    }
  }
  
  Future<void> _clearLogs() async {
    await VooLogging.instance.clearLogs();
    setState(() {
      recentLogs.clear();
    });
  }
  
  String _getLogLevelIcon(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '🐛';
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
    }
  }
  
  Color _getLogLevelColor(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return Colors.grey;
      case LogLevel.info:
        return Colors.blue;
      case LogLevel.warning:
        return Colors.orange;
      case LogLevel.error:
        return Colors.red;
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
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
                                '${log.loggerName} • ${log.timestamp.toString().split('.').first}',
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