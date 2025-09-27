import 'package:flutter/material.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Background indicator widget for navigation items
class VooBackgroundIndicator extends StatelessWidget {
  /// Whether the indicator is selected
  final bool isSelected;

  /// Child widget to wrap
  final Widget child;

  /// Indicator color
  final Color color;

  /// Indicator shape
  final ShapeBorder? shape;

  /// Padding around the indicator
  final EdgeInsetsGeometry padding;

  /// Animation duration
  final Duration duration;

  /// Animation curve
  final Curve curve;

  /// Whether to animate the indicator
  final bool animate;

  const VooBackgroundIndicator({
    super.key,
    required this.isSelected,
    required this.child,
    required this.color,
    this.shape,
    required this.padding,
    required this.duration,
    required this.curve,
    required this.animate,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveShape =
        shape ?? RoundedRectangleBorder(borderRadius: context.vooRadius.card);

    if (!animate) {
      return Container(
        padding: padding,
        decoration: ShapeDecoration(
          color: isSelected ? color : Colors.transparent,
          shape: effectiveShape,
        ),
        child: child,
      );
    }

    return AnimatedContainer(
      duration: duration,
      curve: curve,
      padding: padding,
      decoration: ShapeDecoration(
        color: isSelected ? color : Colors.transparent,
        shape: effectiveShape,
      ),
      child: child,
    );
  }
}
