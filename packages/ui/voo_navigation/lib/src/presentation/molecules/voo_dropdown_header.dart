import 'package:flutter/material.dart';
import 'package:voo_tokens/voo_tokens.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation/src/presentation/molecules/voo_navigation_badge.dart';

/// Dropdown header widget for expandable navigation items
class VooDropdownHeader extends StatelessWidget {
  /// Navigation item
  final VooNavigationItem item;

  /// Navigation configuration
  final VooNavigationConfig config;

  /// Whether this header has a selected child
  final bool hasSelectedChild;

  /// Current selected item ID
  final String? selectedId;

  /// Whether the dropdown is expanded
  final bool isExpanded;

  /// Rotation animation for expand icon
  final Animation<double> rotationAnimation;

  /// Tap handler
  final VoidCallback? onTap;

  /// Tile padding
  final EdgeInsetsGeometry? tilePadding;

  const VooDropdownHeader({
    super.key,
    required this.item,
    required this.config,
    required this.hasSelectedChild,
    required this.selectedId,
    required this.isExpanded,
    required this.rotationAnimation,
    this.onTap,
    this.tilePadding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isHighlighted = hasSelectedChild || item.id == selectedId;

    return InkWell(
      onTap: item.isEnabled ? onTap : null,
      borderRadius: context.vooTokens.radius.button,
      child: Padding(
        padding: tilePadding ?? EdgeInsets.symmetric(horizontal: context.vooSpacing.md, vertical: context.vooSpacing.sm + context.vooSpacing.xs),
        child: Row(
          children: [
            // Icon
            AnimatedSwitcher(
              duration: context.vooAnimation.durationFast,
              child: Icon(
                isExpanded ? item.effectiveSelectedIcon : item.icon,
                key: ValueKey('${item.id}_icon_$isExpanded'),
                color: isHighlighted
                    ? (item.selectedIconColor ?? config.selectedItemColor ?? colorScheme.primary)
                    : (item.iconColor ?? config.unselectedItemColor ?? colorScheme.onSurfaceVariant),
              ),
            ),

            SizedBox(width: context.vooSpacing.sm + context.vooSpacing.xs),

            // Label
            Expanded(
              child: AnimatedDefaultTextStyle(
                duration: context.vooAnimation.durationFast,
                style: isHighlighted
                    ? (item.selectedLabelStyle ?? theme.textTheme.bodyLarge!.copyWith(color: config.selectedItemColor ?? colorScheme.primary, fontWeight: FontWeight.w600))
                    : (item.labelStyle ?? theme.textTheme.bodyLarge!.copyWith(color: config.unselectedItemColor ?? colorScheme.onSurfaceVariant)),
                child: Text(item.label, overflow: TextOverflow.ellipsis),
              ),
            ),

            // Badge if present
            if (item.hasBadge) ...[SizedBox(width: context.vooSpacing.sm), VooNavigationBadge(item: item, config: config, size: context.vooSize.iconXSmall, animate: config.enableAnimations)],

            // Expand icon
            SizedBox(width: context.vooSpacing.sm),
            RotationTransition(
              turns: rotationAnimation,
              child: Icon(Icons.expand_more, color: colorScheme.onSurfaceVariant, size: context.vooSize.checkboxSize),
            ),
          ],
        ),
      ),
    );
  }
}
