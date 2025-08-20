/// Log level enum for categorizing log entries
enum LogLevel {
  verbose,
  debug,
  info,
  warning,
  error,
  fatal,
  network,
  navigation;

  /// Get color for this log level
  int get color {
    switch (this) {
      case LogLevel.verbose:
        return 0xFF9E9E9E; // Grey
      case LogLevel.debug:
        return 0xFF2196F3; // Blue
      case LogLevel.info:
        return 0xFF4CAF50; // Green
      case LogLevel.warning:
        return 0xFFFFC107; // Amber
      case LogLevel.error:
        return 0xFFF44336; // Red
      case LogLevel.fatal:
        return 0xFF9C27B0; // Purple
      case LogLevel.network:
        return 0xFF00BCD4; // Cyan
      case LogLevel.navigation:
        return 0xFF3F51B5; // Indigo
    }
  }

  /// Get display name for this log level
  String get displayName {
    switch (this) {
      case LogLevel.verbose:
        return 'Verbose';
      case LogLevel.debug:
        return 'Debug';
      case LogLevel.info:
        return 'Info';
      case LogLevel.warning:
        return 'Warning';
      case LogLevel.error:
        return 'Error';
      case LogLevel.fatal:
        return 'Fatal';
      case LogLevel.network:
        return 'Network';
      case LogLevel.navigation:
        return 'Navigation';
    }
  }

  /// Get icon for this log level
  String get icon {
    switch (this) {
      case LogLevel.verbose:
        return '💬';
      case LogLevel.debug:
        return '🐛';
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
      case LogLevel.fatal:
        return '💀';
      case LogLevel.network:
        return '🌐';
      case LogLevel.navigation:
        return '🧭';
    }
  }
}

/// Extension for LogLevel
extension LogLevelExtensions on LogLevel {
  /// Check if this level is considered an error
  bool get isError => this == LogLevel.error || this == LogLevel.fatal;
  
  /// Check if this level is considered a warning
  bool get isWarning => this == LogLevel.warning;
  
  /// Get priority for sorting (higher = more important)
  int get priority {
    switch (this) {
      case LogLevel.fatal:
        return 6;
      case LogLevel.error:
        return 5;
      case LogLevel.warning:
        return 4;
      case LogLevel.info:
        return 3;
      case LogLevel.network:
        return 2;
      case LogLevel.debug:
        return 1;
      case LogLevel.verbose:
        return 0;
      case LogLevel.navigation:
        return 2;
    }
  }
}

/// Helper class for log level colors
class LogLevelColor {
  final int value;
  
  const LogLevelColor(this.value);
  
  /// Create from log level
  factory LogLevelColor.fromLevel(LogLevel level) {
    return LogLevelColor(level.color);
  }
}