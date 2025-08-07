import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_logging/features/logging/data/models/log_entry_model.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/detail_header.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/detail_section.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/detail_section_with_actions.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/performance_indicator.dart';

class PerformanceDetailsPanel extends StatelessWidget {
  final LogEntryModel log;
  final VoidCallback onClose;

  const PerformanceDetailsPanel({
    super.key,
    required this.log,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final metadata = log.metadata ?? {};
    final durationMs = metadata['duration'] as int? ?? 0;
    final duration = Duration(milliseconds: durationMs);
    final operation = metadata['operation'] as String? ?? log.message;
    final operationType = metadata['operationType'] as String?;
    final metrics = metadata['metrics'] as Map<String, dynamic>?;
    final startTime = metadata['startTime'] as String?;
    final endTime = metadata['endTime'] as String?;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(left: BorderSide(color: theme.dividerColor)),
      ),
      child: Column(
        children: [
          DetailHeader(
            title: 'Performance Details',
            onClose: onClose,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Performance Overview
                  Row(
                    children: [
                      PerformanceIndicator(duration: duration),
                      const SizedBox(width: 12),
                      if (operationType != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            operationType,
                            style: theme.textTheme.labelMedium,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Operation Section
                  DetailSection(
                    title: 'Operation',
                    content: SelectableText(
                      operation,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),

                  // Timing Details
                  const SizedBox(height: 16),
                  DetailSection(
                    title: 'Timing',
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Duration', _formatDuration(duration)),
                        if (startTime != null)
                          _buildInfoRow('Start Time', startTime),
                        if (endTime != null)
                          _buildInfoRow('End Time', endTime),
                        _buildInfoRow('Logged At', log.timestamp.toString()),
                      ],
                    ),
                  ),

                  // Metrics Section
                  if (metrics != null && metrics.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    DetailSectionWithActions(
                      title: 'Metrics',
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.copy, size: 18),
                          onPressed: () => _copyToClipboard(context, _formatJson(metrics)),
                          tooltip: 'Copy metrics',
                        ),
                      ],
                      content: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: metrics.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 120,
                                    child: Text(
                                      entry.key,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SelectableText(
                                      _formatValue(entry.value),
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],

                  // Additional Metadata
                  if (metadata.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    DetailSectionWithActions(
                      title: 'Additional Data',
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.copy, size: 18),
                          onPressed: () => _copyToClipboard(context, _formatJson(metadata)),
                          tooltip: 'Copy all data',
                        ),
                      ],
                      content: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: SelectableText(
                          _formatJson(metadata),
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

  String _formatDuration(Duration duration) {
    final ms = duration.inMilliseconds;
    if (ms < 1000) {
      return '${ms}ms';
    } else {
      return '${(ms / 1000).toStringAsFixed(2)}s';
    }
  }

  String _formatValue(dynamic value) {
    if (value is Map || value is List) {
      return _formatJson(value);
    }
    return value.toString();
  }

  String _formatJson(dynamic json) {
    try {
      if (json is String) {
        return json;
      }
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