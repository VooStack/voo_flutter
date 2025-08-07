import 'package:flutter/material.dart';
import 'package:voo_analytics/voo_analytics.dart';
import 'package:voo_logging/voo_logging.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  late final AnalyticsRepository _analyticsRepository;
  List<TouchEvent> _touchEvents = [];
  Map<String, dynamic>? _heatMapData;
  bool _isTrackingEnabled = true;
  int _tapCount = 0;
  int _longPressCount = 0;
  int _swipeCount = 0;

  @override
  void initState() {
    super.initState();
    // Initialize analytics if not already done
    _initializeAnalytics();
  }
  
  Future<void> _initializeAnalytics() async {
    if (!VooAnalyticsPlugin.instance.isInitialized) {
      await VooAnalyticsPlugin.instance.initialize(
        enableTouchTracking: true,
        enableEventLogging: true,
        enableUserProperties: true,
      );
    }
    _analyticsRepository = VooAnalyticsPlugin.instance.repository!;
    _loadAnalyticsData();
  }

  Future<void> _loadAnalyticsData() async {
    // Get touch events from analytics repository
    final events = await _analyticsRepository.getTouchEvents();
    final heatMap = await _analyticsRepository.getHeatMapData();

    setState(() {
      _touchEvents = events.take(20).toList(); // Show last 20 events
      _heatMapData = heatMap;
    });
  }

  void _clearAnalytics() async {
    await _analyticsRepository.clearData();
    setState(() {
      _touchEvents = [];
      _heatMapData = null;
      _tapCount = 0;
      _longPressCount = 0;
      _swipeCount = 0;
    });
    await VooLogger.info('Analytics data cleared');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Analytics data cleared')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadAnalyticsData, tooltip: 'Refresh data'),
          IconButton(icon: const Icon(Icons.delete_sweep), onPressed: _clearAnalytics, tooltip: 'Clear analytics'),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tracking Toggle
            Card(
              child: SwitchListTile(
                title: const Text('Enable Touch Tracking'),
                subtitle: const Text('Track user interactions in real-time'),
                value: _isTrackingEnabled,
                onChanged: (value) {
                  setState(() {
                    _isTrackingEnabled = value;
                  });
                  VooLogger.info('Touch tracking ${value ? 'enabled' : 'disabled'}');
                },
              ),
            ),
            const SizedBox(height: 16),

            // Statistics
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Interaction Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard('Taps', _tapCount, Colors.blue),
                        _buildStatCard('Long Press', _longPressCount, Colors.orange),
                        _buildStatCard('Swipes', _swipeCount, Colors.green),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Interactive Area with TouchTracker
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Interactive Touch Area', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('Tap, long press, or swipe in the area below', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 16),
                    TouchTrackerWidget(
                      screenName: 'AnalyticsPage',
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [Colors.deepPurple.shade100, Colors.deepPurple.shade50], begin: Alignment.topLeft, end: Alignment.bottomRight),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.deepPurple.shade200, width: 2),
                        ),
                        child: Stack(
                          children: [
                            // Heat map visualization
                            if (_heatMapData != null) ..._buildHeatMapOverlay(),

                            // Instructions
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.touch_app, size: 48, color: Colors.deepPurple.shade300),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Touch here to track interactions',
                                    style: TextStyle(color: Colors.deepPurple.shade600, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Recent Events
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Recent Touch Events', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('${_touchEvents.length} events', style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_touchEvents.isEmpty)
                      const Center(
                        child: Padding(padding: EdgeInsets.all(32), child: Text('No touch events recorded yet')),
                      )
                    else
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemCount: _touchEvents.length,
                          itemBuilder: (context, index) {
                            final event = _touchEvents[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: _getEventColor(event.type),
                                child: Icon(_getEventIcon(event.type), color: Colors.white, size: 20),
                              ),
                              title: Text(event.type.name.toUpperCase()),
                              subtitle: Text('Position: (${event.position.dx.toStringAsFixed(1)}, ${event.position.dy.toStringAsFixed(1)}) • ${_formatTime(event.timestamp)}'),
                              dense: true,
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
      ),
    );
  }

  Widget _buildStatCard(String label, int value, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: Center(
            child: Text(
              value.toString(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  List<Widget> _buildHeatMapOverlay() {
    if (_heatMapData == null || _heatMapData!.isEmpty) return [];

    final points = _heatMapData!['points'] as List<dynamic>? ?? [];

    return points.map((point) {
      final pointMap = point as Map<String, dynamic>;
      final intensity = (pointMap['intensity'] ?? 0.5) as double;
      final x = (pointMap['x'] ?? 0.0) as double;
      final y = (pointMap['y'] ?? 0.0) as double;

      return Positioned(
        left: x - 10,
        top: y - 10,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red.withValues(alpha: intensity * 0.3),
          ),
        ),
      );
    }).toList();
  }

  Color _getEventColor(TouchType type) {
    switch (type) {
      case TouchType.tap:
        return Colors.blue;
      case TouchType.longPress:
        return Colors.orange;
      case TouchType.panStart:
      case TouchType.panUpdate:
      case TouchType.panEnd:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getEventIcon(TouchType type) {
    switch (type) {
      case TouchType.tap:
        return Icons.touch_app;
      case TouchType.longPress:
        return Icons.timer;
      case TouchType.panStart:
      case TouchType.panUpdate:
      case TouchType.panEnd:
        return Icons.swipe;
      default:
        return Icons.gesture;
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }
}
