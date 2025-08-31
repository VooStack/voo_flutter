import 'package:voo_data_grid/src/domain/entities/voo_sort_direction.dart';

/// Column sort state
class VooColumnSort {
  final String field;
  final VooSortDirection direction;

  const VooColumnSort({
    required this.field,
    required this.direction,
  });
}