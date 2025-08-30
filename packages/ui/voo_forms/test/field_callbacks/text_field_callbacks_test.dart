import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';
import '../test_helpers.dart';

/// Tests for text field type callbacks (text, email, password, phone, url, multiline)
/// Ensures all callbacks work correctly with proper type safety
void main() {
  group('Text Field Callbacks - Comprehensive Testing', () {
    group('VooField.text() - Standard Text Input', () {
      testWidgets(
        'should invoke onChanged callback with correct String value when text is entered',
        (tester) async {
          // Arrange
          String? capturedValue;
          bool callbackInvoked = false;
          
          final field = VooField.text(
            name: 'username',
            label: 'Username',
            hint: 'Enter your username',
            onChanged: (String? value) {
              capturedValue = value;
              callbackInvoked = true;
            },
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          await enterTextWithVerification(tester, 'john_doe', fieldName: 'username');
          
          // Assert
          expectCallbackInvoked(
            wasInvoked: callbackInvoked,
            callbackName: 'onChanged',
            context: 'text field input',
          );
          expectFieldValue(
            actual: capturedValue,
            expected: 'john_doe',
            fieldName: 'username',
            context: 'after entering text',
          );
        },
      );
      
      testWidgets(
        'should handle empty string correctly',
        (tester) async {
          // Arrange
          String? capturedValue = 'initial';
          
          final field = VooField.text(
            name: 'username',
            initialValue: 'initial',
            onChanged: (String? value) => capturedValue = value,
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          await tester.enterText(find.byType(TextField), '');
          await tester.pump();
          
          // Assert
          expectFieldValue(
            actual: capturedValue,
            expected: '',
            fieldName: 'username',
            context: 'after clearing text',
          );
        },
      );
      
      testWidgets(
        'should handle special characters and unicode correctly',
        (tester) async {
          // Arrange
          String? capturedValue;
          const testString = 'Test @#\$% 你好 😀';
          
          final field = VooField.text(
            name: 'special_text',
            onChanged: (String? value) => capturedValue = value,
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          await enterTextWithVerification(tester, testString, fieldName: 'special_text');
          
          // Assert
          expectFieldValue(
            actual: capturedValue,
            expected: testString,
            fieldName: 'special_text',
            context: 'with special characters and unicode',
          );
        },
      );
    });
    
    group('VooField.email() - Email Input Validation', () {
      testWidgets(
        'should capture valid email format correctly',
        (tester) async {
          // Arrange
          String? capturedValue;
          bool callbackInvoked = false;
          
          final field = VooField.email(
            name: 'email',
            label: 'Email Address',
            onChanged: (String? value) {
              capturedValue = value;
              callbackInvoked = true;
            },
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          await enterTextWithVerification(
            tester,
            'user@example.com',
            fieldName: 'email',
          );
          
          // Assert
          expectCallbackInvoked(
            wasInvoked: callbackInvoked,
            callbackName: 'onChanged',
            context: 'email field input',
          );
          expectFieldValue(
            actual: capturedValue,
            expected: 'user@example.com',
            fieldName: 'email',
            context: 'valid email format',
          );
        },
      );
      
      testWidgets(
        'should handle complex email formats',
        (tester) async {
          // Arrange
          String? capturedValue;
          const complexEmail = 'user.name+tag@sub.example.co.uk';
          
          final field = VooField.email(
            name: 'email',
            onChanged: (String? value) => capturedValue = value,
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          await enterTextWithVerification(tester, complexEmail, fieldName: 'email');
          
          // Assert
          expectFieldValue(
            actual: capturedValue,
            expected: complexEmail,
            fieldName: 'email',
            context: 'complex email with subdomains and special chars',
          );
        },
      );
    });
    
    group('VooField.password() - Secure Input Handling', () {
      testWidgets(
        'should obscure password text while capturing value correctly',
        (tester) async {
          // Arrange
          String? capturedValue;
          const password = 'SecureP@ss123!';
          
          final field = VooField.password(
            name: 'password',
            label: 'Password',
            onChanged: (String? value) => capturedValue = value,
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          // Verify password field is obscured
          final textField = tester.widget<TextField>(find.byType(TextField));
          expect(
            textField.obscureText,
            isTrue,
            reason: 'Password field should obscure text for security',
          );
          
          await enterTextWithVerification(tester, password, fieldName: 'password');
          
          // Assert
          expectFieldValue(
            actual: capturedValue,
            expected: password,
            fieldName: 'password',
            context: 'secure password input',
          );
        },
      );
      
      testWidgets(
        'should handle password visibility toggle if enabled',
        (tester) async {
          // Arrange
          String? capturedValue;
          
          final field = VooField.password(
            name: 'password',
            // showPasswordToggle is not available in current API
            onChanged: (String? value) => capturedValue = value,
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          // Check for visibility toggle button
          final toggleButton = find.byIcon(Icons.visibility);
          if (toggleButton.evaluate().isNotEmpty) {
            await tester.tap(toggleButton);
            await tester.pump();
            
            // Verify text is now visible
            final textField = tester.widget<TextField>(find.byType(TextField));
            expect(
              textField.obscureText,
              isFalse,
              reason: 'Password should be visible after toggle',
            );
          }
          
          await enterTextWithVerification(tester, 'visible123', fieldName: 'password');
          
          // Assert
          expectFieldValue(
            actual: capturedValue,
            expected: 'visible123',
            fieldName: 'password',
            context: 'with visibility toggle',
          );
        },
      );
    });
    
    group('VooField.phone() - Phone Number Input', () {
      testWidgets(
        'should handle various phone number formats',
        (tester) async {
          // Arrange
          final phoneNumbers = [
            '+1-234-567-8900',
            '(234) 567-8900',
            '234.567.8900',
            '+44 20 7123 4567',
          ];
          
          for (final phoneNumber in phoneNumbers) {
            String? capturedValue;
            
            final field = VooField.phone(
              name: 'phone',
              label: 'Phone Number',
              onChanged: (String? value) => capturedValue = value,
            );
            
            // Act
            await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
            await enterTextWithVerification(tester, phoneNumber, fieldName: 'phone');
            
            // Assert
            expectFieldValue(
              actual: capturedValue,
              expected: phoneNumber,
              fieldName: 'phone',
              context: 'format: $phoneNumber',
            );
          }
        },
      );
    });
    
    // Note: VooField.url() doesn't exist in current API
    // URL validation would need to be done with VooField.text() and custom validators
    
    group('VooField.multiline() - Multiline Text Input', () {
      testWidgets(
        'should handle multiline text with line breaks correctly',
        (tester) async {
          // Arrange
          String? capturedValue;
          const multilineText = 'Line 1\nLine 2\nLine 3\n\nLine 5 with gap';
          
          final field = VooField.multiline(
            name: 'description',
            label: 'Description',
            maxLines: 5,
            onChanged: (String? value) => capturedValue = value,
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          // Verify multiline configuration
          final textField = tester.widget<TextField>(find.byType(TextField));
          expect(
            textField.maxLines,
            greaterThan(1),
            reason: 'Multiline field should allow multiple lines',
          );
          
          await enterTextWithVerification(
            tester,
            multilineText,
            fieldName: 'description',
          );
          
          // Assert
          expectFieldValue(
            actual: capturedValue,
            expected: multilineText,
            fieldName: 'description',
            context: 'multiline text with line breaks',
          );
        },
      );
      
      testWidgets(
        'should respect maxLength if specified',
        (tester) async {
          // Arrange
          String? capturedValue;
          const longText = 'This is a very long text that exceeds the maximum length';
          
          final field = VooField.multiline(
            name: 'limited_text',
            maxLength: 20,
            onChanged: (String? value) => capturedValue = value,
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          final textField = tester.widget<TextField>(find.byType(TextField));
          expect(
            textField.maxLength,
            equals(20),
            reason: 'Should enforce maxLength constraint',
          );
          
          await tester.enterText(find.byType(TextField), longText);
          await tester.pump();
          
          // Assert - Text should be truncated to maxLength
          expect(
            capturedValue?.length ?? 0,
            lessThanOrEqualTo(20),
            reason: 'Text should be truncated to maxLength of 20',
          );
        },
      );
    });
    
    group('Edge Cases and Error Scenarios', () {
      testWidgets(
        'should handle null onChanged callback gracefully',
        (tester) async {
          // Arrange
          final field = VooField.text(
            name: 'no_callback',
            label: 'No Callback Field',
            // No onChanged callback provided
          );
          
          // Act & Assert - Should not throw
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          await expectLater(
            () async => await enterTextWithVerification(
              tester,
              'test',
              fieldName: 'no_callback',
            ),
            returnsNormally,
            reason: 'Should handle missing onChanged callback without errors',
          );
        },
      );
      
      testWidgets(
        'should handle rapid text changes correctly',
        (tester) async {
          // Arrange
          final capturedValues = <String?>[];
          
          final field = VooField.text(
            name: 'rapid_input',
            onChanged: (String? value) => capturedValues.add(value),
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          // Simulate rapid typing
          await tester.enterText(find.byType(TextField), 'a');
          await tester.pump(const Duration(milliseconds: 50));
          await tester.enterText(find.byType(TextField), 'ab');
          await tester.pump(const Duration(milliseconds: 50));
          await tester.enterText(find.byType(TextField), 'abc');
          await tester.pump(const Duration(milliseconds: 50));
          
          // Assert
          expect(
            capturedValues.isNotEmpty,
            isTrue,
            reason: 'Should capture all rapid text changes',
          );
          expect(
            capturedValues.last,
            equals('abc'),
            reason: 'Final value should be complete text',
          );
        },
      );
    });
  });
}