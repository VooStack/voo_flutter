import 'dart:async';

import 'package:flutter/material.dart';

import 'package:voo_terminal/src/domain/entities/terminal_command.dart';
import 'package:voo_terminal/src/domain/entities/terminal_config.dart';
import 'package:voo_terminal/src/domain/entities/terminal_line.dart';
import 'package:voo_terminal/src/domain/enums/line_type.dart';

/// Controller for managing terminal state and operations.
///
/// Use this controller to programmatically interact with the terminal,
/// including writing output, managing history, and handling commands.
///
/// ```dart
/// final controller = TerminalController();
///
/// // Write output
/// controller.writeLine('Hello, World!');
/// controller.writeError('Something went wrong');
/// controller.writeSuccess('Operation completed');
///
/// // Clear terminal
/// controller.clear();
///
/// // Navigate
/// controller.scrollToBottom();
/// ```
class TerminalController extends ChangeNotifier {
  /// The terminal configuration.
  TerminalConfig _config;

  /// Buffer of terminal lines.
  final List<TerminalLine> _lines = [];

  /// Command history.
  final List<String> _history = [];

  /// Current position in history navigation.
  int _historyIndex = -1;

  /// Current input text.
  String _currentInput = '';

  /// Registered commands.
  final Map<String, TerminalCommand> _commands = {};

  /// Scroll controller for the terminal output.
  final ScrollController scrollController = ScrollController();

  /// Focus node for the terminal input.
  final FocusNode focusNode = FocusNode();

  /// Text editing controller for the input field.
  final TextEditingController textController = TextEditingController();

  /// Stream subscription for external input streams.
  StreamSubscription<String>? _streamSubscription;

  /// Creates a terminal controller.
  TerminalController({
    TerminalConfig? config,
    List<TerminalCommand>? commands,
  }) : _config = config ?? const TerminalConfig() {
    if (commands != null) {
      for (final command in commands) {
        registerCommand(command);
      }
    }
    _registerBuiltInCommands();
  }

  /// The current configuration.
  TerminalConfig get config => _config;

  /// All lines in the terminal buffer.
  List<TerminalLine> get lines => List.unmodifiable(_lines);

  /// The command history.
  List<String> get commandHistory => List.unmodifiable(_history);

  /// Current input text.
  String get currentInput => _currentInput;

  /// Number of lines in the buffer.
  int get lineCount => _lines.length;

  /// Whether the terminal has any lines.
  bool get isEmpty => _lines.isEmpty;

  /// Whether the terminal has content.
  bool get isNotEmpty => _lines.isNotEmpty;

  /// Updates the terminal configuration.
  void updateConfig(TerminalConfig config) {
    _config = config;
    notifyListeners();
  }

  // ==================== Line Management ====================

  /// Adds a line to the terminal.
  void addLine(TerminalLine line) {
    _lines.add(line);
    _trimBuffer();
    notifyListeners();
    if (_config.autoScroll) {
      _scrollToBottomDeferred();
    }
  }

  /// Adds multiple lines to the terminal.
  void addLines(List<TerminalLine> lines) {
    _lines.addAll(lines);
    _trimBuffer();
    notifyListeners();
    if (_config.autoScroll) {
      _scrollToBottomDeferred();
    }
  }

  /// Writes text as a standard output line.
  void write(String text) {
    addLine(TerminalLine.output(text));
  }

  /// Writes text followed by a newline.
  void writeLine(String text) {
    write(text);
  }

  /// Writes multiple lines.
  void writeLines(List<String> lines) {
    addLines(lines.map((text) => TerminalLine.output(text)).toList());
  }

  /// Writes an error message.
  void writeError(String text) {
    addLine(TerminalLine.error(text));
  }

  /// Writes a warning message.
  void writeWarning(String text) {
    addLine(TerminalLine.warning(text));
  }

  /// Writes a success message.
  void writeSuccess(String text) {
    addLine(TerminalLine.success(text));
  }

  /// Writes a system message.
  void writeSystem(String text) {
    addLine(TerminalLine.system(text));
  }

  /// Writes an info message.
  void writeInfo(String text) {
    addLine(TerminalLine.info(text));
  }

  /// Writes a debug message.
  void writeDebug(String text) {
    addLine(TerminalLine.debug(text));
  }

  /// Clears all lines from the terminal.
  void clear() {
    _lines.clear();
    notifyListeners();
  }

  /// Removes lines matching the given predicate.
  void removeWhere(bool Function(TerminalLine line) test) {
    _lines.removeWhere(test);
    notifyListeners();
  }

  void _trimBuffer() {
    if (_config.maxLines != null && _lines.length > _config.maxLines!) {
      _lines.removeRange(0, _lines.length - _config.maxLines!);
    }
  }

  // ==================== Input Handling ====================

  /// Sets the current input text.
  void setInput(String text) {
    _currentInput = text;
    textController.text = text;
    textController.selection = TextSelection.fromPosition(
      TextPosition(offset: text.length),
    );
    notifyListeners();
  }

  /// Submits the current input as a command.
  Future<void> submit() async {
    final input = textController.text.trim();
    if (input.isEmpty) return;

    // Echo input if configured
    if (_config.echoInput) {
      addLine(TerminalLine.input(input, prompt: _config.prompt));
    }

    // Add to history
    if (_config.enableHistory && input.isNotEmpty) {
      _addToHistory(input);
    }

    // Clear input
    textController.clear();
    _currentInput = '';
    _historyIndex = -1;

    // Execute command
    await _executeCommand(input);

    notifyListeners();
  }

  /// Handles key events for history navigation.
  void navigateHistoryUp() {
    if (!_config.enableHistory || _history.isEmpty) return;

    if (_historyIndex < _history.length - 1) {
      _historyIndex++;
      setInput(_history[_history.length - 1 - _historyIndex]);
    }
  }

  /// Navigates down through command history.
  void navigateHistoryDown() {
    if (!_config.enableHistory) return;

    if (_historyIndex > 0) {
      _historyIndex--;
      setInput(_history[_history.length - 1 - _historyIndex]);
    } else if (_historyIndex == 0) {
      _historyIndex = -1;
      setInput('');
    }
  }

  void _addToHistory(String command) {
    // Don't add duplicates of the last command
    if (_history.isNotEmpty && _history.last == command) return;

    _history.add(command);

    // Trim history if needed
    if (_history.length > _config.historySize) {
      _history.removeAt(0);
    }
  }

  /// Clears command history.
  void clearHistory() {
    _history.clear();
    _historyIndex = -1;
    notifyListeners();
  }

  // ==================== Command System ====================

  /// Registers a command.
  void registerCommand(TerminalCommand command) {
    _commands[command.name.toLowerCase()] = command;
    for (final alias in command.aliases) {
      _commands[alias.toLowerCase()] = command;
    }
  }

  /// Registers multiple commands.
  void registerCommands(List<TerminalCommand> commands) {
    for (final command in commands) {
      registerCommand(command);
    }
  }

  /// Unregisters a command by name.
  void unregisterCommand(String name) {
    final command = _commands[name.toLowerCase()];
    if (command != null) {
      _commands.remove(command.name.toLowerCase());
      for (final alias in command.aliases) {
        _commands.remove(alias.toLowerCase());
      }
    }
  }

  /// Gets all registered commands.
  List<TerminalCommand> get commands {
    final uniqueCommands = <String, TerminalCommand>{};
    for (final command in _commands.values) {
      uniqueCommands[command.name] = command;
    }
    return uniqueCommands.values.toList();
  }

  /// Gets command suggestions for the given prefix.
  List<String> getSuggestions(String prefix) {
    if (prefix.isEmpty) return [];

    final lowerPrefix = prefix.toLowerCase();
    final suggestions = <String>[];

    for (final command in commands) {
      if (command.name.toLowerCase().startsWith(lowerPrefix)) {
        suggestions.add(command.name);
      }
      for (final alias in command.aliases) {
        if (alias.toLowerCase().startsWith(lowerPrefix)) {
          suggestions.add(alias);
        }
      }
    }

    return suggestions..sort();
  }

  Future<void> _executeCommand(String input) async {
    final parts = input.split(RegExp(r'\s+'));
    if (parts.isEmpty) return;

    final commandName = parts[0].toLowerCase();
    final args = parts.skip(1).toList();

    final command = _commands[commandName];
    if (command != null) {
      final result = await command.execute(args);
      if (result.success && result.output != null) {
        writeLine(result.output!);
      } else if (!result.success && result.errorMessage != null) {
        writeError(result.errorMessage!);
      }
    } else {
      writeError('Unknown command: $commandName');
    }
  }

  void _registerBuiltInCommands() {
    registerCommand(TerminalCommand(
      name: 'clear',
      aliases: ['cls'],
      description: 'Clear the terminal screen',
      handler: (_) {
        clear();
        return const CommandResult.empty();
      },
    ));

    registerCommand(TerminalCommand(
      name: 'help',
      aliases: ['?'],
      description: 'Show available commands',
      usage: 'help [command]',
      handler: (args) {
        if (args.isNotEmpty) {
          final commandName = args[0].toLowerCase();
          final command = _commands[commandName];
          if (command != null) {
            return CommandResult.success(command.helpText);
          }
          return CommandResult.error('Unknown command: $commandName');
        }

        final visibleCommands = commands.where((c) => !c.isHidden).toList()
          ..sort((a, b) => a.name.compareTo(b.name));

        if (visibleCommands.isEmpty) {
          return const CommandResult.success('No commands available');
        }

        final buffer = StringBuffer('Available commands:\n');
        for (final command in visibleCommands) {
          buffer.writeln('  ${command.name}: ${command.description}');
        }
        return CommandResult.success(buffer.toString().trimRight());
      },
    ));

    registerCommand(TerminalCommand(
      name: 'history',
      description: 'Show command history',
      handler: (_) {
        if (_history.isEmpty) {
          return const CommandResult.success('No history');
        }

        final buffer = StringBuffer();
        for (var i = 0; i < _history.length; i++) {
          buffer.writeln('${i + 1}: ${_history[i]}');
        }
        return CommandResult.success(buffer.toString().trimRight());
      },
    ));

    registerCommand(TerminalCommand(
      name: 'echo',
      description: 'Echo text back to the terminal',
      usage: 'echo <text>',
      handler: (args) {
        if (args.isEmpty) {
          return const CommandResult.success('');
        }
        return CommandResult.success(args.join(' '));
      },
    ));
  }

  // ==================== Navigation ====================

  /// Scrolls to the top of the terminal.
  void scrollToTop() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(0);
    }
  }

  /// Scrolls to the bottom of the terminal.
  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }

  /// Scrolls to the bottom after the frame is rendered.
  void _scrollToBottomDeferred() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom();
    });
  }

  // ==================== Stream Support ====================

  /// Attaches a stream as input source.
  ///
  /// Lines from the stream are added to the terminal output.
  void attachStream(Stream<String> stream, {LineType type = LineType.output}) {
    detachStream();
    _streamSubscription = stream.listen((text) {
      addLine(TerminalLine.create(content: text, type: type));
    });
  }

  /// Detaches the current input stream.
  void detachStream() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  /// Requests focus for the terminal input.
  void requestFocus() {
    focusNode.requestFocus();
  }

  @override
  void dispose() {
    detachStream();
    scrollController.dispose();
    focusNode.dispose();
    textController.dispose();
    super.dispose();
  }
}
