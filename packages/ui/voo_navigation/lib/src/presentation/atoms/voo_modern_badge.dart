import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Modern badge widget for navigation items
class VooModernBadge extends StatelessWidget {
  /// Navigation item containing badge data
  final VooNavigationItem item;

  /// Whether the parent item is selected
  final bool isSelected;

  /// Primary color for selected state
  final Color primaryColor;

  const VooModernBadge({
    super.key,
    required this.item,
    required this.isSelected,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Handle dot badge
    if (item.showDot) {
      return Container(
        width: context.vooSize.badgeMedium,
        height: context.vooSize.badgeMedium,
        decoration: BoxDecoration(
          color: item.badgeColor ?? Colors.red,
          shape: BoxShape.circle,
        ),
      );
    }

    // Get badge text
    String badgeText;
    if (item.badgeCount != null) {
      badgeText = item.badgeCount! > 99 ? '99+' : item.badgeCount.toString();
    } else if (item.badgeText != null) {
      badgeText = item.badgeText!;
    } else {
      return const SizedBox.shrink();
    }

    // Build text badge
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.vooSpacing.sm - context.vooSpacing.xxs,
        vertical: context.vooSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? (item.badgeColor ?? primaryColor)
            : Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(context.vooRadius.lg),
      ),
      constraints: const BoxConstraints(minWidth: 18),
      child: Text(
        badgeText,
        style: theme.textTheme.labelSmall?.copyWith(
          color: isSelected
              ? Colors.white
              : Colors.white.withValues(alpha: 0.9),
          fontWeight: FontWeight.w600,
          fontSize: context.vooTypography.bodySmall.fontSize,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}