import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

// Test implementation of VooDataGridSource
class TestDataGridSource extends VooDataGridSource {
  final List<dynamic>? _initialData;

  TestDataGridSource({super.mode = VooDataGridMode.local, List<dynamic>? data}) : _initialData = data;

  /// Initialize data asynchronously - must be called before running tests
  Future<void> initializeData() async {
    if (_initialData != null) {
      await setLocalDataAsync(_initialData);
    }
  }

  @override
  Future<VooDataGridResponse> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    if (mode == VooDataGridMode.local) {
      return VooDataGridResponse(rows: rows, totalRows: totalRows, page: page, pageSize: pageSize);
    }
    throw UnimplementedError();
  }
}

void main() {
  group('VooDataGridSource', () {
    late TestDataGridSource dataSource;
    late List<Map<String, dynamic>> testData;

    setUp(() {
      testData = [
        {'id': 1, 'name': 'John Doe', 'age': 30, 'status': 'active'},
        {'id': 2, 'name': 'Jane Smith', 'age': 25, 'status': 'inactive'},
        {'id': 3, 'name': 'Bob Johnson', 'age': 35, 'status': 'active'},
        {'id': 4, 'name': 'Alice Brown', 'age': 28, 'status': 'active'},
        {'id': 5, 'name': 'Charlie Wilson', 'age': 32, 'status': 'inactive'},
      ];
    });

    group('Local Mode', () {
      setUp(() async {
        dataSource = TestDataGridSource(data: testData);
        await dataSource.initializeData();
      });

      test('should initialize with local data', () {
        expect(dataSource.rows, testData);
        expect(dataSource.totalRows, 5);
        expect(dataSource.mode, VooDataGridMode.local);
      });

      test('should handle pagination correctly', () {
        dataSource.changePageSize(2);
        dataSource.changePage(0);
        expect(dataSource.currentPage, 0);
        expect(dataSource.totalPages, 3);

        dataSource.changePage(1);
        expect(dataSource.currentPage, 1);

        dataSource.changePage(2);
        expect(dataSource.currentPage, 2);
      });

      test('should change page size', () {
        dataSource.changePageSize(3);
        expect(dataSource.pageSize, 3);
        expect(dataSource.totalPages, 2);
      });

      test('should apply filters', () {
        dataSource.applyFilter('status', const VooDataFilter(operator: VooFilterOperator.equals, value: 'active'));

        expect(dataSource.filters.length, 1);
        expect(dataSource.filters['status']?.value, 'active');
      });

      test('should clear filters', () {
        dataSource.applyFilter('status', const VooDataFilter(operator: VooFilterOperator.equals, value: 'active'));
        dataSource.applyFilter('age', const VooDataFilter(operator: VooFilterOperator.greaterThan, value: 30));

        expect(dataSource.filters.length, 2);

        dataSource.clearFilters();
        expect(dataSource.filters.isEmpty, true);
      });

      test('should apply sorts', () {
        dataSource.applySort('name', VooSortDirection.ascending);

        expect(dataSource.sorts.length, 1);
        expect(dataSource.sorts[0].field, 'name');
        expect(dataSource.sorts[0].direction, VooSortDirection.ascending);
      });

      test('should handle multi-sort', () {
        dataSource.applySort('status', VooSortDirection.descending);
        dataSource.applySort('age', VooSortDirection.ascending);

        expect(dataSource.sorts.length, 2);
        expect(dataSource.sorts[0].field, 'status');
        expect(dataSource.sorts[1].field, 'age');
      });

      test('should refresh data', () async {
        int listenerCallCount = 0;
        dataSource.addListener(() {
          listenerCallCount++;
        });

        await dataSource.refresh();
        expect(listenerCallCount, greaterThan(0));
      });

      test('should handle row selection in single mode', () {
        dataSource.setSelectionMode(VooSelectionMode.single);

        dataSource.toggleRowSelection(testData[0]);
        expect(dataSource.selectedRows.length, 1);
        expect(dataSource.selectedRows.contains(testData[0]), true);

        dataSource.toggleRowSelection(testData[1]);
        expect(dataSource.selectedRows.length, 1);
        expect(dataSource.selectedRows.contains(testData[1]), true);
      });

      test('should handle row selection in multiple mode', () {
        dataSource.setSelectionMode(VooSelectionMode.multiple);

        dataSource.toggleRowSelection(testData[0]);
        dataSource.toggleRowSelection(testData[1]);
        expect(dataSource.selectedRows.length, 2);

        dataSource.toggleRowSelection(testData[0]);
        expect(dataSource.selectedRows.length, 1);
        expect(dataSource.selectedRows.contains(testData[1]), true);
      });

      test('should toggle row selection', () {
        dataSource.setSelectionMode(VooSelectionMode.multiple);

        dataSource.toggleRowSelection(testData[0]);
        expect(dataSource.selectedRows.contains(testData[0]), true);

        dataSource.toggleRowSelection(testData[0]);
        expect(dataSource.selectedRows.contains(testData[0]), false);
      });

      test('should select all rows', () {
        dataSource.setSelectionMode(VooSelectionMode.multiple);

        dataSource.selectAllRows();
        // selectAllRows selects from current page rows, not all data
        expect(dataSource.selectedRows.isNotEmpty, true);
      });

      test('should deselect all rows', () {
        dataSource.setSelectionMode(VooSelectionMode.multiple);

        dataSource.selectAllRows();
        expect(dataSource.selectedRows.isNotEmpty, true);

        dataSource.deselectAllRows();
        expect(dataSource.selectedRows.isEmpty, true);
      });

      test('should not allow selection when mode is none', () {
        dataSource.setSelectionMode(VooSelectionMode.none);

        dataSource.toggleRowSelection(testData[0]);
        expect(dataSource.selectedRows.isEmpty, true);
      });

      test('should track loading state', () async {
        expect(dataSource.isLoading, false);
        // Loading state is managed internally during loadData
        // We can't set it directly
      });

      test('should track error state', () {
        expect(dataSource.error, null);
        // Error state is managed internally
        // We can't set it directly
      });
    });

    group('Remote Mode', () {
      setUp(() {
        dataSource = TestDataGridSource(mode: VooDataGridMode.remote);
      });

      test('should initialize in remote mode', () {
        expect(dataSource.mode, VooDataGridMode.remote);
        expect(dataSource.rows.isEmpty, true);
      });

      test('should handle remote data', () {
        // In remote mode, data is fetched via fetchRemoteData
        expect(dataSource.rows.isEmpty, true);
        expect(dataSource.mode, VooDataGridMode.remote);
      });

      test('should apply filter in remote mode', () {
        dataSource.applyFilter('test', const VooDataFilter(operator: VooFilterOperator.equals, value: 'value'));

        // In remote mode, applying filter updates the filters
        expect(dataSource.filters.containsKey('test'), true);
        expect(dataSource.filters['test']?.value, 'value');
      });

      test('should throw unimplemented error for fetchRemoteData', () {
        expect(() => dataSource.fetchRemoteData(page: 0, pageSize: 20, filters: {}, sorts: []), throwsUnimplementedError);
      });
    });

    group('VooDataGridResponse', () {
      test('should create response with all properties', () {
        final response = VooDataGridResponse(rows: testData, totalRows: 100, page: 2, pageSize: 20);

        expect(response.rows, testData);
        expect(response.totalRows, 100);
        expect(response.page, 2);
        expect(response.pageSize, 20);
      });

      test('should have correct properties', () {
        final response1 = VooDataGridResponse(rows: testData, totalRows: 100, page: 1, pageSize: 20);

        final response2 = VooDataGridResponse(rows: testData, totalRows: 100, page: 1, pageSize: 20);

        final response3 = VooDataGridResponse(rows: testData, totalRows: 100, page: 2, pageSize: 20);

        // Check properties instead of equality since VooDataGridResponse doesn't override ==
        expect(response1.rows, response2.rows);
        expect(response1.totalRows, response2.totalRows);
        expect(response1.page, response2.page);
        expect(response1.pageSize, response2.pageSize);

        expect(response1.page, isNot(response3.page));
      });
    });

    group('Filter Operators', () {
      test('should have all expected operators', () {
        const operators = VooFilterOperator.values;

        expect(operators.contains(VooFilterOperator.equals), true);
        expect(operators.contains(VooFilterOperator.notEquals), true);
        expect(operators.contains(VooFilterOperator.contains), true);
        expect(operators.contains(VooFilterOperator.notContains), true);
        expect(operators.contains(VooFilterOperator.startsWith), true);
        expect(operators.contains(VooFilterOperator.endsWith), true);
        expect(operators.contains(VooFilterOperator.greaterThan), true);
        expect(operators.contains(VooFilterOperator.greaterThanOrEqual), true);
        expect(operators.contains(VooFilterOperator.lessThan), true);
        expect(operators.contains(VooFilterOperator.lessThanOrEqual), true);
        expect(operators.contains(VooFilterOperator.between), true);
        expect(operators.contains(VooFilterOperator.inList), true);
        expect(operators.contains(VooFilterOperator.notInList), true);
        expect(operators.contains(VooFilterOperator.isNull), true);
        expect(operators.contains(VooFilterOperator.isNotNull), true);
      });
    });

    group('Selection Modes', () {
      test('should have all expected selection modes', () {
        const modes = VooSelectionMode.values;

        expect(modes.contains(VooSelectionMode.none), true);
        expect(modes.contains(VooSelectionMode.single), true);
        expect(modes.contains(VooSelectionMode.multiple), true);
      });
    });

    group('Data Grid Modes', () {
      test('should have all expected data grid modes', () {
        const modes = VooDataGridMode.values;

        expect(modes.contains(VooDataGridMode.local), true);
        expect(modes.contains(VooDataGridMode.remote), true);
      });
    });
  });
}
