import 'package:voo_performance/src/voo_performance_plugin.dart';
import 'package:voo_performance/src/domain/entities/performance_trace.dart';

class PerformanceTracker {
  final String operation;
  final String? operationType;
  final Map<String, dynamic> metrics;
  final PerformanceTrace _trace;
  bool _completed = false;

  PerformanceTracker({
    required this.operation,
    this.operationType,
    Map<String, dynamic>? metrics,
  }) : metrics = metrics ?? {},
       _trace = VooPerformancePlugin.instance.newTrace(operation) {
    _trace.start();
    final opType = operationType;
    if (opType != null) {
      _trace.putAttribute('operation_type', opType);
    }
  }

  void addMetric(String key, dynamic value) {
    if (!_completed && value is int) {
      _trace.putMetric(key, value);
    } else if (!_completed) {
      metrics[key] = value;
    }
  }

  void addMetrics(Map<String, dynamic> newMetrics) {
    if (!_completed) {
      newMetrics.forEach((key, value) {
        if (value is int) {
          _trace.putMetric(key, value);
        } else {
          metrics[key] = value;
        }
      });
    }
  }

  Future<void> complete({Map<String, dynamic>? additionalMetrics}) async {
    if (_completed) return;
    _completed = true;

    if (additionalMetrics != null) {
      addMetrics(additionalMetrics);
    }

    metrics.forEach((key, value) {
      if (value != null) {
        _trace.putAttribute(key, value.toString());
      }
    });

    _trace.stop();
  }

  static Future<T> track<T>({
    required String operation,
    required Future<T> Function() action,
    String? operationType,
    Map<String, dynamic>? metrics,
  }) async {
    final tracker = PerformanceTracker(
      operation: operation,
      operationType: operationType,
      metrics: metrics,
    );

    try {
      final result = await action();
      await tracker.complete();
      return result;
    } catch (error, stackTrace) {
      await tracker.complete(
        additionalMetrics: {
          'error': error.toString(),
          'stackTrace': stackTrace.toString(),
        },
      );
      rethrow;
    }
  }

  static T trackSync<T>({
    required String operation,
    required T Function() action,
    String? operationType,
    Map<String, dynamic>? metrics,
  }) {
    final tracker = PerformanceTracker(
      operation: operation,
      operationType: operationType,
      metrics: metrics,
    );

    try {
      final result = action();
      tracker.complete();
      return result;
    } catch (error, stackTrace) {
      tracker.complete(
        additionalMetrics: {
          'error': error.toString(),
          'stackTrace': stackTrace.toString(),
        },
      );
      rethrow;
    }
  }
}
