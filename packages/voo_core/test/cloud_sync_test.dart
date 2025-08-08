import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_core/voo_core.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  // Mock the path_provider channel
  const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    channel,
    (MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return '/tmp/test_docs';
      }
      return null;
    },
  );
  
  group('CloudSync Tests', () {
    setUp(() {
      // Reset Voo before each test
      Voo.dispose();
    });

    test('Voo initializes without cloud sync when no API key provided', () async {
      await Voo.initializeApp(
        options: const VooOptions(
          enableCloudSync: false,
        ),
      );

      expect(Voo.isInitialized, true);
      expect(Voo.options?.enableCloudSync, false);
      expect(Voo.options?.apiKey, null);
    });

    test('Voo initializes with cloud sync when API key provided', () async {
      await Voo.initializeApp(
        options: const VooOptions(
          apiKey: 'test-api-key',
          enableCloudSync: true,
          apiEndpoint: 'https://test.api.com',
          syncInterval: Duration(seconds: 30),
          batchSize: 50,
        ),
      );

      expect(Voo.isInitialized, true);
      expect(Voo.options?.enableCloudSync, true);
      expect(Voo.options?.apiKey, 'test-api-key');
      expect(Voo.options?.apiEndpoint, 'https://test.api.com');
      expect(Voo.options?.syncInterval, const Duration(seconds: 30));
      expect(Voo.options?.batchSize, 50);
    });

    test('VooOptions correctly masks API key in toString', () {
      const options = VooOptions(
        apiKey: 'secret-key-12345',
        enableCloudSync: true,
      );

      final str = options.toString();
      expect(str.contains('secret-key-12345'), false);
      expect(str.contains('***'), true);
    });

    test('SyncEntity can be created and converted to JSON', () {
      final entity = SyncEntityImpl(
        id: 'test-123',
        type: 'test',
        timestamp: DateTime(2024, 1, 1),
        data: {'message': 'test message'},
      );

      final json = entity.toJson();
      expect(json['id'], 'test-123');
      expect(json['type'], 'test');
      expect(json['data']['message'], 'test message');
    });

    test('SyncEntity can be created from JSON', () {
      final json = {
        'id': 'test-456',
        'type': 'log',
        'timestamp': '2024-01-01T00:00:00.000',
        'data': {'level': 'info'},
        'isSynced': false,
        'retryCount': 0,
      };

      final entity = SyncEntityImpl.fromJson(json);
      expect(entity.id, 'test-456');
      expect(entity.type, 'log');
      expect(entity.data['level'], 'info');
      expect(entity.isSynced, false);
      expect(entity.retryCount, 0);
    });

    test('SyncEntity copyWith creates new instance with updated values', () {
      final entity = SyncEntityImpl(
        id: 'test-789',
        type: 'analytics',
        timestamp: DateTime.now(),
        data: {'event': 'click'},
      );

      final updated = entity.copyWith(
        isSynced: true,
        retryCount: 2,
      );

      expect(updated.id, entity.id);
      expect(updated.type, entity.type);
      expect(updated.isSynced, true);
      expect(updated.retryCount, 2);
    });

    test('CloudSyncManager singleton returns same instance', () {
      final instance1 = CloudSyncManager.instance;
      final instance2 = CloudSyncManager.instance;

      expect(identical(instance1, instance2), true);
    });

    test('CloudSyncManager does not initialize when cloud sync disabled', () async {
      await Voo.initializeApp(
        options: const VooOptions(
          enableCloudSync: false,
        ),
      );

      final manager = CloudSyncManager.instance;
      await manager.initialize();

      expect(manager.queueSize, 0);
      expect(manager.isSyncing, false);
    });

    tearDown(() {
      Voo.dispose();
    });
  });
}