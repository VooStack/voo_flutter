import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

void main() {
  group('DataGrid Filter Debouncing Integration Tests', () {
    late VooDataGridController<Map<String, dynamic>> controller;
    late VooDataGridSource<Map<String, dynamic>> dataSource;
    final List<Map<String, VooDataFilter?>> filterChanges = [];

    setUp(() {
      filterChanges.clear();

      // Create a local data source that tracks filter changes
      dataSource = VooLocalDataSource<Map<String, dynamic>>(
        data: [
          {'name': 'John', 'age': 25},
          {'name': 'Jane', 'age': 30},
          {'name': 'Bob', 'age': 35},
        ],
      );

      // Track filter changes
      dataSource.addListener(() {
        filterChanges.add(Map.from(dataSource.filters));
      });

      controller = VooDataGridController<Map<String, dynamic>>(
        dataSource: dataSource,
        columns: [
          VooDataColumn<Map<String, dynamic>>(field: 'name', label: 'Name', valueGetter: (row) => row['name']),
          VooDataColumn<Map<String, dynamic>>(field: 'age', label: 'Age', dataType: VooDataColumnType.number, valueGetter: (row) => row['age']),
        ],
      );
    });

    testWidgets('should debounce text filter changes in data grid', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: VooDataGrid<Map<String, dynamic>>(controller: controller)),
        ),
      );
      await tester.pumpAndSettle();

      // Clear any initial filter changes from setup
      filterChanges.clear();

      // Find the text filter field for 'name' column
      final textField = find.byType(TextField).first;

      // Type multiple characters quickly
      await tester.enterText(textField, 'J');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.enterText(textField, 'Jo');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.enterText(textField, 'Joh');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.enterText(textField, 'John');
      await tester.pump(const Duration(milliseconds: 100));

      // At this point, no filter changes should have been applied yet (debounced)
      expect(filterChanges.isEmpty, true, reason: 'Filter should not be applied yet due to debouncing');

      // Wait for debounce duration (500ms)
      await tester.pump(const Duration(milliseconds: 400));

      // Now the filter should have been applied only once
      expect(filterChanges.length, 1, reason: 'Filter should be applied once after debounce');
      expect(filterChanges.last['name']?.value, 'John');
    });

    testWidgets('should debounce number filter changes in data grid', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: VooDataGrid<Map<String, dynamic>>(controller: controller)),
        ),
      );
      await tester.pumpAndSettle();

      // Clear any initial filter changes from setup
      filterChanges.clear();

      // Find the number filter field for 'age' column (second TextField)
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2)); // name and age filters
      final numberField = textFields.last;

      // Type multiple numbers quickly
      await tester.enterText(numberField, '2');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.enterText(numberField, '25');
      await tester.pump(const Duration(milliseconds: 100));

      // At this point, no filter changes should have been applied yet (debounced)
      expect(filterChanges.isEmpty, true, reason: 'Number filter should not be applied yet due to debouncing');

      // Wait for debounce duration (500ms)
      await tester.pump(const Duration(milliseconds: 400));

      // Now the filter should have been applied only once
      expect(filterChanges.length, 1, reason: 'Number filter should be applied once after debounce');
      expect(filterChanges.last['age']?.value, 25);
    });

    testWidgets('should apply filters immediately when moving between fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: VooDataGrid<Map<String, dynamic>>(controller: controller)),
        ),
      );
      await tester.pumpAndSettle();

      // Clear any initial filter changes from setup
      filterChanges.clear();

      final textFields = find.byType(TextField);
      final nameField = textFields.first;
      final ageField = textFields.last;

      // Type in name field
      await tester.enterText(nameField, 'John');
      await tester.pump(const Duration(milliseconds: 100));

      // Move to age field (this might trigger the debounce to complete)
      await tester.tap(ageField);
      await tester.pump(const Duration(milliseconds: 100));

      // Type in age field
      await tester.enterText(ageField, '30');
      await tester.pump(const Duration(milliseconds: 100));

      // Wait for both debounce durations to complete
      await tester.pump(const Duration(milliseconds: 500));

      // Both filters should be applied
      expect(filterChanges.isNotEmpty, true, reason: 'At least one filter change should be recorded');

      // Check final filter state
      final finalFilters = dataSource.filters;
      expect(finalFilters['name']?.value, 'John');
      expect(finalFilters['age']?.value, 30);
    });

    testWidgets('should cancel pending debounce when clearing filter', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: VooDataGrid<Map<String, dynamic>>(controller: controller)),
        ),
      );
      await tester.pumpAndSettle();

      // Clear any initial filter changes from setup
      filterChanges.clear();

      final textField = find.byType(TextField).first;

      // Type text
      await tester.enterText(textField, 'John');
      await tester.pump(const Duration(milliseconds: 100));

      // Clear the field before debounce completes
      await tester.enterText(textField, '');
      await tester.pump(const Duration(milliseconds: 100));

      // Wait for debounce duration
      await tester.pump(const Duration(milliseconds: 500));

      // Filter should be cleared (null)
      expect(filterChanges.length, 1);
      expect(filterChanges.last['name'], null);
    });

    testWidgets('VooDataGridFilterRow properly integrates debounced filter fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) =>
                  VooDataGridFilterRow<Map<String, dynamic>>(controller: controller, theme: VooDataGridTheme.fromContext(context)),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should render filter row with filter components
      // The filter row contains TextFilter and NumberFilter which internally use TextFilterField and NumberFilterField
      final textFields = find.byType(TextField);
      expect(textFields, findsWidgets);

      // Type in first field and verify debouncing
      final firstField = textFields.first;
      await tester.enterText(firstField, 'Test');
      await tester.pump(const Duration(milliseconds: 200));

      // Should not have triggered filter yet
      expect(filterChanges.isEmpty, true);

      // Wait for debounce
      await tester.pump(const Duration(milliseconds: 300));

      // Now should have triggered at least once
      expect(filterChanges.isNotEmpty, true);
      expect(filterChanges.last['name']?.value, 'Test');
    });

    testWidgets('should handle rapid filter changes across multiple columns', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: VooDataGrid<Map<String, dynamic>>(controller: controller)),
        ),
      );
      await tester.pumpAndSettle();

      // Clear any initial filter changes from setup
      filterChanges.clear();

      final textFields = find.byType(TextField);
      final nameField = textFields.first;
      final ageField = textFields.last;

      // Rapidly type in both fields
      await tester.enterText(nameField, 'J');
      await tester.pump(const Duration(milliseconds: 50));
      await tester.enterText(ageField, '2');
      await tester.pump(const Duration(milliseconds: 50));
      await tester.enterText(nameField, 'Jo');
      await tester.pump(const Duration(milliseconds: 50));
      await tester.enterText(ageField, '25');
      await tester.pump(const Duration(milliseconds: 50));
      await tester.enterText(nameField, 'John');
      await tester.pump(const Duration(milliseconds: 50));

      // No filters should be applied yet
      expect(filterChanges.isEmpty, true);

      // Wait for debounce on both fields
      await tester.pump(const Duration(milliseconds: 500));

      // Filters should now be applied
      expect(filterChanges.isNotEmpty, true);

      // Verify both filters were applied with final values
      final finalFilters = dataSource.filters;
      expect(finalFilters['name']?.value, 'John');
      expect(finalFilters['age']?.value, 25);
    });
  });
}
