import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation/src/presentation/atoms/voo_modern_badge.dart';

/// Modern icon widget with badge support for custom navigation
class VooModernIcon extends StatelessWidget {
  /// Navigation item containing icon data
  final VooNavigationItem item;

  /// Whether this item is selected
  final bool isSelected;

  /// Primary color for theming
  final Color primaryColor;

  const VooModernIcon({
    super.key,
    required this.item,
    required this.isSelected,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final icon = AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Icon(
        isSelected ? item.effectiveSelectedIcon : item.icon,
        key: ValueKey(isSelected),
        color: isSelected
            ? theme.colorScheme.primary
            : Colors.white.withValues(alpha: 0.8),
        size: isSelected ? 22 : 20,
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
            child: VooModernBadge(
              item: item,
              isSelected: isSelected,
              primaryColor: primaryColor,
            ),
          ),
        ],
      );
    }

    return icon;
  }
}