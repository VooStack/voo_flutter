import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('Simplified VooForm Validation', () {
    testWidgets('validates required fields automatically', (tester) async {
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
                  validators: [VooValidator.required()],
                ),
                VooTextField(
                  name: 'email',
                  label: 'Email',
                  validators: [
                    VooValidator.required(),
                    VooValidator.email(),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      
      // Form should be invalid initially (empty required fields)
      expect(controller.isValid, false);
      
      // Enter valid username
      // Note: We need to set the controller text directly because enterText
      // doesn't work properly with controller-backed TextFormFields in tests
      final usernameField = tester.widget<TextFormField>(find.byType(TextFormField).first);
      usernameField.controller?.text = 'testuser';
      await tester.pump();
      
      // Still invalid (email is empty)
      expect(controller.isValid, false);
      
      // Enter invalid email
      final emailField = tester.widget<TextFormField>(find.byType(TextFormField).last);
      emailField.controller?.text = 'invalid-email';
      await tester.pump();
      
      // Still invalid (email format is wrong)
      expect(controller.isValid, false);
      
      // Enter valid email
      emailField.controller?.text = 'test@example.com';
      await tester.pump();
      
      // Now form should be valid
      expect(controller.isValid, true);
      
      // Validate explicitly
      final isValid = controller.validateAll();
      expect(isValid, true);
      expect(controller.errors, isEmpty);
    });
    
    testWidgets('controller syncs with field changes automatically', (tester) async {
      final controller = VooFormController();
      String? capturedValue;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              controller: controller,
              fields: [
                VooTextField(
                  name: 'test_field',
                  label: 'Test Field',
                  onChanged: (value) {
                    capturedValue = value;
                  },
                ),
              ],
            ),
          ),
        ),
      );
      
      // Enter text
      await tester.enterText(
        find.byType(TextFormField),
        'test value',
      );
      await tester.pump();
      
      // Check controller has the value
      expect(controller.getValue('test_field'), 'test value');
      
      // Check user callback was also called
      expect(capturedValue, 'test value');
    });
  });
}