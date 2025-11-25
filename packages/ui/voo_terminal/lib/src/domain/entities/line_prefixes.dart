import 'package:voo_terminal/src/domain/enums/line_type.dart';

/// Custom prefix icons for each line type.
///
/// Use this to customize the prefix characters shown before line content.
/// Set any prefix to an empty string to hide it.
///
/// ## Usage
///
/// ```dart
/// // Use default emoji prefixes
/// LinePrefixes()
///
/// // No prefixes (plain text)
/// LinePrefixes.none()
///
/// // ASCII-only prefixes like [ERR], [WARN], [OK]
/// LinePrefixes.ascii()
///
/// // Custom prefixes
/// LinePrefixes(
///   error: '❌ ',
///   success: '✅ ',
///   warning: '⚡ ',
/// )
/// ```
class LinePrefixes {
  /// Prefix for output lines.
  final String output;

  /// Prefix for input lines.
  final String input;

  /// Prefix for error lines.
  final String error;

  /// Prefix for warning lines.
  final String warning;

  /// Prefix for success lines.
  final String success;

  /// Prefix for system lines.
  final String system;

  /// Prefix for info lines.
  final String info;

  /// Prefix for debug lines.
  final String debug;

  /// Creates custom line prefixes.
  const LinePrefixes({
    this.output = '',
    this.input = '> ',
    this.error = '✗ ',
    this.warning = '⚠ ',
    this.success = '✓ ',
    this.system = '• ',
    this.info = 'ℹ ',
    this.debug = '🔍 ',
  });

  /// Creates prefixes with no icons (plain text).
  const LinePrefixes.none()
      : output = '',
        input = '> ',
        error = '',
        warning = '',
        success = '',
        system = '',
        info = '',
        debug = '';

  /// Creates minimal prefixes using ASCII characters only.
  const LinePrefixes.ascii()
      : output = '',
        input = '> ',
        error = '[ERR] ',
        warning = '[WARN] ',
        success = '[OK] ',
        system = '[SYS] ',
        info = '[INFO] ',
        debug = '[DBG] ';

  /// Gets the prefix for a specific line type.
  String forType(LineType type) {
    switch (type) {
      case LineType.output:
        return output;
      case LineType.input:
        return input;
      case LineType.error:
        return error;
      case LineType.warning:
        return warning;
      case LineType.success:
        return success;
      case LineType.system:
        return system;
      case LineType.info:
        return info;
      case LineType.debug:
        return debug;
    }
  }

  /// Creates a copy with the given fields replaced.
  LinePrefixes copyWith({
    String? output,
    String? input,
    String? error,
    String? warning,
    String? success,
    String? system,
    String? info,
    String? debug,
  }) {
    return LinePrefixes(
      output: output ?? this.output,
      input: input ?? this.input,
      error: error ?? this.error,
      warning: warning ?? this.warning,
      success: success ?? this.success,
      system: system ?? this.system,
      info: info ?? this.info,
      debug: debug ?? this.debug,
    );
  }
}
