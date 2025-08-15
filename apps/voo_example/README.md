# VooFlutter Example App

A comprehensive example application demonstrating all VooFlutter packages working together in harmony.

## Overview

This example app showcases the integration of:
- **voo_core**: Core utilities and plugin system
- **voo_logging**: Advanced logging with DevTools integration
- **voo_analytics**: User interaction tracking and heat maps
- **voo_performance**: Performance monitoring and metrics

## Features

### 1. Logging Example
- Create logs with different severity levels (Debug, Info, Warning, Error)
- View real-time log entries
- Export and clear logs
- Automatic exception tracking
- DevTools integration for advanced debugging

### 2. Analytics Example
- Touch interaction tracking
- Real-time heat map generation
- Interaction statistics (taps, long presses, swipes)
- Customizable tracking settings
- Event metadata recording

### 3. Performance Monitoring
- Real-time CPU and memory usage monitoring
- FPS tracking
- Custom performance traces
- Network request metrics
- Performance statistics and averages

### 4. Network Interceptors
- Automatic request/response logging via Dio interceptors
- Performance metrics for network calls
- Error tracking and reporting
- Request history with timing information
- Support for all HTTP methods (GET, POST, PUT, DELETE)

## Getting Started

### Prerequisites
- Flutter SDK ^3.8.0
- Dart SDK ^3.8.0
- DevStack API (optional, for telemetry backend)

### Installation

1. Navigate to the example app directory:
```bash
cd apps/voo_example
```

2. Install dependencies:
```bash
flutter pub get
```

3. **DevStack Integration Setup (Optional)**:
   
   If you want to use DevStack telemetry backend:
   
   a. Copy the environment template:
   ```bash
   cp .env.example .env
   ```
   
   b. Edit `.env` with your DevStack credentials:
   ```env
   DEVSTACK_API_KEY=your_api_key_here
   DEVSTACK_PROJECT_ID=your_project_id_here
   DEVSTACK_ORGANIZATION_ID=your_organization_id_here
   DEVSTACK_API_ENDPOINT=http://localhost:5001/api/v1
   ```
   
   c. For different environments:
   - **Local development**: `http://localhost:5001/api/v1`
   - **Android emulator**: `http://10.0.2.2:5001/api/v1`
   - **iOS simulator**: `http://[YOUR_HOST_IP]:5001/api/v1`
   - **Production**: `https://api.devstack.com/api/v1`

### Running the App

#### Standard Example (without DevStack):
```bash
flutter run
```

#### DevStack Integration Examples:

Run the DevStack-enabled example:
```bash
flutter run lib/devstack_example.dart
```

Run the comprehensive DevStack test:
```bash
flutter run lib/devstack_full_test.dart
```

#### Platform-specific:

Run on iOS Simulator:
```bash
flutter run -d ios
```

Run on Android Emulator:
```bash
flutter run -d android
```

Run on Web:
```bash
flutter run -d chrome
```

### Running Tests

#### Unit and Widget Tests:
```bash
flutter test
```

#### Integration Tests:
```bash
flutter test test/integration_test.dart
```

#### Run all tests with coverage:
```bash
flutter test --coverage
```

## Project Structure

```
voo_example/
├── lib/
│   ├── main.dart                 # App entry point and initialization
│   ├── devstack_example.dart     # DevStack integration example
│   ├── devstack_full_test.dart   # Comprehensive DevStack test
│   └── pages/
│       ├── home_page.dart        # Main navigation hub
│       ├── logging_page.dart     # Logging features demo
│       ├── analytics_page.dart   # Analytics features demo
│       ├── performance_page.dart # Performance monitoring demo
│       └── network_page.dart     # Network interceptors demo
├── test/
│   ├── widget_test.dart         # Widget and unit tests
│   └── integration_test.dart    # Integration tests
├── .env.example                  # Environment variables template
├── .env                          # Your DevStack credentials (gitignored)
├── .gitignore                    # Git ignore rules
└── pubspec.yaml                  # Package dependencies
```

## Key Code Examples

### Initialize All Packages
```dart
await Voo.init(
  options: VooOptions(
    appName: 'VooExample',
    appVersion: '1.0.0',
    enableDebugMode: true,
  ),
  plugins: [
    VooLoggingPlugin(),
    VooAnalyticsPlugin(),
    VooPerformancePlugin(),
  ],
);
```

### DevStack Integration
```dart
// Load environment variables
await dotenv.load(fileName: ".env");

// Initialize DevStack telemetry
await DevStackTelemetry.initialize(
  apiKey: dotenv.env['DEVSTACK_API_KEY']!,
  projectId: dotenv.env['DEVSTACK_PROJECT_ID']!,
  organizationId: dotenv.env['DEVSTACK_ORGANIZATION_ID']!,
  endpoint: dotenv.env['DEVSTACK_API_ENDPOINT']!,
  enableDebugMode: true,
  syncInterval: const Duration(seconds: 30),
  batchSize: 50,
);
```

### Logging
```dart
VooLogger.info('Application started');
VooLogger.error('An error occurred', error: exception, stackTrace: stack);
```

### Analytics Tracking
```dart
final event = TouchEvent(
  id: DateTime.now().toString(),
  type: 'tap',
  position: Offset(100, 200),
  timestamp: DateTime.now(),
);
analyticsRepository.trackTouchEvent(event);
```

### Performance Monitoring
```dart
final trace = performanceTracker.startTrace('api_call');
// Perform operation
trace.stop();
print('Operation took: ${trace.duration.inMilliseconds}ms');
```

### Network Interceptors
```dart
final dio = Dio();
dio.interceptors.add(VooDioInterceptor());
dio.interceptors.add(PerformanceDioInterceptor());
```

## Development Tips

1. **DevTools Integration**: Open Flutter DevTools to see real-time logs and performance metrics
2. **Hot Reload**: The app supports hot reload for rapid development
3. **State Management**: Uses setState for simplicity, but can be extended with BLoC/Provider
4. **Error Handling**: All errors are automatically logged via VooLogger

## Troubleshooting

### Common Issues

1. **Dependencies not resolving**: 
   - Ensure you're using the correct Flutter/Dart SDK versions
   - Run `flutter clean` and `flutter pub get`

2. **Tests failing**:
   - Initialize packages in setUpAll() for tests
   - Mock network calls for reliable testing

3. **Performance issues**:
   - Check the Performance page for bottlenecks
   - Review logs for excessive logging

## Contributing

This example app serves as a reference implementation. To contribute:
1. Add new feature demonstrations
2. Improve existing examples
3. Add more comprehensive tests
4. Update documentation

## License

See the main repository LICENSE file for details.