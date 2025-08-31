/// Common types used across VooDataGrid
/// 
/// These types are shared between the legacy ChangeNotifier-based
/// implementation and the new state-management agnostic implementation.

import 'package:voo_data_grid/src/domain/entities/data_grid_column.dart';

/// Data grid operation mode
enum VooDataGridMode {
  /// All operations (filtering, sorting, pagination) are handled locally
  local,

  /// All operations are handled remotely via API
  remote,

  /// Filtering and sorting are local, but data fetching is remote
  mixed,
}

/// Response from data source
///
/// Generic type parameter T represents the row data type.
class VooDataGridResponse<T> {
  final List<T> rows;
  final int totalRows;
  final int page;
  final int pageSize;

  const VooDataGridResponse({
    required this.rows,
    required this.totalRows,
    required this.page,
    required this.pageSize,
  });
}

/// Data filter for a column
class VooDataFilter {
  final VooFilterOperator operator;
  final dynamic value;
  final dynamic valueTo; // For range filters

  const VooDataFilter({
    required this.operator,
    required this.value,
    this.valueTo,
  });
}

/// Selection mode for data grid
enum VooSelectionMode {
  none,
  single,
  multiple,
}