# Voo Logging

[![Flutter Package CI](https://github.com/voostack/voo_logging/actions/workflows/dart.yml/badge.svg)](https://github.com/voostack/voo_logging/actions/workflows/dart.yml)
[![Publish](https://github.com/voostack/voo_logging/actions/workflows/publish.yml/badge.svg)](https://github.com/voostack/voo_logging/actions/workflows/publish.yml)
[![pub package](https://img.shields.io/pub/v/voo_logging.svg)](https://pub.dev/packages/voo_logging)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A comprehensive, production-ready logging package for Flutter and Dart applications with DevTools integration, persistent storage, and powerful filtering capabilities.

## 🚀 Features

- **🎯 Simple API** - Intuitive methods for different log levels (verbose, debug, info, warning, error, fatal)
- **🔧 DevTools Integration** - Real-time log viewing with dedicated Network and Performance tabs
- **💾 Persistent Storage** - Logs survive app restarts using Sembast database
- **🏷️ Rich Context** - Categories, tags, metadata, user tracking, and session management
- **⚡ High Performance** - Non-blocking async operations with efficient indexing
- **🌐 Network Monitoring** - Built-in network request/response logging with optional interceptors
- **📈 Performance Tracking** - Track operation durations and performance metrics
- **🌐 Cross-Platform** - Works on iOS, Android, Web, macOS, Windows, and Linux
- **📊 Statistics** - Built-in analytics for log patterns and error tracking
- **🔍 Advanced Filtering** - Filter by level, time range, category, tag, or text search
- **📤 Export Options** - Export logs as JSON or CSV for external analysis
- **🔌 Dio Integration** - Ready-to-use Dio interceptor for automatic network logging

## 📦 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  voo_logging: ^0.0.1
```

Then run:
```bash
flutter pub get
```

## 🎯 Quick Start

```dart
import 'package:voo_logging/voo_logging.dart';

void main() async {
  // Initialize the logger
  await VooLogger.initialize();
  
  // Start logging!
  VooLogger.info('App started successfully');
  
  runApp(MyApp());
}
```

## 📖 Usage Examples

### Basic Logging

```dart
// Different log levels
VooLogger.verbose('Detailed trace information');
VooLogger.debug('Debug information for development');
VooLogger.info('General information');
VooLogger.warning('Warning: This might be a problem');
VooLogger.error('Error occurred', error: exception, stackTrace: stack);
VooLogger.fatal('Fatal error - app might crash');
```

### Structured Logging with Context

```dart
// Log with categories and tags
VooLogger.info('User logged in',
  category: 'Auth',
  tag: 'login_success',
  metadata: {
    'userId': user.id,
    'method': 'email',
    'timestamp': DateTime.now().toIso8601String(),
  }
);

// Track API calls
VooLogger.debug('API Request',
  category: 'Network',
  tag: 'api_call',
  metadata: {
    'endpoint': '/api/users',
    'method': 'GET',
    'headers': headers,
  }
);

// Log errors with full context
VooLogger.error('Payment failed',
  category: 'Payment',
  tag: 'payment_error',
  error: exception,
  stackTrace: stackTrace,
  metadata: {
    'amount': 99.99,
    'currency': 'USD',
    'provider': 'stripe',
    'errorCode': 'insufficient_funds',
  }
);
```

### Network Request Monitoring

```dart
// Log network requests manually
await VooLogger.networkRequest(
  'GET',
  'https://api.example.com/users',
  headers: {'Authorization': 'Bearer token'},
  metadata: {'userId': 'user_123'}
);

// Log network responses
await VooLogger.networkResponse(
  200,
  'https://api.example.com/users',
  Duration(milliseconds: 456),
  headers: {'Content-Type': 'application/json'},
  contentLength: 2048,
  metadata: {'cached': false}
);

// Or use the NetworkInterceptor
final interceptor = VooNetworkInterceptor();
await interceptor.onRequest(
  method: 'POST',
  url: 'https://api.example.com/data',
  headers: headers,
  body: requestBody,
);
```

### Dio Integration

```dart
import 'package:dio/dio.dart';
import 'package:voo_logging/voo_logging.dart';

final dio = Dio();
final vooInterceptor = VooDioInterceptor();

// Add to Dio
dio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) => vooInterceptor.onRequest(options, handler),
  onResponse: (response, handler) => vooInterceptor.onResponse(response, handler),
  onError: (error, handler) => vooInterceptor.onError(error, handler),
));

// Now all Dio requests are automatically logged!
```

### Performance Tracking

```dart
// Log performance metrics directly
VooLogger.performance(
  'DatabaseQuery',
  Duration(milliseconds: 456),
  metrics: {
    'rowCount': 1000,
    'cacheHit': false,
    'queryType': 'SELECT'
  }
);

// Track async operations automatically
final result = await PerformanceTracker.track<String>(
  operation: 'FetchUserData',
  operationType: 'api',
  action: () async {
    // Your async code here
    final response = await api.getUser();
    return response.data;
  },
  metrics: {
    'endpoint': '/api/user',
    'method': 'GET'
  }
);

// Track synchronous operations
final sum = PerformanceTracker.trackSync<int>(
  operation: 'CalculateSum',
  operationType: 'computation',
  action: () {
    int sum = 0;
    for (int i = 0; i < 1000000; i++) {
      sum += i;
    }
    return sum;
  },
  metrics: {'iterations': 1000000}
);

// Manual tracking with PerformanceTracker
final tracker = PerformanceTracker(
  operation: 'DataProcessing',
  operationType: 'batch',
);
// ... do work ...
tracker.addMetric('processedItems', 500);
tracker.addMetric('errors', 0);
await tracker.complete();
```

### User and Session Tracking

```dart
// Set user context (persists across all logs)
VooLogger.setUserId('user_123');

// Start a new session
VooLogger.startNewSession();

// Clear user context on logout
VooLogger.clearUserId();
```

### Querying and Filtering Logs

```dart
// Get recent logs
final recentLogs = await VooLogger.getLogs(limit: 100);

// Filter by log level
final errors = await VooLogger.getLogsByLevel(LogLevel.error);
final warnings = await VooLogger.getLogsByLevel(LogLevel.warning);

// Filter by time range
final todayLogs = await VooLogger.getLogsByTimeRange(
  startTime: DateTime.now().subtract(Duration(days: 1)),
  endTime: DateTime.now(),
);

// Filter by category
final authLogs = await VooLogger.getLogsByCategory('Auth');

// Filter by tag
final loginLogs = await VooLogger.getLogsByTag('login_success');

// Search logs by text
final searchResults = await VooLogger.searchLogs('payment');

// Get logs for specific session
final sessionLogs = await VooLogger.getLogsBySession(sessionId);

// Get logs for specific user
final userLogs = await VooLogger.getLogsByUser('user_123');

// Get unique values for filtering
final categories = await VooLogger.getCategories();
final tags = await VooLogger.getTags();
final sessions = await VooLogger.getSessions();
```

### Statistics and Analytics

```dart
// Get log statistics
final stats = await VooLogger.getStatistics();

print('Total logs: ${stats.totalLogs}');
print('Logs by level: ${stats.logsByLevel}');
print('Logs by category: ${stats.logsByCategory}');
print('Error rate: ${stats.errorRate}%');
print('Most frequent categories: ${stats.topCategories}');
print('Most frequent tags: ${stats.topTags}');
```

### Exporting Logs

```dart
// Export as JSON
final jsonExport = await VooLogger.exportLogs(
  format: 'json',
  filter: LogFilter(
    levels: [LogLevel.error, LogLevel.fatal],
    startTime: DateTime.now().subtract(Duration(days: 7)),
  ),
);

// Export as CSV
final csvExport = await VooLogger.exportLogs(
  format: 'csv',
  filter: LogFilter(
    category: 'Payment',
  ),
);

// Save to file
final file = File('logs_export.json');
await file.writeAsString(jsonExport);
```

### Log Management

```dart
// Clear all logs
await VooLogger.clearLogs();

// Clear old logs (older than 30 days)
await VooLogger.clearOldLogs(days: 30);

// Get storage info
final storageInfo = await VooLogger.getStorageInfo();
print('Storage used: ${storageInfo.sizeInBytes} bytes');
print('Number of logs: ${storageInfo.logCount}');
```

## 🔧 DevTools Extension

The package includes a powerful DevTools extension for real-time log monitoring and analysis with dedicated tabs for different log types.

### Features:
- 📊 **Logs Tab** - Real-time log streaming with advanced filtering
- 🌐 **Network Tab** - Monitor HTTP requests/responses with timing and size info
- 📈 **Performance Tab** - Track operation durations and identify bottlenecks
- 🔍 Advanced filtering and search across all tabs
- 📊 Visual statistics and charts
- 🎨 Syntax highlighting for metadata
- 📤 Export functionality for all log types
- 🔄 Auto-scroll and pause options

### Using DevTools:
1. Run your app in debug mode
2. Open Flutter DevTools
3. Navigate to the "Voo Logger" tab
4. Switch between Logs, Network, and Performance tabs
5. Start monitoring your application!

## ⚙️ Configuration

### Custom Configuration

```dart
await VooLogger.initialize(
  config: VooLoggerConfig(
    // Maximum number of logs to keep
    maxLogs: 100000,
    
    // Auto-delete logs older than X days
    autoDeleteAfterDays: 30,
    
    // Enable/disable console output
    enableConsoleOutput: true,
    
    // Minimum level for console output
    consoleLogLevel: LogLevel.debug,
    
    // Enable/disable DevTools integration
    enableDevTools: true,
    
    // Custom log format
    logFormat: (log) => '[${log.level}] ${log.message}',
  ),
);
```

### Performance Considerations

- Logs are written asynchronously to avoid blocking the UI
- Automatic indexing on timestamp, level, category, and tag
- Configurable cache size and retention policies
- Efficient batch operations for bulk queries

## 🏗️ Architecture

The package follows clean architecture principles:

```
lib/
├── src/
│   ├── data/
│   │   ├── enums/          # LogLevel enum
│   │   ├── models/         # Data models
│   │   └── sources/        # Storage implementation
│   └── domain/
│       └── entities/       # Core entities
├── voo_logging.dart        # Public API
└── devtools_extension/     # DevTools integration
```

## 🧪 Testing

```dart
// Use InMemoryLogStorage for testing
testWidgets('test with logging', (tester) async {
  await VooLogger.initialize(useInMemoryStorage: true);
  
  // Your test code
  VooLogger.info('Test started');
  
  // Verify logs
  final logs = await VooLogger.getLogs();
  expect(logs.length, 1);
  expect(logs.first.message, 'Test started');
});
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📋 Roadmap

### 🎯 Core Features
- [ ] **Remote Logging Backend** - Send logs to remote servers with automatic retry and buffering
  - *Why:* Essential for production apps to centralize logs from multiple devices
  - *Use case:* Monitor app health across thousands of users in real-time
  
- [ ] **End-to-End Encryption** - Encrypt sensitive logs with AES-256 before storage
  - *Why:* Protect user privacy and comply with security requirements
  - *Use case:* Healthcare apps logging patient interactions, financial apps with transaction logs
  
- [ ] **Custom Storage Adapters** - Support for SQLite, Hive, Isar, and cloud storage (Firebase, AWS S3)
  - *Why:* Different apps have different storage needs and existing infrastructure
  - *Use case:* Use Isar for offline-first apps, Firebase for real-time sync, S3 for long-term archives
  
- [ ] **Smart Log Rotation** - Size-based, time-based, and count-based rotation strategies
  - *Why:* Prevent logs from consuming all device storage
  - *Use case:* Keep last 7 days or 100MB of logs, whichever comes first
  
- [ ] **Performance Monitoring** - Built-in performance metrics and flame graphs
  - *Why:* Logging shouldn't slow down your app, and you need to know if it does
  - *Use case:* Detect when logging is impacting frame rates or response times
  
- [ ] **Crash Reporting Integration** - Seamless integration with Sentry, Crashlytics, and Bugsnag
  - *Why:* Logs provide context for crashes, making debugging faster
  - *Use case:* Automatically attach last 100 logs to crash reports

### 🚀 Advanced Features
- [ ] **Log Replay** - Record and replay user sessions for debugging
  - *Why:* Reproduce bugs exactly as users experienced them
  - *Use case:* Customer reports issue → replay their exact session with logs
  
- [ ] **Real-time Log Streaming** - WebSocket-based live log streaming to DevTools
  - *Why:* Debug issues as they happen, not after the fact
  - *Use case:* Watch logs from beta testers' devices during testing sessions
  
- [ ] **AI-Powered Log Analysis** - Automatic pattern detection and anomaly alerts
  - *Why:* Humans can't watch millions of logs, but AI can spot patterns
  - *Use case:* "Unusual spike in payment errors from UK users in last hour"
  
- [ ] **Log Aggregation** - Combine logs from multiple devices/users for analysis
  - *Why:* Understand system-wide issues, not just individual problems
  - *Use case:* "Show all logs related to order #12345 across all microservices"
  
- [ ] **Custom Log Processors** - Plugin system for custom log transformation
  - *Why:* Every team has unique logging needs
  - *Use case:* Auto-tag logs with feature flags, A/B test variants, or user segments
  
- [ ] **Log Sampling** - Intelligent sampling for high-volume applications
  - *Why:* Reduce costs while maintaining visibility into issues
  - *Use case:* Log 1% of success cases but 100% of errors

### 🔧 Developer Experience
- [ ] **VS Code Extension** - View and filter logs directly in VS Code
  - *Why:* Stay in your editor while debugging
  - *Use case:* Click on error in editor → see related logs in sidebar
  
- [ ] **IntelliJ Plugin** - Full IDE integration for JetBrains products
  - *Why:* Android Studio and IntelliJ users need first-class support
  - *Use case:* Set breakpoints that capture surrounding logs
  
- [ ] **CLI Tool** - Command-line interface for log analysis and export
  - *Why:* Power users and CI/CD pipelines need scriptable access
  - *Use case:* `voo logs --level=error --last=1h | grep payment`
  
- [ ] **Log Templates** - Pre-built templates for common logging scenarios
  - *Why:* Standardize logging across teams without repetitive code
  - *Use case:* `@LogHttpRequest` automatically logs method, URL, duration, status
  
- [ ] **Annotation Support** - `@Log` annotations for automatic method logging
  - *Why:* Reduce boilerplate while ensuring consistent logging
  - *Use case:* `@LogExecution` logs method entry, exit, duration, and parameters
  
- [ ] **Code Generation** - Generate boilerplate logging code
  - *Why:* Consistency and time-saving for large codebases
  - *Use case:* Generate repository classes with built-in operation logging

### 📊 Analytics & Insights
- [ ] **Log Dashboard** - Web-based dashboard for log visualization
  - *Why:* Non-developers need to understand app health too
  - *Use case:* Product managers tracking feature adoption through logs
  
- [ ] **Custom Metrics** - Define and track custom business metrics
  - *Why:* Logs contain business intelligence, not just errors
  - *Use case:* Track conversion funnel drop-offs through log events
  
- [ ] **Alerting System** - Set up alerts for specific log patterns
  - *Why:* Be proactive, not reactive to issues
  - *Use case:* Alert when error rate exceeds 1% or response time > 2s
  
- [ ] **Log Correlation** - Correlate logs across microservices
  - *Why:* Modern apps are distributed, debugging should be too
  - *Use case:* Track a request from mobile app → API → database → response
  
- [ ] **Export to BI Tools** - Direct export to Tableau, PowerBI, etc.
  - *Why:* Leverage existing business intelligence infrastructure
  - *Use case:* Daily export of user behavior logs to data warehouse
  
- [ ] **Machine Learning** - Predictive analysis and trend detection
  - *Why:* Predict problems before they happen
  - *Use case:* "Memory leak detected, will cause crashes in ~2 hours"

### 🔐 Security & Compliance
- [ ] **GDPR Compliance** - Automatic PII detection and redaction
  - *Why:* Avoid massive fines and protect user privacy
  - *Use case:* Automatically redact email addresses, phone numbers from logs
  
- [ ] **Audit Trail** - Immutable audit logs with blockchain verification
  - *Why:* Prove compliance and detect tampering
  - *Use case:* Financial apps proving transaction logs haven't been altered
  
- [ ] **Role-Based Access** - Fine-grained access control for logs
  - *Why:* Not everyone should see all logs
  - *Use case:* Support sees user logs, developers see system logs
  
- [ ] **Log Retention Policies** - Automated compliance with data retention laws
  - *Why:* Different data has different legal requirements
  - *Use case:* Keep audit logs 7 years, user logs 90 days, delete PII after 30 days
  
- [ ] **Security Scanning** - Detect sensitive data in logs automatically
  - *Why:* Developers accidentally log passwords, API keys, etc.
  - *Use case:* Block logs containing patterns like API keys or credit cards

### 🌐 Platform Extensions
- [ ] **React Native Support** - Full support for React Native apps
  - *Why:* Huge ecosystem that needs quality logging
  - *Use case:* Single logging solution for React Native + native modules
  
- [ ] **Server-Side Dart** - Optimized for Dart backend applications
  - *Why:* Full-stack Dart is growing, needs unified logging
  - *Use case:* Correlate frontend and backend logs with same tool
  
- [ ] **Edge Computing** - Log processing at the edge with Cloudflare Workers
  - *Why:* Process logs closer to users for faster insights
  - *Use case:* Regional log aggregation without centralized bottlenecks
  
- [ ] **IoT Support** - Lightweight logging for IoT devices
  - *Why:* Constrained devices need efficient logging too
  - *Use case:* Smart home devices with 512KB RAM still get structured logging
  
- [ ] **Desktop Widgets** - Native desktop widgets for log monitoring
  - *Why:* Keep critical metrics always visible
  - *Use case:* Menu bar widget showing error count, system tray alerts

### 🎨 Visualization
- [ ] **Log Flow Diagrams** - Visualize log flow through your application
  - *Why:* Understand complex interactions visually
  - *Use case:* See how a user action triggers logs across 10 microservices
  
- [ ] **Heat Maps** - Visual representation of log density
  - *Why:* Spot patterns and anomalies at a glance
  - *Use case:* See which app features generate most errors by time of day
  
- [ ] **3D Log Explorer** - Navigate logs in 3D space by time/category
  - *Why:* Spatial navigation can reveal patterns 2D lists miss
  - *Use case:* Fly through a timeline of events leading to an outage
  
- [ ] **AR Log Viewer** - View logs in augmented reality
  - *Why:* Spatial debugging for IoT, servers, and mobile testing
  - *Use case:* Point phone at smart device to see its logs floating above it
  
- [ ] **Custom Themes** - Beautiful themes for DevTools extension
  - *Why:* Developers stare at logs all day, they should look good
  - *Use case:* Dark themes, high contrast, colorblind-friendly options

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with [Sembast](https://pub.dev/packages/sembast) for efficient local storage
- Inspired by enterprise logging solutions
- Thanks to the Flutter community for feedback and contributions

## 📞 Support

- 📧 Email: support@voostack.com
- 🐛 Issues: [GitHub Issues](https://github.com/voostack/voo_logging/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/voostack/voo_logging/discussions)

---

Made with ❤️ by [VooStack](https://voostack.com)