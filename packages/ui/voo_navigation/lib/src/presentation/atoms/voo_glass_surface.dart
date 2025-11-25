import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_theme.dart';

/// A frosted glass surface widget for glassmorphism effects
///
/// Creates a translucent surface with backdrop blur, subtle borders,
/// and soft shadows for a modern glass-like appearance.
///
/// ```dart
/// VooGlassSurface(
///   theme: VooNavigationTheme.glassmorphism(),
///   borderRadius: BorderRadius.circular(24),
///   child: YourContent(),
/// )
/// ```
class VooGlassSurface extends StatelessWidget {
  /// The navigation theme configuration
  final VooNavigationTheme theme;

  /// The content to display on top of the glass surface
  final Widget child;

  /// Border radius for the surface
  final BorderRadius borderRadius;

  /// Padding inside the surface
  final EdgeInsetsGeometry? padding;

  /// Fixed width (optional)
  final double? width;

  /// Fixed height (optional)
  final double? height;

  /// Additional margin around the surface
  final EdgeInsetsGeometry? margin;

  /// Whether to clip the content to the border radius
  final bool clipContent;

  const VooGlassSurface({
    super.key,
    required this.theme,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.padding,
    this.width,
    this.height,
    this.margin,
    this.clipContent = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Resolve colors
    final surfaceColor = theme.surfaceTintColor ??
        (isDark
            ? colorScheme.surfaceContainerHigh
            : colorScheme.surface);

    final borderColor = theme.borderColor ??
        (isDark ? Colors.white : Colors.black);

    Widget content = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: surfaceColor.withValues(alpha: theme.surfaceOpacity),
        borderRadius: borderRadius,
        border: theme.borderWidth > 0
            ? Border.all(
                color: borderColor.withValues(alpha: theme.borderOpacity),
                width: theme.borderWidth,
              )
            : null,
        boxShadow: theme.resolveShadows(context),
      ),
      child: child,
    );

    // Apply blur if sigma > 0
    if (theme.blurSigma > 0) {
      content = ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: theme.blurSigma,
            sigmaY: theme.blurSigma,
          ),
          child: content,
        ),
      );
    } else if (clipContent) {
      content = ClipRRect(
        borderRadius: borderRadius,
        child: content,
      );
    }

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    return content;
  }
}

/// A glass surface with hover animation support
///
/// Animates opacity and glow on hover for interactive elements
class VooGlassSurfaceInteractive extends StatefulWidget {
  /// The navigation theme configuration
  final VooNavigationTheme theme;

  /// The content to display
  final Widget child;

  /// Border radius for the surface
  final BorderRadius borderRadius;

  /// Padding inside the surface
  final EdgeInsetsGeometry? padding;

  /// Whether the surface is currently selected
  final bool isSelected;

  /// Callback when the surface is tapped
  final VoidCallback? onTap;

  /// Whether to show a glow effect when selected
  final bool showGlowOnSelected;

  /// Custom glow color (uses theme primary if null)
  final Color? glowColor;

  const VooGlassSurfaceInteractive({
    super.key,
    required this.theme,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.padding,
    this.isSelected = false,
    this.onTap,
    this.showGlowOnSelected = true,
    this.glowColor,
  });

  @override
  State<VooGlassSurfaceInteractive> createState() =>
      _VooGlassSurfaceInteractiveState();
}

class _VooGlassSurfaceInteractiveState
    extends State<VooGlassSurfaceInteractive> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Calculate opacity based on state
    final baseOpacity = widget.theme.surfaceOpacity;
    final effectiveOpacity = _isHovered
        ? (baseOpacity + 0.1).clamp(0.0, 1.0)
        : widget.isSelected
            ? (baseOpacity + 0.05).clamp(0.0, 1.0)
            : baseOpacity;

    final surfaceColor = widget.theme.surfaceTintColor ??
        (isDark
            ? colorScheme.surfaceContainerHigh
            : colorScheme.surface);

    final glowColor = widget.glowColor ?? colorScheme.primary;

    final borderColor = widget.theme.borderColor ??
        (isDark ? Colors.white : Colors.black);

    // Build shadows with optional glow
    final shadows = <BoxShadow>[
      ...widget.theme.resolveShadows(context),
      if (widget.isSelected && widget.showGlowOnSelected)
        BoxShadow(
          color: glowColor.withValues(alpha: 0.2),
          blurRadius: widget.theme.indicatorGlowBlur,
          spreadRadius: 0,
        ),
    ];

    Widget content = AnimatedContainer(
      duration: widget.theme.animationDuration,
      curve: widget.theme.animationCurve,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: surfaceColor.withValues(alpha: effectiveOpacity),
        borderRadius: widget.borderRadius,
        border: widget.theme.borderWidth > 0
            ? Border.all(
                color: borderColor.withValues(
                  alpha: widget.isSelected
                      ? widget.theme.borderOpacity * 1.5
                      : widget.theme.borderOpacity,
                ),
                width: widget.theme.borderWidth,
              )
            : null,
        boxShadow: shadows,
      ),
      child: widget.child,
    );

    // Apply blur
    if (widget.theme.blurSigma > 0) {
      content = ClipRRect(
        borderRadius: widget.borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: widget.theme.blurSigma,
            sigmaY: widget.theme.blurSigma,
          ),
          child: content,
        ),
      );
    } else {
      content = ClipRRect(
        borderRadius: widget.borderRadius,
        child: content,
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      ),
    );
  }
}
