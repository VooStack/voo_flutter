import 'package:flutter/material.dart';
import 'package:voo_logging/voo_logging.dart';

class LoggingPage extends StatefulWidget {
  const LoggingPage({super.key});

  @override
  State<LoggingPage> createState() => _LoggingPageState();
}

class _LoggingPageState extends State<LoggingPage> {
  final TextEditingController _messageController = TextEditingController();
  LogLevel _selectedLevel = LogLevel.info;
  List<LogEntry> _recentLogs = [];

  @override
  void initState() {
    super.initState();
    _loadRecentLogs();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadRecentLogs() async {
    // VooLogger doesn't have getLogs, we'll track logs locally
    // In a real app, you might stream logs or store them
    setState(() {
      // Keep existing logs
    });
  }

  void _logMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    // Create a local log entry for display
    final logEntry = LogEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      level: _selectedLevel,
      message: message,
      category: 'LoggingPage',
      metadata: const {'source': 'LoggingPage'},
    );

    // Log using VooLogger
    switch (_selectedLevel) {
      case LogLevel.verbose:
        await VooLogger.verbose(message);
        break;
      case LogLevel.debug:
        await VooLogger.debug(message);
        break;
      case LogLevel.info:
        await VooLogger.info(message);
        break;
      case LogLevel.warning:
        await VooLogger.warning(message);
        break;
      case LogLevel.error:
        await VooLogger.error(message);
        break;
      case LogLevel.fatal:
        await VooLogger.fatal(message);
        break;
    }

    // Add to local list for display
    setState(() {
      _recentLogs.insert(0, logEntry);
      if (_recentLogs.length > 10) {
        _recentLogs.removeLast();
      }
    });

    _messageController.clear();
    _loadRecentLogs();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Logged: $message'), backgroundColor: _getColorForLevel(_selectedLevel), duration: const Duration(seconds: 2)));
  }

  void _clearLogs() async {
    await VooLogger.clearLogs();
    setState(() {
      _recentLogs = [];
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logs cleared')));
    }
  }

  void _exportLogs() async {
    await VooLogger.exportLogs();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logs exported')));
    }
  }

  Color _getColorForLevel(LogLevel level) {
    switch (level) {
      case LogLevel.verbose:
        return Colors.grey.shade400;
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
        title: const Text('Logging Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadRecentLogs, tooltip: 'Refresh logs'),
          IconButton(icon: const Icon(Icons.delete_sweep), onPressed: _clearLogs, tooltip: 'Clear all logs'),
          IconButton(icon: const Icon(Icons.download), onPressed: _exportLogs, tooltip: 'Export logs'),
        ],
      ),
      body: Column(
        children: [
          // Log Input Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Create Log Entry', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(labelText: 'Log Message', hintText: 'Enter a message to log', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<LogLevel>(
                            value: _selectedLevel,
                            decoration: const InputDecoration(labelText: 'Log Level', border: OutlineInputBorder()),
                            items: LogLevel.values.map((level) {
                              return DropdownMenuItem(
                                value: level,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(color: _getColorForLevel(level), shape: BoxShape.circle),
                                    ),
                                    Text(level.name.toUpperCase()),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedLevel = value;
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: _logMessage,
                          icon: const Icon(Icons.send),
                          label: const Text('Log'),
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Example Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              children: [
                ActionChip(
                  label: const Text('Test Debug'),
                  onPressed: () async {
                    await VooLogger.debug('Debug test at ${DateTime.now()}');
                    _addLocalLog(LogLevel.debug, 'Debug test at ${DateTime.now()}');
                  },
                ),
                ActionChip(
                  label: const Text('Test Info'),
                  onPressed: () async {
                    await VooLogger.info('Info test at ${DateTime.now()}');
                    _addLocalLog(LogLevel.info, 'Info test at ${DateTime.now()}');
                  },
                ),
                ActionChip(
                  label: const Text('Test Warning'),
                  onPressed: () async {
                    await VooLogger.warning('Warning test at ${DateTime.now()}');
                    _addLocalLog(LogLevel.warning, 'Warning test at ${DateTime.now()}');
                  },
                ),
                ActionChip(
                  label: const Text('Test Error'),
                  onPressed: () async {
                    await VooLogger.error('Error test at ${DateTime.now()}');
                    _addLocalLog(LogLevel.error, 'Error test at ${DateTime.now()}');
                  },
                ),
                ActionChip(
                  label: const Text('Test Exception'),
                  onPressed: () async {
                    try {
                      throw Exception('Test exception');
                    } catch (e, stack) {
                      await VooLogger.error('Exception caught', error: e, stackTrace: stack);
                      _addLocalLog(LogLevel.error, 'Exception caught: $e');
                    }
                  },
                ),
              ],
            ),
          ),

          // Recent Logs
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Recent Logs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('${_recentLogs.length} entries', style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _recentLogs.isEmpty
                        ? const Center(child: Text('No logs yet. Create some logs above!'))
                        : ListView.builder(
                            itemCount: _recentLogs.length,
                            itemBuilder: (context, index) {
                              final log = _recentLogs[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: Container(
                                    width: 8,
                                    height: 40,
                                    decoration: BoxDecoration(color: _getColorForLevel(log.level), borderRadius: BorderRadius.circular(4)),
                                  ),
                                  title: Text(log.message),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${log.level.name.toUpperCase()} • ${_formatTime(log.timestamp)}', style: const TextStyle(fontSize: 12)),
                                      if (log.metadata != null && log.metadata!.isNotEmpty)
                                        Text('Metadata: ${log.metadata}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                    ],
                                  ),
                                  isThreeLine: log.metadata != null && log.metadata!.isNotEmpty,
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addLocalLog(LogLevel level, String message) {
    final logEntry = LogEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      level: level,
      message: message,
      category: 'LoggingPage',
      metadata: const {'source': 'Test'},
    );

    setState(() {
      _recentLogs.insert(0, logEntry);
      if (_recentLogs.length > 10) {
        _recentLogs.removeLast();
      }
    });
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }
}
