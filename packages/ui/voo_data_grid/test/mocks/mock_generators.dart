import 'package:mockito/annotations.dart';
import 'package:voo_data_grid/src/data/datasources/data_grid_source_base.dart';
import 'package:voo_data_grid/src/data/datasources/voo_local_data_source.dart';

// Generate mocks for testing
// Note: Generic classes like VooDataGridSource<T> need manual mocking
@GenerateMocks([
  DataGridSourceBase,
  VooLocalDataSource,
])
void main() {}