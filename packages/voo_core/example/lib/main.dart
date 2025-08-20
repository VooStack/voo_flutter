import 'package:flutter/material.dart';
import 'package:voo_core/voo_core.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voo Core Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _platformInfo = '';

  @override
  void initState() {
    super.initState();
    _initializeVoo();
  }

  Future<void> _initializeVoo() async {
    // Initialize Voo with options
    await Voo.initializeApp(
      options: const VooOptions(appName: 'VooCore Example'),
    );

    // Get platform information
    final isWeb = PlatformUtils.isWeb;
    final isMobile = PlatformUtils.isMobile;
    final isDesktop = PlatformUtils.isDesktop;

    setState(() {
      _platformInfo =
          '''
Is Web: $isWeb
Is Mobile: $isMobile
Is Desktop: $isDesktop
      ''';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Voo Core Example'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Voo Core Platform Detection',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _platformInfo,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Example of using VooException
                  try {
                    throw const VooException(
                      'This is a test exception',
                      code: 'TEST_ERROR',
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Caught exception: $e')),
                    );
                  }
                },
                child: const Text('Test VooException'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Example of analytics event
                  final event = AnalyticsEvent(
                    name: 'button_clicked',
                    parameters: {
                      'button': 'test_analytics',
                      'timestamp': DateTime.now().toIso8601String(),
                    },
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Analytics event: ${event.name}')),
                  );
                },
                child: const Text('Test Analytics Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
