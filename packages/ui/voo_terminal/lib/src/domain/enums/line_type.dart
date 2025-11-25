/// Types of terminal lines that determine visual styling.
enum LineType {
  /// Standard output text.
  output,

  /// User input line (command that was entered).
  input,

  /// Error message, typically displayed in red.
  error,

  /// Warning message, typically displayed in yellow/amber.
  warning,

  /// Success message, typically displayed in green.
  success,

  /// System message for internal terminal communications.
  system,

  /// Informational message, typically displayed in blue/cyan.
  info,

  /// Debug message, typically displayed in gray/muted.
  debug,
}

/// Extension methods for [LineType].
extension LineTypeExtension on LineType {
  /// Returns whether this line type represents user input.
  bool get isInput => this == LineType.input;

  /// Returns whether this line type represents an error state.
  bool get isError => this == LineType.error;

  /// Returns whether this line type represents a success state.
  bool get isSuccess => this == LineType.success;

  /// Returns whether this line type represents a warning state.
  bool get isWarning => this == LineType.warning;

  /// Returns the default prefix character for this line type.
  String get defaultPrefix {
    switch (this) {
      case LineType.output:
        return '';
      case LineType.input:
        return '> ';
      case LineType.error:
        return '✗ ';
      case LineType.warning:
        return '⚠ ';
      case LineType.success:
        return '✓ ';
      case LineType.system:
        return '• ';
      case LineType.info:
        return 'ℹ ';
      case LineType.debug:
        return '🔍 ';
    }
  }
}
