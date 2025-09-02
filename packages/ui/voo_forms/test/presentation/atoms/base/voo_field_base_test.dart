import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_field_base.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_form_field_widget.dart';

// Test implementation of VooFieldBase
class TestField extends VooFieldBase<String> {
  const TestField({
    super.key,
    required super.name,
    super.label,
    super.value,
    super.initialValue,
    super.required,
    super.error,
    super.helper,
  });
  
  @override
  Widget build(BuildContext context) => Container(
      key: Key('test-field-$name'),
      child: Text(label ?? name),
    );
}

void main() {
  group('VooFieldBase', () {
    test('implements VooFormFieldWidget interface', () {
      const field = TestField(name: 'test');
      expect(field, isA<VooFormFieldWidget>());
    });
    
    test('has required properties', () {
      const field = TestField(
        name: 'testField',
        label: 'Test Label',
        required: true,
        initialValue: 'initial',
      );
      
      expect(field.name, 'testField');
      expect(field.label, 'Test Label');
      expect(field.required, true);
      expect(field.initialValue, 'initial');
    });
    
    testWidgets('builds label correctly', (WidgetTester tester) async {
      const field = TestField(
        name: 'test',
        label: 'Test Field',
        required: true,
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
      const field = TestField(
        name: 'test',
        label: 'Test Field',
        required: true,
      );
      
      expect(field.validate(null), 'Test Field is required');
      expect(field.validate(''), 'Test Field is required');
      expect(field.validate('value'), null);
    });
  });
}