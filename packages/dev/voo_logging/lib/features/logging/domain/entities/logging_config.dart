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
  final bool shouldNotify;

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
    this.shouldNotify = false,
  });

  PrettyLogFormatter get formatter => PrettyLogFormatter(
    enabled: enablePrettyLogs,
    showEmojis: showEmojis,
    showTimestamp: showTimestamp,
    showColors: showColors,
    showBorders: showBorders,
    lineLength: lineLength,
  );

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
    bool? shouldNotify,
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
    shouldNotify: shouldNotify ?? this.shouldNotify,
  );

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
        other.shouldNotify == shouldNotify;
  }

  @override
  int get hashCode => Object.hash(enablePrettyLogs, showEmojis, showTimestamp, showColors, showBorders, lineLength, minimumLevel, enabled, enableDevToolsJson, shouldNotify);
}
