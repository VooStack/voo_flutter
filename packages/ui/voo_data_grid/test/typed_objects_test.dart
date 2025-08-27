import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

// Test model class - mimics the OrderList that was causing issues
class TestModel {
  final String id;
  final String siteNumber;
  final String name;
  final double amount;

  TestModel({
    required this.id,
    required this.siteNumber,
    required this.name,
    required this.amount,
  });
}

// Test data source
class TestTypedDataSource extends VooDataGridSource {
  TestTypedDataSource() : super(mode: VooDataGridMode.local);

  @override
  Future<VooDataGridResponse> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    // Not used in local mode
    return VooDataGridResponse(
      rows: [],
      totalRows: 0,
      page: page,
      pageSize: pageSize,
    );
  }
}

void main() {
  group('VooDataGrid Typed Objects Support', () {
    test('should handle typed objects with valueGetter', () {
      // Create test data
      final testData = [
        TestModel(
            id: '1', siteNumber: 'SITE001', name: 'Test 1', amount: 100.0),
        TestModel(
            id: '2', siteNumber: 'SITE002', name: 'Test 2', amount: 200.0),
        TestModel(
            id: '3', siteNumber: 'SITE003', name: 'Test 3', amount: 300.0),
      ];

      // Create data source
      final dataSource = TestTypedDataSource();
      dataSource.setLocalData(testData);

      // Create columns with valueGetter (REQUIRED for typed objects)
      final columns = [
        VooDataColumn(
          field: 'id',
          label: 'ID',
          valueGetter: (row) => (row as TestModel).id,
        ),
        VooDataColumn(
          field: 'siteNumber',
          label: 'Site Number',
          valueGetter: (row) => (row as TestModel).siteNumber,
        ),
        VooDataColumn(
          field: 'name',
          label: 'Name',
          valueGetter: (row) => (row as TestModel).name,
        ),
        VooDataColumn(
          field: 'amount',
          label: 'Amount',
          valueGetter: (row) => (row as TestModel).amount,
        ),
      ];

      // Load data
      dataSource.loadData();

      // Verify data is loaded
      expect(dataSource.rows.length, 3);
      expect(dataSource.rows[0], isA<TestModel>());

      // Test that valueGetter works
      final firstRow = dataSource.rows[0];
      expect(columns[0].valueGetter!(firstRow), '1'); // ID column
      expect(
          columns[1].valueGetter!(firstRow), 'SITE001'); // Site Number column
      expect(columns[2].valueGetter!(firstRow), 'Test 1'); // Name column
      expect(columns[3].valueGetter!(firstRow), 100.0); // Amount column
    });

    test('should work with Map objects without valueGetter', () {
      // Create test data as Maps
      final testData = [
        {'id': '1', 'siteNumber': 'SITE001', 'name': 'Test 1', 'amount': 100.0},
        {'id': '2', 'siteNumber': 'SITE002', 'name': 'Test 2', 'amount': 200.0},
        {'id': '3', 'siteNumber': 'SITE003', 'name': 'Test 3', 'amount': 300.0},
      ];

      // Create data source
      final dataSource = TestTypedDataSource();
      dataSource.setLocalData(testData);

      // Load data
      dataSource.loadData();

      // Verify data is loaded
      expect(dataSource.rows.length, 3);
      expect(dataSource.rows[0], isA<Map>());

      // Map objects can be accessed with bracket notation
      final firstRow = dataSource.rows[0] as Map;
      expect(firstRow['id'], '1');
      expect(firstRow['siteNumber'], 'SITE001');
      expect(firstRow['name'], 'Test 1');
      expect(firstRow['amount'], 100.0);
    });

    test('demonstrates typed object filtering limitation', () {
      // Create test data
      final testData = [
        TestModel(
            id: '1', siteNumber: 'SITE001', name: 'Test Alpha', amount: 100.0),
        TestModel(
            id: '2', siteNumber: 'SITE002', name: 'Test Beta', amount: 200.0),
        TestModel(
            id: '3', siteNumber: 'SITE003', name: 'Test Gamma', amount: 300.0),
      ];

      // Create data source
      final dataSource = TestTypedDataSource();
      dataSource.setLocalData(testData);
      dataSource.loadData();

      // Initial count
      expect(dataSource.rows.length, 3);

      // NOTE: Filtering typed objects in local mode won't work without valueGetter
      // because the internal _getFieldValue method returns null for typed objects.
      // This is why valueGetter is REQUIRED in column definitions for typed objects.

      // For filtering to work with typed objects, you would need to:
      // 1. Use Map objects instead of typed objects, OR
      // 2. Implement custom filtering in fetchRemoteData for remote mode

      // This demonstrates the limitation:
      dataSource.applyFilter(
          'name',
          const VooDataFilter(
            operator: VooFilterOperator.contains,
            value: 'Beta',
          ));

      // Filter doesn't work on typed objects in local mode without proper field access
      // The rows would be empty because _getFieldValue returns null
      expect(dataSource.rows.length, 0); // All rows filtered out
    });
  });
}
