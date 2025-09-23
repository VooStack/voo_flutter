import 'package:flutter/material.dart';

/// Selection indicator for navigation items
class VooNavigationIndicator extends StatelessWidget {
  /// Whether to show the indicator
  final bool isSelected;

  /// Child widget to wrap with indicator
  final Widget child;

  /// Indicator color
  final Color? color;

  /// Indicator shape
  final ShapeBorder? shape;

  /// Indicator height (for horizontal indicators)
  final double? height;

  /// Indicator width (for vertical indicators)
  final double? width;

  /// Padding around the indicator
  final EdgeInsetsGeometry padding;

  /// Animation duration
  final Duration duration;

  /// Animation curve
  final Curve curve;

  /// Whether to animate the indicator
  final bool animate;

  /// Indicator type
  final VooIndicatorType type;

  /// Indicator position for line type
  final VooIndicatorPosition position;

  const VooNavigationIndicator({
    super.key,
    required this.isSelected,
    required this.child,
    this.color,
    this.shape,
    this.height,
    this.width,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
    this.animate = true,
    this.type = VooIndicatorType.background,
    this.position = VooIndicatorPosition.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveColor = color ?? colorScheme.primaryContainer;

    switch (type) {
      case VooIndicatorType.background:
        return _buildBackgroundIndicator(effectiveColor);
      case VooIndicatorType.line:
        return _buildLineIndicator(effectiveColor);
      case VooIndicatorType.pill:
        return _buildPillIndicator(effectiveColor);
      case VooIndicatorType.custom:
        return _buildCustomIndicator(effectiveColor);
    }
  }

  Widget _buildBackgroundIndicator(Color color) {
    final indicator = Container(
      padding: padding,
      decoration: ShapeDecoration(
        color: isSelected ? color : Colors.transparent,
        shape:
            shape ??
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: child,
    );

    if (!animate) {
      return indicator;
    }

    return AnimatedContainer(
      duration: duration,
      curve: curve,
      padding: padding,
      decoration: ShapeDecoration(
        color: isSelected ? color : Colors.transparent,
        shape:
            shape ??
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: child,
    );
  }

  Widget _buildLineIndicator(Color color) {
    final Widget line = AnimatedContainer(
      duration: animate ? duration : Duration.zero,
      curve: curve,
      height:
          position == VooIndicatorPosition.bottom ||
              position == VooIndicatorPosition.top
          ? (height ?? 3)
          : null,
      width:
          position == VooIndicatorPosition.left ||
              position == VooIndicatorPosition.right
          ? (width ?? 3)
          : null,
      decoration: BoxDecoration(
        color: isSelected ? color : Colors.transparent,
        borderRadius: BorderRadius.circular(1.5),
      ),
    );

    final Widget content = child;

    switch (position) {
      case VooIndicatorPosition.bottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(padding: padding, child: content),
            line,
          ],
        );
      case VooIndicatorPosition.top:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            line,
            Padding(padding: padding, child: content),
          ],
        );
      case VooIndicatorPosition.left:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            line,
            Padding(padding: padding, child: content),
          ],
        );
      case VooIndicatorPosition.right:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(padding: padding, child: content),
            line,
          ],
        );
    }
  }

  Widget _buildPillIndicator(Color color) {
    final indicator = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: isSelected ? color : Colors.transparent,
        borderRadius: BorderRadius.circular(height ?? 20),
      ),
      child: child,
    );

    if (!animate) {
      return indicator;
    }

    return AnimatedContainer(
      duration: duration,
      curve: curve,
      padding: padding,
      decoration: BoxDecoration(
        color: isSelected ? color : Colors.transparent,
        borderRadius: BorderRadius.circular(height ?? 20),
      ),
      child: child,
    );
  }

  Widget _buildCustomIndicator(Color color) {
    // For custom indicators, just wrap the child with animation
    if (!animate || !isSelected) {
      return Padding(padding: padding, child: child);
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: isSelected ? 1 : 0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) => Transform.scale(
        scale: 1 + (value * 0.05),
        child: Padding(padding: padding, child: child),
      ),
      child: child,
    );
  }
}

/// Type of indicator to display
enum VooIndicatorType {
  /// Background fill indicator
  background,

  /// Line indicator (top, bottom, left, or right)
  line,

  /// Pill-shaped indicator
  pill,

  /// Custom indicator with scale animation
  custom,
}

/// Position for line indicators
enum VooIndicatorPosition {
  /// Line at the top
  top,

  /// Line at the bottom
  bottom,

  /// Line on the left
  left,

  /// Line on the right
  right,
}
