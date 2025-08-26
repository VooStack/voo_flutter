import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_data_grid/preview/voo_data_grid_preview.dart';

@Preview(name: 'Basic Data Grid')
Widget basicDataGridPreview() {
  return const VooDataGridBasicPreview();
}

@Preview(name: 'Filterable Data Grid')
Widget filterableDataGridPreview() {
  return const VooDataGridFilterablePreview();
}

@Preview(name: 'Selectable Data Grid')
Widget selectableDataGridPreview() {
  return const VooDataGridSelectablePreview();
}

@Preview(name: 'Paginated Data Grid')
Widget paginatedDataGridPreview() {
  return const VooDataGridPaginatedPreview();
}
