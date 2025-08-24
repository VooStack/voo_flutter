import 'package:flutter/material.dart';
import 'package:voo_ui/voo_ui.dart';

class DataGridExample extends StatefulWidget {
  const DataGridExample({super.key});

  @override
  State<DataGridExample> createState() => _DataGridExampleState();
}

class _DataGridExampleState extends State<DataGridExample> {
  late final UserDataSource _localDataSource;
  late final RemoteUserDataSource _remoteDataSource;
  late final VooDataGridController _localController;
  late final VooDataGridController _remoteController;

  VooDataGridMode _currentMode = VooDataGridMode.local;

  @override
  void initState() {
    super.initState();

    // Initialize local data source with sample data
    _localDataSource = UserDataSource();
    _localDataSource.loadSampleData();
    _localController = VooDataGridController(dataSource: _localDataSource);
    _localController.setColumns(_columns);

    // Initialize remote data source
    _remoteDataSource = RemoteUserDataSource();
    _remoteController = VooDataGridController(dataSource: _remoteDataSource);
    _remoteController.setColumns(_columns);
  }

  @override
  void dispose() {
    _localController.dispose();
    _remoteController.dispose();
    _localDataSource.dispose();
    _remoteDataSource.dispose();
    super.dispose();
  }

  List<VooDataColumn> get _columns => [
        VooDataColumn(
          field: 'id',
          label: 'ID',
          width: 80,
          frozen: true,
          dataType: VooDataColumnType.number,
        ),
        VooDataColumn(
          field: 'name',
          label: 'Name',
          dataType: VooDataColumnType.text,
          filterHint: 'Search by name...',
        ),
        VooDataColumn(
          field: 'email',
          label: 'Email',
          dataType: VooDataColumnType.text,
          filterHint: 'Search by email...',
        ),
        VooDataColumn(
          field: 'role',
          label: 'Role',
          dataType: VooDataColumnType.select,
          filterOptions: [
            VooFilterOption(value: 'admin', label: 'Admin'),
            VooFilterOption(value: 'user', label: 'User'),
            VooFilterOption(value: 'moderator', label: 'Moderator'),
            VooFilterOption(value: 'editor', label: 'Editor'),
          ],
        ),
        VooDataColumn(
          field: 'department',
          label: 'Department',
          dataType: VooDataColumnType.select,
          filterOptions: [
            VooFilterOption(value: 'engineering', label: 'Engineering'),
            VooFilterOption(value: 'design', label: 'Design'),
            VooFilterOption(value: 'marketing', label: 'Marketing'),
            VooFilterOption(value: 'sales', label: 'Sales'),
            VooFilterOption(value: 'hr', label: 'Human Resources'),
          ],
        ),
        VooDataColumn(
          field: 'status',
          label: 'Status',
          dataType: VooDataColumnType.select,
          filterOptions: [
            VooFilterOption(value: 'active', label: 'Active'),
            VooFilterOption(value: 'inactive', label: 'Inactive'),
            VooFilterOption(value: 'pending', label: 'Pending'),
          ],
          cellBuilder: (context, value, row) {
            final color = switch (value) {
              'active' => Colors.green,
              'inactive' => Colors.grey,
              'pending' => Colors.orange,
              _ => Colors.grey,
            };
            return Row(
              children: [
                Icon(Icons.circle, size: 10, color: color),
                const SizedBox(width: 8),
                Text(
                  value?.toString() ?? '',
                  style: TextStyle(color: color),
                ),
              ],
            );
          },
        ),
        VooDataColumn(
          field: 'salary',
          label: 'Salary',
          dataType: VooDataColumnType.number,
          valueFormatter: (value) {
            if (value is num) {
              return '\$${value.toStringAsFixed(0)}';
            }
            return '';
          },
        ),
        VooDataColumn(
          field: 'joinDate',
          label: 'Join Date',
          dataType: VooDataColumnType.date,
          valueFormatter: (value) {
            if (value is DateTime) {
              return '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
            }
            return '';
          },
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Grid Example'),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: design.spacingMd),
            child: SegmentedButton<VooDataGridMode>(
              segments: const [
                ButtonSegment(
                  value: VooDataGridMode.local,
                  label: Text('Local'),
                  icon: Icon(Icons.computer),
                ),
                ButtonSegment(
                  value: VooDataGridMode.remote,
                  label: Text('Remote'),
                  icon: Icon(Icons.cloud),
                ),
                ButtonSegment(
                  value: VooDataGridMode.mixed,
                  label: Text('Mixed'),
                  icon: Icon(Icons.sync),
                ),
              ],
              selected: {_currentMode},
              onSelectionChanged: (Set<VooDataGridMode> selection) {
                setState(() {
                  _currentMode = selection.first;
                });
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(design.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VooCard(
              child: Padding(
                padding: EdgeInsets.all(design.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mode: ${_currentMode.name.toUpperCase()}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: design.spacingSm),
                    Text(
                      _getModeDescription(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: design.spacingLg),
            Expanded(
              child: VooCard(
                child: Padding(
                  padding: EdgeInsets.all(design.spacingMd),
                  child: VooDataGrid(
                    controller: _currentMode == VooDataGridMode.local ? _localController : _remoteController,
                    onRowTap: (row) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Tapped on ${row['name']}'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getModeDescription() {
    return switch (_currentMode) {
      VooDataGridMode.local => 'All operations (filtering, sorting, pagination) are handled locally. Best for small datasets.',
      VooDataGridMode.remote => 'All operations are sent to the server. Best for large datasets with server-side processing.',
      VooDataGridMode.mixed => 'Data is fetched from server once, then filtered and sorted locally. Good balance for medium datasets.',
    };
  }
}

// Local data source
class UserDataSource extends VooDataGridSource {
  UserDataSource() : super(mode: VooDataGridMode.local);

  void loadSampleData() {
    final List<Map<String, dynamic>> sampleData = List.generate(100, (index) {
      return {
        'id': index + 1,
        'name': 'User ${index + 1}',
        'email': 'user${index + 1}@example.com',
        'role': ['admin', 'user', 'moderator', 'editor'][index % 4],
        'department': ['engineering', 'design', 'marketing', 'sales', 'hr'][index % 5],
        'status': ['active', 'inactive', 'pending'][index % 3],
        'salary': 50000 + (index * 1000),
        'joinDate': DateTime.now().subtract(Duration(days: index * 10)),
      };
    });

    setLocalData(sampleData);
  }
}

// Remote data source (simulated)
class RemoteUserDataSource extends VooDataGridSource {
  RemoteUserDataSource() : super(mode: VooDataGridMode.remote);

  @override
  Future<VooDataGridResponse> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Generate mock data based on filters
    final totalRows = 1000;
    final startIndex = page * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, totalRows);

    final List<Map<String, dynamic>> rows = [];
    for (int i = startIndex; i < endIndex; i++) {
      final row = {
        'id': i + 1,
        'name': 'Remote User ${i + 1}',
        'email': 'remote.user${i + 1}@example.com',
        'role': ['admin', 'user', 'moderator', 'editor'][i % 4],
        'department': ['engineering', 'design', 'marketing', 'sales', 'hr'][i % 5],
        'status': ['active', 'inactive', 'pending'][i % 3],
        'salary': 60000 + (i * 1500),
        'joinDate': DateTime.now().subtract(Duration(days: i * 15)),
      };

      // Apply filters (simplified for demo)
      bool matchesFilters = true;
      filters.forEach((field, filter) {
        if (filter.value != null && filter.value.toString().isNotEmpty) {
          final fieldValue = row[field]?.toString().toLowerCase() ?? '';
          final filterValue = filter.value.toString().toLowerCase();
          if (!fieldValue.contains(filterValue)) {
            matchesFilters = false;
          }
        }
      });

      if (matchesFilters) {
        rows.add(row);
      }
    }

    return VooDataGridResponse(
      rows: rows,
      totalRows: totalRows,
      page: page,
      pageSize: pageSize,
    );
  }
}
