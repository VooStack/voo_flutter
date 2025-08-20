## 0.3.0

* Added WASM support for web platform
* Improved documentation and API comments
* Added comprehensive examples
* Enhanced pub.dev score compliance
* Performance optimizations
* Restored active maintenance - package is no longer deprecated
* Enhanced network performance metrics
* Improved Dio interceptor integration

## 0.2.0

* Enhanced performance trace tracking
* Improved network metrics collection
* Better integration with DevTools extension
* Added custom performance traces

## 0.1.1

* Initial performance monitoring implementation
* Basic network metrics tracking
* Dio interceptor for automatic monitoring
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