import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:voo_core/src/cloud/sync_entity.dart';
import 'package:voo_core/src/cloud/sync_entity_impl.dart';

class SyncStorage {
  static const String _storeName = 'sync_queue';
  static const String _syncedStoreName = 'synced_ids';
  
  Database? _database;
  final _store = StoreRef<String, Map<String, dynamic>>(_storeName);
  final _syncedStore = StoreRef<String, bool>(_syncedStoreName);
  
  Future<void> initialize() async {
    if (kIsWeb) {
      _database = await databaseFactoryWeb.openDatabase('voo_sync.db');
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final dbPath = path.join(directory.path, 'voo_sync.db');
      _database = await databaseFactoryIo.openDatabase(dbPath);
    }
  }
  
  Future<void> saveEntity(SyncEntity entity) async {
    if (_database == null) await initialize();
    
    await _store.record(entity.id).put(_database!, entity.toJson());
  }
  
  Future<List<SyncEntity>> getPendingEntities() async {
    if (_database == null) await initialize();
    
    final records = await _store.find(_database!);
    return records.map((record) => 
      SyncEntityImpl.fromJson(record.value)
    ).toList();
  }
  
  Future<Set<String>> getSyncedIds() async {
    if (_database == null) await initialize();
    
    final records = await _syncedStore.find(_database!);
    return records.map((record) => record.key).toSet();
  }
  
  Future<void> markAsSynced(List<String> ids) async {
    if (_database == null) await initialize();
    
    await _database!.transaction((txn) async {
      // Add to synced store
      for (final id in ids) {
        await _syncedStore.record(id).put(txn, true);
      }
      
      // Remove from pending store
      for (final id in ids) {
        await _store.record(id).delete(txn);
      }
    });
  }
  
  Future<List<SyncEntity>> incrementRetryCount(List<String> ids) async {
    if (_database == null) await initialize();
    
    final updated = <SyncEntity>[];
    
    await _database!.transaction((txn) async {
      for (final id in ids) {
        final record = await _store.record(id).get(txn);
        if (record != null) {
          final entity = SyncEntityImpl.fromJson(record);
          final updatedEntity = entity.copyWith(retryCount: entity.retryCount + 1);
          await _store.record(id).put(txn, updatedEntity.toJson());
          updated.add(updatedEntity);
        }
      }
    });
    
    return updated;
  }
  
  Future<void> clear() async {
    if (_database == null) await initialize();
    
    await _database!.transaction((txn) async {
      await _store.delete(txn);
      await _syncedStore.delete(txn);
    });
  }
  
  void dispose() {
    _database?.close();
  }
}