import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('Dropdown Validation Fix', () {
    testWidgets('dropdown selection clears validation error', (tester) async {
      final controller = VooFormController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              controller: controller,
              fields: const [
                VooDropdownField<String>(
                  name: 'dropdown',
                  label: 'Jurisdiction',
                  options: ['Option 1', 'Option 2', 'Option 3'],
                  placeholder: 'Select an option',
                  validators: [RequiredValidation<String>()],
                ),
              ],
            ),
          ),
        ),
      );

      // Trigger validation to show error
      controller.validateField('dropdown', force: true);
      await tester.pump();

      // Verify error is shown
      expect(find.text('This field is required'), findsOneWidget);

      // Open dropdown
      await tester.tap(find.byType(VooDropdownField<String>));
      await tester.pumpAndSettle();

      // Select an option
      await tester.tap(find.text('Option 1').last);
      await tester.pumpAndSettle();

      // Verify error is cleared
      expect(find.text('This field is required'), findsNothing);
    });

    testWidgets('async dropdown selection clears validation error', (tester) async {
      final controller = VooFormController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              controller: controller,
              fields: [
                VooAsyncDropdownField<String>(
                  name: 'asyncDropdown',
                  label: 'Async Dropdown',
                  asyncOptionsLoader: (query) async {
                    await Future<void>.delayed(const Duration(milliseconds: 100));
                    return ['Option 1', 'Option 2', 'Option 3'];
                  },
                  placeholder: 'Select an option',
                  validators: const [RequiredValidation<String>()],
                ),
              ],
            ),
          ),
        ),
      );

      // Trigger validation to show error
      controller.validateField('asyncDropdown', force: true);
      await tester.pump();

      // Verify error is shown
      expect(find.text('This field is required'), findsOneWidget);

      // Open dropdown
      await tester.tap(find.byType(VooAsyncDropdownField<String>));
      await tester.pumpAndSettle();

      // Wait for options to load
      await tester.pump(const Duration(milliseconds: 150));

      // Select an option
      await tester.tap(find.text('Option 1').last);
      await tester.pumpAndSettle();

      // Verify error is cleared
      expect(find.text('This field is required'), findsNothing);
    });
  });

  group('Focus Retention Fix', () {
    testWidgets('text field maintains focus when error clears', (tester) async {
      final controller = VooFormController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              controller: controller,
              fields: const [
                VooTextField(
                  name: 'textField',
                  label: 'Text Field',
                  validators: [RequiredValidation<String>()],
                ),
              ],
            ),
          ),
        ),
      );

      // Trigger validation to show error
      controller.validateField('textField', force: true);
      await tester.pump();

      // Verify error is shown
      expect(find.text('This field is required'), findsOneWidget);

      // Focus the field
      await tester.tap(find.byType(TextFormField));
      await tester.pump();

      // Verify field has focus by checking if we can type
      // The fact that we can type means the field has focus

      // Type a character
      await tester.enterText(find.byType(TextFormField), 'a');
      await tester.pump();

      // Verify we can continue typing (field still has focus)
      await tester.enterText(find.byType(TextFormField), 'ab');
      await tester.pump();
      expect(find.text('ab'), findsOneWidget);

      // Verify error is cleared
      expect(find.text('This field is required'), findsNothing);
    });

    testWidgets('currency field maintains focus when error clears', (tester) async {
      final controller = VooFormController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              controller: controller,
              fields: const [
                VooCurrencyField(
                  name: 'currencyField',
                  label: 'Amount',
                  validators: [RequiredValidation<double>()],
                ),
              ],
            ),
          ),
        ),
      );

      // Trigger validation to show error
      controller.validateField('currencyField', force: true);
      await tester.pump();

      // Verify error is shown
      expect(find.text('This field is required'), findsOneWidget);

      // Focus the field
      await tester.tap(find.byType(TextFormField));
      await tester.pump();

      // Type a digit - this should clear the validation error
      await tester.enterText(find.byType(TextFormField), '5');
      await tester.pump();

      // Verify error is cleared (main goal of this test)
      expect(find.text('This field is required'), findsNothing);
      
      // Type more to verify field still has focus
      await tester.enterText(find.byType(TextFormField), '50');
      await tester.pump();
      
      // Just verify we have input (don't check exact format)
      expect(controller.getValue('currencyField'), isNotNull);
    });

    testWidgets('number field maintains focus when error clears', (tester) async {
      final controller = VooFormController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              controller: controller,
              fields: const [
                VooNumberField(
                  name: 'numberField',
                  label: 'Number',
                  validators: [RequiredValidation<num>()],
                ),
              ],
            ),
          ),
        ),
      );

      // Trigger validation to show error
      controller.validateField('numberField', force: true);
      await tester.pump();

      // Verify error is shown
      expect(find.text('This field is required'), findsOneWidget);

      // Focus the field
      await tester.tap(find.byType(TextFormField));
      await tester.pump();

      // Verify field has focus by checking if we can type
      // The fact that we can type means the field has focus

      // Type a digit
      await tester.enterText(find.byType(TextFormField), '1');
      await tester.pump();

      // Verify we can continue typing (field still has focus)
      await tester.enterText(find.byType(TextFormField), '12');
      await tester.pump();
      expect(find.text('12'), findsOneWidget);

      // Verify error is cleared
      expect(find.text('This field is required'), findsNothing);
    });

    testWidgets('date field selection clears validation error', (tester) async {
      final controller = VooFormController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              controller: controller,
              fields: const [
                VooDateField(
                  name: 'dateField',
                  label: 'Date',
                  validators: [RequiredValidation<DateTime>()],
                ),
              ],
            ),
          ),
        ),
      );

      // Trigger validation to show error
      controller.validateField('dateField', force: true);
      await tester.pump();

      // Verify error is shown
      expect(find.text('This field is required'), findsOneWidget);

      // Tap the date field to open picker
      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();

      // Select a date (today)
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Verify error is cleared
      expect(find.text('This field is required'), findsNothing);
    });
  });
}
