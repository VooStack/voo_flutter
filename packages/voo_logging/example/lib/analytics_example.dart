import 'package:flutter/material.dart';
import 'package:voo_analytics/voo_analytics.dart';
import 'package:voo_core/voo_core.dart';

class AnalyticsExamplePage extends StatefulWidget {
  const AnalyticsExamplePage({super.key});

  @override
  State<AnalyticsExamplePage> createState() => _AnalyticsExamplePageState();
}

class _AnalyticsExamplePageState extends State<AnalyticsExamplePage> {
  bool _trackingEnabled = true;
  int _tapCount = 0;
  int _eventCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnalytics();
  }

  Future<void> _initializeAnalytics() async {
    if (!VooAnalyticsPlugin.instance.isInitialized) {
      await Voo.initializeApp();
      await VooAnalyticsPlugin.instance.initialize();
    }
  }

  void _logCustomEvent(String eventName) {
    VooAnalyticsPlugin.instance.logEvent(
      eventName,
      parameters: {'screen': 'analytics_example', 'timestamp': DateTime.now().toIso8601String(), 'count': _eventCount++},
    );

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Event logged: $eventName'), duration: const Duration(seconds: 1)));
  }

  @override
  Widget build(BuildContext context) => TouchTrackerWidget(
    screenName: 'analytics_example',
    enabled: _trackingEnabled,
    child: Scaffold(
      appBar: AppBar(title: const Text('Analytics Example'), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Touch Tracking', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      title: const Text('Enable Touch Tracking'),
                      subtitle: const Text('Track all touch events on this screen'),
                      value: _trackingEnabled,
                      onChanged: (value) {
                        setState(() {
                          _trackingEnabled = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Tap anywhere on the screen to generate touch events'),
                    const SizedBox(height: 8),
                    const Text('Events are sent to DevTools in real-time'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Interactive Elements', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _tapCount++;
                        });
                        _logCustomEvent('button_tap');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Text('Tap Me! (Count: $_tapCount)', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 16)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(onPressed: () => _logCustomEvent('action_save'), icon: const Icon(Icons.save), label: const Text('Save')),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _logCustomEvent('action_share'),
                            icon: const Icon(Icons.share),
                            label: const Text('Share'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _logCustomEvent('action_delete'),
                            icon: const Icon(Icons.delete),
                            label: const Text('Delete'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(onPressed: () => _logCustomEvent('action_edit'), icon: const Icon(Icons.edit), label: const Text('Edit')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Custom Events', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 16),
                    ElevatedButton(onPressed: () => _logCustomEvent('page_view'), child: const Text('Log Page View')),
                    const SizedBox(height: 8),
                    ElevatedButton(onPressed: () => _logCustomEvent('user_action'), child: const Text('Log User Action')),
                    const SizedBox(height: 8),
                    ElevatedButton(onPressed: () => _logCustomEvent('feature_used'), child: const Text('Log Feature Usage')),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        VooAnalyticsPlugin.instance.logEvent(
                          'complex_event',
                          parameters: {
                            'user_id': 'user123',
                            'session_id': 'session456',
                            'screen': 'analytics_example',
                            'action': 'complex_action',
                            'value': 42,
                            'tags': ['important', 'tracked'],
                            'metadata': {'device': 'mobile', 'os': 'iOS', 'version': '1.0.0'},
                          },
                        );
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('Complex event logged with metadata'), duration: Duration(seconds: 1)));
                      },
                      child: const Text('Log Complex Event'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DevTools Integration', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 16),
                    const Text(
                      '1. Open Flutter DevTools\n'
                      '2. Navigate to the "Voo Logger" tab\n'
                      '3. Click on the "Analytics" sub-tab\n'
                      '4. Toggle between "Events" and "Heat Map" views\n'
                      '5. Touch events and custom events will appear in real-time',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
