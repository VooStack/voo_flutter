import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('VooMultiSelectField', () {
    // Sample test data
    final testOptions = ['Option 1', 'Option 2', 'Option 3', 'Option 4'];
    
    Widget buildTestApp({
      required Widget child,
      VooFormController? controller,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: controller != null
                  ? VooForm(
                      controller: controller,
                      fields: [child as VooFormFieldWidget],
                    )
                  : child,
            ),
          ),
        ),
      );
    }

    testWidgets('displays empty selection text when no items selected', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: VooMultiSelectField<String>(
            name: 'multiselect',
            options: testOptions,
            emptySelectionText: 'Please select items',
          ),
        ),
      );

      expect(find.text('Please select items'), findsOneWidget);
    });

    testWidgets('displays placeholder when no empty text provided', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: VooMultiSelectField<String>(
            name: 'multiselect',
            options: testOptions,
            placeholder: 'Select multiple options',
          ),
        ),
      );

      // The placeholder appears in the chips area when no items are selected
      expect(find.text('Select multiple options'), findsWidgets);
    });

    testWidgets('displays initial values as chips', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: VooMultiSelectField<String>(
            name: 'multiselect',
            options: testOptions,
            initialValue: ['Option 1', 'Option 3'],
          ),
        ),
      );

      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Option 3'), findsOneWidget);
      expect(find.byType(Chip), findsNWidgets(2));
    });

    testWidgets('shows +N more when selections exceed maxChipsDisplay', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: VooMultiSelectField<String>(
            name: 'multiselect',
            options: testOptions,
            initialValue: testOptions,
            maxChipsDisplay: 2,
          ),
        ),
      );

      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Option 2'), findsOneWidget);
      expect(find.text('+2 more'), findsOneWidget);
      expect(find.byType(Chip), findsNWidgets(3)); // 2 items + 1 more chip
    });

    testWidgets('opens dropdown overlay when tapped', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: VooMultiSelectField<String>(
            name: 'multiselect',
            options: testOptions,
          ),
        ),
      );

      // Initially, overlay is not shown
      expect(find.byType(TextField), findsNothing);

      // Tap to open dropdown
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Search field should be visible in overlay
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search...'), findsOneWidget);
    });

    testWidgets('shows all options in dropdown', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: VooMultiSelectField<String>(
            name: 'multiselect',
            options: testOptions,
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // All options should be visible
      for (final option in testOptions) {
        expect(find.text(option), findsWidgets); // At least one (might be in both list and input)
      }
      
      // Should have checkboxes for each option
      expect(find.byType(Checkbox), findsNWidgets(testOptions.length));
    });

    testWidgets('filters options based on search', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: VooMultiSelectField<String>(
            name: 'multiselect',
            options: testOptions,
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Enter search query
      await tester.enterText(find.byType(TextField), '2');
      await tester.pumpAndSettle();

      // Only Option 2 should be visible in the list
      expect(find.widgetWithText(ListTile, 'Option 2'), findsOneWidget);
      expect(find.widgetWithText(ListTile, 'Option 1'), findsNothing);
      expect(find.widgetWithText(ListTile, 'Option 3'), findsNothing);
    });

    testWidgets('selects item when checkbox is tapped', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: VooMultiSelectField<String>(
            name: 'multiselect',
            options: testOptions,
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Tap first checkbox
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      // Close dropdown
      await tester.tapAt(const Offset(10, 10)); // Tap outside
      await tester.pumpAndSettle();

      // Selected item should appear as chip
      expect(find.widgetWithText(Chip, 'Option 1'), findsOneWidget);
    });

    testWidgets('deselects item when chip delete is tapped', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: VooMultiSelectField<String>(
            name: 'multiselect',
            options: testOptions,
            initialValue: ['Option 1'],
          ),
        ),
      );

      // Initially should have one chip
      expect(find.widgetWithText(Chip, 'Option 1'), findsOneWidget);

      // Tap delete icon on chip
      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pumpAndSettle();

      // Chip should be removed
      expect(find.widgetWithText(Chip, 'Option 1'), findsNothing);
      expect(find.text('Select items...'), findsOneWidget);
    });

    testWidgets('shows select all button when enabled', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: VooMultiSelectField<String>(
            name: 'multiselect',
            options: testOptions,
            showSelectAll: true,
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Select All button should be visible
      expect(find.text('Select All'), findsOneWidget);
    });

    testWidgets('selects all items when select all is tapped', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: VooMultiSelectField<String>(
            name: 'multiselect',
            options: testOptions,
            showSelectAll: true,
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Tap Select All
      await tester.tap(find.text('Select All'));
      await tester.pumpAndSettle();

      // Close dropdown
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      // All items should be selected (first 3 visible + 1 more)
      expect(find.byType(Chip), findsNWidgets(4)); // 3 items + 1 more chip
    });

    testWidgets('shows clear all button in dropdown when items selected', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: VooMultiSelectField<String>(
            name: 'multiselect',
            options: testOptions,
            initialValue: ['Option 1', 'Option 2'],
            showClearAll: true,
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      
      // Clear All button should be visible in dropdown
      expect(find.text('Clear All'), findsOneWidget);
    });

    testWidgets('clears all selections when clear all is tapped', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: VooMultiSelectField<String>(
            name: 'multiselect',
            options: testOptions,
            initialValue: testOptions,
            showClearAll: true,
          ),
        ),
      );

      // Initially should have selections
      expect(find.byType(Chip), findsWidgets);

      // Open dropdown
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      
      // Tap clear all button in dropdown
      await tester.tap(find.text('Clear All'));
      await tester.pumpAndSettle();

      // All selections should be cleared
      expect(find.byType(Chip), findsNothing);
      expect(find.text('Select items...'), findsOneWidget);
    });

    testWidgets('calls onChanged when selection changes', (tester) async {
      List<String>? changedValue;
      
      await tester.pumpWidget(
        buildTestApp(
          child: VooMultiSelectField<String>(
            name: 'multiselect',
            options: testOptions,
            onChanged: (value) => changedValue = value,
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Select first item
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      expect(changedValue, ['Option 1']);
    });

    testWidgets('integrates with VooFormController', (tester) async {
      final controller = VooFormController();
      
      await tester.pumpWidget(
        buildTestApp(
          controller: controller,
          child: VooMultiSelectField<String>(
            name: 'multiselect',
            options: testOptions,
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Select items
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Checkbox).at(1));
      await tester.pumpAndSettle();

      // Controller should have the selected values
      final value = controller.getValue('multiselect') as List<String>?;
      expect(value, ['Option 1', 'Option 2']);
    });

    testWidgets('respects readOnly state', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: VooMultiSelectField<String>(
            name: 'multiselect',
            options: testOptions,
            initialValue: ['Option 1'],
            readOnly: true,
          ),
        ),
      );

      // Tap should not open dropdown
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Dropdown should not be open
      expect(find.byType(TextField), findsNothing);
      
      // Delete button on chip should not be shown when readOnly
      expect(find.byIcon(Icons.close), findsNothing);
      
      // Chip should still be there
      expect(find.widgetWithText(Chip, 'Option 1'), findsOneWidget);
    });

    testWidgets('respects enabled state', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: VooMultiSelectField<String>(
            name: 'multiselect',
            options: testOptions,
            enabled: false,
          ),
        ),
      );

      // Tap should not open dropdown
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Dropdown should not be open
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('uses custom displayTextBuilder', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: VooMultiSelectField<int>(
            name: 'multiselect',
            options: [1, 2, 3, 4],
            initialValue: [1, 3],
            displayTextBuilder: (value) => 'Item #$value',
          ),
        ),
      );

      expect(find.text('Item #1'), findsOneWidget);
      expect(find.text('Item #3'), findsOneWidget);
    });

    testWidgets('applies custom search filter', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: VooMultiSelectField<String>(
            name: 'multiselect',
            options: testOptions,
            searchFilter: (item, query) => item.endsWith(query),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Search for items ending with '3'
      await tester.enterText(find.byType(TextField), '3');
      await tester.pumpAndSettle();

      // Only Option 3 should match
      expect(find.widgetWithText(ListTile, 'Option 3'), findsOneWidget);
      expect(find.widgetWithText(ListTile, 'Option 1'), findsNothing);
    });

    testWidgets('displays label when provided', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: VooMultiSelectField<String>(
            name: 'multiselect',
            options: testOptions,
            label: 'Select Multiple Items',
          ),
        ),
      );

      expect(find.text('Select Multiple Items'), findsOneWidget);
    });

    testWidgets('displays helper text when provided', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: VooMultiSelectField<String>(
            name: 'multiselect',
            options: testOptions,
            helper: 'You can select multiple options',
          ),
        ),
      );

      expect(find.text('You can select multiple options'), findsOneWidget);
    });

    testWidgets('displays validation error', (tester) async {
      final controller = VooFormController();
      
      await tester.pumpWidget(
        buildTestApp(
          controller: controller,
          child: VooMultiSelectField<String>(
            name: 'multiselect',
            options: testOptions,
            validators: [
              CustomValidation<List<String>>(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select at least one option';
                  }
                  return null;
                },
                errorMessage: 'Please select at least one option',
              ),
            ],
          ),
        ),
      );

      // Validate form
      controller.validate();
      await tester.pumpAndSettle();

      // Error should be displayed
      expect(find.text('Please select at least one option'), findsOneWidget);
    });
  });

  group('VooAsyncMultiSelectField', () {
    // Async options loader
    Future<List<String>> loadOptions(String query) async {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      final allOptions = ['Async 1', 'Async 2', 'Async 3', 'Async 4'];
      if (query.isEmpty) return allOptions;
      return allOptions.where((o) => o.toLowerCase().contains(query.toLowerCase())).toList();
    }

    Widget buildTestApp({
      required Widget child,
      VooFormController? controller,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: controller != null
                  ? VooForm(
                      controller: controller,
                      fields: [child as VooFormFieldWidget],
                    )
                  : child,
            ),
          ),
        ),
      );
    }

    testWidgets('loads initial options on mount', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: VooAsyncMultiSelectField<String>(
            name: 'async_multiselect',
            asyncOptionsLoader: loadOptions,
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(InkWell).first);
      await tester.pump(); // Start loading
      
      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // Wait for loading to complete
      await tester.pumpAndSettle();

      // Options should be loaded
      expect(find.text('Async 1'), findsOneWidget);
      expect(find.text('Async 2'), findsOneWidget);
      expect(find.text('Async 3'), findsOneWidget);
      expect(find.text('Async 4'), findsOneWidget);
    });

    testWidgets('searches with debounce', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: VooAsyncMultiSelectField<String>(
            name: 'async_multiselect',
            asyncOptionsLoader: loadOptions,
            searchDebounce: const Duration(milliseconds: 200),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Type search query
      await tester.enterText(find.byType(TextField), '2');
      
      // Should still show all options (debounce not triggered yet)
      expect(find.widgetWithText(ListTile, 'Async 1'), findsOneWidget);
      
      // Wait for debounce and loading
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Should only show filtered results
      expect(find.widgetWithText(ListTile, 'Async 2'), findsOneWidget);
      expect(find.widgetWithText(ListTile, 'Async 1'), findsNothing);
    });

    testWidgets('maintains selections across searches', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: VooAsyncMultiSelectField<String>(
            name: 'async_multiselect',
            asyncOptionsLoader: loadOptions,
          ),
        ),
      );

      // Open dropdown and wait for initial load
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Select first item
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      // Search for different items
      await tester.enterText(find.byType(TextField), '3');
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      // Previous selection should still show as chip
      expect(find.widgetWithText(Chip, 'Async 1'), findsOneWidget);
    });

    testWidgets('handles async loading errors gracefully', (tester) async {
      Future<List<String>> errorLoader(String query) async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
        throw Exception('Failed to load options');
      }

      await tester.pumpWidget(
        buildTestApp(
          child: VooAsyncMultiSelectField<String>(
            name: 'async_multiselect',
            asyncOptionsLoader: errorLoader,
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(InkWell).first);
      await tester.pump(); // Start loading
      
      // Should show loading initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // Wait for error (avoid pumpAndSettle as it may timeout with error state)
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(); // Allow one more frame for error handling

      // Loading should be hidden after error
      // Note: The widget may show an error state or empty state
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('uses custom loading indicator', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: VooAsyncMultiSelectField<String>(
            name: 'async_multiselect',
            asyncOptionsLoader: loadOptions,
            loadingIndicator: const Text('Loading options...'),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(InkWell).first);
      await tester.pump(); // Start loading
      
      // Should show custom loading indicator
      expect(find.text('Loading options...'), findsOneWidget);
      
      await tester.pumpAndSettle();
    });
  });
}