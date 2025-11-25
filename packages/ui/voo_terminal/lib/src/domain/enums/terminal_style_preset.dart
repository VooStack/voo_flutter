/// Visual style presets for terminal theming.
enum TerminalStylePreset {
  /// Classic terminal style with green text on black background.
  ///
  /// Reminiscent of vintage CRT terminals with phosphor displays.
  classic,

  /// Modern minimal style that adapts to the app's theme.
  ///
  /// Clean design with subtle borders and theme-aware colors.
  modern,

  /// Retro CRT effect with scanlines and phosphor glow.
  ///
  /// Includes visual effects like scanlines and subtle screen curvature.
  retro,

  /// Matrix-inspired style with falling character animations.
  ///
  /// Green characters with optional animated rain effect.
  matrix,

  /// Amber phosphor terminal style.
  ///
  /// Warm amber/orange text reminiscent of early terminals.
  amber,

  /// Ubuntu terminal style.
  ///
  /// Purple and orange accent colors matching Ubuntu's terminal.
  ubuntu,

  /// Custom style allowing full control over all theme properties.
  custom,
}
