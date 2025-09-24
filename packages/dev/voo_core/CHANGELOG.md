## 0.4.3

 - **FEAT**: add example modules and run configurations for VooFlutter packages.

## 0.4.2

 - **FEAT**: Introduce voo_tokens package for design tokens and responsive utilities.

## 0.4.1

- **CHORE**: Update package dependencies to use version constraints
- **FIX**: Corrected version dependencies for better melos monorepo compatibility
- **CHORE**: Minor dependency adjustments for voo_responsive and voo_ui_core integration

## 0.4.0

> Note: This release has breaking changes.

 - **REFACTOR**: remove deprecated performance sync entity and update plugin structure.
 - **FEAT**: Update CHANGELOG and version for voo_core to 0.3.4; fix network request status display in DevTools extension.
 - **FEAT**: Update DevTools extension to improve network request handling and UI feedback, including timeout detection and enhanced loading indicators.
 - **FEAT**: Update cSpell words in settings, increment version to 0.3.2, and refactor network_bloc for improved readability.
 - **FEAT**: Update package versions and fix dev tools name in configuration.
 - **FEAT**: Refactor network list and performance list to use new empty state widget.
 - **FEAT**: Update changelogs for voo_analytics, voo_core, voo_logging, and voo_performance packages to reflect deprecation and migration to voo_telemetry.
 - **FEAT**: Enhance topics in pubspec.yaml files for voo_analytics, voo_core, voo_logging, voo_performance, and voo_telemetry packages.
 - **FEAT**: Add comprehensive test suite and configuration for VooTelemetry package.
 - **FEAT**: Update package versions and descriptions; enhance import statements for consistency.
 - **FEAT**: Add DevStack integration and telemetry support.
 - **FEAT**: Add DevStack integration guide and example app; enhance telemetry configuration and logging features.
 - **FEAT**: Enhance logging configuration with enableDevToolsJson option; update LogSyncEntity and SyncStorage for improved functionality.
 - **FEAT**: Add cloud sync support for analytics and performance metrics; enhance VooAnalytics and VooPerformance plugins; update CHANGELOGs and tests.
 - **FEAT**: Implement cloud sync functionality for analytics, logging, and performance data; add SyncEntity and CloudSyncManager classes; update version to 0.1.0.
 - **FEAT**: Add license files and update package versions to 0.0.1 for voo_core, voo_analytics, and voo_performance.
 - **FEAT**: Enhance Voo DevTools extension with heat map visualization and analytics improvements.
 - **FEAT**: Update package versions and enhance analytics, performance, and logging functionalities.
 - **FEAT**: Add analytics tracking and UI components to Voo DevTools extension.
 - **FEAT**: Add logs and network details panels for improved logging functionality.
 - **BREAKING** **FEAT**(voo_telemetry): Complete OpenTelemetry migration for VooFlutter.

## 0.3.4

* Fixed DevTools extension network request status display:
  - Fixed issue where completed requests with status codes remained showing as "Pending"
  - Corrected NetworkRequestModel merge logic to properly update completion flags

## 0.3.3

* Fixed DevTools extension network tab freezing issues:
  - Fixed CircularProgressIndicator blocking UI with AlwaysStoppedAnimation
  - Added null safety for pending request body formatting
  - Added timeout detection for requests pending >30 seconds
  - Enhanced UI feedback for pending and timeout states
  - Fixed freezing when clicking on incomplete network requests

## 0.3.2

* Updated DevTools extension branding from "Voo DevTools" to "Dev Stack"
* Fixed DevTools extension web configuration for local development
* Added proper Flutter buildConfig setup in index.html

## 0.3.1
 * fixed dev tools name to match the entire stack

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