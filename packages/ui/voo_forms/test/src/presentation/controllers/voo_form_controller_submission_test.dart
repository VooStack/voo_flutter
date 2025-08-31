import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/src/domain/entities/field_type.dart';
import 'package:voo_forms/src/domain/entities/form.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/domain/entities/validation_rules/custom_validation.dart';
import 'package:voo_forms/src/presentation/controllers/voo_form_controller.dart';

void main() {
  group('VooFormController Submission Tests', () {
    late VooFormController controller;
    late VooForm form;

    setUp(() {
      form = const VooForm(
        id: 'test-form',
        title: 'Test Form',
        fields: [
          VooFormField<String>(
            id: 'name',
            name: 'name',
            label: 'Name',
            type: VooFieldType.text,
            validators: [
              CustomValidation<String>(
                validator: _validateNotEmpty,
                errorMessage: 'Field is required',
              ),
            ],
          ),
          VooFormField<num>(
            id: 'age',
            name: 'age',
            label: 'Age',
            type: VooFieldType.number,
            validators: [
              CustomValidation<num>(
                validator: _validatePositiveNumber,
                errorMessage: 'Must be positive',
              ),
            ],
          ),
        ],
      );
      controller = VooFormController(form: form);
    });

    tearDown(() {
      controller.dispose();
    });

    group('isSubmitting state', () {
      test('should be false initially', () {
        expect(controller.isSubmitting, isFalse);
      });

      test('should be true during submission', () async {
        // Arrange
        controller.setValue('name', 'John Doe');
        controller.setValue('age', 25);
        bool wasSubmittingDuringCallback = false;

        // Act
        await controller.submit(
          onSubmit: (values) async {
            wasSubmittingDuringCallback = controller.isSubmitting;
            await Future<void>.delayed(const Duration(milliseconds: 10));
          },
        );

        // Assert
        expect(wasSubmittingDuringCallback, isTrue);
        expect(controller.isSubmitting, isFalse);
      });

      test('should prevent multiple simultaneous submissions', () async {
        // Arrange
        controller.setValue('name', 'John Doe');
        controller.setValue('age', 25);
        int submissionCount = 0;

        // Act - Try to submit twice simultaneously
        final future1 = controller.submit(
          onSubmit: (values) async {
            submissionCount++;
            await Future<void>.delayed(const Duration(milliseconds: 50));
          },
        );

        final future2 = controller.submit(
          onSubmit: (values) async {
            submissionCount++;
            await Future<void>.delayed(const Duration(milliseconds: 50));
          },
        );

        await Future.wait([future1, future2]);

        // Assert - Only one submission should have occurred
        expect(submissionCount, equals(1));
      });

      test('should be false after submission error', () async {
        // Arrange
        controller.setValue('name', 'John Doe');
        controller.setValue('age', 25);
        String? errorMessage;

        // Act
        await controller.submit(
          onSubmit: (values) async {
            throw Exception('Submission failed');
          },
          onError: (error) {
            errorMessage = error.toString();
          },
        );

        // Assert
        expect(controller.isSubmitting, isFalse);
        expect(errorMessage, contains('Submission failed'));
      });
    });

    group('isSubmitted state', () {
      test('should be false initially', () {
        expect(controller.isSubmitted, isFalse);
      });

      test('should be true after successful submission', () async {
        // Arrange
        controller.setValue('name', 'John Doe');
        controller.setValue('age', 25);

        // Act
        final result = await controller.submit(
          onSubmit: (values) async {
            // Simulate API call
            await Future<void>.delayed(const Duration(milliseconds: 10));
          },
        );

        // Assert
        expect(result, isTrue);
        expect(controller.isSubmitted, isTrue);
        expect(controller.isSubmitting, isFalse);
      });

      test('should remain false after failed submission', () async {
        // Arrange
        controller.setValue('name', 'John Doe');
        controller.setValue('age', 25);

        // Act
        final result = await controller.submit(
          onSubmit: (values) async {
            throw Exception('API Error');
          },
        );

        // Assert
        expect(result, isFalse);
        expect(controller.isSubmitted, isFalse);
      });

      test('should reset to false when form is reset', () async {
        // Arrange
        controller.setValue('name', 'John Doe');
        controller.setValue('age', 25);
        await controller.submit(
          onSubmit: (values) async {},
        );
        expect(controller.isSubmitted, isTrue);

        // Act
        controller.reset();

        // Assert
        expect(controller.isSubmitted, isFalse);
      });

      test('should reset to false when form is cleared', () async {
        // Arrange
        controller.setValue('name', 'John Doe');
        controller.setValue('age', 25);
        await controller.submit(
          onSubmit: (values) async {},
        );
        expect(controller.isSubmitted, isTrue);

        // Act
        controller.clear();

        // Assert
        expect(controller.isSubmitted, isFalse);
      });
    });

    group('onSubmit callback', () {
      test('should receive all form values', () async {
        // Arrange
        controller.setValue('name', 'John Doe');
        controller.setValue('age', 25);
        Map<String, dynamic>? receivedValues;

        // Act
        await controller.submit(
          onSubmit: (values) async {
            receivedValues = values;
          },
        );

        // Assert
        expect(receivedValues, isNotNull);
        expect(receivedValues!['name'], equals('John Doe'));
        expect(receivedValues!['age'], equals(25));
      });

      test('should not be called if validation fails', () async {
        // Arrange
        controller.setValue('name', ''); // Invalid - empty
        controller.setValue('age', -5); // Invalid - negative
        bool onSubmitCalled = false;

        // Act
        final result = await controller.submit(
          onSubmit: (values) async {
            onSubmitCalled = true;
          },
        );

        // Assert
        expect(result, isFalse);
        expect(onSubmitCalled, isFalse);
        expect(controller.isSubmitted, isFalse);
      });

      test('should handle async operations correctly', () async {
        // Arrange
        controller.setValue('name', 'John Doe');
        controller.setValue('age', 25);
        bool asyncOperationCompleted = false;

        // Act
        await controller.submit(
          onSubmit: (values) async {
            await Future<void>.delayed(const Duration(milliseconds: 100));
            asyncOperationCompleted = true;
          },
        );

        // Assert
        expect(asyncOperationCompleted, isTrue);
      });

      test('should convert string numbers to num for number fields', () async {
        // Arrange
        controller.setValue('name', 'John Doe');
        controller.setValue('age', '30'); // String that should be converted
        Map<String, dynamic>? receivedValues;

        // Act
        await controller.submit(
          onSubmit: (values) async {
            receivedValues = values;
          },
        );

        // Assert
        expect(receivedValues!['age'], isA<num>());
        expect(receivedValues!['age'], equals(30));
      });
    });

    group('onSuccess callback', () {
      test('should be called after successful submission', () async {
        // Arrange
        controller.setValue('name', 'John Doe');
        controller.setValue('age', 25);
        bool onSuccessCalled = false;

        // Act
        await controller.submit(
          onSubmit: (values) async {},
          onSuccess: () {
            onSuccessCalled = true;
          },
        );

        // Assert
        expect(onSuccessCalled, isTrue);
      });

      test('should not be called after failed submission', () async {
        // Arrange
        controller.setValue('name', 'John Doe');
        controller.setValue('age', 25);
        bool onSuccessCalled = false;

        // Act
        await controller.submit(
          onSubmit: (values) async {
            throw Exception('Failed');
          },
          onSuccess: () {
            onSuccessCalled = true;
          },
        );

        // Assert
        expect(onSuccessCalled, isFalse);
      });

      test('should be called after onSubmit completes', () async {
        // Arrange
        controller.setValue('name', 'John Doe');
        controller.setValue('age', 25);
        final callOrder = <String>[];

        // Act
        await controller.submit(
          onSubmit: (values) async {
            callOrder.add('onSubmit');
            await Future<void>.delayed(const Duration(milliseconds: 10));
          },
          onSuccess: () {
            callOrder.add('onSuccess');
          },
        );

        // Assert
        expect(callOrder, equals(['onSubmit', 'onSuccess']));
      });
    });

    group('onError callback', () {
      test('should be called with error on submission failure', () async {
        // Arrange
        controller.setValue('name', 'John Doe');
        controller.setValue('age', 25);
        dynamic receivedError;

        // Act
        await controller.submit(
          onSubmit: (values) async {
            throw Exception('Network error');
          },
          onError: (error) {
            receivedError = error;
          },
        );

        // Assert
        expect(receivedError, isNotNull);
        expect(receivedError.toString(), contains('Network error'));
      });

      test('should not be called on successful submission', () async {
        // Arrange
        controller.setValue('name', 'John Doe');
        controller.setValue('age', 25);
        bool onErrorCalled = false;

        // Act
        await controller.submit(
          onSubmit: (values) async {},
          onError: (error) {
            onErrorCalled = true;
          },
        );

        // Assert
        expect(onErrorCalled, isFalse);
      });

      test('should handle different error types', () async {
        // Arrange
        controller.setValue('name', 'John Doe');
        controller.setValue('age', 25);
        final errors = <dynamic>[];

        // Test String error
        await controller.submit(
          onSubmit: (values) async {
            throw 'String error';
          },
          onError: errors.add,
        );

        // Test Exception
        await controller.submit(
          onSubmit: (values) async {
            throw Exception('Exception error');
          },
          onError: errors.add,
        );

        // Test custom error
        await controller.submit(
          onSubmit: (values) async {
            throw CustomError('Custom error');
          },
          onError: errors.add,
        );

        // Assert
        expect(errors.length, equals(3));
        expect(errors[0], isA<String>());
        expect(errors[1], isA<Exception>());
        expect(errors[2], isA<CustomError>());
      });
    });

    group('isDirty state during submission', () {
      test('should reset isDirty after successful submission', () async {
        // Arrange
        controller.setValue('name', 'John Doe');
        controller.setValue('age', 25);
        expect(controller.isDirty, isTrue);

        // Act
        await controller.submit(
          onSubmit: (values) async {},
        );

        // Assert
        expect(controller.isDirty, isFalse);
      });

      test('should maintain isDirty after failed submission', () async {
        // Arrange
        controller.setValue('name', 'John Doe');
        controller.setValue('age', 25);
        expect(controller.isDirty, isTrue);

        // Act
        await controller.submit(
          onSubmit: (values) async {
            throw Exception('Failed');
          },
        );

        // Assert
        expect(controller.isDirty, isTrue);
      });
    });

    group('validation during submission', () {
      test('should validate all fields before submission', () async {
        // Arrange
        controller.setValue('name', ''); // Invalid
        controller.setValue('age', -5); // Invalid

        // Act
        final result = await controller.submit(
          onSubmit: (values) async {},
        );

        // Assert
        expect(result, isFalse);
        expect(controller.form.errors.isNotEmpty, isTrue);
      });

      test('should show field errors after failed validation', () async {
        // Arrange
        controller.setValue('name', '');
        controller.setValue('age', -5);

        // Act
        await controller.submit(
          onSubmit: (values) async {},
        );

        // Assert
        expect(controller.getError('name'), equals('Field is required'));
        expect(controller.getError('age'), equals('Must be positive'));
      });

      test('should clear errors on successful submission', () async {
        // Arrange
        controller.setValue('name', '');
        controller.validateField('name'); // Create an error
        expect(controller.getError('name'), isNotNull);

        // Fix the error and submit
        controller.setValue('name', 'John Doe');
        controller.setValue('age', 25);

        // Act
        await controller.submit(
          onSubmit: (values) async {},
        );

        // Assert
        expect(controller.getError('name'), isNull);
        expect(controller.form.errors.isEmpty, isTrue);
      });
    });

    group('listener notifications', () {
      test('should notify listeners when submission starts', () async {
        // Arrange
        controller.setValue('name', 'John Doe');
        controller.setValue('age', 25);
        int notificationCount = 0;
        controller.addListener(() {
          notificationCount++;
        });

        // Act
        await controller.submit(
          onSubmit: (values) async {
            await Future<void>.delayed(const Duration(milliseconds: 10));
          },
        );

        // Assert - Should notify at least when starting and completing
        expect(notificationCount, greaterThanOrEqualTo(2));
      });

      test('should notify listeners on submission error', () async {
        // Arrange
        controller.setValue('name', 'John Doe');
        controller.setValue('age', 25);
        int notificationCount = 0;
        controller.addListener(() {
          notificationCount++;
        });

        // Act
        await controller.submit(
          onSubmit: (values) async {
            throw Exception('Error');
          },
        );

        // Assert
        expect(notificationCount, greaterThanOrEqualTo(2));
      });
    });

    group('edge cases', () {
      test('should handle null callbacks gracefully', () async {
        // Arrange
        controller.setValue('name', 'John Doe');
        controller.setValue('age', 25);

        // Act & Assert - Should not throw
        expect(
          () => controller.submit(
            onSubmit: (values) async {},
          ),
          returnsNormally,
        );
      });

      test('should handle empty form submission', () async {
        // Arrange - Form with no required fields
        const emptyForm = VooForm(
          id: 'empty-form',
          title: 'Empty Form',
          fields: [
            VooFormField<String>(
              id: 'optional',
              name: 'optional',
              label: 'Optional Field',
              type: VooFieldType.text,
            ),
          ],
        );
        final emptyController = VooFormController(form: emptyForm);

        // Act
        final result = await emptyController.submit(
          onSubmit: (values) async {},
        );

        // Assert
        expect(result, isTrue);
        expect(emptyController.isSubmitted, isTrue);

        // Cleanup
        emptyController.dispose();
      });

      test('should handle rapid successive submissions', () async {
        // Arrange
        controller.setValue('name', 'John Doe');
        controller.setValue('age', 25);
        final results = <bool>[];

        // Act - Rapid fire submissions
        for (int i = 0; i < 5; i++) {
          final result = await controller.submit(
            onSubmit: (values) async {
              await Future<void>.delayed(const Duration(milliseconds: 10));
            },
          );
          results.add(result);
        }

        // Assert - All should succeed since they run sequentially after completion
        expect(results.every((r) => r == true), isTrue);
      });
    });
  });
}

// Helper validation functions
String? _validateNotEmpty(String? value) =>
    value?.isNotEmpty == true ? null : 'Field is required';

String? _validatePositiveNumber(num? value) =>
    value != null && value > 0 ? null : 'Must be positive';

// Custom error class for testing
class CustomError implements Exception {
  final String message;
  CustomError(this.message);
  
  @override
  String toString() => 'CustomError: $message';
}