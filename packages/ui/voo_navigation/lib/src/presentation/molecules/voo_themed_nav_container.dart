import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_theme.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// A themed container for navigation components
///
/// Automatically applies the appropriate visual style based on the theme preset:
/// - Glassmorphism: Frosted glass with blur
/// - Neomorphism: Soft shadows with embossed effect
/// - Material 3 Enhanced: Polished Material with rich colors
/// - Minimal Modern: Clean flat design
///
/// ```dart
/// VooThemedNavContainer(
///   theme: config.effectiveTheme,
///   child: NavigationContent(),
/// )
/// ```
class VooThemedNavContainer extends StatelessWidget {
  /// The navigation theme configuration
  final VooNavigationTheme theme;

  /// The content to display inside the container
  final Widget child;

  /// Border radius for the container
  final BorderRadius? borderRadius;

  /// Padding inside the container
  final EdgeInsetsGeometry? padding;

  /// Margin outside the container
  final EdgeInsetsGeometry? margin;

  /// Fixed width (optional)
  final double? width;

  /// Fixed height (optional)
  final double? height;

  /// Whether to clip content to border radius
  final bool clipContent;

  const VooThemedNavContainer({
    super.key,
    required this.theme,
    required this.child,
    this.borderRadius,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.clipContent = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ??
        BorderRadius.circular(theme.containerBorderRadius);

    return switch (theme.preset) {
      VooNavigationPreset.glassmorphism =>
        _buildGlassmorphism(context, effectiveBorderRadius),
      VooNavigationPreset.neomorphism =>
        _buildNeomorphism(context, effectiveBorderRadius),
      VooNavigationPreset.material3Enhanced =>
        _buildMaterial3Enhanced(context, effectiveBorderRadius),
      VooNavigationPreset.minimalModern =>
        _buildMinimalModern(context, effectiveBorderRadius),
    };
  }

  Widget _buildGlassmorphism(BuildContext context, BorderRadius radius) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        borderRadius: radius,
        border: theme.showContainerBorder
            ? Border.all(
                color: borderColor.withValues(alpha: theme.borderOpacity),
                width: theme.borderWidth,
              )
            : null,
        boxShadow: theme.resolveShadows(context),
      ),
      child: child,
    );

    // Apply blur
    if (theme.blurSigma > 0) {
      content = ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: theme.blurSigma,
            sigmaY: theme.blurSigma,
          ),
          child: content,
        ),
      );
    } else if (clipContent) {
      content = ClipRRect(borderRadius: radius, child: content);
    }

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    return content;
  }

  Widget _buildNeomorphism(BuildContext context, BorderRadius radius) {
    final themeData = Theme.of(context);
    final isDark = themeData.brightness == Brightness.dark;

    final surfaceColor = theme.surfaceTintColor ?? themeData.colorScheme.surface;

    // Neomorphism shadow colors
    final lightShadowOpacity = isDark ? 0.05 : theme.shadowLightOpacity;
    final darkShadowOpacity = isDark ? 0.4 : theme.shadowDarkOpacity;

    Widget content = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: radius,
        boxShadow: theme.showContainerShadow
            ? [
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
              ]
            : null,
      ),
      child: child,
    );

    if (clipContent) {
      content = ClipRRect(borderRadius: radius, child: content);
    }

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    return content;
  }

  Widget _buildMaterial3Enhanced(BuildContext context, BorderRadius radius) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final surfaceColor = theme.surfaceTintColor ??
        (isDark
            ? colorScheme.surfaceContainerHigh
            : colorScheme.surfaceContainer);

    Widget content = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: radius,
        boxShadow: theme.showContainerShadow
            ? theme.resolveShadows(context)
            : null,
      ),
      child: child,
    );

    if (clipContent) {
      content = ClipRRect(borderRadius: radius, child: content);
    }

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    return content;
  }

  Widget _buildMinimalModern(BuildContext context, BorderRadius radius) {
    final colorScheme = Theme.of(context).colorScheme;

    final surfaceColor = theme.surfaceTintColor ?? colorScheme.surface;
    final borderColor = theme.borderColor ?? colorScheme.outlineVariant;

    Widget content = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: radius,
        border: theme.showContainerBorder
            ? Border.all(
                color: borderColor.withValues(alpha: theme.borderOpacity),
                width: theme.borderWidth,
              )
            : null,
        // No shadows for minimal
      ),
      child: child,
    );

    if (clipContent) {
      content = ClipRRect(borderRadius: radius, child: content);
    }

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    return content;
  }
}

/// A themed bottom navigation bar container
///
/// Specialized container for bottom navigation with floating support
class VooThemedBottomNavContainer extends StatelessWidget {
  /// The navigation theme configuration
  final VooNavigationTheme theme;

  /// The navigation content
  final Widget child;

  /// Height of the navigation bar
  final double height;

  /// Whether this is a floating navigation bar
  final bool isFloating;

  /// Horizontal margin (for floating style)
  final double? horizontalMargin;

  /// Bottom margin (for floating style)
  final double? bottomMargin;

  const VooThemedBottomNavContainer({
    super.key,
    required this.theme,
    required this.child,
    this.height = 72,
    this.isFloating = false,
    this.horizontalMargin,
    this.bottomMargin,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = context.vooSpacing;
    final effectiveHMargin = horizontalMargin ?? spacing.md;
    final effectiveBMargin = bottomMargin ?? spacing.lg;

    if (isFloating) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          effectiveHMargin,
          0,
          effectiveHMargin,
          effectiveBMargin,
        ),
        child: VooThemedNavContainer(
          theme: theme,
          height: height,
          borderRadius: BorderRadius.circular(theme.containerBorderRadius),
          child: child,
        ),
      );
    }

    // Non-floating: full width with optional top border radius
    return VooThemedNavContainer(
      theme: theme,
      height: height,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(theme.containerBorderRadius * 0.5),
      ),
      child: child,
    );
  }
}

/// A themed navigation rail container
///
/// Specialized container for navigation rail with proper sizing
class VooThemedRailContainer extends StatelessWidget {
  /// The navigation theme configuration
  final VooNavigationTheme theme;

  /// The rail content
  final Widget child;

  /// Width of the rail
  final double width;

  /// Whether the rail is extended (wider with labels)
  final bool isExtended;

  /// Margin around the rail
  final double? margin;

  const VooThemedRailContainer({
    super.key,
    required this.theme,
    required this.child,
    this.width = 80,
    this.isExtended = false,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = context.vooSpacing;
    final effectiveMargin = margin ?? spacing.sm;

    return Padding(
      padding: EdgeInsets.all(effectiveMargin),
      child: VooThemedNavContainer(
        theme: theme,
        width: width,
        borderRadius: BorderRadius.circular(theme.containerBorderRadius),
        child: child,
      ),
    );
  }
}

/// A themed navigation drawer container
///
/// Specialized container for navigation drawer
class VooThemedDrawerContainer extends StatelessWidget {
  /// The navigation theme configuration
  final VooNavigationTheme theme;

  /// The drawer content
  final Widget child;

  /// Width of the drawer
  final double width;

  const VooThemedDrawerContainer({
    super.key,
    required this.theme,
    required this.child,
    this.width = 280,
  });

  @override
  Widget build(BuildContext context) {
    // Drawer typically doesn't have outer margin or rounded corners
    // on the left edge
    return VooThemedNavContainer(
      theme: theme,
      width: width,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(theme.containerBorderRadius),
        bottomRight: Radius.circular(theme.containerBorderRadius),
      ),
      child: child,
    );
  }
}
