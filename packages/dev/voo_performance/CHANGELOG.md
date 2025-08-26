## 0.4.0

> Note: This release has breaking changes.

 - **REFACTOR**: remove deprecated performance sync entity and update plugin structure.
 - **REFACTOR**: Remove obsolete integration and widget tests; streamline HeatMapData and VooPerformance initialization.
 - **FEAT**: Refactor network list and performance list to use new empty state widget.
 - **FEAT**: Refactor NetworkList to support both log and request models.
 - **FEAT**: Update changelogs for voo_analytics, voo_core, voo_logging, and voo_performance packages to reflect deprecation and migration to voo_telemetry.
 - **FEAT**: Enhance topics in pubspec.yaml files for voo_analytics, voo_core, voo_logging, voo_performance, and voo_telemetry packages.
 - **FEAT**: Add comprehensive test suite and configuration for VooTelemetry package.
 - **FEAT**: Update package versions and descriptions; enhance import statements for consistency.
 - **FEAT**: Add cloud sync support for analytics and performance metrics; enhance VooAnalytics and VooPerformance plugins; update CHANGELOGs and tests.
 - **FEAT**: Implement cloud sync functionality for analytics, logging, and performance data; add SyncEntity and CloudSyncManager classes; update version to 0.1.0.
 - **FEAT**: Enhance package description and add additional metadata in pubspec.yaml.
 - **FEAT**: Update dependencies in pubspec.yaml; add dio package and remove duplicate entry.
 - **FEAT**: Add license files and update package versions to 0.0.1 for voo_core, voo_analytics, and voo_performance.
 - **FEAT**: Integrate Voo Analytics and Performance tracking; add example pages for analytics and performance metrics.
 - **FEAT**: Enhance Voo DevTools extension with heat map visualization and analytics improvements.
 - **FEAT**: Update package versions and enhance analytics, performance, and logging functionalities.
 - **FEAT**: Add analytics tracking and UI components to Voo DevTools extension.
 - **FEAT**: Add VooFlutter example app with integration and widget tests.
 - **FEAT**: Add logs and network details panels for improved logging functionality.
 - **BREAKING** **FEAT**(voo_telemetry): Complete OpenTelemetry migration for VooFlutter.

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