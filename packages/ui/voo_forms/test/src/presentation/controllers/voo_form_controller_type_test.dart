import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/src/domain/entities/field_type.dart';
import 'package:voo_forms/src/domain/entities/form.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/domain/entities/validation_rules/custom_validation.dart';
import 'package:voo_forms/src/presentation/controllers/voo_form_controller.dart';

void main() {
  group('VooFormController Type Conversion Tests', () {
    late VooFormController controller;
    late VooForm form;

    setUp(() {
      form = const VooForm(
        id: 'test-form',
        title: 'Test Form',
        fields: [
          VooFormField<num>(
            id: 'number-field',
            name: 'number_field',
            label: 'Number Field',
            type: VooFieldType.number,
          ),
          VooFormField<String>(
            id: 'text-field',
            name: 'text_field',
            label: 'Text Field',
            type: VooFieldType.text,
          ),
        ],
      );
      controller = VooFormController(form: form);
    });

    tearDown(() {
      controller.dispose();
    });

    test('should convert string to number for number fields', () {
      // Act
      controller.setValue('number-field', '234234');

      // Assert
      final value = controller.getValue('number-field');
      expect(value, isA<num>());
      expect(value, equals(234234));
    });

    test('should handle decimal numbers correctly', () {
      // Act
      controller.setValue('number-field', '123.456');

      // Assert
      final value = controller.getValue('number-field');
      expect(value, isA<num>());
      expect(value, equals(123.456));
    });

    test('should handle negative numbers correctly', () {
      // Act
      controller.setValue('number-field', '-789');

      // Assert
      final value = controller.getValue('number-field');
      expect(value, isA<num>());
      expect(value, equals(-789));
    });

    test('should store null for empty string in number field', () {
      // Act
      controller.setValue('number-field', '');

      // Assert
      final value = controller.getValue('number-field');
      expect(value, isNull);
    });

    test('should store null if string cannot be parsed as number', () {
      // Act
      controller.setValue('number-field', 'not-a-number');

      // Assert
      final value = controller.getValue('number-field');
      expect(value, isNull);
    });

    test('should not convert strings for text fields', () {
      // Act
      controller.setValue('text-field', '12345');

      // Assert
      final value = controller.getValue('text-field');
      expect(value, isA<String>());
      expect(value, equals('12345'));
    });

    test('should preserve number type when setting directly', () {
      // Act
      controller.setValue('number-field', 42);

      // Assert
      final value = controller.getValue('number-field');
      expect(value, isA<num>());
      expect(value, equals(42));
    });

    test('validateAll should work with string values converted to numbers', () {
      // Arrange
      const formWithValidation = VooForm(
        id: 'validation-form',
        title: 'Validation Form',
        fields: [
          VooFormField<num>(
            id: 'age',
            name: 'age',
            label: 'Age',
            type: VooFieldType.number,
            validators: [
              CustomValidation<num>(
                validator: _validatePositiveNumber,
                errorMessage: 'Age must be positive',
              ),
            ],
          ),
        ],
      );
      final validationController = VooFormController(form: formWithValidation);

      // Act - Set a string value that should be converted to number
      validationController.setValue('age', '25');
      final isValid = validationController.validateAll();

      // Assert
      expect(isValid, isTrue);
      expect(validationController.getValue('age'), equals(25));

      // Cleanup
      validationController.dispose();
    });

    test('validateAll should handle invalid number strings', () {
      // Arrange
      const formWithValidation = VooForm(
        id: 'validation-form',
        title: 'Validation Form',
        fields: [
          VooFormField<num>(
            id: 'amount',
            name: 'amount',
            label: 'Amount',
            type: VooFieldType.number,
            validators: [
              CustomValidation<num>(
                validator: _validateIsNumber,
                errorMessage: 'Must be a valid number',
              ),
            ],
          ),
        ],
      );
      final validationController = VooFormController(form: formWithValidation);

      // Act - Set an invalid number string
      validationController.setValue('amount', 'invalid');
      final isValid = validationController.validateAll();

      // Assert
      expect(isValid, isFalse);
      expect(validationController.getValue('amount'), isNull);

      // Cleanup
      validationController.dispose();
    });

    test('_handleFieldChange should convert values correctly', () {
      // This tests the internal _handleFieldChange method indirectly
      // by simulating what happens when a text field updates
      
      // Act - Simulate text field sending string value
      controller.setValue('number-field', '999');

      // Assert
      final value = controller.getValue('number-field');
      expect(value, isA<num>());
      expect(value, equals(999));
    });

    test('should handle scientific notation', () {
      // Act
      controller.setValue('number-field', '1.23e5');

      // Assert
      final value = controller.getValue('number-field');
      expect(value, isA<num>());
      expect(value, equals(123000));
    });

    test('should handle leading/trailing spaces', () {
      // Act
      controller.setValue('number-field', '  456  ');

      // Assert
      final value = controller.getValue('number-field');
      expect(value, isA<num>());
      expect(value, equals(456));
    });

    test('copyWith should work with correct types after conversion', () {
      // Act
      controller.setValue('number-field', '234234');
      
      // This should not throw a type error
      expect(() => controller.validateAll(), returnsNormally);
    });

    test('getTypedValue should return correct type after conversion', () {
      // Act
      controller.setValue('number-field', '789');

      // Assert
      final typedValue = controller.getTypedValue<num>('number-field');
      expect(typedValue, isNotNull);
      expect(typedValue, equals(789));
    });

    test('toJson should include converted values', () {
      // Act
      controller.setValue('number-field', '100');
      controller.setValue('text-field', 'hello');
      final json = controller.toJson();

      // Assert
      expect(json['number_field'], equals(100));
      expect(json['text_field'], equals('hello'));
    });
  });
}

// Validator functions for testing
String? _validatePositiveNumber(num? value) =>
    value != null && value > 0 ? null : 'Age must be positive';

String? _validateIsNumber(num? value) =>
    value != null ? null : 'Must be a valid number';