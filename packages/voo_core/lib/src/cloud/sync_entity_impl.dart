import 'package:voo_core/src/cloud/sync_entity.dart';

class SyncEntityImpl extends SyncEntity {
  const SyncEntityImpl({
    required super.id,
    required super.type,
    required super.timestamp,
    required super.data,
    super.isSynced,
    super.retryCount,
  });
  
  factory SyncEntityImpl.fromJson(Map<String, dynamic> json) {
    return SyncEntityImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      data: json['data'] as Map<String, dynamic>,
      isSynced: json['isSynced'] as bool? ?? false,
      retryCount: json['retryCount'] as int? ?? 0,
    );
  }
  
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['isSynced'] = isSynced;
    json['retryCount'] = retryCount;
    return json;
  }
  
  @override
  SyncEntity copyWith({
    bool? isSynced,
    int? retryCount,
  }) {
    return SyncEntityImpl(
      id: id,
      type: type,
      timestamp: timestamp,
      data: data,
      isSynced: isSynced ?? this.isSynced,
      retryCount: retryCount ?? this.retryCount,
    );
  }
}