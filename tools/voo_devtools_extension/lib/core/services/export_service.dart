import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/services.dart';
import 'package:voo_devtools_extension/core/models/log_entry_model.dart';
import 'package:voo_devtools_extension/core/models/network_request_model.dart';
import 'package:voo_devtools_extension/core/utils/export_converters.dart';
import 'package:web/web.dart' as web;

// Re-export ExportFormat for convenience
export 'package:voo_devtools_extension/core/utils/export_converters.dart'
    show ExportFormat;

/// Service for exporting DevTools data (web-specific download functionality)
/// For pure conversion functions, use ExportConverters directly.
class ExportService {
  ExportService._();

  // ─────────────────────────────────────────────────────────────────────────
  // Conversion delegates (for backward compatibility)
  // ─────────────────────────────────────────────────────────────────────────

  /// Export logs to JSON string
  static String logsToJson(List<LogEntryModel> logs, {bool pretty = true}) =>
      ExportConverters.logsToJson(logs, pretty: pretty);

  /// Export logs to CSV string
  static String logsToCsv(List<LogEntryModel> logs) =>
      ExportConverters.logsToCsv(logs);

  /// Export network requests to JSON string
  static String networkToJson(
    List<NetworkRequestModel> requests, {
    bool pretty = true,
  }) =>
      ExportConverters.networkToJson(requests, pretty: pretty);

  /// Export network requests to CSV string
  static String networkToCsv(List<NetworkRequestModel> requests) =>
      ExportConverters.networkToCsv(requests);

  /// Export analytics events to JSON string
  static String analyticsToJson(
    List<LogEntryModel> events, {
    bool pretty = true,
  }) =>
      ExportConverters.analyticsToJson(events, pretty: pretty);

  /// Export analytics events to CSV string
  static String analyticsToCsv(List<LogEntryModel> events) =>
      ExportConverters.analyticsToCsv(events);

  /// Export performance metrics to JSON string
  static String performanceToJson(
    List<LogEntryModel> metrics, {
    bool pretty = true,
  }) =>
      ExportConverters.performanceToJson(metrics, pretty: pretty);

  /// Export performance metrics to CSV string
  static String performanceToCsv(List<LogEntryModel> metrics) =>
      ExportConverters.performanceToCsv(metrics);

  // ─────────────────────────────────────────────────────────────────────────
  // Download / Copy (Web-specific)
  // ─────────────────────────────────────────────────────────────────────────

  /// Download content as a file
  static void downloadFile({
    required String content,
    required String filename,
    required String mimeType,
  }) {
    // Create blob and download link using JSArrayBuffer
    final bytes = utf8.encode(content);
    final jsArray = bytes.toJS;
    final blob = web.Blob(
      <JSAny>[jsArray].toJS,
      web.BlobPropertyBag(type: mimeType),
    );

    final url = web.URL.createObjectURL(blob);

    final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
    anchor.href = url;
    anchor.download = filename;
    anchor.style.display = 'none';

    web.document.body?.appendChild(anchor);
    anchor.click();
    web.document.body?.removeChild(anchor);

    web.URL.revokeObjectURL(url);
  }

  /// Copy content to clipboard
  static Future<bool> copyToClipboard(String content) async {
    try {
      await Clipboard.setData(ClipboardData(text: content));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Export and download logs
  static void exportLogs({
    required List<LogEntryModel> logs,
    required ExportFormat format,
  }) {
    final timestamp = DateTime.now().toIso8601String().split('T').first;

    switch (format) {
      case ExportFormat.json:
        downloadFile(
          content: logsToJson(logs),
          filename: 'logs_$timestamp.json',
          mimeType: 'application/json',
        );
        break;
      case ExportFormat.csv:
        downloadFile(
          content: logsToCsv(logs),
          filename: 'logs_$timestamp.csv',
          mimeType: 'text/csv',
        );
        break;
    }
  }

  /// Export and download network requests
  static void exportNetwork({
    required List<NetworkRequestModel> requests,
    required ExportFormat format,
  }) {
    final timestamp = DateTime.now().toIso8601String().split('T').first;

    switch (format) {
      case ExportFormat.json:
        downloadFile(
          content: networkToJson(requests),
          filename: 'network_$timestamp.json',
          mimeType: 'application/json',
        );
        break;
      case ExportFormat.csv:
        downloadFile(
          content: networkToCsv(requests),
          filename: 'network_$timestamp.csv',
          mimeType: 'text/csv',
        );
        break;
    }
  }

  /// Export and download analytics events
  static void exportAnalytics({
    required List<LogEntryModel> events,
    required ExportFormat format,
  }) {
    final timestamp = DateTime.now().toIso8601String().split('T').first;

    switch (format) {
      case ExportFormat.json:
        downloadFile(
          content: analyticsToJson(events),
          filename: 'analytics_$timestamp.json',
          mimeType: 'application/json',
        );
        break;
      case ExportFormat.csv:
        downloadFile(
          content: analyticsToCsv(events),
          filename: 'analytics_$timestamp.csv',
          mimeType: 'text/csv',
        );
        break;
    }
  }

  /// Export and download performance metrics
  static void exportPerformance({
    required List<LogEntryModel> metrics,
    required ExportFormat format,
  }) {
    final timestamp = DateTime.now().toIso8601String().split('T').first;

    switch (format) {
      case ExportFormat.json:
        downloadFile(
          content: performanceToJson(metrics),
          filename: 'performance_$timestamp.json',
          mimeType: 'application/json',
        );
        break;
      case ExportFormat.csv:
        downloadFile(
          content: performanceToCsv(metrics),
          filename: 'performance_$timestamp.csv',
          mimeType: 'text/csv',
        );
        break;
    }
  }

}
