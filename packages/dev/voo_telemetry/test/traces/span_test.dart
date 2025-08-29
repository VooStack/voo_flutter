import 'package:flutter_test/flutter_test.dart';
import 'package:voo_telemetry/src/traces/span.dart';

void main() {
  group('Span', () {
    test('should create span with generated IDs', () {
      final span = Span(name: 'test-span');

      expect(span.name, 'test-span');
      expect(span.traceId, isNotEmpty);
      expect(span.traceId.length, 32); // UUID without dashes
      expect(span.spanId, isNotEmpty);
      expect(span.spanId.length, 16);
      expect(span.parentSpanId, isNull);
      expect(span.kind, SpanKind.internal);
      expect(span.startTime, isNotNull);
      expect(span.endTime, isNull);
      expect(span.isRecording, true);
    });

    test('should create span with provided IDs', () {
      final span = Span(
        name: 'test-span',
        traceId: '12345678901234567890123456789012',
        spanId: '1234567890123456',
        parentSpanId: '0987654321098765',
        kind: SpanKind.server,
      );

      expect(span.traceId, '12345678901234567890123456789012');
      expect(span.spanId, '1234567890123456');
      expect(span.parentSpanId, '0987654321098765');
      expect(span.kind, SpanKind.server);
    });

    test('should set and get attributes', () {
      final span = Span(name: 'test-span');

      span.setAttribute('key1', 'value1');
      span.setAttribute('key2', 42);
      span.setAttribute('key3', true);
      span.setAttribute('key4', 3.14);

      expect(span.attributes['key1'], 'value1');
      expect(span.attributes['key2'], 42);
      expect(span.attributes['key3'], true);
      expect(span.attributes['key4'], 3.14);
    });

    test('should set multiple attributes', () {
      final span = Span(name: 'test-span');

      span.setAttributes({'attr1': 'value1', 'attr2': 100, 'attr3': false});

      expect(span.attributes.length, 3);
      expect(span.attributes['attr1'], 'value1');
      expect(span.attributes['attr2'], 100);
      expect(span.attributes['attr3'], false);
    });

    test('should add events', () {
      final span = Span(name: 'test-span');

      span.addEvent('event1');
      span.addEvent('event2', attributes: {'key': 'value'});

      expect(span.events.length, 2);
      expect(span.events[0].name, 'event1');
      expect(span.events[0].attributes, isEmpty);
      expect(span.events[1].name, 'event2');
      expect(span.events[1].attributes['key'], 'value');
    });

    test('should record exception', () {
      final span = Span(name: 'test-span');
      final exception = Exception('Test error');
      final stackTrace = StackTrace.current;

      span.recordException(exception, stackTrace, attributes: {'custom': 'attr'});

      expect(span.events.length, 1);
      expect(span.events[0].name, 'exception');
      expect(span.events[0].attributes['exception.type'], '_Exception');
      expect(span.events[0].attributes['exception.message'], contains('Test error'));
      expect(span.events[0].attributes['exception.stacktrace'], isNotNull);
      expect(span.events[0].attributes['custom'], 'attr');
      expect(span.status.code, StatusCode.error);
      expect(span.status.description, contains('Test error'));
    });

    test('should set status', () {
      final span = Span(name: 'test-span');

      span.status = SpanStatus.ok();
      expect(span.status.code, StatusCode.ok);
      expect(span.status.description, isNull);

      span.status = SpanStatus.error(description: 'Something went wrong');
      expect(span.status.code, StatusCode.error);
      expect(span.status.description, 'Something went wrong');
    });

    test('should end span', () {
      final span = Span(name: 'test-span');
      expect(span.isRecording, true);
      expect(span.endTime, isNull);
      expect(span.durationMicroseconds, isNull);

      span.end();

      expect(span.isRecording, false);
      expect(span.endTime, isNotNull);
      expect(span.durationMicroseconds, isNotNull);
      expect(span.durationMicroseconds! >= 0, true);
    });

    test('should end span with custom end time', () {
      final startTime = DateTime.now();
      final endTime = startTime.add(const Duration(seconds: 5));
      final span = Span(name: 'test-span', startTime: startTime);

      span.end(endTime);

      expect(span.endTime, endTime);
      expect(span.durationMicroseconds, 5000000);
    });

    test('should convert to OTLP format', () {
      final span = Span(
        name: 'test-span',
        traceId: '12345678901234567890123456789012',
        spanId: '1234567890123456',
        parentSpanId: '0987654321098765',
        kind: SpanKind.client,
      );

      span.setAttribute('http.method', 'GET');
      span.setAttribute('http.url', 'https://example.com');
      span.addEvent('request-sent');
      span.status = SpanStatus.ok();
      span.end();

      final otlp = span.toOtlp();

      expect(otlp['name'], 'test-span');
      expect(otlp['traceId'], isList);
      expect(otlp['spanId'], isList);
      expect(otlp['parentSpanId'], isList);
      expect(otlp['kind'], SpanKind.client.value);
      expect(otlp['startTimeUnixNano'], isA<int>());
      expect(otlp['endTimeUnixNano'], isA<int>());
      expect(otlp['attributes'], isList);
      expect(otlp['attributes'].length, 2);
      expect(otlp['events'], isList);
      expect(otlp['events'].length, 1);
      expect(otlp['status'], isMap);
      expect(otlp['status']['code'], StatusCode.ok.value);
    });

    test('should add span links', () {
      final span = Span(name: 'test-span');

      span.links.add(SpanLink(traceId: 'abcdef1234567890abcdef1234567890', spanId: 'fedcba0987654321', attributes: {'link.type': 'parent'}));

      expect(span.links.length, 1);
      expect(span.links[0].traceId, 'abcdef1234567890abcdef1234567890');
      expect(span.links[0].spanId, 'fedcba0987654321');
      expect(span.links[0].attributes['link.type'], 'parent');
    });
  });

  group('SpanEvent', () {
    test('should convert to OTLP format', () {
      final event = SpanEvent(name: 'test-event', timestamp: DateTime.parse('2024-01-01T12:00:00Z'), attributes: {'key1': 'value1', 'key2': 42});

      final otlp = event.toOtlp();

      expect(otlp['name'], 'test-event');
      expect(otlp['timeUnixNano'], isA<int>());
      expect(otlp['attributes'], isList);
      expect(otlp['attributes'].length, 2);
    });
  });

  group('SpanLink', () {
    test('should convert to OTLP format', () {
      final link = SpanLink(traceId: '12345678901234567890123456789012', spanId: '1234567890123456', attributes: {'link.type': 'child'});

      final otlp = link.toOtlp();

      expect(otlp['traceId'], isList);
      expect(otlp['spanId'], isList);
      expect(otlp['attributes'], isList);
      expect(otlp['attributes'].length, 1);
    });
  });

  group('SpanStatus', () {
    test('should create unset status', () {
      final status = SpanStatus.unset();
      expect(status.code, StatusCode.unset);
      expect(status.description, isNull);
    });

    test('should create ok status', () {
      final status = SpanStatus.ok();
      expect(status.code, StatusCode.ok);
      expect(status.description, isNull);
    });

    test('should create error status with description', () {
      final status = SpanStatus.error(description: 'Error message');
      expect(status.code, StatusCode.error);
      expect(status.description, 'Error message');
    });

    test('should convert to OTLP format', () {
      final status = SpanStatus.error(description: 'Test error');
      final otlp = status.toOtlp();

      expect(otlp['code'], StatusCode.error.value);
      expect(otlp['message'], 'Test error');
    });
  });
}
