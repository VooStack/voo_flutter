import 'package:flutter/material.dart';
import 'package:voo_logging/features/logging/data/models/log_entry_model.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/detail_header.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/detail_section.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/info_row.dart';

class AnalyticsDetailsPanel extends StatelessWidget {
  final LogEntryModel event;
  final VoidCallback onClose;

  const AnalyticsDetailsPanel({
    super.key,
    required this.event,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          left: BorderSide(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailHeader(
            title: 'Analytics Event Details',
            onClose: onClose,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailSection(
                    title: 'Event Information',
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoRow(
                          label: 'Timestamp',
                          value: event.timestamp.toIso8601String(),
                        ),
                        if (event.category != null)
                          InfoRow(
                            label: 'Category',
                            value: event.category!,
                          ),
                        InfoRow(
                          label: 'Level',
                          value: event.level.name,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  DetailSection(
                    title: 'Event Message',
                    content: SelectableText(
                      event.message,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  if (event.error != null) ...[
                    const SizedBox(height: 16),
                    DetailSection(
                      title: 'Error',
                      content: SelectableText(
                        event.error.toString(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                  if (event.stackTrace != null) ...[
                    const SizedBox(height: 16),
                    DetailSection(
                      title: 'Stack Trace',
                      content: SelectableText(
                        event.stackTrace!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
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
}