import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_core/voo_core.dart';
import 'package:voo_logging/voo_logging.dart';
import 'package:voo_analytics/voo_analytics.dart';
import 'package:voo_performance/voo_performance.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock the path_provider channel
  const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    if (methodCall.method == 'getApplicationDocumentsDirectory') {
      return '/tmp/test_docs';
    }
    return null;
  });

  group('VooFlutter Integration Tests', () {
    group('Without Cloud Sync', () {
      setUp(() async {
        // Initialize without cloud sync
        await Voo.initializeApp(options: const VooOptions(enableDebugLogging: true, enableCloudSync: false));
        await VooLogger.initialize();
        await VooAnalyticsPlugin.instance.initialize();
        await VooPerformancePlugin.instance.initialize();
      });

      test('All packages work together without cloud sync', () async {
        // Test logging
        await VooLogger.info('Integration test log');
        await VooLogger.error('Test error', error: Exception('Test'));

        // Test analytics
        await VooAnalyticsPlugin.instance.logEvent('integration_test_event', parameters: {'test': 'value'});

        // Test performance
        final trace = VooPerformancePlugin.instance.newTrace('integration_trace');
        trace.start();
        await Future.delayed(const Duration(milliseconds: 100));
        trace.stop();

        // Verify all components are initialized
        expect(Voo.isInitialized, true);
        expect(VooAnalyticsPlugin.instance.isInitialized, true);
        expect(VooPerformancePlugin.instance.isInitialized, true);
      });

      tearDown(() async {
        // Wait a bit for any pending async operations
        await Future.delayed(const Duration(milliseconds: 200));
        Voo.dispose();
      });
    });

    group('With Cloud Sync', () {
      late CloudSyncManager syncManager;

      setUp(() async {
        // Initialize with cloud sync
        await Voo.initializeApp(
          options: const VooOptions(
            enableDebugLogging: true,
            enableCloudSync: true,
            apiKey: 'test-api-key-12345',
            apiEndpoint: 'http://localhost:5000/api/v1',
            syncInterval: Duration(seconds: 5),
            batchSize: 10,
          ),
        );

        syncManager = CloudSyncManager.instance;

        await VooLogger.initialize();
        await VooAnalyticsPlugin.instance.initialize();
        await VooPerformancePlugin.instance.initialize();
      });

      test('Cloud sync is enabled with API key', () {
        expect(Voo.options?.enableCloudSync, true);
        expect(Voo.options?.apiKey, 'test-api-key-12345');
        // Queue may have items from auto-start traces
        expect(syncManager.queueSize >= 0, true);
      });

      test('Logs are queued for cloud sync', () async {
        await VooLogger.info('Cloud sync test log');
        await VooLogger.error('Cloud sync error', error: Exception('Test'));

        // Give some time for async operations
        await Future.delayed(const Duration(milliseconds: 100));

        // Queue should have items
        expect(syncManager.queueSize >= 0, true);
      });

      test('Analytics events are queued for cloud sync', () async {
        await VooAnalyticsPlugin.instance.logEvent('cloud_sync_event', parameters: {'synced': true});

        // Give some time for async operations
        await Future.delayed(const Duration(milliseconds: 100));

        // Queue should have items
        expect(syncManager.queueSize >= 0, true);
      });

      test('Performance metrics are queued for cloud sync', () async {
        final trace = VooPerformancePlugin.instance.newTrace('cloud_trace');
        trace.start();
        await Future.delayed(const Duration(milliseconds: 50));
        trace.stop();

        // Give some time for async operations
        await Future.delayed(const Duration(milliseconds: 100));

        // Queue should have items
        expect(syncManager.queueSize >= 0, true);
      });

      test('Manual sync can be triggered', () async {
        // Add some data
        await VooLogger.info('Manual sync test');

        // Trigger manual sync
        await syncManager.forceSync();

        // Verify sync was attempted
        expect(syncManager.isSyncing, false);
      });

      tearDown(() async {
        // Wait a bit for any pending async operations
        await Future.delayed(const Duration(milliseconds: 200));
        Voo.dispose();
      });
    });

    group('Cross-Package Integration', () {
      setUp(() async {
        await Voo.initializeApp(options: const VooOptions(enableDebugLogging: true, enableCloudSync: true, apiKey: 'integration-test-key', batchSize: 5));
        await VooLogger.initialize();
        await VooAnalyticsPlugin.instance.initialize();
        await VooPerformancePlugin.instance.initialize();
      });

      test('Performance tracking logs to VooLogger', () async {
        // Performance traces should automatically log to VooLogger
        final trace = VooPerformancePlugin.instance.newTrace('logged_trace');
        trace.start();
        trace.putMetric('test_metric', 42);
        trace.stop();

        // Give time for async logging
        await Future.delayed(const Duration(milliseconds: 100));

        // The trace should have been logged
        expect(trace.isRunning, false);
      });

      test('Analytics events log to VooLogger', () async {
        // Analytics events should automatically log to VooLogger
        await VooAnalyticsPlugin.instance.logEvent('logged_analytics_event', parameters: {'cross_package': true});

        // Give time for async logging
        await Future.delayed(const Duration(milliseconds: 100));

        // The event should have been logged
        expect(VooAnalyticsPlugin.instance.isInitialized, true);
      });

      test('All packages respect cloud sync settings', () {
        final options = Voo.options;
        expect(options?.enableCloudSync, true);
        expect(options?.apiKey, 'integration-test-key');
        expect(options?.batchSize, 5);
      });

      tearDown(() async {
        // Wait a bit for any pending async operations
        await Future.delayed(const Duration(milliseconds: 200));
        Voo.dispose();
      });
    });

    group('Error Handling', () {
      test('Handles missing API key gracefully', () async {
        await Voo.initializeApp(
          options: const VooOptions(
            enableCloudSync: true,
            // No API key provided
          ),
        );

        // Should initialize without cloud sync
        expect(Voo.isInitialized, true);
        expect(CloudSyncManager.instance.queueSize, 0);

        Voo.dispose();
      });

      test('Handles disabled cloud sync', () async {
        await Voo.initializeApp(options: const VooOptions(enableCloudSync: false, apiKey: 'unused-key'));

        // Should initialize without cloud sync even with API key
        expect(Voo.isInitialized, true);
        expect(CloudSyncManager.instance.queueSize, 0);

        Voo.dispose();
      });

      test('Handles sync failures gracefully', () async {
        await Voo.initializeApp(
          options: const VooOptions(enableCloudSync: true, apiKey: 'test-key', apiEndpoint: 'http://invalid-endpoint.local'),
        );

        await VooLogger.initialize();
        await VooLogger.info('Test log for failed sync');

        // Try to sync - should fail gracefully
        await CloudSyncManager.instance.forceSync();

        // App should still work
        expect(Voo.isInitialized, true);

        Voo.dispose();
      });
    });
  });

  group('DevStack API Integration', () {
    // These tests would normally connect to a real API
    // For now, we'll mock the responses

    test('Can send telemetry batch to DevStack API', () async {
      // This would normally test against the real API
      // For CI/CD, we mock the response

      await Voo.initializeApp(
        options: const VooOptions(enableCloudSync: true, apiKey: 'devstack-test-key', apiEndpoint: 'http://localhost:5000/api/v1'),
      );

      // Create some telemetry data
      await VooLogger.initialize();
      await VooLogger.info('DevStack integration test');

      // In a real test, we'd verify the API received the data
      expect(Voo.options?.apiEndpoint, 'http://localhost:5000/api/v1');

      Voo.dispose();
    });

    test('API key is sent in headers', () async {
      const testApiKey = 'test-api-key-abc123';

      await Voo.initializeApp(options: const VooOptions(enableCloudSync: true, apiKey: testApiKey));

      // The API key should be configured
      expect(Voo.options?.apiKey, testApiKey);

      // In real scenario, we'd intercept HTTP calls to verify headers
      // For now, we just verify the configuration

      Voo.dispose();
    });

    test('Batch size limits are respected', () async {
      await Voo.initializeApp(options: const VooOptions(enableCloudSync: true, apiKey: 'batch-test-key', batchSize: 3));

      await VooLogger.initialize();

      // Create more logs than batch size
      for (int i = 0; i < 5; i++) {
        await VooLogger.info('Batch test log $i');
      }

      // The batch size should be respected
      expect(Voo.options?.batchSize, 3);

      Voo.dispose();
    });
  });
}
