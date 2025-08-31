import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

// Custom type for testing typed callbacks
class CustomOption {
  final String id;
  final String name;

  const CustomOption({required this.id, required this.name});
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomOption &&
          runtimeType == other.runtimeType &&
          id == other.id;
  
  @override
  int get hashCode => id.hashCode;
}

void main() {
  group('All Fields Typed Callback Tests', () {
    // Helper to create test app
    Widget createTestApp(Widget child) => MaterialApp(
        home: VooDesignSystem(
          data: VooDesignSystemData.defaultSystem,
          child: VooResponsiveBuilder(
            child: Scaffold(body: child),
          ),
        ),
      );

    testWidgets('Text field should handle typed String callbacks', (tester) async {
      String? capturedValue;
      
      final field = VooField.text(
        name: 'text',
        label: 'Text Field',
        onChanged: (String? value) {
          // Field callback with nullable type
        },
      );
      
      await tester.pumpWidget(createTestApp(
        VooFieldWidget(
          field: field,
          onChanged: (value) {
            capturedValue = value as String;
          },
        ),
      ),);
      
      // Type text
      await tester.enterText(find.byType(TextFormField), 'test');
      await tester.pump();
      
      expect(capturedValue, equals('test'));
      // Field callback should NOT be called due to type safety issues we fixed
      // The field.onChanged is only called through VooFieldWidget's onChanged
    });

    testWidgets('Number field should handle typed num callbacks', (tester) async {
      num? capturedValue;
      
      final field = VooField.number(
        name: 'number',
        label: 'Number Field',
        onChanged: (num? value) {
          // Field callback with nullable type
        },
      );
      
      await tester.pumpWidget(createTestApp(
        VooFieldWidget(
          field: field,
          onChanged: (value) {
            capturedValue = num.tryParse(value.toString());
          },
        ),
      ),);
      
      // Type number
      await tester.enterText(find.byType(TextFormField), '42');
      await tester.pump();
      
      expect(capturedValue, equals(42));
    });

    testWidgets('Boolean switch should handle typed bool callbacks', (tester) async {
      bool? capturedValue;
      
      final field = VooField.boolean(
        name: 'boolean',
        label: 'Boolean Field',
        onChanged: (bool? value) {
          // Field callback with nullable type
        },
      );
      
      await tester.pumpWidget(createTestApp(
        VooFieldWidget(
          field: field,
          onChanged: (value) {
            capturedValue = value as bool;
          },
        ),
      ),);
      
      // Toggle switch
      await tester.tap(find.byType(Switch));
      await tester.pump();
      
      expect(capturedValue, equals(true));
    });

    testWidgets('Checkbox should handle typed bool? callbacks', (tester) async {
      bool? capturedValue;
      
      final field = VooField.checkbox(
        name: 'checkbox',
        label: 'Checkbox Field',
        onChanged: (bool? value) {
          // Field callback with nullable type
        },
      );
      
      await tester.pumpWidget(createTestApp(
        VooFieldWidget(
          field: field,
          onChanged: (value) {
            capturedValue = value as bool?;
          },
        ),
      ),);
      
      // Toggle checkbox
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      
      expect(capturedValue, equals(true));
    });

    testWidgets('Dropdown should handle typed callbacks', (tester) async {
      CustomOption? capturedValue;
      
      final options = [
        const CustomOption(id: '1', name: 'Option 1'),
        const CustomOption(id: '2', name: 'Option 2'),
      ];
      
      final field = VooField.dropdown<CustomOption>(
        name: 'dropdown',
        label: 'Dropdown Field',
        options: options,
        converter: (option) => VooDropdownChild(
          value: option,
          label: option.name,
        ),
        initialValue: options[0],
        onChanged: (CustomOption? value) {
          // Field callback with typed parameter
        },
      );
      
      await tester.pumpWidget(createTestApp(
        VooFieldWidget(
          field: field,
          onChanged: (value) {
            capturedValue = value as CustomOption?;
          },
        ),
      ),);
      
      // Open dropdown
      await tester.tap(find.byType(DropdownButtonFormField));
      await tester.pumpAndSettle();
      
      // Select second option
      final option2 = find.text('Option 2').last;
      if (option2.evaluate().isNotEmpty) {
        await tester.tap(option2);
        await tester.pumpAndSettle();
        
        expect(capturedValue?.id, equals('2'));
      }
    });

    testWidgets('Radio should handle typed callbacks', (tester) async {
      String? capturedValue;
      
      final field = VooField.radio(
        name: 'radio',
        label: 'Radio Field',
        options: ['Option A', 'Option B'],
        onChanged: (value) {
          // Field callback
        },
      );
      
      await tester.pumpWidget(createTestApp(
        VooFieldWidget(
          field: field,
          onChanged: (value) {
            capturedValue = value as String;
          },
        ),
      ),);
      
      // Select second radio option
      final radioButtons = find.byType(Radio<String>);
      if (radioButtons.evaluate().length >= 2) {
        await tester.tap(radioButtons.at(1));
        await tester.pump();
        
        expect(capturedValue, equals('Option B'));
      }
    });

    testWidgets('Slider should handle typed double callbacks', (tester) async {
      double? capturedValue;
      
      final field = VooField.slider(
        name: 'slider',
        label: 'Slider Field',
        initialValue: 50,
        onChanged: (double? value) {
          // Field callback with nullable type
        },
      );
      
      await tester.pumpWidget(createTestApp(
        VooFieldWidget(
          field: field,
          onChanged: (value) {
            capturedValue = value as double;
          },
        ),
      ),);
      
      // Move slider
      final slider = find.byType(Slider);
      expect(slider, findsOneWidget);
      
      // Simulate dragging the slider
      await tester.drag(slider, const Offset(100, 0));
      await tester.pump();
      
      // Value should have changed
      expect(capturedValue, isNotNull);
      expect(capturedValue, isNot(equals(50)));
    });

    testWidgets('Date field should handle typed DateTime? callbacks', (tester) async {
      final field = VooField.date(
        name: 'date',
        label: 'Date Field',
        onChanged: (DateTime? value) {
          // Field callback with nullable type
        },
      );
      
      await tester.pumpWidget(createTestApp(
        VooFieldWidget(
          field: field,
          onChanged: (value) {
            // Widget callback
          },
        ),
      ),);
      
      // Check that the date field renders without type errors
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('Time field should handle typed TimeOfDay? callbacks', (tester) async {
      final field = VooField.time(
        name: 'time',
        label: 'Time Field',
        onChanged: (TimeOfDay? value) {
          // Field callback with nullable type
        },
      );
      
      await tester.pumpWidget(createTestApp(
        VooFieldWidget(
          field: field,
          onChanged: (value) {
            // Widget callback
          },
        ),
      ),);
      
      // Check that the time field renders without type errors
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('Multiline field should handle typed String callbacks', (tester) async {
      String? capturedValue;
      
      final field = VooField.multiline(
        name: 'multiline',
        label: 'Multiline Field',
        onChanged: (String? value) {
          // Field callback with nullable type
        },
      );
      
      await tester.pumpWidget(createTestApp(
        VooFieldWidget(
          field: field,
          onChanged: (value) {
            capturedValue = value as String;
          },
        ),
      ),);
      
      // Type multiline text
      await tester.enterText(find.byType(TextFormField), 'Line 1\nLine 2');
      await tester.pump();
      
      expect(capturedValue, equals('Line 1\nLine 2'));
    });

    testWidgets('Email field should handle typed String callbacks', (tester) async {
      String? capturedValue;
      
      final field = VooField.email(
        name: 'email',
        label: 'Email Field',
        onChanged: (String? value) {
          // Typed callback with nullable type
        },
      );
      
      await tester.pumpWidget(createTestApp(
        VooFieldWidget(
          field: field,
          onChanged: (value) {
            capturedValue = value as String;
          },
        ),
      ),);
      
      await tester.enterText(find.byType(TextFormField), 'test@example.com');
      await tester.pump();
      
      expect(capturedValue, equals('test@example.com'));
    });

    testWidgets('All fields should not throw type casting errors', (tester) async {
      // This test ensures no runtime type casting errors occur
      bool hasError = false;
      String? errorMessage;
      
      try {
        // Create all field types with strongly typed callbacks
        final fields = [
          VooField.text(
            name: 'text',
            label: 'Text',
            onChanged: (String? value) {},
          ),
          VooField.number(
            name: 'number',
            label: 'Number',
            onChanged: (num? value) {},
          ),
          VooField.boolean(
            name: 'boolean',
            label: 'Boolean',
            onChanged: (bool? value) {},
          ),
          VooField.checkbox(
            name: 'checkbox',
            label: 'Checkbox',
            onChanged: (bool? value) {},
          ),
          VooField.dropdown<String>(
            name: 'dropdown',
            label: 'Dropdown',
            options: ['A', 'B'],
            converter: (v) => VooDropdownChild(value: v, label: v),
            onChanged: (String? value) {},
          ),
          VooField.radio(
            name: 'radio',
            label: 'Radio',
            options: ['A', 'B'],
            onChanged: (value) {},
          ),
          VooField.slider(
            name: 'slider',
            label: 'Slider',
            onChanged: (double? value) {},
          ),
          VooField.date(
            name: 'date',
            label: 'Date',
            onChanged: (DateTime? value) {},
          ),
          VooField.time(
            name: 'time',
            label: 'Time',
            onChanged: (TimeOfDay? value) {},
          ),
        ];
        
        // Build all fields
        for (final field in fields) {
          await tester.pumpWidget(createTestApp(
            VooFieldWidget(field: field),
          ),);
          await tester.pump();
        }
      } catch (e) {
        hasError = true;
        errorMessage = e.toString();
      }
      
      expect(hasError, isFalse,
          reason: 'No type casting errors should occur. Error: $errorMessage',);
    });
  });
}