import 'package:flutter/material.dart';
import 'package:voo_logging_devtools_extension/presentation/theme/app_theme.dart';

/// Consistent page header for all tabs
class PageHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Widget> actions;
  final Color? iconColor;

  const PageHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actions = const [],
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIconColor = iconColor ?? theme.colorScheme.primary;

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingLg,
        vertical: AppTheme.spacingMd,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  effectiveIconColor.withValues(alpha: 0.15),
                  effectiveIconColor.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(
                color: effectiveIconColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Icon(icon, size: 24, color: effectiveIconColor),
          ),
          const SizedBox(width: AppTheme.spacingLg),

          // Title and subtitle
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Actions
          ...actions.map(
            (action) => Padding(
              padding: const EdgeInsets.only(left: AppTheme.spacingSm),
              child: action,
            ),
          ),
        ],
      ),
    );
  }
}
