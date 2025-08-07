import 'package:flutter/material.dart';

class PerformanceIndicator extends StatelessWidget {
  final Duration duration;
  final bool showLabel;

  const PerformanceIndicator({
    super.key,
    required this.duration,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getDurationColor(duration);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        if (showLabel) ...[
          const SizedBox(width: 4),
          Text(
            _formatDuration(duration),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ],
    );
  }

  Color _getDurationColor(Duration duration) {
    final ms = duration.inMilliseconds;
    if (ms < 100) {
      return Colors.green;
    } else if (ms < 500) {
      return Colors.lightGreen;
    } else if (ms < 1000) {
      return Colors.orange;
    } else if (ms < 3000) {
      return Colors.deepOrange;
    } else {
      return Colors.red;
    }
  }

  String _formatDuration(Duration duration) {
    final ms = duration.inMilliseconds;
    if (ms < 1000) {
      return '${ms}ms';
    } else {
      return '${(ms / 1000).toStringAsFixed(1)}s';
    }
  }
}