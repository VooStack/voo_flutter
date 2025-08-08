import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:voo_core/voo_core.dart';
import 'package:voo_logging/voo_logging.dart';
import 'package:voo_performance/src/data/models/performance_sync_entity.dart';
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
  String get version => '0.0.1';

  bool get isInitialized => _initialized;

  Future<void> initialize({
    bool enableNetworkMonitoring = true,
    bool enableTraceMonitoring = true,
    bool enableAutoAppStartTrace = true,
  }) async {
    if (_initialized) {
      return;
    }

    if (!Voo.isInitialized) {
      throw VooException(
        'Voo.initializeApp() must be called before initializing VooPerformance',
        code: 'core-not-initialized',
      );
    }

    // Set initialized flag before creating traces
    _initialized = true;
    Voo.registerPlugin(this);

    if (enableAutoAppStartTrace) {
      final appStartTrace = newTrace('app_start');
      appStartTrace.start();
      Future.delayed(const Duration(milliseconds: 100), () {
        appStartTrace.stop();
      });
    }

    if (kDebugMode) {
      print('[VooPerformance] Initialized with network monitoring: $enableNetworkMonitoring');
    }
  }

  PerformanceTrace newTrace(String name) {
    if (!_initialized) {
      throw VooException(
        'VooPerformance not initialized. Call initialize() first.',
        code: 'not-initialized',
      );
    }

    final trace = PerformanceTrace(
      name: name,
      startTime: DateTime.now(),
    );
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
    
    // Send performance trace to VooLogger
    VooLogger.info(
      'Performance trace: ${trace.name}',
      category: 'Performance',
      metadata: {
        'operation': trace.name,
        'operationType': trace.attributes['operation_type'] ?? 'trace',
        'duration': trace.duration?.inMilliseconds ?? 0,
        'duration_ms': trace.duration?.inMilliseconds ?? 0,
        'attributes': trace.attributes,
        'metrics': trace.metrics,
        'timestamp': trace.startTime.toIso8601String(),
      },
    );
    
    // Sync to cloud if enabled
    final options = Voo.options;
    if (options != null && options.enableCloudSync && options.apiKey != null) {
      final syncEntity = PerformanceSyncEntity.fromTrace(trace: trace);
      await CloudSyncManager.instance.addToQueue(syncEntity);
    }
    
    if (_performanceMetrics.length > 1000) {
      _performanceMetrics.removeRange(0, 100);
    }
  }

  Future<void> recordNetworkMetric(NetworkMetric metric) async {
    _networkMetrics.add(metric);
    
    // Send network metric to VooLogger for DevTools streaming
    VooLogger.info(
      'Network request: ${metric.method} ${metric.url}',
      category: 'Performance',
      metadata: {
        'operation': 'network_request',
        'operationType': 'network',
        'url': metric.url,
        'method': metric.method,
        'statusCode': metric.statusCode,
        'duration': metric.duration.inMilliseconds,
        'duration_ms': metric.duration.inMilliseconds,
        'requestSize': metric.requestSize,
        'responseSize': metric.responseSize,
        'timestamp': metric.timestamp.toIso8601String(),
        ...?metric.metadata,
      },
    );
    
    // Sync to cloud if enabled
    final options = Voo.options;
    if (options != null && options.enableCloudSync && options.apiKey != null) {
      final syncEntity = PerformanceSyncEntity.fromNetworkMetric(metric: metric);
      await CloudSyncManager.instance.addToQueue(syncEntity);
    }
    
    if (_networkMetrics.length > 1000) {
      _networkMetrics.removeRange(0, 100);
    }
  }

  Map<String, dynamic> getMetricsSummary() {
    final avgResponseTime = _networkMetrics.isEmpty
        ? 0
        : _networkMetrics
            .map((m) => m.duration.inMilliseconds)
            .reduce((a, b) => a + b) / _networkMetrics.length;

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
  FutureOr<void> onCoreInitialized() {
    if (!_initialized && Voo.options?.autoRegisterPlugins == true) {
      if (kDebugMode) {
        print('[VooPerformance] Plugin auto-registered');
      }
    }
  }

  @override
  void dispose() {
    clearMetrics();
    _initialized = false;
    _instance = null;
    super.dispose();
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