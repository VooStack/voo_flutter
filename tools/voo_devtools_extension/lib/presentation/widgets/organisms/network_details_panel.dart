import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_logging/features/logging/data/models/log_entry_model.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/detail_header.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/detail_section.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/detail_section_with_actions.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/network_method_chip.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/network_status_badge.dart';

class NetworkDetailsPanel extends StatelessWidget {
  final LogEntryModel log;
  final VoidCallback onClose;

  const NetworkDetailsPanel({
    super.key,
    required this.log,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final metadata = log.metadata ?? {};
    final method = metadata['method'] as String? ?? 'GET';
    final url = metadata['url'] as String? ?? log.message;
    final statusCode = metadata['statusCode'] as int?;
    final duration = metadata['duration'] as int?;
    // Headers might be in the metadata directly for requests
    final requestHeaders = metadata['headers'] as Map<String, dynamic>? ?? 
                           metadata['requestHeaders'] as Map<String, dynamic>?;
    final responseHeaders = metadata['responseHeaders'] as Map<String, dynamic>?;
    final requestBody = metadata['requestBody'];
    final responseBody = metadata['responseBody'];

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(left: BorderSide(color: theme.dividerColor)),
      ),
      child: Column(
        children: [
          DetailHeader(
            title: 'Network Request Details',
            onClose: onClose,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Request Overview
                  Row(
                    children: [
                      NetworkMethodChip(method: method),
                      const SizedBox(width: 12),
                      if (statusCode != null) ...[
                        NetworkStatusBadge(statusCode: statusCode),
                        const SizedBox(width: 12),
                      ],
                      if (duration != null)
                        Text(
                          '${duration}ms',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: duration > 1000 ? Colors.orange : null,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // URL Section
                  DetailSection(
                    title: 'URL',
                    content: SelectableText(
                      url,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),

                  // Timing
                  if (duration != null) ...[
                    const SizedBox(height: 16),
                    DetailSection(
                      title: 'Timing',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Duration', '${duration}ms'),
                          _buildInfoRow('Timestamp', log.timestamp.toString()),
                        ],
                      ),
                    ),
                  ],

                  // Request Headers
                  if (requestHeaders != null && requestHeaders.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    DetailSection(
                      title: 'Request Headers',
                      content: _buildHeadersList(requestHeaders),
                    ),
                  ],

                  // Request Body
                  if (requestBody != null) ...[
                    const SizedBox(height: 16),
                    DetailSectionWithActions(
                      title: 'Request Body',
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.copy, size: 18),
                          onPressed: () => _copyToClipboard(context, requestBody.toString()),
                          tooltip: 'Copy request body',
                        ),
                      ],
                      content: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: SelectableText(
                          _formatJson(requestBody),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ),
                  ],

                  // Response Headers
                  if (responseHeaders != null && responseHeaders.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    DetailSection(
                      title: 'Response Headers',
                      content: _buildHeadersList(responseHeaders),
                    ),
                  ],

                  // Response Body
                  if (responseBody != null) ...[
                    const SizedBox(height: 16),
                    DetailSectionWithActions(
                      title: 'Response Body',
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.copy, size: 18),
                          onPressed: () => _copyToClipboard(context, responseBody.toString()),
                          tooltip: 'Copy response body',
                        ),
                      ],
                      content: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: SelectableText(
                          _formatJson(responseBody),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ),
                  ],

                  // Error Section
                  if (log.error != null) ...[
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
                          log.error.toString(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.red,
                            fontFamily: 'monospace',
                          ),
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
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(fontSize: 12),
            ),
          ),
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}