import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/src/domain/enums/form_error_display_mode.dart';
import 'package:voo_forms/src/domain/utils/validators.dart';
import 'package:voo_forms/src/presentation/state/voo_form_controller.dart';

void main() {
  group('VooFormController - Comprehensive Tests', () {
    late VooFormController controller;

    setUp(() {
      controller = VooFormController();
    });

    tearDown(() {
      controller.dispose();
    });

    group('Edge Cases and Boundary Conditions', () {
      test('handles null values correctly', () {
        controller.registerField('field1');
        controller.setValue('field1', null);
        expect(controller.getValue('field1'), isNull);
        expect(controller.values['field1'], isNull);
      });

      test('handles empty string values', () {
        controller.registerField('field1');
        controller.setValue('field1', '');
        expect(controller.getValue('field1'), '');
        expect(controller.values['field1'], '');
      });

      test('handles very long string values', () {
        final longString = 'a' * 10000;
        controller.registerField('field1');
        controller.setValue('field1', longString);
        expect(controller.getValue('field1'), longString);
      });

      test('handles special characters in field names', () {
        const specialName = 'field-name_with.special@chars!';
        controller.registerField(specialName);
        controller.setValue(specialName, 'value');
        expect(controller.getValue(specialName), 'value');
      });

      test('handles unicode characters in values', () {
        const unicodeValue = '你好世界 👋 مرحبا بالعالم';
        controller.registerField('field1');
        controller.setValue('field1', unicodeValue);
        expect(controller.getValue('field1'), unicodeValue);
      });

      test('handles numeric boundary values', () {
        controller.registerField('number');

        // Test max int
        controller.setValue('number', 9223372036854775807);
        expect(controller.getValue('number'), 9223372036854775807);

        // Test min int
        controller.setValue('number', -9223372036854775808);
        expect(controller.getValue('number'), -9223372036854775808);

        // Test double precision
        controller.setValue('number', 0.00000000001);
        expect(controller.getValue('number'), 0.00000000001);
      });

      test('handles accessing non-existent fields', () {
        expect(controller.getValue('nonexistent'), isNull);
        expect(controller.getError('nonexistent'), isNull);
        expect(controller.hasError('nonexistent'), false);
        expect(controller.isFieldEnabled('nonexistent'), true);
        expect(controller.isFieldVisible('nonexistent'), true);
      });
    });

    group('Validation - Error Conditions', () {
      test('validates with throwing validators', () {
        controller.registerField('field1', validators: [(dynamic value) => throw Exception('Validator error')]);

        controller.setValue('field1', 'test');
        final isValid = controller.validate();
        expect(isValid, false);
        expect(controller.hasError('field1'), true);
      });

      test('validates with null-returning validators', () {
        controller.registerField(
          'field1',
          validators: [
            (dynamic value) => null, // Validator returns null (valid)
          ],
        );

        controller.setValue('field1', 'test');
        final isValid = controller.validate();
        expect(isValid, true);
        expect(controller.hasError('field1'), false);
      });

      test('validates with empty string error messages', () {
        controller.registerField(
          'field1',
          validators: [
            (dynamic value) => '', // Empty string should be treated as valid
          ],
        );

        controller.setValue('field1', 'test');
        final isValid = controller.validate();
        expect(isValid, true);
        expect(controller.hasError('field1'), false);
      });

      test('validates with whitespace-only error messages', () {
        controller.registerField(
          'field1',
          validators: [
            (dynamic value) => '   ', // Whitespace-only should be invalid
          ],
        );

        controller.setValue('field1', 'test');
        final isValid = controller.validate();
        expect(isValid, false);
        expect(controller.getError('field1'), '   ');
      });

      test('handles validation with mixed validator types', () {
        controller.registerField(
          'field1',
          validators: [VooValidator.required<String>(), (dynamic value) => (value as String).length < 3 ? 'Too short' : null, VooValidator.maxLength(10)],
        );

        // Test empty value
        controller.setValue('field1', '');
        expect(controller.validate(), false);

        // Test too short
        controller.setValue('field1', 'ab');
        expect(controller.validate(), false);

        // Test too long
        controller.setValue('field1', 'this is way too long');
        expect(controller.validate(), false);

        // Test valid
        controller.setValue('field1', 'perfect');
        expect(controller.validate(), true);
      });

      test('stops at first validation error', () {
        var secondValidatorCalled = false;
        controller.registerField(
          'field1',
          validators: [
            (dynamic value) => 'First error',
            (dynamic value) {
              secondValidatorCalled = true;
              return 'Second error';
            },
          ],
        );

        controller.setValue('field1', 'test');
        controller.validate();

        expect(controller.getError('field1'), 'First error');
        expect(secondValidatorCalled, false);
      });
    });

    group('Validation - Display Modes', () {
      test('respects onTyping display mode', () {
        controller = VooFormController();

        controller.registerField('field1', validators: [VooValidator.required()]);

        // Error should show when validation is triggered
        controller.setValue('field1', '', validate: true);
        expect(controller.hasError('field1'), true);

        // Setting valid value with validate=true should clear error
        controller.setValue('field1', 'valid', validate: true);
        expect(controller.hasError('field1'), false);

        // Setting empty again should show error with onTyping mode
        controller.setValue('field1', '', validate: true);
        expect(controller.hasError('field1'), true);
      });

      test('respects onSubmit display mode', () async {
        controller = VooFormController(errorDisplayMode: VooFormErrorDisplayMode.onSubmit);

        controller.registerField('field1', validators: [VooValidator.required()]);

        // Error should not show before submit
        controller.setValue('field1', '');
        controller.validate();
        expect(controller.hasError('field1'), false);

        // Error should show after submit attempt
        final result = await controller.submit(onSubmit: (_) async {});

        expect(result, false); // Submit should fail
        expect(controller.hasError('field1'), true); // Error should now be visible
      });

      test('respects none display mode', () {
        controller = VooFormController(errorDisplayMode: VooFormErrorDisplayMode.none);

        controller.registerField('field1', validators: [VooValidator.required()]);

        controller.setValue('field1', '');
        final isValid = controller.validate();

        // Validation should return false but errors are shown with none mode
        expect(isValid, false);

        // With none mode, validateAll shows errors
        expect(controller.hasError('field1'), true);
      });
    });

    group('State Management - Race Conditions', () {
      test('handles rapid value changes', () {
        controller.registerField('field1');

        for (int i = 0; i < 1000; i++) {
          controller.setValue('field1', 'value$i');
        }

        expect(controller.getValue('field1'), 'value999');
        expect(controller.isDirty, true);
      });

      test('handles concurrent validation calls', () async {
        controller.registerField('field1', validators: [(dynamic value) => value == null || value.toString().isEmpty ? 'Required' : null]);

        // Simulate concurrent validation
        final futures = <Future<bool>>[];
        for (int i = 0; i < 10; i++) {
          futures.add(Future<bool>(() => controller.validate()));
        }

        final results = await Future.wait(futures);
        expect(results.every((r) => r == false), isTrue);
      });

      test('prevents multiple simultaneous submits', () async {
        controller.registerField('field1', initialValue: 'test');

        var submitCount = 0;
        Future<bool> submit() => controller.submit(
          onSubmit: (_) async {
            submitCount++;
            await Future<void>.delayed(const Duration(milliseconds: 100));
          },
        );

        // Try to submit multiple times
        final futures = <Future<bool>>[];
        for (int i = 0; i < 5; i++) {
          futures.add(submit());
        }

        await Future.wait(futures);

        // Only first submit should execute
        expect(submitCount, 1);
        expect(controller.isSubmitting, false);
      });
    });

    group('Memory Management', () {
      test('controller lifecycle management', () {
        // Register fields and controllers
        controller.registerField('field1', initialValue: 'test1');
        controller.registerField('field2', initialValue: 'test2');

        final textController1 = controller.registerTextController('field1');
        final textController2 = controller.registerTextController('field2');
        final focusNode1 = controller.getFocusNode('field1');
        final focusNode2 = controller.getFocusNode('field2');

        // Verify everything works before dispose
        expect(textController1.text, 'test1');
        expect(textController2.text, 'test2');
        expect(focusNode1, isNotNull);
        expect(focusNode2, isNotNull);
        expect(controller.values.length, 2);

        // Dispose the controller
        controller.dispose();

        // Create new controller and verify clean state
        controller = VooFormController();
        expect(controller.values, isEmpty);
        expect(controller.errors, isEmpty);
      });

      test('verifies controller has clean state after dispose and recreation', () {
        // Setup first controller with data
        controller.registerField('field1', initialValue: 'test1');
        controller.registerField('field2', initialValue: 'test2');
        controller.setValue('field1', 'modified');
        controller.setValidators('field1', [VooValidator.required()]);

        // Verify state before dispose
        expect(controller.getValue('field1'), 'modified');
        expect(controller.getValue('field2'), 'test2');

        // Dispose
        controller.dispose();

        // Create new controller
        controller = VooFormController();

        // Verify new controller has clean state
        expect(controller.values, isEmpty);
        expect(controller.errors, isEmpty);
        expect(controller.getValue('field1'), isNull);
        expect(controller.getValue('field2'), isNull);
      });
    });

    group('Real-world Scenarios', () {
      test('handles complex registration form', () {
        // Setup registration form
        controller.registerFields({
          'username': FormFieldConfig(
            name: 'username',
            validators: [
              VooValidator.required(),
              VooValidator.minLength(3),
              VooValidator.maxLength(20),
              VooValidator.pattern(r'^[a-zA-Z0-9_]+$', 'Only alphanumeric and underscore allowed'),
            ],
          ),
          'email': FormFieldConfig(name: 'email', validators: [VooValidator.required(), VooValidator.email()]),
          'password': FormFieldConfig(name: 'password', validators: [VooValidator.required(), VooValidator.password()]),
          'confirmPassword': const FormFieldConfig(name: 'confirmPassword'),
          'age': FormFieldConfig(name: 'age', validators: [VooValidator.required(), VooValidator.min(18), VooValidator.max(120)]),
          'terms': FormFieldConfig(name: 'terms', validators: [(dynamic value) => value == true ? null : 'You must accept the terms']),
        });
        // Add dynamic validator for password confirmation
        controller.addValidators('confirmPassword', [
          (dynamic value) {
            final password = controller.getValue('password');
            return value != password ? 'Passwords do not match' : null;
          },
        ]);

        // Test invalid state
        expect(controller.validate(), false);

        // Fill form with invalid data
        controller.setValues({
          'username': 'ab', // Too short
          'email': 'invalid-email',
          'password': 'weak',
          'confirmPassword': 'different',
          'age': 15, // Too young
          'terms': false,
        });

        expect(controller.validate(), false);
        expect(controller.hasError('username'), true);
        expect(controller.hasError('email'), true);
        expect(controller.hasError('password'), true);
        expect(controller.hasError('confirmPassword'), true);
        expect(controller.hasError('age'), true);
        expect(controller.hasError('terms'), true);

        // Fill with valid data
        controller.setValues({
          'username': 'john_doe',
          'email': 'john@example.com',
          'password': 'SecurePass123!',
          'confirmPassword': 'SecurePass123!',
          'age': 25,
          'terms': true,
        });

        expect(controller.validate(), true);
        expect(controller.errors, isEmpty);
      });

      test('handles dynamic form with conditional fields', () {
        controller.registerField('userType', initialValue: 'personal');
        controller.registerField('firstName');
        controller.registerField('lastName');
        controller.registerField('companyName');
        controller.registerField('taxId');

        // Dynamic validation based on user type
        void updateValidators() {
          final userType = controller.getValue('userType');

          if (userType == 'business') {
            controller.setValidators('companyName', [VooValidator.required()]);
            controller.setValidators('taxId', [VooValidator.required()]);
            controller.removeValidators('firstName');
            controller.removeValidators('lastName');
            controller.hideField('firstName');
            controller.hideField('lastName');
            controller.showField('companyName');
            controller.showField('taxId');
          } else {
            controller.setValidators('firstName', [VooValidator.required()]);
            controller.setValidators('lastName', [VooValidator.required()]);
            controller.removeValidators('companyName');
            controller.removeValidators('taxId');
            controller.showField('firstName');
            controller.showField('lastName');
            controller.hideField('companyName');
            controller.hideField('taxId');
          }
        }

        // Initial setup for personal
        updateValidators();

        controller.setValues({'firstName': 'John', 'lastName': 'Doe'});

        expect(controller.validate(), true);

        // Switch to business
        controller.setValue('userType', 'business');
        updateValidators();

        expect(controller.validate(), false); // Company fields not filled

        controller.setValues({'companyName': 'Acme Corp', 'taxId': '12-3456789'});

        expect(controller.validate(), true);
        expect(controller.isFieldVisible('firstName'), false);
        expect(controller.isFieldVisible('companyName'), true);
      });

      test('handles multi-step wizard form', () {
        // Step 1: Personal Info
        controller.registerFields({
          'firstName': const FormFieldConfig(name: 'firstName'),
          'lastName': const FormFieldConfig(name: 'lastName'),
          'email': const FormFieldConfig(name: 'email'),
        });

        // Step 2: Address
        controller.registerFields({
          'street': const FormFieldConfig(name: 'street'),
          'city': const FormFieldConfig(name: 'city'),
          'zipCode': const FormFieldConfig(name: 'zipCode'),
        });

        // Step 3: Preferences
        controller.registerFields({
          'newsletter': const FormFieldConfig(name: 'newsletter', initialValue: false),
          'notifications': const FormFieldConfig(name: 'notifications', initialValue: true),
        });

        // Add validators for step 1
        controller.setValidators('firstName', [VooValidator.required()]);
        controller.setValidators('lastName', [VooValidator.required()]);
        controller.setValidators('email', [VooValidator.required(), VooValidator.email()]);

        // Validate step 1
        controller.setValues({'firstName': 'John', 'lastName': 'Doe', 'email': 'john@example.com'});

        final step1Valid = controller.validateField('firstName') && controller.validateField('lastName') && controller.validateField('email');
        expect(step1Valid, true);

        // Add validators for step 2
        controller.setValidators('street', [VooValidator.required()]);
        controller.setValidators('city', [VooValidator.required()]);
        controller.setValidators('zipCode', [VooValidator.required(), VooValidator.pattern(r'^\d{5}$', 'Invalid zip code')]);

        // Validate step 2
        controller.setValues({'street': '123 Main St', 'city': 'New York', 'zipCode': '10001'});

        final step2Valid = controller.validateField('street') && controller.validateField('city') && controller.validateField('zipCode');
        expect(step2Valid, true);

        // Final validation
        expect(controller.validate(), true);
        expect(controller.values.length, 8);
      });
    });

    group('Performance Tests', () {
      test('handles large number of fields efficiently', () {
        final stopwatch = Stopwatch()..start();

        // Register 1000 fields
        for (int i = 0; i < 1000; i++) {
          controller.registerField('field$i', initialValue: 'value$i');
        }

        expect(stopwatch.elapsedMilliseconds, lessThan(100));
        stopwatch.reset();

        // Set all values
        final values = <String, dynamic>{};
        for (int i = 0; i < 1000; i++) {
          values['field$i'] = 'newValue$i';
        }
        controller.setValues(values);

        expect(stopwatch.elapsedMilliseconds, lessThan(100));
        stopwatch.reset();

        // Validate all
        controller.validate();

        expect(stopwatch.elapsedMilliseconds, lessThan(100));
        stopwatch.stop();
      });

      test('handles deep validator chains efficiently', () {
        final validators = <dynamic>[];
        for (int i = 0; i < 100; i++) {
          validators.add((dynamic value) => null); // All pass
        }

        controller.registerField('field1', validators: validators);
        controller.setValue('field1', 'test');

        final stopwatch = Stopwatch()..start();
        controller.validate();
        stopwatch.stop();

        expect(stopwatch.elapsedMilliseconds, lessThan(50));
      });
    });

    group('isValid Getter - Critical Tests', () {
      test('returns false when field has validation errors', () {
        controller.registerField('field1', validators: [VooValidator.required()]);

        // Don't set value (field is empty)
        expect(controller.isValid, false);
      });

      test('returns true when all fields are valid', () {
        controller.registerField('field1', validators: [VooValidator.required()]);

        controller.setValue('field1', 'valid value');
        expect(controller.isValid, true);
      });

      test('does not modify errors map during silent validation', () {
        controller.registerField('field1', validators: [VooValidator.required()]);

        // Field is invalid but errors shouldn't show
        expect(controller.errors, isEmpty);
        expect(controller.isValid, false);
        expect(controller.errors, isEmpty); // Still empty after isValid check
      });

      test('detects invalid state with multiple fields', () {
        controller.registerField('field1', validators: [VooValidator.required()]);
        controller.registerField('field2', validators: [VooValidator.required()]);
        controller.registerField('field3'); // No validators

        controller.setValue('field1', 'value');
        // field2 is empty
        controller.setValue('field3', 'value');

        expect(controller.isValid, false);
      });

      test('handles validators that return non-string values', () {
        controller.registerField(
          'field1',
          validators: [
            (dynamic value) => true, // Returns bool instead of string
            (dynamic value) => 123, // Returns number instead of string
            (dynamic value) => <dynamic>[], // Returns list instead of string
          ],
        );

        controller.setValue('field1', 'test');
        expect(controller.isValid, true); // Non-string returns should be treated as valid
      });
    });
  });
}
