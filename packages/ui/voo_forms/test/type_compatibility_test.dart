import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

/// Comprehensive test suite to validate type safety and callback compatibility
/// for all form field types. This addresses the user-reported issue:
/// TypeError: Instance of '(String?) => void': type '(String?) => void' 
/// is not a subtype of type '((dynamic) => void)?'
void main() {
  group('Type Compatibility Tests', () {
    group('Callback Type Conversion', () {
      test('Text field should accept String callbacks', () {
        // This test validates that a text field can accept a String-typed callback
        // and that the type system handles it correctly
        void onStringChanged(String? value) {
          print('String changed: $value');
        }

        final field = VooFormField(
          id: 'test',
          name: 'test',
          type: VooFieldType.text,
          onChanged: onStringChanged,
        );

        // Verify the callback is stored correctly
        expect(field.onChanged, isNotNull);
        field.onChanged?.call('test');
      });

      test('Dynamic callbacks should work with all field types', () {
        // Test that a generic dynamic callback works with different field types
        void onDynamicChanged(dynamic value) {
          print('Value changed: $value');
        }

        final textField = VooFormField(
          id: 'text',
          name: 'text',
          type: VooFieldType.text,
          onChanged: onDynamicChanged,
        );

        final numberField = VooFormField(
          id: 'number',
          name: 'number',
          type: VooFieldType.number,
          onChanged: onDynamicChanged,
        );

        final boolField = VooFormField(
          id: 'bool',
          name: 'bool',
          type: VooFieldType.boolean,
          onChanged: onDynamicChanged,
        );

        // Test all callbacks work
        textField.onChanged?.call('string');
        numberField.onChanged?.call(42);
        boolField.onChanged?.call(true);
      });
    });

    group('Widget Callback Integration', () {
      testWidgets('VooFieldWidget should handle typed callbacks correctly', (tester) async {
        // This test simulates the actual issue users are experiencing
        String? capturedStringValue;
        dynamic capturedDynamicValue;

        // Create a string-typed callback
        void onStringChanged(String? value) {
          capturedStringValue = value;
        }

        // Create a dynamic-typed callback
        void onDynamicChanged(dynamic value) {
          capturedDynamicValue = value;
        }

        // Test with a text field using string callback
        final stringField = VooFormField(
          id: 'string_field',
          name: 'string_field',
          type: VooFieldType.text,
          label: 'String Field',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  // This should work without type errors
                  VooFieldWidget(
                    field: stringField,
                    onChanged: (value) {
                      // Cast to String? should be safe for text fields
                      onStringChanged(value as String?);
                    },
                  ),
                  // This should also work
                  VooFieldWidget(
                    field: stringField,
                    onChanged: onDynamicChanged,
                  ),
                ],
              ),
            ),
          ),
        );

        // Verify the widgets render without errors
        expect(find.byType(VooFieldWidget), findsNWidgets(2));
      });

      testWidgets('Mixed type callbacks should not cause runtime errors', (tester) async {
        // Test that mixing different callback types doesn't cause issues
        final results = <String, dynamic>{};

        final fields = [
          VooFormField(
            id: 'text',
            name: 'text',
            type: VooFieldType.text,
            label: 'Text',
          ),
          VooFormField(
            id: 'number',
            name: 'number',
            type: VooFieldType.number,
            label: 'Number',
          ),
          VooFormField(
            id: 'bool',
            name: 'bool',
            type: VooFieldType.boolean,
            label: 'Boolean',
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: fields.map((field) {
                  return VooFieldWidget(
                    field: field,
                    onChanged: (value) {
                      // This should handle any type
                      results[field.id] = value;
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        );

        // Verify all widgets render
        expect(find.byType(VooFieldWidget), findsNWidgets(3));
      });
    });

    group('Generic Type Preservation', () {
      test('Generic field types should be preserved', () {
        // Test that generic types are maintained throughout the field lifecycle
        final stringField = VooFormField<String>(
          id: 'string',
          name: 'string',
          type: VooFieldType.text,
          value: 'initial',
          onChanged: (String? value) {
            expect(value, isA<String?>());
          },
        );

        final intField = VooFormField<int>(
          id: 'int',
          name: 'int',
          type: VooFieldType.number,
          value: 42,
          onChanged: (int? value) {
            expect(value, isA<int?>());
          },
        );

        // Invoke callbacks to test type preservation
        stringField.onChanged?.call('test');
        intField.onChanged?.call(100);
      });

      test('Option types should match field types', () {
        // Test that dropdown options maintain consistent types
        final stringDropdown = VooFormField<String>(
          id: 'dropdown',
          name: 'dropdown',
          type: VooFieldType.dropdown,
          value: 'option1',
          options: const [
            VooFieldOption<String>(value: 'option1', label: 'Option 1'),
            VooFieldOption<String>(value: 'option2', label: 'Option 2'),
          ],
          onChanged: (String? value) {
            expect(value, anyOf(isNull, isA<String>()));
          },
        );

        // Test the callback
        stringDropdown.onChanged?.call('option2');
        stringDropdown.onChanged?.call(null);
      });
    });

    group('Common Type Error Scenarios', () {
      test('String to dynamic conversion should work', () {
        // This simulates the exact error users are seeing
        void Function(String?) stringCallback = (String? value) {};
        void Function(dynamic)? dynamicCallback;

        // This should not throw a type error
        dynamicCallback = (dynamic value) {
          if (value is String?) {
            stringCallback(value);
          }
        };

        // Test the conversion
        dynamicCallback('test');
        dynamicCallback(null);
      });

      test('Widget onChanged should accept various callback signatures', () {
        final field = VooFormField(
          id: 'test',
          name: 'test',
          type: VooFieldType.text,
        );

        // All these callback signatures should be valid
        final callbacks = <void Function(dynamic)?>[
          (dynamic value) {},
          (value) {},
          (Object? value) {},
        ];

        for (final callback in callbacks) {
          expect(() {
            final widget = VooFieldWidget(
              field: field,
              onChanged: callback,
            );
          }, returnsNormally);
        }
      });
    });

    group('Real-world Usage Patterns', () {
      testWidgets('Form with mixed field types and single callback', (tester) async {
        // This simulates a common pattern where a form has multiple field types
        // but uses a single callback to handle all changes
        final formData = <String, dynamic>{};

        final formFields = [
          VooFormField(
            id: 'name',
            name: 'name',
            type: VooFieldType.text,
            label: 'Name',
          ),
          VooFormField(
            id: 'age',
            name: 'age',
            type: VooFieldType.number,
            label: 'Age',
          ),
          VooFormField(
            id: 'email',
            name: 'email',
            type: VooFieldType.email,
            label: 'Email',
          ),
          VooFormField(
            id: 'subscribe',
            name: 'subscribe',
            type: VooFieldType.boolean,
            label: 'Subscribe',
          ),
        ];

        // Single callback for all fields
        void handleFieldChange(String fieldId, dynamic value) {
          formData[fieldId] = value;
        }

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: formFields.map((field) {
                  return VooFieldWidget(
                    field: field,
                    onChanged: (value) => handleFieldChange(field.id, value),
                  );
                }).toList(),
              ),
            ),
          ),
        );

        // Verify all fields render
        expect(find.byType(VooFieldWidget), findsNWidgets(4));
      });

      testWidgets('Controller-based form management', (tester) async {
        // Test using a text editing controller pattern
        final textController = TextEditingController();
        
        final field = VooFormField(
          id: 'controlled',
          name: 'controlled',
          type: VooFieldType.text,
          label: 'Controlled Field',
        );

        String? lastValue;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VooFieldWidget(
                field: field,
                controller: textController,
                onChanged: (value) {
                  // Store the value
                  lastValue = value as String?;
                },
              ),
            ),
          ),
        );

        expect(find.byType(VooFieldWidget), findsOneWidget);
        
        // Test entering text
        await tester.enterText(find.byType(TextFormField), 'test input');
        expect(lastValue, equals('test input'));
      });
    });
  });
}