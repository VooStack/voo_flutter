import 'package:flutter/material.dart';

import 'package:voo_terminal/src/domain/entities/terminal_theme.dart';
import 'package:voo_terminal/src/presentation/widgets/atoms/window_controls.dart';

/// Optional header bar for the terminal.
///
/// Displays a title and optional action buttons like close, minimize, etc.
class TerminalHeader extends StatelessWidget {
  /// The theme to use for styling.
  final VooTerminalTheme theme;

  /// The title to display.
  final String? title;

  /// Custom title widget (overrides title string).
  final Widget? titleWidget;

  /// Leading widget (e.g., icon).
  final Widget? leading;

  /// Trailing widgets (e.g., action buttons).
  final List<Widget>? actions;

  /// Height of the header. If null, uses theme.headerHeight.
  final double? height;

  /// Padding of the header. If null, uses theme.headerPadding.
  final EdgeInsets? padding;

  /// Callback when close button is pressed.
  final VoidCallback? onClose;

  /// Callback when minimize button is pressed.
  final VoidCallback? onMinimize;

  /// Callback when maximize button is pressed.
  final VoidCallback? onMaximize;

  /// Whether to show window control buttons.
  final bool showWindowControls;

  /// Alignment of the title within the header.
  final TextAlign titleAlignment;

  /// Creates a terminal header.
  const TerminalHeader({
    super.key,
    required this.theme,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.height,
    this.padding,
    this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.showWindowControls = false,
    this.titleAlignment = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? theme.headerHeight;
    final effectivePadding = padding ?? theme.headerPadding;

    return Container(
      height: effectiveHeight,
      decoration: BoxDecoration(
        color: theme.surfaceColor,
        border: Border(
          bottom: BorderSide(
            color: theme.borderColor,
            width: theme.borderWidth,
          ),
        ),
      ),
      padding: effectivePadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showWindowControls) ...[
            WindowControls(
              onClose: onClose,
              onMinimize: onMinimize,
              onMaximize: onMaximize,
            ),
            const SizedBox(width: 8.0),
          ],
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 8.0),
          ],
          Expanded(
            child: titleWidget ??
                (title != null
                    ? Text(
                        title!,
                        style: TextStyle(
                          fontFamily: theme.fontFamily,
                          fontSize: theme.fontSize * theme.headerTitleScale,
                          color: theme.textColor,
                          height: 1.0,
                        ),
                        textAlign: titleAlignment,
                        overflow: TextOverflow.ellipsis,
                      )
                    : const SizedBox.shrink()),
          ),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}
