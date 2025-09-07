import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_read_only_field.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('VooCurrencyField', () {
    Widget buildTestWidget(Widget child) {
      return MaterialApp(
        home: Scaffold(
          body: child,
        ),
      );
    }

    testWidgets('formats currency correctly when typing 88', (tester) async {
      // Build the widget
      await tester.pumpWidget(
        buildTestWidget(
          VooCurrencyField(
            name: 'amount',
            label: 'Amount',
          ),
        ),
      );

      // Find the text field
      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);

      // Type "8"
      await tester.enterText(textField, '8');
      await tester.pump();
      
      // Should show $0.08
      expect(find.text('\$0.08'), findsOneWidget);

      // Type "88" (replacing the text)
      await tester.enterText(textField, '88');
      await tester.pump();
      
      // Should show $0.88
      expect(find.text('\$0.88'), findsOneWidget);
    });

    testWidgets('formats large amounts with thousand separators', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VooCurrencyField(
            name: 'amount',
            label: 'Amount',
          ),
        ),
      );

      final textField = find.byType(TextFormField);
      
      // Type "123456"
      await tester.enterText(textField, '123456');
      await tester.pump();
      
      // Should show $1,234.56
      expect(find.text('\$1,234.56'), findsOneWidget);
    });

    testWidgets('handles different currency symbols', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VooCurrencyField(
            name: 'amount',
            label: 'Amount',
            currencySymbol: '€',
            locale: 'de_DE',
          ),
        ),
      );

      final textField = find.byType(TextFormField);
      
      // Type "99"
      await tester.enterText(textField, '99');
      await tester.pump();
      
      // Should show formatted with Euro symbol
      // Note: EUR formatter puts symbol after amount
      expect(find.textContaining('0,99'), findsOneWidget);
      expect(find.textContaining('€'), findsOneWidget);
    });

    testWidgets('validates min and max values', (tester) async {
      double? currentValue;
      
      await tester.pumpWidget(
        buildTestWidget(
          VooCurrencyField(
            name: 'amount',
            label: 'Amount',
            min: 10.0,
            max: 100.0,
            onChanged: (value) => currentValue = value,
          ),
        ),
      );

      final textField = find.byType(TextFormField);
      
      // Type a value below minimum (5.00)
      await tester.enterText(textField, '500');
      await tester.pump();
      
      expect(currentValue, 5.0);
      
      // Validation should fail for value below min
      final field = tester.widget<VooCurrencyField>(find.byType(VooCurrencyField));
      expect(field.validate(5.0), contains('must be at least'));
      
      // Type a value above maximum (150.00)
      await tester.enterText(textField, '15000');
      await tester.pump();
      
      expect(currentValue, 150.0);
      
      // Validation should fail for value above max
      expect(field.validate(150.0), contains('must be at most'));
      
      // Type a valid value (50.00)
      await tester.enterText(textField, '5000');
      await tester.pump();
      
      expect(currentValue, 50.0);
      expect(field.validate(50.0), isNull);
    });

    testWidgets('handles onChanged callback', (tester) async {
      double? lastValue;
      
      await tester.pumpWidget(
        buildTestWidget(
          VooCurrencyField(
            name: 'amount',
            label: 'Amount',
            onChanged: (value) => lastValue = value,
          ),
        ),
      );

      final textField = find.byType(TextFormField);
      
      // Type "123"
      await tester.enterText(textField, '123');
      await tester.pump();
      
      // Should receive 1.23 as the value
      expect(lastValue, 1.23);
    });

    testWidgets('displays initial value correctly', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VooCurrencyField(
            name: 'amount',
            label: 'Amount',
            initialValue: 42.50,
          ),
        ),
      );

      // Should display the formatted initial value
      expect(find.text('\$42.50'), findsOneWidget);
    });

    testWidgets('handles read-only mode', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VooCurrencyField(
            name: 'amount',
            label: 'Amount',
            initialValue: 99.99,
            readOnly: true,
          ),
        ),
      );

      // Should show read-only field with formatted value
      expect(find.byType(VooReadOnlyField), findsOneWidget);
      expect(find.text('\$99.99'), findsOneWidget);
      
      // Should not have an editable text field
      expect(find.byType(TextFormField), findsNothing);
    });

    testWidgets('handles JPY currency with no decimal places', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VooCurrencyField(
            name: 'amount',
            label: 'Amount',
            currencySymbol: '¥',
            decimalDigits: 0,
            locale: 'ja_JP',
          ),
        ),
      );

      final textField = find.byType(TextFormField);
      
      // Type "1234"
      await tester.enterText(textField, '1234');
      await tester.pump();
      
      // Should show ¥1,234 (no decimal places)
      expect(find.textContaining('1,234'), findsOneWidget);
      expect(find.textContaining('¥'), findsOneWidget);
    });
  });
}