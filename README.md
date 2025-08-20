# VooFlutter

A comprehensive Flutter development toolkit that provides production-ready capabilities for logging, analytics, performance monitoring, and telemetry. Built with a Firebase-like architecture where all packages work locally by default, with optional cloud syncing through OpenTelemetry.

## Architecture

VooFlutter follows a plugin-based architecture similar to Firebase:

- **`voo_core`** - Central initialization package (like Firebase Core)
- **Local packages** - Work independently without cloud requirements
- **`voo_telemetry`** - Optional cloud syncing via OpenTelemetry

## Packages

### Core Package

#### voo_core
The foundation package that provides:
- Central app initialization (like Firebase Core)
- Plugin registration system
- Shared utilities and base classes
- Multi-app support

### Local Packages (Work Without Cloud)

#### voo_logging
Comprehensive local logging with:
- Persistent storage using Sembast
- Real-time filtering and search
- DevTools integration
- Network request logging
- Multiple log levels

#### voo_analytics
Local analytics and user interaction tracking:
- Touch event capture
- Heat map generation
- Route-aware analytics
- Event logging
- User properties

#### voo_performance
Local performance monitoring:
- Custom performance traces
- Network performance metrics
- Dio interceptor integration
- Performance statistics

### Cloud Integration (Optional)

#### voo_telemetry
OpenTelemetry integration for cloud syncing:
- OTLP protocol support
- Traces, metrics, and logs
- Automatic batching
- Integration with other Voo packages
- Works with any OpenTelemetry backend

## Quick Start

### 1. Basic Setup (Local Only)

```dart
import 'package:voo_core/voo_core.dart';
import 'package:voo_logging/voo_logging.dart';
import 'package:voo_analytics/voo_analytics.dart';
import 'package:voo_performance/voo_performance.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Voo Core (like Firebase Core)
  await Voo.initializeApp(
    options: VooOptions.development(
      appName: 'MyApp',
      appVersion: '1.0.0',
    ),
  );
  
  // Initialize local packages
  await VooLoggingPlugin.initialize();
  await VooAnalyticsPlugin.initialize();
  await VooPerformancePlugin.initialize();
  
  // Use the packages - all data stays local
  await VooLogger.info('App started');
  await VooAnalyticsPlugin.instance.logEvent('app_opened');
  
  runApp(MyApp());
}
```

### 2. With Cloud Syncing

```dart
import 'package:voo_telemetry/voo_telemetry.dart';

void main() async {
  // ... previous initialization code ...
  
  // Add cloud syncing capability
  await VooTelemetryPlugin.initialize(
    endpoint: 'https://your-otlp-endpoint.com',
    apiKey: 'your-api-key',
  );
  
  // Now all Voo packages automatically sync to the cloud
  // while still maintaining local functionality
}
```

## Key Features

### 🔌 Plugin Architecture
- Similar to Firebase's modular approach
- Each package can be used independently
- Automatic plugin discovery and registration

### 💾 Local-First Design
- All packages work without internet connection
- Data persisted locally using Sembast
- No cloud dependency for core functionality

### ☁️ Optional Cloud Sync
- Add cloud capabilities with one line of code
- OpenTelemetry standard compliance
- Works with any OTLP-compatible backend

### 🛠️ DevTools Integration
- Real-time log monitoring
- Performance metrics visualization
- Analytics event tracking
- Network request inspection

### 🎯 Production Ready
- Battle-tested in production apps
- Comprehensive error handling
- Automatic cleanup and memory management
- Configurable retention policies

## Installation

Add the packages you need to your `pubspec.yaml`:

```yaml
dependencies:
  # Core package (required)
  voo_core: ^0.2.0
  
  # Add the packages you need (all optional)
  voo_logging: ^0.2.0
  voo_analytics: ^0.2.0
  voo_performance: ^0.2.0
  
  # Add cloud syncing (optional)
  voo_telemetry: ^0.2.0
```

## Development

This project uses [Melos](https://melos.invertase.dev) for managing the monorepo.

### Setup

```bash
# Install Melos globally
dart pub global activate melos

# Bootstrap the workspace
melos bootstrap
```

### Common Commands

```bash
# Run tests for all packages
melos run test_all

# Analyze all packages
melos run analyze

# Build DevTools extensions
melos run build_devtools_extension

# Run the example app
melos run run_example
```

## Package Status

| Package | Version | Description |
|---------|---------|-------------|
| voo_core | 0.2.0 | Core foundation and plugin system |
| voo_logging | 0.2.0 | Local logging with DevTools |
| voo_analytics | 0.2.0 | Local analytics and heat maps |
| voo_performance | 0.2.0 | Local performance monitoring |
| voo_telemetry | 0.2.0 | Cloud syncing via OpenTelemetry |

## Example App

The `apps/voo_example` directory contains a complete example demonstrating:
- Package initialization
- Local-only mode
- Cloud sync integration
- DevTools usage
- Performance monitoring
- Analytics tracking

## Migration from v0.1.x

Version 0.2.0 introduces a new architecture:

1. **voo_core** no longer handles cloud syncing
2. Each package works locally by default
3. Cloud syncing moved to **voo_telemetry**
4. Firebase-like initialization pattern

See the [migration guide](MIGRATION.md) for detailed instructions.

## Contributing

Contributions are welcome! Please read our [contributing guidelines](CONTRIBUTING.md) before submitting PRs.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- [Documentation](https://voostack.com/docs)
- [GitHub Issues](https://github.com/voostack/voo_flutter/issues)
- [Discord Community](https://discord.gg/voostack)