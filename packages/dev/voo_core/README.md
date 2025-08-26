# Voo Core

[![pub package](https://img.shields.io/pub/v/voo_core.svg)](https://pub.dev/packages/voo_core)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

The foundation package for the Voo Flutter ecosystem, providing core infrastructure for logging, analytics, and performance monitoring in Flutter applications. Part of the comprehensive Dev Stack toolkit for Flutter development.

## 🚀 Features

- **Plugin Architecture**: Extensible plugin system for modular functionality
- **Platform Utilities**: Cross-platform detection and configuration
- **Base Interceptors**: Network interceptor foundation for monitoring
- **Performance Metrics**: Core performance tracking interfaces
- **Analytics Events**: Standardized analytics event definitions
- **DevTools Extension**: Integrated Flutter DevTools extension for real-time monitoring
- **Exception Handling**: Unified exception management
- **Type-Safe Configuration**: Strongly typed configuration options

## 📦 Installation

```yaml
dependencies:
  voo_core: ^0.3.4
```

## 🎯 Quick Start

### Basic Setup

```dart
import 'package:voo_core/voo_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Voo Core
  await Voo.initializeApp(
    options: VooOptions(
      enableDebugLogging: true,
      autoRegisterPlugins: true,
    ),
  );
  
  runApp(MyApp());
}
```

### With Other Voo Packages

```dart
import 'package:voo_core/voo_core.dart';
import 'package:voo_logging/voo_logging.dart';
import 'package:voo_analytics/voo_analytics.dart';
import 'package:voo_performance/voo_performance.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize core
  await Voo.initializeApp();
  
  // Initialize plugins
  await VooLoggingPlugin.instance.initialize();
  await VooAnalyticsPlugin.instance.initialize();
  await VooPerformancePlugin.instance.initialize();
  
  runApp(MyApp());
}
```

## 🛠️ DevTools Extension

Voo Core includes a comprehensive DevTools extension that provides real-time monitoring and debugging capabilities for your Flutter applications.

### Features

- **Logging Tab**: View and filter application logs in real-time
- **Network Tab**: Monitor HTTP requests and responses with detailed inspection
- **Analytics Tab**: Track user interactions and analytics events
- **Performance Tab**: Analyze performance metrics and identify bottlenecks

### Enabling DevTools

The DevTools extension is automatically available when running your app in debug or profile mode. To access it:

1. Run your Flutter app in debug mode
2. Open Flutter DevTools (click the DevTools link in your IDE or run `flutter devtools`)
3. Navigate to the "Dev Stack" tab in DevTools
4. Start monitoring your app in real-time

### DevTools Configuration

```dart
await Voo.initializeApp(
  options: VooOptions(
    enableDevTools: true, // Enabled by default in debug mode
    devToolsPort: 9100,   // Optional: specify custom port
  ),
);
```

## 🔌 Plugin Architecture

### Creating Custom Plugins

Extend the Voo ecosystem with custom plugins:

```dart
class MyCustomPlugin extends VooPlugin {
  @override
  String get name => 'my_custom_plugin';
  
  @override
  String get version => '1.0.0';
  
  @override
  FutureOr<void> onCoreInitialized() async {
    // Initialization logic
    print('Plugin initialized: $name v$version');
  }
  
  @override
  void dispose() {
    // Cleanup resources
  }
}

// Register your plugin
void main() async {
  await Voo.initializeApp();
  Voo.registerPlugin(MyCustomPlugin());
  runApp(MyApp());
}
```

### Managing Plugins

```dart
// Check if a plugin is registered
if (Voo.hasPlugin('my_custom_plugin')) {
  // Get plugin instance
  final plugin = Voo.getPlugin<MyCustomPlugin>('my_custom_plugin');
  
  // Use plugin functionality
  plugin?.doSomething();
}

// Unregister a plugin
Voo.unregisterPlugin('my_custom_plugin');
```

## 🌐 Platform Utilities

Detect and respond to platform-specific requirements:

```dart
import 'package:voo_core/voo_core.dart';

void configurePlatform() {
  if (PlatformUtils.isMobile) {
    // Configure for mobile (iOS/Android)
    configureForMobile();
  } else if (PlatformUtils.isDesktop) {
    // Configure for desktop (Windows/macOS/Linux)
    configureForDesktop();
  } else if (PlatformUtils.isWeb) {
    // Configure for web
    configureForWeb();
  }
  
  print('Platform: ${PlatformUtils.platformName}');
  print('Is iOS: ${PlatformUtils.isIOS}');
  print('Is Android: ${PlatformUtils.isAndroid}');
}
```

## 🔄 Network Interceptors

Create custom network interceptors for monitoring and logging:

```dart
class CustomNetworkInterceptor extends BaseInterceptor {
  @override
  bool get enabled => true;
  
  @override
  FutureOr<void> onRequest({
    required String method,
    required String url,
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? metadata,
  }) async {
    print('Request: $method $url');
    // Custom request handling
  }
  
  @override
  FutureOr<void> onResponse({
    required int statusCode,
    required String url,
    required Duration duration,
    Map<String, String>? headers,
    dynamic body,
    int? contentLength,
    Map<String, dynamic>? metadata,
  }) async {
    print('Response: $statusCode from $url (${duration.inMilliseconds}ms)');
    // Custom response handling
  }
  
  @override
  FutureOr<void> onError({
    required String url,
    required Object error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  }) async {
    print('Error: $error for $url');
    // Custom error handling
  }
}
```

## 📊 Performance Metrics

Track and analyze performance metrics:

```dart
import 'package:voo_core/voo_core.dart';

// Define custom performance metrics
class CustomMetrics extends PerformanceMetrics {
  final String operation;
  final Duration duration;
  final Map<String, dynamic> metadata;
  
  CustomMetrics({
    required this.operation,
    required this.duration,
    this.metadata = const {},
  });
}

// Use with performance tracking packages
final metric = CustomMetrics(
  operation: 'database_query',
  duration: Duration(milliseconds: 150),
  metadata: {'query': 'SELECT * FROM users'},
);
```

## 🎯 Analytics Events

Define and track analytics events:

```dart
import 'package:voo_core/voo_core.dart';

// Create custom analytics events
class UserActionEvent extends AnalyticsEvent {
  @override
  String get name => 'user_action';
  
  @override
  Map<String, dynamic> get properties => {
    'action': 'button_click',
    'screen': 'home',
    'timestamp': DateTime.now().toIso8601String(),
  };
}

// Track events (when used with voo_analytics)
final event = UserActionEvent();
```

## ⚠️ Exception Handling

Unified exception handling across the Voo ecosystem:

```dart
import 'package:voo_core/voo_core.dart';

try {
  // Your code
} on VooException catch (e) {
  print('Voo exception: ${e.message}');
  print('Code: ${e.code}');
  if (e.details != null) {
    print('Details: ${e.details}');
  }
}

// Throw custom Voo exceptions
throw VooException(
  message: 'Something went wrong',
  code: 'CUSTOM_ERROR',
  details: {'userId': 123},
);
```

## 🔧 Configuration Options

### VooOptions

Complete configuration reference:

```dart
VooOptions(
  // Core settings
  enableDebugLogging: true,        // Enable debug logs
  autoRegisterPlugins: true,       // Auto-register plugins
  initializationTimeout: Duration(seconds: 10), // Init timeout
  
  // DevTools settings
  enableDevTools: true,            // Enable DevTools extension
  devToolsPort: 9100,              // Custom DevTools port
  
  // Custom configuration
  customConfig: {
    'feature_flag': true,
    'api_version': 'v2',
  },
)
```

## 📚 API Reference

### Voo Class

| Method | Description |
|--------|-------------|
| `initializeApp({VooOptions? options})` | Initialize Voo Core system |
| `registerPlugin(VooPlugin plugin)` | Register a plugin |
| `unregisterPlugin(String name)` | Unregister a plugin |
| `getPlugin<T>(String name)` | Get registered plugin by name |
| `hasPlugin(String name)` | Check if plugin is registered |
| `dispose()` | Cleanup all plugins and resources |

### VooPlugin Abstract Class

| Method/Property | Description |
|-----------------|-------------|
| `name` | Plugin unique identifier |
| `version` | Plugin version string |
| `onCoreInitialized()` | Called when core is initialized |
| `dispose()` | Cleanup plugin resources |

### PlatformUtils

| Property | Description |
|----------|-------------|
| `isWeb` | Running on web platform |
| `isMobile` | Running on mobile (iOS/Android) |
| `isDesktop` | Running on desktop |
| `isIOS` | Running on iOS |
| `isAndroid` | Running on Android |
| `isWindows` | Running on Windows |
| `isMacOS` | Running on macOS |
| `isLinux` | Running on Linux |
| `platformName` | Current platform name string |

## 🤝 Integration with Voo Packages

Voo Core seamlessly integrates with:

- **[voo_logging](https://pub.dev/packages/voo_logging)**: Comprehensive logging with persistent storage
- **[voo_analytics](https://pub.dev/packages/voo_analytics)**: User interaction tracking and heat maps
- **[voo_performance](https://pub.dev/packages/voo_performance)**: Performance monitoring and optimization

## 📝 Example Application

Check out the [complete example](https://github.com/voostack/voo_flutter/tree/main/apps/voo_example) demonstrating all Voo packages working together.

## 🐛 Debugging Tips

1. **Enable Debug Logging**: Set `enableDebugLogging: true` in VooOptions
2. **Use DevTools**: Access the Dev Stack tab in Flutter DevTools for real-time monitoring
3. **Check Plugin Registration**: Use `Voo.hasPlugin()` to verify plugins are loaded
4. **Platform-Specific Issues**: Use `PlatformUtils` to debug platform-specific behavior

## 📈 Performance Considerations

- Plugins are lazy-loaded to minimize startup impact
- DevTools extension only active in debug/profile modes
- Efficient memory management with automatic cleanup
- Minimal overhead when features are disabled

## 🔄 Migration Guide

### From 0.2.x to 0.3.x

```dart
// Old
await Voo.initialize();

// New
await Voo.initializeApp(
  options: VooOptions(
    // Your configuration
  ),
);
```

## 🤔 Troubleshooting

### DevTools Extension Not Showing

1. Ensure you're running in debug or profile mode
2. Check that the extension is built: `melos run build_devtools_extension`
3. Restart DevTools after building

### Plugin Not Registering

1. Verify `autoRegisterPlugins` is enabled
2. Ensure plugin is imported before `Voo.initializeApp()`
3. Check for initialization errors in console

## 📄 License

MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Contributing

Contributions are welcome! Please read our [contributing guidelines](https://github.com/voostack/voo_flutter/blob/main/CONTRIBUTING.md) before submitting PRs.

## 💬 Support

- 📧 Email: support@voostack.com
- 🐛 Issues: [GitHub Issues](https://github.com/voostack/voo_flutter/issues)
- 💬 Discord: [Join our community](https://discord.gg/voostack)

---

Built with ❤️ by [VooStack](https://voostack.com)