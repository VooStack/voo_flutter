import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_ui/voo_ui.dart';

// Sample data source implementation
class SampleDataSource extends VooDataGridSource {
  final List<Map<String, dynamic>> _allData = List.generate(100, (index) => {
    'id': index + 1,
    'name': 'User ${index + 1}',
    'email': 'user${index + 1}@example.com',
    'role': index % 3 == 0 ? 'Admin' : (index % 2 == 0 ? 'Editor' : 'Viewer'),
    'status': index % 4 == 0 ? 'Inactive' : 'Active',
    'created': DateTime.now().subtract(Duration(days: index * 7)),
    'salary': 50000 + (index * 1000),
  });

  @override
  Future<VooDataGridResponse> fetchData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Apply filters
    var filteredData = _allData.where((row) {
      for (final entry in filters.entries) {
        final field = entry.key;
        final filter = entry.value;
        final value = row[field];
        
        switch (filter.operator) {
          case VooFilterOperator.contains:
            if (!value.toString().toLowerCase().contains(
                filter.value.toString().toLowerCase())) {
              return false;
            }
            break;
          case VooFilterOperator.equals:
            if (value != filter.value) {
              return false;
            }
            break;
          case VooFilterOperator.greaterThanOrEqual:
            if (value is num && filter.value is num) {
              if (value < filter.value) {
                return false;
              }
            }
            break;
          case VooFilterOperator.lessThanOrEqual:
            if (value is num && filter.value is num) {
              if (value > filter.value) {
                return false;
              }
            }
            break;
          default:
            break;
        }
      }
      return true;
    }).toList();
    
    // Apply sorts
    for (final sort in sorts.reversed) {
      filteredData.sort((a, b) {
        final aValue = a[sort.field];
        final bValue = b[sort.field];
        
        int comparison;
        if (aValue is Comparable) {
          comparison = aValue.compareTo(bValue);
        } else {
          comparison = aValue.toString().compareTo(bValue.toString());
        }
        
        return sort.direction == VooSortDirection.ascending
            ? comparison
            : -comparison;
      });
    }
    
    // Apply pagination
    final totalRows = filteredData.length;
    final startIndex = page * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, totalRows);
    final paginatedData = filteredData.sublist(startIndex, endIndex);
    
    return VooDataGridResponse(
      rows: paginatedData,
      totalRows: totalRows,
      page: page,
      pageSize: pageSize,
    );
  }
}

// VooDataGrid Previews
@Preview(name: 'VooDataGrid - Basic')
Widget vooDataGridBasic() => MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Basic Data Grid')),
        body: _DataGridExample(
          columns: [
            const VooDataColumn(
              field: 'id',
              label: 'ID',
              width: 60,
              textAlign: TextAlign.center,
            ),
            const VooDataColumn(
              field: 'name',
              label: 'Name',
              width: 150,
            ),
            const VooDataColumn(
              field: 'email',
              label: 'Email',
              width: 200,
            ),
            const VooDataColumn(
              field: 'role',
              label: 'Role',
              width: 100,
            ),
          ],
        ),
      ),
    );

@Preview(name: 'VooDataGrid - With Filters')
Widget vooDataGridWithFilters() => MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Data Grid with Filters')),
        body: _DataGridExample(
          showFilters: true,
          columns: [
            const VooDataColumn(
              field: 'id',
              label: 'ID',
              width: 60,
              filterable: false,
              textAlign: TextAlign.center,
            ),
            const VooDataColumn(
              field: 'name',
              label: 'Name',
              width: 150,
              dataType: VooDataColumnType.text,
            ),
            const VooDataColumn(
              field: 'email',
              label: 'Email',
              width: 200,
              dataType: VooDataColumnType.text,
            ),
            const VooDataColumn(
              field: 'role',
              label: 'Role',
              width: 100,
              dataType: VooDataColumnType.select,
              filterOptions: [
                VooFilterOption(value: 'Admin', label: 'Admin'),
                VooFilterOption(value: 'Editor', label: 'Editor'),
                VooFilterOption(value: 'Viewer', label: 'Viewer'),
              ],
            ),
            const VooDataColumn(
              field: 'status',
              label: 'Status',
              width: 100,
              dataType: VooDataColumnType.select,
              filterOptions: [
                VooFilterOption(value: 'Active', label: 'Active'),
                VooFilterOption(value: 'Inactive', label: 'Inactive'),
              ],
            ),
          ],
        ),
      ),
    );

@Preview(name: 'VooDataGrid - Custom Cell Rendering')
Widget vooDataGridCustomCells() => MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Custom Cell Rendering')),
        body: _DataGridExample(
          columns: [
            const VooDataColumn(
              field: 'id',
              label: 'ID',
              width: 60,
              textAlign: TextAlign.center,
            ),
            const VooDataColumn(
              field: 'name',
              label: 'Name',
              width: 150,
            ),
            VooDataColumn(
              field: 'status',
              label: 'Status',
              width: 120,
              cellBuilder: (context, value, row) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: value == 'Active' ? Colors.green.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  value.toString(),
                  style: TextStyle(
                    color: value == 'Active' ? Colors.green.shade800 : Colors.red.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            VooDataColumn(
              field: 'salary',
              label: 'Salary',
              width: 120,
              textAlign: TextAlign.right,
              valueFormatter: (value) => '\$${value.toString().replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (Match m) => '${m[1]},',
              )}',
            ),
          ],
        ),
      ),
    );

@Preview(name: 'VooDataGrid - With Selection')
Widget vooDataGridWithSelection() => MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Data Grid with Selection')),
        body: _DataGridExample(
          selectionMode: VooSelectionMode.multiple,
          columns: [
            const VooDataColumn(
              field: 'id',
              label: 'ID',
              width: 60,
              textAlign: TextAlign.center,
            ),
            const VooDataColumn(
              field: 'name',
              label: 'Name',
              width: 150,
            ),
            const VooDataColumn(
              field: 'email',
              label: 'Email',
              width: 200,
            ),
            const VooDataColumn(
              field: 'role',
              label: 'Role',
              width: 100,
            ),
          ],
        ),
      ),
    );

@Preview(name: 'VooDataGrid - Frozen Columns')
Widget vooDataGridFrozenColumns() => MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Frozen Columns')),
        body: _DataGridExample(
          columns: [
            const VooDataColumn(
              field: 'id',
              label: 'ID',
              width: 60,
              frozen: true,
              textAlign: TextAlign.center,
            ),
            const VooDataColumn(
              field: 'name',
              label: 'Name',
              width: 150,
              frozen: true,
            ),
            const VooDataColumn(
              field: 'email',
              label: 'Email',
              width: 200,
            ),
            const VooDataColumn(
              field: 'role',
              label: 'Role',
              width: 100,
            ),
            const VooDataColumn(
              field: 'status',
              label: 'Status',
              width: 100,
            ),
            const VooDataColumn(
              field: 'created',
              label: 'Created',
              width: 150,
            ),
            const VooDataColumn(
              field: 'salary',
              label: 'Salary',
              width: 120,
            ),
          ],
        ),
      ),
    );

// Helper widget for examples
class _DataGridExample extends StatefulWidget {
  final List<VooDataColumn> columns;
  final bool showFilters;
  final VooSelectionMode selectionMode;

  const _DataGridExample({
    required this.columns,
    this.showFilters = false,
    this.selectionMode = VooSelectionMode.none,
  });

  @override
  State<_DataGridExample> createState() => _DataGridExampleState();
}

class _DataGridExampleState extends State<_DataGridExample> {
  late final SampleDataSource _dataSource;
  late final VooDataGridController _controller;

  @override
  void initState() {
    super.initState();
    _dataSource = SampleDataSource();
    _dataSource.setSelectionMode(widget.selectionMode);
    _controller = VooDataGridController(
      dataSource: _dataSource,
      columns: widget.columns,
      showFilters: widget.showFilters,
      alternatingRowColors: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _dataSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: VooDataGrid(
        controller: _controller,
        onRowTap: (row) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tapped: ${row['name']}'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }
}