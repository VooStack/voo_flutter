# Changelog

## [0.1.0] - 2024-08-20

* Added WASM support for web platform
* Improved documentation and API comments
* Added comprehensive examples
* Enhanced pub.dev score compliance
* Performance optimizations
* Enhanced OTLP export capabilities
* Improved trace and metric collection

## [0.0.1] - 2024-01-15

### 🎉 Major Release - Complete OpenTelemetry Implementation

This is a complete rewrite of the VooFlutter telemetry system to align with OpenTelemetry standards and integrate with the new DevStack OTLP API.

### ✨ New Features

- **Full OpenTelemetry Support**: Complete implementation of traces, metrics, and logs following OTLP specification
- **OTLP Export**: Native OTLP/HTTP export with JSON encoding (gRPC coming soon)
- **Unified API**: Single `VooTelemetry` entry point for all telemetry operations
- **Context Propagation**: W3C Trace Context support for distributed tracing
- **Automatic Instrumentation**: Built-in support for HTTP and Dio clients
- **Batch Processing**: Intelligent batching with configurable intervals and sizes
- **Resource Attributes**: Comprehensive resource identification and attributes
- **Error Tracking**: Automatic exception capture with stack traces
- **Performance Metrics**: Built-in instruments for counters, gauges, and histograms
- **Structured Logging**: OpenTelemetry-compliant log records with severity levels

### 🔄 Breaking Changes

- **Package Rename**: Consolidated from separate packages to unified `voo_telemetry`
- **API Changes**: Complete API redesign following OpenTelemetry conventions
- **Configuration**: New initialization API with OTLP endpoint configuration
- **Dependencies**: Removed legacy dependencies, added OTLP support libraries

### 🔧 Technical Improvements

- **Clean Architecture**: Separation of concerns with providers, exporters, and processors
- **Type Safety**: Strong typing throughout the API
- **Performance**: Optimized batching and export mechanisms
- **Reliability**: Automatic retry with exponential backoff
- **Debugging**: Comprehensive debug mode with detailed logging

### 📦 Migration Guide

#### Before (legacy packages)
```dart
VooLogger.initialize(apiKey: 'key', endpoint: 'url');
VooLogger.log('message');

VooAnalytics.trackEvent('event', properties: {});

VooPerformance.startTrace('trace');
```

#### After (v0.0.1)
```dart
await VooTelemetry.initialize(
  endpoint: 'https://your-api.com',
  apiKey: 'key',
  serviceName: 'app',
);

// Logging
VooTelemetry.instance.getLogger().info('message');

// Tracing
VooTelemetry.instance.getTracer().withSpan('operation', (span) async {
  // Your code
});

// Metrics
VooTelemetry.instance.getMeter().createCounter('events').increment();
```

### 🚀 DevStack API Integration

This version is designed to work with DevStack API which provides:
- Native OTLP ingestion endpoints
- GCP Cloud Operations integration
- Real-time telemetry processing
- PII redaction and compliance

### 📝 Documentation

- Comprehensive README with examples
- API documentation with dartdoc
- Integration guides for common scenarios
- Troubleshooting section

### 🐛 Known Issues

- gRPC export not yet implemented (use HTTP/JSON)
- Some advanced OpenTelemetry features pending implementation

### 🔮 Future Enhancements

- gRPC support for improved performance
- Additional instrumentations (SQLite, SharedPreferences)
- Sampling strategies configuration
- Offline storage with SQLite
- Custom exporters support

