import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('Keyboard Dismissal Fix Tests', () {
    testWidgets('keyboard remains open when clicking field with validation error', (tester) async {
      final controller = VooFormController();

      // Register field with required validation
      controller.registerField('testField', validators: [const RequiredValidation<String>()]);

      // Create a focus node to track focus state
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormScope(
              controller: controller,
              isReadOnly: false,
              isLoading: false,
              child: VooTextField(name: 'testField', label: 'Test Field', focusNode: focusNode, validators: const [RequiredValidation<String>()]),
            ),
          ),
        ),
      );

      // Force validation to show error
      controller.validateField('testField', force: true);
      await tester.pump();

      // Verify error is shown
      expect(controller.getError('testField'), 'This field is required');

      // First click on field - keyboard should open and stay open
      await tester.tap(find.byType(TextFormField));
      await tester.pump();

      // Verify field has focus (keyboard would be open)
      expect(focusNode.hasFocus, isTrue, reason: 'Field should have focus on first click even with validation error');

      // Type a character to clear the error
      await tester.enterText(find.byType(TextFormField), 'a');
      await tester.pump();

      // Field should STILL have focus (keyboard should remain open)
      expect(focusNode.hasFocus, isTrue, reason: 'Field should maintain focus after typing clears validation error');

      // Error should be cleared
      expect(controller.getError('testField'), isNull);

      // Clear the field to trigger error again
      await tester.enterText(find.byType(TextFormField), '');
      await tester.pump();

      // Field should STILL have focus even with error appearing
      expect(focusNode.hasFocus, isTrue, reason: 'Field should maintain focus when validation error appears');

      // Error should be shown again
      expect(controller.getError('testField'), 'This field is required');
    });

    testWidgets('keyboard remains open when validation state changes', (tester) async {
      final controller = VooFormController();

      // Create a focus node to track focus state
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              controller: controller,
              fields: [
                VooTextField(
                  name: 'username',
                  label: 'Username',
                  focusNode: focusNode,
                  validators: const [RequiredValidation<String>(), MinLengthValidation(minLength: 3)],
                ),
              ],
            ),
          ),
        ),
      );

      // Focus the field
      await tester.tap(find.byType(TextFormField));
      await tester.pump();

      expect(focusNode.hasFocus, isTrue, reason: 'Field should have focus initially');

      // Type first character - triggers required validation to pass
      await tester.enterText(find.byType(TextFormField), 'a');
      await tester.pump();

      expect(focusNode.hasFocus, isTrue, reason: 'Field should maintain focus after first character (required validation passes)');

      // Type second character - still under min length
      await tester.enterText(find.byType(TextFormField), 'ab');
      await tester.pump();

      expect(focusNode.hasFocus, isTrue, reason: 'Field should maintain focus with min length error');

      // Type third character - passes all validation
      await tester.enterText(find.byType(TextFormField), 'abc');
      await tester.pump();

      expect(focusNode.hasFocus, isTrue, reason: 'Field should maintain focus when all validation passes');

      // Clear field - triggers required validation
      await tester.enterText(find.byType(TextFormField), '');
      await tester.pump();

      expect(focusNode.hasFocus, isTrue, reason: 'Field should maintain focus when field is cleared and error appears');
    });

    testWidgets('AnimatedBuilder properly isolates TextFormField from rebuilds', (tester) async {
      final controller = VooFormController();

      controller.registerField('testField', validators: [const RequiredValidation<String>()]);

      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormScope(
              controller: controller,
              isReadOnly: false,
              isLoading: false,
              child: VooTextField(name: 'testField', label: 'Test Field', focusNode: focusNode, validators: const [RequiredValidation<String>()]),
            ),
          ),
        ),
      );

      // Focus field
      await tester.tap(find.byType(TextFormField));
      await tester.pump();

      // Force validation error
      controller.validateField('testField', force: true);
      await tester.pump();

      // Type to clear error - this should NOT rebuild the TextFormField
      await tester.enterText(find.byType(TextFormField), 'test');
      await tester.pump();

      // The TextFormField should not have been rebuilt due to AnimatedBuilder isolation
      expect(focusNode.hasFocus, isTrue, reason: 'Focus should be maintained through validation state changes');
    });
  });
}
