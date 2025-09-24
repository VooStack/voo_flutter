import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Modern badge display for navigation rail items
class VooRailModernBadge extends StatelessWidget {
  /// Navigation item containing badge data
  final VooNavigationItem item;

  /// Whether the item is selected
  final bool isSelected;

  /// Whether this is for extended rail
  final bool extended;

  const VooRailModernBadge({
    super.key,
    required this.item,
    required this.isSelected,
    required this.extended,
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
          color: item.badgeColor ?? Colors.red,
          shape: BoxShape.circle,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: extended
            ? context.vooSpacing.sm
            : context.vooSpacing.sm - context.vooSpacing.xxs,
        vertical: context.vooSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: item.badgeColor ?? theme.colorScheme.error,
        borderRadius: BorderRadius.circular(context.vooRadius.lg),
      ),
      child: Text(
        badgeText,
        style: theme.textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: extended ? 11 : 10,
        ),
      ),
    );
  }
}