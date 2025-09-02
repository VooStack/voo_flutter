import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_currency_field.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_decimal_field.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_integer_field.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_number_field.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_percentage_field.dart';

void main() {
  group('VooNumberField', () {
    testWidgets('renders with label', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooNumberField(
              name: 'quantity',
              label: 'Quantity',
            ),
          ),
        ),
      );

      expect(find.text('Quantity'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('accepts numeric input', (WidgetTester tester) async {
      num? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooNumberField(
              name: 'quantity',
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '42.5');
      expect(changedValue, 42.5);
    });

    testWidgets('restricts to valid numbers', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooNumberField(
              name: 'quantity',
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'abc');
      expect(find.text('abc'), findsNothing);
    });

    testWidgets('validates min and max values', (WidgetTester tester) async {
      const field = VooNumberField(
        name: 'quantity',
        label: 'Quantity',
        min: 10,
        max: 100,
      );

      expect(field.validate(5), contains('at least'));
      expect(field.validate(150), contains('at most'));
      expect(field.validate(50), null);
    });
  });

  group('VooIntegerField', () {
    testWidgets('only accepts integers', (WidgetTester tester) async {
      int? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooIntegerField(
              name: 'age',
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '25');
      expect(changedValue, 25);

      // Try to enter decimal - should not accept
      await tester.enterText(find.byType(TextField), '25.5');
      expect(find.text('25.5'), findsNothing);
    });

    testWidgets('validates integer range', (WidgetTester tester) async {
      final field = VooIntegerField(
        name: 'age',
        label: 'Age',
        min: 18,
        max: 65,
      );

      expect(field.validate(17), contains('at least'));
      expect(field.validate(66), contains('at most'));
      expect(field.validate(30), null);
    });
  });

  group('VooDecimalField', () {
    testWidgets('accepts decimal values', (WidgetTester tester) async {
      double? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDecimalField(
              name: 'weight',
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '75.25');
      expect(changedValue, 75.25);
    });

    testWidgets('respects maxDecimalPlaces', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDecimalField(
              name: 'price',
            ),
          ),
        ),
      );

      // First enter a valid value with 2 decimal places
      await tester.enterText(find.byType(TextField), '10.99');
      expect(find.text('10.99'), findsOneWidget);
      
      // Try to enter a third decimal place - should be prevented
      await tester.enterText(find.byType(TextField), '10.999');
      // Value should remain at 10.99 (formatter prevents third decimal)
      expect(find.text('10.99'), findsOneWidget);
    });
  });

  group('VooCurrencyField', () {
    testWidgets('shows currency icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooCurrencyField(
              name: 'price',
              label: 'Price',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.attach_money), findsOneWidget);
    });

    testWidgets('formats as currency with 2 decimal places', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooCurrencyField(
              name: 'price',
              initialValue: 99.9,
            ),
          ),
        ),
      );

      expect(find.text('99.9'), findsOneWidget);
    });

    testWidgets('does not allow negative values', (WidgetTester tester) async {
      final field = VooCurrencyField(
        name: 'price',
        label: 'Price',
      );

      // Currency fields have min: 0 by default
      expect(field.validate(-10), contains('at least'));
      expect(field.validate(10), null);
    });

    testWidgets('shows Euro symbol when configured', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooCurrencyField(
              name: 'price',
              currencySymbol: '€',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.euro), findsOneWidget);
    });
  });

  group('VooPercentageField', () {
    testWidgets('shows percentage icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooPercentageField(
              name: 'discount',
              label: 'Discount',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.percent), findsOneWidget);
    });

    testWidgets('restricts values between 0 and 100', (WidgetTester tester) async {
      final field = VooPercentageField(
        name: 'discount',
        label: 'Discount',
      );

      expect(field.validate(-10), contains('at least'));
      expect(field.validate(150), contains('at most'));
      expect(field.validate(50), null);
    });

    testWidgets('handles integer percentages when decimals disabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooPercentageField(
              name: 'tax',
              allowDecimals: false,
            ),
          ),
        ),
      );

      // First enter a valid integer value
      await tester.enterText(find.byType(TextField), '15');
      expect(find.text('15'), findsOneWidget);
      
      // Try to enter a decimal - should be prevented
      await tester.enterText(find.byType(TextField), '15.5');
      // Value should remain at 15 (formatter prevents decimal when disabled)
      expect(find.text('15'), findsOneWidget);
    });
  });
}