import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation/src/presentation/molecules/voo_navigation_badge.dart';

/// Icon with optional badge widget for navigation items
class VooIconWithBadge extends StatelessWidget {
  /// Navigation item containing icon and badge data
  final VooNavigationItem item;

  /// Whether this item is selected
  final bool isSelected;

  /// Whether to use selected icon variant
  final bool useSelectedIcon;

  /// Navigation configuration
  final VooNavigationConfig config;

  /// Selected item color override
  final Color? selectedColor;

  /// Unselected item color override
  final Color? unselectedColor;

  const VooIconWithBadge({
    super.key,
    required this.item,
    required this.isSelected,
    required this.useSelectedIcon,
    required this.config,
    this.selectedColor,
    this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveSelectedColor = selectedColor ??
        config.selectedItemColor ?? colorScheme.primary;
    final effectiveUnselectedColor = unselectedColor ??
        config.unselectedItemColor ?? colorScheme.onSurfaceVariant;

    final icon = AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(scale: animation, child: child),
      ),
      child: item.leadingWidget ??
          Icon(
            useSelectedIcon ? item.effectiveSelectedIcon : item.icon,
            key: ValueKey('${item.id}_${useSelectedIcon}_$isSelected'),
            color: isSelected
                ? (item.selectedIconColor ?? effectiveSelectedColor)
                : (item.iconColor ?? effectiveUnselectedColor),
            size: isSelected ? 28 : 24,
          ),
    );

    if (item.hasBadge) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          icon,
          Positioned(
            top: -4,
            right: -4,
            child: VooNavigationBadge(item: item, config: config),
          ),
        ],
      );
    }

    return icon;
  }
}