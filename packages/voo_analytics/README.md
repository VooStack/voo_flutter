# Voo Analytics

A comprehensive analytics and heat map tracking package for Flutter applications. Track user interactions, visualize touch patterns, and gain insights into user behavior.

## Features

- 📊 Touch event tracking and recording
- 🔥 Heat map data generation and visualization
- 🎯 User interaction analytics
- 📱 Cross-platform support (iOS, Android, Web, Desktop)
- 🔧 Easy integration with existing Flutter apps
- 📈 Real-time analytics data collection
- 🎨 DevTools extension for heat map visualization

## Installation

```yaml
dependencies:
  voo_analytics: ^0.0.2
```

## Usage

### Basic Setup

```dart
import 'package:voo_analytics/voo_analytics.dart';
import 'package:voo_core/voo_core.dart';

void main() async {
  // Initialize Voo Core first
  await Voo.initializeApp();
  
  // Initialize Analytics Plugin
  await VooAnalyticsPlugin.instance.initialize();
  
  runApp(MyApp());
}
```

### Touch Tracking

Wrap your app or specific widgets with `TouchTrackerWidget` to automatically track user interactions:

```dart
import 'package:voo_analytics/voo_analytics.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TouchTrackerWidget(
      child: MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}
```

### Manual Event Tracking

Track custom analytics events:

```dart
// Track a touch event
VooAnalyticsPlugin.instance.trackTouchEvent(
  TouchEvent(
    x: 100.0,
    y: 200.0,
    timestamp: DateTime.now(),
    screenName: 'home_screen',
    elementType: 'button',
    elementId: 'submit_button',
  ),
);

// Track custom events
VooAnalyticsPlugin.instance.trackEvent(
  'user_action',
  properties: {
    'action': 'button_click',
    'screen': 'home',
    'value': 'submit',
  },
);
```

### Heat Map Data

Generate and access heat map data for visualization:

```dart
// Get heat map data for a specific screen
final heatMapData = await VooAnalyticsPlugin.instance.getHeatMapData(
  screenName: 'home_screen',
  startTime: DateTime.now().subtract(Duration(days: 7)),
  endTime: DateTime.now(),
);

// Access heat map points
for (final point in heatMapData.points) {
  print('Touch at (${point.x}, ${point.y}) with intensity ${point.intensity}');
}

// Get aggregated heat map with grid resolution
final aggregatedData = await VooAnalyticsPlugin.instance.getAggregatedHeatMap(
  screenName: 'home_screen',
  gridSize: 50, // 50x50 pixel grid
);
```

### Session Management

Track user sessions and analyze user behavior:

```dart
// Start a new session
VooAnalyticsPlugin.instance.startSession(
  userId: 'user123',
  sessionId: 'session456',
);

// End the current session
VooAnalyticsPlugin.instance.endSession();

// Get session analytics
final sessionData = await VooAnalyticsPlugin.instance.getSessionAnalytics(
  sessionId: 'session456',
);
```

### Export Analytics Data

Export collected analytics data for external analysis:

```dart
// Export as JSON
final jsonData = await VooAnalyticsPlugin.instance.exportAnalytics(
  format: ExportFormat.json,
  startDate: DateTime.now().subtract(Duration(days: 30)),
  endDate: DateTime.now(),
);

// Export as CSV
final csvData = await VooAnalyticsPlugin.instance.exportAnalytics(
  format: ExportFormat.csv,
  includeHeatMapData: true,
);
```

## DevTools Integration

The package includes a DevTools extension that provides:

- Real-time heat map visualization
- Touch event timeline
- Analytics dashboard
- Session insights
- Export functionality

To use the DevTools extension:

1. Run your app in debug mode
2. Open Flutter DevTools
3. Navigate to the "Voo Analytics" tab
4. View real-time heat maps and analytics data

## Configuration

Configure analytics behavior:

```dart
VooAnalyticsPlugin.instance.configure(
  AnalyticsConfig(
    enableTouchTracking: true,
    enableHeatMap: true,
    samplingRate: 1.0, // Track 100% of events
    batchSize: 100, // Send events in batches of 100
    flushInterval: Duration(seconds: 30), // Flush every 30 seconds
    maxStorageSize: 10 * 1024 * 1024, // 10MB max storage
  ),
);
```

## Privacy and Data Collection

This package respects user privacy:

- All data is stored locally by default
- No automatic data transmission to external servers
- User consent should be obtained before tracking
- Sensitive areas can be excluded from tracking

```dart
// Exclude sensitive widgets from tracking
TouchTrackerWidget(
  excludeAreas: [
    Rect.fromLTWH(0, 0, 100, 50), // Exclude top area
  ],
  child: YourApp(),
);
```

## Platform Support

| Platform | Supported | Notes |
|----------|-----------|-------|
| iOS      | ✅ | Full support |
| Android  | ✅ | Full support |
| Web      | ✅ | Full support |
| macOS    | ✅ | Full support |
| Windows  | ✅ | Full support |
| Linux    | ✅ | Full support |

## Example

See the [example](example/) directory for a complete sample application demonstrating all features.

## License

MIT