## 0.4.2

 - **FEAT**: Introduce voo_tokens package for design tokens and responsive utilities.
 - **FEAT**: Enhance form components with configurable options and improved theming.

## 0.4.1

  fixed error causing repeated error in console ```DebugService: Error serving requestsError: Unsupported operation: Cannot send Null```

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
 - **FEAT**: Enhance logging configuration with enableDevToolsJson option; update LogSyncEntity and SyncStorage for improved functionality.
 - **FEAT**: Add cloud sync support for analytics and performance metrics; enhance VooAnalytics and VooPerformance plugins; update CHANGELOGs and tests.
 - **FEAT**: Implement cloud sync functionality for analytics, logging, and performance data; add SyncEntity and CloudSyncManager classes; update version to 0.1.0.
 - **FEAT**: Add license files and update package versions to 0.0.1 for voo_core, voo_analytics, and voo_performance.
 - **FEAT**: Implement route-aware touch tracking and heat map visualization; enhance analytics data collection and UI components.
 - **FEAT**: Enhance touch event logging and heat map visualization; improve coordinate normalization and rendering.
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
* Enhanced heat map visualization
* Improved touch event tracking

## 0.2.0

* Improved analytics event tracking
* Enhanced route-aware analytics
* Better integration with DevTools extension
* Added touch tracking widget components

## 0.1.1

* Initial analytics implementation
* Basic heat map functionality
* Touch event capture system
  - Better performance and reliability

### Migration Guide

```dart
// Before
import 'package:voo_analytics/voo_analytics.dart';
VooAnalytics.trackEvent('event_name', properties: {...});

// After
import 'package:voo_telemetry/voo_telemetry.dart';
VooTelemetry.instance.trackEvent('event_name', properties: {...});
```

## 0.1.0

* **BREAKING CHANGE**: Now requires voo_core ^0.1.0
* Added automatic cloud sync support for analytics events
* Introduced AnalyticsSyncEntity for cloud synchronization
* Integrated with CloudSyncManager from voo_core
* Analytics events and touch events are automatically synced to cloud
* Added support for batch syncing of analytics data
* Enhanced repository to support cloud sync without breaking existing functionality
* Improved offline-first architecture with automatic retry
* User properties and custom events are now cloud-syncable

## 0.0.2

* Updated dependencies (voo_core ^0.0.2, voo_logging ^0.0.15)
* Implemented heat map data tracking functionality
* Added touch event tracking for user interaction analytics
* Created TouchTrackerWidget for automatic touch tracking
* Implemented analytics repository with clean architecture
* Added support for heat map visualization data
* Enhanced integration with voo_logging for analytics events
* Improved JSON serialization for analytics data
* Added comprehensive analytics event structure

## 0.0.1

* Initial release
* Basic analytics infrastructure
* Foundation for heat map and touch tracking