import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:voo_analytics/src/domain/entities/touch_event.dart';
import 'package:voo_analytics/src/domain/entities/heat_map_data.dart';
import 'package:voo_analytics/src/domain/repositories/analytics_repository.dart';

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
    
    // Send to DevTools
    _sendToDevTools(
      category: 'Analytics',
      message: 'Analytics event: $name',
      metadata: {
        'type': 'analytics_event',
        'eventName': name,
        ...?parameters,
        'timestamp': timestamp.toIso8601String(),
      },
    );
    
    if (kDebugMode) {
      print('[VooAnalytics] Event logged: $name');
    }
  }

  @override
  Future<void> trackTouchEvent(TouchEvent event) async {
    if (!enableTouchTracking) return;
    
    _touchEvents.add(event);
    
    // Keep list bounded
    if (_touchEvents.length > 10000) {
      _touchEvents.removeRange(0, 1000);
    }
    
    await _saveData();
    
    // Send to DevTools
    _sendToDevTools(
      category: 'Analytics',
      message: 'Touch event at (${event.x.toStringAsFixed(1)}, ${event.y.toStringAsFixed(1)})',
      metadata: {
        'type': 'touch_event',
        'x': event.x,
        'y': event.y,
        'screenName': event.screenName,
        'screen': event.route ?? event.screenName,
        'touchType': event.type.name,
        'timestamp': event.timestamp.toIso8601String(),
        'route': event.route,
        'widgetKey': event.widgetKey,
        'widgetType': event.widgetType,
      },
    );
    
    if (kDebugMode) {
      print('[VooAnalytics] Touch event tracked at (${event.x}, ${event.y})');
    }
  }

  @override
  Future<void> setUserProperty(String name, String value) async {
    if (!enableUserProperties) return;
    
    _userProperties[name] = value;
    await _saveData();
    
    if (kDebugMode) {
      print('[VooAnalytics] User property set: $name = $value');
    }
  }

  @override
  Future<void> setUserId(String userId) async {
    _userId = userId;
    await _saveData();
    
    if (kDebugMode) {
      print('[VooAnalytics] User ID set: $userId');
    }
  }

  @override
  Future<Map<String, dynamic>> getHeatMapData({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final filteredEvents = _touchEvents.where((event) {
      if (startDate != null && event.timestamp.isBefore(startDate)) {
        return false;
      }
      if (endDate != null && event.timestamp.isAfter(endDate)) {
        return false;
      }
      return true;
    }).toList();

    // Group by route
    final Map<String, List<TouchEvent>> routeEvents = {};
    for (final event in filteredEvents) {
      final route = event.route ?? 'unknown';
      routeEvents[route] ??= [];
      routeEvents[route]!.add(event);
    }

    // Generate heat map data for each route
    final Map<String, dynamic> heatMapData = {};
    for (final entry in routeEvents.entries) {
      final route = entry.key;
      final events = entry.value;
      
      // Create heat map grid (simplified)
      final List<HeatMapPoint> points = [];
      for (final event in events) {
        points.add(HeatMapPoint(
          position: Offset(event.x, event.y),
          intensity: 1.0,
          count: 1,
          primaryType: TouchType.tap,
        ));
      }
      
      heatMapData[route] = {
        'points': points.map((p) => p.toMap()).toList(),
        'event_count': events.length,
      };
    }

    return heatMapData;
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
    
    if (kDebugMode) {
      print('[VooAnalytics] All data cleared');
    }
  }

  @override
  Future<void> logTouchEvent(TouchEvent event) async {
    // Alias for trackTouchEvent for backward compatibility
    await trackTouchEvent(event);
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
  void dispose() {
    // Clean up resources if needed
  }
  
  void _sendToDevTools({
    required String category,
    required String message,
    Map<String, dynamic>? metadata,
  }) {
    try {
      final timestamp = DateTime.now();
      final structuredData = {
        '__voo_logger__': true,
        'entry': {
          'id': '${category.toLowerCase()}_${timestamp.millisecondsSinceEpoch}',
          'timestamp': timestamp.toIso8601String(),
          'message': message,
          'level': 'info',
          'category': category,
          'tag': 'VooAnalytics',
          'metadata': metadata,
        },
      };
      
      // Send via postEvent for DevTools extension
      developer.postEvent('voo_logger_event', structuredData);
    } catch (_) {
      // Silent fail - logging is best effort
    }
  }
}