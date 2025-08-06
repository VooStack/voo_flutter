import 'package:voo_logging/features/logging/domain/entities/voo_logger.dart';

class PerformanceTracker {
  final String operation;
  final String? operationType;
  final Map<String, dynamic> metrics;
  final DateTime _startTime;
  bool _completed = false;

  PerformanceTracker({required this.operation, this.operationType, Map<String, dynamic>? metrics}) : metrics = metrics ?? {}, _startTime = DateTime.now();

  void addMetric(String key, dynamic value) {
    if (!_completed) {
      metrics[key] = value;
    }
  }

  void addMetrics(Map<String, dynamic> newMetrics) {
    if (!_completed) {
      metrics.addAll(newMetrics);
    }
  }

  Future<void> complete({Map<String, dynamic>? additionalMetrics}) async {
    if (_completed) return;
    _completed = true;

    final duration = DateTime.now().difference(_startTime);

    if (additionalMetrics != null) {
      metrics.addAll(additionalMetrics);
    }

    final Map<String, Object> performanceMetrics = {};
    metrics.forEach((key, value) {
      if (value != null) {
        performanceMetrics[key] = value as Object;
      }
    });
    final opType = operationType;
    if (opType != null) {
      performanceMetrics['operationType'] = opType;
    }
    performanceMetrics['startTime'] = _startTime.toIso8601String();
    performanceMetrics['endTime'] = DateTime.now().toIso8601String();
    
    VooLogger.performance(
      operation,
      duration,
      metrics: performanceMetrics,
    );
  }

  static Future<T> track<T>({required String operation, required Future<T> Function() action, String? operationType, Map<String, dynamic>? metrics}) async {
    final tracker = PerformanceTracker(operation: operation, operationType: operationType, metrics: metrics);

    try {
      final result = await action();
      await tracker.complete();
      return result;
    } catch (error, stackTrace) {
      await tracker.complete(additionalMetrics: {'error': error.toString(), 'stackTrace': stackTrace.toString()});
      rethrow;
    }
  }

  static T trackSync<T>({required String operation, required T Function() action, String? operationType, Map<String, dynamic>? metrics}) {
    final tracker = PerformanceTracker(operation: operation, operationType: operationType, metrics: metrics);

    try {
      final result = action();
      tracker.complete();
      return result;
    } catch (error, stackTrace) {
      tracker.complete(additionalMetrics: {'error': error.toString(), 'stackTrace': stackTrace.toString()});
      rethrow;
    }
  }
}
