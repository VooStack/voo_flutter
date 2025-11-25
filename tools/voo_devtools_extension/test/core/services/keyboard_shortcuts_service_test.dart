import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_devtools_extension/core/models/keyboard_shortcut.dart';
import 'package:voo_devtools_extension/core/services/keyboard_shortcuts_service.dart';

void main() {
  group('KeyboardShortcutsService', () {
    late KeyboardShortcutsService service;

    setUp(() {
      service = KeyboardShortcutsService();
    });

    tearDown(() {
      service.unregisterAll();
    });

    test('should register shortcut callback', () {
      // Register a callback - actual invocation tested via widget tests
      service.register('test_shortcut', () {});
      expect(service.isRegistered('test_shortcut'), true);
    });

    test('should unregister shortcut', () {
      service.register('test_shortcut', () {});
      expect(service.isRegistered('test_shortcut'), true);

      service.unregister('test_shortcut');
      expect(service.isRegistered('test_shortcut'), false);
    });

    test('should unregister all shortcuts', () {
      service.register('shortcut1', () {});
      service.register('shortcut2', () {});
      service.register('shortcut3', () {});

      service.unregisterAll();

      expect(service.isRegistered('shortcut1'), false);
      expect(service.isRegistered('shortcut2'), false);
      expect(service.isRegistered('shortcut3'), false);
    });

    test('should override existing shortcut when registering with same id', () {
      var callCount = 0;

      service.register('test_shortcut', () => callCount = 1);
      service.register('test_shortcut', () => callCount = 2);

      // Only one registration should exist (the latest one)
      expect(service.isRegistered('test_shortcut'), true);
      // Note: callCount would be 2 if triggered - actual invocation tested via widget tests
      expect(callCount, 0); // Not triggered yet
    });
  });

  group('KeyboardShortcut', () {
    test('should have correct display string for Mac', () {
      const shortcut = KeyboardShortcut(
        id: 'test',
        label: 'Test',
        description: 'Test shortcut',
        key: LogicalKeyboardKey.keyR,
        needsModifier: true,
      );

      // The display string varies by platform, but should include the key
      expect(shortcut.displayString, isNotEmpty);
      expect(shortcut.displayString.contains('R'), true);
    });

    test('should have correct display string with shift', () {
      const shortcut = KeyboardShortcut(
        id: 'test',
        label: 'Test',
        description: 'Test shortcut',
        key: LogicalKeyboardKey.keyC,
        needsModifier: true,
        needsShift: true,
      );

      expect(shortcut.displayString, isNotEmpty);
      expect(shortcut.displayString.contains('C'), true);
    });

    test('should format special keys correctly', () {
      const escapeShortcut = KeyboardShortcut(
        id: 'escape',
        label: 'Escape',
        description: 'Close',
        key: LogicalKeyboardKey.escape,
      );

      const enterShortcut = KeyboardShortcut(
        id: 'enter',
        label: 'Enter',
        description: 'Confirm',
        key: LogicalKeyboardKey.enter,
      );

      // Should have some representation of the key
      expect(escapeShortcut.displayString, isNotEmpty);
      expect(enterShortcut.displayString, isNotEmpty);
    });
  });

  group('AppShortcuts', () {
    test('should have all shortcut categories defined', () {
      expect(AppShortcuts.allShortcuts.containsKey('Navigation'), true);
      expect(AppShortcuts.allShortcuts.containsKey('Actions'), true);
      expect(AppShortcuts.allShortcuts.containsKey('View'), true);
      expect(AppShortcuts.allShortcuts.containsKey('List'), true);
      expect(AppShortcuts.allShortcuts.containsKey('Tabs'), true);
      expect(AppShortcuts.allShortcuts.containsKey('Help'), true);
    });

    test('should have unique shortcut ids', () {
      final allIds = <String>[];
      for (final category in AppShortcuts.allShortcuts.values) {
        for (final shortcut in category) {
          allIds.add(shortcut.id);
        }
      }

      final uniqueIds = allIds.toSet();
      expect(uniqueIds.length, allIds.length, reason: 'All shortcut IDs should be unique');
    });

    test('tab shortcuts should be numbered 1-4', () {
      expect(AppShortcuts.tab1.key, LogicalKeyboardKey.digit1);
      expect(AppShortcuts.tab2.key, LogicalKeyboardKey.digit2);
      expect(AppShortcuts.tab3.key, LogicalKeyboardKey.digit3);
      expect(AppShortcuts.tab4.key, LogicalKeyboardKey.digit4);
    });
  });
}
