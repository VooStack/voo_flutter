import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:voo_terminal/voo_terminal.dart';

/// Demo page for streaming log viewer.
class LogViewerDemoPage extends StatefulWidget {
  const LogViewerDemoPage({super.key});

  @override
  State<LogViewerDemoPage> createState() => _LogViewerDemoPageState();
}

class _LogViewerDemoPageState extends State<LogViewerDemoPage> {
  late TerminalController _controller;
  Timer? _logTimer;
  bool _isStreaming = false;
  final _random = Random();

  final _logMessages = [
    ('info', 'Processing request from client'),
    ('info', 'Query executed in 45ms'),
    ('success', 'User authentication successful'),
    ('warning', 'Cache miss for key: user_preferences'),
    ('info', 'Loading configuration from disk'),
    ('error', 'Connection timeout after 30s'),
    ('info', 'Received webhook payload'),
    ('success', 'Email sent successfully'),
    ('warning', 'Rate limit approaching: 90%'),
    ('debug', 'Parsing JSON response'),
    ('info', 'Session created: abc123'),
    ('error', 'Invalid API key provided'),
    ('success', 'Database backup completed'),
    ('warning', 'Deprecated API endpoint called'),
    ('info', 'File uploaded: document.pdf (2.5MB)'),
  ];

  @override
  void initState() {
    super.initState();
    _controller = TerminalController(
      config: TerminalConfig.preview(maxLines: 500),
    );

    _controller.writeSystem('Log Viewer Demo');
    _controller.writeLine('Press "Start Streaming" to begin receiving logs.');
  }

  void _toggleStreaming() {
    setState(() {
      _isStreaming = !_isStreaming;
    });

    if (_isStreaming) {
      _controller.writeLine('');
      _controller.writeSystem('Starting log stream...');
      _logTimer = Timer.periodic(
        Duration(milliseconds: 500 + _random.nextInt(1500)),
        (_) => _addRandomLog(),
      );
    } else {
      _logTimer?.cancel();
      _logTimer = null;
      _controller.writeSystem('Log stream paused');
    }
  }

  void _addRandomLog() {
    final log = _logMessages[_random.nextInt(_logMessages.length)];
    final (type, message) = log;
    final timestamp = DateTime.now();
    final formattedTime =
        '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}';

    switch (type) {
      case 'info':
        _controller.writeInfo('[$formattedTime] $message');
      case 'success':
        _controller.writeSuccess('[$formattedTime] $message');
      case 'warning':
        _controller.writeWarning('[$formattedTime] $message');
      case 'error':
        _controller.writeError('[$formattedTime] $message');
      case 'debug':
        _controller.writeDebug('[$formattedTime] $message');
    }
  }

  void _clearLogs() {
    _controller.clear();
    _controller.writeSystem('Logs cleared');
  }

  void _addBulkLogs() {
    _controller.writeSystem('Adding 50 log entries...');
    for (var i = 0; i < 50; i++) {
      _addRandomLog();
    }
    _controller.writeSystem('Done');
  }

  @override
  void dispose() {
    _logTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Viewer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.playlist_add),
            onPressed: _addBulkLogs,
            tooltip: 'Add 50 logs',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearLogs,
            tooltip: 'Clear',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: VooTerminal(
                controller: _controller,
                config: TerminalConfig.preview(
                  maxLines: 500,
                  autoScroll: true,
                ),
                theme: VooTerminalTheme.modern(),
                showHeader: true,
                title: 'Application Logs',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: _toggleStreaming,
                  icon: Icon(_isStreaming ? Icons.pause : Icons.play_arrow),
                  label: Text(_isStreaming ? 'Pause Streaming' : 'Start Streaming'),
                ),
                const SizedBox(width: 16),
                ListenableBuilder(
                  listenable: _controller,
                  builder: (context, _) {
                    return Text(
                      '${_controller.lineCount} lines',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.7),
                          ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
