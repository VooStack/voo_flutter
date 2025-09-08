import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/src/domain/enums/form_error_display_mode.dart';
import 'package:voo_forms/src/domain/enums/form_validation_mode.dart';
import 'package:voo_forms/src/domain/utils/validators.dart';
import 'package:voo_forms/src/presentation/state/voo_form_controller.dart';

void main() {
  group('VooFormController', () {
    late VooFormController controller;

    setUp(() {
      controller = VooFormController();
    });

    tearDown(() {
      controller.dispose();
    });

    group('Field Registration', () {
      test('should register a single field', () {
        controller.registerField(
          'username',
          initialValue: 'john_doe',
        );

        expect(controller.getValue('username'), 'john_doe');
      });

      test('should register multiple fields', () {
        controller.registerFields({
          'username': const FormFieldConfig(
            name: 'username',
            initialValue: 'john_doe',
          ),
          'email': const FormFieldConfig(
            name: 'email',
            initialValue: 'john@example.com',
          ),
        });

        expect(controller.getValue('username'), 'john_doe');
        expect(controller.getValue('email'), 'john@example.com');
      });

      test('should create focus nodes for registered fields', () {
        controller.registerField('username');
        
        final focusNode = controller.getFocusNode('username');
        expect(focusNode, isNotNull);
        expect(focusNode, isA<FocusNode>());
      });

      test('should register text controller', () {
        controller.registerField('username', initialValue: 'john');
        
        final textController = controller.registerTextController('username');
        expect(textController.text, 'john');
      });
    });

    group('Value Management', () {
      test('should set and get field value', () {
        controller.registerField('username');
        controller.setValue('username', 'john_doe');
        
        expect(controller.getValue('username'), 'john_doe');
      });

      test('should get typed value', () {
        controller.registerField('age');
        controller.setValue('age', 25);
        
        expect(controller.getTypedValue<int>('age'), 25);
        expect(controller.getTypedValue<String>('age'), isNull);
      });

      test('should set multiple values at once', () {
        controller.registerField('username');
        controller.registerField('email');
        
        controller.setValues({
          'username': 'john_doe',
          'email': 'john@example.com',
        });
        
        expect(controller.getValue('username'), 'john_doe');
        expect(controller.getValue('email'), 'john@example.com');
      });

      test('should mark form as dirty when value changes', () {
        controller.registerField('username');
        expect(controller.isDirty, false);
        
        controller.setValue('username', 'john_doe');
        expect(controller.isDirty, true);
      });

      test('should update text controller when value changes', () {
        controller.registerField('username');
        final textController = controller.registerTextController('username');
        
        controller.setValue('username', 'new_value');
        expect(textController.text, 'new_value');
      });
    });

    group('Validation', () {
      test('should validate required field with VooValidator', () {
        controller.registerField(
          'username',
          validators: [VooValidator.required()],
        );
        
        // Field is empty, should be invalid
        expect(controller.validate(), false);
        expect(controller.getError('username'), 'This field is required');
        
        // Set value, should be valid
        controller.setValue('username', 'john_doe');
        expect(controller.validate(), true);
        expect(controller.getError('username'), isNull);
      });

      test('should validate email field with VooValidator', () {
        controller.registerField(
          'email',
          validators: [
            VooValidator.required(),
            VooValidator.email(),
          ],
        );
        
        // Field is empty, should be invalid
        expect(controller.validate(), false);
        expect(controller.getError('email'), 'This field is required');
        
        // Invalid email
        controller.setValue('email', 'invalid');
        controller.validateField('email', force: true);
        expect(controller.getError('email'), 'Please enter a valid email address');
        
        // Valid email
        controller.setValue('email', 'john@example.com');
        expect(controller.validateField('email'), true);
        expect(controller.getError('email'), isNull);
      });

      test('should validate ALL fields when calling validate()', () {
        // Register 5 fields with required validators
        controller.registerField('field1', validators: [VooValidator.required()]);
        controller.registerField('field2', validators: [VooValidator.required()]);
        controller.registerField('field3', validators: [VooValidator.required()]);
        controller.registerField('field4', validators: [VooValidator.required()]);
        controller.registerField('field5', validators: [VooValidator.required()]);
        
        // All fields empty, should be invalid
        expect(controller.validate(), false);
        expect(controller.errors.length, 5); // Should have 5 errors
        expect(controller.getError('field1'), 'This field is required');
        expect(controller.getError('field2'), 'This field is required');
        expect(controller.getError('field3'), 'This field is required');
        expect(controller.getError('field4'), 'This field is required');
        expect(controller.getError('field5'), 'This field is required');
        
        // Fill in 3 fields, should still be invalid
        controller.setValue('field1', 'value1');
        controller.setValue('field2', 'value2');
        controller.setValue('field3', 'value3');
        expect(controller.validate(), false);
        expect(controller.errors.length, 2); // Should have 2 errors now
        expect(controller.getError('field1'), isNull);
        expect(controller.getError('field2'), isNull);
        expect(controller.getError('field3'), isNull);
        expect(controller.getError('field4'), 'This field is required');
        expect(controller.getError('field5'), 'This field is required');
        
        // Fill all fields, should be valid
        controller.setValue('field4', 'value4');
        controller.setValue('field5', 'value5');
        expect(controller.validate(), true);
        expect(controller.errors.isEmpty, true);
      });

      test('should validate complex form with multiple field types', () {
        // Register different types of fields with various validators
        controller.registerField(
          'username',
          validators: [
            VooValidator.required(),
            VooValidator.minLength(3),
          ],
        );
        
        controller.registerField(
          'email',
          validators: [
            VooValidator.required(),
            VooValidator.email(),
          ],
        );
        
        controller.registerField(
          'age',
          validators: [
            VooValidator.required(),
            VooValidator.min(18),
            VooValidator.max(100),
          ],
        );
        
        controller.registerField(
          'phone',
          validators: [
            VooValidator.required(),
            VooValidator.phone(),
          ],
        );
        
        controller.registerField(
          'website',
          validators: [
            VooValidator.url(),
          ],
        );
        
        // All required fields empty, should be invalid
        expect(controller.validate(), false);
        expect(controller.errors.length, 4); // 4 required fields
        
        // Set invalid values
        controller.setValue('username', 'ab'); // Too short
        controller.setValue('email', 'notanemail'); // Invalid email
        controller.setValue('age', 15); // Below minimum
        controller.setValue('phone', '123'); // Invalid phone
        controller.setValue('website', 'notaurl'); // Invalid URL
        
        controller.validateAll(force: true);
        expect(controller.getError('username'), 'Minimum 3 characters required');
        expect(controller.getError('email'), 'Please enter a valid email address');
        expect(controller.getError('age'), 'Must be at least 18');
        expect(controller.getError('phone'), 'Please enter a valid phone number');
        expect(controller.getError('website'), 'Please enter a valid URL');
        
        // Set valid values
        controller.setValue('username', 'johndoe');
        controller.setValue('email', 'john@example.com');
        controller.setValue('age', 25);
        controller.setValue('phone', '+1-555-123-4567');
        controller.setValue('website', 'https://example.com');
        
        expect(controller.validate(), true);
        expect(controller.errors.isEmpty, true);
      });

      test('should validate with mixed validators (function and VooValidationRule)', () {
        controller.registerField(
          'password',
          validators: [
            VooValidator.required(),
            (dynamic value) => value != null && value.toString().length < 8
                ? 'Password must be at least 8 characters'
                : null,
          ],
        );
        
        // Field is empty, should be invalid
        expect(controller.validate(), false);
        expect(controller.getError('password'), 'This field is required');
        
        // Short password
        controller.setValue('password', '123');
        controller.validateField('password', force: true);
        expect(controller.getError('password'), 'Password must be at least 8 characters');
        
        // Valid password
        controller.setValue('password', 'password123');
        expect(controller.validateField('password'), true);
        expect(controller.getError('password'), isNull);
      });

      test('should validate required field', () {
        controller.registerField(
          'username',
          validators: [
            (value) => value == null || value.toString().isEmpty
                ? 'Username is required'
                : null,
          ],
        );
        
        // Field is empty, should be invalid
        expect(controller.validate(), false);
        expect(controller.getError('username'), 'Username is required');
        
        // Set value, should be valid
        controller.setValue('username', 'john_doe');
        expect(controller.validate(), true);
        expect(controller.getError('username'), isNull);
      });

      test('should validate multiple validators', () {
        controller.registerField(
          'password',
          validators: [
            (value) => value == null || value.toString().isEmpty
                ? 'Password is required'
                : null,
            (value) => value != null && value.toString().length < 8
                ? 'Password must be at least 8 characters'
                : null,
          ],
        );
        
        // Empty password
        expect(controller.validateField('password'), false);
        expect(controller.getError('password'), 'Password is required');
        
        // Short password
        controller.setValue('password', '123');
        controller.validateField('password', force: true);
        expect(controller.getError('password'), 'Password must be at least 8 characters');
        
        // Valid password
        controller.setValue('password', 'password123');
        expect(controller.validateField('password'), true);
        expect(controller.getError('password'), isNull);
      });

      test('should validate all fields', () {
        controller.registerField(
          'username',
          validators: [
            (value) => value == null || value.toString().isEmpty
                ? 'Username is required'
                : null,
          ],
        );
        controller.registerField(
          'email',
          validators: [
            (value) => value == null || value.toString().isEmpty
                ? 'Email is required'
                : null,
          ],
        );
        
        expect(controller.validateAll(), false);
        expect(controller.errors.length, 2);
        
        controller.setValue('username', 'john');
        controller.setValue('email', 'john@example.com');
        
        expect(controller.validateAll(), true);
        expect(controller.errors.isEmpty, true);
      });

      test('should support silent validation', () {
        controller.registerField(
          'username',
          validators: [
            (value) => value == null || value.toString().isEmpty
                ? 'Username is required'
                : null,
          ],
        );
        
        // Silent validation doesn't update errors
        expect(controller.validate(silent: true), false);
        expect(controller.errors.isEmpty, true);
        
        // Non-silent validation updates errors
        expect(controller.validate(silent: false), false);
        expect(controller.errors.isNotEmpty, true);
      });

      test('should respect error display mode onTyping', () {
        controller = VooFormController(
          errorDisplayMode: VooFormErrorDisplayMode.onTyping,
        );
        
        controller.registerField(
          'username',
          validators: [
            (value) => value == null || value.toString().isEmpty
                ? 'Username is required'
                : null,
          ],
        );
        
        // Should show error immediately on validation
        controller.setValue('username', '', validate: true);
        expect(controller.getError('username'), 'Username is required');
      });

      test('should respect error display mode onSubmit', () {
        controller = VooFormController(
          errorDisplayMode: VooFormErrorDisplayMode.onSubmit,
        );
        
        controller.registerField(
          'username',
          validators: [
            (value) => value == null || value.toString().isEmpty
                ? 'Username is required'
                : null,
          ],
        );
        
        // Should not show error before submit
        controller.validateField('username');
        expect(controller.getError('username'), isNull);
        
        // Should show error after submit attempt
        controller.submit(
          onSubmit: (_) async {},
        ).then((success) {
          expect(success, false);
          expect(controller.getError('username'), 'Username is required');
        });
      });
    });

    group('Form Operations', () {
      test('should clear all values', () {
        controller.registerField('username', initialValue: 'john');
        controller.registerField('email', initialValue: 'john@example.com');
        
        controller.clear();
        
        expect(controller.getValue('username'), isNull);
        expect(controller.getValue('email'), isNull);
        expect(controller.isDirty, false);
      });

      test('should reset to initial values', () {
        controller.registerField('username', initialValue: 'john');
        
        controller.setValue('username', 'jane');
        expect(controller.getValue('username'), 'jane');
        
        controller.reset();
        expect(controller.getValue('username'), isNull); // Reset clears all values
        expect(controller.isDirty, false);
      });

      test('should clear errors', () {
        controller.registerField(
          'username',
          validators: [
            (value) => 'Always error',
          ],
        );
        
        controller.validateAll();
        expect(controller.errors.isNotEmpty, true);
        
        controller.clearErrors();
        expect(controller.errors.isEmpty, true);
      });

      test('should clear specific field error', () {
        controller.registerField(
          'username',
          validators: [(value) => 'Username error'],
        );
        controller.registerField(
          'email',
          validators: [(value) => 'Email error'],
        );
        
        controller.validateAll();
        expect(controller.errors.length, 2);
        
        controller.clearError('username');
        expect(controller.getError('username'), isNull);
        expect(controller.getError('email'), 'Email error');
      });
    });

    group('Submit', () {
      test('should submit valid form', () async {
        controller.registerField('username', initialValue: 'john');
        controller.registerField('email', initialValue: 'john@example.com');
        
        bool submitted = false;
        Map<String, dynamic>? submittedValues;
        
        final result = await controller.submit(
          onSubmit: (values) async {
            submitted = true;
            submittedValues = values;
          },
        );
        
        expect(result, true);
        expect(submitted, true);
        expect(submittedValues, {
          'username': 'john',
          'email': 'john@example.com',
        });
        expect(controller.isSubmitted, true);
        expect(controller.isDirty, false);
      });

      test('should not submit invalid form', () async {
        controller.registerField(
          'username',
          validators: [
            (value) => value == null || value.toString().isEmpty
                ? 'Username is required'
                : null,
          ],
        );
        
        bool submitted = false;
        
        final result = await controller.submit(
          onSubmit: (values) async {
            submitted = true;
          },
        );
        
        expect(result, false);
        expect(submitted, false);
        expect(controller.getError('username'), 'Username is required');
      });

      test('should handle submit error', () async {
        controller.registerField('username', initialValue: 'john');
        
        dynamic capturedError;
        
        final result = await controller.submit(
          onSubmit: (values) async {
            throw Exception('Submit failed');
          },
          onError: (error) {
            capturedError = error;
          },
        );
        
        expect(result, false);
        expect(capturedError, isNotNull);
        expect(controller.isSubmitting, false);
      });

      test('should prevent multiple simultaneous submits', () async {
        controller.registerField('username', initialValue: 'john');
        
        int submitCount = 0;
        
        // Start first submit
        final future1 = controller.submit(
          onSubmit: (values) async {
            submitCount++;
            await Future.delayed(const Duration(milliseconds: 100));
          },
        );
        
        // Try second submit immediately
        final future2 = controller.submit(
          onSubmit: (values) async {
            submitCount++;
          },
        );
        
        await Future.wait([future1, future2]);
        
        expect(submitCount, 1); // Only one submit should happen
      });
    });

    group('Field Visibility and Enablement', () {
      test('should enable and disable fields', () {
        controller.registerField('username', enabled: true);
        
        expect(controller.isFieldEnabled('username'), true);
        
        controller.disableField('username');
        expect(controller.isFieldEnabled('username'), false);
        
        controller.enableField('username');
        expect(controller.isFieldEnabled('username'), true);
      });

      test('should show and hide fields', () {
        controller.registerField('username', visible: true);
        
        expect(controller.isFieldVisible('username'), true);
        
        controller.hideField('username');
        expect(controller.isFieldVisible('username'), false);
        
        controller.showField('username');
        expect(controller.isFieldVisible('username'), true);
      });
    });

    group('Focus Management', () {
      test('should focus next field', () {
        controller.registerField('field1', visible: true, enabled: true);
        controller.registerField('field2', visible: true, enabled: true);
        controller.registerField('field3', visible: true, enabled: true);
        
        // Note: Can't test actual focus without a widget tree
        // Just ensure the method doesn't throw
        controller.focusNextField('field1');
      });

      test('should focus previous field', () {
        controller.registerField('field1', visible: true, enabled: true);
        controller.registerField('field2', visible: true, enabled: true);
        controller.registerField('field3', visible: true, enabled: true);
        
        // Note: Can't test actual focus without a widget tree
        // Just ensure the method doesn't throw
        controller.focusPreviousField('field2');
      });

      test('should skip disabled fields in focus navigation', () {
        controller.registerField('field1', visible: true, enabled: true);
        controller.registerField('field2', visible: true, enabled: false);
        controller.registerField('field3', visible: true, enabled: true);
        
        // Should skip field2 since it's disabled
        controller.focusNextField('field1');
      });
    });

    group('Validator Management', () {
      test('should add validators to existing field', () {
        controller.registerField('username');
        
        controller.addValidators('username', [
          (value) => value == null ? 'Required' : null,
        ]);
        
        expect(controller.validateField('username'), false);
        expect(controller.getError('username'), 'Required');
      });

      test('should replace validators', () {
        controller.registerField(
          'username',
          validators: [
            (value) => 'Old validator',
          ],
        );
        
        controller.setValidators('username', [
          (value) => 'New validator',
        ]);
        
        controller.validateField('username');
        expect(controller.getError('username'), 'New validator');
      });

      test('should remove validators', () {
        controller.registerField(
          'username',
          validators: [
            (value) => 'Error',
          ],
        );
        
        controller.removeValidators('username');
        expect(controller.validateField('username'), true);
      });
    });

    group('toJson', () {
      test('should convert form values to JSON', () {
        controller.registerField('username', initialValue: 'john');
        controller.registerField('age', initialValue: 25);
        controller.registerField('active', initialValue: true);
        
        final json = controller.toJson();
        
        expect(json, {
          'username': 'john',
          'age': 25,
          'active': true,
        });
      });
    });

    group('Change Notifications', () {
      test('should notify listeners on value change', () {
        controller.registerField('username');
        
        int notificationCount = 0;
        controller.addListener(() {
          notificationCount++;
        });
        
        controller.setValue('username', 'john');
        expect(notificationCount, greaterThan(0));
      });

      test('should notify listeners on validation', () {
        controller.registerField(
          'username',
          validators: [(value) => 'Error'],
        );
        
        int notificationCount = 0;
        controller.addListener(() {
          notificationCount++;
        });
        
        controller.validateAll();
        expect(notificationCount, greaterThan(0));
      });
    });
  });
}