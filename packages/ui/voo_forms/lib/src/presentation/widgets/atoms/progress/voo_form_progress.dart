import 'package:flutter/material.dart';

/// Atom component for form progress indicator
/// Simple, reusable progress indicator for forms
/// Follows KISS principle and atomic design
class VooFormProgress extends StatelessWidget {
  /// Whether to show indeterminate progress
  final bool isIndeterminate;

  /// Progress value (0.0 to 1.0) for determinate progress
  final double? value;

  /// Height of the progress indicator
  final double height;

  /// Background color for the progress track
  final Color? backgroundColor;

  /// Color for the progress indicator
  final Color? valueColor;

  /// Border radius for the progress indicator
  final BorderRadius? borderRadius;

  /// Whether to animate the value changes
  final bool animate;

  const VooFormProgress({
    super.key,
    this.isIndeterminate = true,
    this.value,
    this.height = 4.0,
    this.backgroundColor,
    this.valueColor,
    this.borderRadius,
    this.animate = true,
  }) : assert(
          isIndeterminate || (value != null && value >= 0.0 && value <= 1.0),
          'Value must be between 0.0 and 1.0 for determinate progress',
        );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor = backgroundColor ??
        theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);
    final effectiveValueColor = valueColor ?? theme.colorScheme.primary;

    final progressIndicator = LinearProgressIndicator(
      value: isIndeterminate ? null : value,
      backgroundColor: effectiveBackgroundColor,
      valueColor: animate
          ? AlwaysStoppedAnimation<Color>(effectiveValueColor)
          : AlwaysStoppedAnimation<Color>(effectiveValueColor),
      minHeight: height,
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: progressIndicator,
      );
    }

    return progressIndicator;
  }
}

/// Circular progress variant for forms
class VooFormCircularProgress extends StatelessWidget {
  /// Size of the circular progress indicator
  final double size;

  /// Stroke width of the circular progress
  final double strokeWidth;

  /// Progress value (0.0 to 1.0) for determinate progress
  final double? value;

  /// Color for the progress indicator
  final Color? valueColor;

  const VooFormCircularProgress({
    super.key,
    this.size = 24.0,
    this.strokeWidth = 2.0,
    this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveValueColor = valueColor ?? theme.colorScheme.primary;

    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        value: value,
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(effectiveValueColor),
      ),
    );
  }
}