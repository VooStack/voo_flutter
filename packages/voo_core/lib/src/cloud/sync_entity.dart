import 'package:flutter/foundation.dart';

@immutable
abstract class SyncEntity {
  final String id;
  final String type;
  final DateTime timestamp;
  final Map<String, dynamic> data;
  final bool isSynced;
  final int retryCount;
  
  const SyncEntity({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.data,
    this.isSynced = false,
    this.retryCount = 0,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'data': data,
    };
  }
  
  SyncEntity copyWith({
    bool? isSynced,
    int? retryCount,
  });
}