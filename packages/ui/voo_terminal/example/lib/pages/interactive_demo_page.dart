import 'package:flutter/material.dart';
import 'package:voo_terminal/voo_terminal.dart';

/// Demo page for interactive terminal.
class InteractiveDemoPage extends StatefulWidget {
  const InteractiveDemoPage({super.key});

  @override
  State<InteractiveDemoPage> createState() => _InteractiveDemoPageState();
}

class _InteractiveDemoPageState extends State<InteractiveDemoPage> {
  late TerminalController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TerminalController(
      config: TerminalConfig.interactive(),
      commands: _buildCommands(),
    );

    // Add welcome message
    _controller.writeSystem('Welcome to VooTerminal Interactive Demo');
    _controller.writeLine('');
    _controller.writeLine('Type "help" to see available commands.');
    _controller.writeLine('Use arrow keys to navigate command history.');
    _controller.writeLine('');
  }

  List<TerminalCommand> _buildCommands() {
    return [
      TerminalCommand.simple(
        name: 'hello',
        aliases: ['hi', 'hey'],
        description: 'Say hello',
        usage: 'hello [name]',
        handler: (args) {
          final name = args.isNotEmpty ? args.join(' ') : 'World';
          return 'Hello, $name!';
        },
      ),
      TerminalCommand.simple(
        name: 'date',
        description: 'Show current date and time',
        handler: (_) => DateTime.now().toString(),
      ),
      TerminalCommand.simple(
        name: 'calc',
        aliases: ['math'],
        description: 'Simple calculator',
        usage: 'calc <num1> <op> <num2>',
        handler: (args) {
          if (args.length < 3) {
            return 'Usage: calc <num1> <op> <num2>\nExample: calc 5 + 3';
          }
          final a = double.tryParse(args[0]);
          final op = args[1];
          final b = double.tryParse(args[2]);

          if (a == null || b == null) {
            return 'Error: Invalid numbers';
          }

          switch (op) {
            case '+':
              return '${a + b}';
            case '-':
              return '${a - b}';
            case '*':
            case 'x':
              return '${a * b}';
            case '/':
              if (b == 0) return 'Error: Division by zero';
              return '${a / b}';
            default:
              return 'Error: Unknown operator "$op"';
          }
        },
      ),
      TerminalCommand.simple(
        name: 'fortune',
        description: 'Get a random fortune',
        handler: (_) {
          final fortunes = [
            'A journey of a thousand miles begins with a single step.',
            'The best time to plant a tree was 20 years ago. The second best time is now.',
            'Code is like humor. When you have to explain it, it\'s bad.',
            'First, solve the problem. Then, write the code.',
            'Simplicity is the soul of efficiency.',
            'Any fool can write code that a computer can understand. Good programmers write code that humans can understand.',
          ];
          return fortunes[DateTime.now().millisecond % fortunes.length];
        },
      ),
      TerminalCommand.simple(
        name: 'cowsay',
        description: 'Make a cow say something',
        usage: 'cowsay <message>',
        handler: (args) {
          final message = args.isNotEmpty ? args.join(' ') : 'Moo!';
          final border = '-' * (message.length + 2);
          return '''
 $border
< $message >
 $border
        \\   ^__^
         \\  (oo)\\_______
            (__)\\       )\\/\\
                ||----w |
                ||     ||''';
        },
      ),
      TerminalCommand(
        name: 'countdown',
        description: 'Countdown from a number',
        usage: 'countdown <seconds>',
        handler: (args) async {
          if (args.isEmpty) {
            return const CommandResult.error('Usage: countdown <seconds>');
          }
          final seconds = int.tryParse(args[0]);
          if (seconds == null || seconds < 1 || seconds > 10) {
            return const CommandResult.error(
              'Please provide a number between 1 and 10',
            );
          }

          for (var i = seconds; i > 0; i--) {
            _controller.writeLine('$i...');
            await Future.delayed(const Duration(seconds: 1));
          }
          return const CommandResult.success('Blast off! 🚀');
        },
      ),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Terminal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              _controller.clear();
              _controller.writeSystem('Terminal cleared');
            },
            tooltip: 'Clear',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: VooTerminal(
          controller: _controller,
          config: TerminalConfig.interactive(
            prompt: r'$ ',
            showTimestamps: false,
          ),
          theme: VooTerminalTheme.classic(),
          showHeader: true,
          showWindowControls: true,
          title: 'bash - Terminal',
        ),
      ),
    );
  }
}
