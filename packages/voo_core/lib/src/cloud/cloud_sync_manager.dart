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
  
  // Debug mode for internal telemetry inspection
  static bool _debugMode = false;
  static final List<String> _debugLog = [];
  static const int _maxDebugLogEntries = 100;
  
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
    
    // Don't add to queue if we're disposing
    if (_syncTimer == null) {
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
      _logDebug('Sync skipped: Cloud sync disabled or API key missing');
      return;
    }
    
    _isSyncing = true;
    
    try {
      final batch = await _syncQueue.getBatch(options.batchSize);
      if (batch.isEmpty) {
        _logDebug('Sync skipped: No items in queue');
        return;
      }
      
      final endpoint = options.apiEndpoint ?? 'https://api.vooflutter.com/v1';
      final url = '$endpoint/telemetry/batch';
      final requestBody = {
        'batch': batch.map((e) => e.toJson()).toList(),
        'timestamp': DateTime.now().toIso8601String(),
        'projectId': options.customConfig['projectId'] ?? 'unknown',
      };
      
      _logDebug('Syncing ${batch.length} items to $url');
      _logDebug('Request headers: ${options.apiKey != null ? "API Key present" : "No API key"}');
      
      if (_debugMode) {
        _logDebug('Request body: ${jsonEncode(requestBody)}');
      }
      
      final response = await _httpClient!.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'X-API-Key': options.apiKey!,
          if (options.customConfig['organizationId'] != null)
            'X-Organization-Id': options.customConfig['organizationId'],
        },
        body: jsonEncode(requestBody),
      );
      
      _logDebug('Response status: ${response.statusCode}');
      _logDebug('Response body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        await _syncQueue.markAsSynced(batch.map((e) => e.id).toList());
        _logDebug('Successfully synced ${batch.length} items');
      } else {
        await _syncQueue.markAsFailed(batch.map((e) => e.id).toList());
        _logDebug('Failed to sync batch: ${response.statusCode} - ${response.body}');
        if (kDebugMode) {
          print('[CloudSync] Failed to sync batch: ${response.statusCode}');
          print('[CloudSync] Response: ${response.body}');
        }
      }
    } catch (e, stackTrace) {
      _logDebug('Error syncing batch: $e\n$stackTrace');
      if (kDebugMode) {
        print('[CloudSync] Error syncing batch: $e');
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
    _syncTimer = null;
    _httpClient?.close();
    _syncQueue.dispose();
    _instance = null;
  }
  
  int get queueSize => _syncQueue.size;
  bool get isSyncing => _isSyncing;
  
  // Debug methods for internal telemetry inspection
  static void enableDebugMode() {
    _debugMode = true;
    if (kDebugMode) {
      print('[CloudSync] Debug mode enabled');
    }
  }
  
  static void disableDebugMode() {
    _debugMode = false;
    if (kDebugMode) {
      print('[CloudSync] Debug mode disabled');
    }
  }
  
  static bool get isDebugMode => _debugMode;
  
  static List<String> getDebugLog() => List.from(_debugLog);
  
  static void clearDebugLog() {
    _debugLog.clear();
  }
  
  static void _logDebug(String message) {
    if (!_debugMode) return;
    
    final timestamp = DateTime.now().toIso8601String();
    final logEntry = '[$timestamp] $message';
    
    _debugLog.add(logEntry);
    
    // Keep only the last N entries
    if (_debugLog.length > _maxDebugLogEntries) {
      _debugLog.removeAt(0);
    }
    
    if (kDebugMode) {
      print('[CloudSync Debug] $message');
    }
  }
  
  // Method to get current sync status
  Map<String, dynamic> getSyncStatus() {
    return {
      'queueSize': queueSize,
      'isSyncing': isSyncing,
      'debugMode': _debugMode,
      'lastSyncTime': _debugLog.isNotEmpty ? _debugLog.last.split(']').first.substring(1) : null,
      'endpoint': Voo.options?.apiEndpoint ?? 'Not configured',
      'cloudSyncEnabled': Voo.options?.enableCloudSync ?? false,
      'apiKeyPresent': Voo.options?.apiKey != null,
    };
  }
}