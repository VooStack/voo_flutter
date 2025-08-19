import 'dart:async';
import 'package:synchronized/synchronized.dart';
import 'package:voo_telemetry/src/core/telemetry_config.dart';
import 'package:voo_telemetry/src/core/telemetry_resource.dart';
import 'package:voo_telemetry/src/exporters/otlp_http_exporter.dart';
import 'log_record.dart';
import 'logger.dart';

/// Provider for log telemetry
class LoggerProvider {
  final TelemetryResource resource;
  final OTLPHttpExporter exporter;
  final TelemetryConfig config;
  final Map<String, Logger> _loggers = {};
  final List<LogRecord> _pendingLogs = [];
  final _lock = Lock();
  
  LoggerProvider({
    required this.resource,
    required this.exporter,
    required this.config,
  });
  
  /// Initialize the logger provider
  Future<void> initialize() async {
    // Any initialization logic
  }
  
  /// Get or create a logger
  Logger getLogger(String name) {
    return _loggers.putIfAbsent(
      name,
      () => Logger(
        name: name,
        provider: this,
      ),
    );
  }
  
  /// Add a log record to be exported
  void addLogRecord(LogRecord logRecord) {
    _lock.synchronized(() {
      _pendingLogs.add(logRecord);
      
      if (_pendingLogs.length >= config.maxBatchSize) {
        flush();
      }
    });
  }
  
  /// Flush pending logs
  Future<void> flush() async {
    final logsToExport = await _lock.synchronized(() {
      final logs = List<LogRecord>.from(_pendingLogs);
      _pendingLogs.clear();
      return logs;
    });
    
    if (logsToExport.isEmpty) return;
    
    final otlpLogs = logsToExport.map((l) => l.toOtlp()).toList();
    await exporter.exportLogs(otlpLogs, resource);
  }
  
  /// Shutdown the provider
  Future<void> shutdown() async {
    await flush();
    _loggers.clear();
  }
}