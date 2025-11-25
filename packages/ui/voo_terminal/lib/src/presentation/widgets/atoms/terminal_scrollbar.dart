import 'package:flutter/material.dart';

import 'package:voo_terminal/src/domain/entities/terminal_theme.dart';

/// A custom-styled scrollbar for the terminal.
///
/// Matches the terminal theme's colors and styling.
class TerminalScrollbar extends StatelessWidget {
  /// The scroll controller to attach to.
  final ScrollController controller;

  /// The theme to use for styling.
  final VooTerminalTheme theme;

  /// The child widget to wrap with the scrollbar.
  final Widget child;

  /// Creates a terminal scrollbar.
  const TerminalScrollbar({
    super.key,
    required this.controller,
    required this.theme,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      controller: controller,
      thumbColor: theme.scrollbarColor,
      thickness: theme.scrollbarWidth,
      radius: Radius.circular(theme.scrollbarWidth / 2),
      thumbVisibility: theme.alwaysShowScrollbar,
      child: child,
    );
  }
}
