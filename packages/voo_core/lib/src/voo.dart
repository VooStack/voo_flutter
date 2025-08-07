import 'dart:async';
import 'package:voo_core/src/voo_options.dart';
import 'package:voo_core/src/voo_plugin.dart';
import 'package:voo_core/src/exceptions/voo_exception.dart';

class Voo {
  static Voo? _instance;
  static final Map<String, VooPlugin> _plugins = {};
  static bool _initialized = false;
  static VooOptions? _options;

  Voo._();

  static VooOptions? get options => _options;
  static bool get isInitialized => _initialized;
  static Map<String, VooPlugin> get plugins => Map.unmodifiable(_plugins);

  static Future<Voo> initializeApp({VooOptions? options}) async {
    if (_initialized) {
      return _instance!;
    }

    _options = options ?? const VooOptions();
    _instance = Voo._();
    _initialized = true;

    // Core initialized

    for (final plugin in _plugins.values) {
      await plugin.onCoreInitialized();
    }

    return _instance!;
  }

  static void registerPlugin(VooPlugin plugin) {
    if (_plugins.containsKey(plugin.name)) {
      throw VooException('Plugin ${plugin.name} is already registered', code: 'plugin-already-registered');
    }

    _plugins[plugin.name] = plugin;

    if (_initialized) {
      plugin.onCoreInitialized();
    }
  }

  static void unregisterPlugin(String pluginName) {
    final plugin = _plugins.remove(pluginName);
    if (plugin != null) {
      plugin.dispose();
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

  static void dispose() {
    for (final plugin in _plugins.values) {
      plugin.dispose();
    }
    _plugins.clear();
    _initialized = false;
    _instance = null;
    _options = null;
  }
}
