import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/inputs/voo_dropdown_search_field.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('Validation Error Display', () {
    testWidgets('VooTextField shows validation error when invalid', (WidgetTester tester) async {
      final controller = VooFormController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              controller: controller,
              fields: [
                VooTextField(name: 'email', label: 'Email', validators: [VooValidator.required(), VooValidator.email()]),
              ],
            ),
          ),
        ),
      );

      // Field should not show error initially
      expect(find.text('This field is required'), findsNothing);

      // Trigger validation
      controller.validate();
      await tester.pump();

      // Now the error should be displayed
      expect(find.text('This field is required'), findsOneWidget);

      // Enter invalid email
      await tester.enterText(find.byType(TextFormField), 'notanemail');
      await tester.pump();

      // Validate again
      controller.validate();
      await tester.pump();

      // Should show email validation error
      expect(find.text('Please enter a valid email address'), findsOneWidget);

      // Enter valid email
      await tester.enterText(find.byType(TextFormField), 'test@example.com');
      await tester.pump();

      // Validate again
      controller.validate();
      await tester.pump();

      // Error should be gone
      expect(find.text('Please enter a valid email address'), findsNothing);
      expect(find.text('This field is required'), findsNothing);
    });

    testWidgets('VooDropdownField shows validation error when invalid', (WidgetTester tester) async {
      final controller = VooFormController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              controller: controller,
              fields: [
                VooDropdownField<String>(name: 'country', label: 'Country', options: const ['USA', 'Canada', 'Mexico'], validators: [VooValidator.required()]),
              ],
            ),
          ),
        ),
      );

      // Field should not show error initially
      expect(find.text('This field is required'), findsNothing);

      // Trigger validation
      controller.validate();
      await tester.pump();

      // Now the error should be displayed
      expect(find.text('This field is required'), findsOneWidget);

      // Select a value
      await tester.tap(find.byType(VooDropdownSearchField<String>));
      await tester.pumpAndSettle();

      // Find and tap an option
      await tester.tap(find.text('USA').last);
      await tester.pumpAndSettle();

      // Validate again
      controller.validate();
      await tester.pump();

      // Error should be gone
      expect(find.text('This field is required'), findsNothing);
    });

    testWidgets('Multiple fields show their respective validation errors', (WidgetTester tester) async {
      final controller = VooFormController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              controller: controller,
              fields: [
                VooTextField(name: 'name', label: 'Name', validators: [VooValidator.required()]),
                VooEmailField(name: 'email', label: 'Email', validators: [VooValidator.required(), VooValidator.email()]),
                VooNumberField(name: 'age', label: 'Age', validators: [VooValidator.required(), VooValidator.min(18, 'Must be at least 18')]),
              ],
            ),
          ),
        ),
      );

      // Fields should not show errors initially
      expect(find.text('This field is required'), findsNothing);

      // Trigger validation
      controller.validate();
      await tester.pump();

      // All required fields should show errors
      expect(find.text('This field is required'), findsNWidgets(3));

      // Enter invalid values
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'John Doe'); // Valid name
      await tester.enterText(textFields.at(1), 'invalid'); // Invalid email
      await tester.enterText(textFields.at(2), '15'); // Age below minimum
      await tester.pump();

      // Validate again
      controller.validate();
      await tester.pump();

      // Check specific errors
      expect(find.text('This field is required'), findsNothing); // Name is valid now
      expect(find.text('Please enter a valid email address'), findsOneWidget);
      expect(find.text('Must be at least 18'), findsOneWidget);
    });

    testWidgets('Errors clear when form is reset', (WidgetTester tester) async {
      final controller = VooFormController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              controller: controller,
              fields: [
                VooTextField(name: 'name', label: 'Name', validators: [VooValidator.required()]),
              ],
            ),
          ),
        ),
      );

      // Trigger validation to show error
      controller.validate();
      await tester.pump();

      expect(find.text('This field is required'), findsOneWidget);

      // Reset the form
      controller.reset();
      // Wait for all deferred callbacks and rebuilds
      await tester.pumpAndSettle();

      // Error should be cleared
      expect(find.text('This field is required'), findsNothing);
    });

    testWidgets('Errors update dynamically as user types', (WidgetTester tester) async {
      final controller = VooFormController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              controller: controller,
              fields: [
                VooTextField(
                  name: 'username',
                  label: 'Username',
                  validators: [VooValidator.required(), VooValidator.minLength(5, 'Username must be at least 5 characters')],
                ),
              ],
            ),
          ),
        ),
      );

      // Trigger validation to show initial error
      controller.validate();
      await tester.pump();

      expect(find.text('This field is required'), findsOneWidget);

      // Start typing - too short
      await tester.enterText(find.byType(TextFormField), 'abc');
      controller.validate();
      await tester.pump();

      expect(find.text('Username must be at least 5 characters'), findsOneWidget);

      // Type enough characters
      await tester.enterText(find.byType(TextFormField), 'abcde');
      controller.validate();
      await tester.pump();

      // Error should be gone
      expect(find.text('Username must be at least 5 characters'), findsNothing);
    });
  });
}
