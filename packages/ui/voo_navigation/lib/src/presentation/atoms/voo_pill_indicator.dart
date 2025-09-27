import 'package:flutter/material.dart';

/// Pill-shaped indicator widget for navigation items
class VooPillIndicator extends StatelessWidget {
  /// Whether the indicator is selected
  final bool isSelected;

  /// Child widget to wrap
  final Widget child;

  /// Indicator color
  final Color color;

  /// Border radius for the pill shape
  final double borderRadius;

  /// Padding around the indicator
  final EdgeInsetsGeometry padding;

  /// Animation duration
  final Duration duration;

  /// Animation curve
  final Curve curve;

  /// Whether to animate the indicator
  final bool animate;

  const VooPillIndicator({
    super.key,
    required this.isSelected,
    required this.child,
    required this.color,
    this.borderRadius = 20,
    required this.padding,
    required this.duration,
    required this.curve,
    required this.animate,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: isSelected ? color : Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
    );

    if (!animate) {
      return Container(padding: padding, decoration: decoration, child: child);
    }

    return AnimatedContainer(
      duration: duration,
      curve: curve,
      padding: padding,
      decoration: decoration,
      child: child,
    );
  }
}
