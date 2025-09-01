import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('VooField Constructor Tests', () {
    testWidgets('VooField.text() creates proper text field', (WidgetTester tester) async {
      final field = VooField.text(
        name: 'text_field',
        label: 'Text Field',
        placeholder: 'Enter text',
        initialValue: 'Initial text',
      );

      expect(field.id, 'text_field');
      expect(field.type, VooFieldType.text);
      expect(field.initialValue, 'Initial text');
      expect(field.placeholder, 'Enter text');

      // Test in a form
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
      expect(find.byType(VooTextFormField), findsOneWidget);
      expect(find.text('Initial text'), findsOneWidget);
    });

    testWidgets('VooField.dropdown() with String type', (WidgetTester tester) async {
      final field = VooField.dropdown<String>(
        name: 'dropdown_field',
        label: 'Dropdown Field',
        options: ['option1', 'option2', 'option3'],
        converter: (String value) => VooFieldOption<String>(
          value: value,
          label: value == 'option1'
              ? 'Option 1'
              : value == 'option2'
                  ? 'Option 2'
                  : 'Option 3',
        ),
        initialValue: 'option1',
      );

      expect(field.id, 'dropdown_field');
      expect(field.type, VooFieldType.dropdown);
      expect(field.initialValue, 'option1');
      expect(field.options?.length, 3);

      // Test in a form
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormBuilder(
              form: VooForm(
                id: 'test_form',
                fields: [field],
              ),
              onSubmit: (values) {
                expect(values['dropdown_field'], isA<String>());
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(VooFormBuilder), findsOneWidget);
    });

    testWidgets('VooField.dropdown() with int type', (WidgetTester tester) async {
      final field = VooField.dropdown<int>(
        name: 'int_dropdown',
        label: 'Int Dropdown',
        options: [1, 2, 3],
        converter: (int value) => VooFieldOption<int>(
          value: value,
          label: value == 1
              ? 'One'
              : value == 2
                  ? 'Two'
                  : 'Three',
        ),
        initialValue: 2,
      );

      expect(field.id, 'int_dropdown');
      expect(field.type, VooFieldType.dropdown);
      expect(field.initialValue, 2);
      expect(field.options?.length, 3);

      // Test in a form
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormBuilder(
              form: VooForm(
                id: 'test_form',
                fields: [field],
              ),
              onSubmit: (values) {
                expect(values['int_dropdown'], isA<int>());
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(VooFormBuilder), findsOneWidget);
    });

    testWidgets('VooField.dropdownAsync() with String type', (WidgetTester tester) async {
      final field = VooField.dropdownAsync<String>(
        name: 'async_dropdown',
        label: 'Async Dropdown',
        asyncOptionsLoader: (String query) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          // Return the raw values, not VooFieldOptions
          return ['async1', 'async2', 'async3'];
        },
        converter: (String value) => VooFieldOption<String>(
          value: value,
          label: 'Async - $value',
        ),
        initialValue: 'async1',
        searchHint: 'Search...',
      );

      expect(field.id, 'async_dropdown');
      expect(field.type, VooFieldType.dropdown);
      expect(field.asyncOptionsLoader, isNotNull);
      expect(field.enableSearch, isTrue);
      expect(field.searchHint, 'Search...');

      // Test in a form
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormBuilder(
              form: VooForm(
                id: 'test_form',
                fields: [field],
              ),
              onSubmit: (values) {
                expect(values['async_dropdown'] == null || values['async_dropdown'] is String, isTrue);
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(VooFormBuilder), findsOneWidget);
    });

    testWidgets('VooField.boolean() creates proper switch field', (WidgetTester tester) async {
      final field = VooField.boolean(
        name: 'bool_field',
        label: 'Boolean Field',
        initialValue: true,
      );

      expect(field.id, 'bool_field');
      expect(field.type, VooFieldType.boolean);
      expect(field.initialValue, true);

      // Test in a form
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormBuilder(
              form: VooForm(
                id: 'test_form',
                fields: [field],
              ),
              onSubmit: (values) {
                expect(values['bool_field'], isA<bool>());
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(VooSwitchFieldWidget), findsOneWidget);
    });

    testWidgets('VooField.date() creates proper date field', (WidgetTester tester) async {
      final initialDate = DateTime(2024);
      final field = VooField.date(
        name: 'date_field',
        label: 'Date Field',
        initialValue: initialDate,
      );

      expect(field.id, 'date_field');
      expect(field.type, VooFieldType.date);
      expect(field.initialValue, initialDate);

      // Test in a form
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormBuilder(
              form: VooForm(
                id: 'test_form',
                fields: [field],
              ),
              onSubmit: (values) {
                expect(values['date_field'], isA<DateTime>());
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(VooDateFieldWidget), findsOneWidget);
    });

    testWidgets('Custom field with customWidget', (WidgetTester tester) async {
      final customWidget = Container(
        key: const Key('custom_widget'),
        padding: const EdgeInsets.all(16),
        child: const Text('Custom Widget Content'),
      );

      final field = VooFormField<dynamic>(
        id: 'custom_field',
        name: 'custom_field',
        label: 'Custom Field',
        type: VooFieldType.custom,
        customWidget: customWidget,
      );

      expect(field.type, VooFieldType.custom);
      expect(field.customWidget, isNotNull);

      // Test in a form
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
      expect(find.byKey(const Key('custom_widget')), findsOneWidget);
      expect(find.text('Custom Widget Content'), findsOneWidget);
    });

    testWidgets('Custom field with customBuilder', (WidgetTester tester) async {
      final field = VooFormField<String>(
        id: 'custom_builder',
        name: 'custom_builder',
        label: 'Custom Builder',
        type: VooFieldType.custom,
        initialValue: 'Builder Value',
        customBuilder: (context, field, value) => Container(
          key: const Key('custom_builder_widget'),
          padding: const EdgeInsets.all(16),
          child: Text('Built with: $value'),
        ),
      );

      expect(field.type, VooFieldType.custom);
      expect(field.customBuilder, isNotNull);

      // Test in a form
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
      expect(find.byKey(const Key('custom_builder_widget')), findsOneWidget);
      expect(find.text('Built with: Builder Value'), findsOneWidget);
    });

    group('Mixed form with various field constructors', () {
      testWidgets('All field types work together', (WidgetTester tester) async {
        final fields = [
          VooField.text(
            name: 'name',
            label: 'Name',
            initialValue: 'John Doe',
          ),
          VooField.email(
            name: 'email',
            label: 'Email',
            initialValue: 'john@example.com',
          ),
          VooField.dropdown<String>(
            name: 'country',
            label: 'Country',
            options: ['us', 'uk', 'ca'],
            converter: (String value) => VooFieldOption<String>(
              value: value,
              label: value == 'us'
                  ? 'United States'
                  : value == 'uk'
                      ? 'United Kingdom'
                      : 'Canada',
            ),
            initialValue: 'us',
          ),
          VooField.dropdown<int>(
            name: 'age_range',
            label: 'Age Range',
            options: [1, 2, 3, 4],
            converter: (int value) => VooFieldOption<int>(
              value: value,
              label: value == 1
                  ? '18-25'
                  : value == 2
                      ? '26-35'
                      : value == 3
                          ? '36-45'
                          : '46+',
            ),
            initialValue: 2,
          ),
          VooField.boolean(
            name: 'newsletter',
            label: 'Subscribe to newsletter',
          ),
          VooField.date(
            name: 'birthdate',
            label: 'Date of Birth',
            initialValue: DateTime(1990),
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
                  // Verify all values maintain their types
                  expect(values['name'], isA<String>());
                  expect(values['email'], isA<String>());
                  expect(values['country'], isA<String>());
                  expect(values['age_range'], isA<int>());
                  expect(values['newsletter'], isA<bool>());
                  expect(values['birthdate'], isA<DateTime>());
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify all fields render without errors
        expect(find.byType(VooFormBuilder), findsOneWidget);
        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('john@example.com'), findsOneWidget);
      });

      testWidgets('Custom readOnlyWidget is used when provided', (WidgetTester tester) async {
        final customReadOnlyWidget = Container(
          key: const Key('custom_readonly'),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text('Custom Read-Only Display'),
        );

        final field = VooFormField<String>(
          id: 'field_with_readonly',
          name: 'field_with_readonly',
          type: VooFieldType.text,
          label: 'Field with Custom Read-Only',
          initialValue: 'Some value',
          readOnlyWidget: customReadOnlyWidget,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VooFormBuilder(
                form: VooForm(
                  id: 'test_form',
                  fields: [field],
                ),
                isEditable: false, // Read-only mode
                onSubmit: (_) {},
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        
        // Custom readOnlyWidget should be displayed
        expect(find.byKey(const Key('custom_readonly')), findsOneWidget);
        expect(find.text('Custom Read-Only Display'), findsOneWidget);
        
        // Should not show default read-only display
        expect(find.text('Some value'), findsNothing);
      });

      testWidgets('Default read-only display is used when no custom widget provided', (WidgetTester tester) async {
        const field = VooFormField<String>(
          id: 'field_without_readonly',
          name: 'field_without_readonly',
          type: VooFieldType.text,
          label: 'Field without Custom Read-Only',
          initialValue: 'Default display value',
          // No readOnlyWidget provided
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VooFormBuilder(
                form: const VooForm(
                  id: 'test_form',
                  fields: [field],
                ),
                isEditable: false, // Read-only mode
                onSubmit: (_) {},
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        
        // Default read-only display should show the value
        expect(find.text('Default display value'), findsOneWidget);
        // Label is shown (appears in the label position)
        expect(find.text('Field without Custom Read-Only'), findsWidgets);
      });

      testWidgets('Form toggles between editable and read-only modes', (WidgetTester tester) async {
        bool isEditable = true;

        final fields = [
          VooField.text(
            name: 'text',
            label: 'Text Field',
            initialValue: 'Some text',
          ),
          VooField.dropdown<String>(
            name: 'dropdown',
            label: 'Dropdown',
            options: ['a', 'b'],
            converter: (String value) => VooFieldOption<String>(
              value: value,
              label: value == 'a' ? 'Option A' : 'Option B',
            ),
            initialValue: 'a',
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: StatefulBuilder(
              builder: (context, setState) => Scaffold(
                appBar: AppBar(
                  title: const Text('Toggle Form'),
                  actions: [
                    Switch(
                      value: isEditable,
                      onChanged: (value) => setState(() => isEditable = value),
                    ),
                  ],
                ),
                body: VooFormBuilder(
                  form: VooForm(
                    id: 'test_form',
                    fields: fields,
                  ),
                  isEditable: isEditable,
                  onSubmit: (_) {},
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Initially editable - should show action buttons
        expect(find.byType(VooFormActions), findsOneWidget);

        // Toggle to read-only
        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();

        // Should not show action buttons in read-only mode
        expect(find.byType(VooFormActions), findsNothing);

        // Toggle back to editable
        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();

        // Should show action buttons again
        expect(find.byType(VooFormActions), findsOneWidget);
      });
    });
  });
}
