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

  /// Custom style that uses user-provided style data.
  custom,
}
