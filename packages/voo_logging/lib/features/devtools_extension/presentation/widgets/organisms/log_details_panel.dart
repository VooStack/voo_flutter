import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_logging/core/domain/extensions/log_level_extensions.dart';
import 'package:voo_logging/features/devtools_extension/presentation/widgets/atoms/detail_section.dart';
import 'package:voo_logging/features/devtools_extension/presentation/widgets/atoms/info_row.dart';
import 'package:voo_logging/features/devtools_extension/presentation/widgets/molecules/log_detail_header.dart';
import 'package:voo_logging/features/logging/data/models/log_entry_model.dart';

class LogDetailsPanel extends StatelessWidget {
  final LogEntryModel log;
  final VoidCallback? onClose;

  const LogDetailsPanel({super.key, required this.log, this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(left: BorderSide(color: theme.dividerColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LogDetailHeader(log: log, onCopyAll: () => _copyAllToClipboard(context), onClose: onClose),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailSection(title: 'Message', content: SelectableText(log.message)),
                  const SizedBox(height: 16),
                  InfoRow(label: 'Timestamp', value: log.timestamp.toIso8601String()),
                  InfoRow(label: 'Level', value: log.level.displayName),
                  if (log.category != null) InfoRow(label: 'Category', value: log.category!),
                  if (log.tag != null) InfoRow(label: 'Tag', value: log.tag!),
                  if (log.userId != null) InfoRow(label: 'User ID', value: log.userId!),
                  if (log.sessionId != null) InfoRow(label: 'Session ID', value: log.sessionId!),
                  if (log.error != null) ...[
                    const SizedBox(height: 16),
                    DetailSection(
                      title: 'Error',
                      content: SelectableText(log.error.toString(), style: TextStyle(color: theme.colorScheme.error)),
                    ),
                  ],
                  if (log.stackTrace != null) ...[
                    const SizedBox(height: 16),
                    DetailSection(
                      title: 'Stack Trace',
                      content: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: theme.colorScheme.onSurface.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(4)),
                        child: SelectableText(log.stackTrace!, style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace')),
                      ),
                    ),
                  ],
                  if (log.metadata != null && log.metadata!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    DetailSection(
                      title: 'Metadata',
                      content: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: theme.colorScheme.onSurface.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(4)),
                        child: SelectableText(
                          const JsonEncoder.withIndent('  ').convert(log.metadata),
                          style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
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


  void _copyAllToClipboard(BuildContext context) {
    final buffer = StringBuffer();
    buffer.writeln('=== LOG DETAILS ===');
    buffer.writeln('Timestamp: ${log.timestamp.toIso8601String()}');
    buffer.writeln('Level: ${log.level.displayName}');
    if (log.category != null) buffer.writeln('Category: ${log.category}');
    if (log.tag != null) buffer.writeln('Tag: ${log.tag}');
    if (log.userId != null) buffer.writeln('User ID: ${log.userId}');
    if (log.sessionId != null) buffer.writeln('Session ID: ${log.sessionId}');
    buffer.writeln('\nMessage:\n${log.message}');

    if (log.error != null) {
      buffer.writeln('\nError:\n${log.error}');
    }

    if (log.stackTrace != null) {
      buffer.writeln('\nStack Trace:\n${log.stackTrace}');
    }

    if (log.metadata != null && log.metadata!.isNotEmpty) {
      buffer.writeln('\nMetadata:');
      buffer.writeln(const JsonEncoder.withIndent('  ').convert(log.metadata));
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Log details copied to clipboard'), duration: Duration(seconds: 2)));
  }
}
