# Voo DevTools Extension

A unified DevTools extension for all Voo packages that dynamically adapts based on which packages are initialized in your Flutter application.

## Features

### Dynamic Plugin Detection
- Automatically detects which Voo packages are initialized in your app
- Shows only relevant tabs and features based on available plugins
- Works with just `voo_core` as the only required dependency

### Material 3 Design
- Modern, clean interface following Google's Material Design 3 guidelines
- Adaptive navigation with NavigationRail for desktop-like experience
- Smooth animations and transitions
- Dark and light theme support

### Quality of Life Improvements
- **Search & Filter**: Quick search and filtering across all data types
- **Export**: Export data as JSON or CSV
- **Clear**: Clear data with confirmation dialogs
- **Refresh**: Manual refresh of data
- **Stats Cards**: Beautiful statistics visualization
- **Empty States**: Helpful guidance when no data is available

## Supported Packages

The extension dynamically adapts to show features for:

- **voo_logging**: Application logs, debugging, and network request logging
- **voo_analytics**: User interaction tracking, heat maps, and analytics events
- **voo_performance**: Performance monitoring, network metrics, and traces
- **voo_telemetry**: Unified telemetry data (coming soon)

## Architecture

### Plugin Detection Service
The extension uses a `PluginDetectionService` that periodically checks which Voo plugins are registered in the running application. It communicates with the app via DevTools service protocol to determine available features.

### Adaptive UI
The UI dynamically adjusts based on detected plugins:
- Navigation items appear only for initialized packages
- Each plugin gets its own dedicated tab with relevant features
- Empty state guidance when no plugins are detected

### Material 3 Components
- NavigationRail for primary navigation
- Cards with rounded corners and subtle borders
- FilterChips for quick filtering
- Consistent spacing and typography
- Teal color scheme with proper contrast ratios

## Development

### Prerequisites
- Flutter SDK ^3.8.1
- DevTools extensions ^0.4.0
- Only `voo_core` package is required

### Building
```bash
# Build the extension
melos run build_devtools_extension

# Validate the extension
melos run validate_logging_extension
```

### Testing
The extension can be tested with different package combinations:
1. Only voo_core (shows empty state)
2. voo_core + voo_logging (shows logging tab)
3. voo_core + voo_analytics (shows analytics tab)
4. All packages (shows all features)

## Usage

1. Initialize Voo in your Flutter app:
```dart
await Voo.initializeApp();
```

2. Initialize the packages you want to use:
```dart
// Optional: Initialize logging
await VooLoggingPlugin.initialize();

// Optional: Initialize analytics
await VooAnalyticsPlugin.initialize();

// Optional: Initialize performance
await VooPerformancePlugin.initialize();
```

3. Open Flutter DevTools and navigate to the Voo extension
4. The extension will automatically detect and display features for initialized packages

## Best Practices

- The extension follows clean architecture principles
- BLoC pattern for state management
- Atomic design for UI components
- Repository pattern for data access
- Plugin architecture for extensibility

## Contributing

When adding support for new Voo packages:
1. Add the package name to `PluginDetectionService._pluginStatus`
2. Create a new tab component for the package
3. Add the tab to `AdaptiveVooPage._buildAvailableTabs()`
4. Update `PluginDetectionService.getPluginInfo()` with package details

## License

See LICENSE file in the repository root.