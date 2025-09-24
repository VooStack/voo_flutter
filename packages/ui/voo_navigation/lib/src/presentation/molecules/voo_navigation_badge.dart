import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation/src/presentation/atoms/voo_dot_badge.dart';
import 'package:voo_navigation/src/presentation/atoms/voo_text_badge.dart';

/// Badge widget for navigation items
class VooNavigationBadge extends StatelessWidget {
  /// The navigation item containing badge data
  final VooNavigationItem item;

  /// Navigation configuration for styling
  final VooNavigationConfig config;

  /// Custom size for the badge
  final double? size;

  /// Whether to animate badge changes
  final bool animate;

  const VooNavigationBadge({
    super.key,
    required this.item,
    required this.config,
    this.size,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!item.hasBadge) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final badgeColor = item.badgeColor ?? theme.colorScheme.error;

    // Handle dot indicator
    if (item.showDot) {
      return VooDotBadge(
        badgeColor: badgeColor,
        size: size ?? 8,
        animate: animate && config.enableAnimations,
        animationDuration: config.badgeAnimationDuration,
      );
    }

    // Handle text/count badge
    final badgeText =
        item.badgeText ??
        (item.badgeCount != null ? _formatCount(item.badgeCount!) : '');

    if (badgeText.isEmpty) {
      return const SizedBox.shrink();
    }

    return VooTextBadge(
      text: badgeText,
      badgeColor: badgeColor,
      textColor: theme.colorScheme.onError,
      size: size ?? 20,
      animate: animate && config.enableAnimations,
      animationDuration: config.badgeAnimationDuration,
    );
  }

  /// Format count for display (e.g., 99+ for counts over 99)
  String _formatCount(int count) {
    if (count > 999) {
      return '999+';
    } else if (count > 99) {
      return '99+';
    }
    return count.toString();
  }
}
