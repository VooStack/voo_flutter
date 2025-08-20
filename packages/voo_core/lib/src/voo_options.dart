import 'package:flutter/foundation.dart';

/// Configuration options for Voo initialization.
/// These options configure the local behavior of Voo packages.
@immutable
class VooOptions {
  /// Enable debug logging for Voo packages.
  final bool enableDebugLogging;
  
  /// Automatically register discovered plugins.
  final bool autoRegisterPlugins;
  
  /// Custom configuration that can be accessed by plugins.
  final Map<String, dynamic> customConfig;
  
  /// Timeout for plugin initialization.
  final Duration initializationTimeout;
  
  /// App name for identification.
  final String? appName;
  
  /// App version for tracking.
  final String? appVersion;
  
  /// Environment (development, staging, production).
  final String environment;
  
  /// Enable local persistence for data.
  final bool enableLocalPersistence;
  
  /// Maximum local storage size in MB.
  final int maxLocalStorageMB;

  const VooOptions({
    this.enableDebugLogging = kDebugMode,
    this.autoRegisterPlugins = true,
    this.customConfig = const {},
    this.initializationTimeout = const Duration(seconds: 10),
    this.appName,
    this.appVersion,
    this.environment = 'development',
    this.enableLocalPersistence = true,
    this.maxLocalStorageMB = 100,
  });

  VooOptions copyWith({
    bool? enableDebugLogging,
    bool? autoRegisterPlugins,
    Map<String, dynamic>? customConfig,
    Duration? initializationTimeout,
    String? appName,
    String? appVersion,
    String? environment,
    bool? enableLocalPersistence,
    int? maxLocalStorageMB,
  }) {
    return VooOptions(
      enableDebugLogging: enableDebugLogging ?? this.enableDebugLogging,
      autoRegisterPlugins: autoRegisterPlugins ?? this.autoRegisterPlugins,
      customConfig: customConfig ?? this.customConfig,
      initializationTimeout: initializationTimeout ?? this.initializationTimeout,
      appName: appName ?? this.appName,
      appVersion: appVersion ?? this.appVersion,
      environment: environment ?? this.environment,
      enableLocalPersistence: enableLocalPersistence ?? this.enableLocalPersistence,
      maxLocalStorageMB: maxLocalStorageMB ?? this.maxLocalStorageMB,
    );
  }

  /// Create options for production environment.
  factory VooOptions.production({
    String? appName,
    String? appVersion,
    Map<String, dynamic>? customConfig,
  }) {
    return VooOptions(
      enableDebugLogging: false,
      environment: 'production',
      appName: appName,
      appVersion: appVersion,
      customConfig: customConfig ?? const {},
    );
  }

  /// Create options for development environment.
  factory VooOptions.development({
    String? appName,
    String? appVersion,
    Map<String, dynamic>? customConfig,
  }) {
    return VooOptions(
      enableDebugLogging: true,
      environment: 'development',
      appName: appName,
      appVersion: appVersion,
      customConfig: customConfig ?? const {},
    );
  }

  @override
  String toString() {
    return 'VooOptions(enableDebugLogging: $enableDebugLogging, autoRegisterPlugins: $autoRegisterPlugins, environment: $environment, appName: $appName, appVersion: $appVersion)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VooOptions &&
        other.enableDebugLogging == enableDebugLogging &&
        other.autoRegisterPlugins == autoRegisterPlugins &&
        mapEquals(other.customConfig, customConfig) &&
        other.initializationTimeout == initializationTimeout &&
        other.appName == appName &&
        other.appVersion == appVersion &&
        other.environment == environment &&
        other.enableLocalPersistence == enableLocalPersistence &&
        other.maxLocalStorageMB == maxLocalStorageMB;
  }

  @override
  int get hashCode {
    return Object.hash(
      enableDebugLogging,
      autoRegisterPlugins,
      customConfig,
      initializationTimeout,
      appName,
      appVersion,
      environment,
      enableLocalPersistence,
      maxLocalStorageMB,
    );
  }
}