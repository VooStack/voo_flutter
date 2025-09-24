import 'package:flutter/material.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Navigation label with text scaling and truncation
class VooNavigationLabel extends StatelessWidget {
  /// The label text
  final String label;

  /// Whether the label is selected
  final bool isSelected;

  /// Text style for the label
  final TextStyle? style;

  /// Text style when selected
  final TextStyle? selectedStyle;

  /// Text color
  final Color? color;

  /// Text color when selected
  final Color? selectedColor;

  /// Maximum lines for the label
  final int maxLines;

  /// Text overflow behavior
  final TextOverflow overflow;

  /// Text alignment
  final TextAlign textAlign;

  /// Animation duration for style transitions
  final Duration? duration;

  /// Animation curve
  final Curve curve;

  /// Whether to animate style changes
  final bool animate;

  /// Optional semantics label
  final String? semanticsLabel;

  /// Whether to scale text based on accessibility settings
  final bool scaleText;

  const VooNavigationLabel({
    super.key,
    required this.label,
    this.isSelected = false,
    this.style,
    this.selectedStyle,
    this.color,
    this.selectedColor,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign = TextAlign.center,
    this.duration,
    this.curve = Curves.easeInOut,
    this.animate = true,
    this.semanticsLabel,
    this.scaleText = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final defaultStyle = theme.textTheme.labelMedium ?? const TextStyle();
    final effectiveDuration = duration ?? context.vooAnimation.durationFast;

    // Determine effective styles
    final baseStyle = isSelected
        ? (selectedStyle ?? defaultStyle.copyWith(fontWeight: FontWeight.w600))
        : (style ?? defaultStyle);

    // Determine effective color
    final effectiveColor = isSelected
        ? (selectedColor ?? colorScheme.primary)
        : (color ?? colorScheme.onSurfaceVariant);

    // Apply color to style
    final effectiveStyle = baseStyle.copyWith(color: effectiveColor);

    // Build text widget
    final textWidget = Text(
      label,
      style: effectiveStyle,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      semanticsLabel: semanticsLabel ?? label,
      textScaler: scaleText
          ? MediaQuery.textScalerOf(context)
          : TextScaler.noScaling,
    );

    // Return with or without animation
    if (!animate) {
      return textWidget;
    }

    return AnimatedDefaultTextStyle(
      duration: effectiveDuration,
      curve: curve,
      style: effectiveStyle,
      child: Text(
        label,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
        semanticsLabel: semanticsLabel ?? label,
        textScaler: scaleText
            ? MediaQuery.textScalerOf(context)
            : TextScaler.noScaling,
      ),
    );
  }
}
