# Voo Logging Example

This example demonstrates the comprehensive features of the Voo Logging package, including its integration with Flutter DevTools.

## Features Demonstrated

### 1. **Custom Log Entry**
- Create logs with custom messages
- Select different log levels (Verbose, Debug, Info, Warning, Error, Fatal)
- Categorize logs (General, Network, Database, UI, Analytics)
- Add custom metadata

### 2. **Quick Log Actions**
- One-click logging for each severity level
- Pre-configured messages for quick testing
- Color-coded buttons for visual distinction

### 3. **Common Scenarios**

#### Network Request Simulation
```dart
await VooLogger.networkRequest(
  'GET',
  'https://api.example.com/users',
  headers: {
    'Authorization': 'Bearer token123',
    'Content-Type': 'application/json',
  },
);
```

#### User Action Tracking
```dart
VooLogger.userAction(
  'button_click',
  screen: 'LoggingExamplePage',
  properties: {
    'button': 'log_user_action',
    'timestamp': DateTime.now().toIso8601String(),
  },
);
```

#### Error Handling
```dart
try {
  // Your code here
} catch (e, stackTrace) {
  VooLogger.error(
    'An error occurred',
    error: e,
    stackTrace: stackTrace,
  );
}
```

#### Performance Metrics
```dart
VooLogger.performance(
  'DatabaseQuery',
  const Duration(milliseconds: 456),
  metrics: {
    'rowCount': 1000,
    'cacheHit': false,
  },
);
```

### 4. **Log Management**
- View log statistics (total logs, counts by level and category)
- Export logs as JSON
- Clear all logs with confirmation
- Change user context and start new sessions

## Getting Started

1. **Initialize the Logger**
   ```dart
   await VooLogger.initialize(
     minimumLevel: LogLevel.verbose,
     appName: 'Voo Logging Example',
     appVersion: '1.0.0',
     userId: 'user123',
   );
   ```

2. **Basic Logging**
   ```dart
   // Simple info log
   VooLogger.info('User logged in');
   
   // With category and metadata
   VooLogger.info(
     'Payment processed',
     category: 'Payment',
     metadata: {
       'amount': 99.99,
       'currency': 'USD',
     },
   );
   ```

3. **Error Logging**
   ```dart
   VooLogger.error(
     'Failed to load user data',
     error: exception,
     stackTrace: stackTrace,
     category: 'API',
   );
   ```

## DevTools Integration

### Viewing Logs in DevTools

1. Run the example app
2. Open Flutter DevTools
3. Navigate to the "Voo Logger" tab
4. See real-time logs with:
   - Filtering by level, category, or search term
   - Export functionality
   - Statistics view
   - Clear logs option

### Features in DevTools Extension

- **Real-time Updates**: Logs appear instantly as they're created
- **Advanced Filtering**: Filter by log level, category, tags, or search text
- **Statistics Dashboard**: View log distribution and patterns
- **Export Options**: Export filtered logs as JSON
- **Clean Architecture**: Built with Bloc pattern for maintainability

## Architecture

The example follows clean architecture principles:

```
example/
├── lib/
│   └── main.dart          # Example app demonstrating all features
├── pubspec.yaml           # Dependencies
└── README.md             # This file
```

## Log Levels

- **Verbose**: Detailed debugging information
- **Debug**: Development debugging messages
- **Info**: General application flow
- **Warning**: Unexpected but non-breaking situations
- **Error**: Errors that don't crash the app
- **Fatal**: Critical errors that might crash the app

## Running the Example

```bash
cd example
flutter run
```

For web with DevTools:
```bash
flutter run -d chrome
```

Then open DevTools:
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

## Key Concepts

### Session Management
Each app launch creates a unique session ID, helping you track logs from specific user sessions.

### User Context
Set user IDs to track logs for specific users:
```dart
VooLogger.setUserId('user456');
```

### Performance Monitoring
Track operation durations and automatically flag slow operations:
```dart
final stopwatch = Stopwatch()..start();
// ... perform operation ...
stopwatch.stop();
VooLogger.performance('DataSync', stopwatch.elapsed);
```

### Batch Logging
The example includes a "Generate Multiple Logs" feature that creates 20 logs across different categories and levels, useful for testing filtering and performance.

## Best Practices

1. **Use Appropriate Log Levels**: Don't use ERROR for warnings or INFO for debug messages
2. **Add Context**: Include relevant metadata for easier debugging
3. **Categories**: Use consistent category names across your app
4. **Performance**: The logger is designed to be non-blocking and won't slow down your app
5. **Privacy**: Be careful not to log sensitive user data

## Troubleshooting

- **Logs not appearing**: Check that you've initialized VooLogger and the minimum level is set appropriately
- **DevTools tab missing**: Ensure the DevTools extension is properly installed in the main package
- **Performance issues**: The logger uses SQLite for storage and is optimized for performance

## Learn More

For more information about the Voo Logging package and its DevTools extension, see the main package documentation.