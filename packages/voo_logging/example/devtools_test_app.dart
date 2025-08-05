import 'package:flutter/material.dart';
import 'package:voo_logging/voo_logging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize VooLogger
  await VooLogger.initialize(appName: 'DevTools Test App', appVersion: '1.0.0');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'VooLogger DevTools Test',
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
    home: const MyHomePage(),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _generateLogs() {
    setState(() {
      _counter++;
    });

    // Generate various log levels
    VooLogger.verbose('Button pressed $_counter times', category: 'UI', tag: 'Button');
    VooLogger.debug('Debug info: counter = $_counter', category: 'Debug');
    VooLogger.info('User interaction logged', category: 'Analytics', metadata: {'action': 'button_press', 'counter': _counter});

    if (_counter % 3 == 0) {
      VooLogger.warning('Counter is divisible by 3!', category: 'Math');
    }

    if (_counter % 5 == 0) {
      VooLogger.error('Counter reached milestone: $_counter', category: 'Milestone');
    }

    if (_counter % 10 == 0) {
      VooLogger.fatal('Critical milestone reached!', category: 'Critical');
    }

    // Test performance logging
    VooLogger.performance('Button handler', const Duration(milliseconds: 50), metrics: {'counter': _counter});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: const Text('VooLogger DevTools Test')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Press the button to generate logs.', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          const Text('Open DevTools and navigate to the', style: TextStyle(fontSize: 16)),
          const Text('Voo Logger tab to see the logs.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          Text('Button pressed $_counter times', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: _generateLogs,
            icon: const Icon(Icons.bug_report),
            label: const Text('Generate Logs'),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
          ),
        ],
      ),
    ),
  );
}
