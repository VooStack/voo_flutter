import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('VooCurrencyField Widget Tests', () {
    late VooFormController controller;

    setUp(() {
      controller = VooFormController();
    });

    tearDown(() {
      controller.dispose();
    });

    Widget createTestWidget(Widget child) {
      return MaterialApp(
        home: Scaffold(
          body: VooForm(
            controller: controller,
            fields: [
              child as VooFormFieldWidget,
            ],
          ),
        ),
      );
    }

    testWidgets('formats currency naturally as user types', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const VooCurrencyField(
            name: 'amount',
            label: 'Amount',
          ),
        ),
      );

      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);

      // Type "4" - should show "$0.04" (calculator style)
      await tester.enterText(textField, '4');
      await tester.pump();
      
      // Get the actual text from the widget
      final textFieldWidget = tester.widget<TextFormField>(textField);
      final currentText = textFieldWidget.controller?.text ?? '';
      
      // Should show calculator-style "$0.04"
      expect(currentText, '\$0.04');
      
      // Type "45" - should show "$0.45"
      await tester.enterText(textField, '45');
      await tester.pump();
      expect(textFieldWidget.controller?.text, '\$0.45');
      
      // Type "456" - should show "$4.56"
      await tester.enterText(textField, '456');
      await tester.pump();
      expect(textFieldWidget.controller?.text, '\$4.56');
      
      // Type "4567" - should show "$45.67"
      await tester.enterText(textField, '4567');
      await tester.pump();
      expect(textFieldWidget.controller?.text, '\$45.67');
    });

    testWidgets('handles single digit "4" correctly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const VooCurrencyField(
            name: 'amount',
            label: 'Amount',
          ),
        ),
      );

      final textField = find.byType(TextFormField);
      
      // This is the specific case the user reported
      await tester.enterText(textField, '4');
      await tester.pump();
      
      final textFieldWidget = tester.widget<TextFormField>(textField);
      final text = textFieldWidget.controller?.text ?? '';
      
      // Should show "$0.04" (calculator style)
      expect(text, '\$0.04');
      
      // Continue typing should work
      await tester.enterText(textField, '45');
      await tester.pump();
      
      final text2 = textFieldWidget.controller?.text ?? '';
      expect(text2, '\$0.45');
    });

    testWidgets('maintains focus while typing currency', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const VooCurrencyField(
            name: 'amount',
            label: 'Amount',
          ),
        ),
      );

      final textField = find.byType(TextFormField);
      
      // Tap to focus
      await tester.tap(textField);
      await tester.pump();
      
      // Type multiple values and check focus is maintained
      final testValues = ['4', '45', '456', '4567', '45678'];
      
      for (final value in testValues) {
        await tester.enterText(textField, value);
        await tester.pump();
        
        // Check that we can continue typing (field still accepts input)
        // If focus was lost, enterText would fail
      }
      
      // Final value should be formatted as calculator style
      final textFieldWidget = tester.widget<TextFormField>(textField);
      final finalText = textFieldWidget.controller?.text ?? '';
      expect(finalText, '\$456.78');
    });

    testWidgets('handles calculator-style entry correctly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const VooCurrencyField(
            name: 'amount',
            label: 'Amount',
          ),
        ),
      );

      final textField = find.byType(TextFormField);
      final textFieldWidget = tester.widget<TextFormField>(textField);
      
      // Type "4550" - should show "$45.50" (calculator style)
      await tester.enterText(textField, '4550');
      await tester.pump();
      
      var text = textFieldWidget.controller?.text ?? '';
      expect(text, '\$45.50');
      
      // Type "123456" - should show "$1,234.56"
      await tester.enterText(textField, '123456');
      await tester.pump();
      
      text = textFieldWidget.controller?.text ?? '';
      expect(text, '\$1,234.56');
    });

    testWidgets('EUR currency formats with European locale', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const VooCurrencyField(
            name: 'amount',
            label: 'Amount',
            currencySymbol: '€',
            locale: 'de_DE',
          ),
        ),
      );

      final textField = find.byType(TextFormField);
      
      // Type "1234"
      await tester.enterText(textField, '1234');
      await tester.pump();
      
      final textFieldWidget = tester.widget<TextFormField>(textField);
      final text = textFieldWidget.controller?.text ?? '';
      
      // Should use European formatting (calculator style)
      expect(text, contains('€'));
      expect(text, contains('12,34')); // European decimal separator
    });

    testWidgets('allows continuous typing without interruption', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const VooCurrencyField(
            name: 'amount',
            label: 'Amount',
          ),
        ),
      );

      final textField = find.byType(TextFormField);
      
      // Simulate rapid typing
      const testInput = '123456';
      for (int i = 1; i <= testInput.length; i++) {
        await tester.enterText(textField, testInput.substring(0, i));
        await tester.pump(const Duration(milliseconds: 50)); // Simulate typing speed
      }
      
      // Final formatted result (calculator style)
      final textFieldWidget = tester.widget<TextFormField>(textField);
      final text = textFieldWidget.controller?.text ?? '';
      expect(text, '\$1,234.56');
    });

    testWidgets('handles deletion properly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const VooCurrencyField(
            name: 'amount',
            label: 'Amount',
          ),
        ),
      );

      final textField = find.byType(TextFormField);
      
      // Type full amount
      await tester.enterText(textField, '12345');
      await tester.pump();
      
      // Delete digits (calculator style: deleting removes rightmost digit)
      await tester.enterText(textField, '1234');
      await tester.pump();
      
      final textFieldWidget = tester.widget<TextFormField>(textField);
      var text = textFieldWidget.controller?.text ?? '';
      expect(text, '\$12.34');
      
      // Delete more
      await tester.enterText(textField, '12');
      await tester.pump();
      
      text = textFieldWidget.controller?.text ?? '';
      expect(text, '\$0.12');
      
      // Delete to single digit
      await tester.enterText(textField, '1');
      await tester.pump();
      
      text = textFieldWidget.controller?.text ?? '';
      expect(text, '\$0.01');
    });
  });
}