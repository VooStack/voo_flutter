## 0.0.14

* **BREAKING**: VooDioInterceptor methods now return `void` instead of `Future<void>` for proper Dio compatibility
* Enhanced network interceptor to properly track request and response data separately
* Added proper request body tracking as `requestBody` in metadata
* Added proper response body tracking as `responseBody` in metadata
* Fixed DevTools extension to display both request and response bodies in network details
* Added comprehensive Dio example with multiple test scenarios
* Added extensive test coverage for VooDioInterceptor
* Fixed type casting error in network interceptor for response body
* Improved header tracking for both requests and responses

## 0.0.13

* Added network monitoring tab with request/response tracking
* Added performance monitoring tab with metrics visualization
* Improved UI components with consistent spacing constants
* Enhanced state management for tab switching to maintain state
* Updated padding and layout across all components for better UI consistency
* Improved DevTools extension with dedicated network and performance features

## 0.0.12

* Fixed category filtering in DevTools extension to show all unique categories from logs
* Removed duplicate "All" option in category dropdown filter
* Categories are now properly extracted from all logs instead of just filtered logs
* Category list updates dynamically when new logs with new categories are received
* "All" category option now correctly shows all logs regardless of category

## 0.0.11

* Fixed DevTools extension not receiving logs from VooLogger
* Refactored DevTools extension to follow clean architecture principles
* Split datasource into interface and implementation for better separation of concerns
* Removed all debug logging for cleaner production code
* Simplified VM Service connection with automatic retry mechanism
* DevTools extension now properly listens to structured logs via VM Service streaming
* Removed unused stub implementations and unnecessary files

## 0.0.10

* Added CLAUDE.md to .gitignore to prevent committing documentation files
* Improved documentation and development instructions

## 0.0.9

* Release updates and maintenance improvements

## 0.0.8

* Removed test/debug logging that was appearing in production
* Removed polling test logs from DevTools extension
* Cleaned up unnecessary debug log statements

## 0.0.7

* Fixed DevTools extension loading issue for published package
* Corrected .pubignore to include main.dart.js in published package
* Ensured all extension build files are properly distributed

## 0.0.6

* fixed .gitignore to allow build folder for dev tools output

## 0.0.5

* aligned versions to match (logging => dev tools)
  
## 0.0.4

* bumped dev tools extension version

## 0.0.3

* Fixed bugs related to logging overflow in dev tools

## 0.0.2

* Add Voo Logger DevTools extension with advanced logging capabilities
* Enhance documentation with detailed installation and usage instructions
* Add automated release workflows for pub.dev publishing
* Update dependencies for improved compatibility
* Refactor code for better readability and consistency
* Add comprehensive CI/CD workflow with devtools extension support
* Improve project structure and analysis options

## 0.0.1

* Initial release
* Core logging functionality with multiple log levels
* Persistent storage using Sembast
* Session and user tracking
* DevTools extension for log viewing and filtering
* Support for categories, tags, and metadata
* Export functionality (JSON, CSV)
* Cross-platform support (iOS, Android, Web, Desktop)
