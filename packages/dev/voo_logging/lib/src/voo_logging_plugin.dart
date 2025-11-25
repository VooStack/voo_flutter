import 'dart:async';

import 'package:voo_core/voo_core.dart';
import 'package:voo_logging/features/logging/domain/entities/logging_config.dart';
import 'package:voo_logging/features/logging/domain/entities/voo_logger.dart';

/// VooLogging plugin for integration with VooCore.
///
/// This plugin is optional - VooLogger works standalone without VooCore.
/// Use this when you want VooLogging to integrate with the VooCore plugin system.
///
/// For standalone usage, just call VooLogger methods directly:
/// ```dart
/// VooLogger.info('Hello world'); // Works without any initialization
/// ```
///
/// For explicit control with VooCore:
/// ```dart
/// await Voo.initializeApp(...);
/// await VooLoggingPlugin.initialize();
/// ```
class VooLoggingPlugin extends VooPlugin {
  static VooLoggingPlugin? _instance;
  bool _initialized = false;

  VooLoggingPlugin._();

  static VooLoggingPlugin get instance {
    _instance ??= VooLoggingPlugin._();
    return _instance!;
  }

  @override
  String get name => 'voo_logging';

  @override
  String get version => '0.4.7';

  bool get isInitialized => _initialized;

  /// Initialize VooLogging plugin with VooCore integration.
  ///
  /// This is optional - VooLogger works without explicit initialization.
  /// Use this when you want to:
  /// - Register with VooCore's plugin system
  /// - Use custom configuration
  /// - Ensure initialization happens at app startup
  ///
  /// Parameters are deprecated - use [config] instead for all settings.
  static Future<void> initialize({
    @Deprecated('Use config.maxLogs instead') int maxEntries = 10000,
    @Deprecated('Use config.enablePrettyLogs instead') bool enableConsoleOutput = true,
    @Deprecated('Logs are always stored') bool enableFileStorage = true,
    LoggingConfig? config,
  }) async {
    final plugin = instance;

    if (plugin._initialized) {
      return;
    }

    // VooCore is now optional - VooLogger works standalone
    final isVooCoreAvailable = Voo.isInitialized;

    // Use provided config or create one with legacy parameters
    final effectiveConfig = config ?? LoggingConfig.minimal().copyWith(
      maxLogs: maxEntries,
      enablePrettyLogs: enableConsoleOutput,
    );

    await VooLogger.initialize(config: effectiveConfig);

    if (isVooCoreAvailable) {
      await Voo.registerPlugin(plugin);
    }

    plugin._initialized = true;
  }

  @override
  FutureOr<void> onAppInitialized(VooApp app) {
    if (!_initialized && app.options.autoRegisterPlugins) {
      VooLogger.info('VooLogging plugin auto-registered');
    }
  }

  @override
  FutureOr<void> dispose() {
    _initialized = false;
    _instance = null;
  }

  @override
  Map<String, dynamic> getInfo() => {...super.getInfo(), 'initialized': _initialized};
}
