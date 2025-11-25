import 'dart:async';

import 'package:flutter/services.dart';
import 'package:voo_devtools_extension/core/models/keyboard_shortcut.dart';

/// Callback type for shortcut actions
typedef ShortcutCallback = void Function();

/// Service for managing keyboard shortcuts throughout the DevTools extension
class KeyboardShortcutsService {
  static final KeyboardShortcutsService _instance =
      KeyboardShortcutsService._internal();
  factory KeyboardShortcutsService() => _instance;
  KeyboardShortcutsService._internal();

  final _shortcutController = StreamController<String>.broadcast();
  Stream<String> get shortcutStream => _shortcutController.stream;

  final Map<String, ShortcutCallback> _callbacks = {};

  /// Whether keyboard shortcuts are currently enabled
  bool isEnabled = true;

  /// Register a callback for a specific shortcut
  void register(String shortcutId, ShortcutCallback callback) {
    _callbacks[shortcutId] = callback;
  }

  /// Unregister a callback for a specific shortcut
  void unregister(String shortcutId) {
    _callbacks.remove(shortcutId);
  }

  /// Unregister all callbacks
  void unregisterAll() {
    _callbacks.clear();
  }

  /// Handle a key event and execute matching shortcuts
  /// Returns true if a shortcut was handled
  bool handleKeyEvent(KeyEvent event) {
    if (!isEnabled) return false;
    if (event is! KeyDownEvent) return false;

    // Check each shortcut
    for (final category in AppShortcuts.allShortcuts.values) {
      for (final shortcut in category) {
        if (shortcut.matches(event)) {
          final callback = _callbacks[shortcut.id];
          if (callback != null) {
            callback();
            _shortcutController.add(shortcut.id);
            return true;
          }
        }
      }
    }

    return false;
  }

  /// Get all registered shortcut IDs
  Set<String> get registeredShortcuts => _callbacks.keys.toSet();

  /// Check if a shortcut is registered
  bool isRegistered(String shortcutId) => _callbacks.containsKey(shortcutId);

  void dispose() {
    _callbacks.clear();
    _shortcutController.close();
  }
}
