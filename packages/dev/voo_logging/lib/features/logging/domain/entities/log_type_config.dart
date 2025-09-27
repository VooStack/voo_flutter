import 'package:flutter/foundation.dart';
import 'package:voo_logging/voo_logging.dart';

@immutable
class LogTypeConfig {
  final bool enableConsoleOutput;
  final bool enableDevToolsOutput;
  final bool enableStorage;
  final LogLevel minimumLevel;

  const LogTypeConfig({this.enableConsoleOutput = true, this.enableDevToolsOutput = true, this.enableStorage = true, this.minimumLevel = LogLevel.verbose});

  LogTypeConfig copyWith({bool? enableConsoleOutput, bool? enableDevToolsOutput, bool? enableStorage, LogLevel? minimumLevel}) {
    return LogTypeConfig(
      enableConsoleOutput: enableConsoleOutput ?? this.enableConsoleOutput,
      enableDevToolsOutput: enableDevToolsOutput ?? this.enableDevToolsOutput,
      enableStorage: enableStorage ?? this.enableStorage,
      minimumLevel: minimumLevel ?? this.minimumLevel,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LogTypeConfig &&
        other.enableConsoleOutput == enableConsoleOutput &&
        other.enableDevToolsOutput == enableDevToolsOutput &&
        other.enableStorage == enableStorage &&
        other.minimumLevel == minimumLevel;
  }

  @override
  int get hashCode => Object.hash(enableConsoleOutput, enableDevToolsOutput, enableStorage, minimumLevel);
}

enum LogType { general, network, analytics, performance, error, system }
