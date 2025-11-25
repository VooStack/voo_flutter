import 'package:flutter/material.dart';
import 'package:voo_terminal/voo_terminal.dart';

/// Demo page for preview (read-only) terminal.
class PreviewDemoPage extends StatefulWidget {
  const PreviewDemoPage({super.key});

  @override
  State<PreviewDemoPage> createState() => _PreviewDemoPageState();
}

class _PreviewDemoPageState extends State<PreviewDemoPage> {
  final List<TerminalLine> _lines = [
    TerminalLine.system('VooTerminal Preview Demo'),
    TerminalLine.output(''),
    TerminalLine.output('This is a read-only terminal view.'),
    TerminalLine.output('Perfect for displaying logs, build output, or status messages.'),
    TerminalLine.output(''),
    TerminalLine.info('Starting application...'),
    TerminalLine.success('Database connected'),
    TerminalLine.success('Cache initialized'),
    TerminalLine.warning('Config file not found, using defaults'),
    TerminalLine.success('Server started on port 8080'),
    TerminalLine.output(''),
    TerminalLine.output('Press the button below to add more output.'),
  ];

  int _counter = 0;

  void _addLine() {
    setState(() {
      _counter++;
      final now = DateTime.now();
      _lines.add(TerminalLine.output(
        '[$_counter] New message at ${now.hour}:${now.minute}:${now.second}',
      ));
    });
  }

  void _addError() {
    setState(() {
      _lines.add(TerminalLine.error('Error: Something went wrong!'));
    });
  }

  void _addSuccess() {
    setState(() {
      _lines.add(TerminalLine.success('Operation completed successfully'));
    });
  }

  void _clear() {
    setState(() {
      _lines.clear();
      _lines.add(TerminalLine.system('Terminal cleared'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Terminal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clear,
            tooltip: 'Clear',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: VooTerminalPreview(
                lines: _lines,
                theme: VooTerminalTheme.modern(),
                showHeader: true,
                title: 'Application Output',
                showTimestamps: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton.icon(
                  onPressed: _addLine,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Output'),
                ),
                FilledButton.tonalIcon(
                  onPressed: _addSuccess,
                  icon: const Icon(Icons.check),
                  label: const Text('Success'),
                ),
                FilledButton.tonalIcon(
                  onPressed: _addError,
                  icon: const Icon(Icons.error_outline),
                  label: const Text('Error'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
