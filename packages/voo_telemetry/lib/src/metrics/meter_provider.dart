import 'dart:async';
import 'package:synchronized/synchronized.dart';
import 'package:voo_telemetry/src/core/telemetry_config.dart';
import 'package:voo_telemetry/src/core/telemetry_resource.dart';
import 'package:voo_telemetry/src/exporters/otlp_http_exporter.dart';
import 'package:voo_telemetry/src/metrics/meter.dart';
import 'package:voo_telemetry/src/metrics/metric.dart';

/// Provider for metrics telemetry
class MeterProvider {
  final TelemetryResource resource;
  final OTLPHttpExporter exporter;
  final TelemetryConfig config;
  final Map<String, Meter> _meters = {};
  final List<Metric> _pendingMetrics = [];
  final _lock = Lock();
  
  MeterProvider({
    required this.resource,
    required this.exporter,
    required this.config,
  });
  
  /// Initialize the meter provider
  Future<void> initialize() async {
    // Any initialization logic
  }
  
  /// Get or create a meter
  Meter getMeter(String name) {
    return _meters.putIfAbsent(
      name,
      () => Meter(
        name: name,
        provider: this,
      ),
    );
  }
  
  /// Add a metric to be exported
  void addMetric(Metric metric) {
    _lock.synchronized(() {
      _pendingMetrics.add(metric);
      
      if (_pendingMetrics.length >= config.maxBatchSize) {
        flush();
      }
    });
  }
  
  /// Flush pending metrics
  Future<void> flush() async {
    final metricsToExport = await _lock.synchronized(() {
      final metrics = List<Metric>.from(_pendingMetrics);
      _pendingMetrics.clear();
      return metrics;
    });
    
    if (metricsToExport.isEmpty) return;
    
    final otlpMetrics = metricsToExport.map((m) => m.toOtlp()).toList();
    await exporter.exportMetrics(otlpMetrics, resource);
  }
  
  /// Shutdown the provider
  Future<void> shutdown() async {
    await flush();
    _meters.clear();
  }
}