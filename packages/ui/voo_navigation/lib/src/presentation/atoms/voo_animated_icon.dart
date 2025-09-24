import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation/src/presentation/atoms/voo_icon_with_badge.dart';

/// Animated icon widget that scales based on animation
class VooAnimatedIcon extends StatelessWidget {
  /// Navigation item containing icon data
  final VooNavigationItem item;

  /// Whether this item is selected
  final bool isSelected;

  /// Index of this item in the navigation
  final int index;

  /// Whether to use selected icon variant
  final bool useSelectedIcon;

  /// Scale animation for this icon
  final Animation<double> scaleAnimation;

  /// Navigation configuration
  final VooNavigationConfig config;

  const VooAnimatedIcon({
    super.key,
    required this.item,
    required this.isSelected,
    required this.index,
    required this.useSelectedIcon,
    required this.scaleAnimation,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: scaleAnimation.value,
        child: VooIconWithBadge(
          item: item,
          isSelected: isSelected,
          useSelectedIcon: useSelectedIcon,
          config: config,
        ),
      ),
    );
  }
}