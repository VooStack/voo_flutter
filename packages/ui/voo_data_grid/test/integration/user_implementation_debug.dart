import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

// Example implementation matching user's code
class OrderRepositoryImpl extends VooDataGridSource<OrderList> {
  OrderRepositoryImpl() : super(mode: VooDataGridMode.remote);

  @override
  Future<VooDataGridResponse<OrderList>> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    // Add debug logging
    debugPrint('[DEBUG] fetchRemoteData called:');
    debugPrint('  - page: $page');
    debugPrint('  - pageSize: $pageSize');
    debugPrint('  - filters: $filters');
    debugPrint('  - sorts: $sorts (length: ${sorts.length})');

    final request = const DataGridRequestBuilder(
      standard: ApiFilterStandard.voo,
      fieldPrefix: 'Site',
    ).buildRequest(page: page + 1, pageSize: pageSize, filters: filters, sorts: sorts);

    debugPrint('  - Built request: $request');

    // Mock response
    return VooDataGridResponse(
      rows: [
        OrderList(siteNumber: '1001', siteName: 'Alpha', status: 'Active'),
        OrderList(siteNumber: '1002', siteName: 'Beta', status: 'Pending'),
      ],
      totalRows: 2,
      page: page,
      pageSize: pageSize,
    );
  }
}

// Mock OrderList class
class OrderList {
  final String siteNumber;
  final String siteName;
  final String status;

  OrderList({required this.siteNumber, required this.siteName, required this.status});
}

void main() {
  test('Debug sorting issue - check if sorts reach fetchRemoteData', () async {
    final dataSource = OrderRepositoryImpl();

    // Check initial state
    debugPrint('\n=== Initial Load ===');
    await dataSource.loadData();

    // Apply a sort
    debugPrint('\n=== Applying Sort ===');
    dataSource.applySort('siteNumber', VooSortDirection.ascending);

    // Check dataSource sorts after applying
    debugPrint('DataSource sorts after applySort: ${dataSource.sorts}');

    debugPrint('\n=== Loading After Sort ===');
    await dataSource.loadData();

    // Verify sorts are in dataSource
    expect(dataSource.sorts.length, equals(1));
    expect(dataSource.sorts.first.field, equals('siteNumber'));
    expect(dataSource.sorts.first.direction, equals(VooSortDirection.ascending));
  });

  testWidgets('Debug sorting with controller and columns', (tester) async {
    final dataSource = OrderRepositoryImpl();

    final controller = VooDataGridController<OrderList>(
      dataSource: dataSource,
      columns: [
        VooDataColumn<OrderList>(field: 'siteNumber', label: 'Site Number', valueGetter: (row) => row.siteNumber),
        VooDataColumn<OrderList>(field: 'siteName', label: 'Site Name', valueGetter: (row) => row.siteName),
        VooDataColumn<OrderList>(
          field: 'status',
          label: 'Status',
          sortable: false, // This column is not sortable
          valueGetter: (row) => row.status,
        ),
      ],
    );

    // Initial load
    debugPrint('\n=== Initial Load with Controller ===');
    await dataSource.loadData();

    // Simulate column header click
    debugPrint('\n=== Simulating Column Sort ===');
    debugPrint('Column sortable? ${controller.columns[0].sortable}');
    debugPrint('DataSource sorts before: ${dataSource.sorts}');

    controller.sortColumn('siteNumber');

    debugPrint('DataSource sorts after: ${dataSource.sorts}');

    // Wait for async operations
    await tester.pumpAndSettle();

    // Verify sorts were applied
    expect(dataSource.sorts.length, equals(1));
    expect(dataSource.sorts.first.field, equals('siteNumber'));

    controller.dispose();
  });
}
