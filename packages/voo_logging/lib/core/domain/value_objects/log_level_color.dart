import 'package:voo_logging/core/domain/enums/log_level.dart';

/// Value object for log level colors (framework-independent)
class LogLevelColor {
  final int red;
  final int green;
  final int blue;
  final double opacity;

  const LogLevelColor({required this.red, required this.green, required this.blue, this.opacity = 1.0});

  factory LogLevelColor.forLevel(LogLevel level) {
    switch (level) {
      case LogLevel.verbose:
        return const LogLevelColor(red: 158, green: 158, blue: 158); // grey
      case LogLevel.debug:
        return const LogLevelColor(red: 33, green: 150, blue: 243); // blue
      case LogLevel.info:
        return const LogLevelColor(red: 76, green: 175, blue: 80); // green
      case LogLevel.warning:
        return const LogLevelColor(red: 255, green: 152, blue: 0); // orange
      case LogLevel.error:
        return const LogLevelColor(red: 244, green: 67, blue: 54); // red
      case LogLevel.fatal:
        return const LogLevelColor(red: 156, green: 39, blue: 176); // purple
    }
  }

  LogLevelColor withOpacity(double opacity) => LogLevelColor(red: red, green: green, blue: blue, opacity: opacity);

  /// Converts to a hex string
  String toHex() =>
      '#${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
