import 'package:flutter/material.dart';
import 'package:voo_core/voo_core.dart';
import 'package:voo_analytics/voo_analytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Voo
  await Voo.initializeApp(
    options: const VooOptions(appName: 'VooAnalytics Example'),
  );

  // Initialize VooAnalytics
  await VooAnalyticsPlugin.initialize(enableTouchTracking: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap app with RouteAwareTouchTracker for route-based analytics
    return RouteAwareTouchTracker(
      child: MaterialApp(
        title: 'Voo Analytics Example',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomePage(),
        navigatorObservers: [
          // Add route observer for analytics
          VooAnalyticsPlugin.instance.routeObserver,
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tapCount = 0;

  void _onTap(TapDownDetails details) {
    setState(() {
      _tapCount++;
    });

    // Touch events are automatically tracked by TouchTrackerWidget
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tap #$_tapCount at ${details.localPosition}'),
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TouchTrackerWidget(
      screenName: 'HomePage',
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Voo Analytics Example'),
        ),
        body: GestureDetector(
          onTapDown: _onTap,
          child: Container(
            color: Colors.transparent,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Tap anywhere to track touch events',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Total taps: $_tapCount',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DetailsPage(),
                        ),
                      );
                    },
                    child: const Text('Go to Details Page'),
                  ),
                  const SizedBox(height: 20),
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(Icons.touch_app, size: 48, color: Colors.blue),
                          SizedBox(height: 8),
                          Text(
                            'Touch Tracking Active',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'All touch events are being recorded\nfor heat map generation',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TouchTrackerWidget(
      screenName: 'DetailsPage',
      child: Scaffold(
        appBar: AppBar(title: const Text('Details Page')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'This is the details page',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              const Text(
                'Touch events on this page are also tracked',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
