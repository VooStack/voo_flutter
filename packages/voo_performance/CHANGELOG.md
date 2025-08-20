## 0.1.1

**⚠️ DEPRECATED: This package is deprecated. Please use `voo_telemetry` instead.**

* **BREAKING CHANGE**: Complete migration to OpenTelemetry standards
* **DEPRECATED**: All functionality moved to `voo_telemetry` package
* Use `voo_telemetry` for:
  - OpenTelemetry-compliant distributed tracing
  - Automatic instrumentation for HTTP, gRPC, and more
  - OTLP export to any compatible backend
  - Better performance and reliability

### Migration Guide

```dart
// Before
import 'package:voo_performance/voo_performance.dart';
VooPerformance.startTrace('operation');

// After
import 'package:voo_telemetry/voo_telemetry.dart';
final span = VooTelemetry.instance.getTracer().startSpan('operation');
```

## 0.1.0

* **BREAKING CHANGE**: Now requires voo_core ^0.1.0
* Added automatic cloud sync support for performance metrics
* Introduced PerformanceSyncEntity for cloud synchronization
* Integrated with CloudSyncManager from voo_core
* Performance traces and network metrics are automatically synced to cloud
* Added support for batch syncing of performance data
* Enhanced VooPerformancePlugin to support cloud sync
* Improved offline-first architecture with automatic retry
* Network metrics now include cloud sync capabilities

## 0.0.2

* Updated dependencies (voo_core ^0.0.2, voo_logging ^0.0.15)
* Implemented performance monitoring for Flutter applications
* Added PerformanceDioInterceptor for HTTP request/response tracking
* Created NetworkMetric entity for network performance data
* Implemented PerformanceTrace for custom performance measurements
* Added PerformanceTracker utility for centralized performance monitoring
* Enhanced integration with voo_logging for performance events
* Improved network request timing and metrics collection
* Added support for custom performance traces
* Integrated with DevTools for performance visualization

## 0.0.1

* Initial release
* Basic performance monitoring infrastructure
* Foundation for network and performance tracking