import 'package:flutter/material.dart';

/// Dot badge widget for navigation items
class VooDotBadge extends StatelessWidget {
  /// Badge color
  final Color badgeColor;

  /// Badge size
  final double size;

  /// Whether to animate the badge
  final bool animate;

  /// Animation duration
  final Duration animationDuration;

  const VooDotBadge({
    super.key,
    required this.badgeColor,
    required this.size,
    required this.animate,
    required this.animationDuration,
  });

  @override
  Widget build(BuildContext context) {
    final dot = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: badgeColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: badgeColor.withAlpha((0.3 * 255).round()),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );

    if (!animate) {
      return dot;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: animationDuration,
      curve: Curves.elasticOut,
      builder: (context, value, child) =>
          Transform.scale(scale: value, child: child),
      child: dot,
    );
  }
}
