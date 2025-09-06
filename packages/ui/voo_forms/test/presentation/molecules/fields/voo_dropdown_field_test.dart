import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_dropdown_field.dart';

void main() {
  group('VooDropdownField', () {
    testWidgets('renders with label', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDropdownField<String>(
              name: 'country',
              label: 'Country',
              options: ['USA', 'Canada', 'Mexico'],
            ),
          ),
        ),
      );

      expect(find.text('Country'), findsOneWidget);
      // VooDropdownField uses VooDropdownSearchField which uses TextFormField
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('shows required indicator when required', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDropdownField<String>(
              name: 'country',
              label: 'Country',
              options: ['USA', 'Canada'],
            ),
          ),
        ),
      );

      expect(find.text('Country'), findsOneWidget);
      expect(find.text(' *'), findsOneWidget);
    });

    testWidgets('displays placeholder text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDropdownField<String>(
              name: 'country',
              placeholder: 'Select a country',
              options: ['USA', 'Canada'],
            ),
          ),
        ),
      );

      expect(find.text('Select a country'), findsOneWidget);
    });

    testWidgets('displays initial value', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDropdownField<String>(
              name: 'country',
              initialValue: 'Canada',
              options: ['USA', 'Canada', 'Mexico'],
            ),
          ),
        ),
      );

      expect(find.text('Canada'), findsOneWidget);
    });

    testWidgets('calls onChanged when selection changes', (WidgetTester tester) async {
      String? selectedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDropdownField<String>(
              name: 'country',
              options: const ['USA', 'Canada', 'Mexico'],
              onChanged: (value) {
                selectedValue = value;
              },
            ),
          ),
        ),
      );

      // Open dropdown by tapping the TextFormField
      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();

      // Select 'Canada' from the dropdown overlay
      await tester.tap(find.text('Canada').last);
      await tester.pumpAndSettle();

      expect(selectedValue, 'Canada');
    });

    testWidgets('uses displayTextBuilder for custom display', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDropdownField<int>(
              name: 'number',
              options: const [1, 2, 3],
              displayTextBuilder: (value) => 'Number: $value',
            ),
          ),
        ),
      );

      // Test that the items are created with displayTextBuilder
      // (Rather than testing the opened dropdown menu which may have timing issues)
      // We can verify this by selecting an item and checking the displayed value

      // Open dropdown by tapping the TextFormField
      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();

      // The dropdown should show the options with displayTextBuilder formatting
      // Look for the dropdown menu items in the overlay
      expect(find.text('Number: 1'), findsWidgets);
      expect(find.text('Number: 2'), findsWidgets);
      expect(find.text('Number: 3'), findsWidgets);
    });

    testWidgets('shows error message', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDropdownField<String>(
              name: 'country',
              options: ['USA', 'Canada'],
              error: 'Please select a country',
            ),
          ),
        ),
      );

      expect(find.text('Please select a country'), findsOneWidget);
    });

    testWidgets('shows helper text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDropdownField<String>(
              name: 'country',
              options: ['USA', 'Canada'],
              helper: 'Select your country of residence',
            ),
          ),
        ),
      );

      expect(find.text('Select your country of residence'), findsOneWidget);
    });

    testWidgets('is disabled when enabled is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDropdownField<String>(
              name: 'country',
              options: ['USA', 'Canada'],
              enabled: false,
              initialValue: 'USA',
            ),
          ),
        ),
      );

      // When disabled, the TextFormField should be disabled
      final textFormField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );
      expect(textFormField.enabled, false);
    });

    testWidgets('validates required field', (WidgetTester tester) async {
      const field = VooDropdownField<String>(
        name: 'country',
        label: 'Country',
        options: ['USA', 'Canada'],
      );

      expect(field.validate(null), 'Country is required');
      expect(field.validate('USA'), null);
    });

    testWidgets('does not show duplicate labels', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDropdownField<String>(
              name: 'country',
              label: 'Country',
              options: ['USA', 'Canada'],
            ),
          ),
        ),
      );

      // Should only find one instance of the label text
      expect(find.text('Country'), findsOneWidget);
    });
  });

  group('VooAsyncDropdownField', () {
    testWidgets('shows loading state initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooAsyncDropdownField<String>(
              name: 'async_country',
              label: 'Country',
              placeholder: 'Loading countries...',
              asyncOptionsLoader: (query) async {
                await Future<void>.delayed(const Duration(milliseconds: 100));
                return ['USA', 'Canada', 'Mexico'];
              },
            ),
          ),
        ),
      );

      expect(find.text('Loading countries...'), findsOneWidget);
      // CircularProgressIndicator might be part of the loading state
      expect(find.byType(CircularProgressIndicator), findsWidgets);

      // Wait for the async operation to complete to avoid timer issues
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
    });

    testWidgets('loads options asynchronously', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooAsyncDropdownField<String>(
              name: 'async_country',
              label: 'Country',
              asyncOptionsLoader: (query) async => ['USA', 'Canada', 'Mexico'],
            ),
          ),
        ),
      );

      // Wait for async operation to complete
      await tester.pumpAndSettle();

      // Open dropdown by tapping the TextFormField
      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();

      // Check items are in the dropdown overlay
      expect(find.text('USA'), findsWidgets);
      expect(find.text('Canada'), findsWidgets);
      expect(find.text('Mexico'), findsWidgets);
    });

    testWidgets('handles async loader errors gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooAsyncDropdownField<String>(
              name: 'async_country',
              label: 'Country',
              asyncOptionsLoader: (query) async {
                throw Exception('Failed to load');
              },
            ),
          ),
        ),
      );

      // Wait for async operation to complete with timeout
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      // Should not show loading indicator after error
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('uses custom loading indicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooAsyncDropdownField<String>(
              name: 'async_country',
              label: 'Country',
              loadingIndicator: const Text('Loading...'),
              asyncOptionsLoader: (query) async {
                await Future<void>.delayed(const Duration(milliseconds: 100));
                return ['USA', 'Canada'];
              },
            ),
          ),
        ),
      );

      expect(find.text('Loading...'), findsOneWidget);

      // Wait for the async operation to complete to avoid timer issues
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
    });

    testWidgets('displays initial value immediately', (WidgetTester tester) async {
      const initialValue = 'Canada';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooAsyncDropdownField<String>(
              name: 'async_country',
              label: 'Country',
              asyncOptionsLoader: (query) async {
                await Future<void>.delayed(const Duration(milliseconds: 100));
                return ['USA', 'Canada', 'Mexico'];
              },
              initialValue: initialValue,
            ),
          ),
        ),
      );

      // Initial value should be displayed immediately before async load
      expect(find.text(initialValue), findsOneWidget);

      // Complete async operations
      await tester.pumpAndSettle();

      // Value should still be displayed
      expect(find.text(initialValue), findsOneWidget);
    });

    testWidgets('displays initial value with custom displayTextBuilder', (WidgetTester tester) async {
      const initialValue = 42;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooAsyncDropdownField<int>(
              name: 'async_id',
              label: 'ID',
              asyncOptionsLoader: (query) async {
                await Future<void>.delayed(const Duration(milliseconds: 100));
                return [41, 42, 43];
              },
              initialValue: initialValue,
              displayTextBuilder: (value) => 'ID: $value',
            ),
          ),
        ),
      );

      // Initial value should be displayed with custom format
      expect(find.text('ID: 42'), findsOneWidget);

      // Complete async operations
      await tester.pumpAndSettle();

      // Value should still be displayed
      expect(find.text('ID: 42'), findsOneWidget);
    });

    testWidgets('preserves selected value after async load', (WidgetTester tester) async {
      const initialValue = 'Mexico';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooAsyncDropdownField<String>(
              name: 'async_country',
              label: 'Country',
              asyncOptionsLoader: (query) async {
                await Future<void>.delayed(const Duration(milliseconds: 100));
                return ['USA', 'Canada', 'Mexico'];
              },
              initialValue: initialValue,
            ),
          ),
        ),
      );

      // Initial value displayed
      expect(find.text(initialValue), findsOneWidget);

      // Complete async load
      await tester.pumpAndSettle();

      // Open dropdown
      await tester.tap(find.text(initialValue));
      await tester.pumpAndSettle();

      // Should show check mark next to selected item
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('shows initial value even when not in async loaded items', (WidgetTester tester) async {
      const initialValue = 'Custom Value';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooAsyncDropdownField<String>(
              name: 'custom',
              label: 'Custom',
              asyncOptionsLoader: (query) async {
                // Return items that don't include the initial value
                await Future<void>.delayed(const Duration(milliseconds: 100));
                return ['Option A', 'Option B', 'Option C'];
              },
              initialValue: initialValue,
            ),
          ),
        ),
      );

      // Initial value should be displayed even though it's not in the async items
      expect(find.text(initialValue), findsOneWidget);

      // Complete the async operation
      await tester.pumpAndSettle();

      // Value should still be displayed
      expect(find.text(initialValue), findsOneWidget);
    });

    testWidgets('displays initial value correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooAsyncDropdownField<String>(
              name: 'dynamic',
              label: 'Dynamic',
              asyncOptionsLoader: (query) async {
                await Future<void>.delayed(const Duration(milliseconds: 50));
                return ['First Value', 'Second Value', 'Third Value'];
              },
              initialValue: 'First Value',
            ),
          ),
        ),
      );

      // Initial value should be displayed immediately
      expect(find.text('First Value'), findsOneWidget);

      // Wait for async load to complete
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      // Value should still be displayed
      expect(find.text('First Value'), findsOneWidget);
    });

    testWidgets('does not show duplicate labels', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooAsyncDropdownField<String>(
              name: 'country',
              label: 'Country',
              asyncOptionsLoader: (query) async => ['USA', 'Canada'],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should only find one instance of the label text
      expect(find.text('Country'), findsOneWidget);
    });
  });
}
