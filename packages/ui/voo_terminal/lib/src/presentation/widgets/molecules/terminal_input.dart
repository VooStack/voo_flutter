import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:voo_terminal/src/domain/entities/terminal_theme.dart';
import 'package:voo_terminal/src/presentation/controllers/terminal_controller.dart';
import 'package:voo_terminal/src/presentation/widgets/atoms/terminal_cursor.dart';
import 'package:voo_terminal/src/presentation/widgets/atoms/terminal_prompt.dart';

/// Input line widget with prompt, text field, and cursor.
///
/// Handles user input, history navigation, and command submission.
class TerminalInput extends StatefulWidget {
  /// The terminal controller.
  final TerminalController controller;

  /// The theme to use for styling.
  final VooTerminalTheme theme;

  /// The prompt string to display.
  final String prompt;

  /// Whether to show the cursor.
  final bool showCursor;

  /// Callback when a command is submitted.
  final VoidCallback? onSubmit;

  /// Creates a terminal input widget.
  const TerminalInput({
    super.key,
    required this.controller,
    required this.theme,
    required this.prompt,
    this.showCursor = true,
    this.onSubmit,
  });

  @override
  State<TerminalInput> createState() => _TerminalInputState();
}

class _TerminalInputState extends State<TerminalInput> {
  @override
  Widget build(BuildContext context) {
    final textStyle = widget.theme.textStyle.copyWith(
      color: widget.theme.inputColor,
    );

    return Container(
      color: widget.theme.backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TerminalPrompt(
            prompt: widget.prompt,
            theme: widget.theme,
          ),
          Expanded(
            child: KeyboardListener(
              focusNode: widget.controller.focusNode,
              onKeyEvent: _handleKeyEvent,
              child: EditableText(
                controller: widget.controller.textController,
                focusNode: FocusNode(),
                style: textStyle,
                cursorColor: Colors.transparent,
                backgroundCursorColor: Colors.transparent,
                selectionColor: widget.theme.selectionColor,
                onSubmitted: (_) => _submit(),
                maxLines: null,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.send,
              ),
            ),
          ),
          if (widget.showCursor)
            TerminalCursor(
              theme: widget.theme,
              height: widget.theme.fontSize * widget.theme.lineHeight,
              isVisible: widget.controller.focusNode.hasFocus,
            ),
        ],
      ),
    );
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      widget.controller.navigateHistoryUp();
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      widget.controller.navigateHistoryDown();
    } else if (event.logicalKey == LogicalKeyboardKey.enter) {
      _submit();
    }
  }

  void _submit() {
    widget.controller.submit();
    widget.onSubmit?.call();
  }
}
