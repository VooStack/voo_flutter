import 'package:flutter/material.dart';
import 'package:voo_tokens/voo_tokens.dart';

import 'package:voo_terminal/src/domain/entities/line_prefixes.dart';
import 'package:voo_terminal/src/domain/enums/line_type.dart';
import 'package:voo_terminal/src/domain/enums/terminal_style_preset.dart';

/// Theme configuration for terminal visual styling.
///
/// Use the factory constructors for preset themes:
/// ```dart
/// VooTerminalTheme.classic()
/// VooTerminalTheme.modern()
/// VooTerminalTheme.retro()
/// VooTerminalTheme.matrix()
/// VooTerminalTheme.amber()
/// VooTerminalTheme.ubuntu()
/// ```
class VooTerminalTheme {
  /// Animation tokens for consistent timing.
  static const _animationTokens = VooAnimationTokens();

  /// The visual style preset.
  final TerminalStylePreset preset;

  // Background & Surface
  /// Main background color of the terminal.
  final Color backgroundColor;

  /// Surface color for highlighted elements.
  final Color surfaceColor;

  // Text Colors
  /// Default text color for output.
  final Color textColor;

  /// Color for user input lines.
  final Color inputColor;

  /// Color for error messages.
  final Color errorColor;

  /// Color for warning messages.
  final Color warningColor;

  /// Color for success messages.
  final Color successColor;

  /// Color for system messages.
  final Color systemColor;

  /// Color for info messages.
  final Color infoColor;

  /// Color for debug messages.
  final Color debugColor;

  // Cursor & Selection
  /// Cursor color.
  final Color cursorColor;

  /// Text selection background color.
  final Color selectionColor;

  // Typography
  /// Font family for terminal text.
  final String fontFamily;

  /// Base font size.
  final double fontSize;

  /// Line height multiplier.
  final double lineHeight;

  /// Font weight for regular text.
  final FontWeight fontWeight;

  /// Font weight for bold text.
  final FontWeight boldFontWeight;

  // Cursor Settings
  /// Duration of cursor blink cycle.
  final Duration cursorBlinkRate;

  /// Width of the cursor.
  final double cursorWidth;

  /// Whether the cursor should blink.
  final bool cursorBlinks;

  // Effects
  /// Whether to enable text glow effect.
  final bool enableGlow;

  /// Blur radius for glow effect.
  final double glowBlur;

  /// Spread radius for glow effect.
  final double glowSpread;

  /// Whether to enable CRT scanline effect.
  final bool enableScanlines;

  /// Opacity of scanlines.
  final double scanlineOpacity;

  /// Spacing between scanlines.
  final double scanlineSpacing;

  // Layout
  /// Padding inside the terminal.
  final EdgeInsets padding;

  /// Border radius of the terminal container.
  final BorderRadius borderRadius;

  /// Whether to show a border.
  final bool showBorder;

  /// Border color.
  final Color borderColor;

  /// Border width.
  final double borderWidth;

  // Scrollbar
  /// Color of the scrollbar thumb.
  final Color scrollbarColor;

  /// Width of the scrollbar.
  final double scrollbarWidth;

  /// Whether to always show the scrollbar.
  final bool alwaysShowScrollbar;

  // Animation
  /// Duration for theme transitions.
  final Duration animationDuration;

  /// Curve for theme transitions.
  final Curve animationCurve;

  // Line formatting
  /// Spacing between terminal lines.
  final double lineSpacing;

  /// Custom prefix icons for each line type.
  /// If null, uses default prefixes from LineType.
  final LinePrefixes? linePrefixes;

  /// Whether to show prefixes for line types.
  final bool showLinePrefixes;

  // Timestamp
  /// Optional custom color for timestamps (defaults to systemColor).
  final Color? timestampColor;

  /// Scale factor for timestamp font size relative to main font.
  final double timestampScale;

  // Header
  /// Height of the terminal header.
  final double headerHeight;

  /// Padding inside the header.
  final EdgeInsets headerPadding;

  /// Scale factor for header title font size relative to main font.
  final double headerTitleScale;

  /// Creates a custom terminal theme.
  const VooTerminalTheme({
    this.preset = TerminalStylePreset.custom,
    required this.backgroundColor,
    required this.surfaceColor,
    required this.textColor,
    required this.inputColor,
    required this.errorColor,
    required this.warningColor,
    required this.successColor,
    required this.systemColor,
    required this.infoColor,
    required this.debugColor,
    required this.cursorColor,
    required this.selectionColor,
    this.fontFamily = 'monospace',
    this.fontSize = 14.0,
    this.lineHeight = 1.4,
    this.fontWeight = FontWeight.w400,
    this.boldFontWeight = FontWeight.w700,
    this.cursorBlinkRate = const Duration(milliseconds: 530),
    this.cursorWidth = 2.0,
    this.cursorBlinks = true,
    this.enableGlow = false,
    this.glowBlur = 4.0,
    this.glowSpread = 1.0,
    this.enableScanlines = false,
    this.scanlineOpacity = 0.05,
    this.scanlineSpacing = 2.0,
    this.padding = const EdgeInsets.all(16.0),
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.showBorder = true,
    required this.borderColor,
    this.borderWidth = 1.0,
    required this.scrollbarColor,
    this.scrollbarWidth = 8.0,
    this.alwaysShowScrollbar = false,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeOutCubic,
    this.lineSpacing = 2.0,
    this.linePrefixes,
    this.showLinePrefixes = true,
    this.timestampColor,
    this.timestampScale = 0.85,
    this.headerHeight = 36.0,
    this.headerPadding = const EdgeInsets.symmetric(horizontal: 12.0),
    this.headerTitleScale = 0.9,
  });

  /// Classic terminal theme: green text on black background.
  factory VooTerminalTheme.classic({
    Color? cursorColor,
    Duration? animationDuration,
  }) {
    const green = Color(0xFF00FF00);
    return VooTerminalTheme(
      preset: TerminalStylePreset.classic,
      backgroundColor: const Color(0xFF0D0D0D),
      surfaceColor: const Color(0xFF1A1A1A),
      textColor: green,
      inputColor: green,
      errorColor: const Color(0xFFFF5555),
      warningColor: const Color(0xFFFFFF55),
      successColor: const Color(0xFF55FF55),
      systemColor: const Color(0xFF888888),
      infoColor: const Color(0xFF55FFFF),
      debugColor: const Color(0xFF666666),
      cursorColor: cursorColor ?? green,
      selectionColor: green.withValues(alpha: 0.3),
      borderColor: const Color(0xFF333333),
      scrollbarColor: green.withValues(alpha: 0.5),
      enableGlow: true,
      glowBlur: 3.0,
      animationDuration: animationDuration ?? _animationTokens.durationNormal,
    );
  }

  /// Modern theme: clean design that adapts to app theme.
  factory VooTerminalTheme.modern({
    Brightness brightness = Brightness.dark,
    Color? accentColor,
    Duration? animationDuration,
  }) {
    final isDark = brightness == Brightness.dark;
    final accent = accentColor ?? const Color(0xFF6366F1);

    return VooTerminalTheme(
      preset: TerminalStylePreset.modern,
      backgroundColor:
          isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFAFAFA),
      surfaceColor:
          isDark ? const Color(0xFF2D2D2D) : const Color(0xFFFFFFFF),
      textColor: isDark ? const Color(0xFFE4E4E7) : const Color(0xFF27272A),
      inputColor: accent,
      errorColor: const Color(0xFFEF4444),
      warningColor: const Color(0xFFF59E0B),
      successColor: const Color(0xFF10B981),
      systemColor: isDark ? const Color(0xFF71717A) : const Color(0xFFA1A1AA),
      infoColor: const Color(0xFF3B82F6),
      debugColor: isDark ? const Color(0xFF52525B) : const Color(0xFFD4D4D8),
      cursorColor: accent,
      selectionColor: accent.withValues(alpha: 0.3),
      borderColor:
          isDark ? const Color(0xFF3F3F46) : const Color(0xFFE4E4E7),
      scrollbarColor:
          isDark ? const Color(0xFF52525B) : const Color(0xFFA1A1AA),
      enableGlow: false,
      animationDuration: animationDuration ?? _animationTokens.durationNormal,
    );
  }

  /// Retro CRT theme: scanlines and phosphor glow effect.
  factory VooTerminalTheme.retro({
    Color? phosphorColor,
    Duration? animationDuration,
  }) {
    final phosphor = phosphorColor ?? const Color(0xFF33FF33);
    return VooTerminalTheme(
      preset: TerminalStylePreset.retro,
      backgroundColor: const Color(0xFF0A0A0A),
      surfaceColor: const Color(0xFF141414),
      textColor: phosphor,
      inputColor: phosphor,
      errorColor: const Color(0xFFFF4444),
      warningColor: const Color(0xFFFFCC00),
      successColor: const Color(0xFF44FF44),
      systemColor: const Color(0xFF666666),
      infoColor: const Color(0xFF44FFFF),
      debugColor: const Color(0xFF444444),
      cursorColor: phosphor,
      selectionColor: phosphor.withValues(alpha: 0.25),
      borderColor: const Color(0xFF222222),
      scrollbarColor: phosphor.withValues(alpha: 0.4),
      enableGlow: true,
      glowBlur: 6.0,
      glowSpread: 2.0,
      enableScanlines: true,
      scanlineOpacity: 0.08,
      scanlineSpacing: 2.0,
      borderRadius: const BorderRadius.all(Radius.circular(12.0)),
      borderWidth: 2.0,
      animationDuration: animationDuration ?? _animationTokens.durationNormal,
    );
  }

  /// Matrix theme: green characters with optional rain effect.
  factory VooTerminalTheme.matrix({
    Duration? animationDuration,
  }) {
    const matrixGreen = Color(0xFF00FF41);
    return VooTerminalTheme(
      preset: TerminalStylePreset.matrix,
      backgroundColor: const Color(0xFF000000),
      surfaceColor: const Color(0xFF0D1F0D),
      textColor: matrixGreen,
      inputColor: const Color(0xFF00CC33),
      errorColor: const Color(0xFFFF3333),
      warningColor: const Color(0xFFFFFF00),
      successColor: const Color(0xFF00FF00),
      systemColor: const Color(0xFF006600),
      infoColor: const Color(0xFF00FFFF),
      debugColor: const Color(0xFF004400),
      cursorColor: matrixGreen,
      selectionColor: matrixGreen.withValues(alpha: 0.2),
      borderColor: const Color(0xFF003300),
      scrollbarColor: matrixGreen.withValues(alpha: 0.3),
      enableGlow: true,
      glowBlur: 8.0,
      glowSpread: 3.0,
      animationDuration: animationDuration ?? _animationTokens.durationFast,
    );
  }

  /// Amber theme: warm amber phosphor display.
  factory VooTerminalTheme.amber({
    Duration? animationDuration,
  }) {
    const amber = Color(0xFFFFB000);
    return VooTerminalTheme(
      preset: TerminalStylePreset.amber,
      backgroundColor: const Color(0xFF1A1200),
      surfaceColor: const Color(0xFF2A1E00),
      textColor: amber,
      inputColor: amber,
      errorColor: const Color(0xFFFF4444),
      warningColor: const Color(0xFFFFDD44),
      successColor: const Color(0xFF88FF44),
      systemColor: const Color(0xFF886600),
      infoColor: const Color(0xFFFFCC66),
      debugColor: const Color(0xFF664400),
      cursorColor: amber,
      selectionColor: amber.withValues(alpha: 0.3),
      borderColor: const Color(0xFF443300),
      scrollbarColor: amber.withValues(alpha: 0.5),
      enableGlow: true,
      glowBlur: 4.0,
      glowSpread: 1.5,
      animationDuration: animationDuration ?? _animationTokens.durationNormal,
    );
  }

  /// Ubuntu theme: Ubuntu terminal colors.
  factory VooTerminalTheme.ubuntu({
    Duration? animationDuration,
  }) {
    const purple = Color(0xFF300A24);
    const orange = Color(0xFFE95420);
    return VooTerminalTheme(
      preset: TerminalStylePreset.ubuntu,
      backgroundColor: purple,
      surfaceColor: const Color(0xFF3D1C33),
      textColor: const Color(0xFFFFFFFF),
      inputColor: orange,
      errorColor: const Color(0xFFCC0000),
      warningColor: const Color(0xFFC4A000),
      successColor: const Color(0xFF4E9A06),
      systemColor: const Color(0xFF75507B),
      infoColor: const Color(0xFF06989A),
      debugColor: const Color(0xFF555753),
      cursorColor: orange,
      selectionColor: orange.withValues(alpha: 0.3),
      borderColor: const Color(0xFF5E3D53),
      scrollbarColor: orange.withValues(alpha: 0.5),
      enableGlow: false,
      animationDuration: animationDuration ?? _animationTokens.durationNormal,
    );
  }

  /// Creates a theme from the current Flutter theme.
  factory VooTerminalTheme.fromTheme(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return VooTerminalTheme(
      preset: TerminalStylePreset.custom,
      backgroundColor: isDark
          ? colorScheme.surfaceContainerLowest
          : colorScheme.surfaceContainerHighest,
      surfaceColor: colorScheme.surfaceContainer,
      textColor: colorScheme.onSurface,
      inputColor: colorScheme.primary,
      errorColor: colorScheme.error,
      warningColor: Colors.amber,
      successColor: Colors.green,
      systemColor: colorScheme.onSurfaceVariant,
      infoColor: colorScheme.tertiary,
      debugColor: colorScheme.outline,
      cursorColor: colorScheme.primary,
      selectionColor: colorScheme.primary.withValues(alpha: 0.3),
      borderColor: colorScheme.outlineVariant,
      scrollbarColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
    );
  }

  /// Gets the color for a specific line type.
  Color colorForLineType(String type) {
    switch (type) {
      case 'input':
        return inputColor;
      case 'error':
        return errorColor;
      case 'warning':
        return warningColor;
      case 'success':
        return successColor;
      case 'system':
        return systemColor;
      case 'info':
        return infoColor;
      case 'debug':
        return debugColor;
      default:
        return textColor;
    }
  }

  /// Gets the text style for terminal text.
  TextStyle get textStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        height: lineHeight,
        fontWeight: fontWeight,
        color: textColor,
      );

  /// Gets the text style for a specific color.
  TextStyle textStyleWithColor(Color color) => textStyle.copyWith(color: color);

  /// Gets the prefix for a specific line type.
  ///
  /// Returns an empty string if [showLinePrefixes] is false.
  /// Uses custom [linePrefixes] if provided, otherwise uses defaults from LineType.
  String prefixForLineType(LineType type) {
    if (!showLinePrefixes) return '';
    return linePrefixes?.forType(type) ?? type.defaultPrefix;
  }

  /// Creates a copy of this theme with the given fields replaced.
  VooTerminalTheme copyWith({
    TerminalStylePreset? preset,
    Color? backgroundColor,
    Color? surfaceColor,
    Color? textColor,
    Color? inputColor,
    Color? errorColor,
    Color? warningColor,
    Color? successColor,
    Color? systemColor,
    Color? infoColor,
    Color? debugColor,
    Color? cursorColor,
    Color? selectionColor,
    String? fontFamily,
    double? fontSize,
    double? lineHeight,
    FontWeight? fontWeight,
    FontWeight? boldFontWeight,
    Duration? cursorBlinkRate,
    double? cursorWidth,
    bool? cursorBlinks,
    bool? enableGlow,
    double? glowBlur,
    double? glowSpread,
    bool? enableScanlines,
    double? scanlineOpacity,
    double? scanlineSpacing,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
    bool? showBorder,
    Color? borderColor,
    double? borderWidth,
    Color? scrollbarColor,
    double? scrollbarWidth,
    bool? alwaysShowScrollbar,
    Duration? animationDuration,
    Curve? animationCurve,
    double? lineSpacing,
    LinePrefixes? linePrefixes,
    bool? showLinePrefixes,
    Color? timestampColor,
    double? timestampScale,
    double? headerHeight,
    EdgeInsets? headerPadding,
    double? headerTitleScale,
  }) {
    return VooTerminalTheme(
      preset: preset ?? this.preset,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      textColor: textColor ?? this.textColor,
      inputColor: inputColor ?? this.inputColor,
      errorColor: errorColor ?? this.errorColor,
      warningColor: warningColor ?? this.warningColor,
      successColor: successColor ?? this.successColor,
      systemColor: systemColor ?? this.systemColor,
      infoColor: infoColor ?? this.infoColor,
      debugColor: debugColor ?? this.debugColor,
      cursorColor: cursorColor ?? this.cursorColor,
      selectionColor: selectionColor ?? this.selectionColor,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      fontWeight: fontWeight ?? this.fontWeight,
      boldFontWeight: boldFontWeight ?? this.boldFontWeight,
      cursorBlinkRate: cursorBlinkRate ?? this.cursorBlinkRate,
      cursorWidth: cursorWidth ?? this.cursorWidth,
      cursorBlinks: cursorBlinks ?? this.cursorBlinks,
      enableGlow: enableGlow ?? this.enableGlow,
      glowBlur: glowBlur ?? this.glowBlur,
      glowSpread: glowSpread ?? this.glowSpread,
      enableScanlines: enableScanlines ?? this.enableScanlines,
      scanlineOpacity: scanlineOpacity ?? this.scanlineOpacity,
      scanlineSpacing: scanlineSpacing ?? this.scanlineSpacing,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      showBorder: showBorder ?? this.showBorder,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      scrollbarColor: scrollbarColor ?? this.scrollbarColor,
      scrollbarWidth: scrollbarWidth ?? this.scrollbarWidth,
      alwaysShowScrollbar: alwaysShowScrollbar ?? this.alwaysShowScrollbar,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      lineSpacing: lineSpacing ?? this.lineSpacing,
      linePrefixes: linePrefixes ?? this.linePrefixes,
      showLinePrefixes: showLinePrefixes ?? this.showLinePrefixes,
      timestampColor: timestampColor ?? this.timestampColor,
      timestampScale: timestampScale ?? this.timestampScale,
      headerHeight: headerHeight ?? this.headerHeight,
      headerPadding: headerPadding ?? this.headerPadding,
      headerTitleScale: headerTitleScale ?? this.headerTitleScale,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VooTerminalTheme &&
        other.preset == preset &&
        other.backgroundColor == backgroundColor &&
        other.textColor == textColor &&
        other.cursorColor == cursorColor;
  }

  @override
  int get hashCode => Object.hash(
        preset,
        backgroundColor,
        textColor,
        cursorColor,
      );
}
