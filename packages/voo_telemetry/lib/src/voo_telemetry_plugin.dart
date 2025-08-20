import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:voo_core/voo_core.dart';
import 'package:voo_telemetry/voo_telemetry.dart';

/// VooTelemetryPlugin provides cloud syncing capabilities for all Voo packages.
/// It integrates with OpenTelemetry to send traces, metrics, and logs to the cloud.
class VooTelemetryPlugin extends VooPlugin {
  static VooTelemetryPlugin? _instance;
  final Map<String, VooTelemetry> _appTelemetry = {};
  bool _initialized = false;
  
  // Configuration
  String? _endpoint;
  String? _apiKey;
  
  VooTelemetryPlugin._();
  
  static VooTelemetryPlugin get instance {
    _instance ??= VooTelemetryPlugin._();
    return _instance!;
  }
  
  @override
  String get name => 'voo_telemetry';
  
  @override
  String get version => '0.2.0';
  
  bool get isInitialized => _initialized;
  
  /// Initialize the telemetry plugin with cloud configuration.
  static Future<void> initialize({
    required String endpoint,
    String? apiKey,
    Duration batchInterval = const Duration(seconds: 30),
    int maxBatchSize = 100,
    bool debug = false,
  }) async {
    final plugin = instance;
    
    if (plugin._initialized) {
      return;
    }
    
    if (!Voo.isInitialized) {
      throw const VooException(
        'Voo.initializeApp() must be called before initializing VooTelemetry',
        code: 'core-not-initialized',
      );
    }
    
    plugin._endpoint = endpoint;
    plugin._apiKey = apiKey;
    
    // Register the plugin with Voo
    await Voo.registerPlugin(plugin);
    plugin._initialized = true;
    
    if (kDebugMode) {
      debugPrint('VooTelemetry: Plugin initialized with endpoint: $endpoint');
    }
  }
  
  @override
  FutureOr<void> onAppInitialized(VooApp app) async {
    if (_endpoint == null) {
      throw const VooException(
        'VooTelemetry endpoint not configured',
        code: 'endpoint-not-configured',
      );
    }
    
    // Initialize OpenTelemetry for this app
    await VooTelemetry.initialize(
      endpoint: _endpoint!,
      apiKey: _apiKey,
      serviceName: app.options.appName ?? app.name,
      serviceVersion: app.options.appVersion ?? '1.0.0',
      additionalAttributes: {
        'app.name': app.name,
        'app.environment': app.options.environment,
        ...app.options.customConfig,
      },
      debug: app.options.enableDebugLogging,
    );
    
    // Store reference (VooTelemetry is a singleton currently)
    _appTelemetry[app.name] = VooTelemetry.instance;
    
    // Set up integrations with other plugins if they exist
    await _setupIntegrations(app);
    
    if (app.options.enableDebugLogging) {
      debugPrint('VooTelemetry initialized for app: ${app.name}');
    }
  }
  
  @override
  FutureOr<void> onAppDeleted(VooApp app) async {
    _appTelemetry.remove(app.name);
    // VooTelemetry handles its own cleanup via shutdown
  }
  
  /// Set up integrations with other Voo plugins.
  Future<void> _setupIntegrations(VooApp app) async {
    // Check if VooLogging is registered and set up log forwarding
    if (Voo.hasPlugin('voo_logging')) {
      _setupLoggingIntegration(app);
    }
    
    // Check if VooAnalytics is registered and set up event forwarding
    if (Voo.hasPlugin('voo_analytics')) {
      _setupAnalyticsIntegration(app);
    }
    
    // Check if VooPerformance is registered and set up metric forwarding
    if (Voo.hasPlugin('voo_performance')) {
      _setupPerformanceIntegration(app);
    }
  }
  
  void _setupLoggingIntegration(VooApp app) {
    // Get the logger for this app
    final loggingPlugin = Voo.getPlugin<VooPlugin>('voo_logging');
    if (loggingPlugin != null) {
      final logger = loggingPlugin.getInstanceForApp(app);
      if (logger != null) {
        // Set up log forwarding to OpenTelemetry
        // The actual implementation would set up stream listeners
        // to forward logs to the telemetry backend
        if (app.options.enableDebugLogging) {
          debugPrint('VooTelemetry: Logging integration enabled for app ${app.name}');
        }
      }
    }
  }
  
  void _setupAnalyticsIntegration(VooApp app) {
    // Get the analytics repository for this app
    final analyticsPlugin = Voo.getPlugin<VooPlugin>('voo_analytics');
    if (analyticsPlugin != null) {
      final repository = analyticsPlugin.getInstanceForApp(app);
      if (repository != null) {
        // Set up event forwarding to OpenTelemetry
        // The actual implementation would set up event listeners
        // to forward analytics events to the telemetry backend
        if (app.options.enableDebugLogging) {
          debugPrint('VooTelemetry: Analytics integration enabled for app ${app.name}');
        }
      }
    }
  }
  
  void _setupPerformanceIntegration(VooApp app) {
    // Get the performance data for this app
    final performancePlugin = Voo.getPlugin<VooPlugin>('voo_performance');
    if (performancePlugin != null) {
      final perfData = performancePlugin.getInstanceForApp(app);
      if (perfData != null) {
        // Set up trace and metric forwarding to OpenTelemetry
        // The actual implementation would set up performance listeners
        // to forward metrics to the telemetry backend
        if (app.options.enableDebugLogging) {
          debugPrint('VooTelemetry: Performance integration enabled for app ${app.name}');
        }
      }
    }
  }
  
  /// Get telemetry instance for a specific app.
  VooTelemetry? getTelemetryForApp([String appName = '[DEFAULT]']) {
    return _appTelemetry[appName];
  }
  
  /// Get the default telemetry instance.
  VooTelemetry? get defaultTelemetry => _appTelemetry['[DEFAULT]'];
  
  @override
  dynamic getInstanceForApp(VooApp app) {
    return _appTelemetry[app.name];
  }
  
  /// Manually flush all telemetry data.
  Future<void> flush() async {
    if (VooTelemetry.isInitialized) {
      await VooTelemetry.instance.flush();
    }
  }
  
  /// Record an exception.
  void recordException(
    dynamic exception,
    StackTrace? stackTrace, {
    Map<String, dynamic>? attributes,
  }) {
    if (VooTelemetry.isInitialized) {
      VooTelemetry.instance.recordException(
        exception,
        stackTrace,
        attributes: attributes,
      );
    }
  }
  
  @override
  FutureOr<void> dispose() async {
    await VooTelemetry.shutdown();
    _appTelemetry.clear();
    _initialized = false;
    _instance = null;
  }
  
  @override
  Map<String, dynamic> getInfo() {
    return {
      ...super.getInfo(),
      'initialized': _initialized,
      'endpoint': _endpoint,
      'apps': _appTelemetry.keys.toList(),
    };
  }
}