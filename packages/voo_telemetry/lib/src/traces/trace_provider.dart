import 'dart:async';
import 'package:synchronized/synchronized.dart';
import 'package:voo_telemetry/src/core/telemetry_config.dart';
import 'package:voo_telemetry/src/core/telemetry_resource.dart';
import 'package:voo_telemetry/src/exporters/otlp_http_exporter.dart';
import 'package:voo_telemetry/src/traces/span.dart';
import 'package:voo_telemetry/src/traces/tracer.dart';

/// Provider for trace telemetry
class TraceProvider {
  final TelemetryResource resource;
  final OTLPHttpExporter exporter;
  final TelemetryConfig config;
  final Map<String, Tracer> _tracers = {};
  final List<Span> _pendingSpans = [];
  final _lock = Lock();
  Span? _activeSpan;
  
  TraceProvider({
    required this.resource,
    required this.exporter,
    required this.config,
  });
  
  /// Initialize the trace provider
  Future<void> initialize() async {
    // Any initialization logic
  }
  
  /// Get or create a tracer
  Tracer getTracer(String name) {
    return _tracers.putIfAbsent(
      name,
      () => Tracer(
        name: name,
        provider: this,
      ),
    );
  }
  
  /// Get the currently active span
  Span? get activeSpan => _activeSpan;
  
  /// Set the active span
  set activeSpan(Span? span) {
    _activeSpan = span;
  }
  
  /// Add a span to be exported
  void addSpan(Span span) {
    _lock.synchronized(() {
      _pendingSpans.add(span);
      
      if (_pendingSpans.length >= config.maxBatchSize) {
        flush();
      }
    });
  }
  
  /// Flush pending spans
  Future<void> flush() async {
    final spansToExport = await _lock.synchronized(() {
      final spans = List<Span>.from(_pendingSpans);
      _pendingSpans.clear();
      return spans;
    });
    
    if (spansToExport.isEmpty) return;
    
    final otlpSpans = spansToExport.map((s) => s.toOtlp()).toList();
    await exporter.exportTraces(otlpSpans, resource);
  }
  
  /// Shutdown the provider
  Future<void> shutdown() async {
    await flush();
    _tracers.clear();
    _activeSpan = null;
  }
}