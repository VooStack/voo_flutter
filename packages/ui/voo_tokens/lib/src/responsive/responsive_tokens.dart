import 'package:equatable/equatable.dart';
import 'package:voo_tokens/src/tokens/voo_animation_tokens.dart';
import 'package:voo_tokens/src/tokens/voo_elevation_tokens.dart';
import 'package:voo_tokens/src/tokens/voo_radius_tokens.dart';
import 'package:voo_tokens/src/tokens/voo_spacing_tokens.dart';
import 'package:voo_tokens/src/tokens/voo_typography_tokens.dart';

class ResponsiveTokens extends Equatable {
  final double scaleFactor;
  final VooSpacingTokens spacing;
  final VooTypographyTokens typography;
  final VooRadiusTokens radius;
  final VooElevationTokens elevation;
  final VooAnimationTokens animation;

  ResponsiveTokens({
    this.scaleFactor = 1.0,
    VooSpacingTokens? spacing,
    VooTypographyTokens? typography,
    VooRadiusTokens? radius,
    VooElevationTokens? elevation,
    VooAnimationTokens? animation,
  }) : spacing = spacing ?? const VooSpacingTokens(),
       typography = typography ?? const VooTypographyTokens(),
       radius = radius ?? VooRadiusTokens(),
       elevation = elevation ?? const VooElevationTokens(),
       animation = animation ?? const VooAnimationTokens();

  factory ResponsiveTokens.forScreenWidth(double screenWidth, {bool isDark = false}) {
    final scaleFactor = _calculateScaleFactor(screenWidth);

    return ResponsiveTokens(
      scaleFactor: scaleFactor,
      spacing: const VooSpacingTokens().scale(scaleFactor),
      typography: const VooTypographyTokens().scale(scaleFactor),
      radius: VooRadiusTokens().scale(scaleFactor),
      elevation: VooElevationTokens(isDarkMode: isDark),
      animation: const VooAnimationTokens(),
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
  );

  ResponsiveTokens copyWith({
    double? scaleFactor,
    VooSpacingTokens? spacing,
    VooTypographyTokens? typography,
    VooRadiusTokens? radius,
    VooElevationTokens? elevation,
    VooAnimationTokens? animation,
  }) => ResponsiveTokens(
    scaleFactor: scaleFactor ?? this.scaleFactor,
    spacing: spacing ?? this.spacing,
    typography: typography ?? this.typography,
    radius: radius ?? this.radius,
    elevation: elevation ?? this.elevation,
    animation: animation ?? this.animation,
  );

  @override
  List<Object?> get props => [scaleFactor, spacing, typography, radius, elevation, animation];
}
