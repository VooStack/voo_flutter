import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation/src/presentation/molecules/drawer_modern_badge.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Child navigation item widget for drawer expandable sections
class VooDrawerChildNavigationItem extends StatelessWidget {
  /// The navigation item
  final VooNavigationItem item;

  /// Navigation configuration
  final VooNavigationConfig config;

  /// Currently selected item ID
  final String selectedId;

  /// Callback when an item is tapped
  final void Function(VooNavigationItem item) onItemTap;

  /// Whether this item is hovered
  final bool isHovered;

  /// Callback to set hover state
  final void Function(bool isHovered) onHoverChanged;

  const VooDrawerChildNavigationItem({
    super.key,
    required this.item,
    required this.config,
    required this.selectedId,
    required this.onItemTap,
    required this.isHovered,
    required this.onHoverChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = item.id == selectedId;

    return MouseRegion(
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      child: Padding(
        padding: EdgeInsets.only(
          left: context.vooSpacing.xl,
          bottom: context.vooSpacing.xxs,
        ),
        child: InkWell(
          onTap: item.isEnabled ? () => onItemTap(item) : null,
          borderRadius: BorderRadius.circular(context.vooRadius.md),
          child: AnimatedContainer(
            duration: context.vooAnimation.durationFast,
            padding: EdgeInsets.symmetric(
              horizontal: context.vooSpacing.sm + context.vooSpacing.xs,
              vertical: context.vooSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.onSurface.withValues(alpha: 0.12)
                  : isHovered
                  ? theme.colorScheme.onSurface.withValues(alpha: 0.06)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(context.vooRadius.md),
            ),
            child: Row(
              children: [
                // Dot indicator for child items
                Container(
                  width: context.vooSize.badgeSmall,
                  height: context.vooSize.badgeSmall,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? config.selectedItemColor ?? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                ),

                SizedBox(width: context.vooSpacing.sm + context.vooSpacing.xs),

                // Label
                Expanded(
                  child: Text(
                    item.label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? config.selectedItemColor ??
                                theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withValues(alpha: 0.9),
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Badge
                if (item.hasBadge) ...[
                  SizedBox(width: context.vooSpacing.sm),
                  VooDrawerModernBadge(item: item, isSelected: isSelected),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
