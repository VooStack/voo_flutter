import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:voo_terminal/src/domain/entities/terminal_line.dart';
import 'package:voo_terminal/src/domain/entities/terminal_theme.dart';
import 'package:voo_terminal/src/domain/enums/line_type.dart';

/// A widget that renders a single terminal line.
///
/// Handles styling based on line type and theme, including optional
/// timestamps and glow effects.
class TerminalLineWidget extends StatelessWidget {
  /// The line to render.
  final TerminalLine line;

  /// The theme to use for styling.
  final VooTerminalTheme theme;

  /// Whether to show timestamps.
  final bool showTimestamp;

  /// Timestamp format string.
  final String timestampFormat;

  /// Whether text can be selected.
  final bool enableSelection;

  /// Whether to use theme-based prefixes instead of line's own prefix.
  ///
  /// When true, uses [VooTerminalTheme.prefixForLineType] for the prefix.
  /// When false, uses [TerminalLine.displayText] which includes line's prefix.
  final bool useThemePrefixes;

  /// Creates a terminal line widget.
  const TerminalLineWidget({
    super.key,
    required this.line,
    required this.theme,
    this.showTimestamp = false,
    this.timestampFormat = 'HH:mm:ss',
    this.enableSelection = true,
    this.useThemePrefixes = true,
  });

  /// Gets the text to display for this line.
  ///
  /// Uses theme prefix when [useThemePrefixes] is true, otherwise uses line's
  /// own displayText.
  String get _displayText {
    if (useThemePrefixes) {
      // If line has a custom prefix set, use it; otherwise use theme prefix
      final prefix = line.prefix ?? theme.prefixForLineType(line.type);
      return '$prefix${line.content}';
    }
    return line.displayText;
  }

  @override
  Widget build(BuildContext context) {
    final textColor = _getColorForLineType();
    final textStyle = theme.textStyle.copyWith(
      color: textColor,
      fontWeight: line.fontWeight ?? theme.fontWeight,
    );

    Widget textWidget = Text(
      _displayText,
      style: textStyle,
      softWrap: true,
    );

    // Apply glow effect if enabled
    if (theme.enableGlow) {
      textWidget = _buildGlowText(textWidget, textColor);
    }

    // Make selectable if enabled
    if (enableSelection && line.isSelectable) {
      textWidget = SelectableText(
        _displayText,
        style: textStyle,
      );

      if (theme.enableGlow) {
        textWidget = _buildGlowText(textWidget, textColor);
      }
    }

    // Add timestamp if configured
    if (showTimestamp) {
      final timestamp = DateFormat(timestampFormat).format(line.timestamp);
      final timestampStyle = textStyle.copyWith(
        color: theme.timestampColor ?? theme.systemColor,
        fontSize: theme.fontSize * theme.timestampScale,
      );

      return Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            '[$timestamp] ',
            style: timestampStyle,
          ),
          Expanded(child: textWidget),
        ],
      );
    }

    // Add background if specified
    if (line.backgroundColor != null) {
      return Container(
        color: line.backgroundColor,
        child: textWidget,
      );
    }

    return textWidget;
  }

  Color _getColorForLineType() {
    // Use custom color if specified
    if (line.textColor != null) {
      return line.textColor!;
    }

    // Use type-based color
    switch (line.type) {
      case LineType.output:
        return theme.textColor;
      case LineType.input:
        return theme.inputColor;
      case LineType.error:
        return theme.errorColor;
      case LineType.warning:
        return theme.warningColor;
      case LineType.success:
        return theme.successColor;
      case LineType.system:
        return theme.systemColor;
      case LineType.info:
        return theme.infoColor;
      case LineType.debug:
        return theme.debugColor;
    }
  }

  Widget _buildGlowText(Widget child, Color color) {
    return Stack(
      children: [
        // Glow layer
        Positioned.fill(
          child: ImageFiltered(
            imageFilter: ColorFilter.mode(
              color.withValues(alpha: 0.5),
              BlendMode.srcATop,
            ),
            child: Opacity(
              opacity: 0.5,
              child: child,
            ),
          ),
        ),
        // Main text
        child,
      ],
    );
  }
}
