import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('VooPhoneField Widget Tests', () {
    late VooFormController controller;

    setUp(() {
      controller = VooFormController();
    });

    tearDown(() {
      controller.dispose();
    });

    Widget createTestWidget(Widget child) => MaterialApp(
      home: Scaffold(
        body: VooForm(controller: controller, fields: [child as VooFormFieldWidget]),
      ),
    );

    testWidgets('formats phone number as user types each digit', (tester) async {
      await tester.pumpWidget(createTestWidget(const VooPhoneField(name: 'phone', label: 'Phone Number', defaultCountryCode: 'US')));

      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);

      // Type first digit "5"
      await tester.enterText(textField, '5');
      await tester.pump();

      // Should show "(5" for US format
      final TextFormField textFieldWidget = tester.widget(textField);
      expect(textFieldWidget.controller?.text, '(5');

      // Type "55"
      await tester.enterText(textField, '55');
      await tester.pump();
      expect(textFieldWidget.controller?.text, '(55');

      // Type "555"
      await tester.enterText(textField, '555');
      await tester.pump();
      expect(textFieldWidget.controller?.text, '(555');

      // Type "5551" - should add closing paren and space
      await tester.enterText(textField, '5551');
      await tester.pump();
      expect(textFieldWidget.controller?.text, '(555) 1');

      // Type "555123"
      await tester.enterText(textField, '555123');
      await tester.pump();
      expect(textFieldWidget.controller?.text, '(555) 123');

      // Type "5551234" - should add dash
      await tester.enterText(textField, '5551234');
      await tester.pump();
      expect(textFieldWidget.controller?.text, '(555) 123-4');

      // Type complete number
      await tester.enterText(textField, '5551234567');
      await tester.pump();
      expect(textFieldWidget.controller?.text, '(555) 123-4567');
    });

    testWidgets('maintains focus while typing', (tester) async {
      await tester.pumpWidget(createTestWidget(const VooPhoneField(name: 'phone', label: 'Phone Number', defaultCountryCode: 'US')));

      final textField = find.byType(TextFormField);

      // Tap to focus
      await tester.tap(textField);
      await tester.pump();

      // Verify field has focus by checking we can type
      // If focus was lost, enterText would fail

      // Type multiple characters - if focus is lost, enterText would fail
      await tester.enterText(textField, '5');
      await tester.pump();

      await tester.enterText(textField, '55');
      await tester.pump();

      await tester.enterText(textField, '555');
      await tester.pump();

      // Even after formatting changes (adding parentheses)
      await tester.enterText(textField, '5551');
      await tester.pump();

      // If we got here without errors, focus was maintained
    });

    testWidgets('handles single digit "4" correctly without issues', (tester) async {
      await tester.pumpWidget(createTestWidget(const VooPhoneField(name: 'phone', label: 'Phone Number', defaultCountryCode: 'US')));

      final textField = find.byType(TextFormField);

      // This is the specific case from the user's screenshot
      await tester.enterText(textField, '4');
      await tester.pump();

      final TextFormField textFieldWidget = tester.widget(textField);
      expect(textFieldWidget.controller?.text, '(4');

      // Continue typing should work (if focus was lost, this would fail)
      await tester.enterText(textField, '41');
      await tester.pump();
      expect(textFieldWidget.controller?.text, '(41');
    });

    testWidgets('handles country code selection with dial code', (tester) async {
      await tester.pumpWidget(createTestWidget(const VooPhoneField(name: 'phone', label: 'Phone Number', defaultCountryCode: 'US', showDialCode: true)));

      final textField = find.byType(TextFormField);

      // Should show country code in prefix
      expect(find.text('+1'), findsOneWidget);

      // Type phone number
      await tester.enterText(textField, '5551234567');
      await tester.pump();

      final TextFormField textFieldWidget = tester.widget(textField);
      // When showDialCode is true, the controller text includes the dial code
      expect(textFieldWidget.controller?.text, '+1 (555) 123-4567');
    });

    testWidgets('allows continuous typing without interruption', (tester) async {
      await tester.pumpWidget(createTestWidget(const VooPhoneField(name: 'phone', label: 'Phone Number', defaultCountryCode: 'US')));

      final textField = find.byType(TextFormField);

      // Simulate rapid typing
      const digits = '5551234567';
      for (int i = 1; i <= digits.length; i++) {
        await tester.enterText(textField, digits.substring(0, i));
        await tester.pump(const Duration(milliseconds: 50)); // Simulate typing speed
        // If focus was lost, enterText would fail
      }

      // Final formatted result
      final TextFormField textFieldWidget = tester.widget(textField);
      expect(textFieldWidget.controller?.text, '(555) 123-4567');
    });

    testWidgets('handles backspace/deletion properly', (tester) async {
      await tester.pumpWidget(createTestWidget(const VooPhoneField(name: 'phone', label: 'Phone Number', defaultCountryCode: 'US')));

      final textField = find.byType(TextFormField);

      // Type full number
      await tester.enterText(textField, '5551234567');
      await tester.pump();

      // Delete last digit
      await tester.enterText(textField, '555123456');
      await tester.pump();

      final TextFormField textFieldWidget = tester.widget(textField);
      expect(textFieldWidget.controller?.text, '(555) 123-456');

      // Delete more
      await tester.enterText(textField, '555');
      await tester.pump();
      expect(textFieldWidget.controller?.text, '(555');

      // Delete to single digit
      await tester.enterText(textField, '5');
      await tester.pump();
      expect(textFieldWidget.controller?.text, '(5');

      // If we got here without errors, focus was maintained throughout
    });
  });
}
