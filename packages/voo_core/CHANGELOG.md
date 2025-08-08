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