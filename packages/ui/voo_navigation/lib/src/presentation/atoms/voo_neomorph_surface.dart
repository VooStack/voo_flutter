import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_theme.dart';

/// A neomorphism surface widget with soft embossed/debossed effects
///
/// Creates a soft, extruded surface with dual shadows (light and dark)
/// that gives the appearance of being raised from or pressed into
/// the background.
///
/// ```dart
/// VooNeomorphSurface(
///   theme: VooNavigationTheme.neomorphism(),
///   borderRadius: BorderRadius.circular(20),
///   child: YourContent(),
/// )
/// ```
class VooNeomorphSurface extends StatelessWidget {
  /// The navigation theme configuration
  final VooNavigationTheme theme;

  /// The content to display on the surface
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

  /// Whether the surface appears pressed in (concave) instead of raised (convex)
  final bool isPressed;

  const VooNeomorphSurface({
    super.key,
    required this.theme,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.padding,
    this.width,
    this.height,
    this.margin,
    this.isPressed = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isDark = themeData.brightness == Brightness.dark;

    // Get base surface color
    final surfaceColor = theme.surfaceTintColor ??
        themeData.colorScheme.surface;

    // Calculate shadow colors with dark mode awareness
    final lightShadowOpacity = isDark ? 0.05 : theme.shadowLightOpacity;
    final darkShadowOpacity = isDark ? 0.4 : theme.shadowDarkOpacity;

    // Build shadows based on pressed state
    List<BoxShadow> shadows;
    if (isPressed) {
      // Inset-like effect: reverse shadow positions for pressed look
      shadows = [
        BoxShadow(
          color: Colors.black.withValues(alpha: darkShadowOpacity),
          blurRadius: theme.shadowBlur * 0.5,
          offset: theme.shadowLightOffset * 0.5, // Reversed position
          spreadRadius: -2,
        ),
        BoxShadow(
          color: Colors.white.withValues(alpha: lightShadowOpacity * 0.5),
          blurRadius: theme.shadowBlur * 0.5,
          offset: theme.shadowDarkOffset * 0.5, // Reversed position
          spreadRadius: -2,
        ),
      ];
    } else {
      // Raised effect: standard neomorphism shadows
      shadows = [
        BoxShadow(
          color: Colors.white.withValues(alpha: lightShadowOpacity),
          blurRadius: theme.shadowBlur,
          offset: theme.shadowLightOffset,
          spreadRadius: isDark ? 0 : 1,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: darkShadowOpacity),
          blurRadius: theme.shadowBlur,
          offset: theme.shadowDarkOffset,
        ),
      ];
    }

    Widget content = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: borderRadius,
        boxShadow: shadows,
      ),
      child: child,
    );

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    return content;
  }
}

/// An interactive neomorphism surface with press animation
///
/// Animates between raised and pressed states on tap
class VooNeomorphSurfaceInteractive extends StatefulWidget {
  /// The navigation theme configuration
  final VooNavigationTheme theme;

  /// The content to display
  final Widget child;

  /// Border radius for the surface
  final BorderRadius borderRadius;

  /// Padding inside the surface
  final EdgeInsetsGeometry? padding;

  /// Whether the surface is currently selected (pressed in)
  final bool isSelected;

  /// Callback when the surface is tapped
  final VoidCallback? onTap;

  const VooNeomorphSurfaceInteractive({
    super.key,
    required this.theme,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.padding,
    this.isSelected = false,
    this.onTap,
  });

  @override
  State<VooNeomorphSurfaceInteractive> createState() =>
      _VooNeomorphSurfaceInteractiveState();
}

class _VooNeomorphSurfaceInteractiveState
    extends State<VooNeomorphSurfaceInteractive> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isDark = themeData.brightness == Brightness.dark;

    final surfaceColor = widget.theme.surfaceTintColor ??
        themeData.colorScheme.surface;

    // Determine if we should show pressed state
    final showPressedState = _isPressed || widget.isSelected;

    // Calculate shadow colors
    final lightShadowOpacity = isDark ? 0.05 : widget.theme.shadowLightOpacity;
    final darkShadowOpacity = isDark ? 0.4 : widget.theme.shadowDarkOpacity;

    // Build animated shadows
    List<BoxShadow> shadows;
    if (showPressedState) {
      shadows = [
        BoxShadow(
          color: Colors.black.withValues(alpha: darkShadowOpacity * 0.6),
          blurRadius: widget.theme.shadowBlur * 0.4,
          offset: widget.theme.shadowLightOffset * 0.3,
          spreadRadius: -1,
        ),
        BoxShadow(
          color: Colors.white.withValues(alpha: lightShadowOpacity * 0.3),
          blurRadius: widget.theme.shadowBlur * 0.4,
          offset: widget.theme.shadowDarkOffset * 0.3,
          spreadRadius: -1,
        ),
      ];
    } else {
      shadows = [
        BoxShadow(
          color: Colors.white.withValues(alpha: lightShadowOpacity),
          blurRadius: widget.theme.shadowBlur,
          offset: widget.theme.shadowLightOffset,
          spreadRadius: isDark ? 0 : 1,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: darkShadowOpacity),
          blurRadius: widget.theme.shadowBlur,
          offset: widget.theme.shadowDarkOffset,
        ),
      ];
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: widget.theme.animationDuration,
        curve: widget.theme.animationCurve,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: widget.borderRadius,
          boxShadow: shadows,
        ),
        child: widget.child,
      ),
    );
  }
}

/// A neomorphism inset container for pressed-in effects
///
/// Creates a container that appears to be pressed into the surface,
/// useful for input fields, selected items, or progress tracks
class VooNeomorphInset extends StatelessWidget {
  /// The navigation theme configuration
  final VooNavigationTheme theme;

  /// The content to display
  final Widget child;

  /// Border radius for the inset
  final BorderRadius borderRadius;

  /// Padding inside the inset
  final EdgeInsetsGeometry? padding;

  /// Fixed width (optional)
  final double? width;

  /// Fixed height (optional)
  final double? height;

  /// Depth of the inset effect (0.0-1.0)
  final double depth;

  const VooNeomorphInset({
    super.key,
    required this.theme,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.padding,
    this.width,
    this.height,
    this.depth = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isDark = themeData.brightness == Brightness.dark;

    final surfaceColor = theme.surfaceTintColor ??
        themeData.colorScheme.surface;

    // Slightly darker/lighter background for inset
    final insetColor = isDark
        ? Color.lerp(surfaceColor, Colors.black, depth * 0.1)!
        : Color.lerp(surfaceColor, Colors.black, depth * 0.05)!;

    // Inner shadows for inset effect
    final innerShadowOpacity = depth * (isDark ? 0.3 : 0.15);

    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: insetColor,
        borderRadius: borderRadius,
        boxShadow: [
          // Inner shadow simulation using a gradient overlay
          BoxShadow(
            color: Colors.black.withValues(alpha: innerShadowOpacity),
            blurRadius: theme.shadowBlur * 0.5 * depth,
            offset: Offset(
              theme.shadowLightOffset.dx * 0.3 * depth,
              theme.shadowLightOffset.dy * 0.3 * depth,
            ),
            spreadRadius: -2,
          ),
        ],
      ),
      child: child,
    );
  }
}
