import 'dart:async';

import 'package:flutter/material.dart';

import 'package:voo_terminal/src/domain/entities/terminal_command.dart';
import 'package:voo_terminal/src/domain/entities/terminal_config.dart';
import 'package:voo_terminal/src/domain/entities/terminal_line.dart';
import 'package:voo_terminal/src/domain/entities/terminal_theme.dart';
import 'package:voo_terminal/src/domain/enums/line_type.dart';
import 'package:voo_terminal/src/presentation/controllers/terminal_controller.dart';
import 'package:voo_terminal/src/presentation/widgets/molecules/terminal_header.dart';
import 'package:voo_terminal/src/presentation/widgets/molecules/terminal_input.dart';
import 'package:voo_terminal/src/presentation/widgets/molecules/terminal_output.dart';

/// A full-featured terminal widget.
///
/// Supports preview, interactive, and hybrid modes with customizable
/// commands, theming, and callbacks.
///
/// ## Basic Usage
///
/// ```dart
/// final controller = TerminalController();
///
/// VooTerminal(
///   controller: controller,
///   config: TerminalConfig.interactive(),
///   theme: VooTerminalTheme.classic(),
/// )
/// ```
///
/// ## With Custom Commands
///
/// ```dart
/// VooTerminal(
///   controller: controller,
///   config: TerminalConfig.interactive(),
///   commands: [
///     TerminalCommand(
///       name: 'hello',
///       handler: (args) => 'Hello, ${args.join(' ')}!',
///     ),
///   ],
/// )
/// ```
class VooTerminal extends StatefulWidget {
  /// The terminal controller.
  ///
  /// If not provided, an internal controller will be created.
  final TerminalController? controller;

  /// The terminal configuration.
  final TerminalConfig config;

  /// The theme to use for styling.
  final VooTerminalTheme? theme;

  /// Commands to register with the terminal.
  final List<TerminalCommand>? commands;

  /// Initial lines to display.
  final List<TerminalLine>? initialLines;

  /// Callback when a command is submitted.
  final void Function(String command, List<String> args)? onCommand;

  /// Callback when a line is added.
  final void Function(TerminalLine line)? onLineAdded;

  /// Optional header title.
  final String? title;

  /// Whether to show the header.
  final bool showHeader;

  /// Whether to show window controls in the header.
  final bool showWindowControls;

  /// Callback when the close button is pressed.
  final VoidCallback? onClose;

  /// Callback when the minimize button is pressed.
  final VoidCallback? onMinimize;

  /// Callback when the maximize button is pressed.
  final VoidCallback? onMaximize;

  /// Custom header widget.
  final Widget? header;

  /// Creates a terminal widget.
  const VooTerminal({
    super.key,
    this.controller,
    this.config = const TerminalConfig(),
    this.theme,
    this.commands,
    this.initialLines,
    this.onCommand,
    this.onLineAdded,
    this.title,
    this.showHeader = false,
    this.showWindowControls = false,
    this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.header,
  });

  /// Creates a preview-only terminal.
  factory VooTerminal.preview({
    Key? key,
    List<TerminalLine>? lines,
    VooTerminalTheme? theme,
    String? title,
    bool showHeader = false,
    bool showWindowControls = false,
    VoidCallback? onClose,
    VoidCallback? onMinimize,
    VoidCallback? onMaximize,
  }) {
    return VooTerminal(
      key: key,
      config: TerminalConfig.preview(),
      theme: theme,
      initialLines: lines,
      title: title,
      showHeader: showHeader,
      showWindowControls: showWindowControls,
      onClose: onClose,
      onMinimize: onMinimize,
      onMaximize: onMaximize,
    );
  }

  /// Creates an interactive terminal.
  factory VooTerminal.interactive({
    Key? key,
    TerminalController? controller,
    List<TerminalCommand>? commands,
    VooTerminalTheme? theme,
    String prompt = r'$ ',
    void Function(String command, List<String> args)? onCommand,
    String? title,
    bool showHeader = false,
    bool showWindowControls = false,
    VoidCallback? onClose,
    VoidCallback? onMinimize,
    VoidCallback? onMaximize,
  }) {
    return VooTerminal(
      key: key,
      controller: controller,
      config: TerminalConfig.interactive(prompt: prompt),
      theme: theme,
      commands: commands,
      onCommand: onCommand,
      title: title,
      showHeader: showHeader,
      showWindowControls: showWindowControls,
      onClose: onClose,
      onMinimize: onMinimize,
      onMaximize: onMaximize,
    );
  }

  /// Creates a terminal that displays from a stream.
  factory VooTerminal.stream({
    Key? key,
    required Stream<String> stream,
    VooTerminalTheme? theme,
    LineType lineType = LineType.output,
    String? title,
    bool showHeader = false,
    bool showWindowControls = false,
    VoidCallback? onClose,
    VoidCallback? onMinimize,
    VoidCallback? onMaximize,
  }) {
    final controller = TerminalController(
      config: TerminalConfig.preview(),
    );
    controller.attachStream(stream, type: lineType);

    return VooTerminal(
      key: key,
      controller: controller,
      config: TerminalConfig.preview(),
      theme: theme,
      title: title,
      showHeader: showHeader,
      showWindowControls: showWindowControls,
      onClose: onClose,
      onMinimize: onMinimize,
      onMaximize: onMaximize,
    );
  }

  @override
  State<VooTerminal> createState() => _VooTerminalState();
}

class _VooTerminalState extends State<VooTerminal> {
  late TerminalController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    if (widget.controller != null) {
      _controller = widget.controller!;
      _ownsController = false;
    } else {
      _controller = TerminalController(
        config: widget.config,
        commands: widget.commands,
      );
      _ownsController = true;
    }

    _controller.updateConfig(widget.config);

    if (widget.commands != null) {
      _controller.registerCommands(widget.commands!);
    }

    if (widget.initialLines != null) {
      _controller.addLines(widget.initialLines!);
    }

    _controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    setState(() {});
  }

  @override
  void didUpdateWidget(VooTerminal oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      _controller.removeListener(_onControllerChanged);
      if (_ownsController) {
        _controller.dispose();
      }
      _initController();
    }

    if (widget.config != oldWidget.config) {
      _controller.updateConfig(widget.config);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use theme from context if not provided
    final effectiveTheme = widget.theme ??
        VooTerminalTheme.fromTheme(Theme.of(context));

    return Semantics(
      label: 'Terminal',
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
                      onClose: widget.onClose,
                      onMinimize: widget.onMinimize,
                      onMaximize: widget.onMaximize,
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
    // Apply scanline effect if enabled
    Widget body = Padding(
      padding: theme.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: TerminalOutput(
              lines: _controller.lines,
              theme: theme,
              scrollController: _controller.scrollController,
              showTimestamps: widget.config.showTimestamps,
              timestampFormat: widget.config.timestampFormat,
              enableSelection: widget.config.enableSelection,
            ),
          ),
          if (widget.config.acceptsInput) ...[
            const SizedBox(height: 4.0),
            TerminalInput(
              controller: _controller,
              theme: theme,
              prompt: widget.config.prompt,
              showCursor: widget.config.showCursor,
              onSubmit: _handleSubmit,
            ),
          ],
        ],
      ),
    );

    // Apply scanline overlay if retro theme
    if (theme.enableScanlines) {
      body = ScanlineOverlay(theme: theme, child: body);
    }

    return GestureDetector(
      onTap: () {
        if (widget.config.acceptsInput) {
          _controller.requestFocus();
        }
      },
      child: body,
    );
  }

  void _handleSubmit() {
    final input = _controller.textController.text.trim();
    if (input.isEmpty) return;

    final parts = input.split(RegExp(r'\s+'));
    if (parts.isEmpty) return;

    widget.onCommand?.call(parts[0], parts.skip(1).toList());
  }
}
