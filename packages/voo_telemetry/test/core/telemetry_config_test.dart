import 'package:flutter_test/flutter_test.dart';
import 'package:voo_telemetry/src/core/telemetry_config.dart';

void main() {
  group('TelemetryConfig', () {
    test('should create with required parameters', () {
      final config = TelemetryConfig(
        endpoint: 'https://api.example.com',
      );

      expect(config.endpoint, 'https://api.example.com');
      expect(config.apiKey, isNull);
      expect(config.batchInterval, const Duration(seconds: 30));
      expect(config.maxBatchSize, 100);
      expect(config.debug, false);
      expect(config.timeout, const Duration(seconds: 10));
      expect(config.maxRetries, 3);
      expect(config.retryDelay, const Duration(seconds: 1));
      expect(config.enableCompression, true);
      expect(config.headers['Content-Type'], 'application/json');
    });

    test('should create with all parameters', () {
      final config = TelemetryConfig(
        endpoint: 'https://api.example.com',
        apiKey: 'test-api-key',
        batchInterval: const Duration(seconds: 60),
        maxBatchSize: 200,
        debug: true,
        timeout: const Duration(seconds: 20),
        maxRetries: 5,
        retryDelay: const Duration(seconds: 2),
        enableCompression: false,
        headers: {'X-Custom': 'value'},
      );

      expect(config.endpoint, 'https://api.example.com');
      expect(config.apiKey, 'test-api-key');
      expect(config.batchInterval, const Duration(seconds: 60));
      expect(config.maxBatchSize, 200);
      expect(config.debug, true);
      expect(config.timeout, const Duration(seconds: 20));
      expect(config.maxRetries, 5);
      expect(config.retryDelay, const Duration(seconds: 2));
      expect(config.enableCompression, false);
      expect(config.headers['X-API-Key'], 'test-api-key');
      expect(config.headers['X-Custom'], 'value');
    });

    test('should add API key to headers when provided', () {
      final config = TelemetryConfig(
        endpoint: 'https://api.example.com',
        apiKey: 'secret-key',
      );

      expect(config.headers['X-API-Key'], 'secret-key');
      expect(config.headers['Content-Type'], 'application/json');
    });

    test('copyWith should create new instance with updated values', () {
      final original = TelemetryConfig(
        endpoint: 'https://api.example.com',
        apiKey: 'original-key',
        debug: false,
      );

      final updated = original.copyWith(
        endpoint: 'https://new.example.com',
        debug: true,
        maxBatchSize: 150,
      );

      // Original should remain unchanged
      expect(original.endpoint, 'https://api.example.com');
      expect(original.debug, false);
      expect(original.maxBatchSize, 100);

      // Updated should have new values
      expect(updated.endpoint, 'https://new.example.com');
      expect(updated.debug, true);
      expect(updated.maxBatchSize, 150);
      // Unchanged values should be preserved
      expect(updated.apiKey, 'original-key');
    });

    test('copyWith should preserve null apiKey', () {
      final config = TelemetryConfig(
        endpoint: 'https://api.example.com',
      );

      final updated = config.copyWith(debug: true);

      expect(updated.apiKey, isNull);
      expect(updated.headers.containsKey('X-API-Key'), false);
    });
  });
}