import 'package:voo_telemetry/src/traces/span.dart';

/// Context for telemetry operations
class TelemetryContext {
  static final TelemetryContext _instance = TelemetryContext._internal();

  factory TelemetryContext() => _instance;

  TelemetryContext._internal();

  // Thread-local storage for active span
  final Map<int, Span> _activeSpans = {};

  /// Get the current active span
  Span? get activeSpan {
    final threadId = identityHashCode(this);
    return _activeSpans[threadId];
  }

  /// Set the active span
  set activeSpan(Span? span) {
    final threadId = identityHashCode(this);
    if (span == null) {
      _activeSpans.remove(threadId);
    } else {
      _activeSpans[threadId] = span;
    }
  }

  /// Execute a function with a span as the active context
  T withSpan<T>(Span span, T Function() fn) {
    final previousSpan = activeSpan;
    activeSpan = span;
    try {
      return fn();
    } finally {
      activeSpan = previousSpan;
    }
  }

  /// Execute an async function with a span as the active context
  Future<T> withSpanAsync<T>(Span span, Future<T> Function() fn) async {
    final previousSpan = activeSpan;
    activeSpan = span;
    try {
      return await fn();
    } finally {
      activeSpan = previousSpan;
    }
  }
}
