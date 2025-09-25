import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation/src/presentation/molecules/drawer_modern_badge.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Navigation item widget for drawer
class VooDrawerNavigationItem extends StatelessWidget {
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

  const VooDrawerNavigationItem({
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
        padding: EdgeInsets.only(bottom: context.vooSpacing.xs),
        child: InkWell(
          onTap: item.isEnabled ? () => onItemTap(item) : null,
          borderRadius: BorderRadius.circular(context.vooRadius.lg),
          child: AnimatedContainer(
            duration: context.vooAnimation.durationFast,
            padding: EdgeInsets.symmetric(
              horizontal: context.vooSpacing.md,
              vertical: context.vooSpacing.sm + context.vooSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary.withValues(alpha: 0.12)
                  : isHovered
                      ? theme.colorScheme.onSurface.withValues(alpha: 0.05)
                      : Colors.transparent,
              border: isSelected
                  ? Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      width: context.vooSize.borderThin,
                    )
                  : null,
              borderRadius: BorderRadius.circular(context.vooRadius.lg),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: theme.colorScheme.shadow.withValues(alpha: 0.06),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      )
                    ]
                  : null,
            ),
            child: Row(
              children: [
                // Icon
                AnimatedSwitcher(
                  duration: context.vooAnimation.durationFast,
                  child: Icon(
                    isSelected ? item.effectiveSelectedIcon : item.icon,
                    key: ValueKey(isSelected),
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    size: context.vooSize.checkboxSize,
                  ),
                ),

                SizedBox(width: context.vooSpacing.sm + context.vooSpacing.xs),

                // Label
                Expanded(
                  child: Text(
                    item.label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withValues(alpha: 0.85),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      fontSize: context.vooTypography.bodyMedium.fontSize,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Modern badge
                if (item.hasBadge) ...[
                  SizedBox(width: context.vooSpacing.sm),
                  VooDrawerModernBadge(
                    item: item,
                    isSelected: isSelected,
                  ),
                ],

                // Trailing widget
                if (item.trailingWidget != null) ...[
                  SizedBox(width: context.vooSpacing.sm),
                  item.trailingWidget!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}