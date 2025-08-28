import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('VooFormField', () {
    test('should create a form field with required properties', () {
      const field = VooFormField<String>(
        id: 'test_field',
        name: 'testField',
        type: VooFieldType.text,
      );

      expect(field.id, 'test_field');
      expect(field.name, 'testField');
      expect(field.type, VooFieldType.text);
      expect(field.required, false); // default value
      expect(field.enabled, true); // default value
      expect(field.visible, true); // default value
    });

    test('should validate required field correctly', () {
      const field = VooFormField<String>(
        id: 'required_field',
        name: 'requiredField',
        type: VooFieldType.text,
        required: true,
      );

      // Test with null value
      var fieldWithNull = field.copyWith(value: null);
      expect(fieldWithNull.validate(), isNotNull);

      // Test with empty string
      var fieldWithEmpty = field.copyWith(value: '');
      expect(fieldWithEmpty.validate(), isNotNull);

      // Test with valid value
      var fieldWithValue = field.copyWith(value: 'test');
      expect(fieldWithValue.validate(), isNull);
    });

    test('should apply custom validators', () {
      final field = VooFormField<String>(
        id: 'email_field',
        name: 'email',
        type: VooFieldType.email,
        validators: [
          VooValidator.email(),
        ],
      );

      // Test with invalid email
      var fieldWithInvalid = field.copyWith(value: 'invalid');
      expect(fieldWithInvalid.validate(), isNotNull);

      // Test with valid email
      var fieldWithValid = field.copyWith(value: 'test@example.com');
      expect(fieldWithValid.validate(), isNull);
    });

    test('should handle min and max length validation', () {
      final field = VooFormField<String>(
        id: 'length_field',
        name: 'lengthField',
        type: VooFieldType.text,
        validators: [
          VooValidator.minLength(3),
          VooValidator.maxLength(10),
        ],
      );

      // Test too short
      var fieldShort = field.copyWith(value: 'ab');
      expect(fieldShort.validate(), contains('at least 3'));

      // Test too long
      var fieldLong = field.copyWith(value: '12345678901');
      expect(fieldLong.validate(), contains('at most 10'));

      // Test valid length
      var fieldValid = field.copyWith(value: '12345');
      expect(fieldValid.validate(), isNull);
    });

    test('should copy field with new values', () {
      const original = VooFormField<String>(
        id: 'original',
        name: 'originalField',
        type: VooFieldType.text,
        label: 'Original Label',
      );

      final copied = original.copyWith(
        label: 'New Label',
        required: true,
      );

      expect(copied.id, 'original');
      expect(copied.label, 'New Label');
      expect(copied.required, true);
      expect(original.label, 'Original Label');
      expect(original.required, false);
    });

    test('should handle dropdown field options', () {
      const field = VooFormField<String>(
        id: 'dropdown',
        name: 'dropdown',
        type: VooFieldType.dropdown,
        options: [
          VooFieldOption(value: 'opt1', label: 'Option 1'),
          VooFieldOption(value: 'opt2', label: 'Option 2'),
        ],
      );

      expect(field.options?.length, 2);
      expect(field.options?.first.value, 'opt1');
      expect(field.options?.first.label, 'Option 1');
    });

    test('should handle number field constraints', () {
      final field = VooFormField<num>(
        id: 'number',
        name: 'number',
        type: VooFieldType.number,
        min: 0,
        max: 100,
        validators: [
          VooValidator.min(0),
          VooValidator.max(100),
        ],
      );

      // Test below minimum
      var fieldBelowMin = field.copyWith(value: -5);
      expect(fieldBelowMin.validate(), contains('at least'));

      // Test above maximum
      var fieldAboveMax = field.copyWith(value: 150);
      expect(fieldAboveMax.validate(), contains('at most'));

      // Test valid value
      var fieldValid = field.copyWith(value: 50);
      expect(fieldValid.validate(), isNull);
    });

    test('should handle date field constraints', () {
      final minDate = DateTime(2020, 1, 1);
      final maxDate = DateTime(2025, 12, 31);
      
      final field = VooFormField<DateTime>(
        id: 'date',
        name: 'date',
        type: VooFieldType.date,
        minDate: minDate,
        maxDate: maxDate,
      );

      expect(field.minDate, minDate);
      expect(field.maxDate, maxDate);
    });

    test('should handle boolean field initial value', () {
      const field = VooFormField<bool>(
        id: 'checkbox',
        name: 'checkbox',
        type: VooFieldType.checkbox,
        initialValue: true,
      );

      expect(field.initialValue, true);
    });

    test('should handle multiselect field', () {
      const field = VooFormField<List<String>>(
        id: 'multiselect',
        name: 'multiselect',
        type: VooFieldType.multiSelect,
        allowMultiple: true,
        options: [
          VooFieldOption(value: ['opt1'], label: 'Option 1'),
          VooFieldOption(value: ['opt2'], label: 'Option 2'),
          VooFieldOption(value: ['opt3'], label: 'Option 3'),
        ],
      );

      expect(field.allowMultiple, true);
      expect(field.options?.length, 3);
    });

    test('should have correct field properties', () {
      const field = VooFormField<String>(
        id: 'test',
        name: 'test',
        type: VooFieldType.text,
        label: 'Test Label',
        required: true,
        helper: 'Helper text',
      );

      expect(field.id, 'test');
      expect(field.name, 'test');
      expect(field.label, 'Test Label');
      expect(field.required, true);
      expect(field.helper, 'Helper text');
      expect(field.type, VooFieldType.text);
    });
  });
}