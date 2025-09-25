import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Modern badge widget for drawer navigation items
class VooDrawerModernBadge extends StatelessWidget {
  /// The navigation item
  final VooNavigationItem item;

  /// Whether the parent item is selected
  final bool isSelected;

  const VooDrawerModernBadge({
    super.key,
    required this.item,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String badgeText;
    if (item.badgeCount != null) {
      badgeText = item.badgeCount! > 99 ? '99+' : item.badgeCount.toString();
    } else if (item.badgeText != null) {
      badgeText = item.badgeText!;
    } else if (item.showDot) {
      return Container(
        width: context.vooSize.badgeMedium,
        height: context.vooSize.badgeMedium,
        decoration: BoxDecoration(
          color: item.badgeColor ?? theme.colorScheme.error,
          shape: BoxShape.circle,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.vooSpacing.sm,
        vertical: context.vooSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? (item.badgeColor ?? theme.colorScheme.primary)
            : theme.colorScheme.onSurface.withValues(alpha: 0.2),
        borderRadius: context.vooRadius.card,
      ),
      child: Text(
        badgeText,
        style: theme.textTheme.labelSmall?.copyWith(
          color: isSelected
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurface.withValues(alpha: 0.9),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}