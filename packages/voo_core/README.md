# Voo Core

The foundation package for the Voo Flutter ecosystem. This package provides the core initialization system and plugin architecture that all other Voo packages depend on.

## Features

- 🚀 Centralized initialization system
- 🔌 Plugin registration and management
- 🛠️ Shared utilities and base classes
- 📊 Performance metrics interfaces
- 🎯 Analytics event definitions

## Installation

```yaml
dependencies:
  voo_core: ^0.0.1
```

## Usage

### Basic Initialization

```dart
import 'package:voo_core/voo_core.dart';

void main() async {
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

### Using with Other Voo Packages

Voo Core is required by all other Voo packages. When you use packages like `voo_logging`, `voo_analytics`, or `voo_performance`, they will automatically register themselves with Voo Core:

```dart
import 'package:voo_core/voo_core.dart';
import 'package:voo_logging/voo_logging.dart';
import 'package:voo_analytics/voo_analytics.dart';
import 'package:voo_performance/voo_performance.dart';

void main() async {
  // Initialize core first
  await Voo.initializeApp();
  
  // Initialize only the packages you need
  await VooLoggingPlugin.instance.initialize();
  await VooAnalyticsPlugin.instance.initialize();
  await VooPerformancePlugin.instance.initialize();
  
  runApp(MyApp());
}
```

### Creating Custom Plugins

You can create your own plugins that integrate with the Voo ecosystem:

```dart
class MyCustomPlugin extends VooPlugin {
  @override
  String get name => 'my_custom_plugin';
  
  @override
  String get version => '1.0.0';
  
  @override
  FutureOr<void> onCoreInitialized() {
    // Called when Voo Core is initialized
    print('My plugin is ready!');
  }
  
  @override
  void dispose() {
    // Cleanup resources
  }
}

// Register your plugin
Voo.registerPlugin(MyCustomPlugin());
```

## Platform Utils

The package includes platform detection utilities:

```dart
import 'package:voo_core/voo_core.dart';

if (PlatformUtils.isMobile) {
  // Mobile-specific code
}

if (PlatformUtils.isWeb) {
  // Web-specific code
}

print('Running on: ${PlatformUtils.platformName}');
```

## Base Interceptor

Create network interceptors that work across all Voo packages:

```dart
class MyInterceptor extends BaseInterceptor {
  @override
  bool get enabled => true;
  
  @override
  FutureOr<void> onRequest({
    required String method,
    required String url,
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? metadata,
  }) {
    // Handle request
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
  }) {
    // Handle response
  }
  
  @override
  FutureOr<void> onError({
    required String url,
    required Object error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  }) {
    // Handle error
  }
}
```

## API Reference

### Voo Class

- `initializeApp({VooOptions? options})` - Initialize the Voo Core system
- `registerPlugin(VooPlugin plugin)` - Register a plugin
- `unregisterPlugin(String pluginName)` - Unregister a plugin
- `getPlugin<T>(String name)` - Get a registered plugin by name
- `hasPlugin(String name)` - Check if a plugin is registered
- `dispose()` - Dispose all plugins and cleanup

### VooOptions

- `enableDebugLogging` - Enable debug logging (default: true in debug mode)
- `autoRegisterPlugins` - Auto-register plugins when they're imported (default: true)
- `customConfig` - Custom configuration map
- `initializationTimeout` - Timeout for initialization (default: 10 seconds)

## License

MIT