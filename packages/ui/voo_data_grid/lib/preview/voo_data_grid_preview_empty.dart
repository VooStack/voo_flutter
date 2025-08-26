import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

// Simple local data source implementation
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

@pragma('preview')
class VooDataGridEmptyStatePreview extends StatefulWidget {
  const VooDataGridEmptyStatePreview({super.key});

  @override
  State<VooDataGridEmptyStatePreview> createState() => _VooDataGridEmptyStatePreviewState();
}

class _VooDataGridEmptyStatePreviewState extends State<VooDataGridEmptyStatePreview> {
  late VooDataGridController _controller;
  late LocalDataGridSource _dataSource;
  bool _hasData = false;

  @override
  void initState() {
    super.initState();

    // Start with empty data to show the empty state with headers
    _dataSource = LocalDataGridSource(data: []);

    // Initialize controller with columns - these will always show
    _controller = VooDataGridController(
      dataSource: _dataSource,
      columns: [
        const VooDataColumn(
          field: 'orderId',
          label: 'Order ID',
          width: 120,
          sortable: true,
          frozen: true,
        ),
        const VooDataColumn(
          field: 'customerName',
          label: 'Customer Name',
          width: 200,
          sortable: true,
          filterable: true,
        ),
        const VooDataColumn(
          field: 'productName',
          label: 'Product',
          width: 180,
          sortable: true,
          filterable: true,
        ),
        VooDataColumn(
          field: 'quantity',
          label: 'Quantity',
          width: 100,
          sortable: true,
          textAlign: TextAlign.right,
        ),
        VooDataColumn(
          field: 'unitPrice',
          label: 'Unit Price',
          width: 120,
          sortable: true,
          textAlign: TextAlign.right,
          valueFormatter: (value) => '\$${value?.toStringAsFixed(2) ?? '0.00'}',
        ),
        VooDataColumn(
          field: 'totalAmount',
          label: 'Total',
          width: 120,
          sortable: true,
          textAlign: TextAlign.right,
          valueFormatter: (value) => '\$${value?.toStringAsFixed(2) ?? '0.00'}',
        ),
        const VooDataColumn(
          field: 'orderStatus',
          label: 'Status',
          width: 100,
          sortable: true,
          filterable: true,
        ),
        const VooDataColumn(
          field: 'orderDate',
          label: 'Order Date',
          width: 120,
          sortable: true,
        ),
        const VooDataColumn(
          field: 'shippingMethod',
          label: 'Shipping',
          width: 140,
        ),
      ],
    );

    _dataSource.loadData();
  }

  void _toggleData() {
    setState(() {
      _hasData = !_hasData;
      if (_hasData) {
        // Add sample data
        final data = List.generate(10, (i) => {
          'orderId': 'ORD${(1000 + i).toString().padLeft(6, '0')}',
          'customerName': 'Customer ${i + 1}',
          'productName': 'Product ${i + 1}',
          'quantity': (i + 1) * 2,
          'unitPrice': (i + 1) * 15.99,
          'totalAmount': (i + 1) * 2 * 15.99,
          'orderStatus': ['Active', 'Pending', 'Shipped'][i % 3],
          'orderDate': DateTime.now().subtract(Duration(days: i)).toIso8601String().split('T')[0],
          'shippingMethod': ['Standard', 'Express', 'Overnight'][i % 3],
        });
        _dataSource.setLocalData(data);
      } else {
        // Clear data to show empty state
        _dataSource.setLocalData([]);
      }
      _dataSource.loadData();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _dataSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Empty State with Headers'),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: Text(
                    _hasData ? '10 rows loaded' : 'No data',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.amber.shade50,
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.orange),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Column headers remain visible even when there\'s no data.\nThis helps users understand the table structure.',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    const SizedBox(width: 16),
                    FilledButton.icon(
                      icon: Icon(_hasData ? Icons.clear : Icons.add),
                      label: Text(_hasData ? 'Clear Data' : 'Add Data'),
                      onPressed: _toggleData,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: VooDataGrid(
                    controller: _controller,
                    showPagination: true,
                    showToolbar: true,
                    emptyStateWidget: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No Orders Found',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your filters or add some data',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 24),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text('Refresh'),
                          onPressed: () {
                            _dataSource.refresh();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: VooDataGridEmptyStatePreview(),
  ));
}