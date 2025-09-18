import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

void main() {
  group('VooDataGrid onRefresh Tests', () {
    late VooDataGridController<Map<String, dynamic>> controller;
    late VooLocalDataSource<Map<String, dynamic>> dataSource;

    setUp(() {
      // Create a local data source
      dataSource = VooLocalDataSource<Map<String, dynamic>>(
        data: [
          {'name': 'John', 'age': 25},
          {'name': 'Jane', 'age': 30},
          {'name': 'Bob', 'age': 35},
        ],
      );

      controller = VooDataGridController<Map<String, dynamic>>(
        dataSource: dataSource,
        columns: [
          VooDataColumn<Map<String, dynamic>>(
            field: 'name',
            label: 'Name',
            dataType: VooDataColumnType.text,
            valueGetter: (row) => row['name'],
          ),
          VooDataColumn<Map<String, dynamic>>(
            field: 'age',
            label: 'Age',
            dataType: VooDataColumnType.number,
            valueGetter: (row) => row['age'],
          ),
        ],
      );
    });

    testWidgets('should call onRefresh callback when refresh button is clicked', (WidgetTester tester) async {
      bool refreshCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDataGrid<Map<String, dynamic>>(
              controller: controller,
              onRefresh: () {
                refreshCalled = true;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find the refresh button
      final refreshButton = find.byIcon(Icons.refresh);
      expect(refreshButton, findsOneWidget);

      // Tap the refresh button
      await tester.tap(refreshButton);
      await tester.pumpAndSettle();

      // Verify the callback was called
      expect(refreshCalled, true);
    });

    testWidgets('should use default dataSource.refresh when onRefresh is not provided', (WidgetTester tester) async {
      int refreshCount = 0;

      // Listen to data source changes to track refresh calls
      dataSource.addListener(() {
        refreshCount++;
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDataGrid<Map<String, dynamic>>(
              controller: controller,
              // No onRefresh callback provided
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find and tap the refresh button
      final refreshButton = find.byIcon(Icons.refresh);
      expect(refreshButton, findsOneWidget);

      await tester.tap(refreshButton);
      await tester.pumpAndSettle();

      // Verify the dataSource.refresh was called (it triggers loadData which notifies listeners)
      expect(refreshCount >= 1, true);
    });

    testWidgets('should pass onRefresh to VooDataGridStateless', (WidgetTester tester) async {
      bool refreshCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDataGridStateless<Map<String, dynamic>>(
              state: VooDataGridState<Map<String, dynamic>>(
                rows: [
                  {'name': 'John', 'age': 25},
                  {'name': 'Jane', 'age': 30},
                ],
                totalRows: 2,
                currentPage: 1,
                pageSize: 10,
                isLoading: false,
                filters: {},
                sorts: const [],
                selectedRows: const {},
              ),
              columns: [
                VooDataColumn<Map<String, dynamic>>(
                  field: 'name',
                  label: 'Name',
                  dataType: VooDataColumnType.text,
                  valueGetter: (row) => row['name'],
                ),
                VooDataColumn<Map<String, dynamic>>(
                  field: 'age',
                  label: 'Age',
                  dataType: VooDataColumnType.number,
                  valueGetter: (row) => row['age'],
                ),
              ],
              onRefresh: () {
                refreshCalled = true;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find the refresh button
      final refreshButton = find.byIcon(Icons.refresh);
      expect(refreshButton, findsOneWidget);

      // Tap the refresh button
      await tester.tap(refreshButton);
      await tester.pumpAndSettle();

      // Verify the callback was called
      expect(refreshCalled, true);
    });

    testWidgets('refresh button should be visible in toolbar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDataGrid<Map<String, dynamic>>(
              controller: controller,
              onRefresh: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify refresh button is visible
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('refresh button should not be visible when toolbar is hidden', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDataGrid<Map<String, dynamic>>(
              controller: controller,
              showToolbar: false,
              onRefresh: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify refresh button is not visible
      expect(find.byIcon(Icons.refresh), findsNothing);
    });

    testWidgets('should call onRefresh on mobile view', (WidgetTester tester) async {
      bool refreshCalled = false;

      // Set a small screen size to trigger mobile view
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDataGrid<Map<String, dynamic>>(
              controller: controller,
              onRefresh: () {
                refreshCalled = true;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find the refresh button (should be in mobile toolbar)
      final refreshButton = find.byIcon(Icons.refresh);
      expect(refreshButton, findsOneWidget);

      // Tap the refresh button
      await tester.tap(refreshButton);
      await tester.pumpAndSettle();

      // Verify the callback was called
      expect(refreshCalled, true);

      // Reset the view size
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}