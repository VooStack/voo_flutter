import 'log_record.dart';
import 'logger_provider.dart';
import '../traces/trace_provider.dart';

/// Logger for creating log records
class Logger {
  final String name;
  final LoggerProvider provider;
  
  Logger({
    required this.name,
    required this.provider,
  });
  
  /// Log a message at the specified severity level
  void log(
    SeverityNumber severity,
    String message, {
    Map<String, dynamic>? attributes,
    DateTime? timestamp,
  }) {
    final logRecord = LogRecord(
      severityNumber: severity,
      severityText: _severityToText(severity),
      body: message,
      attributes: {
        'logger.name': name,
        ...?attributes,
      },
      timestamp: timestamp ?? DateTime.now(),
    );
    
    // Add trace context if available
    final activeSpan = provider.exporter.debug ? null : null; // TODO: Get active span
    if (activeSpan != null) {
      // logRecord.traceId = activeSpan.traceId;
      // logRecord.spanId = activeSpan.spanId;
    }
    
    provider.addLogRecord(logRecord);
  }
  
  /// Log a trace message
  void trace(String message, {Map<String, dynamic>? attributes}) {
    log(SeverityNumber.trace, message, attributes: attributes);
  }
  
  /// Log a debug message
  void debug(String message, {Map<String, dynamic>? attributes}) {
    log(SeverityNumber.debug, message, attributes: attributes);
  }
  
  /// Log an info message
  void info(String message, {Map<String, dynamic>? attributes}) {
    log(SeverityNumber.info, message, attributes: attributes);
  }
  
  /// Log a warning message
  void warn(String message, {Map<String, dynamic>? attributes}) {
    log(SeverityNumber.warn, message, attributes: attributes);
  }
  
  /// Log an error message
  void error(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? attributes,
  }) {
    final attrs = {
      ...?attributes,
      if (error != null) 'error.type': error.runtimeType.toString(),
      if (error != null) 'error.message': error.toString(),
      if (stackTrace != null) 'error.stacktrace': stackTrace.toString(),
    };
    
    log(SeverityNumber.error, message, attributes: attrs);
  }
  
  /// Log a fatal message
  void fatal(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? attributes,
  }) {
    final attrs = {
      ...?attributes,
      if (error != null) 'error.type': error.runtimeType.toString(),
      if (error != null) 'error.message': error.toString(),
      if (stackTrace != null) 'error.stacktrace': stackTrace.toString(),
    };
    
    log(SeverityNumber.fatal, message, attributes: attrs);
  }
  
  String _severityToText(SeverityNumber severity) {
    switch (severity) {
      case SeverityNumber.trace:
      case SeverityNumber.trace2:
      case SeverityNumber.trace3:
      case SeverityNumber.trace4:
        return 'TRACE';
      case SeverityNumber.debug:
      case SeverityNumber.debug2:
      case SeverityNumber.debug3:
      case SeverityNumber.debug4:
        return 'DEBUG';
      case SeverityNumber.info:
      case SeverityNumber.info2:
      case SeverityNumber.info3:
      case SeverityNumber.info4:
        return 'INFO';
      case SeverityNumber.warn:
      case SeverityNumber.warn2:
      case SeverityNumber.warn3:
      case SeverityNumber.warn4:
        return 'WARN';
      case SeverityNumber.error:
      case SeverityNumber.error2:
      case SeverityNumber.error3:
      case SeverityNumber.error4:
        return 'ERROR';
      case SeverityNumber.fatal:
      case SeverityNumber.fatal2:
      case SeverityNumber.fatal3:
      case SeverityNumber.fatal4:
        return 'FATAL';
      default:
        return 'UNSPECIFIED';
    }
  }
}