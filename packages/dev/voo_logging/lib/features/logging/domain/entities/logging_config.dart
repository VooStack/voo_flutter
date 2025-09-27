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
  });

  factory LoggingConfig.production() => const LoggingConfig(
    minimumLevel: LogLevel.warning,
    enablePrettyLogs: false,
    showEmojis: false,
    logTypeConfigs: {
      LogType.network: LogTypeConfig(enableConsoleOutput: false, enableDevToolsOutput: true, minimumLevel: LogLevel.info),
      LogType.analytics: LogTypeConfig(enableConsoleOutput: false, enableDevToolsOutput: true),
      LogType.error: LogTypeConfig(enableConsoleOutput: true, enableDevToolsOutput: true, minimumLevel: LogLevel.warning),
    },
  );

  factory LoggingConfig.development() => const LoggingConfig(
    minimumLevel: LogLevel.verbose,
    enablePrettyLogs: true,
    showEmojis: true,
    logTypeConfigs: {
      LogType.network: LogTypeConfig(enableConsoleOutput: false, enableDevToolsOutput: true, minimumLevel: LogLevel.debug),
      LogType.analytics: LogTypeConfig(enableConsoleOutput: false, enableDevToolsOutput: true, minimumLevel: LogLevel.info),
      LogType.performance: LogTypeConfig(enableConsoleOutput: false, enableDevToolsOutput: true, minimumLevel: LogLevel.info),
    },
  );

  PrettyLogFormatter get formatter => PrettyLogFormatter(
    enabled: enablePrettyLogs,
    showEmojis: showEmojis,
    showTimestamp: showTimestamp,
    showColors: showColors,
    showBorders: showBorders,
    lineLength: lineLength,
  );

  LogTypeConfig getConfigForType(LogType type) {
    return logTypeConfigs[type] ?? const LogTypeConfig();
  }

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
        mapEquals(other.logTypeConfigs, logTypeConfigs);
  }

  @override
  int get hashCode =>
      Object.hash(enablePrettyLogs, showEmojis, showTimestamp, showColors, showBorders, lineLength, minimumLevel, enabled, enableDevToolsJson, logTypeConfigs);
}
