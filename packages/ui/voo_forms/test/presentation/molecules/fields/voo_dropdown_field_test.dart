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
      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
    });

    testWidgets('shows required indicator when required', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDropdownField<String>(
              name: 'country',
              label: 'Country',
              options: ['USA', 'Canada'],
              required: true,
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

      // Open dropdown
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      // Select 'Canada'
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
      
      // First select an item
      await tester.tap(find.byType(DropdownButtonFormField<int>));
      await tester.pumpAndSettle();
      
      // The dropdown should show the options with displayTextBuilder formatting
      // Look for the dropdown menu items in the overlay
      expect(find.text('Number: 1').last, findsOneWidget);
      expect(find.text('Number: 2').last, findsOneWidget);
      expect(find.text('Number: 3').last, findsOneWidget);
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

      final dropdown = tester.widget<DropdownButtonFormField<String>>(
        find.byType(DropdownButtonFormField<String>),
      );
      expect(dropdown.onChanged, null);
    });

    testWidgets('validates required field', (WidgetTester tester) async {
      const field = VooDropdownField<String>(
        name: 'country',
        label: 'Country',
        options: ['USA', 'Canada'],
        required: true,
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
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
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

      // Open dropdown
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      expect(find.text('USA'), findsOneWidget);
      expect(find.text('Canada'), findsOneWidget);
      expect(find.text('Mexico'), findsOneWidget);
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

      // Wait for async operation to complete
      await tester.pumpAndSettle();

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
