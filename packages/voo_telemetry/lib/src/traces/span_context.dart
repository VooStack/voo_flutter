/// Context for a span in a distributed trace
class SpanContext {
  final String traceId;
  final String spanId;
  final int traceFlags;
  final String? traceState;
  
  SpanContext({
    required this.traceId,
    required this.spanId,
    this.traceFlags = 1, // Sampled by default
    this.traceState,
  });
  
  /// Check if the span is sampled
  bool get isSampled => (traceFlags & 0x01) == 0x01;
  
  /// Create from W3C traceparent header
  factory SpanContext.fromTraceparent(String traceparent) {
    final parts = traceparent.split('-');
    if (parts.length != 4) {
      throw const FormatException('Invalid traceparent format');
    }
    
    return SpanContext(
      traceId: parts[1],
      spanId: parts[2],
      traceFlags: int.parse(parts[3], radix: 16),
    );
  }
  
  /// Convert to W3C traceparent header
  String toTraceparent() {
    final version = '00';
    final flags = traceFlags.toRadixString(16).padLeft(2, '0');
    return '$version-$traceId-$spanId-$flags';
  }
  
  /// Create from W3C tracestate header
  static String? parseTracestate(String? tracestate) {
    return tracestate;
  }
}