import 'package:flutter/foundation.dart';
import 'package:voo_logging/features/logging/domain/utils/pretty_log_formatter.dart';
import 'package:voo_logging/voo_logging.dart';

@immutable
class LoggingConfig {
  final bool enablePrettyLogs;
  final bool showEmojis;
  final bool showTimestamp;
  final bool showColors;
  final bool showBorders;
  final int lineLength;
  final LogLevel minimumLevel;
  final bool enabled;
  final bool enableDevToolsJson;
  final Map<LogType, LogTypeConfig> logTypeConfigs;

  /// Maximum number of logs to retain. Set to null for unlimited.
  final int? maxLogs;

  /// Maximum age of logs in days. Logs older than this will be cleaned up.
  /// Set to null to keep logs forever.
  final int? retentionDays;

  /// Whether to automatically clean up old logs on initialization.
  final bool autoCleanup;

  const LoggingConfig({
    this.enablePrettyLogs = true,
    this.showEmojis = true,
    this.showTimestamp = true,
    this.showColors = true,
    this.showBorders = true,
    this.lineLength = 120,
    this.minimumLevel = LogLevel.verbose,
    this.enabled = true,
    this.enableDevToolsJson = false,
    this.logTypeConfigs = const {},
    this.maxLogs,
    this.retentionDays,
    this.autoCleanup = true,
  });

  factory LoggingConfig.production() => const LoggingConfig(
    minimumLevel: LogLevel.warning,
    enablePrettyLogs: false,
    showEmojis: false,
    maxLogs: 5000,
    retentionDays: 3,
    logTypeConfigs: {
      LogType.network: LogTypeConfig(enableConsoleOutput: false, minimumLevel: LogLevel.info),
      LogType.analytics: LogTypeConfig(enableConsoleOutput: false),
      LogType.error: LogTypeConfig(minimumLevel: LogLevel.warning),
    },
  );

  factory LoggingConfig.development() => const LoggingConfig(
    maxLogs: 10000,
    retentionDays: 7,
    logTypeConfigs: {
      LogType.network: LogTypeConfig(enableConsoleOutput: false, minimumLevel: LogLevel.debug),
      LogType.analytics: LogTypeConfig(enableConsoleOutput: false, minimumLevel: LogLevel.info),
      LogType.performance: LogTypeConfig(enableConsoleOutput: false, minimumLevel: LogLevel.info),
    },
  );

  /// Zero-config preset that works out of the box.
  /// Automatically detects debug/release mode and configures accordingly.
  factory LoggingConfig.minimal() => const LoggingConfig(maxLogs: 10000, retentionDays: 7);

  PrettyLogFormatter get formatter => PrettyLogFormatter(
    enabled: enablePrettyLogs,
    showEmojis: showEmojis,
    showTimestamp: showTimestamp,
    showColors: showColors,
    showBorders: showBorders,
    lineLength: lineLength,
  );

  LogTypeConfig getConfigForType(LogType type) => logTypeConfigs[type] ?? const LogTypeConfig();

  LogTypeConfig getConfigForCategory(String? category) {
    final type = mapCategoryToLogType(category);
    return getConfigForType(type);
  }

  static LogType mapCategoryToLogType(String? category) {
    if (category == null) return LogType.general;

    switch (category.toLowerCase()) {
      case 'network':
        return LogType.network;
      case 'analytics':
        return LogType.analytics;
      case 'performance':
        return LogType.performance;
      case 'error':
        return LogType.error;
      case 'system':
        return LogType.system;
      default:
        return LogType.general;
    }
  }

  LoggingConfig copyWith({
    bool? enablePrettyLogs,
    bool? showEmojis,
    bool? showTimestamp,
    bool? showColors,
    bool? showBorders,
    int? lineLength,
    LogLevel? minimumLevel,
    bool? enabled,
    bool? enableDevToolsJson,
    Map<LogType, LogTypeConfig>? logTypeConfigs,
    int? maxLogs,
    int? retentionDays,
    bool? autoCleanup,
  }) => LoggingConfig(
    enablePrettyLogs: enablePrettyLogs ?? this.enablePrettyLogs,
    showEmojis: showEmojis ?? this.showEmojis,
    showTimestamp: showTimestamp ?? this.showTimestamp,
    showColors: showColors ?? this.showColors,
    showBorders: showBorders ?? this.showBorders,
    lineLength: lineLength ?? this.lineLength,
    minimumLevel: minimumLevel ?? this.minimumLevel,
    enabled: enabled ?? this.enabled,
    enableDevToolsJson: enableDevToolsJson ?? this.enableDevToolsJson,
    logTypeConfigs: logTypeConfigs ?? this.logTypeConfigs,
    maxLogs: maxLogs ?? this.maxLogs,
    retentionDays: retentionDays ?? this.retentionDays,
    autoCleanup: autoCleanup ?? this.autoCleanup,
  );

  LoggingConfig withLogTypeConfig(LogType type, LogTypeConfig config) {
    final updatedConfigs = Map<LogType, LogTypeConfig>.from(logTypeConfigs);
    updatedConfigs[type] = config;
    return copyWith(logTypeConfigs: updatedConfigs);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoggingConfig &&
        other.enablePrettyLogs == enablePrettyLogs &&
        other.showEmojis == showEmojis &&
        other.showTimestamp == showTimestamp &&
        other.showColors == showColors &&
        other.showBorders == showBorders &&
        other.lineLength == lineLength &&
        other.minimumLevel == minimumLevel &&
        other.enabled == enabled &&
        other.enableDevToolsJson == enableDevToolsJson &&
        mapEquals(other.logTypeConfigs, logTypeConfigs) &&
        other.maxLogs == maxLogs &&
        other.retentionDays == retentionDays &&
        other.autoCleanup == autoCleanup;
  }

  @override
  int get hashCode => Object.hash(
    enablePrettyLogs,
    showEmojis,
    showTimestamp,
    showColors,
    showBorders,
    lineLength,
    minimumLevel,
    enabled,
    enableDevToolsJson,
    logTypeConfigs,
    maxLogs,
    retentionDays,
    autoCleanup,
  );
}
