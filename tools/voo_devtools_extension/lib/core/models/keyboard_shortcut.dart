import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Represents a keyboard shortcut with its action and description
class KeyboardShortcut {
  final String id;
  final String label;
  final String description;
  final LogicalKeyboardKey key;
  final bool needsModifier;
  final bool needsShift;

  const KeyboardShortcut({
    required this.id,
    required this.label,
    required this.description,
    required this.key,
    this.needsModifier = false,
    this.needsShift = false,
  });

  /// Get the display string for this shortcut
  String get displayString {
    final parts = <String>[];

    if (needsModifier) {
      parts.add(_isMacOS ? '⌘' : 'Ctrl');
    }
    if (needsShift) {
      parts.add(_isMacOS ? '⇧' : 'Shift');
    }

    parts.add(_getKeyLabel(key));

    return parts.join(_isMacOS ? '' : '+');
  }

  static bool get _isMacOS {
    return defaultTargetPlatform == TargetPlatform.macOS;
  }

  String _getKeyLabel(LogicalKeyboardKey key) {
    // Map common keys to readable labels
    if (key == LogicalKeyboardKey.escape) return _isMacOS ? '⎋' : 'Esc';
    if (key == LogicalKeyboardKey.enter) return _isMacOS ? '↩' : 'Enter';
    if (key == LogicalKeyboardKey.arrowUp) return '↑';
    if (key == LogicalKeyboardKey.arrowDown) return '↓';
    if (key == LogicalKeyboardKey.arrowLeft) return '←';
    if (key == LogicalKeyboardKey.arrowRight) return '→';
    if (key == LogicalKeyboardKey.space) return 'Space';
    if (key == LogicalKeyboardKey.tab) return _isMacOS ? '⇥' : 'Tab';
    if (key == LogicalKeyboardKey.backspace) return _isMacOS ? '⌫' : 'Backspace';
    if (key == LogicalKeyboardKey.delete) return _isMacOS ? '⌦' : 'Del';
    if (key == LogicalKeyboardKey.keyF) return 'F';
    if (key == LogicalKeyboardKey.keyK) return 'K';
    if (key == LogicalKeyboardKey.keyE) return 'E';
    if (key == LogicalKeyboardKey.keyC) return 'C';
    if (key == LogicalKeyboardKey.keyS) return 'S';
    if (key == LogicalKeyboardKey.keyR) return 'R';
    if (key == LogicalKeyboardKey.keyT) return 'T';
    if (key == LogicalKeyboardKey.digit1) return '1';
    if (key == LogicalKeyboardKey.digit2) return '2';
    if (key == LogicalKeyboardKey.digit3) return '3';
    if (key == LogicalKeyboardKey.digit4) return '4';
    if (key == LogicalKeyboardKey.slash) return '/';
    if (key == LogicalKeyboardKey.question) return '?';

    return key.keyLabel;
  }

  /// Check if this shortcut matches the given key event
  bool matches(KeyEvent event) {
    // Check modifier requirements
    final hasModifier = HardwareKeyboard.instance.isMetaPressed ||
        HardwareKeyboard.instance.isControlPressed;
    final hasShift = HardwareKeyboard.instance.isShiftPressed;

    if (needsModifier && !hasModifier) return false;
    if (needsShift && !hasShift) return false;

    // Check the actual key
    return event.logicalKey == key;
  }
}

/// Pre-defined keyboard shortcuts for the DevTools extension
class AppShortcuts {
  AppShortcuts._();

  // Navigation
  static const focusSearch = KeyboardShortcut(
    id: 'focus_search',
    label: 'Focus Search',
    description: 'Jump to the search field',
    key: LogicalKeyboardKey.keyF,
    needsModifier: true,
  );

  static const quickFilter = KeyboardShortcut(
    id: 'quick_filter',
    label: 'Quick Filter',
    description: 'Open filter options',
    key: LogicalKeyboardKey.keyK,
    needsModifier: true,
  );

  static const escape = KeyboardShortcut(
    id: 'escape',
    label: 'Close/Cancel',
    description: 'Close panel or cancel operation',
    key: LogicalKeyboardKey.escape,
  );

  // Actions
  static const exportData = KeyboardShortcut(
    id: 'export',
    label: 'Export Data',
    description: 'Export current tab data',
    key: LogicalKeyboardKey.keyE,
    needsModifier: true,
  );

  static const clearData = KeyboardShortcut(
    id: 'clear',
    label: 'Clear Data',
    description: 'Clear current tab data',
    key: LogicalKeyboardKey.keyC,
    needsModifier: true,
    needsShift: true,
  );

  static const refresh = KeyboardShortcut(
    id: 'refresh',
    label: 'Refresh',
    description: 'Refresh current tab data',
    key: LogicalKeyboardKey.keyR,
    needsModifier: true,
  );

  // List navigation
  static const selectPrevious = KeyboardShortcut(
    id: 'select_previous',
    label: 'Previous Item',
    description: 'Select the previous item in the list',
    key: LogicalKeyboardKey.arrowUp,
  );

  static const selectNext = KeyboardShortcut(
    id: 'select_next',
    label: 'Next Item',
    description: 'Select the next item in the list',
    key: LogicalKeyboardKey.arrowDown,
  );

  static const openDetails = KeyboardShortcut(
    id: 'open_details',
    label: 'Open Details',
    description: 'Open details for selected item',
    key: LogicalKeyboardKey.enter,
  );

  // Tab navigation
  static const tab1 = KeyboardShortcut(
    id: 'tab_1',
    label: 'Tab 1',
    description: 'Switch to first tab',
    key: LogicalKeyboardKey.digit1,
    needsModifier: true,
  );

  static const tab2 = KeyboardShortcut(
    id: 'tab_2',
    label: 'Tab 2',
    description: 'Switch to second tab',
    key: LogicalKeyboardKey.digit2,
    needsModifier: true,
  );

  static const tab3 = KeyboardShortcut(
    id: 'tab_3',
    label: 'Tab 3',
    description: 'Switch to third tab',
    key: LogicalKeyboardKey.digit3,
    needsModifier: true,
  );

  static const tab4 = KeyboardShortcut(
    id: 'tab_4',
    label: 'Tab 4',
    description: 'Switch to fourth tab',
    key: LogicalKeyboardKey.digit4,
    needsModifier: true,
  );

  // View
  static const toggleTheme = KeyboardShortcut(
    id: 'toggle_theme',
    label: 'Toggle Theme',
    description: 'Switch between light and dark mode',
    key: LogicalKeyboardKey.keyT,
    needsModifier: true,
    needsShift: true,
  );

  // Help
  static const showHelp = KeyboardShortcut(
    id: 'show_help',
    label: 'Show Shortcuts',
    description: 'Show keyboard shortcuts help',
    key: LogicalKeyboardKey.slash,
    needsModifier: true,
  );

  /// All available shortcuts grouped by category
  static const Map<String, List<KeyboardShortcut>> allShortcuts = {
    'Navigation': [
      focusSearch,
      quickFilter,
      escape,
    ],
    'Actions': [
      refresh,
      exportData,
      clearData,
    ],
    'View': [
      toggleTheme,
    ],
    'List': [
      selectPrevious,
      selectNext,
      openDetails,
    ],
    'Tabs': [
      tab1,
      tab2,
      tab3,
      tab4,
    ],
    'Help': [
      showHelp,
    ],
  };
}
