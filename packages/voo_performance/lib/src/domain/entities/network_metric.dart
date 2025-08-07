import 'package:equatable/equatable.dart';

class NetworkMetric extends Equatable {
  final String id;
  final String url;
  final String method;
  final int statusCode;
  final Duration duration;
  final DateTime timestamp;
  final int? requestSize;
  final int? responseSize;
  final Map<String, dynamic>? metadata;

  const NetworkMetric({
    required this.id,
    required this.url,
    required this.method,
    required this.statusCode,
    required this.duration,
    required this.timestamp,
    this.requestSize,
    this.responseSize,
    this.metadata,
  });

  bool get isError => statusCode >= 400;
  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'method': method,
      'status_code': statusCode,
      'duration_ms': duration.inMilliseconds,
      'timestamp': timestamp.toIso8601String(),
      if (requestSize != null) 'request_size': requestSize,
      if (responseSize != null) 'response_size': responseSize,
      if (metadata != null) 'metadata': metadata,
    };
  }

  factory NetworkMetric.fromMap(Map<String, dynamic> map) {
    return NetworkMetric(
      id: map['id'] as String,
      url: map['url'] as String,
      method: map['method'] as String,
      statusCode: map['status_code'] as int,
      duration: Duration(milliseconds: map['duration_ms'] as int),
      timestamp: DateTime.parse(map['timestamp'] as String),
      requestSize: map['request_size'] as int?,
      responseSize: map['response_size'] as int?,
      metadata: map['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        url,
        method,
        statusCode,
        duration,
        timestamp,
        requestSize,
        responseSize,
        metadata,
      ];
}