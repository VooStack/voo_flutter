import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:voo_core/src/voo_options.dart';
import 'package:voo_core/src/voo_plugin.dart';
import 'package:voo_core/src/exceptions/voo_exception.dart';

/// Central initialization and management for all Voo packages.
/// Works similar to Firebase Core, providing a unified entry point.
class Voo {
  static final Map<String, VooPlugin> _plugins = {};
  static final Map<String, VooApp> _apps = {};
  static bool _initialized = false;
  static VooOptions? _options;
  static const String _defaultAppName = '[DEFAULT]';

  Voo._();

  static VooOptions? get options => _options;
  static bool get isInitialized => _initialized;
  static Map<String, VooPlugin> get plugins => Map.unmodifiable(_plugins);
  static Map<String, VooApp> get apps => Map.unmodifiable(_apps);

  /// Initialize the default Voo app.
  static Future<VooApp> initializeApp({
    String name = _defaultAppName,
    VooOptions? options,
  }) async {
    if (_apps.containsKey(name)) {
      return _apps[name]!;
    }

    _options = options ?? const VooOptions();

    if (!_initialized) {
      _initialized = true;
    }

    final app = VooApp._(name: name, options: _options!);
    _apps[name] = app;

    // Notify all registered plugins about the new app
    for (final plugin in _plugins.values) {
      await plugin.onAppInitialized(app);
    }

    if (kDebugMode) {
      debugPrint('Voo: Initialized app "$name"');
    }

    return app;
  }

  /// Get an app by name.
  static VooApp app([String name = _defaultAppName]) {
    final app = _apps[name];
    if (app == null) {
      throw VooException(
        'App "$name" not found. Available apps: ${_apps.keys.join(", ")}',
        code: 'app-not-found',
      );
    }
    return app;
  }

  /// Get all initialized apps.
  static List<VooApp> get allApps => _apps.values.toList();

  /// Register a plugin to be initialized with Voo apps.
  static Future<void> registerPlugin(VooPlugin plugin) async {
    if (_plugins.containsKey(plugin.name)) {
      throw VooException(
        'Plugin ${plugin.name} is already registered',
        code: 'plugin-already-registered',
      );
    }

    _plugins[plugin.name] = plugin;

    // Initialize the plugin with all existing apps
    for (final app in _apps.values) {
      await plugin.onAppInitialized(app);
    }

    if (kDebugMode) {
      debugPrint('Voo: Registered plugin "${plugin.name}"');
    }
  }

  /// Unregister a plugin.
  static Future<void> unregisterPlugin(String pluginName) async {
    final plugin = _plugins.remove(pluginName);
    if (plugin != null) {
      await plugin.dispose();
      if (kDebugMode) {
        debugPrint('Voo: Unregistered plugin "$pluginName"');
      }
    }
  }

  static T? getPlugin<T extends VooPlugin>(String name) {
    final plugin = _plugins[name];
    if (plugin is T) {
      return plugin;
    }
    return null;
  }

  static bool hasPlugin(String name) {
    return _plugins.containsKey(name);
  }

  /// Dispose all apps and plugins.
  static Future<void> dispose() async {
    // Dispose all plugins
    for (final plugin in _plugins.values) {
      await plugin.dispose();
    }
    _plugins.clear();

    // Dispose all apps
    for (final app in _apps.values) {
      await app.dispose();
    }
    _apps.clear();

    _initialized = false;
    _options = null;
  }

  /// Check if a plugin is registered.
  static bool isPluginRegistered<T extends VooPlugin>() {
    return _plugins.values.whereType<T>().isNotEmpty;
  }

  /// Ensure a plugin is registered, throw if not.
  static void ensurePluginRegistered<T extends VooPlugin>(String pluginName) {
    if (!isPluginRegistered<T>()) {
      throw VooException(
        'Plugin "$pluginName" is not registered. Please register it first.',
        code: 'plugin-not-registered',
      );
    }
  }
}

/// Represents a Voo application instance.
class VooApp {
  final String name;
  final VooOptions options;
  final Map<String, dynamic> _data = {};

  VooApp._({required this.name, required this.options});

  /// Check if this is the default app.
  bool get isDefault => name == Voo._defaultAppName;

  /// Store custom data associated with this app.
  void setData(String key, dynamic value) {
    _data[key] = value;
  }

  /// Retrieve custom data associated with this app.
  T? getData<T>(String key) {
    return _data[key] as T?;
  }

  /// Dispose this app.
  Future<void> dispose() async {
    _data.clear();
  }

  /// Delete this app.
  Future<void> delete() async {
    await dispose();
    Voo._apps.remove(name);

    // Notify plugins about app deletion
    for (final plugin in Voo._plugins.values) {
      await plugin.onAppDeleted(this);
    }
  }
}
