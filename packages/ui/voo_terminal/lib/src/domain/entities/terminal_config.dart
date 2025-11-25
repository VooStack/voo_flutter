import 'package:equatable/equatable.dart';

import 'package:voo_terminal/src/domain/enums/terminal_mode.dart';

/// Configuration options for the terminal widget.
///
/// Use this to customize terminal behavior including mode, scrolling,
/// history, and input handling.
class TerminalConfig extends Equatable {
  /// The terminal display mode.
  final TerminalMode mode;

  /// Maximum number of lines to keep in the buffer.
  ///
  /// Older lines are removed when this limit is exceeded.
  /// Set to null for unlimited (not recommended for long-running terminals).
  final int? maxLines;

  /// Whether to show timestamps on each line.
  final bool showTimestamps;

  /// Format string for timestamps (uses intl DateFormat patterns).
  final String timestampFormat;

  /// Whether to enable command history.
  final bool enableHistory;

  /// Maximum number of commands to keep in history.
  final int historySize;

  /// Whether to automatically scroll to the bottom when new lines are added.
  final bool autoScroll;

  /// The command prompt string to display before user input.
  final String prompt;

  /// Whether to echo user input back as a line.
  final bool echoInput;

  /// Whether to enable text selection.
  final bool enableSelection;

  /// Whether to enable line wrapping.
  final bool enableLineWrap;

  /// Tab size in spaces for tab character expansion.
  final int tabSize;

  /// Whether the terminal should request focus when mounted.
  final bool autofocus;

  /// Whether to show a cursor in interactive mode.
  final bool showCursor;

  /// Creates a terminal configuration.
  const TerminalConfig({
    this.mode = TerminalMode.preview,
    this.maxLines = 1000,
    this.showTimestamps = false,
    this.timestampFormat = 'HH:mm:ss',
    this.enableHistory = true,
    this.historySize = 100,
    this.autoScroll = true,
    this.prompt = r'$ ',
    this.echoInput = true,
    this.enableSelection = true,
    this.enableLineWrap = true,
    this.tabSize = 4,
    this.autofocus = false,
    this.showCursor = true,
  });

  /// Creates a preview-only configuration.
  factory TerminalConfig.preview({
    int? maxLines = 1000,
    bool showTimestamps = false,
    bool autoScroll = true,
    bool enableSelection = true,
  }) {
    return TerminalConfig(
      mode: TerminalMode.preview,
      maxLines: maxLines,
      showTimestamps: showTimestamps,
      autoScroll: autoScroll,
      enableSelection: enableSelection,
      enableHistory: false,
      showCursor: false,
    );
  }

  /// Creates an interactive terminal configuration.
  factory TerminalConfig.interactive({
    int? maxLines = 1000,
    bool showTimestamps = false,
    String prompt = r'$ ',
    bool enableHistory = true,
    int historySize = 100,
    bool autoScroll = true,
    bool autofocus = true,
  }) {
    return TerminalConfig(
      mode: TerminalMode.interactive,
      maxLines: maxLines,
      showTimestamps: showTimestamps,
      prompt: prompt,
      enableHistory: enableHistory,
      historySize: historySize,
      autoScroll: autoScroll,
      autofocus: autofocus,
      showCursor: true,
    );
  }

  /// Creates a hybrid terminal configuration.
  factory TerminalConfig.hybrid({
    int? maxLines = 1000,
    bool showTimestamps = false,
    String prompt = r'$ ',
    bool enableHistory = true,
    bool autoScroll = true,
  }) {
    return TerminalConfig(
      mode: TerminalMode.hybrid,
      maxLines: maxLines,
      showTimestamps: showTimestamps,
      prompt: prompt,
      enableHistory: enableHistory,
      autoScroll: autoScroll,
      showCursor: true,
    );
  }

  /// Whether the terminal is in preview (read-only) mode.
  bool get isPreview => mode == TerminalMode.preview;

  /// Whether the terminal accepts user input.
  bool get acceptsInput =>
      mode == TerminalMode.interactive || mode == TerminalMode.hybrid;

  /// Creates a copy of this configuration with the given fields replaced.
  TerminalConfig copyWith({
    TerminalMode? mode,
    int? maxLines,
    bool? showTimestamps,
    String? timestampFormat,
    bool? enableHistory,
    int? historySize,
    bool? autoScroll,
    String? prompt,
    bool? echoInput,
    bool? enableSelection,
    bool? enableLineWrap,
    int? tabSize,
    bool? autofocus,
    bool? showCursor,
  }) {
    return TerminalConfig(
      mode: mode ?? this.mode,
      maxLines: maxLines ?? this.maxLines,
      showTimestamps: showTimestamps ?? this.showTimestamps,
      timestampFormat: timestampFormat ?? this.timestampFormat,
      enableHistory: enableHistory ?? this.enableHistory,
      historySize: historySize ?? this.historySize,
      autoScroll: autoScroll ?? this.autoScroll,
      prompt: prompt ?? this.prompt,
      echoInput: echoInput ?? this.echoInput,
      enableSelection: enableSelection ?? this.enableSelection,
      enableLineWrap: enableLineWrap ?? this.enableLineWrap,
      tabSize: tabSize ?? this.tabSize,
      autofocus: autofocus ?? this.autofocus,
      showCursor: showCursor ?? this.showCursor,
    );
  }

  @override
  List<Object?> get props => [
        mode,
        maxLines,
        showTimestamps,
        timestampFormat,
        enableHistory,
        historySize,
        autoScroll,
        prompt,
        echoInput,
        enableSelection,
        enableLineWrap,
        tabSize,
        autofocus,
        showCursor,
      ];
}
