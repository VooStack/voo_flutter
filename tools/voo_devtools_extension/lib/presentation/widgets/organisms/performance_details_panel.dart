import 'package:flutter/material.dart';
import 'package:voo_devtools_extension/core/models/log_entry_model.dart';
import 'package:voo_devtools_extension/presentation/widgets/organisms/universal_details_panel.dart';
import 'package:voo_devtools_extension/presentation/theme/app_theme.dart';

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
    final operation = metadata['operation'] as String? ?? log.message;
    final operationType = metadata['operationType'] as String?;
    final metrics = metadata['metrics'] as Map<String, dynamic>?;
    final startTime = metadata['startTime'] as String?;
    final endTime = metadata['endTime'] as String?;

    // Determine performance color
    final performanceColor = _getPerformanceColor(durationMs);

    // Build sections
    final sections = <DetailSection>[];

    // Performance Overview section
    sections.add(
      DetailSection(
        title: 'Performance Overview',
        content: Row(
          children: [
            _buildPerformanceIndicator(context, durationMs),
            const SizedBox(width: AppTheme.spacingLg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    operation,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (operationType != null) ...[
                    const SizedBox(height: AppTheme.spacingXs),
                    Text(
                      operationType,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // Timing Details section
    sections.add(
      DetailSection(
        title: 'Timing Details',
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UniversalDetailsPanel.buildKeyValueRow(
              'Duration',
              _formatDuration(durationMs),
            ),
            if (startTime != null)
              UniversalDetailsPanel.buildKeyValueRow('Start Time', startTime),
            if (endTime != null)
              UniversalDetailsPanel.buildKeyValueRow('End Time', endTime),
            UniversalDetailsPanel.buildKeyValueRow(
              'Logged At',
              log.timestamp.toIso8601String(),
            ),
          ],
        ),
      ),
    );

    // Metrics section
    if (metrics != null && metrics.isNotEmpty) {
      sections.add(
        DetailSection(
          title: 'Performance Metrics',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: metrics.entries.map((entry) {
              return UniversalDetailsPanel.buildKeyValueRow(
                entry.key,
                _formatValue(entry.value),
                monospace: entry.value is num,
              );
            }).toList(),
          ),
        ),
      );
    }

    // Additional metadata
    if (metadata.isNotEmpty) {
      final filteredMetadata = Map<String, dynamic>.from(metadata)
        ..remove('duration')
        ..remove('operation')
        ..remove('operationType')
        ..remove('startTime')
        ..remove('endTime')
        ..remove('metrics');

      if (filteredMetadata.isNotEmpty) {
        sections.add(
          DetailSection(
            title: 'Additional Data',
            content: UniversalDetailsPanel.buildCodeBlock(
              context,
              UniversalDetailsPanel.formatJson(filteredMetadata),
            ),
            collapsible: true,
            initiallyExpanded: false,
          ),
        );
      }
    }

    // Error section
    if (log.error != null) {
      sections.add(
        DetailSection(
          title: 'Error',
          content: Container(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              border: Border.all(
                color: theme.colorScheme.error.withValues(alpha: 0.5),
              ),
            ),
            child: SelectableText(
              log.error!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ),
      );
    }

    // Stack trace section
    if (log.stackTrace != null) {
      sections.add(
        DetailSection(
          title: 'Stack Trace',
          content: UniversalDetailsPanel.buildCodeBlock(
            context,
            log.stackTrace!,
          ),
          collapsible: true,
          initiallyExpanded: false,
        ),
      );
    }

    return UniversalDetailsPanel(
      title: 'Performance Details',
      headerBadges: [
        _buildDurationBadge(context, durationMs),
        if (operationType != null)
          _buildOperationTypeBadge(context, operationType),
      ],
      sections: sections,
      onClose: onClose,
      accentColor: performanceColor,
    );
  }

  Widget _buildPerformanceIndicator(BuildContext context, int durationMs) {
    final theme = Theme.of(context);
    final color = _getPerformanceColor(durationMs);
    final label = _getPerformanceLabel(durationMs);

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.05)],
        ),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _formatDuration(durationMs),
            style: theme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationBadge(BuildContext context, int durationMs) {
    final theme = Theme.of(context);
    final color = _getPerformanceColor(durationMs);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            _formatDuration(durationMs),
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperationTypeBadge(BuildContext context, String type) {
    final theme = Theme.of(context);
    final (icon, color) = _getOperationTypeInfo(type);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            type,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPerformanceColor(int durationMs) {
    if (durationMs < 100) {
      return Colors.green;
    } else if (durationMs < 500) {
      return Colors.blue;
    } else if (durationMs < 1000) {
      return Colors.amber;
    } else if (durationMs < 3000) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String _getPerformanceLabel(int durationMs) {
    if (durationMs < 100) {
      return 'Fast';
    } else if (durationMs < 500) {
      return 'Normal';
    } else if (durationMs < 1000) {
      return 'Moderate';
    } else if (durationMs < 3000) {
      return 'Slow';
    } else {
      return 'Very Slow';
    }
  }

  (IconData, Color) _getOperationTypeInfo(String type) {
    switch (type.toLowerCase()) {
      case 'network':
        return (Icons.wifi_outlined, Colors.blue);
      case 'database':
        return (Icons.storage_outlined, Colors.purple);
      case 'render':
        return (Icons.brush_outlined, Colors.green);
      case 'computation':
        return (Icons.memory_outlined, Colors.orange);
      case 'custom':
        return (Icons.timer_outlined, Colors.indigo);
      default:
        return (Icons.speed_outlined, Colors.grey);
    }
  }

  String _formatDuration(int durationMs) {
    if (durationMs < 1000) {
      return '${durationMs}ms';
    } else {
      return '${(durationMs / 1000).toStringAsFixed(1)}s';
    }
  }

  String _formatValue(dynamic value) {
    if (value is Map || value is List) {
      return UniversalDetailsPanel.formatJson(value);
    }
    return value.toString();
  }
}
