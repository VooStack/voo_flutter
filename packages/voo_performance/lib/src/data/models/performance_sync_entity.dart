import 'package:voo_core/voo_core.dart';
import 'package:voo_performance/src/domain/entities/performance_trace.dart';
import 'package:voo_performance/src/domain/entities/network_metric.dart';

class PerformanceSyncEntity extends SyncEntity {
  PerformanceSyncEntity.fromTrace({
    required PerformanceTrace trace,
    super.isSynced,
    super.retryCount,
  }) : super(
          id: trace.id,
          type: 'performance_trace',
          timestamp: trace.startTime,
          data: {
            'name': trace.name,
            'duration_ms': trace.duration?.inMilliseconds ?? 0,
            'attributes': trace.attributes,
            'metrics': trace.metrics,
          },
        );
  
  PerformanceSyncEntity.fromNetworkMetric({
    required NetworkMetric metric,
    super.isSynced,
    super.retryCount,
  }) : super(
          id: '${metric.timestamp.millisecondsSinceEpoch}_${metric.url}',
          type: 'network_metric',
          timestamp: metric.timestamp,
          data: {
            'url': metric.url,
            'method': metric.method,
            'statusCode': metric.statusCode,
            'duration_ms': metric.duration.inMilliseconds,
            'requestSize': metric.requestSize,
            'responseSize': metric.responseSize,
            'metadata': metric.metadata,
          },
        );
  
  @override
  SyncEntity copyWith({
    bool? isSynced,
    int? retryCount,
  }) {
    return PerformanceSyncEntity.fromTrace(
      trace: PerformanceTrace(
        name: data['name'] as String,
        startTime: timestamp,
      ),
      isSynced: isSynced ?? this.isSynced,
      retryCount: retryCount ?? this.retryCount,
    );
  }
}