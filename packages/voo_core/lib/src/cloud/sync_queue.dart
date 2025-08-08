import 'dart:async';
import 'dart:collection';
import 'package:voo_core/src/cloud/sync_entity.dart';
import 'package:voo_core/src/cloud/sync_storage.dart';

class SyncQueue {
  final Queue<SyncEntity> _queue = Queue();
  final Set<String> _syncedIds = {};
  final SyncStorage _storage = SyncStorage();
  final StreamController<int> _sizeController = StreamController<int>.broadcast();
  bool _initialized = false;
  
  Stream<int> get sizeStream => _sizeController.stream;
  int get size => _queue.length;
  
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    
    await _storage.initialize();
    final pendingEntities = await _storage.getPendingEntities();
    _queue.addAll(pendingEntities);
    
    final syncedIds = await _storage.getSyncedIds();
    _syncedIds.addAll(syncedIds);
  }
  
  Future<void> add(SyncEntity entity) async {
    if (!_initialized) {
      await initialize();
    }
    
    if (_syncedIds.contains(entity.id)) {
      return;
    }
    
    _queue.add(entity);
    await _storage.saveEntity(entity);
    _sizeController.add(_queue.length);
  }
  
  Future<List<SyncEntity>> getBatch(int batchSize) async {
    final batch = <SyncEntity>[];
    
    while (batch.length < batchSize && _queue.isNotEmpty) {
      final entity = _queue.removeFirst();
      if (!_syncedIds.contains(entity.id)) {
        batch.add(entity);
      }
    }
    
    _sizeController.add(_queue.length);
    return batch;
  }
  
  Future<void> markAsSynced(List<String> ids) async {
    _syncedIds.addAll(ids);
    await _storage.markAsSynced(ids);
    
    _queue.removeWhere((entity) => ids.contains(entity.id));
    _sizeController.add(_queue.length);
  }
  
  Future<void> markAsFailed(List<String> ids) async {
    final failedEntities = await _storage.incrementRetryCount(ids);
    
    for (final entity in failedEntities) {
      if (entity.retryCount < 3) {
        _queue.add(entity);
      }
    }
    
    _sizeController.add(_queue.length);
  }
  
  Future<void> clear() async {
    _queue.clear();
    _syncedIds.clear();
    await _storage.clear();
    _sizeController.add(0);
  }
  
  void dispose() {
    if (!_sizeController.isClosed) {
      _sizeController.close();
    }
    _storage.dispose();
  }
}