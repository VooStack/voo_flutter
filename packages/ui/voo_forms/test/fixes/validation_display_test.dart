import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('Validation Display Tests', () {
    testWidgets('validateAll with force shows errors immediately', (tester) async {
      final controller = VooFormController(errorDisplayMode: VooFormErrorDisplayMode.onSubmit);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              controller: controller,
              fields: [
                VooTextField(name: 'username', label: 'Username', validators: [VooValidator.required()]),
                VooDropdownField(name: 'country', label: 'Country', options: const ['USA', 'Canada', 'Mexico'], validators: [VooValidator.required()]),
              ],
            ),
          ),
        ),
      );

      // Initially no errors shown
      expect(controller.errors.isEmpty, isTrue);

      // Call validateAll with force=true
      final isValid = controller.validateAll(force: true);
      await tester.pump();

      // Validation should fail
      expect(isValid, isFalse);

      // Errors should be shown
      expect(controller.errors.isNotEmpty, isTrue);
      expect(controller.getError('username'), 'This field is required');
      expect(controller.getError('country'), 'This field is required');

      // Errors should be visible in UI
      expect(find.text('This field is required'), findsNWidgets(2));
    });

    testWidgets('submit method validates and shows errors', (tester) async {
      final controller = VooFormController(errorDisplayMode: VooFormErrorDisplayMode.onSubmit);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              controller: controller,
              fields: [
                VooTextField(name: 'email', label: 'Email', validators: [VooValidator.required(), VooValidator.email()]),
                VooNumberField(name: 'age', label: 'Age', validators: [VooValidator.required(), VooValidator.min(18)]),
              ],
            ),
          ),
        ),
      );

      // Initially no errors shown
      expect(controller.errors.isEmpty, isTrue);

      // Attempt to submit with empty fields
      bool submitSuccess = false;
      await controller.submit(
        onSubmit: (values) async {
          submitSuccess = true;
        },
      );
      await tester.pump();

      // Submit should fail
      expect(submitSuccess, isFalse);

      // Errors should be shown
      expect(controller.errors.isNotEmpty, isTrue);
      expect(controller.getError('email'), 'This field is required');
      expect(controller.getError('age'), 'This field is required');

      // Fill in invalid values
      controller.setValue('email', 'invalid');
      controller.setValue('age', 10);

      // Try to submit again
      await controller.submit(
        onSubmit: (values) async {
          submitSuccess = true;
        },
      );
      await tester.pump();

      // Submit should still fail
      expect(submitSuccess, isFalse);

      // Different errors should be shown
      expect(controller.getError('email'), contains('valid email'));
      expect(controller.getError('age'), contains('at least 18'));
    });

    testWidgets('clearErrors removes all validation errors', (tester) async {
      final controller = VooFormController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              controller: controller,
              fields: [
                VooTextField(name: 'field1', validators: [VooValidator.required()]),
                VooTextField(name: 'field2', validators: [VooValidator.required()]),
              ],
            ),
          ),
        ),
      );

      // Force validation to show errors
      controller.validateAll(force: true);
      await tester.pump();

      // Errors should be shown
      expect(controller.errors.length, 2);
      expect(find.text('This field is required'), findsNWidgets(2));

      // Clear errors
      controller.clearErrors();
      await tester.pump();

      // Errors should be cleared
      expect(controller.errors.isEmpty, isTrue);
      expect(find.text('This field is required'), findsNothing);
    });

    testWidgets('VooFormPageBuilder passes controller correctly', (tester) async {
      final controller = VooFormController();
      VooFormController? capturedController;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormPageBuilder(
              controller: controller,
              actionsBuilder: (context, actionController) {
                capturedController = actionController;
                return TextButton(
                  onPressed: () {
                    actionController.validateAll(force: true);
                  },
                  child: const Text('Validate'),
                );
              },
              form: VooForm(
                controller: controller,
                fields: [
                  VooTextField(name: 'test', validators: [VooValidator.required()]),
                ],
              ),
            ),
          ),
        ),
      );

      // The controller passed to actionsBuilder should be the same
      expect(capturedController, same(controller));

      // Click validate button
      await tester.tap(find.text('Validate'));
      await tester.pump();

      // Error should be shown
      expect(controller.getError('test'), 'This field is required');
      expect(find.text('This field is required'), findsOneWidget);
    });
  });
}
