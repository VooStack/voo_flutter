import 'package:flutter/material.dart';
import 'package:voo_ui_core/src/foundations/spacing.dart';

class VooPageHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Widget> actions;
  final Color? iconColor;

  const VooPageHeader({
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
      height: VooSpacing.headerHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: VooSpacing.lg,
        vertical: VooSpacing.md,
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
              borderRadius: BorderRadius.circular(VooSpacing.radiusMd),
              border: Border.all(
                color: effectiveIconColor.withValues(alpha: 0.2),
              ),
            ),
            child: Icon(icon, size: 24, color: effectiveIconColor),
          ),
          const SizedBox(width: VooSpacing.lg),
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
          ...actions.map(
            (action) => Padding(
              padding: const EdgeInsets.only(left: VooSpacing.sm),
              child: action,
            ),
          ),
        ],
      ),
    );
  }
}