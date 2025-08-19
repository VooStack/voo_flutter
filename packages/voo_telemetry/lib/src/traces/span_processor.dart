import 'package:voo_telemetry/src/traces/span.dart';

/// Processor for spans (placeholder)
abstract class SpanProcessor {
  void onStart(Span span);
  void onEnd(Span span);
  Future<void> shutdown();
}