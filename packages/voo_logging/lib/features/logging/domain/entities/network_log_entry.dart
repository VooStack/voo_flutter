import 'package:voo_logging/features/logging/domain/entities/log_entry.dart';

class NetworkLogEntry extends LogEntry {
  final String method;
  final String url;
  final int? statusCode;
  final Map<String, String>? requestHeaders;
  final Map<String, String>? responseHeaders;
  final dynamic requestBody;
  final dynamic responseBody;
  final int? requestSize;
  final int? responseSize;
  final Duration? duration;

  const NetworkLogEntry({
    required super.id,
    required super.timestamp,
    required super.message,
    required super.level,
    required this.method,
    required this.url,
    this.statusCode,
    this.requestHeaders,
    this.responseHeaders,
    this.requestBody,
    this.responseBody,
    this.requestSize,
    this.responseSize,
    this.duration,
    super.category = 'Network',
    super.tag,
    super.metadata,
    super.error,
    super.stackTrace,
    super.userId,
    super.sessionId,
  });

  bool get isRequest => statusCode == null;
  bool get isResponse => statusCode != null;
  bool get isSuccess => statusCode != null && statusCode! >= 200 && statusCode! < 300;
  bool get isError => statusCode != null && statusCode! >= 400;
}