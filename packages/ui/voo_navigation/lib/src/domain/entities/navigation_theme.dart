import 'package:flutter/material.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Visual style presets for navigation components
enum VooNavigationPreset {
  /// Frosted glass effect with blur and translucent surfaces
  glassmorphism,

  /// Soft embossed/debossed effect with dual shadows
  neomorphism,

  /// Enhanced Material 3 with richer animations and polish
  material3Enhanced,

  /// Clean flat design with typography focus and minimal styling
  minimalModern,
}

/// Types of selection indicators for themed navigation items
enum VooThemeIndicatorStyle {
  /// Pill-shaped background indicator (Material 3 style)
  pill,

  /// Glowing indicator with shadow effect
  glow,

  /// Thin line/underline indicator
  line,

  /// Embossed pressed-in indicator (neomorphism)
  embossed,

  /// Full background highlight
  background,

  /// No visible indicator
  none,
}

/// Theme configuration for navigation visual styling
///
/// Use the factory constructors for preset themes:
/// ```dart
/// VooNavigationTheme.glassmorphism()
/// VooNavigationTheme.neomorphism()
/// VooNavigationTheme.material3Enhanced()
/// VooNavigationTheme.minimalModern()
/// ```
class VooNavigationTheme {
  /// Animation tokens for consistent timing
  static const _animationTokens = VooAnimationTokens();

  /// The visual style preset
  final VooNavigationPreset preset;

  // Surface properties
  /// Opacity of the navigation surface (0.0-1.0)
  final double surfaceOpacity;

  /// Blur sigma for glassmorphism effect (0 = no blur)
  final double blurSigma;

  /// Custom tint color for the surface (uses theme colors if null)
  final Color? surfaceTintColor;

  // Shadow properties (primarily for neomorphism)
  /// Offset for the light shadow (top-left)
  final Offset shadowLightOffset;

  /// Offset for the dark shadow (bottom-right)
  final Offset shadowDarkOffset;

  /// Blur radius for shadows
  final double shadowBlur;

  /// Opacity for light shadow (adjusted for dark mode internally)
  final double shadowLightOpacity;

  /// Opacity for dark shadow (adjusted for dark mode internally)
  final double shadowDarkOpacity;

  // Border properties
  /// Width of the border (0 = no border)
  final double borderWidth;

  /// Opacity of the border color (0.0-1.0)
  final double borderOpacity;

  /// Custom border color (uses theme colors if null)
  final Color? borderColor;

  // Indicator properties
  /// Type of selection indicator
  final VooThemeIndicatorStyle indicatorStyle;

  /// Blur radius for glow indicator (0 = no glow)
  final double indicatorGlowBlur;

  /// Custom indicator color (uses theme primary if null)
  final Color? indicatorColor;

  /// Border radius for indicator
  final double indicatorBorderRadius;

  // Animation properties
  /// Duration for state transitions
  final Duration animationDuration;

  /// Curve for state transitions
  final Curve animationCurve;

  // Component-specific properties
  /// Corner radius for navigation containers
  final double containerBorderRadius;

  /// Whether to show a subtle border on containers
  final bool showContainerBorder;

  /// Whether to apply elevation/shadow to containers
  final bool showContainerShadow;

  /// Creates a custom navigation theme
  const VooNavigationTheme({
    required this.preset,
    this.surfaceOpacity = 1.0,
    this.blurSigma = 0,
    this.surfaceTintColor,
    this.shadowLightOffset = Offset.zero,
    this.shadowDarkOffset = Offset.zero,
    this.shadowBlur = 0,
    this.shadowLightOpacity = 0,
    this.shadowDarkOpacity = 0,
    this.borderWidth = 0,
    this.borderOpacity = 0,
    this.borderColor,
    this.indicatorStyle = VooThemeIndicatorStyle.pill,
    this.indicatorGlowBlur = 0,
    this.indicatorColor,
    this.indicatorBorderRadius = 12,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeOutCubic,
    this.containerBorderRadius = 24,
    this.showContainerBorder = false,
    this.showContainerShadow = true,
  });

  /// Glassmorphism preset: Frosted glass with blur and translucent surfaces
  ///
  /// Visual characteristics:
  /// - Semi-transparent background (70-85% opacity)
  /// - Backdrop blur effect (10-20 sigma)
  /// - Subtle border with low opacity
  /// - Soft glow indicator
  /// - 200ms ease-in-out animations
  factory VooNavigationTheme.glassmorphism({
    double surfaceOpacity = 0.75,
    double blurSigma = 16,
    Color? surfaceTintColor,
    Color? indicatorColor,
    Duration? animationDuration,
    Curve? animationCurve,
  }) {
    return VooNavigationTheme(
      preset: VooNavigationPreset.glassmorphism,
      surfaceOpacity: surfaceOpacity,
      blurSigma: blurSigma,
      surfaceTintColor: surfaceTintColor,
      borderWidth: 1,
      borderOpacity: 0.15,
      indicatorStyle: VooThemeIndicatorStyle.glow,
      indicatorGlowBlur: 12,
      indicatorColor: indicatorColor,
      indicatorBorderRadius: 16,
      animationDuration: animationDuration ?? _animationTokens.durationNormal,
      animationCurve: animationCurve ?? Curves.easeInOut,
      containerBorderRadius: 24,
      showContainerBorder: true,
      showContainerShadow: true,
    );
  }

  /// Neomorphism preset: Soft embossed/debossed effect with dual shadows
  ///
  /// Visual characteristics:
  /// - Opaque surface matching parent background
  /// - Dual shadow system (light top-left, dark bottom-right)
  /// - No borders (shadows define edges)
  /// - Embossed pressed indicator
  /// - 150ms ease-out animations
  factory VooNavigationTheme.neomorphism({
    double shadowBlur = 12,
    double shadowOffset = 6,
    Color? surfaceTintColor,
    Color? indicatorColor,
    Duration? animationDuration,
    Curve? animationCurve,
  }) {
    return VooNavigationTheme(
      preset: VooNavigationPreset.neomorphism,
      surfaceOpacity: 1.0,
      blurSigma: 0,
      surfaceTintColor: surfaceTintColor,
      shadowLightOffset: Offset(-shadowOffset, -shadowOffset),
      shadowDarkOffset: Offset(shadowOffset, shadowOffset),
      shadowBlur: shadowBlur,
      shadowLightOpacity: 0.7,
      shadowDarkOpacity: 0.15,
      borderWidth: 0,
      borderOpacity: 0,
      indicatorStyle: VooThemeIndicatorStyle.embossed,
      indicatorGlowBlur: 0,
      indicatorColor: indicatorColor,
      indicatorBorderRadius: 16,
      animationDuration: animationDuration ?? _animationTokens.durationFast,
      animationCurve: animationCurve ?? Curves.easeOut,
      containerBorderRadius: 20,
      showContainerBorder: false,
      showContainerShadow: true,
    );
  }

  /// Material 3 Enhanced preset: Polished Material 3 with richer animations
  ///
  /// Visual characteristics:
  /// - Standard Material 3 surface colors
  /// - Elevation-based shadows
  /// - Animated pill indicator with subtle glow
  /// - 200ms ease-out-back animations
  factory VooNavigationTheme.material3Enhanced({
    Color? surfaceTintColor,
    Color? indicatorColor,
    Duration? animationDuration,
    Curve? animationCurve,
  }) {
    return VooNavigationTheme(
      preset: VooNavigationPreset.material3Enhanced,
      surfaceOpacity: 1.0,
      blurSigma: 0,
      surfaceTintColor: surfaceTintColor,
      shadowLightOffset: Offset.zero,
      shadowDarkOffset: const Offset(0, 4),
      shadowBlur: 12,
      shadowLightOpacity: 0,
      shadowDarkOpacity: 0.12,
      borderWidth: 0,
      borderOpacity: 0,
      indicatorStyle: VooThemeIndicatorStyle.pill,
      indicatorGlowBlur: 8,
      indicatorColor: indicatorColor,
      indicatorBorderRadius: 12,
      animationDuration: animationDuration ?? _animationTokens.durationNormal,
      animationCurve: animationCurve ?? Curves.easeOutBack,
      containerBorderRadius: 16,
      showContainerBorder: false,
      showContainerShadow: true,
    );
  }

  /// Minimal Modern preset: Clean flat design with typography focus
  ///
  /// Visual characteristics:
  /// - Flat opaque surface
  /// - No shadows
  /// - Thin line/underline indicator
  /// - 150ms linear animations
  factory VooNavigationTheme.minimalModern({
    Color? surfaceTintColor,
    Color? indicatorColor,
    double borderWidth = 1,
    Duration? animationDuration,
    Curve? animationCurve,
  }) {
    return VooNavigationTheme(
      preset: VooNavigationPreset.minimalModern,
      surfaceOpacity: 1.0,
      blurSigma: 0,
      surfaceTintColor: surfaceTintColor,
      shadowLightOffset: Offset.zero,
      shadowDarkOffset: Offset.zero,
      shadowBlur: 0,
      shadowLightOpacity: 0,
      shadowDarkOpacity: 0,
      borderWidth: borderWidth,
      borderOpacity: 0.2,
      indicatorStyle: VooThemeIndicatorStyle.line,
      indicatorGlowBlur: 0,
      indicatorColor: indicatorColor,
      indicatorBorderRadius: 4,
      animationDuration: animationDuration ?? _animationTokens.durationFast,
      animationCurve: animationCurve ?? Curves.linear,
      containerBorderRadius: 8,
      showContainerBorder: true,
      showContainerShadow: false,
    );
  }

  /// Creates a copy with the given fields replaced
  VooNavigationTheme copyWith({
    VooNavigationPreset? preset,
    double? surfaceOpacity,
    double? blurSigma,
    Color? surfaceTintColor,
    Offset? shadowLightOffset,
    Offset? shadowDarkOffset,
    double? shadowBlur,
    double? shadowLightOpacity,
    double? shadowDarkOpacity,
    double? borderWidth,
    double? borderOpacity,
    Color? borderColor,
    VooThemeIndicatorStyle? indicatorStyle,
    double? indicatorGlowBlur,
    Color? indicatorColor,
    double? indicatorBorderRadius,
    Duration? animationDuration,
    Curve? animationCurve,
    double? containerBorderRadius,
    bool? showContainerBorder,
    bool? showContainerShadow,
  }) {
    return VooNavigationTheme(
      preset: preset ?? this.preset,
      surfaceOpacity: surfaceOpacity ?? this.surfaceOpacity,
      blurSigma: blurSigma ?? this.blurSigma,
      surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
      shadowLightOffset: shadowLightOffset ?? this.shadowLightOffset,
      shadowDarkOffset: shadowDarkOffset ?? this.shadowDarkOffset,
      shadowBlur: shadowBlur ?? this.shadowBlur,
      shadowLightOpacity: shadowLightOpacity ?? this.shadowLightOpacity,
      shadowDarkOpacity: shadowDarkOpacity ?? this.shadowDarkOpacity,
      borderWidth: borderWidth ?? this.borderWidth,
      borderOpacity: borderOpacity ?? this.borderOpacity,
      borderColor: borderColor ?? this.borderColor,
      indicatorStyle: indicatorStyle ?? this.indicatorStyle,
      indicatorGlowBlur: indicatorGlowBlur ?? this.indicatorGlowBlur,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      indicatorBorderRadius:
          indicatorBorderRadius ?? this.indicatorBorderRadius,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      containerBorderRadius:
          containerBorderRadius ?? this.containerBorderRadius,
      showContainerBorder: showContainerBorder ?? this.showContainerBorder,
      showContainerShadow: showContainerShadow ?? this.showContainerShadow,
    );
  }

  /// Adjusts theme properties for screen size (responsive scaling)
  ///
  /// Scales blur, shadow, and radius values based on device type:
  /// - Mobile: 0.85x (subtler effects)
  /// - Tablet: 1.0x (baseline)
  /// - Desktop: 1.15x (more pronounced effects)
  VooNavigationTheme responsive({
    required double screenWidth,
  }) {
    // Calculate scale factor based on screen width
    final scaleFactor = _getScaleFactor(screenWidth);

    return copyWith(
      blurSigma: blurSigma * scaleFactor,
      shadowBlur: shadowBlur * scaleFactor,
      shadowLightOffset: shadowLightOffset * scaleFactor,
      shadowDarkOffset: shadowDarkOffset * scaleFactor,
      indicatorGlowBlur: indicatorGlowBlur * scaleFactor,
    );
  }

  /// Gets scale factor based on screen width
  double _getScaleFactor(double screenWidth) {
    if (screenWidth < 600) return 0.85; // Mobile
    if (screenWidth < 1024) return 1.0; // Tablet
    return 1.15; // Desktop
  }

  /// Resolves the surface color for the current theme
  Color resolveSurfaceColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (surfaceTintColor != null) {
      return surfaceTintColor!.withValues(alpha: surfaceOpacity);
    }

    final baseColor = isDark
        ? theme.colorScheme.surfaceContainerHigh
        : theme.colorScheme.surface;

    return baseColor.withValues(alpha: surfaceOpacity);
  }

  /// Resolves the border color for the current theme
  Color resolveBorderColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (borderColor != null) {
      return borderColor!.withValues(alpha: borderOpacity);
    }

    final baseColor = isDark ? Colors.white : Colors.black;
    return baseColor.withValues(alpha: borderOpacity);
  }

  /// Resolves the indicator color for the current theme
  Color resolveIndicatorColor(BuildContext context) {
    if (indicatorColor != null) return indicatorColor!;
    return Theme.of(context).colorScheme.primary;
  }

  /// Generates box shadows for the current theme
  List<BoxShadow> resolveShadows(BuildContext context) {
    if (!showContainerShadow) return [];

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    switch (preset) {
      case VooNavigationPreset.glassmorphism:
        return [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: isDark ? 0.3 : 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: isDark ? 0.15 : 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ];

      case VooNavigationPreset.neomorphism:
        // Dual shadow system for neomorphism
        final lightOpacity = isDark ? 0.05 : shadowLightOpacity;
        final darkOpacity = isDark ? 0.4 : shadowDarkOpacity;

        return [
          BoxShadow(
            color: Colors.white.withValues(alpha: lightOpacity),
            blurRadius: shadowBlur,
            offset: shadowLightOffset,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: darkOpacity),
            blurRadius: shadowBlur,
            offset: shadowDarkOffset,
          ),
        ];

      case VooNavigationPreset.material3Enhanced:
        return [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: isDark ? 0.25 : 0.12),
            blurRadius: shadowBlur,
            offset: shadowDarkOffset,
          ),
        ];

      case VooNavigationPreset.minimalModern:
        return []; // No shadows for minimal
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VooNavigationTheme &&
        other.preset == preset &&
        other.surfaceOpacity == surfaceOpacity &&
        other.blurSigma == blurSigma &&
        other.indicatorStyle == indicatorStyle &&
        other.animationDuration == animationDuration;
  }

  @override
  int get hashCode => Object.hash(
        preset,
        surfaceOpacity,
        blurSigma,
        indicatorStyle,
        animationDuration,
      );
}
