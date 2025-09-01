import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

/// Test data for grid rows
final List<Map<String, dynamic>> testGridData = List.generate(
  100,
  (index) => {
    'id': index + 1,
    'name': 'Item ${index + 1}',
    'price': (index + 1) * 10.0,
    'status': index % 2 == 0 ? 'active' : 'inactive',
    'category': ['Electronics', 'Clothing', 'Food'][index % 3],
    'quantity': (index + 1) * 5,
    'date': DateTime.now().subtract(Duration(days: index)),
    'description': 'Description for item ${index + 1}',
    'isAvailable': index % 2 == 0,
  },
);

/// Small test dataset for quick tests
final List<Map<String, dynamic>> smallTestData = testGridData.take(10).toList();

/// Test columns configuration
final List<VooDataColumn> testColumns = [
  const VooDataColumn(
    field: 'id',
    label: 'ID',
    width: 60,
    frozen: true,
  ),
  const VooDataColumn(
    field: 'name',
    label: 'Name',
    width: 150,
  ),
  const VooDataColumn(
    field: 'price',
    label: 'Price',
    width: 100,
    textAlign: TextAlign.right,
  ),
  const VooDataColumn(
    field: 'status',
    label: 'Status',
    width: 100,
  ),
  const VooDataColumn(
    field: 'category',
    label: 'Category',
    width: 120,
  ),
  const VooDataColumn(
    field: 'quantity',
    label: 'Quantity',
    width: 100,
    textAlign: TextAlign.right,
  ),
];

/// Test columns for Map<String, dynamic> data
final List<VooDataColumn<Map<String, dynamic>>> testColumnsTyped = [
  const VooDataColumn<Map<String, dynamic>>(
    field: 'id',
    label: 'ID',
    width: 60,
    frozen: true,
  ),
  const VooDataColumn<Map<String, dynamic>>(
    field: 'name',
    label: 'Name',
    width: 150,
  ),
  const VooDataColumn<Map<String, dynamic>>(
    field: 'price',
    label: 'Price',
    width: 100,
    textAlign: TextAlign.right,
  ),
  const VooDataColumn<Map<String, dynamic>>(
    field: 'status',
    label: 'Status',
    width: 100,
  ),
  const VooDataColumn<Map<String, dynamic>>(
    field: 'category',
    label: 'Category',
    width: 120,
  ),
  const VooDataColumn<Map<String, dynamic>>(
    field: 'quantity',
    label: 'Quantity',
    width: 100,
    textAlign: TextAlign.right,
  ),
];

/// Minimal columns for simple tests
final List<VooDataColumn> minimalColumns = [
  const VooDataColumn(
    field: 'id',
    label: 'ID',
    width: 60,
  ),
  const VooDataColumn(
    field: 'name',
    label: 'Name',
    width: 150,
  ),
];

/// Create test filter
VooDataFilter createTestFilter({
  VooFilterOperator operator = VooFilterOperator.contains,
  dynamic value = 'test',
  dynamic valueTo,
}) =>
    VooDataFilter(
      operator: operator,
      value: value,
      valueTo: valueTo,
    );

/// Create test sort
VooColumnSort createTestSort({
  String field = 'id',
  VooSortDirection direction = VooSortDirection.ascending,
}) =>
    VooColumnSort(
      field: field,
      direction: direction,
    );

/// Create test grid response
VooDataGridResponse createTestResponse({
  List<dynamic>? rows,
  int? totalRows,
  int page = 1,
  int pageSize = 10,
}) =>
    VooDataGridResponse(
      rows: rows ?? smallTestData,
      totalRows: totalRows ?? smallTestData.length,
      page: page,
      pageSize: pageSize,
    );