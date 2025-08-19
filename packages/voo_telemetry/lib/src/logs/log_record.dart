/// Represents a log record in OpenTelemetry
class LogRecord {
  final DateTime timestamp;
  final DateTime? observedTimestamp;
  final SeverityNumber severityNumber;
  final String severityText;
  final String body;
  final Map<String, dynamic> attributes;
  String? traceId;
  String? spanId;
  int traceFlags;
  
  LogRecord({
    required this.severityNumber,
    required this.severityText,
    required this.body,
    DateTime? timestamp,
    this.observedTimestamp,
    Map<String, dynamic>? attributes,
    this.traceId,
    this.spanId,
    this.traceFlags = 0,
  })  : timestamp = timestamp ?? DateTime.now(),
        attributes = attributes ?? {};
  
  /// Convert to OTLP format
  Map<String, dynamic> toOtlp() {
    return {
      'timeUnixNano': timestamp.microsecondsSinceEpoch * 1000,
      if (observedTimestamp != null)
        'observedTimeUnixNano': observedTimestamp!.microsecondsSinceEpoch * 1000,
      'severityNumber': severityNumber.value,
      'severityText': severityText,
      'body': {'stringValue': body},
      'attributes': attributes.entries
          .map((e) => {
                'key': e.key,
                'value': _convertValue(e.value),
              })
          .toList(),
      if (traceId != null) 'traceId': _hexToBytes(traceId!),
      if (spanId != null) 'spanId': _hexToBytes(spanId!.padRight(16, '0')),
      'flags': traceFlags,
    };
  }
  
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
    } else if (value is List) {
      return {
        'arrayValue': {
          'values': value.map((v) => _convertValue(v)).toList(),
        }
      };
    } else if (value is Map) {
      return {
        'kvlistValue': {
          'values': value.entries
              .map((e) => {
                    'key': e.key.toString(),
                    'value': _convertValue(e.value),
                  })
              .toList(),
        }
      };
    } else {
      return {'stringValue': value.toString()};
    }
  }
}

/// Severity numbers for log records
enum SeverityNumber {
  unspecified(0),
  trace(1),
  trace2(2),
  trace3(3),
  trace4(4),
  debug(5),
  debug2(6),
  debug3(7),
  debug4(8),
  info(9),
  info2(10),
  info3(11),
  info4(12),
  warn(13),
  warn2(14),
  warn3(15),
  warn4(16),
  error(17),
  error2(18),
  error3(19),
  error4(20),
  fatal(21),
  fatal2(22),
  fatal3(23),
  fatal4(24);
  
  final int value;
  const SeverityNumber(this.value);
}