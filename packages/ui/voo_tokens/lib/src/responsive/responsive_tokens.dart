import 'package:equatable/equatable.dart';
import 'package:voo_tokens/src/tokens/voo_animation_tokens.dart';
import 'package:voo_tokens/src/tokens/voo_component_radius_tokens.dart';
import 'package:voo_tokens/src/tokens/voo_elevation_tokens.dart';
import 'package:voo_tokens/src/tokens/voo_gap_tokens.dart';
import 'package:voo_tokens/src/tokens/voo_margin_tokens.dart';
import 'package:voo_tokens/src/tokens/voo_padding_tokens.dart';
import 'package:voo_tokens/src/tokens/voo_radius_tokens.dart';
import 'package:voo_tokens/src/tokens/voo_size_tokens.dart';
import 'package:voo_tokens/src/tokens/voo_spacing_tokens.dart';
import 'package:voo_tokens/src/tokens/voo_typography_tokens.dart';

class ResponsiveTokens extends Equatable {
  final double scaleFactor;
  final VooSpacingTokens spacing;
  final VooTypographyTokens typography;
  final VooRadiusTokens radius;
  final VooElevationTokens elevation;
  final VooAnimationTokens animation;
  final VooMarginTokens margin;
  final VooPaddingTokens padding;
  final VooGapTokens gap;
  final VooComponentRadiusTokens componentRadius;
  final VooSizeTokens size;

  ResponsiveTokens({
    this.scaleFactor = 1.0,
    VooSpacingTokens? spacing,
    VooTypographyTokens? typography,
    VooRadiusTokens? radius,
    VooElevationTokens? elevation,
    VooAnimationTokens? animation,
    VooMarginTokens? margin,
    VooPaddingTokens? padding,
    VooGapTokens? gap,
    VooComponentRadiusTokens? componentRadius,
    VooSizeTokens? size,
  }) : spacing = spacing ?? const VooSpacingTokens(),
       typography = typography ?? const VooTypographyTokens(),
       radius = radius ?? VooRadiusTokens(),
       elevation = elevation ?? const VooElevationTokens(),
       animation = animation ?? const VooAnimationTokens(),
       margin = margin ?? const VooMarginTokens(),
       padding = padding ?? const VooPaddingTokens(),
       gap = gap ?? const VooGapTokens(),
       componentRadius = componentRadius ?? const VooComponentRadiusTokens(),
       size = size ?? const VooSizeTokens();

  factory ResponsiveTokens.forScreenWidth(double screenWidth, {bool isDark = false}) {
    final scaleFactor = _calculateScaleFactor(screenWidth);

    return ResponsiveTokens(
      scaleFactor: scaleFactor,
      spacing: const VooSpacingTokens().scale(scaleFactor),
      typography: const VooTypographyTokens().scale(scaleFactor),
      radius: VooRadiusTokens().scale(scaleFactor),
      elevation: VooElevationTokens(isDarkMode: isDark),
      animation: const VooAnimationTokens(),
      margin: const VooMarginTokens().scale(scaleFactor),
      padding: const VooPaddingTokens().scale(scaleFactor),
      gap: const VooGapTokens().scale(scaleFactor),
      componentRadius: const VooComponentRadiusTokens().scale(scaleFactor),
      size: const VooSizeTokens().scale(scaleFactor),
    );
  }

  static double _calculateScaleFactor(double screenWidth) {
    if (screenWidth < 360) {
      return 0.85;
    } else if (screenWidth < 414) {
      return 0.9;
    } else if (screenWidth < 600) {
      return 1.0;
    } else if (screenWidth < 768) {
      return 1.1;
    } else if (screenWidth < 1024) {
      return 1.15;
    } else if (screenWidth < 1440) {
      return 1.2;
    } else {
      return 1.25;
    }
  }

  ResponsiveTokens scale(double factor) => ResponsiveTokens(
    scaleFactor: factor,
    spacing: spacing.scale(factor),
    typography: typography.scale(factor),
    radius: radius.scale(factor),
    elevation: elevation,
    animation: animation,
    margin: margin.scale(factor),
    padding: padding.scale(factor),
    gap: gap.scale(factor),
    componentRadius: componentRadius.scale(factor),
    size: size.scale(factor),
  );

  ResponsiveTokens copyWith({
    double? scaleFactor,
    VooSpacingTokens? spacing,
    VooTypographyTokens? typography,
    VooRadiusTokens? radius,
    VooElevationTokens? elevation,
    VooAnimationTokens? animation,
    VooMarginTokens? margin,
    VooPaddingTokens? padding,
    VooGapTokens? gap,
    VooComponentRadiusTokens? componentRadius,
    VooSizeTokens? size,
  }) => ResponsiveTokens(
    scaleFactor: scaleFactor ?? this.scaleFactor,
    spacing: spacing ?? this.spacing,
    typography: typography ?? this.typography,
    radius: radius ?? this.radius,
    elevation: elevation ?? this.elevation,
    animation: animation ?? this.animation,
    margin: margin ?? this.margin,
    padding: padding ?? this.padding,
    gap: gap ?? this.gap,
    componentRadius: componentRadius ?? this.componentRadius,
    size: size ?? this.size,
  );

  @override
  List<Object?> get props => [scaleFactor, spacing, typography, radius, elevation, animation, margin, padding, gap, componentRadius, size];
}
