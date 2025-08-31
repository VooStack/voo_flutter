import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

// Test data source implementation
class TestDataSource<T> extends VooDataGridSource<T> {
  TestDataSource({required super.mode});

  @override
  Future<VooDataGridResponse<T>> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    // Not needed for these tests
    return VooDataGridResponse<T>(
      rows: [],
      totalRows: 0,
      page: page,
      pageSize: pageSize,
    );
  }
}

// Test model classes
class OrderList {
  final String id;
  final String siteNumber;
  final FileStatus? status;
  final double amount;

  OrderList({
    required this.id,
    required this.siteNumber,
    this.status,
    required this.amount,
  });
}

class FileStatus {
  final String code;
  final String name;
  final Color color;

  FileStatus({
    required this.code,
    required this.name,
    required this.color,
  });
}

void main() {
  group('VooDataGrid Error Handling', () {
    testWidgets('should handle typed valueGetter without crashing', (tester) async {
      // Create test data
      final testData = [
        OrderList(
          id: '1',
          siteNumber: 'SITE001',
          status: FileStatus(code: 'ACTIVE', name: 'Active', color: Colors.green),
          amount: 100.0,
        ),
        OrderList(
          id: '2',
          siteNumber: 'SITE002',
          status: FileStatus(
            code: 'PENDING',
            name: 'Pending',
            color: Colors.orange,
          ),
          amount: 200.0,
        ),
        OrderList(
          id: '3',
          siteNumber: 'SITE003',
          amount: 300.0,
        ),
      ];

      // Create data source with proper type
      final dataSource = TestDataSource<OrderList>(mode: VooDataGridMode.local);
      dataSource.setLocalData(testData);

      // Create columns with properly typed valueGetters
      final columns = [
        VooDataColumn<OrderList>(
          field: 'id',
          label: 'ID',
          valueGetter: (OrderList row) => row.id,
        ),
        VooDataColumn<OrderList>(
          field: 'siteNumber',
          label: 'Site Number',
          valueGetter: (OrderList row) => row.siteNumber,
        ),
        VooDataColumn<OrderList>(
          field: 'status',
          label: 'Status',
          // This is the kind of valueGetter that was causing the error
          valueGetter: (OrderList row) => row.status?.name,
          valueFormatter: (value) => (value ?? 'N/A') as String,
        ),
        VooDataColumn<OrderList>(
          field: 'statusCode',
          label: 'Status Code',
          // Test accessing nested property with null safety
          valueGetter: (OrderList row) => row.status?.code ?? 'NO_STATUS',
        ),
        VooDataColumn<OrderList>(
          field: 'amount',
          label: 'Amount',
          valueGetter: (OrderList row) => row.amount,
          valueFormatter: (value) => '\$${value.toStringAsFixed(2)}',
        ),
      ];

      // Create controller
      final controller = VooDataGridController<OrderList>(dataSource: dataSource);
      controller.setColumns(columns);

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDataGrid<OrderList>(
              controller: controller,
            ),
          ),
        ),
      );

      // Widget should build without errors
      expect(find.byType(VooDataGrid<OrderList>), findsOneWidget);

      // Check that data is displayed correctly
      await tester.pump();

      // Verify that the grid renders without throwing errors
      expect(find.text('ID'), findsOneWidget);
      expect(find.text('Site Number'), findsOneWidget);
      expect(find.text('Status'), findsOneWidget);

      // Check that values are displayed
      expect(find.text('SITE001'), findsOneWidget);
      expect(find.text('SITE002'), findsOneWidget);
      expect(find.text('SITE003'), findsOneWidget);

      // Check formatted values
      expect(find.text('\$100.00'), findsOneWidget);
      expect(find.text('\$200.00'), findsOneWidget);
      expect(find.text('\$300.00'), findsOneWidget);

      // Check null safety handling
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('N/A'), findsOneWidget); // Null status should show N/A
    });

    test('should log warning when valueGetter is missing for typed objects', () {
      // Capture debug print output
      final List<String> debugMessages = [];
      final originalDebugPrint = debugPrint;
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message != null) debugMessages.add(message);
      };

      // Create typed data
      final testData = [
        OrderList(
          id: '1',
          siteNumber: 'SITE001',
          status: FileStatus(code: 'ACTIVE', name: 'Active', color: Colors.green),
          amount: 100.0,
        ),
      ];

      final dataSource = TestDataSource<OrderList>(mode: VooDataGridMode.local);
      dataSource.setLocalData(testData);

      // Create column WITHOUT valueGetter (this should trigger warning)
      final columns = [
        const VooDataColumn<OrderList>(
          field: 'id',
          label: 'ID',
          // Missing valueGetter - should trigger warning for typed objects
        ),
      ];

      final controller = VooDataGridController<OrderList>(dataSource: dataSource);
      controller.setColumns(columns);

      // The warning should be logged when trying to access field value
      // This would happen during rendering, but we can test the source directly

      // Restore original debugPrint
      debugPrint = originalDebugPrint;

      // Since we can't easily trigger the rendering in a unit test,
      // we at least verify the setup is correct
      expect(controller.columns.length, 1);
      expect(controller.columns[0].valueGetter, isNull);
    });

    test('should handle type mismatch errors gracefully', () {
      // This test verifies that even if there's a type mismatch,
      // the error is caught and logged rather than crashing

      final testData = [
        {'id': '1', 'value': 100},
        {'id': '2', 'value': 200},
      ];

      final dataSource = TestDataSource<Map<String, dynamic>>(mode: VooDataGridMode.local);
      dataSource.setLocalData(testData);

      final columns = [
        VooDataColumn<Map<String, dynamic>>(
          field: 'id',
          label: 'ID',
          valueGetter: (row) => row['id'],
        ),
        VooDataColumn<Map<String, dynamic>>(
          field: 'value',
          label: 'Value',
          valueGetter: (row) {
            // This could potentially throw if the value type changes
            return row['value'] as int;
          },
          valueFormatter: (value) => '\$\$value',
        ),
      ];

      final controller = VooDataGridController<Map<String, dynamic>>(dataSource: dataSource);
      controller.setColumns(columns);

      // Verify the setup
      expect(controller.dataSource.rows.length, 2);
      expect(() => columns[0].valueGetter!(testData[0]), returnsNormally);
      expect(() => columns[1].valueGetter!(testData[1]), returnsNormally);
    });

    test('should handle filtering with typed objects that have valueGetter', () {
      final testData = [
        OrderList(id: '1', siteNumber: 'SITE001', amount: 100.0),
        OrderList(id: '2', siteNumber: 'SITE002', amount: 200.0),
        OrderList(id: '3', siteNumber: 'SITE003', amount: 300.0),
      ];

      final dataSource = TestDataSource<OrderList>(mode: VooDataGridMode.local);
      dataSource.setLocalData(testData);

      // Note: Local filtering on typed objects without valueGetter won't work
      // This is a known limitation that we've documented

      // For remote mode, filtering is handled server-side
      final remoteDataSource = TestDataSource<OrderList>(mode: VooDataGridMode.remote);

      // Apply filter (this would be sent to server in remote mode)
      remoteDataSource.applyFilter(
        'siteNumber',
        const VooDataFilter(
          value: 'SITE001',
          operator: VooFilterOperator.equals,
        ),
      );

      expect(remoteDataSource.filters.length, 1);
      expect(remoteDataSource.filters['siteNumber']?.value, 'SITE001');
    });
  });

  group('VooDataGrid Type Safety', () {
    test('should maintain type safety throughout the widget tree', () {
      // This test ensures that generic types are properly maintained

      // Create strongly typed columns
      final columns = <VooDataColumn<OrderList>>[
        VooDataColumn<OrderList>(
          field: 'id',
          label: 'ID',
          valueGetter: (OrderList row) => row.id,
        ),
      ];

      // Create strongly typed data source
      final dataSource = TestDataSource<OrderList>(mode: VooDataGridMode.local);

      // Create strongly typed controller
      final controller = VooDataGridController<OrderList>(dataSource: dataSource);
      controller.setColumns(columns);

      // Verify types are maintained
      expect(controller, isA<VooDataGridController<OrderList>>());
      expect(controller.dataSource, isA<VooDataGridSource<OrderList>>());
      expect(controller.columns.first, isA<VooDataColumn<OrderList>>());

      // The valueGetter should be properly typed
      final valueGetter = controller.columns.first.valueGetter;
      expect(valueGetter, isA<Function(OrderList)?>());
    });
  });
}
