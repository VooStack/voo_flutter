import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_logging_devtools_extension/core/models/log_entry_model.dart';
import 'package:voo_logging_devtools_extension/core/models/network_request_model.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/detail_header.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/detail_section.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/detail_section_with_actions.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/method_badge.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/status_badge.dart';

class NetworkDetailsPanel extends StatelessWidget {
  final LogEntryModel? log;
  final NetworkRequestModel? request;
  final VoidCallback onClose;

  const NetworkDetailsPanel({super.key, this.log, this.request, required this.onClose}) : assert(log != null || request != null, 'Either log or request must be provided');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Use request if available, otherwise convert log to request
    final networkRequest = request ?? (log != null ? NetworkRequestModel.fromLogEntry(log!) : null);
    if (networkRequest == null) {
      return Container(); // Should never happen due to assert
    }

    final method = networkRequest.method;
    final url = networkRequest.url;
    final statusCode = networkRequest.statusCode;
    final duration = networkRequest.duration;
    final requestHeaders = networkRequest.requestHeaders;
    final responseHeaders = networkRequest.responseHeaders;
    final requestBody = networkRequest.requestBody;
    final responseBody = networkRequest.responseBody;
    final error = networkRequest.error;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(left: BorderSide(color: theme.dividerColor)),
      ),
      child: Column(
        children: [
          DetailHeader(title: 'Network Request Details', onClose: onClose),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Request Overview
                  Row(
                    children: [
                      MethodBadge(method: method),
                      const SizedBox(width: 12),
                      if (statusCode != null) ...[StatusBadge(statusCode: statusCode), const SizedBox(width: 12)],
                      if (duration != null)
                        Text(
                          '${duration}ms',
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: duration > 1000 ? Colors.orange : null),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // URL Section
                  DetailSection(
                    title: 'URL',
                    content: SelectableText(url, style: theme.textTheme.bodyMedium),
                  ),

                  // Timing
                  if (duration != null) ...[
                    const SizedBox(height: 16),
                    DetailSection(
                      title: 'Timing',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [_buildInfoRow('Duration', '${duration}ms'), _buildInfoRow('Timestamp', networkRequest.timestamp.toString())],
                      ),
                    ),
                  ],

                  // Request Headers
                  if (requestHeaders != null && requestHeaders.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    DetailSection(title: 'Request Headers', content: _buildHeadersList(requestHeaders)),
                  ],

                  // Request Body
                  if (requestBody != null) ...[
                    const SizedBox(height: 16),
                    DetailSectionWithActions(
                      title: 'Request Body',
                      actions: [
                        IconButton(icon: const Icon(Icons.copy, size: 18), onPressed: () => _copyToClipboard(context, requestBody.toString()), tooltip: 'Copy request body'),
                      ],
                      content: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(4)),
                        child: SelectableText(_formatJson(requestBody), style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace')),
                      ),
                    ),
                  ],

                  // Response Headers
                  if (responseHeaders != null && responseHeaders.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    DetailSection(title: 'Response Headers', content: _buildHeadersList(responseHeaders)),
                  ],

                  // Response Body
                  if (responseBody != null) ...[
                    const SizedBox(height: 16),
                    DetailSectionWithActions(
                      title: 'Response Body',
                      actions: [
                        IconButton(icon: const Icon(Icons.copy, size: 18), onPressed: () => _copyToClipboard(context, responseBody.toString()), tooltip: 'Copy response body'),
                      ],
                      content: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(4)),
                        child: SelectableText(_formatJson(responseBody), style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace')),
                      ),
                    ),
                  ],

                  // Error Section
                  if (error != null) ...[
                    const SizedBox(height: 16),
                    DetailSection(
                      title: 'Error',
                      content: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                        ),
                        child: SelectableText(
                          error,
                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.red, fontFamily: 'monospace'),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          Expanded(child: SelectableText(value, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildHeadersList(Map<String, dynamic> headers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: headers.entries.map((entry) {
        return _buildInfoRow(entry.key, entry.value.toString());
      }).toList(),
    );
  }

  String _formatJson(dynamic json) {
    try {
      if (json is String) {
        return json;
      }
      // Pretty print JSON with 2 spaces indentation
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(json);
    } catch (_) {
      return json.toString();
    }
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard'), duration: Duration(seconds: 2)));
  }
}
