import 'package:flutter/material.dart';

import 'package:voo_json_tree/src/domain/entities/json_tree_tokens.dart';

/// Theme configuration for the JSON tree viewer.
///
/// Provides comprehensive styling options for all visual aspects of the tree.
///
/// ## Predefined Themes
///
/// Use factory constructors for quick setup:
/// - [VooJsonTreeTheme.dark] - Dark background with VS Code-like colors
/// - [VooJsonTreeTheme.light] - Light background with readable colors
/// - [VooJsonTreeTheme.vscode] - VS Code dark theme colors
/// - [VooJsonTreeTheme.monokai] - Monokai color scheme
/// - [VooJsonTreeTheme.fromTokens] - Token-based theme using voo_tokens
/// - [VooJsonTreeTheme.system] - Inherits from current Material theme
///
/// ## Custom Theme
///
/// ```dart
/// VooJsonTreeTheme(
///   backgroundColor: Colors.grey[900],
///   keyColor: Colors.blue[300],
///   stringColor: Colors.orange[300],
/// )
/// ```
class VooJsonTreeTheme {
  /// Creates a new [VooJsonTreeTheme].
  const VooJsonTreeTheme({
    this.backgroundColor,
    this.keyColor = const Color(0xFF9CDCFE),
    this.keyFontWeight = FontWeight.normal,
    this.stringColor = const Color(0xFFCE9178),
    this.numberColor = const Color(0xFFB5CEA8),
    this.booleanColor = const Color(0xFF569CD6),
    this.nullColor = const Color(0xFF808080),
    this.bracketColor = const Color(0xFFFFD700),
    this.expandIconColor = const Color(0xFF808080),
    this.indentGuideColor = const Color(0xFF404040),
    this.hoverColor = const Color(0x1AFFFFFF),
    this.selectedColor = const Color(0xFF094771),
    this.searchMatchColor = const Color(0xFFFFE484),
    this.searchMatchTextColor = const Color(0xFF000000),
    this.fontFamily = 'monospace',
    this.fontSize = 13.0,
    this.lineHeight = 1.4,
    this.indentWidth = 20.0,
    this.nodeSpacing = 2.0,
    this.showIndentGuides = true,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.all(12.0),
  });

  /// Background color of the tree view.
  final Color? backgroundColor;

  /// Color for JSON keys/property names.
  final Color keyColor;

  /// Font weight for keys.
  final FontWeight keyFontWeight;

  /// Color for string values.
  final Color stringColor;

  /// Color for number values.
  final Color numberColor;

  /// Color for boolean values.
  final Color booleanColor;

  /// Color for null values.
  final Color nullColor;

  /// Color for brackets ({}, []).
  final Color bracketColor;

  /// Color for expand/collapse icons.
  final Color expandIconColor;

  /// Color for indent guide lines.
  final Color indentGuideColor;

  /// Background color on hover.
  final Color hoverColor;

  /// Background color for selected nodes.
  final Color selectedColor;

  /// Background color for search match highlights.
  final Color searchMatchColor;

  /// Text color for search match highlights.
  final Color searchMatchTextColor;

  /// Font family for all text.
  final String fontFamily;

  /// Font size for all text.
  final double fontSize;

  /// Line height multiplier.
  final double lineHeight;

  /// Width of each indentation level in pixels.
  final double indentWidth;

  /// Vertical spacing between nodes.
  final double nodeSpacing;

  /// Whether to show vertical indent guide lines.
  final bool showIndentGuides;

  /// Border radius for the container.
  final double borderRadius;

  /// Padding inside the container.
  final EdgeInsets padding;

  /// Creates a dark theme preset.
  factory VooJsonTreeTheme.dark() {
    return const VooJsonTreeTheme(
      backgroundColor: Color(0xFF1E1E1E),
      keyColor: Color(0xFF9CDCFE),
      stringColor: Color(0xFFCE9178),
      numberColor: Color(0xFFB5CEA8),
      booleanColor: Color(0xFF569CD6),
      nullColor: Color(0xFF808080),
      bracketColor: Color(0xFFFFD700),
      expandIconColor: Color(0xFFCCCCCC),
      indentGuideColor: Color(0xFF404040),
      hoverColor: Color(0xFF2A2D2E),
      selectedColor: Color(0xFF094771),
    );
  }

  /// Creates a light theme preset.
  factory VooJsonTreeTheme.light() {
    return const VooJsonTreeTheme(
      backgroundColor: Color(0xFFFFFFFF),
      keyColor: Color(0xFF0451A5),
      stringColor: Color(0xFFA31515),
      numberColor: Color(0xFF098658),
      booleanColor: Color(0xFF0000FF),
      nullColor: Color(0xFF808080),
      bracketColor: Color(0xFF000000),
      expandIconColor: Color(0xFF424242),
      indentGuideColor: Color(0xFFE0E0E0),
      hoverColor: Color(0xFFF5F5F5),
      selectedColor: Color(0xFFADD6FF),
      searchMatchColor: Color(0xFFFFEB3B),
      searchMatchTextColor: Color(0xFF000000),
    );
  }

  /// Creates a VS Code-inspired dark theme.
  factory VooJsonTreeTheme.vscode() {
    return const VooJsonTreeTheme(
      backgroundColor: Color(0xFF1E1E1E),
      keyColor: Color(0xFF9CDCFE),
      stringColor: Color(0xFFCE9178),
      numberColor: Color(0xFFB5CEA8),
      booleanColor: Color(0xFF569CD6),
      nullColor: Color(0xFF569CD6),
      bracketColor: Color(0xFFD4D4D4),
      expandIconColor: Color(0xFFCCCCCC),
      indentGuideColor: Color(0xFF404040),
      hoverColor: Color(0xFF2A2D2E),
      selectedColor: Color(0xFF264F78),
    );
  }

  /// Creates a Monokai-inspired theme.
  factory VooJsonTreeTheme.monokai() {
    return const VooJsonTreeTheme(
      backgroundColor: Color(0xFF272822),
      keyColor: Color(0xFFF92672),
      stringColor: Color(0xFFE6DB74),
      numberColor: Color(0xFFAE81FF),
      booleanColor: Color(0xFFAE81FF),
      nullColor: Color(0xFFAE81FF),
      bracketColor: Color(0xFFF8F8F2),
      expandIconColor: Color(0xFF75715E),
      indentGuideColor: Color(0xFF3E3D32),
      hoverColor: Color(0xFF3E3D32),
      selectedColor: Color(0xFF49483E),
    );
  }

  /// Creates a theme using voo_tokens design system values.
  ///
  /// This factory uses spacing, radius, and animation values from the
  /// voo_tokens package for consistency with the VooFlutter ecosystem.
  ///
  /// Colors can be customized or will default to the dark theme colors.
  ///
  /// ```dart
  /// VooJsonTreeTheme.fromTokens()
  /// VooJsonTreeTheme.fromTokens(
  ///   keyColor: Colors.cyan,
  ///   stringColor: Colors.amber,
  /// )
  /// ```
  factory VooJsonTreeTheme.fromTokens({
    Color? backgroundColor,
    Color keyColor = const Color(0xFF9CDCFE),
    FontWeight keyFontWeight = FontWeight.normal,
    Color stringColor = const Color(0xFFCE9178),
    Color numberColor = const Color(0xFFB5CEA8),
    Color booleanColor = const Color(0xFF569CD6),
    Color nullColor = const Color(0xFF808080),
    Color bracketColor = const Color(0xFFFFD700),
    Color expandIconColor = const Color(0xFFCCCCCC),
    Color indentGuideColor = const Color(0xFF404040),
    Color hoverColor = const Color(0xFF2A2D2E),
    Color selectedColor = const Color(0xFF094771),
    Color searchMatchColor = const Color(0xFFFFE484),
    Color searchMatchTextColor = const Color(0xFF000000),
    String? fontFamily,
    double? fontSize,
    double? lineHeight,
    bool? showIndentGuides,
  }) {
    return VooJsonTreeTheme(
      backgroundColor: backgroundColor ?? const Color(0xFF1E1E1E),
      keyColor: keyColor,
      keyFontWeight: keyFontWeight,
      stringColor: stringColor,
      numberColor: numberColor,
      booleanColor: booleanColor,
      nullColor: nullColor,
      bracketColor: bracketColor,
      expandIconColor: expandIconColor,
      indentGuideColor: indentGuideColor,
      hoverColor: hoverColor,
      selectedColor: selectedColor,
      searchMatchColor: searchMatchColor,
      searchMatchTextColor: searchMatchTextColor,
      fontFamily: fontFamily ?? JsonTreeTokens.fontFamily,
      fontSize: fontSize ?? JsonTreeTokens.fontSize,
      lineHeight: lineHeight ?? JsonTreeTokens.lineHeight,
      indentWidth: JsonTreeTokens.indentWidth,
      nodeSpacing: JsonTreeTokens.nodeSpacing,
      showIndentGuides: showIndentGuides ?? true,
      borderRadius: JsonTreeTokens.containerRadius,
      padding: JsonTreeTokens.containerPadding,
    );
  }

  /// Creates a theme that inherits colors from the current Material theme.
  ///
  /// This is useful for apps that want the JSON tree to blend with their
  /// existing theme. Uses the ColorScheme from the provided [context].
  ///
  /// ```dart
  /// VooJsonTree(
  ///   data: jsonData,
  ///   theme: VooJsonTreeTheme.system(context),
  /// )
  /// ```
  factory VooJsonTreeTheme.system(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return VooJsonTreeTheme(
      backgroundColor: colorScheme.surface,
      keyColor: colorScheme.primary,
      keyFontWeight: FontWeight.w500,
      stringColor: isDark
          ? const Color(0xFFCE9178)
          : const Color(0xFFA31515),
      numberColor: isDark
          ? const Color(0xFFB5CEA8)
          : const Color(0xFF098658),
      booleanColor: colorScheme.tertiary,
      nullColor: colorScheme.outline,
      bracketColor: colorScheme.onSurface,
      expandIconColor: colorScheme.onSurfaceVariant,
      indentGuideColor: colorScheme.outlineVariant,
      hoverColor: colorScheme.surfaceContainerHighest,
      selectedColor: colorScheme.primaryContainer,
      searchMatchColor: colorScheme.tertiaryContainer,
      searchMatchTextColor: colorScheme.onTertiaryContainer,
      fontFamily: JsonTreeTokens.fontFamily,
      fontSize: JsonTreeTokens.fontSize,
      lineHeight: JsonTreeTokens.lineHeight,
      indentWidth: JsonTreeTokens.indentWidth,
      nodeSpacing: JsonTreeTokens.nodeSpacing,
      showIndentGuides: true,
      borderRadius: JsonTreeTokens.containerRadius,
      padding: JsonTreeTokens.containerPadding,
    );
  }

  /// Creates a transparent theme with no background.
  ///
  /// Useful for embedding the tree in custom containers or when you want
  /// full control over the surrounding styling.
  ///
  /// ```dart
  /// Container(
  ///   decoration: myCustomDecoration,
  ///   child: VooJsonTree(
  ///     data: jsonData,
  ///     theme: VooJsonTreeTheme.transparent(),
  ///   ),
  /// )
  /// ```
  factory VooJsonTreeTheme.transparent() {
    return VooJsonTreeTheme(
      backgroundColor: Colors.transparent,
      keyColor: const Color(0xFF9CDCFE),
      stringColor: const Color(0xFFCE9178),
      numberColor: const Color(0xFFB5CEA8),
      booleanColor: const Color(0xFF569CD6),
      nullColor: const Color(0xFF808080),
      bracketColor: const Color(0xFFD4D4D4),
      expandIconColor: const Color(0xFFCCCCCC),
      indentGuideColor: const Color(0xFF404040),
      hoverColor: const Color(0x1AFFFFFF),
      selectedColor: const Color(0xFF094771),
      fontFamily: JsonTreeTokens.fontFamily,
      fontSize: JsonTreeTokens.fontSize,
      lineHeight: JsonTreeTokens.lineHeight,
      indentWidth: JsonTreeTokens.indentWidth,
      nodeSpacing: JsonTreeTokens.nodeSpacing,
      borderRadius: 0,
      padding: EdgeInsets.zero,
    );
  }

  /// Creates a copy with the given fields replaced.
  VooJsonTreeTheme copyWith({
    Color? backgroundColor,
    Color? keyColor,
    FontWeight? keyFontWeight,
    Color? stringColor,
    Color? numberColor,
    Color? booleanColor,
    Color? nullColor,
    Color? bracketColor,
    Color? expandIconColor,
    Color? indentGuideColor,
    Color? hoverColor,
    Color? selectedColor,
    Color? searchMatchColor,
    Color? searchMatchTextColor,
    String? fontFamily,
    double? fontSize,
    double? lineHeight,
    double? indentWidth,
    double? nodeSpacing,
    bool? showIndentGuides,
    double? borderRadius,
    EdgeInsets? padding,
  }) {
    return VooJsonTreeTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      keyColor: keyColor ?? this.keyColor,
      keyFontWeight: keyFontWeight ?? this.keyFontWeight,
      stringColor: stringColor ?? this.stringColor,
      numberColor: numberColor ?? this.numberColor,
      booleanColor: booleanColor ?? this.booleanColor,
      nullColor: nullColor ?? this.nullColor,
      bracketColor: bracketColor ?? this.bracketColor,
      expandIconColor: expandIconColor ?? this.expandIconColor,
      indentGuideColor: indentGuideColor ?? this.indentGuideColor,
      hoverColor: hoverColor ?? this.hoverColor,
      selectedColor: selectedColor ?? this.selectedColor,
      searchMatchColor: searchMatchColor ?? this.searchMatchColor,
      searchMatchTextColor: searchMatchTextColor ?? this.searchMatchTextColor,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      indentWidth: indentWidth ?? this.indentWidth,
      nodeSpacing: nodeSpacing ?? this.nodeSpacing,
      showIndentGuides: showIndentGuides ?? this.showIndentGuides,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
    );
  }
}
