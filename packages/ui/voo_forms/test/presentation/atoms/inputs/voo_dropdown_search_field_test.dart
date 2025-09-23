import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/inputs/voo_dropdown_search_field.dart';

void main() {
  group('VooDropdownSearchField', () {
    Widget wrapInApp(Widget child) => MaterialApp(home: Scaffold(body: child));

    testWidgets('dismisses dropdown when clicking outside', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const Column(
            children: [
              VooDropdownSearchField<String>(items: ['Option 1', 'Option 2', 'Option 3'], value: 'Option 1'),
              SizedBox(height: 100),
              Text('Outside Area'),
            ],
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      // Dropdown should be open (search field visible)
      expect(find.text('Search...'), findsOneWidget);

      // Click outside by tapping at a specific position
      // Use bottom-right corner which should be outside any dropdown overlay
      await tester.tapAt(const Offset(750, 550));
      await tester.pumpAndSettle();

      // Dropdown should be closed (search field not visible)
      expect(find.text('Search...'), findsNothing);
    });

    testWidgets('dismisses dropdown with async search when clicking outside', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          Column(
            children: [
              VooDropdownSearchField<String>(items: const [], value: 'A', asyncSearch: (query) async => ['A', 'B', 'C']),
              const SizedBox(height: 100),
              const Text('Outside Area'),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Open dropdown
      await tester.tap(find.text('A'));
      await tester.pumpAndSettle();

      // Dropdown should be open
      expect(find.text('Search...'), findsOneWidget);

      // Click outside by tapping at a specific position
      // Use bottom-right corner which should be outside any dropdown overlay
      await tester.tapAt(const Offset(750, 550));
      await tester.pumpAndSettle();

      // Dropdown should be closed
      expect(find.text('Search...'), findsNothing);
    });

    testWidgets('displays initial value', (tester) async {
      const initialValue = 'Option 2';

      await tester.pumpWidget(wrapInApp(const VooDropdownSearchField<String>(items: ['Option 1', 'Option 2', 'Option 3'], value: initialValue)));

      expect(find.text(initialValue), findsOneWidget);
    });

    testWidgets('displays initial value with displayTextBuilder', (tester) async {
      const initialValue = 2;

      await tester.pumpWidget(
        wrapInApp(VooDropdownSearchField<int>(items: const [1, 2, 3], value: initialValue, displayTextBuilder: (value) => 'Number $value')),
      );

      expect(find.text('Number 2'), findsOneWidget);
    });

    testWidgets('updates selected value when item is tapped', (tester) async {
      String? selectedValue = 'Option 1';

      await tester.pumpWidget(
        wrapInApp(
          StatefulBuilder(
            builder: (context, setState) => VooDropdownSearchField<String>(
              items: const ['Option 1', 'Option 2', 'Option 3'],
              value: selectedValue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                });
              },
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      // Select Option 2
      await tester.tap(find.text('Option 2').last);
      await tester.pumpAndSettle();

      // Value should be updated
      expect(find.text('Option 2'), findsOneWidget);
      expect(selectedValue, 'Option 2');
    });

    testWidgets('filters items based on search term', (tester) async {
      await tester.pumpWidget(wrapInApp(const VooDropdownSearchField<String>(items: ['Apple', 'Banana', 'Cherry', 'Date'], value: 'Apple')));

      // Open dropdown
      await tester.tap(find.text('Apple'));
      await tester.pumpAndSettle();

      // All items should be visible initially
      expect(find.text('Banana'), findsOneWidget);
      expect(find.text('Cherry'), findsOneWidget);
      expect(find.text('Date'), findsOneWidget);

      // Enter search term
      await tester.enterText(find.byType(TextField), 'an');
      await tester.pumpAndSettle();

      // Only matching items should be visible
      expect(find.text('Banana'), findsOneWidget);
      expect(find.text('Cherry'), findsNothing);
      expect(find.text('Date'), findsNothing);
    });

    testWidgets('shows loading indicator when async search is in progress', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          VooDropdownSearchField<String>(
            items: const [],
            asyncSearch: (query) async {
              await Future<void>.delayed(const Duration(milliseconds: 100));
              return ['Result 1', 'Result 2'];
            },
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(InkWell));
      await tester.pump();

      // Enter search term
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      // Loading indicator should be visible
      expect(find.byType(LinearProgressIndicator), findsOneWidget);

      // Complete async operation
      await tester.pumpAndSettle();

      // Loading indicator should be gone
      expect(find.byType(LinearProgressIndicator), findsNothing);
    });

    testWidgets('shows check icon for selected item', (tester) async {
      await tester.pumpWidget(wrapInApp(const VooDropdownSearchField<String>(items: ['Option 1', 'Option 2', 'Option 3'], value: 'Option 2')));

      // Open dropdown
      await tester.tap(find.text('Option 2'));
      await tester.pumpAndSettle();

      // Check icon should be next to selected item
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('respects enabled property', (tester) async {
      await tester.pumpWidget(wrapInApp(const VooDropdownSearchField<String>(items: ['Option 1', 'Option 2'], value: 'Option 1', enabled: false)));

      // Try to tap the disabled dropdown
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      // Dropdown should not open
      expect(find.text('Search...'), findsNothing);
    });
  });
}
