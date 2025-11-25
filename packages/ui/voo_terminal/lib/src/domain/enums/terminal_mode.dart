/// Terminal display modes that control user interaction capabilities.
enum TerminalMode {
  /// Read-only mode for displaying output without user input.
  ///
  /// Use this mode for log viewers, status displays, or any scenario
  /// where users should only view content.
  preview,

  /// Full interactive mode with command input and execution.
  ///
  /// Use this mode for command-line interfaces where users
  /// can type commands and receive responses.
  interactive,

  /// Hybrid mode with scrollable output and a fixed input line.
  ///
  /// Use this mode when you want the benefits of preview mode
  /// (scrollable history) with the ability to accept input.
  hybrid,
}
