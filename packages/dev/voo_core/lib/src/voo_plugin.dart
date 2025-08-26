import 'dart:async';

/// Base class for all Voo plugins.
/// Plugins can be registered with Voo to extend functionality.
abstract class VooPlugin {
  /// Unique name for this plugin.
  String get name;

  /// Version of this plugin.
  String get version;

  /// Called when a new Voo app is initialized.
  FutureOr<void> onAppInitialized(covariant Object app) {}

  /// Called when a Voo app is deleted.
  FutureOr<void> onAppDeleted(covariant Object app) {}

  /// Dispose resources used by this plugin.
  FutureOr<void> dispose() {}

  /// Get information about this plugin.
  Map<String, dynamic> getInfo() {
    return {'name': name, 'version': version};
  }

  /// Get the instance of this plugin for a specific app.
  /// Plugins can override this to provide app-specific instances.
  dynamic getInstanceForApp(covariant Object app) {
    return this;
  }
}
