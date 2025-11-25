import 'dart:convert';

import 'package:voo_devtools_extension/core/models/log_entry_model.dart';
import 'package:voo_devtools_extension/core/models/network_request_model.dart';

/// Export format options
enum ExportFormat {
  json,
  csv,
}

/// Pure Dart converters for exporting data to JSON and CSV formats.
/// These methods don't use any web-specific APIs and can be tested in VM.
class ExportConverters {
  ExportConverters._();

  // ─────────────────────────────────────────────────────────────────────────
  // Logs Export
  // ─────────────────────────────────────────────────────────────────────────

  /// Export logs to JSON string
  static String logsToJson(List<LogEntryModel> logs, {bool pretty = true}) {
    final data = {
      'exportedAt': DateTime.now().toIso8601String(),
      'count': logs.length,
      'logs': logs.map((log) => log.toJson()).toList(),
    };
    return pretty
        ? const JsonEncoder.withIndent('  ').convert(data)
        : jsonEncode(data);
  }

  /// Export logs to CSV string
  static String logsToCsv(List<LogEntryModel> logs) {
    final buffer = StringBuffer();

    // Header
    buffer.writeln('Timestamp,Level,Category,Tag,Message,Error');

    // Rows
    for (final log in logs) {
      buffer.writeln([
        log.timestamp.toIso8601String(),
        log.level.name,
        escapeCsv(log.category ?? ''),
        escapeCsv(log.tag ?? ''),
        escapeCsv(log.message),
        escapeCsv(log.error ?? ''),
      ].join(','));
    }

    return buffer.toString();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Network Export
  // ─────────────────────────────────────────────────────────────────────────

  /// Export network requests to JSON string
  static String networkToJson(
    List<NetworkRequestModel> requests, {
    bool pretty = true,
  }) {
    final data = {
      'exportedAt': DateTime.now().toIso8601String(),
      'count': requests.length,
      'requests': requests
          .map((req) => {
                'id': req.id,
                'url': req.url,
                'method': req.method,
                'timestamp': req.timestamp.toIso8601String(),
                'statusCode': req.statusCode,
                'duration': req.duration,
                'requestSize': req.requestSize,
                'responseSize': req.responseSize,
                'error': req.error,
                if (req.requestHeaders != null)
                  'requestHeaders': req.requestHeaders,
                if (req.responseHeaders != null)
                  'responseHeaders': req.responseHeaders,
                if (req.requestBody != null) 'requestBody': req.requestBody,
                if (req.responseBody != null) 'responseBody': req.responseBody,
              })
          .toList(),
    };
    return pretty
        ? const JsonEncoder.withIndent('  ').convert(data)
        : jsonEncode(data);
  }

  /// Export network requests to CSV string
  static String networkToCsv(List<NetworkRequestModel> requests) {
    final buffer = StringBuffer();

    // Header
    buffer.writeln(
      'Timestamp,Method,URL,Status,Duration (ms),Request Size,Response Size,Error',
    );

    // Rows
    for (final req in requests) {
      buffer.writeln([
        req.timestamp.toIso8601String(),
        req.method,
        escapeCsv(req.url),
        req.statusCode?.toString() ?? '',
        req.duration?.toString() ?? '',
        req.requestSize?.toString() ?? '',
        req.responseSize?.toString() ?? '',
        escapeCsv(req.error ?? ''),
      ].join(','));
    }

    return buffer.toString();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Analytics Export (using LogEntryModel)
  // ─────────────────────────────────────────────────────────────────────────

  /// Export analytics events to JSON string
  static String analyticsToJson(
    List<LogEntryModel> events, {
    bool pretty = true,
  }) {
    final data = {
      'exportedAt': DateTime.now().toIso8601String(),
      'count': events.length,
      'events': events
          .map((event) => {
                'id': event.id,
                'timestamp': event.timestamp.toIso8601String(),
                'type': event.category,
                'message': event.message,
                if (event.metadata != null) ...event.metadata!,
              })
          .toList(),
    };
    return pretty
        ? const JsonEncoder.withIndent('  ').convert(data)
        : jsonEncode(data);
  }

  /// Export analytics events to CSV string
  static String analyticsToCsv(List<LogEntryModel> events) {
    final buffer = StringBuffer();

    // Header
    buffer.writeln('Timestamp,Type,Message');

    // Rows
    for (final event in events) {
      buffer.writeln([
        event.timestamp.toIso8601String(),
        escapeCsv(event.category ?? ''),
        escapeCsv(event.message),
      ].join(','));
    }

    return buffer.toString();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Performance Export (using LogEntryModel)
  // ─────────────────────────────────────────────────────────────────────────

  /// Export performance metrics to JSON string
  static String performanceToJson(
    List<LogEntryModel> metrics, {
    bool pretty = true,
  }) {
    final data = {
      'exportedAt': DateTime.now().toIso8601String(),
      'count': metrics.length,
      'metrics': metrics
          .map((metric) => {
                'id': metric.id,
                'timestamp': metric.timestamp.toIso8601String(),
                'operation': metric.category,
                'message': metric.message,
                if (metric.metadata != null) ...metric.metadata!,
              })
          .toList(),
    };
    return pretty
        ? const JsonEncoder.withIndent('  ').convert(data)
        : jsonEncode(data);
  }

  /// Export performance metrics to CSV string
  static String performanceToCsv(List<LogEntryModel> metrics) {
    final buffer = StringBuffer();

    // Header
    buffer.writeln('Timestamp,Operation,Duration (ms),Message');

    // Rows
    for (final metric in metrics) {
      final duration = metric.metadata?['duration']?.toString() ?? '';
      buffer.writeln([
        metric.timestamp.toIso8601String(),
        escapeCsv(metric.category ?? ''),
        duration,
        escapeCsv(metric.message),
      ].join(','));
    }

    return buffer.toString();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────────────

  /// Escape a string for CSV
  static String escapeCsv(String value) {
    if (value.contains(',') ||
        value.contains('"') ||
        value.contains('\n') ||
        value.contains('\r')) {
      // Escape double quotes and wrap in quotes
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}
