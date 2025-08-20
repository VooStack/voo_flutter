import 'package:flutter_test/flutter_test.dart';
import 'package:voo_core/voo_core.dart';

void main() {
  group('VooOptions', () {
    test('should create with default values', () {
      const options = VooOptions();

      expect(options.enableDebugLogging, isNotNull);
      expect(options.autoRegisterPlugins, true);
      expect(options.customConfig, isEmpty);
      expect(options.initializationTimeout, const Duration(seconds: 10));
      expect(options.apiKey, isNull);
      expect(options.apiEndpoint, isNull);
      expect(options.enableCloudSync, false);
      expect(options.syncInterval, const Duration(minutes: 1));
      expect(options.batchSize, 100);
    });

    test('should create with custom values', () {
      const options = VooOptions(
        enableDebugLogging: true,
        autoRegisterPlugins: false,
        customConfig: {'key': 'value'},
        initializationTimeout: Duration(seconds: 30),
        apiKey: 'test-api-key',
        apiEndpoint: 'https://api.example.com',
        enableCloudSync: true,
        syncInterval: Duration(minutes: 5),
        batchSize: 200,
      );

      expect(options.enableDebugLogging, true);
      expect(options.autoRegisterPlugins, false);
      expect(options.customConfig['key'], 'value');
      expect(options.initializationTimeout, const Duration(seconds: 30));
      expect(options.apiKey, 'test-api-key');
      expect(options.apiEndpoint, 'https://api.example.com');
      expect(options.enableCloudSync, true);
      expect(options.syncInterval, const Duration(minutes: 5));
      expect(options.batchSize, 200);
    });

    test('should copy with new values', () {
      const original = VooOptions(
        enableDebugLogging: false,
        apiKey: 'original-key',
        batchSize: 50,
      );

      final copied = original.copyWith(
        enableDebugLogging: true,
        apiKey: 'new-key',
        enableCloudSync: true,
      );

      // Original should remain unchanged
      expect(original.enableDebugLogging, false);
      expect(original.apiKey, 'original-key');
      expect(original.enableCloudSync, false);

      // Copied should have new values
      expect(copied.enableDebugLogging, true);
      expect(copied.apiKey, 'new-key');
      expect(copied.enableCloudSync, true);
      
      // Unchanged values should be preserved
      expect(copied.batchSize, 50);
      expect(copied.autoRegisterPlugins, true);
    });

    test('should handle cloud sync configuration', () {
      const options = VooOptions(
        enableCloudSync: true,
        apiKey: 'sync-key',
        apiEndpoint: 'https://sync.example.com',
        syncInterval: Duration(seconds: 30),
        batchSize: 500,
      );

      expect(options.enableCloudSync, true);
      expect(options.apiKey, 'sync-key');
      expect(options.apiEndpoint, 'https://sync.example.com');
      expect(options.syncInterval, const Duration(seconds: 30));
      expect(options.batchSize, 500);
    });

    test('should validate batch size', () {
      const smallBatch = VooOptions(batchSize: 1);
      const largeBatch = VooOptions(batchSize: 10000);

      expect(smallBatch.batchSize, 1);
      expect(largeBatch.batchSize, 10000);
    });

    test('should handle empty custom config', () {
      const options = VooOptions();
      expect(options.customConfig, isEmpty);
      expect(options.customConfig, const {});
    });

    test('should handle complex custom config', () {
      const options = VooOptions(
        customConfig: {
          'feature_flags': ['flag1', 'flag2'],
          'nested': {
            'key': 'value',
            'number': 42,
          },
        },
      );

      expect(options.customConfig['feature_flags'], ['flag1', 'flag2']);
      expect(options.customConfig['nested'], {'key': 'value', 'number': 42});
    });
  });
}