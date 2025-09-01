import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/domain/entities/voo_field.dart';
import 'package:voo_forms/src/presentation/molecules/field_widget_factory.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';

void main() {
  group('ReadOnlyWidget Support', () {
    testWidgets('VooField.text supports readOnlyWidget', (WidgetTester tester) async {
      final customReadOnlyWidget = Container(
        key: const Key('custom-readonly'),
        child: const Text('Custom Read-Only Display'),
      );

      final field = VooField.text(
        name: 'testField',
        label: 'Test Field',
        initialValue: 'Test Value',
        readOnlyWidget: customReadOnlyWidget,
      );

      expect(field.readOnlyWidget, isNotNull);
      expect(field.readOnlyWidget, equals(customReadOnlyWidget));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                const factory = FieldWidgetFactory();
                return factory.create(
                  context: context,
                  field: field,
                  options: const VooFieldOptions(),
                  isEditable: false,
                );
              },
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('custom-readonly')), findsOneWidget);
      expect(find.text('Custom Read-Only Display'), findsOneWidget);
    });

    testWidgets('VooField.dropdown supports readOnlyWidget', (WidgetTester tester) async {
      final customReadOnlyWidget = Container(
        key: const Key('dropdown-readonly'),
        child: const Text('Selected: Option 1'),
      );

      final field = VooField.dropdownSimple(
        name: 'dropdown',
        label: 'Dropdown Field',
        options: ['Option 1', 'Option 2', 'Option 3'],
        initialValue: 'Option 1',
        readOnlyWidget: customReadOnlyWidget,
      );

      expect(field.readOnlyWidget, isNotNull);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                const factory = FieldWidgetFactory();
                return factory.create(
                  context: context,
                  field: field,
                  options: const VooFieldOptions(),
                  isEditable: false,
                );
              },
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('dropdown-readonly')), findsOneWidget);
      expect(find.text('Selected: Option 1'), findsOneWidget);
    });

    test('All VooField factory methods have readOnlyWidget parameter', () {
      final textField = VooField.text(
        name: 'text',
        readOnlyWidget: const Text('readonly'),
      );
      expect(textField.readOnlyWidget, isNotNull);

      final emailField = VooField.email(
        name: 'email',
        readOnlyWidget: const Text('readonly'),
      );
      expect(emailField.readOnlyWidget, isNotNull);

      final passwordField = VooField.password(
        name: 'password',
        readOnlyWidget: const Text('readonly'),
      );
      expect(passwordField.readOnlyWidget, isNotNull);

      final phoneField = VooField.phone(
        name: 'phone',
        readOnlyWidget: const Text('readonly'),
      );
      expect(phoneField.readOnlyWidget, isNotNull);

      final numberField = VooField.number(
        name: 'number',
        readOnlyWidget: const Text('readonly'),
      );
      expect(numberField.readOnlyWidget, isNotNull);

      final multilineField = VooField.multiline(
        name: 'multiline',
        readOnlyWidget: const Text('readonly'),
      );
      expect(multilineField.readOnlyWidget, isNotNull);

      final dropdownField = VooField.dropdown<String>(
        name: 'dropdown',
        options: ['A', 'B'],
        converter: (value) => VooFieldOption(value: value, label: value),
        readOnlyWidget: const Text('readonly'),
      );
      expect(dropdownField.readOnlyWidget, isNotNull);

      final booleanField = VooField.boolean(
        name: 'boolean',
        readOnlyWidget: const Text('readonly'),
      );
      expect(booleanField.readOnlyWidget, isNotNull);

      final checkboxField = VooField.checkbox(
        name: 'checkbox',
        readOnlyWidget: const Text('readonly'),
      );
      expect(checkboxField.readOnlyWidget, isNotNull);

      final radioField = VooField.radio(
        name: 'radio',
        options: ['A', 'B'],
        readOnlyWidget: const Text('readonly'),
      );
      expect(radioField.readOnlyWidget, isNotNull);

      final dateField = VooField.date(
        name: 'date',
        readOnlyWidget: const Text('readonly'),
      );
      expect(dateField.readOnlyWidget, isNotNull);

      final timeField = VooField.time(
        name: 'time',
        readOnlyWidget: const Text('readonly'),
      );
      expect(timeField.readOnlyWidget, isNotNull);

      final integerField = VooField.integer(
        name: 'integer',
        readOnlyWidget: const Text('readonly'),
      );
      expect(integerField.readOnlyWidget, isNotNull);

      final decimalField = VooField.decimal(
        name: 'decimal',
        readOnlyWidget: const Text('readonly'),
      );
      expect(decimalField.readOnlyWidget, isNotNull);

      final currencyField = VooField.currency(
        name: 'currency',
        readOnlyWidget: const Text('readonly'),
      );
      expect(currencyField.readOnlyWidget, isNotNull);

      final percentageField = VooField.percentage(
        name: 'percentage',
        readOnlyWidget: const Text('readonly'),
      );
      expect(percentageField.readOnlyWidget, isNotNull);

      final sliderField = VooField.slider(
        name: 'slider',
        readOnlyWidget: const Text('readonly'),
      );
      expect(sliderField.readOnlyWidget, isNotNull);
    });
  });
}