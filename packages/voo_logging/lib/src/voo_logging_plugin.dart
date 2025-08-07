import 'dart:async';
import 'package:voo_core/voo_core.dart';
import 'package:voo_logging/features/logging/domain/entities/voo_logger.dart';

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
  String get version => '0.0.15';

  bool get isInitialized => _initialized;

  Future<void> initialize({
    int maxEntries = 10000,
    bool enableConsoleOutput = true,
    bool enableFileStorage = true,
  }) async {
    if (_initialized) {
      return;
    }

    if (!Voo.isInitialized) {
      throw const VooException(
        'Voo.initializeApp() must be called before initializing VooLogging',
        code: 'core-not-initialized',
      );
    }

    await VooLogger.initialize();

    Voo.registerPlugin(this);
    _initialized = true;
  }

  @override
  FutureOr<void> onCoreInitialized() {
    if (!_initialized && Voo.options?.autoRegisterPlugins == true) {
      VooLogger.info('VooLogging plugin auto-registered');
    }
  }

  @override
  void dispose() {
    // Clean up resources
    _initialized = false;
    _instance = null;
    super.dispose();
  }

  @override
  Map<String, dynamic> getInfo() => {
        ...super.getInfo(),
        'initialized': _initialized,
      };
}