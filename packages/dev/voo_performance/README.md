# Voo Performance

A comprehensive performance monitoring package for Flutter applications. Track network requests, measure custom performance traces, and optimize your app's performance.

## Features

- 🚀 Network request performance tracking
- ⏱️ Custom performance trace measurements
- 📊 Real-time performance metrics
- 🔌 Dio interceptor for automatic HTTP tracking
- 📈 Performance visualization in DevTools
- 🎯 Automatic performance bottleneck detection
- 📱 Cross-platform support

## Installation

```yaml
dependencies:
  voo_performance: ^0.0.2
```

## Usage

### Basic Setup

```dart
import 'package:voo_performance/voo_performance.dart';
import 'package:voo_core/voo_core.dart';

void main() async {
  // Initialize Voo Core first
  await Voo.initializeApp();
  
  // Initialize Performance Plugin
  await VooPerformancePlugin.instance.initialize();
  
  runApp(MyApp());
}
```

### Network Performance Tracking with Dio

Automatically track all HTTP requests made with Dio:

```dart
import 'package:dio/dio.dart';
import 'package:voo_performance/voo_performance.dart';

final dio = Dio();

// Add the performance interceptor
dio.interceptors.add(PerformanceDioInterceptor());

// Now all requests will be automatically tracked
final response = await dio.get('https://api.example.com/data');
```

### Custom Performance Traces

Measure custom operations in your app:

```dart
// Start a performance trace
final trace = VooPerformancePlugin.instance.startTrace('database_query');

// Set attributes on the trace
trace.setAttribute('query_type', 'select');
trace.setAttribute('table', 'users');

// Perform your operation
final results = await database.query('SELECT * FROM users');

// Add metrics
trace.setMetric('row_count', results.length);

// Stop the trace
await trace.stop();
```

### Automatic UI Performance Tracking

Track screen rendering and UI performance:

```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PerformanceTracker(
      traceName: 'my_screen_render',
      child: Scaffold(
        appBar: AppBar(title: Text('My Screen')),
        body: YourContent(),
      ),
    );
  }
}
```

### Performance Metrics

Access collected performance metrics:

```dart
// Get network metrics
final networkMetrics = await VooPerformancePlugin.instance.getNetworkMetrics(
  startTime: DateTime.now().subtract(Duration(hours: 1)),
  endTime: DateTime.now(),
);

for (final metric in networkMetrics) {
  print('${metric.url}: ${metric.duration}ms, ${metric.statusCode}');
}

// Get custom trace metrics
final traces = await VooPerformancePlugin.instance.getTraces(
  traceName: 'database_query',
);

for (final trace in traces) {
  print('${trace.name}: ${trace.duration}ms');
}
```

### Performance Thresholds and Alerts

Set performance thresholds to identify issues:

```dart
VooPerformancePlugin.instance.setThresholds(
  PerformanceThresholds(
    networkRequestWarning: Duration(seconds: 2),
    networkRequestCritical: Duration(seconds: 5),
    customTraceWarning: Duration(milliseconds: 500),
    customTraceCritical: Duration(seconds: 1),
  ),
);

// Listen for performance alerts
VooPerformancePlugin.instance.onPerformanceAlert.listen((alert) {
  print('Performance issue: ${alert.message}');
  print('Severity: ${alert.severity}');
  print('Details: ${alert.details}');
});
```

### Aggregated Performance Reports

Generate performance reports:

```dart
// Get daily performance summary
final report = await VooPerformancePlugin.instance.generateReport(
  reportType: ReportType.daily,
  date: DateTime.now(),
);

print('Average network latency: ${report.averageNetworkLatency}ms');
print('P95 latency: ${report.p95Latency}ms');
print('Total requests: ${report.totalRequests}');
print('Failed requests: ${report.failedRequests}');
print('Slowest endpoints: ${report.slowestEndpoints}');
```

### Export Performance Data

Export performance data for analysis:

```dart
// Export as JSON
final jsonData = await VooPerformancePlugin.instance.exportData(
  format: ExportFormat.json,
  startDate: DateTime.now().subtract(Duration(days: 7)),
  endDate: DateTime.now(),
);

// Export as CSV
final csvData = await VooPerformancePlugin.instance.exportData(
  format: ExportFormat.csv,
  includeTraces: true,
  includeNetworkMetrics: true,
);
```

## DevTools Integration

The package includes a DevTools extension that provides:

- Real-time performance monitoring dashboard
- Network request timeline with waterfall view
- Custom trace visualization
- Performance metrics charts
- Bottleneck identification
- Export functionality

To use the DevTools extension:

1. Run your app in debug mode
2. Open Flutter DevTools
3. Navigate to the "Voo Performance" tab
4. Monitor real-time performance metrics

## Configuration

Configure performance monitoring behavior:

```dart
VooPerformancePlugin.instance.configure(
  PerformanceConfig(
    enableNetworkTracking: true,
    enableCustomTraces: true,
    samplingRate: 1.0, // Track 100% of operations
    maxTracesDuration: Duration(minutes: 5), // Max trace duration
    autoCaptureHttpErrors: true,
    captureRequestHeaders: true,
    captureResponseHeaders: true,
    captureRequestBody: false, // Disable for privacy
    captureResponseBody: false, // Disable for privacy
  ),
);
```

## Best Practices

1. **Use meaningful trace names**: Make traces easy to identify in reports
2. **Set appropriate thresholds**: Configure thresholds based on your app's requirements
3. **Monitor critical paths**: Focus on user-facing operations
4. **Regular analysis**: Review performance reports regularly
5. **Clean up traces**: Always stop traces to avoid memory leaks

```dart
// Good practice: Use try-finally to ensure trace stops
final trace = VooPerformancePlugin.instance.startTrace('critical_operation');
try {
  await performCriticalOperation();
} finally {
  await trace.stop();
}
```

## Platform Support

| Platform | Supported | Notes |
|----------|-----------|-------|
| iOS      | ✅ | Full support |
| Android  | ✅ | Full support |
| Web      | ✅ | Full support with limitations |
| macOS    | ✅ | Full support |
| Windows  | ✅ | Full support |
| Linux    | ✅ | Full support |

## Example

See the [example](example/) directory for a complete sample application demonstrating all features.

## License

MIT