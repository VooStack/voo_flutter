import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation/src/presentation/atoms/voo_icon_with_badge.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Material 2 bottom navigation bar wrapper
class VooMaterial2BottomNavigation extends StatelessWidget {
  /// Navigation items to display
  final List<VooNavigationItem> items;

  /// Currently selected index
  final int selectedIndex;

  /// Navigation configuration
  final VooNavigationConfig config;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom elevation
  final double? elevation;

  /// Whether to show labels
  final bool showLabels;

  /// Whether to show selected labels only
  final bool showSelectedLabels;

  /// Whether to enable feedback
  final bool enableFeedback;

  /// Callback when item is selected
  final void Function(String itemId) onItemSelected;

  const VooMaterial2BottomNavigation({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.config,
    required this.showLabels,
    required this.showSelectedLabels,
    required this.enableFeedback,
    required this.onItemSelected,
    this.backgroundColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        if (enableFeedback) {
          HapticFeedback.lightImpact();
        }
        final item = items[index];
        if (item.isEnabled) {
          onItemSelected(item.id);
        }
      },
      backgroundColor: backgroundColor ?? config.navigationBackgroundColor,
      elevation: elevation ?? config.elevation ?? context.vooElevation.level4,
      selectedItemColor: config.selectedItemColor,
      unselectedItemColor: config.unselectedItemColor,
      showSelectedLabels: showSelectedLabels,
      showUnselectedLabels: showLabels,
      type: items.length > 3
          ? BottomNavigationBarType.fixed
          : BottomNavigationBarType.shifting,
      items: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isSelected = index == selectedIndex;

        return BottomNavigationBarItem(
          icon: VooIconWithBadge(
            item: item,
            isSelected: isSelected,
            useSelectedIcon: false,
            config: config,
          ),
          activeIcon: VooIconWithBadge(
            item: item,
            isSelected: isSelected,
            useSelectedIcon: true,
            config: config,
          ),
          label: item.label,
          tooltip: item.effectiveTooltip,
          backgroundColor: item.iconColor?.withAlpha((0.1 * 255).round()),
        );
      }).toList(),
    );
  }
}