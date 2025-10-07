import 'package:flutter/material.dart';
import 'package:voo_devtools_extension/core/models/log_entry_model.dart';
import 'package:voo_devtools_extension/presentation/theme/app_theme.dart';
import 'package:voo_devtools_extension/presentation/widgets/molecules/universal_list_tile.dart';

/// Performance metric tile using the universal list tile component
class PerformanceListTile extends StatelessWidget {
  final LogEntryModel log;
  final bool isSelected;
  final VoidCallback onTap;

  const PerformanceListTile({
    super.key,
    required this.log,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final metadata = log.metadata ?? {};
    final durationMs = metadata['duration'] as int? ?? 0;
    final operation = metadata['operation'] as String? ?? log.message;
    final operationType = metadata['operationType'] as String?;

    // Determine performance color based on duration
    final (color, performanceLabel) = _getPerformanceInfo(durationMs);

    return UniversalListTile(
      id: log.id,
      title: operation,
      subtitle: operationType ?? 'Performance Metric',
      category: log.category ?? 'Performance',
      timestamp: log.timestamp,
      leadingBadge: _buildPerformanceBadge(context, durationMs, color),
      trailingBadges: [
        if (operationType != null)
          _buildOperationTypeBadge(context, operationType),
        if (durationMs > 1000) _buildSlowBadge(context),
      ],
      metadata: {
        'duration': _formatDuration(durationMs),
        if (metadata['metrics'] != null)
          'metrics': '${(metadata['metrics'] as Map).length} items',
      },
      isSelected: isSelected,
      onTap: onTap,
      accentColor: color,
      icon: _getOperationIcon(operationType),
      showTimestamp: true,
    );
  }

  Widget _buildPerformanceBadge(
    BuildContext context,
    int durationMs,
    Color color,
  ) {
    final theme = Theme.of(context);
    final label = _formatDuration(durationMs);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, size: 16, color: color),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
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

  Widget _buildSlowBadge(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber_outlined, size: 12, color: Colors.orange),
          const SizedBox(width: 2),
          Text(
            'SLOW',
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  (Color, String) _getPerformanceInfo(int durationMs) {
    if (durationMs < 100) {
      return (Colors.green, 'Fast');
    } else if (durationMs < 500) {
      return (Colors.blue, 'Normal');
    } else if (durationMs < 1000) {
      return (Colors.amber, 'Moderate');
    } else if (durationMs < 3000) {
      return (Colors.orange, 'Slow');
    } else {
      return (Colors.red, 'Very Slow');
    }
  }

  (IconData, Color) _getOperationTypeInfo(String? type) {
    switch (type?.toLowerCase()) {
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

  IconData _getOperationIcon(String? operationType) {
    return _getOperationTypeInfo(operationType).$1;
  }

  String _formatDuration(int durationMs) {
    if (durationMs < 1000) {
      return '${durationMs}ms';
    } else {
      return '${(durationMs / 1000).toStringAsFixed(1)}s';
    }
  }
}
