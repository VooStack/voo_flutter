import 'package:flutter/material.dart';

class PerformanceAveragesCard extends StatelessWidget {
  final Map<String, double> averageDurations;
  
  const PerformanceAveragesCard({
    super.key,
    required this.averageDurations,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Average Durations', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: averageDurations.entries.map((entry) {
              final avgMs = entry.value.round();
              final color = _getDurationColor(avgMs);
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
                  const SizedBox(width: 4),
                  Text(
                    '${entry.key}: ${avgMs}ms',
                    style: theme.textTheme.bodySmall?.copyWith(color: color),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _getDurationColor(int ms) {
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
}