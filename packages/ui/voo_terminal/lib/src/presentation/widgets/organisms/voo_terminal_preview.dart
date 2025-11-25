import 'package:flutter/material.dart';

import 'package:voo_terminal/src/domain/entities/terminal_line.dart';
import 'package:voo_terminal/src/domain/entities/terminal_theme.dart';
import 'package:voo_terminal/src/presentation/widgets/atoms/terminal_line_widget.dart';
import 'package:voo_terminal/src/presentation/widgets/molecules/terminal_header.dart';
import 'package:voo_terminal/src/presentation/widgets/molecules/terminal_output.dart';

/// A read-only terminal widget for displaying output.
///
/// Use this widget when you need a simple terminal display without
/// user input capabilities.
///
/// ## Basic Usage
///
/// ```dart
/// VooTerminalPreview(
///   lines: [
///     TerminalLine.output('Hello, World!'),
///     TerminalLine.success('Operation completed'),
///     TerminalLine.error('Something went wrong'),
///   ],
///   theme: VooTerminalTheme.classic(),
/// )
/// ```
class VooTerminalPreview extends StatefulWidget {
  /// The lines to display.
  final List<TerminalLine> lines;

  /// The theme to use for styling.
  final VooTerminalTheme? theme;

  /// Whether to show timestamps on each line.
  final bool showTimestamps;

  /// Timestamp format string.
  final String timestampFormat;

  /// Whether text can be selected.
  final bool enableSelection;

  /// Whether to auto-scroll to the bottom when lines are added.
  final bool autoScroll;

  /// Optional header title.
  final String? title;

  /// Whether to show the header.
  final bool showHeader;

  /// Whether to show window controls in the header.
  final bool showWindowControls;

  /// Custom header widget.
  final Widget? header;

  /// Creates a terminal preview widget.
  const VooTerminalPreview({
    super.key,
    required this.lines,
    this.theme,
    this.showTimestamps = false,
    this.timestampFormat = 'HH:mm:ss',
    this.enableSelection = true,
    this.autoScroll = true,
    this.title,
    this.showHeader = false,
    this.showWindowControls = false,
    this.header,
  });

  @override
  State<VooTerminalPreview> createState() => _VooTerminalPreviewState();
}

class _VooTerminalPreviewState extends State<VooTerminalPreview> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(VooTerminalPreview oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.autoScroll && widget.lines.length > oldWidget.lines.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(
            _scrollController.position.maxScrollExtent,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = widget.theme ??
        VooTerminalTheme.fromTheme(Theme.of(context));

    return Semantics(
      label: 'Terminal Output',
      child: Container(
        decoration: BoxDecoration(
          color: effectiveTheme.backgroundColor,
          borderRadius: effectiveTheme.borderRadius,
          border: effectiveTheme.showBorder
              ? Border.all(
                  color: effectiveTheme.borderColor,
                  width: effectiveTheme.borderWidth,
                )
              : null,
        ),
        child: ClipRRect(
          borderRadius: effectiveTheme.borderRadius,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.showHeader || widget.header != null)
                widget.header ??
                    TerminalHeader(
                      theme: effectiveTheme,
                      title: widget.title,
                      showWindowControls: widget.showWindowControls,
                    ),
              Expanded(
                child: _buildBody(effectiveTheme),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(VooTerminalTheme theme) {
    Widget body = Padding(
      padding: theme.padding,
      child: TerminalOutput(
        lines: widget.lines,
        theme: theme,
        scrollController: _scrollController,
        showTimestamps: widget.showTimestamps,
        timestampFormat: widget.timestampFormat,
        enableSelection: widget.enableSelection,
      ),
    );

    // Apply scanline overlay if enabled
    if (theme.enableScanlines) {
      body = ScanlineOverlay(theme: theme, child: body);
    }

    return body;
  }
}

/// A compact terminal line display for inline usage.
///
/// Displays a single line without the full terminal chrome.
class TerminalLinePreview extends StatelessWidget {
  /// The line to display.
  final TerminalLine line;

  /// The theme to use for styling.
  final VooTerminalTheme? theme;

  /// Whether to show the timestamp.
  final bool showTimestamp;

  /// Timestamp format string.
  final String timestampFormat;

  /// Creates a terminal line preview.
  const TerminalLinePreview({
    super.key,
    required this.line,
    this.theme,
    this.showTimestamp = false,
    this.timestampFormat = 'HH:mm:ss',
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ??
        VooTerminalTheme.fromTheme(Theme.of(context));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: effectiveTheme.backgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: TerminalLineWidget(
        line: line,
        theme: effectiveTheme,
        showTimestamp: showTimestamp,
        timestampFormat: timestampFormat,
      ),
    );
  }
}
