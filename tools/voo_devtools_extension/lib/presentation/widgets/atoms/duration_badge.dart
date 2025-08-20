import 'package:flutter/material.dart';

/// Atomic component for displaying durations with color coding
class DurationBadge extends StatelessWidget {
  final int milliseconds;
  final bool showIcon;

  const DurationBadge({
    super.key,
    required this.milliseconds,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getDurationColor(milliseconds);
    final displayText = _formatDuration(milliseconds);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(Icons.schedule, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            displayText,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDurationColor(int ms) {
    if (ms < 100) {
      return Colors.green;
    } else if (ms < 300) {
      return Colors.lightGreen;
    } else if (ms < 500) {
      return Colors.lime;
    } else if (ms < 1000) {
      return Colors.orange;
    } else if (ms < 3000) {
      return Colors.deepOrange;
    } else {
      return Colors.red;
    }
  }

  String _formatDuration(int ms) {
    if (ms < 1000) {
      return '${ms}ms';
    } else if (ms < 60000) {
      return '${(ms / 1000).toStringAsFixed(1)}s';
    } else {
      final minutes = ms ~/ 60000;
      final seconds = (ms % 60000) ~/ 1000;
      return '${minutes}m ${seconds}s';
    }
  }
}
