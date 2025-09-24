import 'package:flutter/material.dart';
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
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding:
            tilePadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Icon
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isExpanded ? item.effectiveSelectedIcon : item.icon,
                key: ValueKey('${item.id}_icon_$isExpanded'),
                color: isHighlighted
                    ? (item.selectedIconColor ??
                          config.selectedItemColor ??
                          colorScheme.primary)
                    : (item.iconColor ??
                          config.unselectedItemColor ??
                          colorScheme.onSurfaceVariant),
              ),
            ),

            const SizedBox(width: 12),

            // Label
            Expanded(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: isHighlighted
                    ? (item.selectedLabelStyle ??
                          theme.textTheme.bodyLarge!.copyWith(
                            color:
                                config.selectedItemColor ?? colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ))
                    : (item.labelStyle ??
                          theme.textTheme.bodyLarge!.copyWith(
                            color:
                                config.unselectedItemColor ??
                                colorScheme.onSurfaceVariant,
                          )),
                child: Text(item.label, overflow: TextOverflow.ellipsis),
              ),
            ),

            // Badge if present
            if (item.hasBadge) ...[
              const SizedBox(width: 8),
              VooNavigationBadge(
                item: item,
                config: config,
                size: 16,
                animate: config.enableAnimations,
              ),
            ],

            // Expand icon
            const SizedBox(width: 8),
            RotationTransition(
              turns: rotationAnimation,
              child: Icon(
                Icons.expand_more,
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}