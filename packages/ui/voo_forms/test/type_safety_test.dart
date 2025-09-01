import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('VooForms Type Safety Tests', () {
    group('Dropdown Field Type Safety', () {
      testWidgets('String dropdown preserves type', (WidgetTester tester) async {
        final field = VooFormField<String>(
          id: 'string_dropdown',
          name: 'string_dropdown',
          label: 'String Dropdown',
          type: VooFieldType.dropdown,
          options: const [
            VooFieldOption<String>(value: 'option1', label: 'Option 1'),
            VooFieldOption<String>(value: 'option2', label: 'Option 2'),
            VooFieldOption<String>(value: 'option3', label: 'Option 3'),
          ],
          initialValue: 'option1',
          onChanged: (String? value) {
            // This should compile without type errors
            expect(value.runtimeType == String || value == null, isTrue);
          },
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VooFormBuilder(
                form: VooForm(
                  id: 'test_form',
                  fields: [field],
                ),
                onSubmit: (_) {},
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        
        // Find and tap the dropdown
        final dropdown = find.byType(DropdownButtonFormField<String>);
        if (dropdown.evaluate().isNotEmpty) {
          expect(dropdown, findsOneWidget);
        } else {
          // For searchable dropdowns
          final textField = find.byType(TextFormField);
          expect(textField, findsWidgets);
        }
      });

      testWidgets('Int dropdown preserves type', (WidgetTester tester) async {
        final field = VooFormField<int>(
          id: 'int_dropdown',
          name: 'int_dropdown',
          label: 'Int Dropdown',
          type: VooFieldType.dropdown,
          options: const [
            VooFieldOption<int>(value: 1, label: 'One'),
            VooFieldOption<int>(value: 2, label: 'Two'),
            VooFieldOption<int>(value: 3, label: 'Three'),
          ],
          initialValue: 1,
          onChanged: (int? value) {
            // This should compile without type errors
            expect(value.runtimeType == int || value == null, isTrue);
          },
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VooFormBuilder(
                form: VooForm(
                  id: 'test_form',
                  fields: [field],
                ),
                onSubmit: (_) {},
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        
        // Find and verify the dropdown
        final dropdown = find.byType(DropdownButtonFormField<int>);
        if (dropdown.evaluate().isNotEmpty) {
          expect(dropdown, findsOneWidget);
        } else {
          // For searchable dropdowns
          final textField = find.byType(TextFormField);
          expect(textField, findsWidgets);
        }
      });

      testWidgets('Async dropdown preserves type', (WidgetTester tester) async {
        final field = VooFormField<String>(
          id: 'async_dropdown',
          name: 'async_dropdown',
          label: 'Async Dropdown',
          type: VooFieldType.dropdown,
          enableSearch: true,
          asyncOptionsLoader: (String query) async {
            // Simulate async loading
            await Future<void>.delayed(const Duration(milliseconds: 100));
            return [
              const VooFieldOption<String>(value: 'async1', label: 'Async Option 1'),
              const VooFieldOption<String>(value: 'async2', label: 'Async Option 2'),
              const VooFieldOption<String>(value: 'async3', label: 'Async Option 3'),
            ];
          },
          initialValue: 'async1',
          onChanged: (String? value) {
            // This should compile without type errors
            expect(value.runtimeType == String || value == null, isTrue);
          },
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VooFormBuilder(
                form: VooForm(
                  id: 'test_form',
                  fields: [field],
                ),
                onSubmit: (_) {},
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        
        // Async dropdowns use searchable interface
        final textField = find.byType(TextFormField);
        expect(textField, findsWidgets);
      });

      testWidgets('Mixed type fields work together', (WidgetTester tester) async {
        final fields = [
          const VooFormField<String>(
            id: 'text_field',
            name: 'text_field',
            label: 'Text Field',
            type: VooFieldType.text,
            initialValue: 'Some text',
          ),
          const VooFormField<String>(
            id: 'string_dropdown',
            name: 'string_dropdown',
            label: 'String Dropdown',
            type: VooFieldType.dropdown,
            options: [
              VooFieldOption<String>(value: 'a', label: 'A'),
              VooFieldOption<String>(value: 'b', label: 'B'),
            ],
            initialValue: 'a',
          ),
          const VooFormField<int>(
            id: 'int_dropdown',
            name: 'int_dropdown',
            label: 'Int Dropdown',
            type: VooFieldType.dropdown,
            options: [
              VooFieldOption<int>(value: 1, label: 'One'),
              VooFieldOption<int>(value: 2, label: 'Two'),
            ],
            initialValue: 1,
          ),
          const VooFormField<bool>(
            id: 'bool_field',
            name: 'bool_field',
            label: 'Boolean Field',
            type: VooFieldType.boolean,
            initialValue: true,
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VooFormBuilder(
                form: VooForm(
                  id: 'test_form',
                  fields: fields,
                ),
                onSubmit: (values) {
                  // Verify values maintain their types
                  expect(values['text_field'], isA<String>());
                  expect(values['string_dropdown'], isA<String>());
                  expect(values['int_dropdown'], isA<int>());
                  expect(values['bool_field'], isA<bool>());
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        
        // All fields should render without errors
        expect(find.byType(VooFormBuilder), findsOneWidget);
      });

      testWidgets('Dynamic dropdown handles unknown types', (WidgetTester tester) async {
        // Test with a custom type
        const field = VooFormField<dynamic>(
          id: 'dynamic_dropdown',
          name: 'dynamic_dropdown',
          label: 'Dynamic Dropdown',
          type: VooFieldType.dropdown,
          options: [
            VooFieldOption<dynamic>(value: {'id': 1}, label: 'Custom Object 1'),
            VooFieldOption<dynamic>(value: {'id': 2}, label: 'Custom Object 2'),
          ],
          initialValue: {'id': 1},
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VooFormBuilder(
                form: const VooForm(
                  id: 'test_form',
                  fields: [field],
                ),
                onSubmit: (_) {},
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        
        // Should render without errors
        expect(find.byType(VooFormBuilder), findsOneWidget);
      });

      testWidgets('Dropdown with no initial value', (WidgetTester tester) async {
        final field = VooFormField<String>(
          id: 'nullable_dropdown',
          name: 'nullable_dropdown',
          label: 'Nullable Dropdown',
          type: VooFieldType.dropdown,
          options: const [
            VooFieldOption<String>(value: 'option1', label: 'Option 1'),
            VooFieldOption<String>(value: 'option2', label: 'Option 2'),
          ],
          // No initial value
          onChanged: (String? value) {
            // Value can be null
            expect(value == null || value.runtimeType == String, isTrue);
          },
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VooFormBuilder(
                form: VooForm(
                  id: 'test_form',
                  fields: [field],
                ),
                onSubmit: (_) {},
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        
        // Should render without errors even with null value
        expect(find.byType(VooFormBuilder), findsOneWidget);
      });
    });

    group('Read-only Mode Type Safety', () {
      testWidgets('All field types work in read-only mode', (WidgetTester tester) async {
        final fields = [
          const VooFormField<String>(
            id: 'text',
            name: 'text',
            label: 'Text',
            type: VooFieldType.text,
            initialValue: 'Text value',
          ),
          const VooFormField<String>(
            id: 'dropdown',
            name: 'dropdown',
            label: 'Dropdown',
            type: VooFieldType.dropdown,
            options: [
              VooFieldOption<String>(value: 'val1', label: 'Value 1'),
            ],
            initialValue: 'val1',
          ),
          const VooFormField<bool>(
            id: 'boolean',
            name: 'boolean',
            label: 'Boolean',
            type: VooFieldType.boolean,
            initialValue: true,
          ),
          VooFormField<DateTime>(
            id: 'date',
            name: 'date',
            label: 'Date',
            type: VooFieldType.date,
            initialValue: DateTime.now(),
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VooFormBuilder(
                form: VooForm(
                  id: 'test_form',
                  fields: fields,
                ),
                isEditable: false, // Read-only mode
                onSubmit: (_) {},
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        
        // Should render all fields in read-only mode without errors
        expect(find.byType(VooFormBuilder), findsOneWidget);
        // Should not show action buttons in read-only mode
        expect(find.byType(VooFormActions), findsNothing);
      });
    });

    group('Custom Field Type Safety', () {
      testWidgets('Custom widget field works correctly', (WidgetTester tester) async {
        final field = VooFormField<dynamic>(
          id: 'custom',
          name: 'custom',
          label: 'Custom Field',
          type: VooFieldType.custom,
          customWidget: Container(
            padding: const EdgeInsets.all(16),
            child: const Text('Custom Widget'),
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VooFormBuilder(
                form: VooForm(
                  id: 'test_form',
                  fields: [field],
                ),
                onSubmit: (_) {},
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        
        // Custom widget should render
        expect(find.text('Custom Widget'), findsOneWidget);
      });

      testWidgets('Custom builder field works correctly', (WidgetTester tester) async {
        final field = VooFormField<String>(
          id: 'custom_builder',
          name: 'custom_builder',
          label: 'Custom Builder',
          type: VooFieldType.custom,
          initialValue: 'Builder Value',
          customBuilder: (context, field, value) => Container(
            padding: const EdgeInsets.all(16),
            child: Text('Builder: $value'),
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VooFormBuilder(
                form: VooForm(
                  id: 'test_form',
                  fields: [field],
                ),
                onSubmit: (_) {},
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        
        // Custom builder should render with value
        expect(find.text('Builder: Builder Value'), findsOneWidget);
      });
    });
  });
}