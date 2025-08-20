import 'package:flutter/material.dart';
import 'package:voo_logging_devtools_extension/core/models/log_entry_model.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/performance_indicator.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/timestamp_text.dart';

class PerformanceMetricTile extends StatelessWidget {
  final LogEntryModel log;
  final bool selected;
  final VoidCallback onTap;

  const PerformanceMetricTile({
    super.key,
    required this.log,
    required this.selected,
    required this.onTap,
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

    return Material(
      color: selected ? theme.colorScheme.primary.withValues(alpha: 0.1) : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: theme.dividerColor),
              left: BorderSide(
                color: selected ? theme.colorScheme.primary : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              PerformanceIndicator(duration: duration),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            operation,
                            style: theme.textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (operationType != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              operationType,
                              style: theme.textTheme.labelSmall,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        TimestampText(timestamp: log.timestamp),
                        if (metrics != null && metrics.isNotEmpty) ...[
                          const SizedBox(width: 16),
                          Text(
                            '${metrics.length} metrics',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}