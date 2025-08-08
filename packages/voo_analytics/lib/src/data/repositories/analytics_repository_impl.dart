import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:voo_core/voo_core.dart';
import 'package:voo_analytics/src/data/models/analytics_sync_entity.dart';
import 'package:voo_analytics/src/domain/entities/touch_event.dart';
import 'package:voo_analytics/src/domain/entities/heat_map_data.dart';
import 'package:voo_analytics/src/domain/repositories/analytics_repository.dart';
import 'package:voo_logging/voo_logging.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final List<TouchEvent> _touchEvents = [];
  final Map<String, dynamic> _events = {};
  final Map<String, String> _userProperties = {};
  String? _userId;
  File? _storageFile;

  @override
  final bool enableTouchTracking;
  
  @override
  final bool enableEventLogging;
  
  @override
  final bool enableUserProperties;

  AnalyticsRepositoryImpl({
    this.enableTouchTracking = true,
    this.enableEventLogging = true,
    this.enableUserProperties = true,
  });

  @override
  Future<void> initialize() async {
    if (!kIsWeb) {
      final directory = await getApplicationDocumentsDirectory();
      final analyticsDir = Directory(path.join(directory.path, 'voo_analytics'));
      if (!await analyticsDir.exists()) {
        await analyticsDir.create(recursive: true);
      }
      _storageFile = File(path.join(analyticsDir.path, 'analytics_data.json'));
      await _loadData();
    }
  }

  Future<void> _loadData() async {
    if (_storageFile != null && await _storageFile!.exists()) {
      try {
        final content = await _storageFile!.readAsString();
        final data = jsonDecode(content) as Map<String, dynamic>;
        
        if (data['touch_events'] != null) {
          final events = data['touch_events'] as List;
          _touchEvents.addAll(
            events.map((e) => TouchEvent.fromMap(e as Map<String, dynamic>)),
          );
        }
        
        if (data['events'] != null) {
          _events.addAll(data['events'] as Map<String, dynamic>);
        }
        
        if (data['user_properties'] != null) {
          _userProperties.addAll(
            Map<String, String>.from(data['user_properties'] as Map),
          );
        }
        
        _userId = data['user_id'] as String?;
      } catch (e) {
        if (kDebugMode) {
          print('[VooAnalytics] Error loading data: $e');
        }
      }
    }
  }

  Future<void> _saveData() async {
    if (_storageFile != null) {
      try {
        final data = {
          'touch_events': _touchEvents.map((e) => e.toMap()).toList(),
          'events': _events,
          'user_properties': _userProperties,
          'user_id': _userId,
        };
        await _storageFile!.writeAsString(jsonEncode(data));
      } catch (e) {
        if (kDebugMode) {
          print('[VooAnalytics] Error saving data: $e');
        }
      }
    }
  }

  @override
  Future<void> logEvent(String name, {Map<String, dynamic>? parameters}) async {
    if (!enableEventLogging) return;
    
    final timestamp = DateTime.now();
    final event = {
      'timestamp': timestamp.toIso8601String(),
      'parameters': parameters ?? {},
    };
    
    if (_events[name] == null) {
      _events[name] = [];
    }
    (_events[name] as List).add(event);
    
    await _saveData();
    
    // Send to VooLogger for DevTools streaming
    VooLogger.info(
      'Analytics Event: $name',
      category: 'analytics',
      metadata: {
        'type': 'custom_event',
        'event_name': name,
        'timestamp': timestamp.toIso8601String(),
        ...?parameters,
      },
    );
    
    // Sync to cloud if enabled
    final options = Voo.options;
    if (options != null && options.enableCloudSync && options.apiKey != null) {
      final syncEntity = AnalyticsSyncEntity(
        id: '${timestamp.millisecondsSinceEpoch}_$name',
        timestamp: timestamp,
        eventType: 'custom_event',
        eventData: {
          'event_name': name,
          'parameters': parameters ?? {},
          'user_id': _userId,
        },
      );
      await CloudSyncManager.instance.addToQueue(syncEntity);
    }
    
    if (kDebugMode) {
      print('[VooAnalytics] Event logged: $name');
    }
  }

  @override
  Future<void> logTouchEvent(TouchEvent event) async {
    if (!enableTouchTracking) return;
    
    _touchEvents.add(event);
    
    if (_touchEvents.length > 10000) {
      _touchEvents.removeRange(0, 1000);
    }
    
    await _saveData();
    
    // Send to VooLogger for DevTools streaming
    VooLogger.info(
      'Touch Event: ${event.type.name} at ${event.screenName}',
      category: 'analytics',
      metadata: {
        'type': 'touch_event',
        'touch_type': event.type.name,
        'screen': event.screenName,
        'x': event.position.dx,
        'y': event.position.dy,
        'widget_type': event.widgetType,
        'widget_key': event.widgetKey,
        'timestamp': event.timestamp.toIso8601String(),
      },
    );
    
    // Sync to cloud if enabled
    final options = Voo.options;
    if (options != null && options.enableCloudSync && options.apiKey != null) {
      final syncEntity = AnalyticsSyncEntity(
        id: '${event.timestamp.millisecondsSinceEpoch}_touch_${event.screenName}',
        timestamp: event.timestamp,
        eventType: 'touch_event',
        eventData: {
          'touch_type': event.type.name,
          'screen': event.screenName,
          'position': {'x': event.position.dx, 'y': event.position.dy},
          'widget_type': event.widgetType,
          'widget_key': event.widgetKey,
          'user_id': _userId,
        },
      );
      await CloudSyncManager.instance.addToQueue(syncEntity);
    }
  }

  @override
  Future<void> setUserProperty(String name, String value) async {
    if (!enableUserProperties) return;
    
    _userProperties[name] = value;
    await _saveData();
  }

  @override
  Future<void> setUserId(String userId) async {
    _userId = userId;
    await _saveData();
  }

  @override
  Future<Map<String, dynamic>> getHeatMapData({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final start = startDate ?? DateTime.now().subtract(const Duration(days: 7));
    final end = endDate ?? DateTime.now();
    
    final filteredEvents = _touchEvents.where((event) {
      return event.timestamp.isAfter(start) && event.timestamp.isBefore(end);
    }).toList();
    
    final Map<String, List<TouchEvent>> groupedByScreen = {};
    for (final event in filteredEvents) {
      groupedByScreen.putIfAbsent(event.screenName, () => []).add(event);
    }
    
    final Map<String, dynamic> heatMaps = {};
    
    for (final entry in groupedByScreen.entries) {
      final screenName = entry.key;
      final events = entry.value;
      
      final Map<String, dynamic> pointsMap = {};
      
      for (final event in events) {
        final key = '${event.position.dx.toInt()}_${event.position.dy.toInt()}';
        
        if (!pointsMap.containsKey(key)) {
          pointsMap[key] = {
            'position': event.position,
            'count': 0,
            'types': <TouchType, int>{},
          };
        }
        
        pointsMap[key]['count']++;
        final types = pointsMap[key]['types'] as Map<TouchType, int>;
        types[event.type] = (types[event.type] ?? 0) + 1;
      }
      
      final points = pointsMap.values.map((data) {
        final types = data['types'] as Map<TouchType, int>;
        final primaryType = types.entries
            .reduce((a, b) => a.value > b.value ? a : b)
            .key;
        
        return HeatMapPoint(
          position: data['position'],
          intensity: (data['count'] as int) / events.length,
          count: data['count'] as int,
          primaryType: primaryType,
        );
      }).toList();
      
      heatMaps[screenName] = HeatMapData(
        screenName: screenName,
        screenSize: const Size(400, 800),
        points: points,
        startDate: start,
        endDate: end,
        totalEvents: events.length,
      ).toMap();
    }
    
    return heatMaps;
  }

  @override
  Future<List<TouchEvent>> getTouchEvents({
    String? screenName,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return _touchEvents.where((event) {
      if (screenName != null && event.screenName != screenName) {
        return false;
      }
      if (startDate != null && event.timestamp.isBefore(startDate)) {
        return false;
      }
      if (endDate != null && event.timestamp.isAfter(endDate)) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Future<void> clearData() async {
    _touchEvents.clear();
    _events.clear();
    _userProperties.clear();
    _userId = null;
    
    if (_storageFile != null && await _storageFile!.exists()) {
      await _storageFile!.delete();
    }
  }

  @override
  void dispose() {
    _touchEvents.clear();
    _events.clear();
    _userProperties.clear();
  }
}