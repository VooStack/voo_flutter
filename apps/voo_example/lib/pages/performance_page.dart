import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:voo_performance/voo_performance.dart';
import 'package:voo_logging/voo_logging.dart';

class PerformancePage extends StatefulWidget {
  const PerformancePage({super.key});

  @override
  State<PerformancePage> createState() => _PerformancePageState();
}

class _PerformancePageState extends State<PerformancePage> {
  PerformanceTrace? _currentTrace;
  final List<NetworkMetric> _networkMetrics = [];
  Timer? _simulationTimer;
  bool _isSimulating = false;

  // Performance metrics
  double _cpuUsage = 0.0;
  double _memoryUsage = 0.0;
  double _fps = 60.0;
  int _totalTraces = 0;
  double _averageResponseTime = 0.0;

  @override
  void initState() {
    super.initState();
    _startPerformanceMonitoring();
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }

  void _startPerformanceMonitoring() {
    // Simulate performance metrics updates
    _simulationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _cpuUsage = 20 + Random().nextDouble() * 30;
        _memoryUsage = 40 + Random().nextDouble() * 20;
        _fps = 55 + Random().nextDouble() * 5;
      });
    });
  }

  void _startTrace(String name) async {
    _currentTrace = VooPerformancePlugin.instance.newTrace(name);
    _currentTrace!.start();
    await VooLogger.info('Performance trace started: $name');

    if (mounted) {
      setState(() {
        _totalTraces++;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Trace "$name" started')));
    }
  }

  void _stopTrace() async {
    if (_currentTrace != null) {
      _currentTrace!.stop();
      final duration = _currentTrace!.duration;
      if (duration != null) {
        await VooLogger.info('Performance trace stopped: ${_currentTrace!.name} (${duration.inMilliseconds}ms)');

        // Update average response time
        if (mounted) {
          setState(() {
            _averageResponseTime = (_averageResponseTime * (_totalTraces - 1) + duration.inMilliseconds) / _totalTraces;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Trace stopped: ${duration.inMilliseconds}ms')));
        }
      }

      _currentTrace = null;
    }
  }

  void _simulateHeavyOperation() async {
    _startTrace('heavy_operation');

    if (mounted) {
      setState(() {
        _isSimulating = true;
      });
    }

    await VooLogger.info('Starting heavy operation simulation');

    // Simulate heavy computation using PerformanceTracker
    await PerformanceTracker.track<void>(
      operation: 'heavy_computation',
      operationType: 'computation',
      metrics: {'iterations': 5},
      action: () async {
        await Future.delayed(const Duration(seconds: 2));

        // Generate some metrics
        for (int i = 0; i < 5; i++) {
          await Future.delayed(const Duration(milliseconds: 200));
          if (_currentTrace != null) {
            _currentTrace!.putMetric('step_$i', (Random().nextDouble() * 100).toInt());
          }
        }
      },
    );

    _stopTrace();

    if (mounted) {
      setState(() {
        _isSimulating = false;
      });
    }

    await VooLogger.info('Heavy operation completed');
  }

  void _simulateNetworkRequest() async {
    _startTrace('network_request');

    final startTime = DateTime.now();

    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500 + Random().nextInt(1500)));

    final endTime = DateTime.now();
    final responseDuration = endTime.difference(startTime);

    final metric = NetworkMetric(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      url: 'https://api.example.com/data/${Random().nextInt(100)}',
      method: ['GET', 'POST', 'PUT', 'DELETE'][Random().nextInt(4)],
      statusCode: [200, 201, 400, 404, 500][Random().nextInt(5)],
      duration: responseDuration,
      requestSize: Random().nextInt(1000) + 100,
      responseSize: Random().nextInt(5000) + 500,
      timestamp: DateTime.now(),
    );

    if (mounted) {
      setState(() {
        _networkMetrics.insert(0, metric);
        if (_networkMetrics.length > 10) {
          _networkMetrics.removeLast();
        }
      });
    }

    _stopTrace();

    await VooLogger.info('Network request completed: ${metric.method} ${metric.url} - ${metric.statusCode} (${metric.duration.inMilliseconds}ms)');
  }

  void _clearMetrics() async {
    if (mounted) {
      setState(() {
        _networkMetrics.clear();
        _totalTraces = 0;
        _averageResponseTime = 0.0;
      });
    }

    await VooLogger.info('Performance metrics cleared');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Metrics cleared')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [IconButton(icon: const Icon(Icons.delete_sweep), onPressed: _clearMetrics, tooltip: 'Clear metrics')],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Real-time Performance Metrics
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Real-time Performance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildMetricRow('CPU Usage', _cpuUsage, 100, Colors.blue),
                    const SizedBox(height: 12),
                    _buildMetricRow('Memory', _memoryUsage, 100, Colors.orange),
                    const SizedBox(height: 12),
                    _buildMetricRow('FPS', _fps, 60, Colors.green),
                  ],
                ),
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
                    const Text('Performance Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard('Total Traces', _totalTraces.toString(), Icons.timeline, Colors.purple),
                        _buildStatCard('Avg Response', '${_averageResponseTime.toStringAsFixed(0)}ms', Icons.speed, Colors.teal),
                        _buildStatCard('Network Calls', _networkMetrics.length.toString(), Icons.network_check, Colors.indigo),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Performance Testing Actions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Performance Testing', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _isSimulating ? null : _simulateHeavyOperation,
                          icon: _isSimulating ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.memory),
                          label: Text(_isSimulating ? 'Simulating...' : 'Heavy Operation'),
                        ),
                        ElevatedButton.icon(onPressed: _simulateNetworkRequest, icon: const Icon(Icons.cloud_download), label: const Text('Network Request')),
                        ElevatedButton.icon(
                          onPressed: () {
                            _startTrace('custom_trace');
                            Future.delayed(const Duration(seconds: 1), _stopTrace);
                          },
                          icon: const Icon(Icons.timer),
                          label: const Text('Custom Trace'),
                        ),
                      ],
                    ),
                    if (_currentTrace != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                            const SizedBox(width: 12),
                            Text('Active trace: ${_currentTrace!.name}'),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Network Metrics History
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Network Metrics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('${_networkMetrics.length} requests', style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_networkMetrics.isEmpty)
                      const Center(
                        child: Padding(padding: EdgeInsets.all(32), child: Text('No network metrics yet')),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _networkMetrics.length,
                        itemBuilder: (context, index) {
                          final metric = _networkMetrics[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(color: _getStatusColor(metric.statusCode).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: Text(
                                    metric.statusCode.toString(),
                                    style: TextStyle(color: _getStatusColor(metric.statusCode), fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ),
                              ),
                              title: Text('${metric.method} ${metric.url.split('/').last}', style: const TextStyle(fontSize: 14)),
                              subtitle: Text('${metric.duration.inMilliseconds}ms • ${_formatBytes(metric.responseSize ?? 0)}', style: const TextStyle(fontSize: 12)),
                              trailing: Text(_formatTime(metric.timestamp), style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                            ),
                          );
                        },
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

  Widget _buildMetricRow(String label, double value, double max, Color color) {
    final percentage = (value / max).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(
              label == 'FPS' ? value.toStringAsFixed(1) : '${value.toStringAsFixed(1)}%',
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(value: percentage, backgroundColor: color.withValues(alpha: 0.1), valueColor: AlwaysStoppedAnimation<Color>(color)),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }

  Color _getStatusColor(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) return Colors.green;
    if (statusCode >= 400 && statusCode < 500) return Colors.orange;
    if (statusCode >= 500) return Colors.red;
    return Colors.grey;
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }
}
