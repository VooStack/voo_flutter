import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:voo_core/voo_core.dart';
import 'package:voo_analytics/src/domain/repositories/analytics_repository.dart';
import 'package:voo_analytics/src/data/repositories/analytics_repository_impl.dart';

class VooAnalyticsPlugin extends VooPlugin {
  static VooAnalyticsPlugin? _instance;
  AnalyticsRepository? repository;
  bool _initialized = false;

  VooAnalyticsPlugin._();

  static VooAnalyticsPlugin get instance {
    _instance ??= VooAnalyticsPlugin._();
    return _instance!;
  }

  @override
  String get name => 'voo_analytics';

  @override
  String get version => '0.0.1';

  bool get isInitialized => _initialized;

  Future<void> initialize({
    bool enableTouchTracking = true,
    bool enableEventLogging = true,
    bool enableUserProperties = true,
  }) async {
    if (_initialized) {
      return;
    }

    if (!Voo.isInitialized) {
      throw VooException(
        'Voo.initializeApp() must be called before initializing VooAnalytics',
        code: 'core-not-initialized',
      );
    }

    repository = AnalyticsRepositoryImpl(
      enableTouchTracking: enableTouchTracking,
      enableEventLogging: enableEventLogging,
      enableUserProperties: enableUserProperties,
    );

    await repository!.initialize();

    Voo.registerPlugin(this);
    _initialized = true;

    if (kDebugMode) {
      print('[VooAnalytics] Initialized with touch tracking: $enableTouchTracking');
    }
  }

  Future<void> logEvent(String name, {Map<String, dynamic>? parameters}) async {
    if (!_initialized) {
      throw VooException(
        'VooAnalytics not initialized. Call initialize() first.',
        code: 'not-initialized',
      );
    }
    await repository!.logEvent(name, parameters: parameters);
  }

  Future<void> setUserProperty(String name, String value) async {
    if (!_initialized) {
      throw VooException(
        'VooAnalytics not initialized. Call initialize() first.',
        code: 'not-initialized',
      );
    }
    await repository!.setUserProperty(name, value);
  }

  Future<void> setUserId(String userId) async {
    if (!_initialized) {
      throw VooException(
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
      throw VooException(
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
  FutureOr<void> onCoreInitialized() {
    if (!_initialized && Voo.options?.autoRegisterPlugins == true) {
      if (kDebugMode) {
        print('[VooAnalytics] Plugin auto-registered');
      }
    }
  }

  @override
  void dispose() {
    repository?.dispose();
    repository = null;
    _initialized = false;
    _instance = null;
    super.dispose();
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