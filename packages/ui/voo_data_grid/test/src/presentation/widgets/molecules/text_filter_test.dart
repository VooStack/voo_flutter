import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/operator_selector.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/text_filter.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

void main() {
  group('TextFilter', () {
    late Map<String, TextEditingController> textControllers;
    late VooDataColumn<Map<String, dynamic>> testColumn;

    setUp(() {
      textControllers = {};
      testColumn = const VooDataColumn<Map<String, dynamic>>(
        field: 'name',
        label: 'Name',
        width: 150,
        filterHint: 'Filter by name...',
        showFilterOperator: true,
        allowedFilterOperators: [
          VooFilterOperator.contains,
          VooFilterOperator.equals,
          VooFilterOperator.startsWith,
          VooFilterOperator.endsWith,
        ],
      );
    });

    tearDown(() {
      textControllers.forEach((key, controller) {
        controller.dispose();
      });
    });

    testWidgets('renders text input field', (WidgetTester tester) async {
      // ignore: unused_local_variable
      dynamic capturedValue;
      // ignore: unused_local_variable
      bool clearCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFilter<Map<String, dynamic>>(
              column: testColumn,
              onFilterChanged: (value) => capturedValue = value,
              onFilterCleared: () => clearCalled = true,
              textControllers: textControllers,
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      // Operator selector should be shown when showFilterOperator is true
      expect(find.byType(OperatorSelector<Map<String, dynamic>>), findsOneWidget);
    });

    testWidgets('triggers onFilterChanged when text is entered', (WidgetTester tester) async {
      dynamic capturedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFilter<Map<String, dynamic>>(
              column: testColumn,
              onFilterChanged: (value) => capturedValue = value,
              onFilterCleared: () {},
              textControllers: textControllers,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'test search');
      await tester.pumpAndSettle();

      expect(capturedValue, equals('test search'));
    });

    testWidgets('allows operator selection', (WidgetTester tester) async {
      // ignore: unused_local_variable
      dynamic capturedValue;
      const currentFilter = VooDataFilter(
        operator: VooFilterOperator.contains,
        value: 'test',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              child: TextFilter<Map<String, dynamic>>(
                column: testColumn,
                currentFilter: currentFilter,
                onFilterChanged: (value) => capturedValue = value,
                onFilterCleared: () {},
                textControllers: textControllers,
              ),
            ),
          ),
        ),
      );

      // Find the operator selector
      final operatorSelector = find.byType(OperatorSelector<Map<String, dynamic>>);
      expect(operatorSelector, findsOneWidget);
    });

    testWidgets('clears value when clear button is pressed', (WidgetTester tester) async {
      bool clearCalled = false;
      const currentFilter = VooDataFilter(
        operator: VooFilterOperator.contains,
        value: 'test',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFilter<Map<String, dynamic>>(
              column: testColumn,
              currentFilter: currentFilter,
              onFilterChanged: (_) {},
              onFilterCleared: () => clearCalled = true,
              textControllers: textControllers,
            ),
          ),
        ),
      );

      // Clear button should be visible when there's a current filter
      final clearButton = find.byIcon(Icons.clear);
      expect(clearButton, findsOneWidget);
      
      await tester.tap(clearButton);
      await tester.pumpAndSettle();
      
      expect(clearCalled, isTrue);
    });

    testWidgets('displays with custom filter hint', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFilter<Map<String, dynamic>>(
              column: testColumn,
              onFilterChanged: (_) {},
              onFilterCleared: () {},
              textControllers: textControllers,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.hintText, equals('Filter by name...'));
    });

    testWidgets('applies consistent 12px font size', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFilter<Map<String, dynamic>>(
              column: testColumn,
              onFilterChanged: (_) {},
              onFilterCleared: () {},
              textControllers: textControllers,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.style?.fontSize, equals(12));
    });

    testWidgets('hides operator selector when showFilterOperator is false', (WidgetTester tester) async {
      const columnWithoutOperator = VooDataColumn<Map<String, dynamic>>(
        field: 'name',
        label: 'Name',
        width: 150,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFilter<Map<String, dynamic>>(
              column: columnWithoutOperator,
              onFilterChanged: (_) {},
              onFilterCleared: () {},
              textControllers: textControllers,
            ),
          ),
        ),
      );

      expect(find.byType(OperatorSelector<Map<String, dynamic>>), findsNothing);
    });

    testWidgets('maintains text controller state', (WidgetTester tester) async {
      const currentFilter = VooDataFilter(
        operator: VooFilterOperator.contains,
        value: 'initial value',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFilter<Map<String, dynamic>>(
              column: testColumn,
              currentFilter: currentFilter,
              onFilterChanged: (_) {},
              onFilterCleared: () {},
              textControllers: textControllers,
            ),
          ),
        ),
      );

      // Check that controller was created and has the initial value
      expect(textControllers.containsKey('name'), isTrue);
      expect(textControllers['name']!.text, equals('initial value'));
    });
  });
}