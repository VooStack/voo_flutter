import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('Focus Retention Tests - All Field Types', () {
    testWidgets('VooTextField maintains focus when typing with error', (tester) async {
      final controller = VooFormController();
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormScope(
              controller: controller,
              isReadOnly: false,
              isLoading: false,
              child: VooTextField(
                name: 'textField',
                label: 'Text Field',
                focusNode: focusNode,
                validators: const [RequiredValidation<String>()],
              ),
            ),
          ),
        ),
      );

      controller.registerField('textField', validators: [const RequiredValidation<String>()]);
      controller.validateField('textField', force: true);
      await tester.pump();

      // Focus and type
      await tester.tap(find.byType(TextFormField));
      await tester.pump();
      expect(focusNode.hasFocus, isTrue, reason: 'VooTextField should have focus');

      await tester.enterText(find.byType(TextFormField), 'test');
      await tester.pump();
      expect(focusNode.hasFocus, isTrue, reason: 'VooTextField should maintain focus after typing');
    });

    testWidgets('VooCurrencyField maintains focus when typing with error', (tester) async {
      final controller = VooFormController();
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormScope(
              controller: controller,
              isReadOnly: false,
              isLoading: false,
              child: VooCurrencyField(
                name: 'currencyField',
                label: 'Currency',
                focusNode: focusNode,
                validators: const [RequiredValidation<double>()],
              ),
            ),
          ),
        ),
      );

      controller.registerField('currencyField', validators: [const RequiredValidation<double>()]);
      controller.validateField('currencyField', force: true);
      await tester.pump();

      // Focus and type
      await tester.tap(find.byType(TextFormField));
      await tester.pump();
      expect(focusNode.hasFocus, isTrue, reason: 'VooCurrencyField should have focus');

      await tester.enterText(find.byType(TextFormField), '123');
      await tester.pump();
      expect(focusNode.hasFocus, isTrue, reason: 'VooCurrencyField should maintain focus after typing');
    });

    testWidgets('VooNumberField maintains focus when typing with error', (tester) async {
      final controller = VooFormController();
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormScope(
              controller: controller,
              isReadOnly: false,
              isLoading: false,
              child: VooNumberField(
                name: 'numberField',
                label: 'Number',
                focusNode: focusNode,
                validators: const [RequiredValidation<num>()],
              ),
            ),
          ),
        ),
      );

      controller.registerField('numberField', validators: [const RequiredValidation<num>()]);
      controller.validateField('numberField', force: true);
      await tester.pump();

      // Focus and type
      await tester.tap(find.byType(TextFormField));
      await tester.pump();
      expect(focusNode.hasFocus, isTrue, reason: 'VooNumberField should have focus');

      await tester.enterText(find.byType(TextFormField), '456');
      await tester.pump();
      expect(focusNode.hasFocus, isTrue, reason: 'VooNumberField should maintain focus after typing');
    });

    testWidgets('VooEmailField maintains focus when typing with error', (tester) async {
      final controller = VooFormController();
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormScope(
              controller: controller,
              isReadOnly: false,
              isLoading: false,
              child: VooEmailField(
                name: 'emailField',
                label: 'Email',
                focusNode: focusNode,
                validators: const [RequiredValidation<String>()],
              ),
            ),
          ),
        ),
      );

      controller.registerField('emailField', validators: [const RequiredValidation<String>()]);
      controller.validateField('emailField', force: true);
      await tester.pump();

      // Focus and type
      await tester.tap(find.byType(TextFormField));
      await tester.pump();
      expect(focusNode.hasFocus, isTrue, reason: 'VooEmailField should have focus');

      await tester.enterText(find.byType(TextFormField), 'test@');
      await tester.pump();
      expect(focusNode.hasFocus, isTrue, reason: 'VooEmailField should maintain focus after typing');
    });

    testWidgets('VooPasswordField maintains focus when typing with error', (tester) async {
      final controller = VooFormController();
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormScope(
              controller: controller,
              isReadOnly: false,
              isLoading: false,
              child: VooPasswordField(
                name: 'passwordField',
                label: 'Password',
                focusNode: focusNode,
                validators: const [RequiredValidation<String>()],
              ),
            ),
          ),
        ),
      );

      controller.registerField('passwordField', validators: [const RequiredValidation<String>()]);
      controller.validateField('passwordField', force: true);
      await tester.pump();

      // Focus and type
      await tester.tap(find.byType(TextFormField));
      await tester.pump();
      expect(focusNode.hasFocus, isTrue, reason: 'VooPasswordField should have focus');

      await tester.enterText(find.byType(TextFormField), 'pass');
      await tester.pump();
      expect(focusNode.hasFocus, isTrue, reason: 'VooPasswordField should maintain focus after typing');
    });

    testWidgets('VooPhoneField maintains focus when typing with error', (tester) async {
      final controller = VooFormController();
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormScope(
              controller: controller,
              isReadOnly: false,
              isLoading: false,
              child: VooPhoneField(
                name: 'phoneField',
                label: 'Phone',
                focusNode: focusNode,
                validators: const [RequiredValidation<String>()],
              ),
            ),
          ),
        ),
      );

      controller.registerField('phoneField', validators: [const RequiredValidation<String>()]);
      controller.validateField('phoneField', force: true);
      await tester.pump();

      // Focus and type
      await tester.tap(find.byType(TextFormField));
      await tester.pump();
      expect(focusNode.hasFocus, isTrue, reason: 'VooPhoneField should have focus');

      await tester.enterText(find.byType(TextFormField), '555');
      await tester.pump();
      expect(focusNode.hasFocus, isTrue, reason: 'VooPhoneField should maintain focus after typing');
    });

    testWidgets('VooMultilineField maintains focus when typing with error', (tester) async {
      final controller = VooFormController();
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormScope(
              controller: controller,
              isReadOnly: false,
              isLoading: false,
              child: VooMultilineField(
                name: 'multilineField',
                label: 'Description',
                focusNode: focusNode,
                validators: const [RequiredValidation<String>()],
              ),
            ),
          ),
        ),
      );

      controller.registerField('multilineField', validators: [const RequiredValidation<String>()]);
      controller.validateField('multilineField', force: true);
      await tester.pump();

      // Focus and type
      await tester.tap(find.byType(TextFormField));
      await tester.pump();
      expect(focusNode.hasFocus, isTrue, reason: 'VooMultilineField should have focus');

      await tester.enterText(find.byType(TextFormField), 'Line 1');
      await tester.pump();
      expect(focusNode.hasFocus, isTrue, reason: 'VooMultilineField should maintain focus after typing');
    });

    testWidgets('VooIntegerField maintains focus when typing with error', (tester) async {
      final controller = VooFormController();
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormScope(
              controller: controller,
              isReadOnly: false,
              isLoading: false,
              child: VooIntegerField(
                name: 'integerField',
                label: 'Integer',
                focusNode: focusNode,
                validators: const [RequiredValidation<num>()],
              ),
            ),
          ),
        ),
      );

      controller.registerField('integerField', validators: [const RequiredValidation<num>()]);
      controller.validateField('integerField', force: true);
      await tester.pump();

      // Focus and type
      await tester.tap(find.byType(TextFormField));
      await tester.pump();
      expect(focusNode.hasFocus, isTrue, reason: 'VooIntegerField should have focus');

      await tester.enterText(find.byType(TextFormField), '789');
      await tester.pump();
      expect(focusNode.hasFocus, isTrue, reason: 'VooIntegerField should maintain focus after typing');
    });

    testWidgets('VooDecimalField maintains focus when typing with error', (tester) async {
      final controller = VooFormController();
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormScope(
              controller: controller,
              isReadOnly: false,
              isLoading: false,
              child: VooDecimalField(
                name: 'decimalField',
                label: 'Decimal',
                focusNode: focusNode,
                validators: const [RequiredValidation<num>()],
              ),
            ),
          ),
        ),
      );

      controller.registerField('decimalField', validators: [const RequiredValidation<num>()]);
      controller.validateField('decimalField', force: true);
      await tester.pump();

      // Focus and type
      await tester.tap(find.byType(TextFormField));
      await tester.pump();
      expect(focusNode.hasFocus, isTrue, reason: 'VooDecimalField should have focus');

      await tester.enterText(find.byType(TextFormField), '3.14');
      await tester.pump();
      expect(focusNode.hasFocus, isTrue, reason: 'VooDecimalField should maintain focus after typing');
    });

    testWidgets('VooPercentageField maintains focus when typing with error', (tester) async {
      final controller = VooFormController();
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormScope(
              controller: controller,
              isReadOnly: false,
              isLoading: false,
              child: VooPercentageField(
                name: 'percentageField',
                label: 'Percentage',
                focusNode: focusNode,
                validators: const [RequiredValidation<num>()],
              ),
            ),
          ),
        ),
      );

      controller.registerField('percentageField', validators: [const RequiredValidation<num>()]);
      controller.validateField('percentageField', force: true);
      await tester.pump();

      // Focus and type
      await tester.tap(find.byType(TextFormField));
      await tester.pump();
      expect(focusNode.hasFocus, isTrue, reason: 'VooPercentageField should have focus');

      await tester.enterText(find.byType(TextFormField), '75');
      await tester.pump();
      expect(focusNode.hasFocus, isTrue, reason: 'VooPercentageField should maintain focus after typing');
    });

    group('Error clearing tests', () {
      testWidgets('VooTextField clears error when valid value is entered', (tester) async {
        final controller = VooFormController();
        final focusNode = FocusNode();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VooFormScope(
                controller: controller,
                isReadOnly: false,
                isLoading: false,
                child: VooTextField(
                  name: 'textField',
                  label: 'Text Field',
                  focusNode: focusNode,
                  validators: const [RequiredValidation<String>()],
                ),
              ),
            ),
          ),
        );

        controller.registerField('textField', validators: [const RequiredValidation<String>()]);
        controller.validateField('textField', force: true);
        await tester.pump();

        // Verify error is shown
        expect(controller.hasError('textField'), isTrue);

        // Focus and type
        await tester.tap(find.byType(TextFormField));
        await tester.pump();

        await tester.enterText(find.byType(TextFormField), 'valid text');
        await tester.pump();

        // Error should be cleared and focus maintained
        expect(controller.hasError('textField'), isFalse);
        expect(focusNode.hasFocus, isTrue);
      });

      testWidgets('VooCurrencyField clears error when valid value is entered', (tester) async {
        final controller = VooFormController();
        final focusNode = FocusNode();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VooFormScope(
                controller: controller,
                isReadOnly: false,
                isLoading: false,
                child: VooCurrencyField(
                  name: 'currencyField',
                  label: 'Amount',
                  focusNode: focusNode,
                  validators: const [RequiredValidation<double>()],
                ),
              ),
            ),
          ),
        );

        controller.registerField('currencyField', validators: [const RequiredValidation<double>()]);
        controller.validateField('currencyField', force: true);
        await tester.pump();

        // Verify error is shown
        expect(controller.hasError('currencyField'), isTrue);

        // Focus and type
        await tester.tap(find.byType(TextFormField));
        await tester.pump();

        await tester.enterText(find.byType(TextFormField), '100');
        await tester.pump();

        // Error should be cleared and focus maintained
        expect(controller.hasError('currencyField'), isFalse);
        expect(focusNode.hasFocus, isTrue);
      });
    });

    group('Multiple field interaction tests', () {
      testWidgets('Focus moves correctly between fields without losing keyboard', (tester) async {
        final controller = VooFormController();
        final focusNode1 = FocusNode();
        final focusNode2 = FocusNode();
        final focusNode3 = FocusNode();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VooFormScope(
                controller: controller,
                isReadOnly: false,
                isLoading: false,
                child: Column(
                  children: [
                    VooTextField(
                      name: 'field1',
                      label: 'Field 1',
                      focusNode: focusNode1,
                      validators: const [RequiredValidation<String>()],
                    ),
                    VooEmailField(
                      name: 'field2',
                      label: 'Field 2',
                      focusNode: focusNode2,
                      validators: const [RequiredValidation<String>()],
                    ),
                    VooNumberField(
                      name: 'field3',
                      label: 'Field 3',
                      focusNode: focusNode3,
                      validators: const [RequiredValidation<num>()],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        // Register all fields
        controller.registerField('field1', validators: [const RequiredValidation<String>()]);
        controller.registerField('field2', validators: [const RequiredValidation<String>()]);
        controller.registerField('field3', validators: [const RequiredValidation<num>()]);

        // Force errors on all fields
        controller.validateField('field1', force: true);
        controller.validateField('field2', force: true);
        controller.validateField('field3', force: true);
        await tester.pump();

        // Type in first field
        await tester.tap(find.byType(TextFormField).first);
        await tester.pump();
        expect(focusNode1.hasFocus, isTrue);

        await tester.enterText(find.byType(TextFormField).first, 'text1');
        await tester.pump();
        expect(focusNode1.hasFocus, isTrue, reason: 'First field should maintain focus');

        // Move to second field
        await tester.tap(find.byType(TextFormField).at(1));
        await tester.pump();
        expect(focusNode2.hasFocus, isTrue);

        await tester.enterText(find.byType(TextFormField).at(1), 'test@test.com');
        await tester.pump();
        expect(focusNode2.hasFocus, isTrue, reason: 'Second field should maintain focus');

        // Move to third field
        await tester.tap(find.byType(TextFormField).last);
        await tester.pump();
        expect(focusNode3.hasFocus, isTrue);

        await tester.enterText(find.byType(TextFormField).last, '123');
        await tester.pump();
        expect(focusNode3.hasFocus, isTrue, reason: 'Third field should maintain focus');
      });
    });
  });
}
