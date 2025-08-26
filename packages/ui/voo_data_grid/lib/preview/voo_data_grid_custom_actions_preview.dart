import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

class VooDataGridCustomActionsPreview extends StatefulWidget {
  const VooDataGridCustomActionsPreview({super.key});

  @override
  State<VooDataGridCustomActionsPreview> createState() =>
      _VooDataGridCustomActionsPreviewState();
}

class _VooDataGridCustomActionsPreviewState
    extends State<VooDataGridCustomActionsPreview> {
  late VooDataGridController _controller;
  late LocalDataGridSource _dataSource;
  final List<Map<String, dynamic>> _tasksData = [];
  String _lastAction = '';

  @override
  void initState() {
    super.initState();
    _generateTasksData();
    _initializeGrid();
  }

  void _generateTasksData() {
    final priorities = ['Critical', 'High', 'Medium', 'Low'];
    final statuses = [
      'Pending',
      'In Progress',
      'Review',
      'Completed',
      'Cancelled'
    ];
    final types = ['Bug', 'Feature', 'Enhancement', 'Documentation', 'Test'];
    final assignees = [
      'Alice Johnson',
      'Bob Smith',
      'Carol Williams',
      'David Brown',
      'Emma Davis'
    ];

    for (int i = 0; i < 100; i++) {
      _tasksData.add({
        'id': 'TASK-${1000 + i}',
        'title':
            'Task ${i + 1}: ${types[i % types.length]} - ${_getRandomTaskTitle(i)}',
        'type': types[i % types.length],
        'priority': priorities[i % priorities.length],
        'status': statuses[i % statuses.length],
        'assignee': assignees[i % assignees.length],
        'dueDate': DateTime.now().add(Duration(days: i - 50)),
        'estimatedHours': 1 + (i % 8),
        'completedHours': i % statuses.length == 3 ? 1 + (i % 8) : (i % 4),
        'description':
            'Description for task ${i + 1}. This is a sample task that needs attention.',
        'tags': _generateTags(i),
        'attachments': i % 3,
        'comments': i % 5,
        'isBlocked': i % 10 == 0,
        'isFlagged': i % 7 == 0,
      });
    }
  }

  String _getRandomTaskTitle(int index) {
    final titles = [
      'Implement user authentication',
      'Fix navigation bug',
      'Update documentation',
      'Optimize database queries',
      'Add unit tests',
      'Refactor legacy code',
      'Design new UI components',
      'Configure CI/CD pipeline',
      'Investigate performance issues',
      'Update dependencies',
    ];
    return titles[index % titles.length];
  }

  List<String> _generateTags(int index) {
    final allTags = [
      'frontend',
      'backend',
      'api',
      'database',
      'ui',
      'security',
      'performance'
    ];
    final tags = <String>[];
    for (int i = 0; i < (index % 3) + 1; i++) {
      tags.add(allTags[(index + i) % allTags.length]);
    }
    return tags;
  }

  void _initializeGrid() {
    _dataSource = LocalDataGridSource(data: _tasksData);
    _dataSource.setSelectionMode(VooSelectionMode.multiple);

    _controller = VooDataGridController(
      dataSource: _dataSource,
      columns: [
        VooDataColumn(
          field: 'id',
          label: 'ID',
          width: 100,
          sortable: true,
          cellBuilder: (context, value, row) {
            final id = row['id'] as String;
            final isBlocked = row['isBlocked'] as bool;
            final isFlagged = row['isFlagged'] as bool;

            return Row(
              children: [
                if (isBlocked)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(Icons.block, size: 14, color: Colors.red),
                  ),
                if (isFlagged)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(Icons.flag, size: 14, color: Colors.orange),
                  ),
                Expanded(
                  child: Text(
                    id,
                    style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                ),
              ],
            );
          },
        ),
        VooDataColumn(
          field: 'title',
          label: 'Title',
          flex: 3,
          sortable: true,
          filterable: true,
        ),
        VooDataColumn(
          field: 'type',
          label: 'Type',
          width: 120,
          sortable: true,
          filterable: true,
          cellBuilder: (context, value, row) {
            final type = row['type'] as String;
            final color = switch (type) {
              'Bug' => Colors.red,
              'Feature' => Colors.blue,
              'Enhancement' => Colors.green,
              'Documentation' => Colors.purple,
              'Test' => Colors.orange,
              _ => Colors.grey,
            };

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Text(
                type,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
        ),
        VooDataColumn(
          field: 'priority',
          label: 'Priority',
          width: 100,
          sortable: true,
          filterable: true,
          cellBuilder: (context, value, row) {
            final priority = row['priority'] as String;
            final icon = switch (priority) {
              'Critical' => Icons.keyboard_double_arrow_up,
              'High' => Icons.keyboard_arrow_up,
              'Medium' => Icons.remove,
              'Low' => Icons.keyboard_arrow_down,
              _ => Icons.help_outline,
            };
            final color = switch (priority) {
              'Critical' => Colors.red,
              'High' => Colors.orange,
              'Medium' => Colors.yellow,
              'Low' => Colors.green,
              _ => Colors.grey,
            };

            return Row(
              children: [
                Icon(icon, size: 16, color: color),
                SizedBox(width: 4),
                Text(
                  priority,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            );
          },
        ),
        VooDataColumn(
          field: 'status',
          label: 'Status',
          width: 120,
          sortable: true,
          filterable: true,
          cellBuilder: (context, value, row) {
            final status = row['status'] as String;
            final color = switch (status) {
              'Pending' => Colors.grey,
              'In Progress' => Colors.blue,
              'Review' => Colors.purple,
              'Completed' => Colors.green,
              'Cancelled' => Colors.red,
              _ => Colors.grey,
            };

            return Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  status,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            );
          },
        ),
        VooDataColumn(
          field: 'assignee',
          label: 'Assignee',
          width: 150,
          sortable: true,
          filterable: true,
          cellBuilder: (context, value, row) {
            final assignee = row['assignee'] as String;
            final initials = assignee
                .split(' ')
                .map((e) => e.isNotEmpty ? e[0] : '')
                .take(2)
                .join();

            return Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.blue.withValues(alpha: 0.2),
                  child: Text(
                    initials,
                    style: TextStyle(fontSize: 10, color: Colors.blue),
                  ),
                ),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    assignee,
                    style: TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          },
        ),
        VooDataColumn(
          field: 'dueDate',
          label: 'Due Date',
          width: 120,
          sortable: true,
          valueFormatter: (value) {
            final date = value as DateTime;
            final now = DateTime.now();
            final diff = date.difference(now).inDays;

            if (diff < 0) {
              return '${-diff}d overdue';
            } else if (diff == 0) {
              return 'Today';
            } else if (diff == 1) {
              return 'Tomorrow';
            } else if (diff <= 7) {
              return 'In ${diff}d';
            } else {
              return '${date.day}/${date.month}/${date.year}';
            }
          },
          cellBuilder: (context, value, row) {
            final date = row['dueDate'] as DateTime;
            final now = DateTime.now();
            final diff = date.difference(now).inDays;
            final status = row['status'] as String;

            Color textColor = Colors.black87;
            if (status != 'Completed' && status != 'Cancelled') {
              if (diff < 0) {
                textColor = Colors.red;
              } else if (diff <= 3) {
                textColor = Colors.orange;
              }
            }

            return Text(
              value,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: diff < 0 ? FontWeight.bold : FontWeight.normal,
              ),
            );
          },
        ),
        VooDataColumn(
          field: 'progress',
          label: 'Progress',
          width: 100,
          cellBuilder: (context, value, row) {
            final estimated = row['estimatedHours'] as int;
            final completed = row['completedHours'] as int;
            final progress =
                estimated > 0 ? (completed / estimated).clamp(0.0, 1.0) : 0.0;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(fontSize: 10),
                ),
                SizedBox(height: 2),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation(
                    progress >= 1.0
                        ? Colors.green
                        : progress >= 0.5
                            ? Colors.blue
                            : Colors.orange,
                  ),
                  minHeight: 3,
                ),
              ],
            );
          },
        ),
        VooDataColumn(
          field: 'tags',
          label: 'Tags',
          width: 150,
          cellBuilder: (context, value, row) {
            final tags = row['tags'] as List<String>;

            return Wrap(
              spacing: 4,
              runSpacing: 2,
              children: tags.map((tag) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(fontSize: 10, color: Colors.blue),
                  ),
                );
              }).toList(),
            );
          },
        ),
        VooDataColumn(
          field: 'actions',
          label: 'Actions',
          width: 150,
          cellBuilder: (context, value, row) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, size: 16),
                  onPressed: () => _performAction('Edit', row),
                  tooltip: 'Edit',
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints.tight(Size(24, 24)),
                ),
                IconButton(
                  icon: Icon(Icons.content_copy, size: 16),
                  onPressed: () => _performAction('Duplicate', row),
                  tooltip: 'Duplicate',
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints.tight(Size(24, 24)),
                ),
                IconButton(
                  icon: Icon(Icons.archive, size: 16),
                  onPressed: () => _performAction('Archive', row),
                  tooltip: 'Archive',
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints.tight(Size(24, 24)),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, size: 16),
                  onSelected: (value) => _performAction(value, row),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints.tight(Size(24, 24)),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                        value: 'View Details', child: Text('View Details')),
                    PopupMenuItem(
                        value: 'Add Comment', child: Text('Add Comment')),
                    PopupMenuItem(
                        value: 'Assign To', child: Text('Assign To...')),
                    PopupMenuItem(
                        value: 'Change Status', child: Text('Change Status')),
                    PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'Delete',
                      child:
                          Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
      showFilters: true,
    );

    _dataSource.loadData();
  }

  void _performAction(String action, Map<String, dynamic> row) {
    setState(() {
      _lastAction = '$action: ${row['id']}';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action performed on ${row['id']}'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _performBulkAction(String action) {
    final selectedRows = _dataSource.selectedRows;
    if (selectedRows.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No items selected'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _lastAction = '$action: ${selectedRows.length} items';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action performed on ${selectedRows.length} items'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Undo logic here
          },
        ),
      ),
    );

    // Clear selection after bulk action
    _dataSource.clearSelection();
  }

  @override
  void dispose() {
    _controller.dispose();
    _dataSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Custom Actions Data Grid'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Column(
          children: [
            // Bulk Actions Bar
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.grey.withValues(alpha: 0.1),
              child: Row(
                children: [
                  StreamBuilder(
                    stream: Stream.periodic(Duration(milliseconds: 100)),
                    builder: (context, snapshot) {
                      final count = _dataSource.selectedRows.length;
                      return Text(
                        count > 0
                            ? '$count items selected'
                            : 'Select items to perform bulk actions',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      );
                    },
                  ),
                  Spacer(),
                  StreamBuilder(
                    stream: Stream.periodic(Duration(milliseconds: 100)),
                    builder: (context, snapshot) {
                      final hasSelection = _dataSource.selectedRows.isNotEmpty;
                      return Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: hasSelection
                                ? () => _performBulkAction('Bulk Edit')
                                : null,
                            icon: Icon(Icons.edit, size: 16),
                            label: Text('Edit'),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: hasSelection
                                ? () => _performBulkAction('Bulk Assign')
                                : null,
                            icon: Icon(Icons.person_add, size: 16),
                            label: Text('Assign'),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: hasSelection
                                ? () => _performBulkAction('Bulk Update Status')
                                : null,
                            icon: Icon(Icons.update, size: 16),
                            label: Text('Update Status'),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: hasSelection
                                ? () => _performBulkAction('Bulk Archive')
                                : null,
                            icon: Icon(Icons.archive, size: 16),
                            label: Text('Archive'),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: hasSelection
                                ? () => _performBulkAction('Bulk Delete')
                                : null,
                            icon: Icon(Icons.delete, size: 16),
                            label: Text('Delete'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.red.withValues(alpha: 0.1),
                              foregroundColor: Colors.red,
                            ),
                          ),
                          if (hasSelection) ...[
                            SizedBox(width: 8),
                            TextButton(
                              onPressed: () => _dataSource.clearSelection(),
                              child: Text('Clear Selection'),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            // Last Action Display
            if (_lastAction.isNotEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.blue.withValues(alpha: 0.1),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      'Last action: $_lastAction',
                      style: TextStyle(color: Colors.blue, fontSize: 12),
                    ),
                  ],
                ),
              ),
            // Data Grid
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Card(
                  elevation: 2,
                  child: VooDataGrid(
                    controller: _controller,
                    showPagination: true,
                  ),
                ),
              ),
            ),
            // Quick Actions Footer
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.05),
                border: Border(
                  top: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Quick Actions:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: 16),
                  TextButton.icon(
                    onPressed: () {
                      // Export logic
                      setState(() {
                        _lastAction = 'Export to CSV';
                      });
                    },
                    icon: Icon(Icons.download, size: 16),
                    label: Text('Export CSV'),
                  ),
                  SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () {
                      // Print logic
                      setState(() {
                        _lastAction = 'Print Preview';
                      });
                    },
                    icon: Icon(Icons.print, size: 16),
                    label: Text('Print'),
                  ),
                  SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () {
                      // Refresh logic
                      _dataSource.loadData();
                      setState(() {
                        _lastAction = 'Data Refreshed';
                      });
                    },
                    icon: Icon(Icons.refresh, size: 16),
                    label: Text('Refresh'),
                  ),
                  Spacer(),
                  Text(
                    'Total: ${_tasksData.length} items',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper class for local data source
class LocalDataGridSource extends VooDataGridSource {
  LocalDataGridSource({
    List<dynamic>? data,
  }) : super(mode: VooDataGridMode.local) {
    if (data != null) {
      setLocalData(data);
    }
  }

  @override
  Future<VooDataGridResponse> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    // Not needed for local mode
    return VooDataGridResponse(
      rows: [],
      totalRows: 0,
      page: page,
      pageSize: pageSize,
    );
  }
}
