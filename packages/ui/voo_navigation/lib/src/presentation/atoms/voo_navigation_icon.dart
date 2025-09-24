import 'package:flutter/material.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Animated navigation icon with selected state transitions
class VooNavigationIcon extends StatelessWidget {
  /// The icon to display
  final IconData icon;

  /// The icon to display when selected (optional)
  final IconData? selectedIcon;

  /// Whether the icon is selected
  final bool isSelected;

  /// Icon size
  final double size;

  /// Icon color
  final Color? color;

  /// Icon color when selected
  final Color? selectedColor;

  /// Animation duration
  final Duration? duration;

  /// Animation curve
  final Curve curve;

  /// Whether to animate icon changes
  final bool animate;

  /// Optional semantics label
  final String? semanticLabel;

  const VooNavigationIcon({
    super.key,
    required this.icon,
    this.selectedIcon,
    this.isSelected = false,
    this.size = 24.0,
    this.color,
    this.selectedColor,
    this.duration,
    this.curve = Curves.easeInOut,
    this.animate = true,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveDuration = duration ?? context.vooAnimation.durationFast;

    final effectiveIcon = isSelected && selectedIcon != null
        ? selectedIcon!
        : icon;
    final effectiveColor = isSelected
        ? (selectedColor ?? colorScheme.primary)
        : (color ?? colorScheme.onSurfaceVariant);

    if (!animate) {
      return Icon(
        effectiveIcon,
        size: size,
        color: effectiveColor,
        semanticLabel: semanticLabel,
      );
    }

    return AnimatedSwitcher(
      duration: effectiveDuration,
      switchInCurve: curve,
      switchOutCurve: curve,
      transitionBuilder: (child, animation) => ScaleTransition(
        scale: animation,
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: Icon(
        effectiveIcon,
        key: ValueKey('${effectiveIcon.codePoint}_$isSelected'),
        size: size,
        color: effectiveColor,
        semanticLabel: semanticLabel,
      ),
    );
  }
}
