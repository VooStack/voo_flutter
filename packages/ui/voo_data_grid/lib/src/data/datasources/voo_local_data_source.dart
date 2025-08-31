import 'package:voo_data_grid/src/data/datasources/data_grid_source.dart';
import 'package:voo_data_grid/src/domain/entities/data_grid_types.dart';

/// Local data source implementation for VooDataGrid
/// 
/// This data source works with in-memory data and provides
/// client-side filtering, sorting, and pagination.
class VooLocalDataSource<T> extends VooDataGridSource<T> {
  /// Constructor
  VooLocalDataSource({
    required List<T> data,
    VooSelectionMode selectionMode = VooSelectionMode.none,
  }) : super(mode: VooDataGridMode.local) {
    setSelectionMode(selectionMode);
    setLocalData(data);
  }
}