enum LogLevel {
  verbose,
  debug,
  info,
  warning,
  error,
  fatal;

  /// Numeric priority for filtering
  /// Higher number = more severe
  int get priority {
    switch (this) {
      case verbose:
        return 0;
      case debug:
        return 1;
      case info:
        return 2;
      case warning:
        return 3;
      case error:
        return 4;
      case fatal:
        return 5;
    }
  }

  /// Color coding for UI display
  /// Why? Visual distinction makes debugging faster
  String get colorCode {
    switch (this) {
      case verbose:
        return '#808080'; // Gray
      case debug:
        return '#0000FF'; // Blue
      case info:
        return '#00FF00'; // Green
      case warning:
        return '#FFA500'; // Orange
      case error:
        return '#FF0000'; // Red
      case fatal:
        return '#8B0000'; // Dark Red
    }
  }

  /// Icon for UI display
  String get icon {
    switch (this) {
      case verbose:
        return '💬';
      case debug:
        return '🐛';
      case info:
        return 'ℹ️';
      case warning:
        return '⚠️';
      case error:
        return '❌';
      case fatal:
        return '💀';
    }
  }
}
