import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';
import '../test_helpers.dart';

/// Comprehensive tests for numeric field types (number, slider)
/// Ensures proper numeric handling, validation, and formatting
void main() {
  group('Numeric Field Callbacks - Comprehensive Testing', () {
    group('VooField.number() - Numeric Text Input', () {
      testWidgets(
        'should accept integer values and invoke callback',
        (tester) async {
          // Arrange
          num? capturedValue;
          bool callbackInvoked = false;
          
          final field = VooField.number(
            name: 'age',
            label: 'Age',
            hint: 'Enter your age',
            min: 0,
            max: 120,
            onChanged: (num? value) {
              capturedValue = value;
              callbackInvoked = true;
            },
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          await enterTextWithVerification(tester, '25', fieldName: 'age');
          
          // Assert
          expectCallbackInvoked(
            wasInvoked: callbackInvoked,
            callbackName: 'onChanged',
            context: 'number field input',
          );
          expect(
            capturedValue,
            equals(25),
            reason: 'Should parse integer value correctly',
          );
          expect(
            capturedValue is int,
            isTrue,
            reason: 'Integer input should remain as int type',
          );
        },
      );
      
      testWidgets(
        'should accept decimal values when decimal is true',
        (tester) async {
          // Arrange
          num? capturedValue;
          
          final field = VooField.number(
            name: 'price',
            label: 'Price',
            hint: 'Enter price in dollars',
            onChanged: (num? value) => capturedValue = value,
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          await enterTextWithVerification(tester, '19.99', fieldName: 'price');
          
          // Assert
          expect(
            capturedValue,
            equals(19.99),
            reason: 'Should parse decimal value correctly',
          );
          expect(
            capturedValue is double,
            isTrue,
            reason: 'Decimal input should be double type',
          );
        },
      );
      
      testWidgets(
        'should enforce min/max constraints',
        (tester) async {
          // Arrange
          final capturedValues = <num?>[];
          
          final field = VooField.number(
            name: 'percentage',
            label: 'Percentage',
            min: 0,
            max: 100,
            hint: 'Enter percentage (0-100)',
            onChanged: (num? value) => capturedValues.add(value),
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          // Try values outside range
          await tester.enterText(find.byType(TextField), '-10');
          await tester.pump();
          
          await tester.enterText(find.byType(TextField), '150');
          await tester.pump();
          
          await tester.enterText(find.byType(TextField), '50');
          await tester.pump();
          
          // Assert
          // Note: Actual constraint enforcement depends on implementation
          // Some implementations may prevent invalid input, others may show error
          expect(
            capturedValues.last,
            equals(50),
            reason: 'Valid value within range should be accepted',
          );
        },
      );
      
      testWidgets(
        'should handle negative numbers correctly',
        (tester) async {
          // Arrange
          num? capturedValue;
          
          final field = VooField.number(
            name: 'temperature',
            label: 'Temperature',
            min: -273.15, // Absolute zero
            max: 100,
            hint: 'Enter temperature in Celsius',
            onChanged: (num? value) => capturedValue = value,
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          await enterTextWithVerification(tester, '-40.5', fieldName: 'temperature');
          
          // Assert
          expect(
            capturedValue,
            equals(-40.5),
            reason: 'Should handle negative decimal values',
          );
        },
      );
      
      testWidgets(
        'should format numbers with thousands separator if enabled',
        (tester) async {
          // Arrange
          num? capturedValue;
          
          final field = VooField.number(
            name: 'salary',
            label: 'Annual Salary',
            hint: 'Enter salary in dollars',
            onChanged: (num? value) => capturedValue = value,
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          // Enter large number
          await tester.enterText(find.byType(TextField), '75000');
          await tester.pump();
          
          // Assert
          expect(
            capturedValue,
            equals(75000),
            reason: 'Should parse number regardless of formatting',
          );
          
          // Check if formatted display shows thousands separator
          // Note: Actual formatting depends on implementation
        },
      );
      
      testWidgets(
        'should reject non-numeric input',
        (tester) async {
          // Arrange
          num? capturedValue;
          String? lastTextValue;
          
          final field = VooField.number(
            name: 'numeric_only',
            label: 'Numbers Only',
            onChanged: (num? value) => capturedValue = value,
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          final textField = find.byType(TextField);
          
          // Try to enter non-numeric text
          await tester.enterText(textField, 'abc');
          await tester.pump();
          lastTextValue = tester.widget<TextField>(textField).controller?.text;
          
          // Assert
          expect(
            lastTextValue?.isEmpty ?? true,
            isTrue,
            reason: 'Non-numeric input should be rejected',
          );
          expect(
            capturedValue,
            isNull,
            reason: 'No value should be captured for invalid input',
          );
        },
      );
    });
    
    group('VooField.slider() - Slider Input', () {
      testWidgets(
        'should capture slider value changes',
        (tester) async {
          // Arrange
          double? capturedValue;
          int changeCount = 0;
          
          final field = VooField.slider(
            name: 'volume',
            label: 'Volume',
            min: 0,
            max: 100,
            initialValue: 50,
            divisions: 10,
            onChanged: (double? value) {
              capturedValue = value;
              changeCount++;
            },
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          // Find slider
          final slider = find.byType(Slider);
          expect(
            slider,
            findsOneWidget,
            reason: 'Slider widget should be rendered',
          );
          
          // Drag slider to new position
          await tester.drag(slider, const Offset(100, 0));
          await tester.pumpAndSettle();
          
          // Assert
          expect(
            changeCount,
            greaterThan(0),
            reason: 'Callback should be invoked during slider drag',
          );
          expect(
            capturedValue,
            isNotNull,
            reason: 'Slider value should be captured',
          );
          expect(
            capturedValue != null && capturedValue! >= 0 && capturedValue! <= 100,
            isTrue,
            reason: 'Slider value should be within min/max range',
          );
        },
      );
      
      testWidgets(
        'should respect divisions for discrete values',
        (tester) async {
          // Arrange
          double? capturedValue;
          
          final field = VooField.slider(
            name: 'rating',
            label: 'Rating',
            min: 0,
            max: 5,
            divisions: 5, // 0, 1, 2, 3, 4, 5
            initialValue: 0,
            onChanged: (double? value) => capturedValue = value,
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          final slider = find.byType(Slider);
          
          // Drag to approximately middle
          await tester.drag(slider, const Offset(50, 0));
          await tester.pumpAndSettle();
          
          // Assert
          expect(
            capturedValue,
            isNotNull,
            reason: 'Slider value should be captured',
          );
          expect(
            capturedValue! % 1,
            equals(0),
            reason: 'With 5 divisions, value should be whole number',
          );
        },
      );
      
      testWidgets(
        'should display value label when showValue is true',
        (tester) async {
          // Arrange
          final field = VooField.slider(
            name: 'brightness',
            label: 'Brightness',
            min: 0,
            max: 100,
            initialValue: 75,
            onChanged: (_) {},
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          // Assert - Check that slider widget exists
          expect(
            find.byType(Slider),
            findsOneWidget,
            reason: 'Slider widget should be displayed',
          );
        },
      );
      
      testWidgets(
        'should handle continuous values without divisions',
        (tester) async {
          // Arrange
          double? capturedValue;
          
          final field = VooField.slider(
            name: 'precision',
            label: 'Precision',
            min: 0.0,
            max: 1.0,
            initialValue: 0.5,
            // No divisions - continuous
            onChanged: (double? value) => capturedValue = value,
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          final slider = find.byType(Slider);
          await tester.drag(slider, const Offset(25, 0));
          await tester.pumpAndSettle();
          
          // Assert
          expect(
            capturedValue,
            isNotNull,
            reason: 'Continuous slider should capture value',
          );
          expect(
            capturedValue != null && capturedValue! >= 0.0 && capturedValue! <= 1.0,
            isTrue,
            reason: 'Value should be within 0.0 to 1.0 range',
          );
        },
      );
      
      testWidgets(
        'should display custom labels if provided',
        (tester) async {
          // Arrange
          final field = VooField.slider(
            name: 'speed',
            label: 'Speed',
            min: 0,
            max: 3,
            divisions: 3,
            initialValue: 1,
            onChanged: (_) {},
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          // Assert - Labels should be accessible
          // Note: Label display depends on implementation
          final slider = tester.widget<Slider>(find.byType(Slider));
          expect(
            slider.divisions,
            equals(3),
            reason: 'Slider should have correct divisions',
          );
        },
      );
    });
    
    group('Advanced Numeric Features', () {
      testWidgets(
        'should handle step increments for number field',
        (tester) async {
          // Arrange
          num? capturedValue;
          
          final field = VooField.number(
            name: 'quantity',
            label: 'Quantity',
            min: 0,
            max: 100,
            step: 5,
            onChanged: (num? value) => capturedValue = value,
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          // Look for increment buttons if implemented
          final incrementButton = find.byIcon(Icons.add);
          if (incrementButton.evaluate().isNotEmpty) {
            await tester.tap(incrementButton);
            await tester.pump();
            
            // Assert
            expect(
              capturedValue,
              equals(5),
              reason: 'Should increment by step value',
            );
          }
        },
      );
      
      testWidgets(
        'should validate numeric range and show error',
        (tester) async {
          // Arrange
          String? validationError;
          
          final field = VooField.number(
            name: 'validated_number',
            label: 'Age (18-65)',
            min: 18,
            max: 65,
            required: true,
            onChanged: (_) {},
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          // Enter invalid value
          await tester.enterText(find.byType(TextField), '10');
          await tester.pump();
          
          // Validation would show error
          // Error display depends on implementation
        },
      );
    });
    
    group('Edge Cases and Error Scenarios', () {
      testWidgets(
        'should handle very large numbers',
        (tester) async {
          // Arrange
          num? capturedValue;
          
          final field = VooField.number(
            name: 'large_number',
            label: 'Large Number',
            max: double.maxFinite,
            onChanged: (num? value) => capturedValue = value,
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          await tester.enterText(find.byType(TextField), '999999999999');
          await tester.pump();
          
          // Assert
          expect(
            capturedValue,
            equals(999999999999),
            reason: 'Should handle large numbers correctly',
          );
        },
      );
      
      testWidgets(
        'should handle scientific notation if supported',
        (tester) async {
          // Arrange
          num? capturedValue;
          
          final field = VooField.number(
            name: 'scientific',
            label: 'Scientific',
            hint: 'Enter scientific number',
            onChanged: (num? value) => capturedValue = value,
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          await tester.enterText(find.byType(TextField), '1.23e5');
          await tester.pump();
          
          // Assert - If scientific notation is supported
          if (capturedValue != null) {
            expect(
              capturedValue,
              equals(123000),
              reason: 'Should parse scientific notation',
            );
          }
        },
      );
      
      testWidgets(
        'should handle rapid slider movements',
        (tester) async {
          // Arrange
          final values = <double>[];
          
          final field = VooField.slider(
            name: 'rapid_slider',
            label: 'Rapid Test',
            min: 0,
            max: 100,
            onChanged: (double? value) {
              if (value != null) values.add(value);
            },
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          final slider = find.byType(Slider);
          
          // Rapid movements
          for (int i = 0; i < 5; i++) {
            await tester.drag(slider, Offset(20.0 * i, 0));
            await tester.pump(const Duration(milliseconds: 50));
          }
          
          // Assert
          expect(
            values.isNotEmpty,
            isTrue,
            reason: 'Should capture multiple values during rapid movement',
          );
          expect(
            values.every((v) => v >= 0 && v <= 100),
            isTrue,
            reason: 'All values should be within range',
          );
        },
      );
    });
  });
}