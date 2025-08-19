import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:voo_telemetry/voo_telemetry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize VooTelemetry with your DevStack API endpoint
  await VooTelemetry.initialize(
    endpoint: 'http://localhost:5000', // Replace with your DevStack API URL
    apiKey: 'your-api-key', // Optional: Add your API key
    serviceName: 'voo-example-app',
    serviceVersion: '2.0.0',
    additionalAttributes: {
      'deployment.environment': 'development',
      'app.platform': 'flutter',
    },
    debug: true,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'VooTelemetry Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TelemetryDemoPage(),
    );
}

class TelemetryDemoPage extends StatefulWidget {
  const TelemetryDemoPage({super.key});

  @override
  State<TelemetryDemoPage> createState() => _TelemetryDemoPageState();
}

class _TelemetryDemoPageState extends State<TelemetryDemoPage> {
  final _tracer = VooTelemetry.instance.getTracer('demo-app');
  final _meter = VooTelemetry.instance.getMeter('demo-metrics');
  final _logger = VooTelemetry.instance.getLogger('demo-logger');
  
  late final Counter _buttonClickCounter;
  late final Histogram _operationDuration;
  late final Gauge _activeUsers;
  
  int _clickCount = 0;
  String _status = 'Ready';
  
  @override
  void initState() {
    super.initState();
    
    // Initialize metrics instruments
    _buttonClickCounter = _meter.createCounter(
      'button_clicks',
      description: 'Number of button clicks',
      unit: 'clicks',
    );
    
    _operationDuration = _meter.createHistogram(
      'operation_duration',
      description: 'Duration of operations',
      unit: 'ms',
    );
    
    _activeUsers = _meter.createGauge(
      'active_users',
      description: 'Number of active users',
    );
    
    // Set initial gauge value
    _activeUsers.set(1);
    
    // Log app startup
    _logger.info('Application started', attributes: {
      'screen': 'TelemetryDemoPage',
      'platform': Theme.of(context).platform.toString(),
    });
  }
  
  Future<void> _performTracedOperation() async {
    setState(() => _status = 'Running traced operation...');
    
    try {
      await _tracer.withSpan('demo-operation', (span) async {
        span.setAttribute('user.action', 'button_click');
        span.setAttribute('click.count', _clickCount);
        
        // Simulate some work
        span.addEvent('Starting processing');
        await Future<void>.delayed(const Duration(milliseconds: 500));
        
        span.addEvent('Fetching data');
        await _fetchData(span);
        
        span.addEvent('Processing complete');
        
        setState(() => _status = 'Operation completed successfully');
      });
    } catch (e, stackTrace) {
      setState(() => _status = 'Operation failed: $e');
      _logger.error('Operation failed', error: e, stackTrace: stackTrace);
    }
  }
  
  Future<void> _fetchData(Span parentSpan) async {
    await _tracer.withSpan('fetch-data', (span) async {
      span.setAttribute('http.method', 'GET');
      span.setAttribute('http.url', 'https://jsonplaceholder.typicode.com/posts/1');
      
      final stopwatch = Stopwatch()..start();
      
      try {
        final dio = Dio();
        final response = await dio.get('https://jsonplaceholder.typicode.com/posts/1');
        
        span.setAttribute('http.status_code', response.statusCode);
        span.setAttribute('response.size', response.data.toString().length);
        
        _logger.info('Data fetched successfully', attributes: {
          'status_code': response.statusCode,
          'data_size': response.data.toString().length,
        });
      } finally {
        stopwatch.stop();
        _operationDuration.record(
          stopwatch.elapsedMilliseconds.toDouble(),
          attributes: {'operation': 'fetch_data'},
        );
      }
    }, kind: SpanKind.client);
  }
  
  void _recordMetrics() {
    setState(() {
      _clickCount++;
      _status = 'Recording metrics...';
    });
    
    // Record counter metric
    _buttonClickCounter.increment(attributes: {
      'button': 'record_metrics',
      'screen': 'demo',
    });
    
    // Record gauge metric
    _activeUsers.set(_clickCount.toDouble());
    
    // Log the action
    _logger.info('Metrics recorded', attributes: {
      'click_count': _clickCount,
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    setState(() => _status = 'Metrics recorded: $_clickCount clicks');
  }
  
  void _simulateError() {
    setState(() => _status = 'Simulating error...');
    
    try {
      // This will throw an error
      throw Exception('Simulated error for demonstration');
    } catch (e, stackTrace) {
      // Record the exception
      VooTelemetry.instance.recordException(
        e,
        stackTrace,
        attributes: {
          'error.simulated': true,
          'user.action': 'simulate_error_button',
        },
      );
      
      setState(() => _status = 'Error recorded and sent');
    }
  }
  
  Future<void> _flushTelemetry() async {
    setState(() => _status = 'Flushing telemetry data...');
    
    await VooTelemetry.instance.flush();
    
    setState(() => _status = 'Telemetry data flushed');
    
    _logger.info('Manual flush completed', attributes: {
      'click_count': _clickCount,
    });
  }
  
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('VooTelemetry Demo'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'OpenTelemetry Integration Demo',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              Text(
                'Status: $_status',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 10),
              Text(
                'Click count: $_clickCount',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 40),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _performTracedOperation,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Run Traced Operation'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _recordMetrics,
                    icon: const Icon(Icons.analytics),
                    label: const Text('Record Metrics'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _simulateError,
                    icon: const Icon(Icons.error_outline),
                    label: const Text('Simulate Error'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _flushTelemetry,
                    icon: const Icon(Icons.cloud_upload),
                    label: const Text('Flush Telemetry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Telemetry Types Demonstrated:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      const Text('✅ Distributed Tracing (Spans)'),
                      const Text('✅ Metrics (Counter, Histogram, Gauge)'),
                      const Text('✅ Structured Logging'),
                      const Text('✅ Exception Tracking'),
                      const Text('✅ Context Propagation'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to settings or info page
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('VooTelemetry Info'),
              content: const Text(
                'This demo app showcases the VooTelemetry package '
                'integration with OpenTelemetry.\n\n'
                'All telemetry data is sent to your configured '
                'DevStack API endpoint for processing and visualization.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
        tooltip: 'Info',
        child: const Icon(Icons.info_outline),
      ),
    );
  
  @override
  void dispose() {
    _logger.info('Application closing', attributes: {
      'total_clicks': _clickCount,
    });
    super.dispose();
  }
}