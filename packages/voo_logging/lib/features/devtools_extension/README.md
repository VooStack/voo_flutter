# Voo Logger DevTools Extension

This DevTools extension provides a real-time log viewer for applications using Voo Logger.

## Architecture

### Data Flow
1. **Logger Repository** → Sends structured logs via `developer.log()` with JSON data
2. **DevTools Extension** → Listens to VM Service logging stream
3. **Data Source** → Receives and parses log entries from the logging stream
4. **Repository** → Provides filtering and data access
5. **Bloc** → Manages state and business logic
6. **UI** → Displays logs with filtering and search capabilities

### Key Components

- **DevToolsLogDataSource**: Listens to VM Service logging events
- **DevToolsLogRepository**: Handles log filtering and caching
- **LogBloc**: State management using BLoC pattern
- **VooLoggerPage**: Main UI with log list and details panel

## How It Works

The extension uses the standard Dart logging stream instead of custom extension events:

1. VooLogger sends structured JSON logs through `developer.log()`
2. The DevTools extension listens to the VM Service's logging stream
3. It filters logs by logger name (VooLogger, voo_logger, AwesomeLogger)
4. Structured logs are parsed from JSON, regular logs are displayed as-is

## Testing

### Method 1: Flutter App Test
1. Run the Flutter test app:
   ```bash
   flutter run example/devtools_test_app.dart
   ```

2. Open DevTools (press 'd' in the Flutter console or use the DevTools button in your IDE)

3. Navigate to the Voo Logger tab

4. Press the "Generate Logs" button in the app to see logs appear in real-time

### Method 2: Dart Console Test
1. Run the console test to generate continuous logs:
   ```bash
   dart run example/test_devtools.dart
   ```

2. While the test is running, open DevTools and navigate to the Voo Logger tab

## Building the Extension

To build and install the DevTools extension:

```bash
flutter pub global activate devtools_extensions
dart run devtools_extensions build_and_copy --source=lib/features/devtools_extension
```

## Features

- Real-time log streaming
- Log level filtering (Verbose, Debug, Info, Warning, Error, Fatal)
- Search functionality
- Category-based filtering
- Log details panel with metadata
- Auto-scroll toggle
- Clear logs
- Statistics view

## Troubleshooting

If logs aren't appearing:

1. Make sure VooLogger is initialized in your app
2. Check the DevTools console for any error messages
3. Verify that the logging stream is enabled (the extension does this automatically)
4. Ensure your app is running in debug mode