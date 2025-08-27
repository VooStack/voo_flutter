import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

/// Complete working example for VooApiStandard with sorting
/// This example shows the correct setup for OrderList with sorting enabled

// Your OrderList entity
class OrderList {
  final String siteNumber;
  final String siteName;
  final String clientCompanyName;
  final String orderStatus;
  final DateTime orderDate;
  final double orderCost;

  OrderList({
    required this.siteNumber,
    required this.siteName,
    required this.clientCompanyName,
    required this.orderStatus,
    required this.orderDate,
    required this.orderCost,
  });
}

// Your repository implementation
class OrderRepositoryImpl extends VooDataGridSource<OrderList> {
  OrderRepositoryImpl() : super(mode: VooDataGridMode.remote);

  @override
  Future<VooDataGridResponse<OrderList>> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    // Build request with VooApiStandard
    final request = const DataGridRequestBuilder(
      standard: ApiFilterStandard.voo,
      fieldPrefix: 'Site',
    ).buildRequest(
      page: page + 1, // VooAPI uses 1-based pagination
      pageSize: pageSize,
      filters: filters,
      sorts: sorts, // <-- Sorts will be included here
    );

    debugPrint('[OrderRepository] API Request: $request');
    
    // Make your actual API call here
    // final response = await remoteDataSource.getOrders(request);
    
    // Mock response for example
    await Future.delayed(const Duration(milliseconds: 500));
    
    return VooDataGridResponse(
      rows: _generateMockData(),
      totalRows: 100,
      page: page,
      pageSize: pageSize,
    );
  }
  
  List<OrderList> _generateMockData() {
    return List.generate(20, (index) => OrderList(
      siteNumber: '100${index + 1}',
      siteName: 'Site ${index + 1}',
      clientCompanyName: 'Client ${index + 1}',
      orderStatus: index % 2 == 0 ? 'Active' : 'Pending',
      orderDate: DateTime.now().subtract(Duration(days: index)),
      orderCost: 1000.0 + (index * 100),
    ));
  }
}

class VooApiStandardExample extends StatefulWidget {
  const VooApiStandardExample({super.key});

  @override
  State<VooApiStandardExample> createState() => _VooApiStandardExampleState();
}

class _VooApiStandardExampleState extends State<VooApiStandardExample> {
  late VooDataGridController<OrderList> controller;
  late OrderRepositoryImpl dataSource;

  @override
  void initState() {
    super.initState();
    
    // Initialize data source
    dataSource = OrderRepositoryImpl();
    
    // Initialize controller with properly configured columns
    controller = VooDataGridController<OrderList>(
      dataSource: dataSource,
      columns: [
        VooDataColumn<OrderList>(
          field: 'siteNumber',
          label: 'Site Number',
          sortable: true, // <-- MUST be true for sorting to work
          filterable: true,
          width: 120,
          // REQUIRED for typed objects (non-Map data)
          valueGetter: (row) => row.siteNumber,
        ),
        VooDataColumn<OrderList>(
          field: 'siteName',
          label: 'Site Name', 
          sortable: true, // <-- MUST be true for sorting to work
          filterable: true,
          width: 200,
          // REQUIRED for typed objects (non-Map data)
          valueGetter: (row) => row.siteName,
        ),
        VooDataColumn<OrderList>(
          field: 'clientCompanyName',
          label: 'Client',
          sortable: true, // <-- MUST be true for sorting to work
          filterable: true,
          width: 200,
          // REQUIRED for typed objects (non-Map data)
          valueGetter: (row) => row.clientCompanyName,
        ),
        VooDataColumn<OrderList>(
          field: 'orderStatus',
          label: 'Status',
          sortable: true, // <-- MUST be true for sorting to work
          filterable: true,
          width: 120,
          // REQUIRED for typed objects (non-Map data)
          valueGetter: (row) => row.orderStatus,
        ),
        VooDataColumn<OrderList>(
          field: 'orderDate',
          label: 'Order Date',
          sortable: true, // <-- MUST be true for sorting to work
          filterable: true,
          width: 150,
          // REQUIRED for typed objects (non-Map data)
          valueGetter: (row) => row.orderDate,
          valueFormatter: (value) {
            if (value is DateTime) {
              return '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
            }
            return value?.toString() ?? '';
          },
        ),
        VooDataColumn<OrderList>(
          field: 'orderCost',
          label: 'Cost',
          sortable: true, // <-- MUST be true for sorting to work
          filterable: true,
          width: 120,
          textAlign: TextAlign.right,
          // REQUIRED for typed objects (non-Map data)
          valueGetter: (row) => row.orderCost,
          valueFormatter: (value) {
            if (value is num) {
              return '\$${value.toStringAsFixed(2)}';
            }
            return value?.toString() ?? '';
          },
        ),
      ],
    );
    
    // Load initial data
    dataSource.loadData();
  }

  @override
  void dispose() {
    controller.dispose();
    dataSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VooApiStandard Sorting Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Debug info panel
          Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Debug Info:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('• Click column headers to sort'),
                const Text('• Check console for API requests'),
                const Text('• Sorts should appear as sortBy and sortDescending'),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.bug_report),
                  label: const Text('Log Current Sorts'),
                  onPressed: () {
                    debugPrint('Current sorts: ${dataSource.sorts}');
                    for (var sort in dataSource.sorts) {
                      debugPrint('  - Field: ${sort.field}, Direction: ${sort.direction}');
                    }
                  },
                ),
              ],
            ),
          ),
          
          // Data Grid
          Expanded(
            child: VooDataGrid<OrderList>(
              controller: controller,
              onRowTap: (row) {
                debugPrint('Tapped row: ${row.siteNumber}');
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Main app to run the example
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VooApiStandard Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const VooApiStandardExample(),
    );
  }
}