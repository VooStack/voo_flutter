import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation/src/presentation/atoms/voo_animated_icon.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Material 3 navigation bar wrapper
class VooMaterial3NavigationBar extends StatelessWidget {
  /// Navigation items to display
  final List<VooNavigationItem> items;

  /// Currently selected index
  final int selectedIndex;

  /// Navigation configuration
  final VooNavigationConfig config;

  /// Scale animations for items
  final List<Animation<double>> scaleAnimations;

  /// Custom height
  final double? height;

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

  const VooMaterial3NavigationBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.config,
    required this.scaleAnimations,
    required this.showLabels,
    required this.showSelectedLabels,
    required this.enableFeedback,
    required this.onItemSelected,
    this.height,
    this.backgroundColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        if (enableFeedback) {
          HapticFeedback.lightImpact();
        }
        final item = items[index];
        if (item.isEnabled) {
          onItemSelected(item.id);
        }
      },
      height: height,
      backgroundColor: backgroundColor ?? config.navigationBackgroundColor,
      elevation: elevation ?? config.elevation ?? context.vooElevation.level2,
      labelBehavior: showLabels
          ? (showSelectedLabels
                ? NavigationDestinationLabelBehavior.onlyShowSelected
                : NavigationDestinationLabelBehavior.alwaysShow)
          : NavigationDestinationLabelBehavior.alwaysHide,
      indicatorColor: config.indicatorColor,
      indicatorShape: config.indicatorShape,
      destinations: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isSelected = index == selectedIndex;

        return NavigationDestination(
          icon: VooAnimatedIcon(
            item: item,
            isSelected: isSelected,
            index: index,
            useSelectedIcon: false,
            scaleAnimation: scaleAnimations[index],
            config: config,
          ),
          selectedIcon: VooAnimatedIcon(
            item: item,
            isSelected: isSelected,
            index: index,
            useSelectedIcon: true,
            scaleAnimation: scaleAnimations[index],
            config: config,
          ),
          label: item.label,
          tooltip: item.effectiveTooltip,
          enabled: item.isEnabled,
        );
      }).toList(),
    );
  }
}
