import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

// Test model similar to user's OrderList
class TestModel {
  final String id;
  final String? status;

  TestModel({required this.id, this.status});
}

// Custom data source
class TestDataSource extends VooDataGridSource<TestModel> {
  TestDataSource() : super(mode: VooDataGridMode.local);

  @override
  Future<VooDataGridResponse<TestModel>> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async => VooDataGridResponse<TestModel>(rows: [], totalRows: 0, page: page, pageSize: pageSize);
}

void main() {
  group('Type Inference Tests', () {
    test('columns should infer type from controller constructor', () {
      // This mimics exactly what the user is doing
      final controller = VooDataGridController<TestModel>(
        dataSource: TestDataSource(),
        columns: [
          VooDataColumn(field: 'id', label: 'ID', valueGetter: (row) => row.id),
          VooDataColumn(field: 'status', label: 'Status', valueGetter: (row) => row.status),
        ],
      );

      // Check that columns are properly typed
      expect(controller.columns, isA<List<VooDataColumn<TestModel>>>());
      expect(controller.columns.length, 2);

      // The valueGetter should be properly typed
      final firstColumn = controller.columns[0];
      expect(firstColumn.valueGetter, isA<Function?>());

      // Test that valueGetter works with the correct type
      final testData = TestModel(id: '1', status: 'active');
      final value = firstColumn.valueGetter?.call(testData);
      expect(value, '1');
    });

    test('columns without explicit type should work in constructor context', () {
      // Create controller with inline columns (no explicit type)
      final controller = VooDataGridController<TestModel>(
        dataSource: TestDataSource(),
        columns: [
          VooDataColumn(
            field: 'id',
            label: 'ID',
            valueGetter: (row) => row.id, // row should be inferred as TestModel
          ),
        ],
      );

      // Verify the column is correctly typed
      final column = controller.columns[0];
      expect(column, isA<VooDataColumn<TestModel>>());

      // Verify valueGetter has correct type
      if (column.valueGetter != null) {
        final testRow = TestModel(id: 'test');
        final result = column.valueGetter!(testRow);
        expect(result, 'test');
      }
    });

    test('explicit type annotation should match controller type', () {
      // With explicit type (what we're recommending as fix)
      final controller = VooDataGridController<TestModel>(
        dataSource: TestDataSource(),
        columns: [VooDataColumn<TestModel>(field: 'id', label: 'ID', valueGetter: (row) => row.id)],
      );

      expect(controller.columns[0], isA<VooDataColumn<TestModel>>());
    });
  });
}
