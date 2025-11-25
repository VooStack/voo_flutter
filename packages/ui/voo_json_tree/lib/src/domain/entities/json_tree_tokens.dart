import 'package:flutter/material.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Token integration layer for VooJsonTree.
///
/// Provides default values derived from voo_tokens design system.
/// These can be used to create consistent theming across the VooFlutter ecosystem.
class JsonTreeTokens {
  /// Private constructor - this class only provides static values.
  const JsonTreeTokens._();

  // Default token instances
  static const _spacing = VooSpacingTokens();
  static final _radius = VooRadiusTokens();
  static const _animation = VooAnimationTokens();

  // ============================================================
  // SPACING TOKENS
  // ============================================================

  /// Default indent width for tree hierarchy.
  /// Uses spacing.md (16px) for comfortable visual hierarchy.
  static double get indentWidth => _spacing.md;

  /// Vertical spacing between tree nodes.
  /// Uses spacing.xxs (2px) for compact but readable layout.
  static double get nodeSpacing => _spacing.xxs;

  /// Default padding inside the tree container.
  /// Uses spacing.cardPadding (16px) for consistent card-like appearance.
  static EdgeInsets get containerPadding => EdgeInsets.all(_spacing.cardPadding);

  /// Padding for toolbar elements.
  /// Uses spacing.sm (8px) for compact toolbar layout.
  static EdgeInsets get toolbarPadding => EdgeInsets.all(_spacing.sm);

  /// Gap between toolbar items.
  /// Uses spacing.gapSmall (8px).
  static double get toolbarGap => _spacing.gapSmall;

  /// Horizontal padding for node content.
  /// Uses spacing.xs (4px) for tight content spacing.
  static double get nodeHorizontalPadding => _spacing.xs;

  // ============================================================
  // RADIUS TOKENS
  // ============================================================

  /// Border radius for the tree container.
  /// Uses radius.md (8px) for subtle rounding.
  static double get containerRadius => _radius.md;

  /// Border radius for search input.
  /// Uses radius.sm (4px) for inline input style.
  static double get inputRadius => _radius.sm;

  /// Border radius for buttons.
  /// Uses radius.sm (4px).
  static double get buttonRadius => _radius.sm;

  /// Border radius for tooltips and context menus.
  /// Uses radius.md (8px).
  static double get tooltipRadius => _radius.md;

  /// Border radius for selected/hovered node highlights.
  /// Uses radius.xs (2px) for subtle selection indication.
  static double get nodeHighlightRadius => _radius.xs;

  // ============================================================
  // ANIMATION TOKENS
  // ============================================================

  /// Duration for expand/collapse animations.
  /// Uses animation.durationNormal (250ms) for smooth but responsive feel.
  static Duration get expansionDuration => _animation.durationNormal;

  /// Duration for hover state transitions.
  /// Uses animation.durationFast (150ms) for quick feedback.
  static Duration get hoverDuration => _animation.durationFast;

  /// Duration for search highlight animations.
  /// Uses animation.durationFast (150ms).
  static Duration get searchHighlightDuration => _animation.durationFast;

  /// Standard easing curve for animations.
  static Curve get standardCurve => _animation.curveEaseInOut;

  /// Easing curve for expansion animations.
  static Curve get expansionCurve => _animation.curveEaseOut;

  // ============================================================
  // TYPOGRAPHY TOKENS
  // ============================================================

  /// Default font size for tree content.
  static const double fontSize = 13.0;

  /// Font size for small screens.
  static const double fontSizeSmall = 12.0;

  /// Font size for large screens.
  static const double fontSizeLarge = 14.0;

  /// Default line height multiplier.
  static const double lineHeight = 1.4;

  /// Default monospace font family for code display.
  static const String fontFamily = 'monospace';

  // ============================================================
  // HELPER METHODS
  // ============================================================

  /// Gets responsive font size based on screen width.
  ///
  /// - Small screens (<600px): 12px
  /// - Medium screens (600-1200px): 13px
  /// - Large screens (>1200px): 14px
  static double getResponsiveFontSize(double screenWidth) {
    if (screenWidth < 600) {
      return fontSizeSmall;
    } else if (screenWidth > 1200) {
      return fontSizeLarge;
    }
    return fontSize;
  }

  /// Gets responsive indent width based on screen width.
  ///
  /// Smaller indent on mobile for better space usage.
  static double getResponsiveIndentWidth(double screenWidth) {
    if (screenWidth < 600) {
      return _spacing.sm; // 8px on mobile
    }
    return _spacing.md; // 16px on larger screens
  }

  /// Gets responsive container padding based on screen width.
  static EdgeInsets getResponsiveContainerPadding(double screenWidth) {
    if (screenWidth < 600) {
      return EdgeInsets.all(_spacing.sm); // 8px on mobile
    }
    return EdgeInsets.all(_spacing.cardPadding); // 16px on larger screens
  }

  /// Creates spacing tokens with custom scale factor.
  static VooSpacingTokens scaledSpacing(double factor) {
    return _spacing.scale(factor);
  }

  /// Creates radius tokens with custom scale factor.
  static VooRadiusTokens scaledRadius(double factor) {
    return _radius.scale(factor);
  }
}
