/// Defines the visual style preset for overlays.
enum VooOverlayStyle {
  /// Standard Material 3 design with theme colors and elevation shadows.
  material,

  /// iOS/Cupertino style with rounded corners, drag handle, and blur backdrop.
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

  /// Microsoft Fluent Design with acrylic/mica effects.
  /// Clean with subtle depth and layering.
  fluent,

  /// Bold, stark design with hard edges and high contrast.
  /// Raw, unpolished aesthetic.
  brutalist,

  /// Vintage/retro aesthetic with warm colors and rounded forms.
  /// Nostalgic feel with soft shadows.
  retro,

  /// Glowing neon borders on dark backgrounds.
  /// Cyberpunk-inspired vibrant look.
  neon,

  /// Paper/card-like appearance with subtle texture.
  /// Clean with soft drop shadows.
  paper,

  /// Heavy frosted glass effect with strong blur.
  /// More opaque than glass style.
  frosted,

  /// Custom style that uses user-provided style data.
  custom,
}

/// Extension methods for [VooOverlayStyle].
extension VooOverlayStyleX on VooOverlayStyle {
  /// Whether this style uses blur effects.
  bool get usesBlur => this == VooOverlayStyle.glass ||
      this == VooOverlayStyle.cupertino ||
      this == VooOverlayStyle.fluent ||
      this == VooOverlayStyle.frosted;

  /// Whether this style is dark-themed.
  bool get isDarkThemed => this == VooOverlayStyle.dark ||
      this == VooOverlayStyle.gradient ||
      this == VooOverlayStyle.neon;

  /// Whether this style uses prominent shadows.
  bool get usesElevation => this == VooOverlayStyle.material ||
      this == VooOverlayStyle.elevated ||
      this == VooOverlayStyle.neumorphic ||
      this == VooOverlayStyle.paper ||
      this == VooOverlayStyle.retro;

  /// Whether this style uses borders.
  bool get usesBorder => this == VooOverlayStyle.outlined ||
      this == VooOverlayStyle.glass ||
      this == VooOverlayStyle.minimal ||
      this == VooOverlayStyle.brutalist ||
      this == VooOverlayStyle.neon;

  /// Whether this style uses glow effects.
  bool get usesGlow => this == VooOverlayStyle.neon;

  /// Display name for the style.
  String get displayName {
    switch (this) {
      case VooOverlayStyle.material:
        return 'Material';
      case VooOverlayStyle.cupertino:
        return 'Cupertino';
      case VooOverlayStyle.glass:
        return 'Glass';
      case VooOverlayStyle.minimal:
        return 'Minimal';
      case VooOverlayStyle.outlined:
        return 'Outlined';
      case VooOverlayStyle.elevated:
        return 'Elevated';
      case VooOverlayStyle.soft:
        return 'Soft';
      case VooOverlayStyle.dark:
        return 'Dark';
      case VooOverlayStyle.gradient:
        return 'Gradient';
      case VooOverlayStyle.neumorphic:
        return 'Neumorphic';
      case VooOverlayStyle.fluent:
        return 'Fluent';
      case VooOverlayStyle.brutalist:
        return 'Brutalist';
      case VooOverlayStyle.retro:
        return 'Retro';
      case VooOverlayStyle.neon:
        return 'Neon';
      case VooOverlayStyle.paper:
        return 'Paper';
      case VooOverlayStyle.frosted:
        return 'Frosted';
      case VooOverlayStyle.custom:
        return 'Custom';
    }
  }
}
