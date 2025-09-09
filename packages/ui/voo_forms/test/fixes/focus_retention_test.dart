import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('Focus Retention Tests', () {
    testWidgets('text field maintains focus when typing clears validation error', (tester) async {
      final controller = VooFormController(
        errorDisplayMode: VooFormErrorDisplayMode.onTyping,
      );
      
      // Register field with required validation
      controller.registerField('testField', 
        validators: [const RequiredValidation<String>()],
      );
      
      // Create a focus node to track focus state
      final focusNode = FocusNode();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormScope(
              controller: controller,
              isReadOnly: false,
              isLoading: false,
              child: VooTextField(
                name: 'testField',
                label: 'Test Field',
                focusNode: focusNode,
              ),
            ),
          ),
        ),
      );
      
      // Force validation to show error
      controller.validateField('testField', force: true);
      await tester.pump();
      
      // Verify error is shown
      expect(controller.getError('testField'), 'This field is required');
      
      // Focus the field
      await tester.tap(find.byType(TextFormField));
      await tester.pump();
      
      // Verify field has focus
      expect(focusNode.hasFocus, isTrue);
      
      // Type first character
      await tester.enterText(find.byType(TextFormField), 'a');
      await tester.pump();
      
      // CRITICAL: Field should still have focus after typing
      expect(focusNode.hasFocus, isTrue, reason: 'Field should maintain focus after typing first character');
      
      // Type more characters to verify continuous typing works
      await tester.enterText(find.byType(TextFormField), 'abc');
      await tester.pump();
      
      // Field should still have focus
      expect(focusNode.hasFocus, isTrue, reason: 'Field should maintain focus during continuous typing');
      
      // Error should be cleared
      expect(controller.getError('testField'), isNull);
    });
    
    testWidgets('currency field maintains focus when typing clears validation error', (tester) async {
      final controller = VooFormController(
        errorDisplayMode: VooFormErrorDisplayMode.onTyping,
      );
      
      // Register field with required validation
      controller.registerField('currencyField', 
        validators: [const RequiredValidation<double>()],
      );
      
      // Create a focus node to track focus state
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
              ),
            ),
          ),
        ),
      );
      
      // Force validation to show error
      controller.validateField('currencyField', force: true);
      await tester.pump();
      
      // Verify error is shown
      expect(controller.getError('currencyField'), 'This field is required');
      
      // Focus the field
      await tester.tap(find.byType(TextFormField));
      await tester.pump();
      
      // Verify field has focus
      expect(focusNode.hasFocus, isTrue);
      
      // Type first digit
      await tester.enterText(find.byType(TextFormField), '5');
      await tester.pump();
      
      // CRITICAL: Field should still have focus after typing
      expect(focusNode.hasFocus, isTrue, reason: 'Currency field should maintain focus after typing first digit');
      
      // Type more digits to verify continuous typing works
      await tester.enterText(find.byType(TextFormField), '55');
      await tester.pump();
      
      // Field should still have focus
      expect(focusNode.hasFocus, isTrue, reason: 'Currency field should maintain focus during continuous typing');
      
      // Error should be cleared
      expect(controller.getError('currencyField'), isNull);
    });
    
    testWidgets('number field maintains focus when typing clears validation error', (tester) async {
      final controller = VooFormController(
        errorDisplayMode: VooFormErrorDisplayMode.onTyping,
      );
      
      // Register field with required validation
      controller.registerField('numberField', 
        validators: [const RequiredValidation<num>()],
      );
      
      // Create a focus node to track focus state
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
              ),
            ),
          ),
        ),
      );
      
      // Force validation to show error
      controller.validateField('numberField', force: true);
      await tester.pump();
      
      // Verify error is shown
      expect(controller.getError('numberField'), 'This field is required');
      
      // Focus the field
      await tester.tap(find.byType(TextFormField));
      await tester.pump();
      
      // Verify field has focus
      expect(focusNode.hasFocus, isTrue);
      
      // Type first digit
      await tester.enterText(find.byType(TextFormField), '1');
      await tester.pump();
      
      // CRITICAL: Field should still have focus after typing
      expect(focusNode.hasFocus, isTrue, reason: 'Number field should maintain focus after typing first digit');
      
      // Type more digits to verify continuous typing works
      await tester.enterText(find.byType(TextFormField), '123');
      await tester.pump();
      
      // Field should still have focus
      expect(focusNode.hasFocus, isTrue, reason: 'Number field should maintain focus during continuous typing');
      
      // Error should be cleared
      expect(controller.getError('numberField'), isNull);
    });
    
    testWidgets('multiple fields maintain focus independently', (tester) async {
      final controller = VooFormController(
        errorDisplayMode: VooFormErrorDisplayMode.onTyping,
      );
      
      // Register fields with required validation
      controller.registerField('field1', 
        validators: [const RequiredValidation<String>()],
      );
      controller.registerField('field2', 
        validators: [const RequiredValidation<String>()],
      );
      
      // Create focus nodes to track focus state
      final focusNode1 = FocusNode();
      final focusNode2 = FocusNode();
      
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
                  ),
                  VooTextField(
                    name: 'field2',
                    label: 'Field 2',
                    focusNode: focusNode2,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      
      // Force validation to show errors on both fields
      controller.validateField('field1', force: true);
      controller.validateField('field2', force: true);
      await tester.pump();
      
      // Verify errors are shown
      expect(controller.getError('field1'), 'This field is required');
      expect(controller.getError('field2'), 'This field is required');
      
      // Focus first field
      await tester.tap(find.byType(TextFormField).first);
      await tester.pump();
      
      // Verify first field has focus
      expect(focusNode1.hasFocus, isTrue);
      expect(focusNode2.hasFocus, isFalse);
      
      // Type in first field
      await tester.enterText(find.byType(TextFormField).first, 'test1');
      await tester.pump();
      
      // First field should still have focus
      expect(focusNode1.hasFocus, isTrue, reason: 'First field should maintain focus after typing');
      expect(focusNode2.hasFocus, isFalse);
      
      // Focus second field
      await tester.tap(find.byType(TextFormField).last);
      await tester.pump();
      
      // Verify second field has focus
      expect(focusNode1.hasFocus, isFalse);
      expect(focusNode2.hasFocus, isTrue);
      
      // Type in second field
      await tester.enterText(find.byType(TextFormField).last, 'test2');
      await tester.pump();
      
      // Second field should still have focus
      expect(focusNode1.hasFocus, isFalse);
      expect(focusNode2.hasFocus, isTrue, reason: 'Second field should maintain focus after typing');
      
      // Both errors should be cleared
      expect(controller.getError('field1'), isNull);
      expect(controller.getError('field2'), isNull);
    });
    
    testWidgets('focus is maintained when validation mode is onChange', (tester) async {
      final controller = VooFormController(
        errorDisplayMode: VooFormErrorDisplayMode.onSubmit,
        validationMode: FormValidationMode.onChange,
      );
      
      // Create a focus node to track focus state
      final focusNode = FocusNode();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              controller: controller,
              fields: [
                VooTextField(
                  name: 'testField',
                  label: 'Test Field',
                  focusNode: focusNode,
                  validators: [const RequiredValidation<String>()],
                ),
              ],
            ),
          ),
        ),
      );
      
      // Submit form to trigger error display
      await controller.submit(onSubmit: (_) async {});
      await tester.pump();
      
      // Verify error is shown
      expect(controller.getError('testField'), 'This field is required');
      
      // Focus the field
      await tester.tap(find.byType(TextFormField));
      await tester.pump();
      
      // Verify field has focus
      expect(focusNode.hasFocus, isTrue);
      
      // Type first character - set controller text directly
      final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      textField.controller?.text = 'a';
      
      // Since onChange validation is enabled, we need to trigger the validation
      // Setting controller text doesn't trigger onChange, so manually set the value
      controller.setValue('testField', 'a');
      await tester.pump();
      
      // CRITICAL: Field should still have focus even with onChange validation
      expect(focusNode.hasFocus, isTrue, reason: 'Field should maintain focus with onChange validation mode');
      
      // Wait for validation to complete
      await tester.pump(const Duration(milliseconds: 100));
      
      // Error should be cleared since we have a value now
      expect(controller.getError('testField'), isNull);
    });
  });
}