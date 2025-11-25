import 'package:flutter/material.dart';

import 'package:voo_terminal/src/domain/entities/terminal_theme.dart';

/// A widget that renders the command prompt indicator.
///
/// Displays the prompt string (e.g., "$ " or "> ") before user input.
class TerminalPrompt extends StatelessWidget {
  /// The prompt string to display.
  final String prompt;

  /// The theme to use for styling.
  final VooTerminalTheme theme;

  /// Optional custom color for the prompt.
  final Color? color;

  /// Creates a terminal prompt widget.
  const TerminalPrompt({
    super.key,
    required this.prompt,
    required this.theme,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final promptColor = color ?? theme.inputColor;
    final textStyle = theme.textStyle.copyWith(
      color: promptColor,
      fontWeight: FontWeight.bold,
    );

    Widget text = Text(
      prompt,
      style: textStyle,
    );

    // Apply glow effect if enabled
    if (theme.enableGlow) {
      text = Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: promptColor.withValues(alpha: 0.3),
              blurRadius: theme.glowBlur,
              spreadRadius: 0,
            ),
          ],
        ),
        child: text,
      );
    }

    return text;
  }
}
