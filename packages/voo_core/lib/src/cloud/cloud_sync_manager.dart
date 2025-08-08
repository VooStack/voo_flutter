import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:voo_core/src/voo.dart';
import 'package:voo_core/src/cloud/sync_queue.dart';
import 'package:voo_core/src/cloud/sync_entity.dart';

class CloudSyncManager {
  static CloudSyncManager? _instance;
  
  final SyncQueue _syncQueue = SyncQueue();
  Timer? _syncTimer;
  bool _isSyncing = false;
  http.Client? _httpClient;
  
  CloudSyncManager._();
  
  static CloudSyncManager get instance {
    _instance ??= CloudSyncManager._();
    return _instance!;
  }
  
  Future<void> initialize() async {
    final options = Voo.options;
    if (options == null || !options.enableCloudSync || options.apiKey == null) {
      return;
    }
    
    await _syncQueue.initialize();
    _httpClient = http.Client();
    _startPeriodicSync(options.syncInterval);
  }
  
  void _startPeriodicSync(Duration interval) {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(interval, (_) => sync());
  }
  
  Future<void> addToQueue(SyncEntity entity) async {
    final options = Voo.options;
    if (options == null || !options.enableCloudSync || options.apiKey == null) {
      return;
    }
    
    await _syncQueue.add(entity);
    
    if (_syncQueue.size >= options.batchSize) {
      await sync();
    }
  }
  
  Future<void> sync() async {
    if (_isSyncing) return;
    
    final options = Voo.options;
    if (options == null || !options.enableCloudSync || options.apiKey == null) {
      return;
    }
    
    _isSyncing = true;
    
    try {
      final batch = await _syncQueue.getBatch(options.batchSize);
      if (batch.isEmpty) {
        return;
      }
      
      final endpoint = options.apiEndpoint ?? 'https://api.vooflutter.com/v1';
      final response = await _httpClient!.post(
        Uri.parse('$endpoint/telemetry/batch'),
        headers: {
          'Content-Type': 'application/json',
          'X-API-Key': options.apiKey!,
        },
        body: jsonEncode({
          'batch': batch.map((e) => e.toJson()).toList(),
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );
      
      if (response.statusCode == 200) {
        await _syncQueue.markAsSynced(batch.map((e) => e.id).toList());
      } else {
        if (kDebugMode) {
          print('Failed to sync batch: ${response.statusCode}');
        }
        await _syncQueue.markAsFailed(batch.map((e) => e.id).toList());
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error syncing batch: $e');
      }
    } finally {
      _isSyncing = false;
    }
  }
  
  Future<void> forceSync() async {
    await sync();
  }
  
  void dispose() {
    _syncTimer?.cancel();
    _httpClient?.close();
    _syncQueue.dispose();
    _instance = null;
  }
  
  int get queueSize => _syncQueue.size;
  bool get isSyncing => _isSyncing;
}