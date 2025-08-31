import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('Type Error Fix Tests', () {
    testWidgets('Should handle (String?) => void callbacks without type errors', (tester) async {
      String? capturedValue;
      
      final field = VooField.text(
        name: 'test',
        label: 'Test Field',
        onChanged: (String? value) {
          capturedValue = value;
        },
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFieldWidget(
              field: field,
              onChanged: (value) {
                // This should not cause a type error
                // print('Value changed: $value');
              },
            ),
          ),
        ),
      );
      
      // Find the text field and enter text
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);
      
      await tester.enterText(textField, 'test value');
      await tester.pump();
      
      expect(capturedValue, 'test value');
    });
    
    testWidgets('Should handle dropdown with custom types correctly', (tester) async {
      final field = VooField.dropdown<TestOption>(
        name: 'test_dropdown',
        label: 'Test Dropdown',
        options: [
          TestOption('opt1', 'Option 1'),
          TestOption('opt2', 'Option 2'),
        ],
        converter: (option) => VooDropdownChild(
          label: option.label,
          value: option,
        ),
        onChanged: (_) {
          // Callback required but value not used in this test
        },
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFieldWidget(
              field: field,
              onChanged: (value) {
                // This should not cause a type error
                // print('Dropdown value changed: $value');
              },
            ),
          ),
        ),
      );
      
      // Dropdown should render without errors
      expect(find.byType(VooDropdownFieldWidget), findsOneWidget);
    });
    
    testWidgets('Should handle async dropdown callbacks correctly', (tester) async {
      final field = VooField.dropdownAsync<TestOption>(
        name: 'async_dropdown',
        label: 'Async Dropdown',
        asyncOptionsLoader: (query) async {
          await Future<void>.delayed(const Duration(milliseconds: 100));
          return [
            TestOption('async1', 'Async Option 1'),
            TestOption('async2', 'Async Option 2'),
          ];
        },
        converter: (option) => VooDropdownChild(
          label: option.label,
          value: option,
        ),
        onChanged: (_) {
          // Callback required but value not used in this test
        },
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFieldWidget(
              field: field,
              onChanged: (value) {
                // This should not cause a type error
                // print('Async dropdown value changed: $value');
              },
            ),
          ),
        ),
      );
      
      // Wait for async operations to complete
      await tester.pumpAndSettle();
      
      // Async dropdown should render without errors
      expect(find.byType(VooDropdownFieldWidget), findsOneWidget);
    });
    
    testWidgets('Should handle all field types with typed callbacks', (tester) async {
      final fields = [
        VooField.text(
          name: 'text',
          onChanged: (String? value) {}, // Text: $value
        ),
        VooField.number(
          name: 'number',
          onChanged: (num? value) {}, // Number: $value
        ),
        VooField.boolean(
          name: 'boolean',
          onChanged: (bool? value) {}, // Boolean: $value
        ),
        VooField.date(
          name: 'date',
          onChanged: (DateTime? value) {}, // Date: $value
        ),
        VooField.time(
          name: 'time',
          onChanged: (TimeOfDay? value) {}, // Time: $value
        ),
        VooField.slider(
          name: 'slider',
          onChanged: (double? value) {}, // Slider: $value
        ),
      ];
      
      for (final field in fields) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VooFieldWidget(
                field: field,
                onChanged: (dynamic value) {
                  // This should not cause any type errors
                  // print('Field ${field.name} changed: $value');
                },
              ),
            ),
          ),
        );
        
        // Wait for any async operations to complete
        await tester.pumpAndSettle();
        
        // Each field should render without errors
        expect(find.byType(VooFieldWidget), findsOneWidget);
      }
    });
  });
}

class TestOption {
  final String id;
  final String label;
  
  TestOption(this.id, this.label);
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestOption &&
          runtimeType == other.runtimeType &&
          id == other.id;
  
  @override
  int get hashCode => id.hashCode;
}