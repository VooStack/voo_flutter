import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:voo_core/voo_core.dart';
import 'package:voo_performance/src/domain/entities/performance_trace.dart';
import 'package:voo_performance/src/domain/entities/network_metric.dart';

class VooPerformancePlugin extends VooPlugin {
  static VooPerformancePlugin? _instance;
  bool _initialized = false;
  final Map<String, PerformanceTrace> _activeTraces = {};
  final List<NetworkMetric> _networkMetrics = [];
  final List<PerformanceMetrics> _performanceMetrics = [];

  VooPerformancePlugin._();

  static VooPerformancePlugin get instance {
    _instance ??= VooPerformancePlugin._();
    return _instance!;
  }

  @override
  String get name => 'voo_performance';

  @override
  String get version => '0.2.0';

  bool get isInitialized => _initialized;

  static Future<void> initialize({
    bool enableNetworkMonitoring = true,
    bool enableTraceMonitoring = true,
    bool enableAutoAppStartTrace = true,
  }) async {
    final plugin = instance;

    if (plugin._initialized) {
      return;
    }

    if (!Voo.isInitialized) {
      throw const VooException(
        'Voo.initializeApp() must be called before initializing VooPerformance',
        code: 'core-not-initialized',
      );
    }

    // Set initialized flag before creating traces
    plugin._initialized = true;
    await Voo.registerPlugin(plugin);

    if (enableAutoAppStartTrace) {
      final appStartTrace = plugin.newTrace('app_start');
      appStartTrace.start();
      // Don't await this - let it complete in background
      Future.delayed(const Duration(milliseconds: 100), () {
        if (plugin._initialized) {
          appStartTrace.stop();
        }
      });
    }

    if (kDebugMode) {
      debugPrint(
        '[VooPerformance] Initialized with network monitoring: $enableNetworkMonitoring',
      );
    }
  }

  PerformanceTrace newTrace(String name) {
    if (!_initialized) {
      throw const VooException(
        'VooPerformance not initialized. Call initialize() first.',
        code: 'not-initialized',
      );
    }

    final trace = PerformanceTrace(name: name, startTime: DateTime.now());
    trace.setStopCallback(recordTrace);
    _activeTraces[trace.id] = trace;
    return trace;
  }

  PerformanceTrace newHttpTrace(String url, String method) {
    final trace = newTrace('http_$method');
    trace.putAttribute('url', url);
    trace.putAttribute('method', method);
    return trace;
  }

  Future<void> recordTrace(PerformanceTrace trace) async {
    _activeTraces.remove(trace.id);

    final metrics = PerformanceMetrics(
      timestamp: trace.startTime,
      duration: trace.duration ?? Duration.zero,
      customMetrics: {
        'name': trace.name,
        ...trace.attributes,
        if (trace.metrics.isNotEmpty) 'metrics': trace.metrics,
      },
    );

    _performanceMetrics.add(metrics);

    if (_performanceMetrics.length > 1000) {
      _performanceMetrics.removeRange(0, 100);
    }

    // Send to DevTools
    _sendToDevTools(
      category: 'Performance',
      message: 'Performance trace: ${trace.name}',
      metadata: {
        'operationType': 'trace',
        'operation': trace.name,
        'duration': trace.duration?.inMilliseconds ?? 0,
        'startTime': trace.startTime.toIso8601String(),
        ...trace.attributes,
        if (trace.metrics.isNotEmpty) 'metrics': trace.metrics,
      },
    );
  }

  Future<void> recordNetworkMetric(NetworkMetric metric) async {
    _networkMetrics.add(metric);

    if (_networkMetrics.length > 1000) {
      _networkMetrics.removeRange(0, 100);
    }

    // Send to DevTools
    _sendToDevTools(
      category: 'Network',
      message: '${metric.method} ${metric.url}',
      metadata: {
        'operationType': 'network',
        'operation': '${metric.method} ${Uri.parse(metric.url).path}',
        'method': metric.method,
        'url': metric.url,
        'statusCode': metric.statusCode,
        'duration': metric.duration.inMilliseconds,
        'requestSize': metric.requestSize,
        'responseSize': metric.responseSize,
        'timestamp': metric.timestamp.toIso8601String(),
      },
    );
  }

  void _sendToDevTools({
    required String category,
    required String message,
    Map<String, dynamic>? metadata,
  }) {
    try {
      final timestamp = DateTime.now();
      
      // Create entry data, filtering out null values for web compatibility
      final entryData = <String, dynamic>{
        'id': '${category.toLowerCase()}_${timestamp.millisecondsSinceEpoch}',
        'timestamp': timestamp.toIso8601String(),
        'message': message,
        'level': 'info',
        'category': category,
        'tag': 'VooPerformance',
      };
      
      // Add metadata if present, filtering out null values
      if (metadata != null) {
        final cleanMetadata = <String, dynamic>{};
        metadata.forEach((key, value) {
          if (value != null) cleanMetadata[key] = value;
        });
        if (cleanMetadata.isNotEmpty) entryData['metadata'] = cleanMetadata;
      }
      
      final structuredData = {
        '__voo_logger__': true,
        'entry': entryData,
      };

      // Send via postEvent for DevTools extension
      developer.postEvent('voo_logger_event', structuredData);
    } catch (_) {
      // Silent fail - logging is best effort
    }
  }

  Map<String, dynamic> getMetricsSummary() {
    final avgResponseTime = _networkMetrics.isEmpty
        ? 0
        : _networkMetrics
                  .map((m) => m.duration.inMilliseconds)
                  .reduce((a, b) => a + b) /
              _networkMetrics.length;

    final errorRate = _networkMetrics.isEmpty
        ? 0
        : _networkMetrics.where((m) => m.statusCode >= 400).length /
              _networkMetrics.length;

    return {
      'network': {
        'total_requests': _networkMetrics.length,
        'average_response_time_ms': avgResponseTime,
        'error_rate': errorRate,
      },
      'traces': {
        'total_traces': _performanceMetrics.length,
        'active_traces': _activeTraces.length,
      },
    };
  }

  List<NetworkMetric> getNetworkMetrics({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _networkMetrics.where((metric) {
      if (startDate != null && metric.timestamp.isBefore(startDate)) {
        return false;
      }
      if (endDate != null && metric.timestamp.isAfter(endDate)) {
        return false;
      }
      return true;
    }).toList();
  }

  void clearMetrics() {
    _networkMetrics.clear();
    _performanceMetrics.clear();
    _activeTraces.clear();
  }

  @override
  FutureOr<void> onAppInitialized(VooApp app) {
    if (!_initialized && app.options.autoRegisterPlugins) {
      if (kDebugMode) {
        debugPrint('[VooPerformance] Plugin auto-registered');
      }
    }
  }

  @override
  FutureOr<void> onAppDeleted(VooApp app) {
    // Clean up any app-specific resources if needed
  }

  @override
  dynamic getInstanceForApp(VooApp app) {
    // Return the plugin instance for telemetry to access
    return this;
  }

  @override
  FutureOr<void> dispose() {
    clearMetrics();
    _initialized = false;
    _instance = null;
  }

  @override
  Map<String, dynamic> getInfo() {
    return {
      ...super.getInfo(),
      'initialized': _initialized,
      'metrics': getMetricsSummary(),
    };
  }
}
