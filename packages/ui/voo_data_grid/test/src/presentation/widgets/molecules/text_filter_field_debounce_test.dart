import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/text_filter_field.dart';

void main() {
  group('TextFilterField Debouncing Tests', () {
    testWidgets('should debounce text input changes by default', (WidgetTester tester) async {
      final List<String?> receivedValues = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TextFilterField(onChanged: receivedValues.add)),
        ),
      );

      final textField = find.byType(TextField);

      await tester.enterText(textField, 't');
      await tester.pump();
      expect(receivedValues, isEmpty);

      await tester.enterText(textField, 'te');
      await tester.pump();
      expect(receivedValues, isEmpty);

      await tester.enterText(textField, 'test');
      await tester.pump();
      expect(receivedValues, isEmpty);

      await tester.pump(const Duration(milliseconds: 500));
      expect(receivedValues, ['test']);
    });

    testWidgets('should respect custom debounce duration', (WidgetTester tester) async {
      final List<String?> receivedValues = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFilterField(debounceDuration: const Duration(milliseconds: 200), onChanged: receivedValues.add),
          ),
        ),
      );

      final textField = find.byType(TextField);

      await tester.enterText(textField, 'test');
      await tester.pump();
      expect(receivedValues, isEmpty);

      await tester.pump(const Duration(milliseconds: 150));
      expect(receivedValues, isEmpty);

      await tester.pump(const Duration(milliseconds: 100));
      expect(receivedValues, ['test']);
    });

    testWidgets('should not debounce when useDebouncing is false', (WidgetTester tester) async {
      final List<String?> receivedValues = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TextFilterField(useDebouncing: false, onChanged: receivedValues.add)),
        ),
      );

      final textField = find.byType(TextField);

      await tester.enterText(textField, 't');
      await tester.pump();
      expect(receivedValues, ['t']);

      await tester.enterText(textField, 'te');
      await tester.pump();
      expect(receivedValues, ['t', 'te']);

      await tester.enterText(textField, 'test');
      await tester.pump();
      expect(receivedValues, ['t', 'te', 'test']);
    });

    testWidgets('should cancel pending debounce on disposal', (WidgetTester tester) async {
      final List<String?> receivedValues = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TextFilterField(onChanged: receivedValues.add)),
        ),
      );

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'test');
      await tester.pump();

      await tester.pumpWidget(Container());

      await tester.pump(const Duration(milliseconds: 600));
      expect(receivedValues, isEmpty);
    });

    testWidgets('should emit null for empty string', (WidgetTester tester) async {
      final List<String?> receivedValues = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TextFilterField(useDebouncing: false, onChanged: receivedValues.add)),
        ),
      );

      final textField = find.byType(TextField);

      await tester.enterText(textField, 'test');
      await tester.pump();
      expect(receivedValues, ['test']);

      await tester.enterText(textField, '');
      await tester.pump();
      expect(receivedValues, ['test', null]);
    });

    testWidgets('clear button should emit null immediately', (WidgetTester tester) async {
      final List<String?> receivedValues = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFilterField(value: 'initial', onChanged: receivedValues.add),
          ),
        ),
      );

      await tester.pump();

      final clearButton = find.byIcon(Icons.clear);
      expect(clearButton, findsOneWidget);

      await tester.tap(clearButton);
      await tester.pump();

      expect(receivedValues, [null]);
    });

    testWidgets('should handle rapid text changes correctly', (WidgetTester tester) async {
      final List<String?> receivedValues = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFilterField(debounceDuration: const Duration(milliseconds: 100), onChanged: receivedValues.add),
          ),
        ),
      );

      final textField = find.byType(TextField);

      await tester.enterText(textField, 'a');
      await tester.pump(const Duration(milliseconds: 50));
      await tester.enterText(textField, 'ab');
      await tester.pump(const Duration(milliseconds: 50));
      await tester.enterText(textField, 'abc');
      await tester.pump(const Duration(milliseconds: 50));
      await tester.enterText(textField, 'abcd');

      expect(receivedValues, isEmpty);

      await tester.pump(const Duration(milliseconds: 150));

      expect(receivedValues, ['abcd']);
    });
  });
}
