import 'package:flutter/material.dart';

import 'package:voo_terminal/src/domain/entities/terminal_line.dart';
import 'package:voo_terminal/src/domain/entities/terminal_theme.dart';
import 'package:voo_terminal/src/presentation/widgets/atoms/terminal_line_widget.dart';
import 'package:voo_terminal/src/presentation/widgets/atoms/terminal_scrollbar.dart';

/// Scrollable output area for terminal lines.
///
/// Renders all terminal lines with optional timestamps and selection.
class TerminalOutput extends StatelessWidget {
  /// The lines to display.
  final List<TerminalLine> lines;

  /// The theme to use for styling.
  final VooTerminalTheme theme;

  /// The scroll controller.
  final ScrollController scrollController;

  /// Whether to show timestamps.
  final bool showTimestamps;

  /// Timestamp format string.
  final String timestampFormat;

  /// Whether text can be selected.
  final bool enableSelection;

  /// Creates a terminal output widget.
  const TerminalOutput({
    super.key,
    required this.lines,
    required this.theme,
    required this.scrollController,
    this.showTimestamps = false,
    this.timestampFormat = 'HH:mm:ss',
    this.enableSelection = true,
  });

  @override
  Widget build(BuildContext context) {
    if (lines.isEmpty) {
      return const SizedBox.shrink();
    }

    Widget listView = ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.zero,
      itemCount: lines.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: index < lines.length - 1 ? theme.lineSpacing : 0.0,
          ),
          child: TerminalLineWidget(
            line: lines[index],
            theme: theme,
            showTimestamp: showTimestamps,
            timestampFormat: timestampFormat,
            enableSelection: false,
          ),
        );
      },
    );

    Widget content = TerminalScrollbar(
      controller: scrollController,
      theme: theme,
      child: listView,
    );

    // Wrap in SelectionArea for multi-line text selection
    if (enableSelection) {
      content = SelectionArea(child: content);
    }

    return content;
  }
}

/// A scanline overlay effect for retro terminals.
class ScanlineOverlay extends StatelessWidget {
  /// The theme to use for styling.
  final VooTerminalTheme theme;

  /// The child widget to overlay.
  final Widget child;

  /// Creates a scanline overlay.
  const ScanlineOverlay({
    super.key,
    required this.theme,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!theme.enableScanlines) {
      return child;
    }

    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _ScanlinePainter(
                opacity: theme.scanlineOpacity,
                spacing: theme.scanlineSpacing,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ScanlinePainter extends CustomPainter {
  final double opacity;
  final double spacing;

  _ScanlinePainter({
    required this.opacity,
    required this.spacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: opacity)
      ..strokeWidth = 1;

    for (var y = 0.0; y < size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ScanlinePainter oldDelegate) {
    return oldDelegate.opacity != opacity || oldDelegate.spacing != spacing;
  }
}
