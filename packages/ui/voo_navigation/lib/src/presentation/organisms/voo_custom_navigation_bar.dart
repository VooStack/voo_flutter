import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation/src/presentation/molecules/voo_custom_navigation_item.dart';

/// Custom navigation bar with modern design
class VooCustomNavigationBar extends StatelessWidget {
  /// Navigation items to display
  final List<VooNavigationItem> items;

  /// Currently selected index
  final int selectedIndex;

  /// Navigation configuration
  final VooNavigationConfig config;

  /// Scale animations for items
  final List<Animation<double>> scaleAnimations;

  /// Rotation animations for items
  final List<Animation<double>> rotationAnimations;

  /// Custom height
  final double? height;

  /// Whether to show labels
  final bool showLabels;

  /// Whether to show selected labels only
  final bool showSelectedLabels;

  /// Whether to enable feedback
  final bool enableFeedback;

  /// Callback when item is selected
  final void Function(String itemId) onItemSelected;

  const VooCustomNavigationBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.config,
    required this.scaleAnimations,
    required this.rotationAnimations,
    required this.showLabels,
    required this.showSelectedLabels,
    required this.enableFeedback,
    required this.onItemSelected,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bottomBarColor = isDark
        ? const Color(0xFF1A1D23) // Dark mode: very dark blue-gray
        : const Color(0xFF1F2937); // Light mode: professional dark gray

    return Container(
      height: height ?? 65,
      decoration: BoxDecoration(
        color: bottomBarColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = index == selectedIndex;

          return Expanded(
            child: VooCustomNavigationItem(
              item: item,
              isSelected: isSelected,
              index: index,
              config: config,
              scaleAnimation: scaleAnimations[index],
              rotationAnimation: rotationAnimations[index],
              showLabels: showLabels,
              showSelectedLabels: showSelectedLabels,
              enableFeedback: enableFeedback,
              onTap: () => onItemSelected(item.id),
            ),
          );
        }).toList(),
      ),
    );
  }
}