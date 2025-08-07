import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:voo_core/voo_core.dart';
import 'package:voo_performance/voo_performance.dart';

class PerformanceExamplePage extends StatefulWidget {
  const PerformanceExamplePage({super.key});

  @override
  State<PerformanceExamplePage> createState() => _PerformanceExamplePageState();
}

class _PerformanceExamplePageState extends State<PerformanceExamplePage> {
  final _dio = Dio();
  bool _isRunning = false;
  String _lastOperation = '';
  int _operationCount = 0;

  @override
  void initState() {
    super.initState();
    _initializePerformance();
  }

  Future<void> _initializePerformance() async {
    if (!VooPerformancePlugin.instance.isInitialized) {
      await Voo.initializeApp();
      await VooPerformancePlugin.instance.initialize();
    }

    // Add performance interceptor to Dio
    _dio.interceptors.add(PerformanceDioInterceptorImpl());
  }

  Future<void> _runCustomTrace(String name, int delayMs) async {
    setState(() {
      _isRunning = true;
      _lastOperation = 'Running $name';
    });

    await PerformanceTracker.track(
      operation: name,
      operationType: 'custom',
      action: () async {
        // Simulate some work
        await Future.delayed(Duration(milliseconds: delayMs));

        // Simulate some calculations
        for (var i = 0; i < 100000; i++) {
          // Performing calculations
        }
      },
      metrics: {'delay_ms': delayMs, 'complexity': 'medium'},
    );

    setState(() {
      _isRunning = false;
      _operationCount++;
      _lastOperation = 'Completed $name (${delayMs}ms)';
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Performance trace completed: $name'), duration: const Duration(seconds: 1)));
    }
  }

  Future<void> _runDatabaseSimulation() async {
    setState(() {
      _isRunning = true;
      _lastOperation = 'Simulating database operations';
    });

    // Simulate multiple database operations
    for (var i = 0; i < 5; i++) {
      await PerformanceTracker.track(
        operation: 'database_query_$i',
        operationType: 'database',
        action: () async {
          final delay = Random().nextInt(200) + 50;
          await Future.delayed(Duration(milliseconds: delay));
        },
        metrics: {'query_id': i, 'table': 'users', 'operation': i % 2 == 0 ? 'SELECT' : 'UPDATE'},
      );
    }

    setState(() {
      _isRunning = false;
      _operationCount += 5;
      _lastOperation = 'Completed database simulation';
    });
  }

  Future<void> _runNetworkRequests() async {
    setState(() {
      _isRunning = true;
      _lastOperation = 'Making network requests';
    });

    try {
      // Make some test requests
      final urls = [
        'https://jsonplaceholder.typicode.com/posts/1',
        'https://jsonplaceholder.typicode.com/users/1',
        'https://jsonplaceholder.typicode.com/comments?postId=1',
      ];

      for (final url in urls) {
        try {
          await _dio.get(url);
          await Future.delayed(const Duration(milliseconds: 100));
        } catch (e) {
          // Ignore errors for demo
        }
      }
    } finally {
      setState(() {
        _isRunning = false;
        _operationCount += 3;
        _lastOperation = 'Completed network requests';
      });
    }
  }

  Future<void> _runComplexOperation() async {
    setState(() {
      _isRunning = true;
      _lastOperation = 'Running complex operation';
    });

    final trace = VooPerformancePlugin.instance.newTrace('complex_calculation');
    trace.start();
    trace.putAttribute('operation_type', 'calculation');
    trace.putAttribute('complexity', 'high');

    try {
      // Step 1: Data preparation
      trace.putMetric('step', 1);
      await Future.delayed(const Duration(milliseconds: 200));

      // Step 2: Processing
      trace.putMetric('step', 2);
      var result = 0;
      for (var i = 0; i < 1000000; i++) {
        result += i * Random().nextInt(10);
      }
      trace.putMetric('result', result);

      // Step 3: Finalization
      trace.putMetric('step', 3);
      await Future.delayed(const Duration(milliseconds: 100));
    } finally {
      trace.stop();
      setState(() {
        _isRunning = false;
        _operationCount++;
        _lastOperation = 'Completed complex operation';
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Performance Example'), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
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
                  Text('Performance Status', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (_isRunning) const CircularProgressIndicator() else const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_lastOperation.isEmpty ? 'Ready' : _lastOperation, style: Theme.of(context).textTheme.bodyLarge),
                            Text('Operations completed: $_operationCount', style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
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
                  Text('Custom Traces', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _isRunning ? null : () => _runCustomTrace('fast_operation', 100),
                    icon: const Icon(Icons.flash_on),
                    label: const Text('Fast Operation (100ms)'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _isRunning ? null : () => _runCustomTrace('medium_operation', 500),
                    icon: const Icon(Icons.speed),
                    label: const Text('Medium Operation (500ms)'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _isRunning ? null : () => _runCustomTrace('slow_operation', 2000),
                    icon: const Icon(Icons.hourglass_empty),
                    label: const Text('Slow Operation (2s)'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _isRunning ? null : _runComplexOperation,
                    icon: const Icon(Icons.memory),
                    label: const Text('Complex Calculation'),
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
                  Text('Database Simulation', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _isRunning ? null : _runDatabaseSimulation,
                    icon: const Icon(Icons.storage),
                    label: const Text('Run Database Operations'),
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
                  Text('Network Performance', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _isRunning ? null : _runNetworkRequests,
                    icon: const Icon(Icons.cloud_download),
                    label: const Text('Make API Requests'),
                  ),
                  const SizedBox(height: 8),
                  const Text('Network requests are automatically tracked with Dio interceptor', style: TextStyle(fontSize: 12)),
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
                    '3. Click on the "Performance" sub-tab\n'
                    '4. Performance metrics will appear in real-time\n'
                    '5. View average durations and filter by operation type',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );

  @override
  void dispose() {
    _dio.close();
    super.dispose();
  }
}
