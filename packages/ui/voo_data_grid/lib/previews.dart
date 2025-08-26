import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

// Simple local data source implementation for previews
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

class VooDataGridBasicPreview extends StatefulWidget {
  const VooDataGridBasicPreview({super.key});

  @override
  State<VooDataGridBasicPreview> createState() =>
      _VooDataGridBasicPreviewState();
}

class _VooDataGridBasicPreviewState extends State<VooDataGridBasicPreview> {
  late VooDataGridController _controller;
  late LocalDataGridSource _dataSource;

  @override
  void initState() {
    super.initState();

    // Create sample data
    final data = List.generate(
        20,
        (index) => {
              'id': index + 1,
              'name': 'User ${index + 1}',
              'email': 'user${index + 1}@example.com',
              'status': index % 3 == 0 ? 'Active' : 'Inactive',
              'created': DateTime.now().subtract(Duration(days: index)),
            });

    // Initialize data source
    _dataSource = LocalDataGridSource(data: data);

    // Initialize controller with columns
    _controller = VooDataGridController(
      dataSource: _dataSource,
      columns: [
        VooDataColumn(
          field: 'id',
          label: 'ID',
          width: 60,
        ),
        VooDataColumn(
          field: 'name',
          label: 'Name',
          flex: 2,
          sortable: true,
        ),
        VooDataColumn(
          field: 'email',
          label: 'Email',
          flex: 3,
          sortable: true,
        ),
        VooDataColumn(
          field: 'status',
          label: 'Status',
          width: 100,
          sortable: true,
        ),
      ],
    );

    // Load initial data
    _dataSource.loadData();
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
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Basic Data Grid'),
        ),
        body: Card(
          margin: const EdgeInsets.all(16),
          child: SizedBox(
            height: 400,
            child: VooDataGrid(
              controller: _controller,
            ),
          ),
        ),
      ),
    );
  }
}

class VooDataGridFilterablePreview extends StatefulWidget {
  const VooDataGridFilterablePreview({super.key});

  @override
  State<VooDataGridFilterablePreview> createState() =>
      _VooDataGridFilterablePreviewState();
}

class _VooDataGridFilterablePreviewState
    extends State<VooDataGridFilterablePreview> {
  late VooDataGridController _controller;
  late LocalDataGridSource _dataSource;

  @override
  void initState() {
    super.initState();

    // Create sample product data
    final products = List.generate(
        50,
        (index) => {
              'id': index + 1,
              'name': 'Product ${index + 1}',
              'category': [
                'Electronics',
                'Books',
                'Clothing',
                'Food'
              ][index % 4],
              'price': (index + 1) * 10.99,
              'stock': index * 5,
              'available': index % 2 == 0,
            });

    _dataSource = LocalDataGridSource(data: products);

    _controller = VooDataGridController(
      dataSource: _dataSource,
      columns: [
        VooDataColumn(
          field: 'name',
          label: 'Product',
          flex: 2,
          sortable: true,
          filterable: true,
        ),
        VooDataColumn(
          field: 'category',
          label: 'Category',
          width: 120,
          sortable: true,
          filterable: true,
        ),
        VooDataColumn(
          field: 'price',
          label: 'Price',
          width: 100,
          sortable: true,
          valueFormatter: (value) => '\$${value.toStringAsFixed(2)}',
        ),
        VooDataColumn(
          field: 'stock',
          label: 'Stock',
          width: 80,
        ),
        VooDataColumn(
          field: 'available',
          label: 'Available',
          width: 100,
          valueFormatter: (value) => value ? '✓' : '✗',
        ),
      ],
      showFilters: true,
    );

    _dataSource.loadData();
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
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Filterable Data Grid'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: VooDataGrid(
            controller: _controller,
          ),
        ),
      ),
    );
  }
}

class VooDataGridSelectablePreview extends StatefulWidget {
  const VooDataGridSelectablePreview({super.key});

  @override
  State<VooDataGridSelectablePreview> createState() =>
      _VooDataGridSelectablePreviewState();
}

class _VooDataGridSelectablePreviewState
    extends State<VooDataGridSelectablePreview> {
  late VooDataGridController _controller;
  late LocalDataGridSource _dataSource;

  int get selectedCount => _dataSource.selectedRows.length;

  @override
  void initState() {
    super.initState();

    final tasks = List.generate(
        15,
        (index) => {
              'id': index + 1,
              'task': 'Task ${index + 1}',
              'assignee': 'User ${(index % 5) + 1}',
              'priority': ['Low', 'Medium', 'High'][index % 3],
              'status': ['Todo', 'In Progress', 'Done'][index % 3],
              'dueDate': DateTime.now().add(Duration(days: index)),
            });

    _dataSource = LocalDataGridSource(data: tasks);
    _dataSource.setSelectionMode(VooSelectionMode.multiple);

    // Listen to selection changes
    _dataSource.addListener(() {
      if (mounted) setState(() {});
    });

    _controller = VooDataGridController(
      dataSource: _dataSource,
      columns: [
        VooDataColumn(
          field: 'task',
          label: 'Task',
          flex: 3,
          sortable: true,
        ),
        VooDataColumn(
          field: 'assignee',
          label: 'Assignee',
          width: 120,
        ),
        VooDataColumn(
          field: 'priority',
          label: 'Priority',
          width: 100,
          sortable: true,
          valueFormatter: (value) {
            final color = switch (value) {
              'High' => '🔴',
              'Medium' => '🟡',
              'Low' => '🟢',
              _ => '',
            };
            return '$color $value';
          },
        ),
        VooDataColumn(
          field: 'status',
          label: 'Status',
          width: 120,
          sortable: true,
        ),
      ],
    );

    _dataSource.loadData();
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
      home: Scaffold(
        appBar: AppBar(
          title: Text('Selectable Grid - $selectedCount selected'),
          actions: [
            if (selectedCount > 0)
              TextButton(
                onPressed: () {
                  _dataSource.clearSelection();
                },
                child: const Text(
                  'Clear Selection',
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: VooDataGrid(
            controller: _controller,
          ),
        ),
      ),
    );
  }
}

class VooDataGridPaginatedPreview extends StatefulWidget {
  const VooDataGridPaginatedPreview({super.key});

  @override
  State<VooDataGridPaginatedPreview> createState() =>
      _VooDataGridPaginatedPreviewState();
}

class _VooDataGridPaginatedPreviewState
    extends State<VooDataGridPaginatedPreview> {
  late VooDataGridController _controller;
  late LocalDataGridSource _dataSource;

  @override
  void initState() {
    super.initState();

    // Generate large dataset
    final largeData = List.generate(
        500,
        (index) => {
              'id': index + 1,
              'title': 'Item ${index + 1}',
              'description': 'Description for item ${index + 1}',
              'value': (index + 1) * 2.5,
              'created': DateTime.now().subtract(Duration(hours: index)),
            });

    _dataSource = LocalDataGridSource(data: largeData);
    // Set page size through the source
    _dataSource.changePageSize(10);

    _controller = VooDataGridController(
      dataSource: _dataSource,
      columns: [
        VooDataColumn(
          field: 'id',
          label: 'ID',
          width: 60,
          sortable: true,
        ),
        VooDataColumn(
          field: 'title',
          label: 'Title',
          flex: 2,
          sortable: true,
        ),
        VooDataColumn(
          field: 'description',
          label: 'Description',
          flex: 3,
        ),
        VooDataColumn(
          field: 'value',
          label: 'Value',
          width: 100,
          sortable: true,
          valueFormatter: (value) => value.toStringAsFixed(2),
        ),
      ],
    );

    _dataSource.loadData();
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
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Paginated Data Grid'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: VooDataGrid(
              controller: _controller,
              showPagination: true,
            ),
          ),
        ),
      ),
    );
  }
}
