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
    _localController = VooDataGridController(
      dataSource: _localDataSource,
      showFilters: false, // Filters will be shown via bottom sheet on mobile
    );
    _localController.setColumns(_columns);

    // Initialize remote data source
    _remoteDataSource = RemoteUserDataSource();
    _remoteController = VooDataGridController(
      dataSource: _remoteDataSource,
      showFilters: false, // Filters will be shown via bottom sheet on mobile
    );
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Grid Example'),
        actions: [
          if (!isMobile)
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
            )
          else
            PopupMenuButton<VooDataGridMode>(
              icon: const Icon(Icons.more_vert),
              onSelected: (mode) {
                setState(() {
                  _currentMode = mode;
                });
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: VooDataGridMode.local,
                  child: ListTile(
                    leading: Icon(Icons.computer),
                    title: Text('Local Mode'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: VooDataGridMode.remote,
                  child: ListTile(
                    leading: Icon(Icons.cloud),
                    title: Text('Remote Mode'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: VooDataGridMode.mixed,
                  child: ListTile(
                    leading: Icon(Icons.sync),
                    title: Text('Mixed Mode'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(isMobile ? design.spacingMd : design.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMobile)
              VooCard(
                child: Padding(
                  padding: EdgeInsets.all(design.spacingMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getCurrentModeIcon(),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          SizedBox(width: design.spacingSm),
                          Text(
                            'Mode: ${_currentMode.name.toUpperCase()}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      SizedBox(height: design.spacingSm),
                      Text(
                        _getModeDescription(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (!isMobile) SizedBox(height: design.spacingLg),
            Expanded(
              child: VooCard(
                elevation: isMobile ? 0 : null,
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? design.spacingSm : design.spacingMd),
                  child: VooDataGrid(
                    controller: _currentMode == VooDataGridMode.local ? _localController : _remoteController,
                    mobilePriorityColumns: ['name', 'email', 'role', 'status'],
                    displayMode: VooDataGridDisplayMode.auto,
                    cardBuilder: isMobile ? _buildCustomCard : null,
                    onRowTap: (row) {
                      if (isMobile) {
                        _showDetailsBottomSheet(context, row);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Selected ${row['name']}'),
                            behavior: SnackBarBehavior.floating,
                            action: SnackBarAction(
                              label: 'View Details',
                              onPressed: () => _showDetailsDialog(context, row),
                            ),
                          ),
                        );
                      }
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

  IconData _getCurrentModeIcon() {
    return switch (_currentMode) {
      VooDataGridMode.local => Icons.computer,
      VooDataGridMode.remote => Icons.cloud,
      VooDataGridMode.mixed => Icons.sync,
    };
  }

  Widget _buildCustomCard(BuildContext context, dynamic row, int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final design = context.vooDesign;
    
    final statusColor = switch (row['status']) {
      'active' => Colors.green,
      'inactive' => Colors.grey,
      'pending' => Colors.orange,
      _ => Colors.grey,
    };

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: design.spacingMd),
      child: InkWell(
        onTap: () => _showDetailsBottomSheet(context, row),
        borderRadius: BorderRadius.circular(design.radiusMd),
        child: Padding(
          padding: EdgeInsets.all(design.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: colorScheme.primaryContainer,
                    child: Text(
                      row['name'].toString()[0].toUpperCase(),
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: design.spacingMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row['name'],
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          row['email'],
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: design.spacingSm,
                      vertical: design.spacingXs,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(design.radiusSm),
                      border: Border.all(
                        color: statusColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 8,
                          color: statusColor,
                        ),
                        SizedBox(width: design.spacingXs),
                        Text(
                          row['status'].toString().toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: design.spacingMd),
              Divider(height: 1),
              SizedBox(height: design.spacingMd),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoChip(
                      context,
                      Icons.work_outline,
                      row['role'].toString().toUpperCase(),
                      colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: design.spacingSm),
                  Expanded(
                    child: _buildInfoChip(
                      context,
                      Icons.business_outlined,
                      row['department'].toString().toUpperCase(),
                      colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label, Color color) {
    final design = context.vooDesign;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: design.spacingSm,
        vertical: design.spacingXs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(design.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: color),
          SizedBox(width: design.spacingXs),
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailsBottomSheet(BuildContext context, dynamic row) {
    final design = context.vooDesign;
    final theme = Theme.of(context);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(design.radiusLg),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: design.spacingMd),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.all(design.spacingLg),
                children: [
                  Text(
                    'User Details',
                    style: theme.textTheme.headlineSmall,
                  ),
                  SizedBox(height: design.spacingLg),
                  _buildDetailRow(context, 'ID', row['id'].toString()),
                  _buildDetailRow(context, 'Name', row['name']),
                  _buildDetailRow(context, 'Email', row['email']),
                  _buildDetailRow(context, 'Role', row['role']),
                  _buildDetailRow(context, 'Department', row['department']),
                  _buildDetailRow(context, 'Status', row['status']),
                  _buildDetailRow(context, 'Salary', '\$${row['salary']}'),
                  _buildDetailRow(
                    context,
                    'Join Date',
                    '${(row['joinDate'] as DateTime).year}-${(row['joinDate'] as DateTime).month.toString().padLeft(2, '0')}-${(row['joinDate'] as DateTime).day.toString().padLeft(2, '0')}',
                  ),
                  SizedBox(height: design.spacingLg),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit'),
                        ),
                      ),
                      SizedBox(width: design.spacingMd),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                          label: const Text('Close'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, dynamic row) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('User Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(context, 'ID', row['id'].toString()),
              _buildDetailRow(context, 'Name', row['name']),
              _buildDetailRow(context, 'Email', row['email']),
              _buildDetailRow(context, 'Role', row['role']),
              _buildDetailRow(context, 'Department', row['department']),
              _buildDetailRow(context, 'Status', row['status']),
              _buildDetailRow(context, 'Salary', '\$${row['salary']}'),
              _buildDetailRow(
                context,
                'Join Date',
                '${(row['joinDate'] as DateTime).year}-${(row['joinDate'] as DateTime).month.toString().padLeft(2, '0')}-${(row['joinDate'] as DateTime).day.toString().padLeft(2, '0')}',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    final design = context.vooDesign;
    final theme = Theme.of(context);
    
    return Padding(
      padding: EdgeInsets.only(bottom: design.spacingMd),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

// Local data source
class UserDataSource extends VooDataGridSource {
  UserDataSource() : super(mode: VooDataGridMode.local) {
    setSelectionMode(VooSelectionMode.multiple);
  }

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
  RemoteUserDataSource() : super(mode: VooDataGridMode.remote) {
    setSelectionMode(VooSelectionMode.multiple);
  }

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
