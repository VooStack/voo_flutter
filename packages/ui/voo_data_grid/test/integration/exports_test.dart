import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

void main() {
  group('VooDataGrid exports', () {
    test('exports are available', () {
      // Test that main classes are exported and can be referenced
      expect(VooDataColumn, isNotNull);
      expect(VooDataGridMode, isNotNull);
      expect(VooDataGridSource, isNotNull);
      expect(VooDataGridController, isNotNull);
    });
  });
}