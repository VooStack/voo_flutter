import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('Focus retention issue when clearing validation errors', () {
    testWidgets('should maintain focus when clearing error by typing', (tester) async {
      // Create a controller with onSubmit error display mode
      final controller = VooFormController(errorDisplayMode: VooFormErrorDisplayMode.onSubmit);

      // Build the form with multiple fields to test focus behavior
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              controller: controller,
              fields: [
                VooTextField(name: 'siteName', label: 'Site Name', validators: [VooValidator.required()]),
                VooTextField(name: 'description', label: 'Description', validators: [VooValidator.required()]),
              ],
            ),
          ),
        ),
      );

      // Allow the widgets to build and register with the controller
      await tester.pumpAndSettle();

      // Find the first text field
      final siteNameField = find.byType(TextFormField).first;

      // Trigger validation to show errors
      controller.validateAll(force: true);
      await tester.pump();

      // Verify errors are shown
      expect(controller.hasError('siteName'), isTrue);
      expect(find.text('This field is required'), findsWidgets);

      // Tap on the site name field to focus it
      await tester.tap(siteNameField);
      await tester.pump();

      // Verify the field has focus
      final FocusNode siteNameFocusNode = controller.getFocusNode('siteName');
      expect(siteNameFocusNode.hasFocus, isTrue);

      // Start typing to clear the error
      await tester.enterText(siteNameField, 'a');
      await tester.pump();

      // The error should be cleared
      expect(controller.hasError('siteName'), isFalse);

      // CRITICAL: The focus should remain on the field
      expect(siteNameFocusNode.hasFocus, isTrue, reason: 'Focus should remain on the field after clearing error');

      // Continue typing to simulate real user behavior
      await tester.enterText(siteNameField, 'abc');
      await tester.pump();

      // Focus should still be maintained
      expect(siteNameFocusNode.hasFocus, isTrue, reason: 'Focus should remain while continuing to type');

      // Verify the text was entered correctly
      expect(find.text('abc'), findsOneWidget);
    });

    testWidgets('should maintain focus across multiple error clearings', (tester) async {
      final controller = VooFormController(errorDisplayMode: VooFormErrorDisplayMode.onSubmit);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormScope(
              controller: controller,
              isReadOnly: false,
              isLoading: false,
              child: VooTextField(name: 'email', label: 'Email', validators: [VooValidator.required(), VooValidator.email()]),
            ),
          ),
        ),
      );

      final emailField = find.byType(TextFormField);

      // Force validation to show required error
      controller.validateAll(force: true);
      await tester.pump();

      // Focus the field
      await tester.tap(emailField);
      await tester.pump();

      final FocusNode emailFocusNode = controller.getFocusNode('email');
      expect(emailFocusNode.hasFocus, isTrue);

      // Type invalid email (clears required but shows email error)
      await tester.enterText(emailField, 'invalid');
      await tester.pump();

      // Focus should be maintained even though error changed
      expect(emailFocusNode.hasFocus, isTrue, reason: 'Focus should remain when error changes from required to email format');

      // Continue typing to make it valid
      await tester.enterText(emailField, 'invalid@example.com');
      await tester.pump();

      // Focus should still be maintained
      expect(emailFocusNode.hasFocus, isTrue, reason: 'Focus should remain when all errors are cleared');
    });

    testWidgets('should handle rapid typing without losing focus', (tester) async {
      final controller = VooFormController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormScope(
              controller: controller,
              isReadOnly: false,
              isLoading: false,
              child: VooTextField(name: 'username', label: 'Username', validators: [VooValidator.required(), VooValidator.minLength(5)]),
            ),
          ),
        ),
      );

      final usernameField = find.byType(TextFormField);

      // Focus the field
      await tester.tap(usernameField);
      await tester.pump();

      final FocusNode focusNode = controller.getFocusNode('username');

      // Simulate rapid typing
      final testStrings = ['a', 'ab', 'abc', 'abcd', 'abcde', 'abcdef'];

      for (final text in testStrings) {
        await tester.enterText(usernameField, text);
        // Don't pump between rapid keystrokes to simulate fast typing

        // Focus should be maintained throughout
        expect(focusNode.hasFocus, isTrue, reason: 'Focus lost after typing "$text"');
      }

      // Final pump to process all changes
      await tester.pump();

      // Focus should still be there
      expect(focusNode.hasFocus, isTrue, reason: 'Focus lost after rapid typing sequence');
    });

    testWidgets('focus node should be stable across rebuilds', (tester) async {
      final controller = VooFormController(errorDisplayMode: VooFormErrorDisplayMode.onSubmit);

      FocusNode? firstFocusNode;
      FocusNode? secondFocusNode;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormScope(
              controller: controller,
              isReadOnly: false,
              isLoading: false,
              child: VooTextField(name: 'testField', label: 'Test Field', validators: [VooValidator.required()]),
            ),
          ),
        ),
      );

      // Get initial focus node
      firstFocusNode = controller.getFocusNode('testField');

      // Focus the field
      await tester.tap(find.byType(TextFormField));
      await tester.pump();
      expect(firstFocusNode.hasFocus, isTrue);

      // Force validation (causes rebuild)
      controller.validateAll(force: true);
      await tester.pump();

      // Get focus node after rebuild
      secondFocusNode = controller.getFocusNode('testField');

      // Focus nodes should be the same instance
      expect(identical(firstFocusNode, secondFocusNode), isTrue, reason: 'Focus node should be stable across rebuilds');

      // And focus should be maintained
      expect(secondFocusNode.hasFocus, isTrue, reason: 'Focus should be maintained after validation rebuild');

      // Clear error by typing
      await tester.enterText(find.byType(TextFormField), 'test');
      await tester.pump();

      // Focus node should still be the same and focused
      final thirdFocusNode = controller.getFocusNode('testField');
      expect(identical(firstFocusNode, thirdFocusNode), isTrue, reason: 'Focus node should remain stable after clearing error');
      expect(thirdFocusNode.hasFocus, isTrue, reason: 'Focus should be maintained after clearing error');
    });
  });
}
