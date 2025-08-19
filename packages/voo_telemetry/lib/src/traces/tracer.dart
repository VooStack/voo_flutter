import 'span.dart';
import 'trace_provider.dart';

/// Tracer for creating and managing spans
class Tracer {
  final String name;
  final TraceProvider provider;
  
  Tracer({
    required this.name,
    required this.provider,
  });
  
  /// Start a new span
  Span startSpan(
    String name, {
    SpanKind kind = SpanKind.internal,
    Map<String, dynamic>? attributes,
    List<SpanLink>? links,
  }) {
    final parentSpan = provider.activeSpan;
    
    final span = Span(
      traceId: parentSpan?.traceId,
      parentSpanId: parentSpan?.spanId,
      name: name,
      kind: kind,
    );
    
    if (attributes != null) {
      span.setAttributes(attributes);
    }
    
    if (links != null) {
      span.links.addAll(links);
    }
    
    provider.activeSpan = span;
    
    return span;
  }
  
  /// Execute a function within a span context
  Future<T> withSpan<T>(
    String name,
    Future<T> Function(Span span) fn, {
    SpanKind kind = SpanKind.internal,
    Map<String, dynamic>? attributes,
  }) async {
    final span = startSpan(name, kind: kind, attributes: attributes);
    
    try {
      final result = await fn(span);
      span.setStatus(SpanStatus.ok());
      return result;
    } catch (e, stackTrace) {
      span.recordException(e, stackTrace);
      rethrow;
    } finally {
      span.end();
      provider.addSpan(span);
      
      // Restore parent span as active
      if (span.parentSpanId != null) {
        // Find parent span in provider if needed
        provider.activeSpan = null;
      }
    }
  }
  
  /// Execute a synchronous function within a span context
  T withSpanSync<T>(
    String name,
    T Function(Span span) fn, {
    SpanKind kind = SpanKind.internal,
    Map<String, dynamic>? attributes,
  }) {
    final span = startSpan(name, kind: kind, attributes: attributes);
    
    try {
      final result = fn(span);
      span.setStatus(SpanStatus.ok());
      return result;
    } catch (e, stackTrace) {
      span.recordException(e, stackTrace);
      rethrow;
    } finally {
      span.end();
      provider.addSpan(span);
      
      // Restore parent span as active
      if (span.parentSpanId != null) {
        provider.activeSpan = null;
      }
    }
  }
}