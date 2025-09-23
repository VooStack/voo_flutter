import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/number_filter_field.dart';

void main() {
  group('NumberFilterField Debouncing Tests', () {
    testWidgets('should debounce number input changes by default', (WidgetTester tester) async {
      final List<num?> receivedValues = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: NumberFilterField(onChanged: receivedValues.add)),
        ),
      );

      final textField = find.byType(TextField);

      await tester.enterText(textField, '1');
      await tester.pump();
      expect(receivedValues, isEmpty);

      await tester.enterText(textField, '12');
      await tester.pump();
      expect(receivedValues, isEmpty);

      await tester.enterText(textField, '123');
      await tester.pump();
      expect(receivedValues, isEmpty);

      await tester.pump(const Duration(milliseconds: 500));
      expect(receivedValues, [123]);
    });

    testWidgets('should respect custom debounce duration', (WidgetTester tester) async {
      final List<num?> receivedValues = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NumberFilterField(debounceDuration: const Duration(milliseconds: 200), onChanged: receivedValues.add),
          ),
        ),
      );

      final textField = find.byType(TextField);

      await tester.enterText(textField, '42');
      await tester.pump();
      expect(receivedValues, isEmpty);

      await tester.pump(const Duration(milliseconds: 150));
      expect(receivedValues, isEmpty);

      await tester.pump(const Duration(milliseconds: 100));
      expect(receivedValues, [42]);
    });

    testWidgets('should not debounce when useDebouncing is false', (WidgetTester tester) async {
      final List<num?> receivedValues = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: NumberFilterField(useDebouncing: false, onChanged: receivedValues.add)),
        ),
      );

      final textField = find.byType(TextField);

      await tester.enterText(textField, '1');
      await tester.pump();
      expect(receivedValues, [1]);

      await tester.enterText(textField, '12');
      await tester.pump();
      expect(receivedValues, [1, 12]);

      await tester.enterText(textField, '123');
      await tester.pump();
      expect(receivedValues, [1, 12, 123]);
    });

    testWidgets('should handle decimal numbers with debouncing', (WidgetTester tester) async {
      final List<num?> receivedValues = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NumberFilterField(debounceDuration: const Duration(milliseconds: 200), onChanged: receivedValues.add),
          ),
        ),
      );

      final textField = find.byType(TextField);

      await tester.enterText(textField, '3.14');
      await tester.pump();
      expect(receivedValues, isEmpty);

      await tester.pump(const Duration(milliseconds: 250));
      expect(receivedValues, [3.14]);
    });

    testWidgets('should handle integer-only mode with debouncing', (WidgetTester tester) async {
      final List<num?> receivedValues = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: NumberFilterField(allowDecimals: false, useDebouncing: false, onChanged: receivedValues.add)),
        ),
      );

      final textField = find.byType(TextField);

      await tester.enterText(textField, '42');
      await tester.pump();

      expect(receivedValues.length, 1);
      expect(receivedValues.first is int, true);
      expect(receivedValues.first, 42);
    });

    testWidgets('should emit null for empty string', (WidgetTester tester) async {
      final List<num?> receivedValues = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: NumberFilterField(useDebouncing: false, onChanged: receivedValues.add)),
        ),
      );

      final textField = find.byType(TextField);

      await tester.enterText(textField, '123');
      await tester.pump();
      expect(receivedValues, [123]);

      await tester.enterText(textField, '');
      await tester.pump();
      expect(receivedValues, [123, null]);
    });

    testWidgets('clear button should emit null immediately', (WidgetTester tester) async {
      final List<num?> receivedValues = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: NumberFilterField(value: 42, onChanged: receivedValues.add)),
        ),
      );

      await tester.pump();

      final clearButton = find.byIcon(Icons.clear);
      expect(clearButton, findsOneWidget);

      await tester.tap(clearButton);
      await tester.pump();

      expect(receivedValues, [null]);
    });

    testWidgets('should handle rapid number changes correctly', (WidgetTester tester) async {
      final List<num?> receivedValues = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NumberFilterField(debounceDuration: const Duration(milliseconds: 100), onChanged: receivedValues.add),
          ),
        ),
      );

      final textField = find.byType(TextField);

      await tester.enterText(textField, '1');
      await tester.pump(const Duration(milliseconds: 50));
      await tester.enterText(textField, '12');
      await tester.pump(const Duration(milliseconds: 50));
      await tester.enterText(textField, '123');
      await tester.pump(const Duration(milliseconds: 50));
      await tester.enterText(textField, '1234');

      expect(receivedValues, isEmpty);

      await tester.pump(const Duration(milliseconds: 150));

      expect(receivedValues, [1234]);
    });

    testWidgets('should cancel pending debounce on disposal', (WidgetTester tester) async {
      final List<num?> receivedValues = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: NumberFilterField(onChanged: receivedValues.add)),
        ),
      );

      final textField = find.byType(TextField);
      await tester.enterText(textField, '999');
      await tester.pump();

      await tester.pumpWidget(Container());

      await tester.pump(const Duration(milliseconds: 600));
      expect(receivedValues, isEmpty);
    });
  });
}
