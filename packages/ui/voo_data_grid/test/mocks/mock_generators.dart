import 'package:mockito/annotations.dart';
import 'package:voo_data_grid/src/presentation/controllers/voo_data_grid_controller.dart';
import 'package:voo_data_grid/src/presentation/controllers/data_grid_controller.dart';

// Generate mocks for testing
// Note: Generic classes like VooDataGridSource<T> need manual mocking
@GenerateMocks([
  VooDataGridController,
  DataGridController,
])
void main() {}