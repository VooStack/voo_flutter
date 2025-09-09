import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('Dropdown Overlay Consistency Tests', () {
    testWidgets('VooDropdownField closes on outside click', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDropdownField<String>(
              name: 'test',
              options: const ['Option 1', 'Option 2', 'Option 3'],
              label: 'Test Dropdown',
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(VooDropdownField<String>));
      await tester.pumpAndSettle();

      // Verify dropdown is open by checking for search field
      expect(find.text('Search...'), findsOneWidget);

      // Click outside the dropdown
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      // Verify dropdown is closed
      expect(find.text('Search...'), findsNothing);
    });

    testWidgets('VooMultiSelectField closes on outside click', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooMultiSelectField<String>(
              name: 'test',
              options: const ['Option 1', 'Option 2', 'Option 3'],
              label: 'Test MultiSelect',
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(VooMultiSelectField<String>));
      await tester.pumpAndSettle();

      // Verify dropdown is open by checking for search field
      expect(find.text('Search...'), findsOneWidget);

      // Click outside the dropdown
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      // Verify dropdown is closed
      expect(find.text('Search...'), findsNothing);
    });

    testWidgets('VooMultiSelectField maintains selection after closing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooMultiSelectField<String>(
              name: 'test',
              options: const ['Option 1', 'Option 2', 'Option 3'],
              label: 'Test MultiSelect',
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(VooMultiSelectField<String>));
      await tester.pumpAndSettle();

      // Select first option
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      // Close dropdown by clicking outside
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      // Verify selection is maintained (chip is shown)
      expect(find.text('Option 1'), findsOneWidget);

      // Reopen dropdown
      await tester.tap(find.byType(VooMultiSelectField<String>));
      await tester.pumpAndSettle();

      // Verify checkbox is still checked
      final checkbox = find.byType(Checkbox).first;
      final checkboxWidget = tester.widget<Checkbox>(checkbox);
      expect(checkboxWidget.value, isTrue);
    });

    testWidgets('Both dropdowns have consistent search behavior', (tester) async {
      // Test VooDropdownField search
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDropdownField<String>(
              name: 'test',
              options: const ['Apple', 'Banana', 'Cherry'],
              label: 'Test Dropdown',
            ),
          ),
        ),
      );

      await tester.tap(find.byType(VooDropdownField<String>));
      await tester.pumpAndSettle();

      // Enter search query
      await tester.enterText(find.byType(TextField), 'Ban');
      await tester.pumpAndSettle();

      // Verify filtering works
      expect(find.text('Banana'), findsOneWidget);
      expect(find.text('Apple'), findsNothing);
      expect(find.text('Cherry'), findsNothing);

      // Clear and test MultiSelect
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooMultiSelectField<String>(
              name: 'test',
              options: const ['Apple', 'Banana', 'Cherry'],
              label: 'Test MultiSelect',
            ),
          ),
        ),
      );

      await tester.tap(find.byType(VooMultiSelectField<String>));
      await tester.pumpAndSettle();

      // Enter search query
      await tester.enterText(find.byType(TextField), 'Ban');
      await tester.pumpAndSettle();

      // Verify filtering works consistently
      expect(find.text('Banana'), findsOneWidget);
      expect(find.text('Apple'), findsNothing);
      expect(find.text('Cherry'), findsNothing);
    });
  });
}