import 'package:flutter/material.dart';

/// Custom indicator widget with scale animation
class VooCustomIndicator extends StatelessWidget {
  /// Whether the indicator is selected
  final bool isSelected;

  /// Child widget to wrap
  final Widget child;

  /// Padding around the child
  final EdgeInsetsGeometry padding;

  /// Animation duration
  final Duration duration;

  /// Animation curve
  final Curve curve;

  /// Whether to animate the indicator
  final bool animate;

  const VooCustomIndicator({
    super.key,
    required this.isSelected,
    required this.child,
    required this.padding,
    required this.duration,
    required this.curve,
    required this.animate,
  });

  @override
  Widget build(BuildContext context) {
    if (!animate || !isSelected) {
      return Padding(padding: padding, child: child);
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: isSelected ? 1 : 0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) => Transform.scale(
        scale: 1 + (value * 0.05),
        child: Padding(padding: padding, child: this.child),
      ),
      child: child,
    );
  }
}
