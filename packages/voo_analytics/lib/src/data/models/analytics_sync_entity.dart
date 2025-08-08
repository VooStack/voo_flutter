import 'package:voo_core/voo_core.dart';

class AnalyticsSyncEntity extends SyncEntity {
  AnalyticsSyncEntity({required super.id, required super.timestamp, required String eventType, required Map<String, dynamic> eventData, super.isSynced, super.retryCount})
    : super(type: 'analytics', data: {'eventType': eventType, ...eventData});

  @override
  SyncEntity copyWith({bool? isSynced, int? retryCount}) {
    return AnalyticsSyncEntity(
      id: id,
      timestamp: timestamp,
      eventType: data['eventType'] as String,
      eventData: Map<String, dynamic>.from(data)..remove('eventType'),
      isSynced: isSynced ?? this.isSynced,
      retryCount: retryCount ?? this.retryCount,
    );
  }
}
