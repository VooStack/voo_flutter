import 'package:flutter/material.dart';

class EmptyAnalyticsPlaceholder extends StatelessWidget {
  const EmptyAnalyticsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics_outlined, size: 64, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text('No Analytics Events', style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
          const SizedBox(height: 8),
          Text('Analytics events will appear here when they are tracked', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.4))),
        ],
      ),
    );
  }
}
