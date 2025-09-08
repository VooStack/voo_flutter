import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_field_base.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_form_field_widget.dart';
import 'package:voo_forms/voo_forms.dart';

// Test implementation of VooFieldBase
class TestField extends VooFieldBase<String> {
  const TestField({
    super.key,
    required super.name,
    super.label,
    super.initialValue,
    super.error,
    super.helper,
    super.validators,
  });

  @override
  Widget build(BuildContext context) => Container(
        key: Key('test-field-$name'),
        child: Text(label ?? name),
      );

  @override
  TestField copyWith({
    String? initialValue,
    String? label,
    VooFieldLayout? layout,
    String? name,
    bool? readOnly,
  }) =>
      TestField(
        key: key,
        name: name ?? this.name,
        label: label ?? this.label,
        initialValue: initialValue ?? this.initialValue,
        error: error,
        helper: helper,
      );
}

void main() {
  group('VooFieldBase', () {
    test('implements VooFormFieldWidget interface', () {
      const field = TestField(name: 'test');
      expect(field, isA<VooFormFieldWidget>());
    });

    test('has required properties', () {
      final field = TestField(
        name: 'testField',
        label: 'Test Label',
        initialValue: 'initial',
        validators: [VooValidator.required()],
      );

      expect(field.name, 'testField');
      expect(field.label, 'Test Label');
      expect(field.isRequired, true);
      expect(field.initialValue, 'initial');
    });

    testWidgets('builds label correctly', (WidgetTester tester) async {
      final field = TestField(
        name: 'test',
        label: 'Test Field',
        validators: [VooValidator.required()],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => field.buildLabel(context),
            ),
          ),
        ),
      );

      expect(find.text('Test Field'), findsOneWidget);
      expect(find.text(' *'), findsOneWidget); // Required indicator
    });

    testWidgets('builds error message correctly', (WidgetTester tester) async {
      const field = TestField(
        name: 'test',
        error: 'This field has an error',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => field.buildError(context),
            ),
          ),
        ),
      );

      expect(find.text('This field has an error'), findsOneWidget);
    });

    testWidgets('builds helper text correctly', (WidgetTester tester) async {
      const field = TestField(
        name: 'test',
        helper: 'This is helper text',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => field.buildHelper(context),
            ),
          ),
        ),
      );

      expect(find.text('This is helper text'), findsOneWidget);
    });

    test('validates required field', () {
      final field = TestField(
        name: 'test',
        label: 'Test Field',
        validators: [VooValidator.required()],
      );

      expect(field.validate(null), 'This field is required');
      expect(field.validate(''), 'This field is required');
      expect(field.validate('value'), null);
    });
  });
}
