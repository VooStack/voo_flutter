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