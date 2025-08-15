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
      
      // Group telemetry by type for DevStack API
      final logItems = <SyncEntity>[];
      final metricItems = <SyncEntity>[];
      final errorItems = <SyncEntity>[];
      final analyticsItems = <SyncEntity>[];
      
      for (final item in batch) {
        final type = item.type;
        if (type == 'log') {
          logItems.add(item);
        } else if (type == 'metric' || type == 'performance') {
          metricItems.add(item);
        } else if (type == 'error') {
          errorItems.add(item);
        } else if (type == 'analytics' || type == 'event') {
          analyticsItems.add(item);
        } else {
          // Default to logs for unknown types
          logItems.add(item);
        }
      }
      
      final endpoint = options.apiEndpoint ?? 'https://api.vooflutter.com/v1';
      final projectId = options.customConfig['projectId'] ?? 'unknown';
      final timestamp = DateTime.now().toIso8601String();
      
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'X-API-Key': options.apiKey!,
      };
      if (options.customConfig['organizationId'] != null) {
        headers['X-Organization-Id'] = options.customConfig['organizationId'].toString();
      }
      
      final successfulIds = <String>[];
      final failedIds = <String>[];
      
      // Send logs
      if (logItems.isNotEmpty) {
        final url = '$endpoint/logs/batch';
        final requestBody = {
          'projectId': projectId,
          'logs': logItems.map((e) {
            final data = e.data as Map<String, dynamic>;
            return {
              'level': data['level'] ?? 'info',
              'message': data['message'] ?? '',
              'timestamp': e.timestamp.toIso8601String(),
              'category': data['category'] ?? 'General',  // Default to 'General' if null
              'metadata': _sanitizeMetadata(data['metadata'] as Map<String, dynamic>?),
            };
          }).toList(),
        };
        
        _logDebug('Syncing ${logItems.length} logs to $url');
        if (_debugMode) {
          _logDebug('Request body: ${jsonEncode(requestBody)}');
        }
        
        final response = await _httpClient!.post(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(requestBody),
        );
        
        _logDebug('Logs response: ${response.statusCode}');
        
        if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
          successfulIds.addAll(logItems.map((e) => e.id));
        } else {
          failedIds.addAll(logItems.map((e) => e.id));
          _logDebug('Failed to sync logs: ${response.statusCode} - ${response.body}');
        }
      }
      
      // Send metrics
      if (metricItems.isNotEmpty) {
        final url = '$endpoint/metrics/batch';
        final requestBody = {
          'projectId': projectId,
          'metrics': metricItems.map((e) {
            final data = e.data as Map<String, dynamic>;
            return {
              'name': data['name'] ?? 'unknown',
              'value': data['value'] ?? 0,
              'timestamp': e.timestamp.toIso8601String(),
              'type': data['type'] ?? 'gauge',
              'tags': data['tags'] ?? {},
            };
          }).toList(),
        };
        
        _logDebug('Syncing ${metricItems.length} metrics to $url');
        
        final response = await _httpClient!.post(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(requestBody),
        );
        
        _logDebug('Metrics response: ${response.statusCode}');
        
        if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
          successfulIds.addAll(metricItems.map((e) => e.id));
        } else {
          failedIds.addAll(metricItems.map((e) => e.id));
        }
      }
      
      // Send errors
      if (errorItems.isNotEmpty) {
        final url = '$endpoint/errors/batch';
        final requestBody = {
          'projectId': projectId,
          'errors': errorItems.map((e) {
            final data = e.data as Map<String, dynamic>;
            return {
              'message': data['message'] ?? '',
              'stackTrace': data['stackTrace'],
              'timestamp': e.timestamp.toIso8601String(),
              'severity': data['severity'] ?? 'error',
              'metadata': _sanitizeMetadata(data['metadata'] as Map<String, dynamic>?),
            };
          }).toList(),
        };
        
        _logDebug('Syncing ${errorItems.length} errors to $url');
        
        final response = await _httpClient!.post(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(requestBody),
        );
        
        _logDebug('Errors response: ${response.statusCode}');
        
        if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
          successfulIds.addAll(errorItems.map((e) => e.id));
        } else {
          failedIds.addAll(errorItems.map((e) => e.id));
        }
      }
      
      // Send analytics events
      if (analyticsItems.isNotEmpty) {
        final url = '$endpoint/analytics/events/batch';
        final requestBody = {
          'projectId': projectId,
          'events': analyticsItems.map((e) {
            final data = e.data as Map<String, dynamic>;
            return {
              'name': data['name'] ?? 'unknown',
              'timestamp': e.timestamp.toIso8601String(),
              'properties': data['properties'] ?? {},
              'userId': data['userId'],
              'sessionId': data['sessionId'],
            };
          }).toList(),
        };
        
        _logDebug('Syncing ${analyticsItems.length} analytics events to $url');
        
        final response = await _httpClient!.post(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(requestBody),
        );
        
        _logDebug('Analytics response: ${response.statusCode}');
        
        if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
          successfulIds.addAll(analyticsItems.map((e) => e.id));
        } else {
          failedIds.addAll(analyticsItems.map((e) => e.id));
        }
      }
      
      // Mark items as synced or failed
      if (successfulIds.isNotEmpty) {
        await _syncQueue.markAsSynced(successfulIds);
        _logDebug('Successfully synced ${successfulIds.length} items');
      }
      
      if (failedIds.isNotEmpty) {
        await _syncQueue.markAsFailed(failedIds);
        _logDebug('Failed to sync ${failedIds.length} items');
        if (kDebugMode) {
          print('[CloudSync] Failed to sync ${failedIds.length} items');
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
  
  // Helper function to sanitize metadata for JSON serialization
  static Map<String, dynamic> _sanitizeMetadata(Map<String, dynamic>? metadata) {
    if (metadata == null) return {};
    
    final sanitized = <String, dynamic>{};
    metadata.forEach((key, value) {
      if (value == null) {
        sanitized[key] = null;
      } else if (value is DateTime) {
        sanitized[key] = value.toIso8601String();
      } else if (value is Map) {
        sanitized[key] = _sanitizeMetadata(value as Map<String, dynamic>);
      } else if (value is List) {
        sanitized[key] = value.map((item) {
          if (item is DateTime) return item.toIso8601String();
          if (item is Map) return _sanitizeMetadata(item as Map<String, dynamic>);
          return item;
        }).toList();
      } else {
        sanitized[key] = value;
      }
    });
    return sanitized;
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