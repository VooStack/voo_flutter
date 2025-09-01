import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper functions for testing dropdown fields
class DropdownTestHelpers {
  /// Finds and taps a dropdown field to open it
  static Future<void> openDropdown(WidgetTester tester, {int index = 0}) async {
    // For searchable dropdowns (using TextFormField)
    final textFields = find.byType(TextFormField);
    if (textFields.evaluate().isNotEmpty) {
      await tester.tap(textFields.at(index));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      return;
    }

    // For regular dropdowns (using DropdownButtonFormField of any generic type)
    final dropdowns = find.byWidgetPredicate((widget) {
      return widget.runtimeType.toString().startsWith('DropdownButtonFormField');
    });
    if (dropdowns.evaluate().isNotEmpty) {
      await tester.tap(dropdowns.at(index));
      await tester.pumpAndSettle();
      return;
    }

    throw TestFailure('No dropdown field found');
  }

  /// Finds a dropdown option by text and taps it
  static Future<void> selectDropdownOption(
    WidgetTester tester,
    String optionText,
  ) async {
    // Try to find the option text directly first
    var optionFinder = find.text(optionText);
    
    // If not found, try finding it in a Text widget
    if (optionFinder.evaluate().isEmpty) {
      optionFinder = find.byWidgetPredicate(
        (widget) => widget is Text && widget.data == optionText,
      );
    }

    // If still not found, look in dropdown menu items
    if (optionFinder.evaluate().isEmpty) {
      optionFinder = find.descendant(
        of: find.byType(DropdownMenuItem),
        matching: find.text(optionText),
      );
    }

    if (optionFinder.evaluate().isNotEmpty) {
      // If there are multiple matches, use the last one (typically the one in the dropdown)
      await tester.tap(optionFinder.last);
      await tester.pumpAndSettle();
    } else {
      throw TestFailure('Option "$optionText" not found in dropdown');
    }
  }

  /// Verifies that a dropdown field displays the expected value
  static void expectDropdownValue(WidgetTester tester, String expectedValue) {
    // For searchable dropdowns, check the TextFormField value
    final textFields = find.byType(TextFormField);
    if (textFields.evaluate().isNotEmpty) {
      final textField = tester.widget<TextFormField>(textFields.first);
      final controller = textField.controller;
      if (controller != null) {
        expect(controller.text, equals(expectedValue));
        return;
      }
    }

    // For regular dropdowns, check if the text is visible
    expect(find.text(expectedValue), findsOneWidget);
  }

  /// Types text into a searchable dropdown's search field
  static Future<void> searchInDropdown(
    WidgetTester tester,
    String searchText,
  ) async {
    // Find the search field (should be the last TextField when dropdown is open)
    final searchFields = find.byType(TextField);
    if (searchFields.evaluate().length > 1) {
      // The last TextField is typically the search field
      await tester.enterText(searchFields.last, searchText);
      await tester.pump();
      // Wait for debounce
      await tester.pump(const Duration(milliseconds: 300));
    } else {
      throw TestFailure('Search field not found in dropdown');
    }
  }

  /// Verifies that dropdown options are visible
  static void expectDropdownOptions(
    WidgetTester tester,
    List<String> expectedOptions,
  ) {
    for (final option in expectedOptions) {
      expect(find.text(option), findsOneWidget,
          reason: 'Option "$option" should be visible');
    }
  }

  /// Verifies that dropdown options are not visible
  static void expectDropdownOptionsAbsent(
    WidgetTester tester,
    List<String> absentOptions,
  ) {
    for (final option in absentOptions) {
      expect(find.text(option), findsNothing,
          reason: 'Option "$option" should not be visible');
    }
  }

  /// Closes an open dropdown by tapping outside
  static Future<void> closeDropdown(WidgetTester tester) async {
    // Tap on a Scaffold or Material widget to close the dropdown
    final scaffold = find.byType(Scaffold);
    if (scaffold.evaluate().isNotEmpty) {
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
    }
  }

  /// Finds a dropdown field by its label
  static Finder findDropdownByLabel(String label) {
    // Try to find TextFormField or DropdownButtonFormField
    // Note: We can't directly access decoration from the widget,
    // so this method is limited. Consider using index-based selection instead.
    return find.byWidgetPredicate(
      (widget) {
        if (widget is TextFormField || widget is DropdownButtonFormField) {
          // We can't directly check the label, but we can find the widget
          return true;
        }
        return false;
      },
    );
  }

  /// Waits for async dropdown options to load
  static Future<void> waitForAsyncOptions(WidgetTester tester) async {
    // Wait for loading indicator to appear and disappear
    await tester.pump(const Duration(milliseconds: 50));
    
    // If there's a loading indicator, wait for it to disappear
    if (find.byType(CircularProgressIndicator).evaluate().isNotEmpty) {
      // Wait for loading to complete (max 5 seconds)
      for (int i = 0; i < 50; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        if (find.byType(CircularProgressIndicator).evaluate().isEmpty) {
          break;
        }
      }
    }
    
    await tester.pump(const Duration(milliseconds: 100));
  }
}