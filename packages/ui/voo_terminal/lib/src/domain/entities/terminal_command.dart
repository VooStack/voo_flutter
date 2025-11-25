import 'package:equatable/equatable.dart';

/// Result of executing a terminal command.
class CommandResult {
  /// The output text to display.
  final String? output;

  /// Whether the command executed successfully.
  final bool success;

  /// Optional error message if the command failed.
  final String? errorMessage;

  /// Creates a successful command result.
  const CommandResult.success([this.output])
      : success = true,
        errorMessage = null;

  /// Creates a failed command result.
  const CommandResult.error(this.errorMessage)
      : success = false,
        output = null;

  /// Creates an empty result (command produced no output).
  const CommandResult.empty()
      : success = true,
        output = null,
        errorMessage = null;
}

/// Type definition for command handler functions.
///
/// The handler receives a list of arguments and returns a [CommandResult]
/// or a [Future<CommandResult>] for async operations.
typedef CommandHandler = dynamic Function(List<String> args);

/// Represents a terminal command that can be executed.
///
/// Commands have a name, optional aliases, and a handler function
/// that processes the command arguments and returns output.
class TerminalCommand extends Equatable {
  /// The primary name of the command.
  final String name;

  /// Alternative names for this command.
  final List<String> aliases;

  /// A brief description of what the command does.
  final String description;

  /// Detailed usage instructions.
  final String? usage;

  /// The function that handles command execution.
  final CommandHandler handler;

  /// Whether this command is hidden from help listings.
  final bool isHidden;

  /// Creates a terminal command.
  const TerminalCommand({
    required this.name,
    required this.handler,
    this.aliases = const [],
    this.description = '',
    this.usage,
    this.isHidden = false,
  });

  /// Creates a simple command that returns a string.
  factory TerminalCommand.simple({
    required String name,
    required String Function(List<String> args) handler,
    List<String> aliases = const [],
    String description = '',
    String? usage,
  }) {
    return TerminalCommand(
      name: name,
      aliases: aliases,
      description: description,
      usage: usage,
      handler: (args) => CommandResult.success(handler(args)),
    );
  }

  /// Creates an async command.
  factory TerminalCommand.async({
    required String name,
    required Future<String> Function(List<String> args) handler,
    List<String> aliases = const [],
    String description = '',
    String? usage,
  }) {
    return TerminalCommand(
      name: name,
      aliases: aliases,
      description: description,
      usage: usage,
      handler: (args) async => CommandResult.success(await handler(args)),
    );
  }

  /// Returns all names this command responds to (name + aliases).
  List<String> get allNames => [name, ...aliases];

  /// Checks if this command matches the given name.
  bool matches(String commandName) {
    final lowerName = commandName.toLowerCase();
    return name.toLowerCase() == lowerName ||
        aliases.any((alias) => alias.toLowerCase() == lowerName);
  }

  /// Executes the command with the given arguments.
  ///
  /// Returns a [CommandResult] with the output or error.
  Future<CommandResult> execute(List<String> args) async {
    try {
      final result = handler(args);
      if (result is Future) {
        final asyncResult = await result;
        return _normalizeResult(asyncResult);
      }
      return _normalizeResult(result);
    } catch (e) {
      return CommandResult.error('Error executing command: $e');
    }
  }

  CommandResult _normalizeResult(dynamic result) {
    if (result is CommandResult) {
      return result;
    } else if (result is String) {
      return CommandResult.success(result);
    } else if (result == null) {
      return const CommandResult.empty();
    }
    return CommandResult.success(result.toString());
  }

  /// Gets a formatted help string for this command.
  String get helpText {
    final buffer = StringBuffer();
    buffer.write(name);
    if (aliases.isNotEmpty) {
      buffer.write(' (${aliases.join(', ')})');
    }
    if (description.isNotEmpty) {
      buffer.write(': $description');
    }
    if (usage != null) {
      buffer.write('\n  Usage: $usage');
    }
    return buffer.toString();
  }

  @override
  List<Object?> get props => [name, aliases, description, usage, isHidden];
}
