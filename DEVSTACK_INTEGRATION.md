# DevStack Integration Guide

This guide explains how to configure VooFlutter packages to send telemetry data to the DevStack API.

## Quick Start

### 1. Get Your DevStack Credentials

You'll need:
- **API Key**: From your DevStack project settings (e.g., `ds_test_xxxxxxxxxxxx`)
- **Project ID**: Your project's UUID (e.g., `984d43b8-70c6-4d49-996e-a6c24ea42de9`)
- **Organization ID**: Your organization's UUID (e.g., `0d1652a4-4251-4c8b-9930-238ec735c236`)

### 2. Initialize DevStack Telemetry

```dart
import 'package:voo_core/voo_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize DevStack telemetry
  await DevStackTelemetry.initialize(
    apiKey: 'YOUR_DEVSTACK_API_KEY',
    projectId: 'YOUR_PROJECT_ID',
    organizationId: 'YOUR_ORGANIZATION_ID',
    endpoint: 'http://localhost:5001/api/v1', // Or production URL
    enableDebugMode: true, // Enable for debugging
    syncInterval: const Duration(seconds: 30),
    batchSize: 50,
  );
  
  // Initialize VooFlutter plugins as normal
  await VooLoggingPlugin.instance.initialize();
  await VooAnalyticsPlugin.instance.initialize();
  await VooPerformancePlugin.instance.initialize();
  
  runApp(MyApp());
}
```

## Features

### Debug Mode

Enable debug mode to see exactly what's being sent to DevStack:

```dart
// Enable debug mode
CloudSyncManager.enableDebugMode();

// Check debug status
if (CloudSyncManager.isDebugMode) {
  print('Debug mode is enabled');
}

// Get debug logs
final debugLogs = DevStackTelemetry.getDebugLog();
for (final log in debugLogs) {
  print(log);
}
```

### Sync Status

Monitor the telemetry sync status:

```dart
// Print formatted status
DevStackTelemetry.printSyncStatus();

// Get status as map
final status = DevStackTelemetry.getSyncStatus();
print('Queue size: ${status['queueSize']}');
print('Is syncing: ${status['isSyncing']}');
```

### Manual Sync

Force an immediate sync of queued telemetry:

```dart
await DevStackTelemetry.forceSync();
```

## What Gets Sent to DevStack

### Logs (from voo_logging)
- All log levels (verbose, debug, info, warning, error, fatal)
- Log metadata and context
- Stack traces for errors

### Analytics Events (from voo_analytics)
- Custom events with parameters
- Touch tracking data
- User interactions

### Performance Metrics (from voo_performance)
- Network request metrics
- Performance traces
- Custom timing measurements

## API Endpoints

The telemetry is sent to these DevStack endpoints:

- **Logs**: `POST /api/v1/logs/batch`
- **Metrics**: `POST /api/v1/metrics/batch`
- **Analytics**: `POST /api/v1/analytics/events/batch`
- **Errors**: `POST /api/v1/errors/batch`

## Configuration Options

| Option | Description | Default |
|--------|-------------|---------|
| `apiKey` | Your DevStack API key | Required |
| `projectId` | Your DevStack project ID | Required |
| `organizationId` | Your DevStack organization ID | Required |
| `endpoint` | DevStack API endpoint | `http://localhost:5001/api/v1` |
| `enableDebugMode` | Enable debug logging | `false` |
| `syncInterval` | How often to sync data | `30 seconds` |
| `batchSize` | Maximum items per sync | `50` |

## Testing the Integration

1. Run the example app with DevStack configuration:
```bash
cd apps/voo_example
flutter run lib/main_devstack.dart
```

2. Generate test telemetry:
- Tap buttons in the demo app to generate logs and events
- Watch the console for sync status
- Check your DevStack dashboard for incoming data

## Troubleshooting

### No Data Appearing in DevStack

1. **Check API Key**: Ensure your API key is correct and active
2. **Check Endpoint**: Verify the endpoint URL is correct
3. **Enable Debug Mode**: See what's being sent and any errors
4. **Check Network**: Ensure your device can reach the DevStack API
5. **Force Sync**: Try manually triggering a sync

### Debug Output

When debug mode is enabled, you'll see:
```
[CloudSync Debug] Syncing 10 items to http://localhost:5001/api/v1/telemetry/batch
[CloudSync Debug] Request headers: API Key present
[CloudSync Debug] Response status: 200
[CloudSync Debug] Successfully synced 10 items
```

### Common Issues

| Issue | Solution |
|-------|----------|
| "API key missing" | Ensure you've set the API key in initialization |
| "Failed to sync batch: 401" | API key is invalid or expired |
| "Failed to sync batch: 404" | Check the endpoint URL is correct |
| "Connection refused" | DevStack API is not running or unreachable |

## Example Implementation

See `/apps/voo_example/lib/main_devstack.dart` for a complete working example.

## Security Notes

- API keys are masked in logs (only first 10 chars shown)
- Use HTTPS in production (`https://api.your-devstack.com`)
- Store API keys securely (use environment variables or secure storage)
- Don't commit API keys to version control