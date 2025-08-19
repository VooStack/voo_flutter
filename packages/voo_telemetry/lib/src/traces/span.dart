import 'package:uuid/uuid.dart';
import 'package:voo_telemetry/src/traces/span_context.dart';

/// Represents a span in a distributed trace
class Span {
  final String traceId;
  final String spanId;
  final String? parentSpanId;
  final String name;
  final SpanKind kind;
  final DateTime startTime;
  DateTime? endTime;
  final Map<String, dynamic> attributes = {};
  final List<SpanEvent> events = [];
  final List<SpanLink> links = [];
  SpanStatus status = SpanStatus.unset();
  final SpanContext context;
  
  Span({
    String? traceId,
    String? spanId,
    this.parentSpanId,
    required this.name,
    this.kind = SpanKind.internal,
    DateTime? startTime,
    SpanContext? context,
  })  : traceId = traceId ?? _generateTraceId(),
        spanId = spanId ?? _generateSpanId(),
        startTime = startTime ?? DateTime.now(),
        context = context ?? SpanContext(
          traceId: traceId ?? _generateTraceId(),
          spanId: spanId ?? _generateSpanId(),
        );
  
  static String _generateTraceId() => const Uuid().v4().replaceAll('-', '');
  
  static String _generateSpanId() => const Uuid().v4().replaceAll('-', '').substring(0, 16);
  
  /// Set an attribute on the span
  void setAttribute(String key, dynamic value) {
    attributes[key] = value;
  }
  
  /// Set multiple attributes
  void setAttributes(Map<String, dynamic> attrs) {
    attributes.addAll(attrs);
  }
  
  /// Add an event to the span
  void addEvent(String name, {Map<String, dynamic>? attributes}) {
    events.add(SpanEvent(
      name: name,
      timestamp: DateTime.now(),
      attributes: attributes ?? {},
    ));
  }
  
  /// Record an exception
  void recordException(
    dynamic exception,
    StackTrace? stackTrace, {
    Map<String, dynamic>? attributes,
  }) {
    addEvent('exception', attributes: {
      'exception.type': exception.runtimeType.toString(),
      'exception.message': exception.toString(),
      if (stackTrace != null) 'exception.stacktrace': stackTrace.toString(),
      ...?attributes,
    });
    
    setStatus(SpanStatus.error(description: exception.toString()));
  }
  
  /// Set the span status
  void setStatus(SpanStatus status) {
    this.status = status;
  }
  
  /// End the span
  void end([DateTime? endTime]) {
    this.endTime = endTime ?? DateTime.now();
  }
  
  /// Check if span is recording
  bool get isRecording => endTime == null;
  
  /// Get span duration in microseconds
  int? get durationMicroseconds {
    if (endTime == null) return null;
    return endTime!.difference(startTime).inMicroseconds;
  }
  
  /// Convert to OTLP format
  Map<String, dynamic> toOtlp() => {
      'traceId': _hexToBytes(traceId),
      'spanId': _hexToBytes(spanId.padRight(16, '0')),
      if (parentSpanId != null)
        'parentSpanId': _hexToBytes(parentSpanId!.padRight(16, '0')),
      'name': name,
      'kind': kind.value,
      'startTimeUnixNano': startTime.microsecondsSinceEpoch * 1000,
      'endTimeUnixNano': (endTime ?? DateTime.now()).microsecondsSinceEpoch * 1000,
      'attributes': attributes.entries.map((e) => {
        'key': e.key,
        'value': _convertAttributeValue(e.value),
      }).toList(),
      'events': events.map((e) => e.toOtlp()).toList(),
      'links': links.map((l) => l.toOtlp()).toList(),
      'status': status.toOtlp(),
    };
  
  List<int> _hexToBytes(String hex) {
    final bytes = <int>[];
    for (int i = 0; i < hex.length; i += 2) {
      final hexByte = hex.substring(i, i + 2);
      bytes.add(int.parse(hexByte, radix: 16));
    }
    return bytes;
  }
  
  Map<String, dynamic> _convertAttributeValue(dynamic value) {
    if (value is String) {
      return {'stringValue': value};
    } else if (value is bool) {
      return {'boolValue': value};
    } else if (value is int) {
      return {'intValue': value};
    } else if (value is double) {
      return {'doubleValue': value};
    } else {
      return {'stringValue': value.toString()};
    }
  }
}

/// Span event
class SpanEvent {
  final String name;
  final DateTime timestamp;
  final Map<String, dynamic> attributes;
  
  SpanEvent({
    required this.name,
    required this.timestamp,
    required this.attributes,
  });
  
  Map<String, dynamic> toOtlp() => {
      'name': name,
      'timeUnixNano': timestamp.microsecondsSinceEpoch * 1000,
      'attributes': attributes.entries.map((e) => {
        'key': e.key,
        'value': _convertValue(e.value),
      }).toList(),
    };
  
  Map<String, dynamic> _convertValue(dynamic value) {
    if (value is String) {
      return {'stringValue': value};
    } else if (value is bool) {
      return {'boolValue': value};
    } else if (value is int) {
      return {'intValue': value};
    } else if (value is double) {
      return {'doubleValue': value};
    } else {
      return {'stringValue': value.toString()};
    }
  }
}

/// Span link
class SpanLink {
  final String traceId;
  final String spanId;
  final Map<String, dynamic> attributes;
  
  SpanLink({
    required this.traceId,
    required this.spanId,
    this.attributes = const {},
  });
  
  Map<String, dynamic> toOtlp() => {
      'traceId': _hexToBytes(traceId),
      'spanId': _hexToBytes(spanId.padRight(16, '0')),
      'attributes': attributes.entries.map((e) => {
        'key': e.key,
        'value': _convertValue(e.value),
      }).toList(),
    };
  
  List<int> _hexToBytes(String hex) {
    final bytes = <int>[];
    for (int i = 0; i < hex.length; i += 2) {
      final hexByte = hex.substring(i, i + 2);
      bytes.add(int.parse(hexByte, radix: 16));
    }
    return bytes;
  }
  
  Map<String, dynamic> _convertValue(dynamic value) {
    if (value is String) {
      return {'stringValue': value};
    } else if (value is bool) {
      return {'boolValue': value};
    } else if (value is int) {
      return {'intValue': value};
    } else if (value is double) {
      return {'doubleValue': value};
    } else {
      return {'stringValue': value.toString()};
    }
  }
}

/// Span kind
enum SpanKind {
  internal(1),
  server(2),
  client(3),
  producer(4),
  consumer(5);
  
  final int value;
  const SpanKind(this.value);
}

/// Span status
class SpanStatus {
  final StatusCode code;
  final String? description;
  
  SpanStatus.unset() : code = StatusCode.unset, description = null;
  SpanStatus.ok() : code = StatusCode.ok, description = null;
  SpanStatus.error({this.description}) : code = StatusCode.error;
  
  Map<String, dynamic> toOtlp() => {
      'code': code.value,
      if (description != null) 'message': description,
    };
}

/// Status code
enum StatusCode {
  unset(0),
  ok(1),
  error(2);
  
  final int value;
  const StatusCode(this.value);
}