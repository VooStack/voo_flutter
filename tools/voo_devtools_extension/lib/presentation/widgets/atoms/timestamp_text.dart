import 'package:flutter/material.dart';

/// Atomic widget for displaying formatted timestamps
class TimestampText extends StatelessWidget {
  final DateTime timestamp;
  final TextStyle? style;

  const TimestampText({super.key, required this.timestamp, this.style});

  @override
  Widget build(BuildContext context) => Text(
    _formatTime(timestamp),
    style: style ?? Theme.of(context).textTheme.bodySmall,
  );

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }
}
