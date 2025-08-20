import 'package:flutter_test/flutter_test.dart';
import 'package:voo_telemetry/src/logs/log_record.dart';

void main() {
  group('LogRecord', () {
    test('should create log record with required parameters', () {
      final record = LogRecord(
        severityNumber: SeverityNumber.info,
        severityText: 'INFO',
        body: 'Test log message',
      );

      expect(record.severityNumber, SeverityNumber.info);
      expect(record.severityText, 'INFO');
      expect(record.body, 'Test log message');
      expect(record.timestamp, isNotNull);
      expect(record.observedTimestamp, isNull);
      expect(record.attributes, isEmpty);
      expect(record.traceId, isNull);
      expect(record.spanId, isNull);
      expect(record.traceFlags, 0);
    });

    test('should create log record with all parameters', () {
      final timestamp = DateTime.now();
      final observedTimestamp = timestamp.add(const Duration(milliseconds: 100));
      
      final record = LogRecord(
        severityNumber: SeverityNumber.error,
        severityText: 'ERROR',
        body: 'Error message',
        timestamp: timestamp,
        observedTimestamp: observedTimestamp,
        attributes: {'key': 'value'},
        traceId: '12345678901234567890123456789012',
        spanId: '1234567890123456',
        traceFlags: 1,
      );

      expect(record.severityNumber, SeverityNumber.error);
      expect(record.severityText, 'ERROR');
      expect(record.body, 'Error message');
      expect(record.timestamp, timestamp);
      expect(record.observedTimestamp, observedTimestamp);
      expect(record.attributes['key'], 'value');
      expect(record.traceId, '12345678901234567890123456789012');
      expect(record.spanId, '1234567890123456');
      expect(record.traceFlags, 1);
    });

    test('should convert to OTLP format without trace context', () {
      final timestamp = DateTime.parse('2024-01-01T12:00:00Z');
      final record = LogRecord(
        severityNumber: SeverityNumber.warn,
        severityText: 'WARN',
        body: 'Warning message',
        timestamp: timestamp,
        attributes: {
          'string': 'value',
          'int': 42,
          'double': 3.14,
          'bool': true,
          'list': [1, 2, 3],
          'map': {'nested': 'value'},
        },
      );

      final otlp = record.toOtlp();

      expect(otlp['timeUnixNano'], timestamp.microsecondsSinceEpoch * 1000);
      expect(otlp['severityNumber'], SeverityNumber.warn.value);
      expect(otlp['severityText'], 'WARN');
      expect(otlp['body'], {'stringValue': 'Warning message'});
      expect(otlp['attributes'], isList);
      expect(otlp['attributes'].length, 6);
      expect(otlp['flags'], 0);
      expect(otlp.containsKey('traceId'), false);
      expect(otlp.containsKey('spanId'), false);
    });

    test('should convert to OTLP format with trace context', () {
      final record = LogRecord(
        severityNumber: SeverityNumber.debug,
        severityText: 'DEBUG',
        body: 'Debug message',
        traceId: 'abcdef1234567890abcdef1234567890',
        spanId: '1234567890',
        traceFlags: 1,
      );

      final otlp = record.toOtlp();

      expect(otlp['traceId'], isList);
      expect(otlp['spanId'], isList);
      expect(otlp['flags'], 1);
    });

    test('should convert various attribute types correctly', () {
      final record = LogRecord(
        severityNumber: SeverityNumber.info,
        severityText: 'INFO',
        body: 'Test',
        attributes: {
          'string': 'text',
          'int': 123,
          'double': 45.67,
          'bool': false,
          'list': ['a', 'b', 'c'],
          'nested_map': {
            'key1': 'value1',
            'key2': 2,
          },
          'null_value': null,
        },
      );

      final otlp = record.toOtlp();
      final attrs = otlp['attributes'] as List;

      // Find string attribute
      final stringAttr = attrs.firstWhere((a) => a['key'] == 'string');
      expect(stringAttr['value']['stringValue'], 'text');

      // Find int attribute
      final intAttr = attrs.firstWhere((a) => a['key'] == 'int');
      expect(intAttr['value']['intValue'], 123);

      // Find double attribute
      final doubleAttr = attrs.firstWhere((a) => a['key'] == 'double');
      expect(doubleAttr['value']['doubleValue'], 45.67);

      // Find bool attribute
      final boolAttr = attrs.firstWhere((a) => a['key'] == 'bool');
      expect(boolAttr['value']['boolValue'], false);

      // Find list attribute
      final listAttr = attrs.firstWhere((a) => a['key'] == 'list');
      expect(listAttr['value']['arrayValue']['values'], isList);
      expect(listAttr['value']['arrayValue']['values'].length, 3);

      // Find map attribute
      final mapAttr = attrs.firstWhere((a) => a['key'] == 'nested_map');
      expect(mapAttr['value']['kvlistValue']['values'], isList);
      expect(mapAttr['value']['kvlistValue']['values'].length, 2);

      // Find null attribute (should be converted to string)
      final nullAttr = attrs.firstWhere((a) => a['key'] == 'null_value');
      expect(nullAttr['value']['stringValue'], 'null');
    });

    test('should handle hex to bytes conversion', () {
      final record = LogRecord(
        severityNumber: SeverityNumber.info,
        severityText: 'INFO',
        body: 'Test',
        traceId: '0123456789abcdef0123456789abcdef',
        spanId: 'fedcba9876543210',
      );

      final otlp = record.toOtlp();
      
      // Check traceId bytes
      final traceIdBytes = otlp['traceId'] as List<int>;
      expect(traceIdBytes.length, 16);
      expect(traceIdBytes[0], 0x01);
      expect(traceIdBytes[1], 0x23);
      expect(traceIdBytes[6], 0xcd);
      expect(traceIdBytes[7], 0xef);

      // Check spanId bytes (padded to 16 chars)
      final spanIdBytes = otlp['spanId'] as List<int>;
      expect(spanIdBytes.length, 8);
      expect(spanIdBytes[0], 0xfe);
      expect(spanIdBytes[1], 0xdc);
    });

    test('should pad short span IDs', () {
      final record = LogRecord(
        severityNumber: SeverityNumber.info,
        severityText: 'INFO',
        body: 'Test',
        spanId: '12345678',
      );

      final otlp = record.toOtlp();
      final spanIdBytes = otlp['spanId'] as List<int>;
      
      // Should pad with zeros and convert correctly
      expect(spanIdBytes.length, 8);
    });

    test('should include observed timestamp when provided', () {
      final timestamp = DateTime.parse('2024-01-01T12:00:00Z');
      final observedTimestamp = DateTime.parse('2024-01-01T12:00:01Z');
      
      final record = LogRecord(
        severityNumber: SeverityNumber.info,
        severityText: 'INFO',
        body: 'Test',
        timestamp: timestamp,
        observedTimestamp: observedTimestamp,
      );

      final otlp = record.toOtlp();

      expect(otlp['timeUnixNano'], timestamp.microsecondsSinceEpoch * 1000);
      expect(otlp['observedTimeUnixNano'], observedTimestamp.microsecondsSinceEpoch * 1000);
    });
  });

  group('SeverityNumber', () {
    test('should have correct values', () {
      expect(SeverityNumber.unspecified.value, 0);
      expect(SeverityNumber.trace.value, 1);
      expect(SeverityNumber.debug.value, 5);
      expect(SeverityNumber.info.value, 9);
      expect(SeverityNumber.warn.value, 13);
      expect(SeverityNumber.error.value, 17);
      expect(SeverityNumber.fatal.value, 21);
    });

    test('should have all severity levels', () {
      // Trace levels
      expect(SeverityNumber.trace.value, 1);
      expect(SeverityNumber.trace2.value, 2);
      expect(SeverityNumber.trace3.value, 3);
      expect(SeverityNumber.trace4.value, 4);

      // Debug levels
      expect(SeverityNumber.debug.value, 5);
      expect(SeverityNumber.debug2.value, 6);
      expect(SeverityNumber.debug3.value, 7);
      expect(SeverityNumber.debug4.value, 8);

      // Info levels
      expect(SeverityNumber.info.value, 9);
      expect(SeverityNumber.info2.value, 10);
      expect(SeverityNumber.info3.value, 11);
      expect(SeverityNumber.info4.value, 12);

      // Warn levels
      expect(SeverityNumber.warn.value, 13);
      expect(SeverityNumber.warn2.value, 14);
      expect(SeverityNumber.warn3.value, 15);
      expect(SeverityNumber.warn4.value, 16);

      // Error levels
      expect(SeverityNumber.error.value, 17);
      expect(SeverityNumber.error2.value, 18);
      expect(SeverityNumber.error3.value, 19);
      expect(SeverityNumber.error4.value, 20);

      // Fatal levels
      expect(SeverityNumber.fatal.value, 21);
      expect(SeverityNumber.fatal2.value, 22);
      expect(SeverityNumber.fatal3.value, 23);
      expect(SeverityNumber.fatal4.value, 24);
    });
  });
}