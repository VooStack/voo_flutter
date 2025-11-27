import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

// Test implementation of VooDataGridDataSource
class TestDataSource extends VooDataGridDataSource<Map<String, dynamic>> {
  final List<Map<String, dynamic>> testData;
  bool fetchCalled = false;

  TestDataSource({this.testData = const []});

  @override
  Future<VooDataGridResponse<Map<String, dynamic>>> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    fetchCalled = true;

    // Simulate async operation
    await Future.delayed(const Duration(milliseconds: 10), () {});

    final startIndex = page * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, testData.length);
    final pageData = testData.sublist(startIndex.clamp(0, testData.length), endIndex);

    return VooDataGridResponse(rows: pageData, totalRows: testData.length, page: page, pageSize: pageSize);
  }
}

// Test typed data source
class Order {
  final int id;
  final String customerName;
  final double amount;

  Order({required this.id, required this.customerName, required this.amount});
}

class TypedTestDataSource extends VooDataGridDataSource<Order> {
  final List<Order> orders;

  TypedTestDataSource({this.orders = const []});

  @override
  Future<VooDataGridResponse<Order>> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    await Future.delayed(const Duration(milliseconds: 10), () {});

    final startIndex = page * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, orders.length);
    final pageData = orders.sublist(startIndex.clamp(0, orders.length), endIndex);

    return VooDataGridResponse(rows: pageData, totalRows: orders.length, page: page, pageSize: pageSize);
  }
}

void main() {
  group('VooDataGridState', () {
    test('should create with default values', () {
      const state = VooDataGridState<Map<String, dynamic>>();

      expect(state.mode, VooDataGridMode.remote);
      expect(state.allRows, isEmpty);
      expect(state.rows, isEmpty);
      expect(state.totalRows, 0);
      expect(state.currentPage, 0);
      expect(state.pageSize, 20);
      expect(state.isLoading, false);
      expect(state.error, isNull);
      expect(state.filters, isEmpty);
      expect(state.sorts, isEmpty);
      expect(state.selectedRows, isEmpty);
      expect(state.selectionMode, VooSelectionMode.none);
    });

    test('should calculate total pages correctly', () {
      const state1 = VooDataGridState<dynamic>(totalRows: 100);
      expect(state1.totalPages, 5);

      const state2 = VooDataGridState<dynamic>(totalRows: 101);
      expect(state2.totalPages, 6);

      const state3 = VooDataGridState<dynamic>();
      expect(state3.totalPages, 0);
    });

    test('copyWith should preserve unmodified values', () {
      const original = VooDataGridState<dynamic>(mode: VooDataGridMode.local, currentPage: 2, pageSize: 50, isLoading: true);

      final modified = original.copyWith(isLoading: false);

      expect(modified.mode, VooDataGridMode.local);
      expect(modified.currentPage, 2);
      expect(modified.pageSize, 50);
      expect(modified.isLoading, false);
    });

    test('copyWith should update specified values', () {
      const original = VooDataGridState<dynamic>();

      final modified = original.copyWith(
        mode: VooDataGridMode.mixed,
        rows: [
          {'id': 1},
          {'id': 2},
        ],
        totalRows: 2,
        currentPage: 1,
        pageSize: 10,
        isLoading: true,
        error: 'Test error',
        filters: {'name': const VooDataFilter(operator: VooFilterOperator.contains, value: 'test')},
        sorts: [const VooColumnSort(field: 'name', direction: VooSortDirection.ascending)],
        selectedRows: {
          {'id': 1},
        },
        selectionMode: VooSelectionMode.multiple,
      );

      expect(modified.mode, VooDataGridMode.mixed);
      expect(modified.rows.length, 2);
      expect(modified.totalRows, 2);
      expect(modified.currentPage, 1);
      expect(modified.pageSize, 10);
      expect(modified.isLoading, true);
      expect(modified.error, 'Test error');
      expect(modified.filters.length, 1);
      expect(modified.sorts.length, 1);
      expect(modified.selectedRows.length, 1);
      expect(modified.selectionMode, VooSelectionMode.multiple);
    });
  });

  group('VooDataGridDataSource', () {
    test('should be implementable without ChangeNotifier', () {
      final dataSource = TestDataSource(
        testData: [
          {'id': 1, 'name': 'Item 1'},
          {'id': 2, 'name': 'Item 2'},
        ],
      );

      expect(dataSource, isA<VooDataGridDataSource>());
      expect(dataSource, isNot(isA<ChangeNotifier>())); // Key test - not a ChangeNotifier
    });

    test('should fetch remote data correctly', () async {
      final testData = List.generate(25, (i) => {'id': i + 1, 'name': 'Item ${i + 1}'});

      final dataSource = TestDataSource(testData: testData);

      final response = await dataSource.fetchRemoteData(page: 0, pageSize: 10, filters: {}, sorts: []);

      expect(response.rows.length, 10);
      expect(response.totalRows, 25);
      expect(response.page, 0);
      expect(response.pageSize, 10);
      expect(dataSource.fetchCalled, true);
    });

    test('should handle pagination correctly', () async {
      final testData = List.generate(25, (i) => {'id': i + 1, 'name': 'Item ${i + 1}'});

      final dataSource = TestDataSource(testData: testData);

      // Get second page
      final response = await dataSource.fetchRemoteData(page: 1, pageSize: 10, filters: {}, sorts: []);

      expect(response.rows.length, 10);
      expect(response.rows.first['id'], 11);
      expect(response.rows.last['id'], 20);

      // Get last page
      final lastPageResponse = await dataSource.fetchRemoteData(page: 2, pageSize: 10, filters: {}, sorts: []);

      expect(lastPageResponse.rows.length, 5);
      expect(lastPageResponse.rows.first['id'], 21);
      expect(lastPageResponse.rows.last['id'], 25);
    });

    test('should work with typed data', () async {
      final orders = [
        Order(id: 1, customerName: 'John Doe', amount: 100.0),
        Order(id: 2, customerName: 'Jane Smith', amount: 200.0),
        Order(id: 3, customerName: 'Bob Johnson', amount: 150.0),
      ];

      final dataSource = TypedTestDataSource(orders: orders);

      final response = await dataSource.fetchRemoteData(page: 0, pageSize: 2, filters: {}, sorts: []);

      expect(response.rows.length, 2);
      expect(response.rows[0].id, 1);
      expect(response.rows[0].customerName, 'John Doe');
      expect(response.rows[1].id, 2);
      expect(response.totalRows, 3);
    });
  });

  group('VooDataGridStateController', () {
    test('should initialize with default state', () {
      final dataSource = TestDataSource();
      final controller = VooDataGridStateController(dataSource: dataSource);

      expect(controller.state.mode, VooDataGridMode.remote);
      expect(controller.state.pageSize, 20);
      expect(controller.state.currentPage, 0);
      expect(controller.state.isLoading, false);
    });

    test('should initialize with custom state', () {
      final dataSource = TestDataSource();
      final controller = VooDataGridStateController(dataSource: dataSource, mode: VooDataGridMode.local, pageSize: 50);

      expect(controller.state.mode, VooDataGridMode.local);
      expect(controller.state.pageSize, 50);
    });

    test('should expose state properties as getters', () {
      final dataSource = TestDataSource();
      final controller = VooDataGridStateController(dataSource: dataSource);

      controller.setLocalData([
        {'id': 1},
        {'id': 2},
      ]);

      expect(controller.mode, controller.state.mode);
      expect(controller.allRows, controller.state.allRows);
      expect(controller.rows, controller.state.rows);
      expect(controller.totalRows, controller.state.totalRows);
      expect(controller.currentPage, controller.state.currentPage);
      expect(controller.pageSize, controller.state.pageSize);
      expect(controller.isLoading, controller.state.isLoading);
      expect(controller.error, controller.state.error);
      expect(controller.filters, controller.state.filters);
      expect(controller.sorts, controller.state.sorts);
      expect(controller.selectedRows, controller.state.selectedRows);
      expect(controller.selectionMode, controller.state.selectionMode);
      expect(controller.totalPages, controller.state.totalPages);
    });

    test('should load remote data', () async {
      final testData = List.generate(25, (i) => {'id': i + 1, 'name': 'Item ${i + 1}'});

      final dataSource = TestDataSource(testData: testData);
      final controller = VooDataGridStateController(dataSource: dataSource, pageSize: 10);

      await controller.loadData();

      expect(controller.state.rows.length, 10);
      expect(controller.state.totalRows, 25);
      expect(controller.state.isLoading, false);
      expect(controller.state.error, isNull);
    });

    test('should handle page changes', () async {
      final testData = List.generate(25, (i) => {'id': i + 1, 'name': 'Item ${i + 1}'});

      final dataSource = TestDataSource(testData: testData);
      final controller = VooDataGridStateController(dataSource: dataSource, pageSize: 10);

      await controller.loadData();
      expect(controller.state.currentPage, 0);
      expect(controller.state.rows.first['id'], 1);

      controller.changePage(1);
      await Future.delayed(const Duration(milliseconds: 20), () {});

      expect(controller.state.currentPage, 1);
      expect(controller.state.rows.first['id'], 11);
    });

    test('should apply filters', () {
      final dataSource = TestDataSource();
      final controller = VooDataGridStateController(dataSource: dataSource);

      controller.applyFilter('name', const VooDataFilter(operator: VooFilterOperator.contains, value: 'test'));

      expect(controller.state.filters.length, 1);
      expect(controller.state.filters['name']!.value, 'test');
      expect(controller.state.currentPage, 0); // Should reset to first page
    });

    test('should clear filters', () {
      final dataSource = TestDataSource();
      final controller = VooDataGridStateController(dataSource: dataSource);

      controller.applyFilter('name', const VooDataFilter(operator: VooFilterOperator.contains, value: 'test'));

      expect(controller.state.filters.length, 1);

      controller.clearFilters();

      expect(controller.state.filters.length, 0);
    });

    test('should apply and clear sorts', () {
      final dataSource = TestDataSource();
      final controller = VooDataGridStateController(dataSource: dataSource);

      controller.applySort('name', VooSortDirection.ascending);

      expect(controller.state.sorts.length, 1);
      expect(controller.state.sorts.first.field, 'name');
      expect(controller.state.sorts.first.direction, VooSortDirection.ascending);

      controller.applySort('name', VooSortDirection.descending);
      expect(controller.state.sorts.first.direction, VooSortDirection.descending);

      controller.applySort('name', VooSortDirection.none);
      expect(controller.state.sorts.length, 0);

      controller.applySort('id', VooSortDirection.ascending);
      controller.applySort('name', VooSortDirection.descending);
      expect(controller.state.sorts.length, 2);

      controller.clearSorts();
      expect(controller.state.sorts.length, 0);
    });

    test('should handle row selection', () async {
      final dataSource = TestDataSource();
      final controller = VooDataGridStateController(dataSource: dataSource, mode: VooDataGridMode.local);

      await controller.setLocalDataAsync([
        {'id': 1},
        {'id': 2},
        {'id': 3},
      ]);

      // Test single selection
      controller.setSelectionMode(VooSelectionMode.single);
      controller.toggleRowSelection({'id': 1});
      expect(controller.state.selectedRows.length, 1);

      controller.toggleRowSelection({'id': 2});
      expect(controller.state.selectedRows.length, 1);
      expect(controller.state.selectedRows.first['id'], 2);

      // Test multiple selection
      controller.setSelectionMode(VooSelectionMode.multiple);
      controller.toggleRowSelection({'id': 1});
      expect(controller.state.selectedRows.length, 2);

      // Test select all
      controller.selectAll();
      expect(controller.state.selectedRows.length, 3);

      // Test clear selection
      controller.clearSelection();
      expect(controller.state.selectedRows.length, 0);
    });

    test('should handle local data with filtering and sorting', () async {
      final dataSource = TestDataSource();
      final controller = VooDataGridStateController(dataSource: dataSource, mode: VooDataGridMode.local, pageSize: 2);

      await controller.setLocalDataAsync([
        {'id': 1, 'name': 'Apple', 'price': 100},
        {'id': 2, 'name': 'Banana', 'price': 50},
        {'id': 3, 'name': 'Cherry', 'price': 150},
        {'id': 4, 'name': 'Date', 'price': 75},
      ]);

      // Test initial state
      expect(controller.state.totalRows, 4);
      expect(controller.state.rows.length, 2);

      // Test filtering - applyFilter calls loadData internally
      controller.applyFilter('name', const VooDataFilter(operator: VooFilterOperator.contains, value: 'a'));
      await controller.loadData(); // Wait for async processing

      expect(controller.state.totalRows, 3); // Apple, Banana, Date
      expect(controller.state.rows.length, 2);

      // Test sorting - applySort calls loadData internally
      controller.applySort('price', VooSortDirection.ascending);
      await controller.loadData(); // Wait for async processing

      expect(controller.state.rows.first['name'], 'Banana'); // price: 50
      expect(controller.state.rows.last['name'], 'Date'); // price: 75
    });

    test('should dispose properly', () {
      final dataSource = TestDataSource();
      final controller = VooDataGridStateController(dataSource: dataSource);

      expect(controller.dispose, returnsNormally);
    });
  });

  group('Integration with Cubit-like pattern', () {
    test('should work without ChangeNotifier conflicts', () async {
      // This simulates using VooDataGrid with Cubit
      // The key is that the data source doesn't extend ChangeNotifier

      final dataSource = TestDataSource(
        testData: [
          {'id': 1, 'name': 'Item 1'},
          {'id': 2, 'name': 'Item 2'},
        ],
      );

      // Simulate Cubit state management
      var state = const VooDataGridState<Map<String, dynamic>>();

      // Load data (like in a Cubit)
      state = state.copyWith(isLoading: true);
      expect(state.isLoading, true);

      final response = await dataSource.fetchRemoteData(page: state.currentPage, pageSize: state.pageSize, filters: state.filters, sorts: state.sorts);

      state = state.copyWith(rows: response.rows, totalRows: response.totalRows, isLoading: false);

      expect(state.rows.length, 2);
      expect(state.isLoading, false);
      expect(state.totalRows, 2);

      // The data source is not a ChangeNotifier, so it won't conflict with Provider
      expect(dataSource, isNot(isA<ChangeNotifier>()));
    });
  });
}
