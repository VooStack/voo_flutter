import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:voo_telemetry/src/core/telemetry_resource.dart';

/// OTLP HTTP exporter for sending telemetry data
class OTLPHttpExporter {
  final String endpoint;
  final String? apiKey;
  final bool debug;
  final http.Client _client;
  final Duration timeout;

  OTLPHttpExporter({required this.endpoint, this.apiKey, this.debug = false, http.Client? client, this.timeout = const Duration(seconds: 10)})
    : _client = client ?? http.Client();

  /// Export traces to OTLP endpoint
  Future<bool> exportTraces(List<Map<String, dynamic>> spans, TelemetryResource resource) async {
    if (spans.isEmpty) return true;

    final url = Uri.parse('$endpoint/v1/traces');
    final body = {
      'resourceSpans': [
        {
          'resource': resource.toOtlp(),
          'scopeSpans': [
            {
              'scope': {'name': 'voo-telemetry', 'version': '2.0.0'},
              'spans': spans,
            },
          ],
        },
      ],
    };

    return _sendRequest(url, body);
  }

  /// Export metrics to OTLP endpoint
  Future<bool> exportMetrics(List<Map<String, dynamic>> metrics, TelemetryResource resource) async {
    if (metrics.isEmpty) return true;

    final url = Uri.parse('$endpoint/v1/metrics');
    final body = {
      'resourceMetrics': [
        {
          'resource': resource.toOtlp(),
          'scopeMetrics': [
            {
              'scope': {'name': 'voo-telemetry', 'version': '2.0.0'},
              'metrics': metrics,
            },
          ],
        },
      ],
    };

    return _sendRequest(url, body);
  }

  /// Export logs to OTLP endpoint
  Future<bool> exportLogs(List<Map<String, dynamic>> logRecords, TelemetryResource resource) async {
    if (logRecords.isEmpty) return true;

    final url = Uri.parse('$endpoint/v1/logs');
    final body = {
      'resourceLogs': [
        {
          'resource': resource.toOtlp(),
          'scopeLogs': [
            {
              'scope': {'name': 'voo-telemetry', 'version': '2.0.0'},
              'logRecords': logRecords,
            },
          ],
        },
      ],
    };

    return _sendRequest(url, body);
  }

  Future<bool> _sendRequest(Uri url, Map<String, dynamic> body) async {
    try {
      if (debug) {
        debugPrint('Sending OTLP request to $url');
        debugPrint('Body: ${jsonEncode(body)}');
      }

      final response = await _client
          .post(url, headers: {'Content-Type': 'application/json', if (apiKey != null) 'X-API-Key': apiKey!}, body: jsonEncode(body))
          .timeout(timeout);

      if (debug) {
        debugPrint('Response status: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        if (debug) {
          debugPrint('Failed to export telemetry: ${response.statusCode} ${response.body}');
        }
        return false;
      }
    } catch (e, stackTrace) {
      if (debug) {
        debugPrint('Error exporting telemetry: $e');
        debugPrint('Stack trace: $stackTrace');
      }
      return false;
    }
  }

  void dispose() {
    _client.close();
  }
}
