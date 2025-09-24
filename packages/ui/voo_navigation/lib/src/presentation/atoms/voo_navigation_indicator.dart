import 'package:flutter/material.dart';
import 'package:voo_tokens/voo_tokens.dart';
import 'package:voo_navigation/src/presentation/atoms/voo_background_indicator.dart';
import 'package:voo_navigation/src/presentation/atoms/voo_custom_indicator.dart';
import 'package:voo_navigation/src/presentation/atoms/voo_line_indicator.dart';
import 'package:voo_navigation/src/presentation/atoms/voo_pill_indicator.dart';

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
  final EdgeInsetsGeometry? padding;

  /// Animation duration
  final Duration? duration;

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
    this.padding,
    this.duration,
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
    final effectivePadding = padding ?? EdgeInsets.symmetric(
      horizontal: context.vooSpacing.sm + context.vooSpacing.xs,
      vertical: context.vooSpacing.xs,
    );
    final effectiveDuration = duration ?? context.vooAnimation.durationFast;

    switch (type) {
      case VooIndicatorType.background:
        return VooBackgroundIndicator(
          isSelected: isSelected,
          color: effectiveColor,
          shape: shape,
          padding: effectivePadding,
          duration: effectiveDuration,
          curve: curve,
          animate: animate,
          child: child,
        );
      case VooIndicatorType.line:
        return VooLineIndicator(
          isSelected: isSelected,
          color: effectiveColor,
          height: height,
          width: width,
          padding: effectivePadding,
          duration: effectiveDuration,
          curve: curve,
          animate: animate,
          position: _mapToLineIndicatorPosition(position),
          child: child,
        );
      case VooIndicatorType.pill:
        return VooPillIndicator(
          isSelected: isSelected,
          color: effectiveColor,
          borderRadius: height ?? 20,
          padding: effectivePadding,
          duration: effectiveDuration,
          curve: curve,
          animate: animate,
          child: child,
        );
      case VooIndicatorType.custom:
        return VooCustomIndicator(
          isSelected: isSelected,
          padding: effectivePadding,
          duration: effectiveDuration,
          curve: curve,
          animate: animate,
          child: child,
        );
    }
  }

  VooLineIndicatorPosition _mapToLineIndicatorPosition(
      VooIndicatorPosition position) {
    switch (position) {
      case VooIndicatorPosition.top:
        return VooLineIndicatorPosition.top;
      case VooIndicatorPosition.bottom:
        return VooLineIndicatorPosition.bottom;
      case VooIndicatorPosition.left:
        return VooLineIndicatorPosition.left;
      case VooIndicatorPosition.right:
        return VooLineIndicatorPosition.right;
    }
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
