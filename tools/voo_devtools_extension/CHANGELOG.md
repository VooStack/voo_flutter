## 1.1.1

### 🐛 Bug Fixes
* Fixed network request status display issue where completed requests with status codes (e.g., 200) remained showing as "Pending"
  * Corrected the merge logic in NetworkRequestModel to properly update isComplete and isInProgress flags based on merged status code

## 0.1.0

### 🎉 Major Features
* **Network Monitoring Tab** - New dedicated tab for monitoring HTTP requests and responses
  * Real-time network request tracking
  * Request/response details with headers and body
  * Status code indicators and timing information
  * Filter by method, status, and URL search
* **Performance Tab** - New dedicated tab for performance metrics
  * Track operation durations and identify bottlenecks
  * Average duration calculations per operation
  * Filter slow operations (>1s)
  * Visual performance indicators
* **Tab Navigation** - New tab-based navigation for better organization
  * Logs, Network, and Performance tabs
  * Clean tab switching with preserved state

### 🛠️ Improvements
* Enhanced atomic design architecture for all UI components
* Added specialized BLoCs for Network and Performance state management
* Created reusable atoms: NetworkMethodChip, NetworkStatusBadge, PerformanceIndicator
* Created filter bars specific to each tab's needs
* Added detailed panels for network and performance log inspection

### 🔧 Technical Changes
* Implemented NetworkBloc and PerformanceBloc for dedicated state management
* Created domain entities for NetworkLogEntry and PerformanceLogEntry
* Added proper filtering and search capabilities per tab
* Improved component reusability with atomic design patterns

## 0.0.11

* Fixed critical issue where extension wasn't receiving logs from VooLogger
* Major refactoring to follow clean architecture principles
* Split datasource into interface (domain layer) and implementation (data layer)
* Removed all debug logging for production-ready code
* Simplified VM Service connection with automatic retry mechanism
* Extension now properly receives and displays structured logs from VooLogger
* Removed unused files and unnecessary complexity
* Better separation of concerns with one class per file

## 0.0.10

* Documentation improvements

## 0.0.9

* Maintenance updates

## 0.0.8

* Removed debug logs from production builds

## 0.0.7

* Fixed loading issues

## 0.0.6

* Build configuration fixes

## 0.0.5

* Version alignment with main package

## 0.0.4

* Bug fixes and improvements

## 0.0.3

* Fixed log overflow issues

## 0.0.2

* Enhanced DevTools extension capabilities
* Added advanced filtering and search functionality

## 0.0.1

* Initial release
* Core DevTools extension functionality
* Real-time log viewing
* Filtering by level, category, and search