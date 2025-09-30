import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

void main() {
  group('Error Callback Tests', () {
    late List<String> errorLog;

    setUp(() {
      errorLog = [];
    });

    testWidgets('VooDataGridStateless should call onError when error is present in state', (WidgetTester tester) async {
      const state = VooDataGridState<Map<String, dynamic>>(
        rows: [],
        totalRows: 0,
        error: 'Network connection failed',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDataGridStateless<Map<String, dynamic>>(
              state: state,
              columns: const [
                VooDataColumn<Map<String, dynamic>>(field: 'name', label: 'Name'),
              ],
              onError: (error) => errorLog.add(error),
            ),
          ),
        ),
      );

      await tester.pump();

      // Error callback should be called when error is in state
      expect(errorLog, ['Network connection failed']);
    });

    testWidgets('VooDataGrid should call onError when data source has error', (WidgetTester tester) async {
      final dataSource = _ErrorDataSource<Map<String, dynamic>>();
      final controller = VooDataGridController<Map<String, dynamic>>(
        columns: const [
          VooDataColumn<Map<String, dynamic>>(field: 'name', label: 'Name'),
        ],
        dataSource: dataSource,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDataGrid<Map<String, dynamic>>(
              controller: controller,
              onError: (error) => errorLog.add(error),
            ),
          ),
        ),
      );

      // Wait for initial data load to complete (which will fail)
      await tester.pumpAndSettle();

      // Error callback should be called
      expect(errorLog.length, greaterThan(0));
      expect(errorLog.first, contains('Database query failed'));
    });

    testWidgets('onError should only be called when error changes', (WidgetTester tester) async {
      var state = const VooDataGridState<Map<String, dynamic>>(
        rows: [],
        totalRows: 0,
      );

      late StateSetter setState;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, stateSetter) {
                setState = stateSetter;
                return VooDataGridStateless<Map<String, dynamic>>(
                  state: state,
                  columns: const [
                    VooDataColumn<Map<String, dynamic>>(field: 'name', label: 'Name'),
                  ],
                  onError: (error) => errorLog.add(error),
                );
              },
            ),
          ),
        ),
      );

      await tester.pump();

      // No errors initially
      expect(errorLog, isEmpty);

      // Set error
      setState(() {
        state = const VooDataGridState<Map<String, dynamic>>(
          rows: [],
          totalRows: 0,
          error: 'Error 1',
        );
      });
      await tester.pump();
      expect(errorLog, ['Error 1']);

      // Rebuild without changing error - callback should not be called again
      setState(() {
        state = const VooDataGridState<Map<String, dynamic>>(
          rows: [],
          totalRows: 0,
          error: 'Error 1', // Same error
        );
      });
      await tester.pump();
      expect(errorLog, ['Error 1']); // Still just one

      // Change to different error
      setState(() {
        state = const VooDataGridState<Map<String, dynamic>>(
          rows: [],
          totalRows: 0,
          error: 'Error 2',
        );
      });
      await tester.pump();
      expect(errorLog, ['Error 1', 'Error 2']);

      // Clear error
      setState(() {
        state = const VooDataGridState<Map<String, dynamic>>(
          rows: [],
          totalRows: 0,
        );
      });
      await tester.pump();
      expect(errorLog, ['Error 1', 'Error 2']); // No new calls

      // Set error again after clearing
      setState(() {
        state = const VooDataGridState<Map<String, dynamic>>(
          rows: [],
          totalRows: 0,
          error: 'Error 3',
        );
      });
      await tester.pump();
      expect(errorLog, ['Error 1', 'Error 2', 'Error 3']);
    });

    testWidgets('onError should not be called if callback is not provided', (WidgetTester tester) async {
      final dataSource = _ErrorDataSource<Map<String, dynamic>>();
      final controller = VooDataGridController<Map<String, dynamic>>(
        columns: const [
          VooDataColumn<Map<String, dynamic>>(field: 'name', label: 'Name'),
        ],
        dataSource: dataSource,
      );

      // No onError callback provided - should not throw
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDataGrid<Map<String, dynamic>>(
              controller: controller,
              // onError not provided
            ),
          ),
        ),
      );

      // Wait for data load (which will fail)
      await tester.pumpAndSettle();

      // Test passes if no exception is thrown
      expect(true, isTrue);
    });

    testWidgets('errorBuilder and onError should both work together', (WidgetTester tester) async {
      final dataSource = _ErrorDataSource<Map<String, dynamic>>();
      final controller = VooDataGridController<Map<String, dynamic>>(
        columns: const [
          VooDataColumn<Map<String, dynamic>>(field: 'name', label: 'Name'),
        ],
        dataSource: dataSource,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDataGrid<Map<String, dynamic>>(
              controller: controller,
              onError: (error) => errorLog.add(error),
              errorBuilder: (error) => Text('Custom Error: $error'),
            ),
          ),
        ),
      );

      // Wait for data load
      await tester.pumpAndSettle();

      // onError callback should be called
      expect(errorLog.length, greaterThan(0));

      // errorBuilder should also be used
      expect(find.textContaining('Custom Error:'), findsOneWidget);
    });
  });
}

/// Test data source that always fails
class _ErrorDataSource<T> extends VooDataGridSource<T> {
  @override
  Future<VooDataGridResponse<T>> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    // Simulate a failure
    throw Exception('Database query failed');
  }
}