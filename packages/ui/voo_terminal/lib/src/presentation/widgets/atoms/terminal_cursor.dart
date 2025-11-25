import 'package:flutter/material.dart';

import 'package:voo_terminal/src/domain/entities/terminal_theme.dart';

/// A blinking cursor widget for the terminal.
///
/// Displays a vertical bar that blinks at the specified rate.
class TerminalCursor extends StatefulWidget {
  /// The theme to use for styling.
  final VooTerminalTheme theme;

  /// The height of the cursor (typically matches line height).
  final double height;

  /// Whether the cursor is visible.
  final bool isVisible;

  /// Creates a terminal cursor.
  const TerminalCursor({
    super.key,
    required this.theme,
    required this.height,
    this.isVisible = true,
  });

  @override
  State<TerminalCursor> createState() => _TerminalCursorState();
}

class _TerminalCursorState extends State<TerminalCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
    _controller = AnimationController(
      duration: widget.theme.cursorBlinkRate,
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.theme.cursorBlinks && widget.isVisible) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(TerminalCursor oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.theme.cursorBlinkRate != widget.theme.cursorBlinkRate ||
        oldWidget.theme.cursorBlinks != widget.theme.cursorBlinks) {
      _controller.dispose();
      _setupAnimation();
    }

    if (widget.theme.cursorBlinks && widget.isVisible) {
      if (!_controller.isAnimating) {
        _controller.repeat(reverse: true);
      }
    } else {
      _controller.stop();
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) {
      return SizedBox(width: widget.theme.cursorWidth, height: widget.height);
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.theme.cursorWidth,
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.theme.cursorColor.withValues(alpha: _animation.value),
            boxShadow: widget.theme.enableGlow
                ? [
                    BoxShadow(
                      color: widget.theme.cursorColor.withValues(
                        alpha: _animation.value * 0.5,
                      ),
                      blurRadius: widget.theme.glowBlur,
                      spreadRadius: widget.theme.glowSpread,
                    ),
                  ]
                : null,
          ),
        );
      },
    );
  }
}
