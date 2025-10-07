import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Section header with expansion tile for navigation rail
class VooRailSectionHeader extends StatelessWidget {
  /// Navigation item representing the section
  final VooNavigationItem item;

  /// Child widgets for the expanded section
  final List<Widget> children;

  /// Whether the rail is in extended mode
  final bool extended;

  const VooRailSectionHeader({
    super.key,
    required this.item,
    required this.children,
    this.extended = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.vooSpacing;

    if (extended) {
      // Extended mode: Show label with children
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: spacing.xs,
          horizontal: spacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header with label
            Padding(
              padding: EdgeInsets.only(
                left: spacing.xs,
                bottom: spacing.xxs,
                top: spacing.xs,
              ),
              child: Text(
                item.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            // Children items
            if (item.isExpanded) ...children,
          ],
        ),
      );
    } else {
      // Compact mode: Icon-only with tooltip
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: spacing.xs,
          horizontal: spacing.sm,
        ),
        child: Column(
          children: [
            // Icon-only header with tooltip
            Tooltip(
              message: item.label,
              child: Icon(
                item.isExpanded ? item.selectedIcon ?? item.icon : item.icon,
                color: theme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ),
            if (item.isExpanded) ...[
              SizedBox(height: spacing.xs),
              ...children,
            ],
          ],
        ),
      );
    }
  }
}
