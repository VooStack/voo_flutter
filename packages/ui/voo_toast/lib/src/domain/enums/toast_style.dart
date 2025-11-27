/// Defines the visual style preset for toasts.
enum VooToastStyle {
  /// Standard Material 3 design with theme colors and elevation shadows.
  /// Uses type-specific colors from colorScheme (primary, error, tertiary, secondary).
  material,

  /// iOS/Cupertino style with rounded corners and subtle blur backdrop.
  cupertino,

  /// Glassmorphism effect with frosted glass, semi-transparent background,
  /// and subtle borders.
  glass,

  /// Clean, minimal design with no shadows or heavy styling.
  /// Focus is entirely on content.
  minimal,

  /// Modern outlined style with borders and no fill.
  /// Clean look with emphasis on structure.
  outlined,

  /// Strong elevation with prominent shadows.
  /// Creates a floating card effect.
  elevated,

  /// Soft pastel colors with gentle rounded corners.
  /// Friendly and approachable appearance.
  soft,

  /// Dark mode optimized with dark backgrounds.
  /// High contrast and reduced eye strain.
  dark,

  /// Gradient background with smooth color transitions.
  /// Modern and visually striking.
  gradient,

  /// Neumorphism style with soft shadows.
  /// Subtle 3D effect with same-color shadows.
  neumorphic,

  /// Glowing neon borders on dark backgrounds.
  /// Cyberpunk-inspired vibrant look.
  neon,

  /// Material snackbar style optimized for mobile.
  /// Full-width, bottom-positioned with action button layout.
  /// Uses dark background with light text for high contrast.
  snackbar,

  /// Custom style that uses user-provided style data.
  custom,
}

/// Extension methods for [VooToastStyle].
extension VooToastStyleX on VooToastStyle {
  /// Whether this style uses blur effects.
  bool get usesBlur =>
      this == VooToastStyle.glass ||
      this == VooToastStyle.cupertino;

  /// Whether this style is dark-themed.
  bool get isDarkThemed =>
      this == VooToastStyle.dark ||
      this == VooToastStyle.gradient ||
      this == VooToastStyle.neon ||
      this == VooToastStyle.snackbar;

  /// Whether this style uses prominent shadows.
  bool get usesElevation =>
      this == VooToastStyle.material ||
      this == VooToastStyle.elevated ||
      this == VooToastStyle.neumorphic ||
      this == VooToastStyle.soft ||
      this == VooToastStyle.snackbar;

  /// Whether this style uses borders.
  bool get usesBorder =>
      this == VooToastStyle.outlined ||
      this == VooToastStyle.glass ||
      this == VooToastStyle.minimal ||
      this == VooToastStyle.neon;

  /// Whether this style uses glow effects.
  bool get usesGlow => this == VooToastStyle.neon;

  /// Whether this style is a snackbar style (full-width, bottom-positioned).
  bool get isSnackbar => this == VooToastStyle.snackbar;

  /// Display name for the style.
  String get displayName {
    switch (this) {
      case VooToastStyle.material:
        return 'Material';
      case VooToastStyle.cupertino:
        return 'Cupertino';
      case VooToastStyle.glass:
        return 'Glass';
      case VooToastStyle.minimal:
        return 'Minimal';
      case VooToastStyle.outlined:
        return 'Outlined';
      case VooToastStyle.elevated:
        return 'Elevated';
      case VooToastStyle.soft:
        return 'Soft';
      case VooToastStyle.dark:
        return 'Dark';
      case VooToastStyle.gradient:
        return 'Gradient';
      case VooToastStyle.neumorphic:
        return 'Neumorphic';
      case VooToastStyle.neon:
        return 'Neon';
      case VooToastStyle.snackbar:
        return 'Snackbar';
      case VooToastStyle.custom:
        return 'Custom';
    }
  }
}
