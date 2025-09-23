import 'package:flutter/material.dart';
import 'package:voo_tokens/src/responsive/responsive_tokens.dart';
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

@immutable
class VooTokensTheme extends ThemeExtension<VooTokensTheme> {
  final ResponsiveTokens tokens;

  const VooTokensTheme({required this.tokens});

  factory VooTokensTheme.standard({double scaleFactor = 1.0}) => VooTokensTheme(
        tokens: ResponsiveTokens(
          scaleFactor: scaleFactor,
          spacing: const VooSpacingTokens().scale(scaleFactor),
          typography: const VooTypographyTokens().scale(scaleFactor),
          radius: VooRadiusTokens().scale(scaleFactor),
          elevation: const VooElevationTokens(),
          animation: const VooAnimationTokens(),
          margin: const VooMarginTokens().scale(scaleFactor),
          padding: const VooPaddingTokens().scale(scaleFactor),
          gap: const VooGapTokens().scale(scaleFactor),
          componentRadius: const VooComponentRadiusTokens().scale(scaleFactor),
          size: const VooSizeTokens().scale(scaleFactor),
        ),
      );

  factory VooTokensTheme.responsive({required double screenWidth, bool isDark = false}) =>
      VooTokensTheme(tokens: ResponsiveTokens.forScreenWidth(screenWidth, isDark: isDark));

  VooSpacingTokens get spacing => tokens.spacing;
  VooTypographyTokens get typography => tokens.typography;
  VooRadiusTokens get radius => tokens.radius;
  VooElevationTokens get elevation => tokens.elevation;
  VooAnimationTokens get animation => tokens.animation;
  VooMarginTokens get margin => tokens.margin;
  VooPaddingTokens get padding => tokens.padding;
  VooGapTokens get gap => tokens.gap;
  VooComponentRadiusTokens get componentRadius => tokens.componentRadius;
  VooSizeTokens get size => tokens.size;

  @override
  VooTokensTheme copyWith({ResponsiveTokens? tokens}) => VooTokensTheme(tokens: tokens ?? this.tokens);

  @override
  VooTokensTheme lerp(ThemeExtension<VooTokensTheme>? other, double t) {
    if (other is! VooTokensTheme) {
      return this;
    }
    return VooTokensTheme(
      tokens: ResponsiveTokens(
        scaleFactor: t < 0.5 ? tokens.scaleFactor : other.tokens.scaleFactor,
        spacing: t < 0.5 ? tokens.spacing : other.tokens.spacing,
        typography: t < 0.5 ? tokens.typography : other.tokens.typography,
        radius: t < 0.5 ? tokens.radius : other.tokens.radius,
        elevation: t < 0.5 ? tokens.elevation : other.tokens.elevation,
        animation: t < 0.5 ? tokens.animation : other.tokens.animation,
      ),
    );
  }
}

extension VooTokensContext on BuildContext {
  VooTokensTheme get vooTokens {
    final theme = Theme.of(this).extension<VooTokensTheme>();
    // Return default theme if not found in context
    return theme ?? VooTokensTheme.standard();
  }

  VooSpacingTokens get vooSpacing => vooTokens.spacing;
  VooTypographyTokens get vooTypography => vooTokens.typography;
  VooRadiusTokens get vooRadius => vooTokens.radius;
  VooElevationTokens get vooElevation => vooTokens.elevation;
  VooAnimationTokens get vooAnimation => vooTokens.animation;
  VooMarginTokens get vooMargin => vooTokens.margin;
  VooPaddingTokens get vooPadding => vooTokens.padding;
  VooGapTokens get vooGap => vooTokens.gap;
  VooComponentRadiusTokens get vooComponentRadius => vooTokens.componentRadius;
  VooSizeTokens get vooSize => vooTokens.size;

  double vooSpace(double baseValue) {
    final scaleFactor = vooTokens.tokens.scaleFactor;
    return baseValue * scaleFactor;
  }
}
