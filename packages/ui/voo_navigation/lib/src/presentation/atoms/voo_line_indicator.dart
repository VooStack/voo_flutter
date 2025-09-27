import 'package:flutter/material.dart';

/// Line indicator widget for navigation items
class VooLineIndicator extends StatelessWidget {
  /// Whether the indicator is selected
  final bool isSelected;

  /// Child widget to wrap
  final Widget child;

  /// Indicator color
  final Color color;

  /// Indicator height (for horizontal indicators)
  final double? height;

  /// Indicator width (for vertical indicators)
  final double? width;

  /// Padding around the child
  final EdgeInsetsGeometry padding;

  /// Animation duration
  final Duration duration;

  /// Animation curve
  final Curve curve;

  /// Whether to animate the indicator
  final bool animate;

  /// Position of the line indicator
  final VooLineIndicatorPosition position;

  const VooLineIndicator({
    super.key,
    required this.isSelected,
    required this.child,
    required this.color,
    this.height,
    this.width,
    required this.padding,
    required this.duration,
    required this.curve,
    required this.animate,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    final line = AnimatedContainer(
      duration: animate ? duration : Duration.zero,
      curve: curve,
      height:
          position == VooLineIndicatorPosition.bottom ||
              position == VooLineIndicatorPosition.top
          ? (height ?? 3)
          : null,
      width:
          position == VooLineIndicatorPosition.left ||
              position == VooLineIndicatorPosition.right
          ? (width ?? 3)
          : null,
      decoration: BoxDecoration(
        color: isSelected ? color : Colors.transparent,
        borderRadius: BorderRadius.circular(1.5),
      ),
    );

    final content = Padding(padding: padding, child: child);

    switch (position) {
      case VooLineIndicatorPosition.bottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [content, line],
        );
      case VooLineIndicatorPosition.top:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [line, content],
        );
      case VooLineIndicatorPosition.left:
        return Row(mainAxisSize: MainAxisSize.min, children: [line, content]);
      case VooLineIndicatorPosition.right:
        return Row(mainAxisSize: MainAxisSize.min, children: [content, line]);
    }
  }
}

/// Position for line indicators
enum VooLineIndicatorPosition {
  /// Line at the top
  top,

  /// Line at the bottom
  bottom,

  /// Line on the left
  left,

  /// Line on the right
  right,
}
