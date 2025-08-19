import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:voo_telemetry/src/core/telemetry_config.dart';
import 'package:voo_telemetry/src/core/telemetry_resource.dart';
import 'package:voo_telemetry/src/exporters/otlp_http_exporter.dart';
import 'package:voo_telemetry/src/logs/logger.dart';
import 'package:voo_telemetry/src/logs/logger_provider.dart';
import 'package:voo_telemetry/src/metrics/meter.dart';
import 'package:voo_telemetry/src/metrics/meter_provider.dart';
import 'package:voo_telemetry/src/traces/trace_provider.dart';
import 'package:voo_telemetry/src/traces/tracer.dart';

/// Main entry point for VooTelemetry OpenTelemetry integration
class VooTelemetry {
  static VooTelemetry? _instance;
  
  final TelemetryConfig config;
  final TelemetryResource resource;
  final TraceProvider traceProvider;
  final MeterProvider meterProvider;
  final LoggerProvider loggerProvider;
  final OTLPHttpExporter exporter;
  
  bool _initialized = false;
  Timer? _flushTimer;
  
  VooTelemetry._({
    required this.config,
    required this.resource,
    required this.traceProvider,
    required this.meterProvider,
    required this.loggerProvider,
    required this.exporter,
  });
  
  /// Initialize VooTelemetry with configuration
  static Future<void> initialize({
    required String endpoint,
    String? apiKey,
    String serviceName = 'voo-flutter-app',
    String serviceVersion = '1.0.0',
    Map<String, dynamic>? additionalAttributes,
    Duration batchInterval = const Duration(seconds: 30),
    int maxBatchSize = 100,
    bool debug = false,
  }) async {
    if (_instance != null) {
      throw StateError('VooTelemetry is already initialized');
    }
    
    final config = TelemetryConfig(
      endpoint: endpoint,
      apiKey: apiKey,
      batchInterval: batchInterval,
      maxBatchSize: maxBatchSize,
      debug: debug,
    );
    
    final resource = TelemetryResource(
      serviceName: serviceName,
      serviceVersion: serviceVersion,
      attributes: {
        'service.name': serviceName,
        'service.version': serviceVersion,
        'telemetry.sdk.name': 'voo-telemetry',
        'telemetry.sdk.version': '2.0.0',
        'telemetry.sdk.language': 'dart',
        'process.runtime.name': 'flutter',
        'process.runtime.version': '${defaultTargetPlatform.name}',
        ...?additionalAttributes,
      },
    );
    
    final exporter = OTLPHttpExporter(
      endpoint: endpoint,
      apiKey: apiKey,
      debug: debug,
    );
    
    final traceProvider = TraceProvider(
      resource: resource,
      exporter: exporter,
      config: config,
    );
    
    final meterProvider = MeterProvider(
      resource: resource,
      exporter: exporter,
      config: config,
    );
    
    final loggerProvider = LoggerProvider(
      resource: resource,
      exporter: exporter,
      config: config,
    );
    
    _instance = VooTelemetry._(
      config: config,
      resource: resource,
      traceProvider: traceProvider,
      meterProvider: meterProvider,
      loggerProvider: loggerProvider,
      exporter: exporter,
    );
    
    await _instance!._init();
  }
  
  /// Get the singleton instance
  static VooTelemetry get instance {
    if (_instance == null) {
      throw StateError('VooTelemetry is not initialized. Call VooTelemetry.initialize() first.');
    }
    return _instance!;
  }
  
  /// Check if VooTelemetry is initialized
  static bool get isInitialized => _instance != null;
  
  Future<void> _init() async {
    if (_initialized) return;
    
    // Initialize providers
    await traceProvider.initialize();
    await meterProvider.initialize();
    await loggerProvider.initialize();
    
    // Start batch flush timer
    _flushTimer = Timer.periodic(config.batchInterval, (_) {
      flush();
    });
    
    _initialized = true;
    
    if (config.debug) {
      debugPrint('VooTelemetry initialized with endpoint: ${config.endpoint}');
    }
  }
  
  /// Manually flush all telemetry data
  Future<void> flush() async {
    await Future.wait([
      traceProvider.flush(),
      meterProvider.flush(),
      loggerProvider.flush(),
    ]);
  }
  
  /// Shutdown VooTelemetry and flush remaining data
  static Future<void> shutdown() async {
    if (_instance == null) return;
    
    _instance!._flushTimer?.cancel();
    await _instance!.flush();
    
    await Future.wait([
      _instance!.traceProvider.shutdown(),
      _instance!.meterProvider.shutdown(),
      _instance!.loggerProvider.shutdown(),
    ]);
    
    _instance = null;
  }
  
  /// Get a tracer for creating spans
  Tracer getTracer([String name = 'default']) {
    return traceProvider.getTracer(name);
  }
  
  /// Get a meter for creating metrics
  Meter getMeter([String name = 'default']) {
    return meterProvider.getMeter(name);
  }
  
  /// Get a logger for creating logs
  Logger getLogger([String name = 'default']) {
    return loggerProvider.getLogger(name);
  }
  
  /// Record an exception with trace context
  void recordException(
    dynamic exception,
    StackTrace? stackTrace, {
    Map<String, dynamic>? attributes,
  }) {
    final span = traceProvider.activeSpan;
    if (span != null) {
      span.recordException(exception, stackTrace, attributes: attributes);
    }
    
    loggerProvider.getLogger('exception').error(
      'Exception occurred',
      attributes: {
        'exception.type': exception.runtimeType.toString(),
        'exception.message': exception.toString(),
        if (stackTrace != null) 'exception.stacktrace': stackTrace.toString(),
        ...?attributes,
      },
    );
  }
}