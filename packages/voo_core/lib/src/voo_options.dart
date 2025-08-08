import 'package:flutter/foundation.dart';

@immutable
class VooOptions {
  final bool enableDebugLogging;
  final bool autoRegisterPlugins;
  final Map<String, dynamic> customConfig;
  final Duration initializationTimeout;
  final String? apiKey;
  final String? apiEndpoint;
  final bool enableCloudSync;
  final Duration syncInterval;
  final int batchSize;

  const VooOptions({
    this.enableDebugLogging = kDebugMode,
    this.autoRegisterPlugins = true,
    this.customConfig = const {},
    this.initializationTimeout = const Duration(seconds: 10),
    this.apiKey,
    this.apiEndpoint,
    this.enableCloudSync = false,
    this.syncInterval = const Duration(minutes: 1),
    this.batchSize = 100,
  });

  VooOptions copyWith({
    bool? enableDebugLogging,
    bool? autoRegisterPlugins,
    Map<String, dynamic>? customConfig,
    Duration? initializationTimeout,
    String? apiKey,
    String? apiEndpoint,
    bool? enableCloudSync,
    Duration? syncInterval,
    int? batchSize,
  }) {
    return VooOptions(
      enableDebugLogging: enableDebugLogging ?? this.enableDebugLogging,
      autoRegisterPlugins: autoRegisterPlugins ?? this.autoRegisterPlugins,
      customConfig: customConfig ?? this.customConfig,
      initializationTimeout: initializationTimeout ?? this.initializationTimeout,
      apiKey: apiKey ?? this.apiKey,
      apiEndpoint: apiEndpoint ?? this.apiEndpoint,
      enableCloudSync: enableCloudSync ?? this.enableCloudSync,
      syncInterval: syncInterval ?? this.syncInterval,
      batchSize: batchSize ?? this.batchSize,
    );
  }

  @override
  String toString() {
    return 'VooOptions(enableDebugLogging: $enableDebugLogging, autoRegisterPlugins: $autoRegisterPlugins, customConfig: $customConfig, initializationTimeout: $initializationTimeout, apiKey: ${apiKey != null ? '***' : 'null'}, apiEndpoint: $apiEndpoint, enableCloudSync: $enableCloudSync, syncInterval: $syncInterval, batchSize: $batchSize)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VooOptions &&
        other.enableDebugLogging == enableDebugLogging &&
        other.autoRegisterPlugins == autoRegisterPlugins &&
        mapEquals(other.customConfig, customConfig) &&
        other.initializationTimeout == initializationTimeout &&
        other.apiKey == apiKey &&
        other.apiEndpoint == apiEndpoint &&
        other.enableCloudSync == enableCloudSync &&
        other.syncInterval == syncInterval &&
        other.batchSize == batchSize;
  }

  @override
  int get hashCode {
    return Object.hash(
      enableDebugLogging,
      autoRegisterPlugins,
      customConfig,
      initializationTimeout,
      apiKey,
      apiEndpoint,
      enableCloudSync,
      syncInterval,
      batchSize,
    );
  }
}