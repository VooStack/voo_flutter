import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final List<StatItem> stats;
  final Widget? trailing;
  final VoidCallback? onTap;

  const StatsCard({
    super.key,
    required this.title,
    required this.stats,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.all(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 24,
                runSpacing: 16,
                children: stats.map((stat) {
                  return _buildStatItem(stat, theme, colorScheme);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(StatItem stat, ThemeData theme, ColorScheme colorScheme) {
    final color = stat.color ?? colorScheme.primary;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (stat.icon != null) ...[
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              stat.icon,
              size: 20,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
        ],
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stat.label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              stat.value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (stat.subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                stat.subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class StatItem {
  final String label;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? color;

  const StatItem({
    required this.label,
    required this.value,
    this.subtitle,
    this.icon,
    this.color,
  });
}