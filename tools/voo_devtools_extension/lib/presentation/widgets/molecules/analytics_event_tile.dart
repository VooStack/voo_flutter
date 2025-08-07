import 'package:flutter/material.dart';
import 'package:voo_logging/features/logging/data/models/log_entry_model.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/timestamp_text.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/log_level_indicator.dart';

class AnalyticsEventTile extends StatelessWidget {
  final LogEntryModel event;
  final bool isSelected;
  final VoidCallback onTap;

  const AnalyticsEventTile({super.key, required this.event, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3) : null,
          border: Border(bottom: BorderSide(color: theme.dividerColor, width: 0.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LogLevelIndicator(level: event.level),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (event.category != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: theme.colorScheme.secondary.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                          child: Text(event.category!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.secondary)),
                        ),
                        const SizedBox(width: 8),
                      ],
                      TimestampText(timestamp: event.timestamp),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(event.message, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
