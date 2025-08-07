import 'package:flutter/foundation.dart';

@immutable
class VooOptions {
  final bool enableDebugLogging;
  final bool autoRegisterPlugins;
  final Map<String, dynamic> customConfig;
  final Duration initializationTimeout;

  const VooOptions({
    this.enableDebugLogging = kDebugMode,
    this.autoRegisterPlugins = true,
    this.customConfig = const {},
    this.initializationTimeout = const Duration(seconds: 10),
  });

  VooOptions copyWith({
    bool? enableDebugLogging,
    bool? autoRegisterPlugins,
    Map<String, dynamic>? customConfig,
    Duration? initializationTimeout,
  }) {
    return VooOptions(
      enableDebugLogging: enableDebugLogging ?? this.enableDebugLogging,
      autoRegisterPlugins: autoRegisterPlugins ?? this.autoRegisterPlugins,
      customConfig: customConfig ?? this.customConfig,
      initializationTimeout: initializationTimeout ?? this.initializationTimeout,
    );
  }

  @override
  String toString() {
    return 'VooOptions(enableDebugLogging: $enableDebugLogging, autoRegisterPlugins: $autoRegisterPlugins, customConfig: $customConfig, initializationTimeout: $initializationTimeout)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VooOptions &&
        other.enableDebugLogging == enableDebugLogging &&
        other.autoRegisterPlugins == autoRegisterPlugins &&
        mapEquals(other.customConfig, customConfig) &&
        other.initializationTimeout == initializationTimeout;
  }

  @override
  int get hashCode {
    return Object.hash(
      enableDebugLogging,
      autoRegisterPlugins,
      customConfig,
      initializationTimeout,
    );
  }
}