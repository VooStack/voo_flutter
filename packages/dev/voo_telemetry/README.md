# VooTelemetry

[![pub package](https://img.shields.io/pub/v/voo_telemetry.svg)](https://pub.dev/packages/voo_telemetry)
[![Flutter](https://img.shields.io/badge/Flutter-%02%2002B.svg?logo=Flutter&logoColor=white)](https://flutter.dev)
[![OpenTelemetry](https://img.shields.io/badge/OpenTelemetry-Compliant-brightgreen)](https://opentelemetry.io)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A comprehensive OpenTelemetry SDK for Flutter applications, providing distributed tracing, metrics collection, and structured logging with OTLP (OpenTelemetry Protocol) export capabilities.

## Features

- 📊 **Full OpenTelemetry Support**: Traces, Metrics, and Logs
- 🚀 **Easy Integration**: Simple API for Flutter apps
- 🔄 **Automatic Batching**: Efficient data transmission
- 🎯 **Context Propagation**: W3C Trace Context support
- 📡 **OTLP Export**: HTTP/JSON and gRPC protocols
- 🔧 **Instrumentation**: Built-in instrumentations for HTTP, Dio, and more
- 💾 **Offline Support**: Local storage with automatic retry
- 🔐 **Secure**: API key authentication support

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  voo_telemetry: ^2.0.0
```

## Quick Start

### Initialize VooTelemetry

```dart
import 'package:voo_telemetry/voo_telemetry.dart';

void main() async {
  // Initialize with your OTLP endpoint
  await VooTelemetry.initialize(
    endpoint: 'https://your-api.com', // Your DevStack API endpoint
    apiKey: 'your-api-key', // Optional API key
    serviceName: 'my-flutter-app',
    serviceVersion: '1.0.0',
    debug: true, // Enable debug logging
  );
  
  runApp(MyApp());
}
```

### Using Traces

```dart
// Get a tracer
final tracer = VooTelemetry.instance.getTracer('my-component');

// Create spans
await tracer.withSpan('fetch-data', (span) async {
  span.setAttribute('user.id', userId);
  
  try {
    final data = await fetchData();
    span.setAttribute('data.count', data.length);
    return data;
  } catch (e, stackTrace) {
    span.recordException(e, stackTrace);
    rethrow;
  }
});

// Manual span management
final span = tracer.startSpan('manual-operation');
try {
  // Your code here
  span.setStatus(SpanStatus.ok());
} catch (e) {
  span.setStatus(SpanStatus.error(description: e.toString()));
} finally {
  span.end();
}
```

### Using Metrics

```dart
// Get a meter
final meter = VooTelemetry.instance.getMeter('my-metrics');

// Create instruments
final counter = meter.createCounter(
  'api_calls',
  description: 'Number of API calls',
  unit: 'calls',
);

final histogram = meter.createHistogram(
  'response_time',
  description: 'API response time',
  unit: 'ms',
);

// Record metrics
counter.add(1, attributes: {'endpoint': '/users'});
histogram.record(responseTime, attributes: {'status': '200'});
```

### Using Logs

```dart
// Get a logger
final logger = VooTelemetry.instance.getLogger('my-logger');

// Log messages
logger.info('User logged in', attributes: {'user.id': userId});
logger.warn('API rate limit approaching');
logger.error('Failed to fetch data', 
  error: exception,
  stackTrace: stackTrace,
  attributes: {'endpoint': '/api/data'},
);
```

## HTTP Instrumentation

### With Dio

```dart
import 'package:dio/dio.dart';

final dio = Dio();

// Add telemetry interceptor
dio.interceptors.add(VooTelemetryDioInterceptor());

// All HTTP calls will be automatically traced
final response = await dio.get('https://api.example.com/data');
```

### With http package

```dart
import 'package:http/http.dart' as http;

// Wrap your HTTP client
final client = VooTelemetryHttpClient(http.Client());

// All HTTP calls will be automatically traced
final response = await client.get(Uri.parse('https://api.example.com/data'));
```

## Advanced Configuration

```dart
await VooTelemetry.initialize(
  endpoint: 'https://your-api.com',
  apiKey: 'your-api-key',
  serviceName: 'my-app',
  serviceVersion: '1.0.0',
  additionalAttributes: {
    'deployment.environment': 'production',
    'team': 'mobile',
    'region': 'us-west-2',
  },
  batchInterval: Duration(seconds: 60), // Batch export interval
  maxBatchSize: 500, // Maximum batch size
  debug: false,
);
```

## Context Propagation

VooTelemetry automatically propagates trace context through async operations:

```dart
final tracer = VooTelemetry.instance.getTracer();

await tracer.withSpan('parent-operation', (parentSpan) async {
  // This span will be a child of parent-operation
  await tracer.withSpan('child-operation', (childSpan) async {
    // Nested operation
  });
});
```

## Error Handling

VooTelemetry provides comprehensive error tracking:

```dart
try {
  await riskyOperation();
} catch (e, stackTrace) {
  // Record exception with context
  VooTelemetry.instance.recordException(
    e, 
    stackTrace,
    attributes: {
      'operation': 'risky_operation',
      'user.id': currentUserId,
    },
  );
}
```

## Performance Monitoring

Track performance metrics automatically:

```dart
final meter = VooTelemetry.instance.getMeter();
final timer = meter.createHistogram('operation_duration', unit: 'ms');

final stopwatch = Stopwatch()..start();
try {
  await performOperation();
} finally {
  stopwatch.stop();
  timer.record(
    stopwatch.elapsedMilliseconds.toDouble(),
    attributes: {'operation': 'data_processing'},
  );
}
```

## Shutdown

Properly shutdown VooTelemetry when your app terminates:

```dart
@override
void dispose() {
  VooTelemetry.shutdown();
  super.dispose();
}
```

## Integration with DevStack API

VooTelemetry is designed to work seamlessly with the DevStack OpenTelemetry API:

1. **Deploy DevStack API**: Follow the DevStack deployment guide
2. **Configure Endpoint**: Use your DevStack API URL as the endpoint
3. **Set API Key**: Use the API key from your DevStack project
4. **View Telemetry**: Access your data through GCP Console or Grafana

## Environment Variables

You can configure VooTelemetry using environment variables:

- `OTEL_SERVICE_NAME`: Service name
- `OTEL_SERVICE_VERSION`: Service version
- `OTEL_EXPORTER_OTLP_ENDPOINT`: OTLP endpoint URL
- `OTEL_EXPORTER_OTLP_HEADERS`: Additional headers
- `OTEL_RESOURCE_ATTRIBUTES`: Resource attributes

## Best Practices

1. **Initialize Early**: Initialize VooTelemetry as early as possible in your app lifecycle
2. **Use Semantic Attributes**: Follow OpenTelemetry semantic conventions
3. **Batch Operations**: Let VooTelemetry handle batching for efficiency
4. **Handle Errors**: Always record exceptions with context
5. **Clean Shutdown**: Ensure proper shutdown to flush pending data

## Troubleshooting

### Debug Mode

Enable debug mode to see detailed logs:

```dart
await VooTelemetry.initialize(
  // ... other config
  debug: true,
);
```

### Check Connectivity

Verify endpoint connectivity:

```dart
final exporter = VooTelemetry.instance.exporter;
// Check if exports are successful
```

### Common Issues

- **No data appearing**: Check endpoint URL and API key
- **High memory usage**: Reduce batch size or flush interval
- **Network errors**: Ensure proper network permissions

## Contributing

Contributions are welcome! Please read our contributing guidelines before submitting PRs.

## License

MIT License - see LICENSE file for details

## Support

For issues and questions:
- GitHub Issues: [voo_telemetry/issues](https://github.com/voostack/voo_flutter/issues)
- Documentation: [VooStack Docs](https://docs.voostack.com)