import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:voo_core/voo_core.dart';
import 'package:voo_analytics/src/domain/repositories/analytics_repository.dart';
import 'package:voo_analytics/src/data/repositories/analytics_repository_impl.dart';
import 'package:voo_analytics/src/presentation/widgets/route_aware_touch_tracker.dart';

class VooAnalyticsPlugin extends VooPlugin {
  static VooAnalyticsPlugin? _instance;
  AnalyticsRepository? repository;
  AnalyticsRouteObserver? _routeObserver;
  bool _initialized = false;

  VooAnalyticsPlugin._();

  static VooAnalyticsPlugin get instance {
    _instance ??= VooAnalyticsPlugin._();
    return _instance!;
  }

  @override
  String get name => 'voo_analytics';

  @override
  String get version => '0.2.0';

  bool get isInitialized => _initialized;

  RouteObserver<ModalRoute> get routeObserver {
    _routeObserver ??= AnalyticsRouteObserver();
    return _routeObserver!;
  }

  static Future<void> initialize({
    bool enableTouchTracking = true,
    bool enableEventLogging = true,
    bool enableUserProperties = true,
  }) async {
    final plugin = instance;

    if (plugin._initialized) {
      return;
    }

    if (!Voo.isInitialized) {
      throw const VooException(
        'Voo.initializeApp() must be called before initializing VooAnalytics',
        code: 'core-not-initialized',
      );
    }

    plugin.repository = AnalyticsRepositoryImpl(
      enableTouchTracking: enableTouchTracking,
      enableEventLogging: enableEventLogging,
      enableUserProperties: enableUserProperties,
    );

    await plugin.repository!.initialize();

    await Voo.registerPlugin(plugin);
    plugin._initialized = true;

    if (kDebugMode) {
      debugPrint(
        '[VooAnalytics] Initialized with touch tracking: $enableTouchTracking',
      );
    }
  }

  Future<void> logEvent(String name, {Map<String, dynamic>? parameters}) async {
    if (!_initialized) {
      throw const VooException(
        'VooAnalytics not initialized. Call initialize() first.',
        code: 'not-initialized',
      );
    }
    await repository!.logEvent(name, parameters: parameters);
  }

  Future<void> setUserProperty(String name, String value) async {
    if (!_initialized) {
      throw const VooException(
        'VooAnalytics not initialized. Call initialize() first.',
        code: 'not-initialized',
      );
    }
    await repository!.setUserProperty(name, value);
  }

  Future<void> setUserId(String userId) async {
    if (!_initialized) {
      throw const VooException(
        'VooAnalytics not initialized. Call initialize() first.',
        code: 'not-initialized',
      );
    }
    await repository!.setUserId(userId);
  }

  Future<Map<String, dynamic>> getHeatMapData({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (!_initialized) {
      throw const VooException(
        'VooAnalytics not initialized. Call initialize() first.',
        code: 'not-initialized',
      );
    }
    return repository!.getHeatMapData(startDate: startDate, endDate: endDate);
  }

  Future<void> clearData() async {
    if (!_initialized) return;
    await repository!.clearData();
  }

  @override
  FutureOr<void> onAppInitialized(VooApp app) {
    if (!_initialized && app.options.autoRegisterPlugins) {
      if (kDebugMode) {
        debugPrint('[VooAnalytics] Plugin auto-registered');
      }
    }
  }

  @override
  FutureOr<void> onAppDeleted(VooApp app) {
    // Clean up any app-specific resources if needed
  }

  @override
  dynamic getInstanceForApp(VooApp app) {
    // Return the repository for telemetry to access
    return repository;
  }

  @override
  FutureOr<void> dispose() {
    repository?.dispose();
    repository = null;
    _initialized = false;
    _instance = null;
  }

  @override
  Map<String, dynamic> getInfo() {
    return {
      ...super.getInfo(),
      'initialized': _initialized,
      'features': {
        'touchTracking': repository?.enableTouchTracking ?? false,
        'eventLogging': repository?.enableEventLogging ?? false,
        'userProperties': repository?.enableUserProperties ?? false,
      },
    };
  }
}
