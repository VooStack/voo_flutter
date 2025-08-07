import 'dart:async';
import 'package:voo_analytics/src/domain/entities/touch_event.dart';

abstract class AnalyticsRepository {
  bool get enableTouchTracking;
  bool get enableEventLogging;
  bool get enableUserProperties;

  Future<void> initialize();
  
  Future<void> logEvent(String name, {Map<String, dynamic>? parameters});
  
  Future<void> logTouchEvent(TouchEvent event);
  
  Future<void> setUserProperty(String name, String value);
  
  Future<void> setUserId(String userId);
  
  Future<Map<String, dynamic>> getHeatMapData({
    DateTime? startDate,
    DateTime? endDate,
  });
  
  Future<List<TouchEvent>> getTouchEvents({
    String? screenName,
    DateTime? startDate,
    DateTime? endDate,
  });
  
  Future<void> clearData();
  
  void dispose();
}