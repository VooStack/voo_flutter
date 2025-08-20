## 0.3.0

* Added WASM support for web platform
* Improved documentation and API comments
* Added comprehensive examples
* Enhanced pub.dev score compliance
* Performance optimizations
* Restored active maintenance - package is no longer deprecated
* Enhanced plugin architecture for better extensibility

## 0.2.0

* Improved plugin system architecture
* Added shared utilities and base classes
* Enhanced platform detection utilities
* Better integration with other voo packages

### Migration Guide

Replace in pubspec.yaml:
```yaml
# Before
dependencies:
  voo_core: ^0.1.4
  voo_logging: ^0.1.0
  voo_analytics: ^0.1.0
  voo_performance: ^0.1.0

# After
dependencies:
  voo_telemetry: ^2.0.0
```

## 0.1.4

* Fixed performance metrics routing to correct endpoint:
  - Added support for `performance_trace` and `network_metric` types
  - Properly route performance data to `/metrics/batch` endpoint
  - Format metrics with proper structure for DevStack API
* Enhanced metrics request formatting:
  - Include required fields (sessionId, deviceId, platform, appVersion)
  - Convert all tags to strings as required by API
  - Handle performance-specific fields (duration_ms, attributes)

## 0.1.3

* Fixed DateTime serialization in CloudSyncManager:
  - Convert DateTime objects to ISO 8601 strings for JSON serialization
  - Added `_sanitizeMetadata` helper to recursively handle DateTime in nested objects
* Fixed headers type to be `Map<String, String>` instead of `Map<String, dynamic>`
* Added default 'General' category for logs when category is null
* Improved error handling and debug logging

## 0.1.2

* Fixed CloudSyncManager to use correct DevStack API endpoints:
  - Logs sent to `/logs/batch`
  - Metrics sent to `/metrics/batch`
  - Errors sent to `/errors/batch`
  - Analytics events sent to `/analytics/events/batch`
* Improved telemetry batching by grouping items by type
* Enhanced error handling for individual endpoint failures

## 0.1.1

* Added DevStack API integration support
* Enhanced CloudSyncManager with comprehensive debug capabilities:
  - Debug mode with detailed logging
  - Debug log buffer for telemetry inspection
  - Sync status monitoring
  - Pretty-printed status display
* Added DevStackTelemetry helper class for easy DevStack configuration
* Added DevStackConfig for DevStack-specific settings
* Improved telemetry sync with better error reporting
* Added Organization ID support in headers
* Enhanced request body with project metadata
* Fixed linting issues - replaced print statements with debugPrint
* Added comprehensive documentation for DevStack integration

## 0.1.0

* **BREAKING CHANGE**: Minimum Flutter version is now 3.0.0
* Added optional cloud sync functionality for telemetry data
* Introduced CloudSyncManager for efficient batch data synchronization
* Added SyncEntity base class for syncable data
* Implemented SyncQueue with duplicate detection and retry logic
* Added persistent storage using Sembast database
* Enhanced VooOptions with cloud configuration:
  - `apiKey` for authentication
  - `apiEndpoint` for custom endpoints
  - `enableCloudSync` flag
  - `syncInterval` for periodic syncing
  - `batchSize` for efficient data transmission
* Improved initialization with automatic cloud sync setup
* Added support for offline-first data persistence
* Enhanced error handling and retry mechanisms

## 0.0.2

* Updated dependencies for improved compatibility
* Added core foundation utilities for Voo Flutter ecosystem
* Implemented base interceptor architecture
* Added platform utilities for cross-platform support
* Introduced VooOptions for configuration management
* Added VooPlugin base class for plugin architecture
* Implemented analytics event structure
* Added performance metrics foundation
* Improved exception handling with VooException
* Enhanced DevTools extension support

## 0.0.1

* Initial release
* Core foundation package for the Voo Flutter ecosystem
* Basic structure and utilities