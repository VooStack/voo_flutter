import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Example model class representing an order
class OrderModel {
  final String orderId;
  final String siteNumber;
  final String customerName;
  final String product;
  final int quantity;
  final double unitPrice;
  final double totalAmount;
  final DateTime orderDate;
  final String status;
  final String paymentMethod;

  OrderModel({
    required this.orderId,
    required this.siteNumber,
    required this.customerName,
    required this.product,
    required this.quantity,
    required this.unitPrice,
    required this.totalAmount,
    required this.orderDate,
    required this.status,
    required this.paymentMethod,
  });
}

/// Data source for typed objects
class TypedObjectDataSource extends VooDataGridSource {
  TypedObjectDataSource({
    List<OrderModel>? orders,
  }) : super(mode: VooDataGridMode.local) {
    if (orders != null) {
      // Convert typed objects to dynamic list for base class
      setLocalData(orders);
    }
  }

  @override
  Future<VooDataGridResponse> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    // For remote mode, convert your typed response to VooDataGridResponse
    // Example:
    // final response = await api.getOrders(...);
    // final orders = response.items; // List<OrderModel>
    // return VooDataGridResponse(
    //   rows: orders,  // Will be List<dynamic> but contains OrderModel instances
    //   totalRows: response.totalCount,
    //   page: page,
    //   pageSize: pageSize,
    // );
    
    // Not needed for local mode
    return VooDataGridResponse(
      rows: [],
      totalRows: 0,
      page: page,
      pageSize: pageSize,
    );
  }
}

/// Preview demonstrating VooDataGrid with typed objects
@pragma('preview')
class VooDataGridTypedObjectsPreview extends StatefulWidget {
  const VooDataGridTypedObjectsPreview({super.key});

  @override
  State<VooDataGridTypedObjectsPreview> createState() =>
      _VooDataGridTypedObjectsPreviewState();
}

class _VooDataGridTypedObjectsPreviewState
    extends State<VooDataGridTypedObjectsPreview> {
  late VooDataGridController _controller;
  late TypedObjectDataSource _dataSource;

  @override
  void initState() {
    super.initState();

    // Create sample typed objects
    final orders = List.generate(
      50,
      (index) => OrderModel(
        orderId: 'ORD${(index + 1).toString().padLeft(6, '0')}',
        siteNumber: 'SITE${((index % 5) + 1).toString().padLeft(3, '0')}',
        customerName: 'Customer ${index + 1}',
        product: ['Laptop', 'Phone', 'Tablet', 'Monitor'][index % 4],
        quantity: (index % 10) + 1,
        unitPrice: 100.0 + (index * 10),
        totalAmount: (100.0 + (index * 10)) * ((index % 10) + 1),
        orderDate: DateTime.now().subtract(Duration(days: index)),
        status: ['Active', 'Pending', 'Completed', 'Cancelled'][index % 4],
        paymentMethod: ['Credit Card', 'PayPal', 'Bank Transfer'][index % 3],
      ),
    );

    // Initialize data source with typed objects
    _dataSource = TypedObjectDataSource(orders: orders);

    // Initialize controller with columns
    // IMPORTANT: For typed objects, you MUST provide valueGetter functions
    _controller = VooDataGridController(
      dataSource: _dataSource,
      columns: [
        VooDataColumn(
          field: 'orderId',
          label: 'Order ID',
          width: 100,
          sortable: true,
          // REQUIRED for typed objects: Extract value from OrderModel
          valueGetter: (row) => (row as OrderModel).orderId,
        ),
        VooDataColumn(
          field: 'siteNumber',
          label: 'Site #',
          width: 80,
          sortable: true,
          // REQUIRED for typed objects: Extract value from OrderModel
          valueGetter: (row) => (row as OrderModel).siteNumber,
        ),
        VooDataColumn(
          field: 'customerName',
          label: 'Customer',
          flex: 2,
          sortable: true,
          filterable: true,
          // REQUIRED for typed objects: Extract value from OrderModel
          valueGetter: (row) => (row as OrderModel).customerName,
        ),
        VooDataColumn(
          field: 'product',
          label: 'Product',
          width: 120,
          sortable: true,
          filterable: true,
          // REQUIRED for typed objects: Extract value from OrderModel
          valueGetter: (row) => (row as OrderModel).product,
        ),
        VooDataColumn(
          field: 'quantity',
          label: 'Qty',
          width: 60,
          sortable: true,
          textAlign: TextAlign.right,
          // REQUIRED for typed objects: Extract value from OrderModel
          valueGetter: (row) => (row as OrderModel).quantity,
        ),
        VooDataColumn(
          field: 'unitPrice',
          label: 'Price',
          width: 90,
          sortable: true,
          textAlign: TextAlign.right,
          // REQUIRED for typed objects: Extract value from OrderModel
          valueGetter: (row) => (row as OrderModel).unitPrice,
          valueFormatter: (value) => '\$${value.toStringAsFixed(2)}',
        ),
        VooDataColumn(
          field: 'totalAmount',
          label: 'Total',
          width: 100,
          sortable: true,
          textAlign: TextAlign.right,
          // REQUIRED for typed objects: Extract value from OrderModel
          valueGetter: (row) => (row as OrderModel).totalAmount,
          valueFormatter: (value) => '\$${value.toStringAsFixed(2)}',
          cellBuilder: (context, value, row) {
            final amount = value as double;
            final color = amount > 1000
                ? Colors.green
                : (amount > 500 ? Colors.orange : Colors.blue);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                '\$${amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
              ),
            );
          },
        ),
        VooDataColumn(
          field: 'orderDate',
          label: 'Date',
          width: 100,
          sortable: true,
          filterable: true,
          // REQUIRED for typed objects: Extract value from OrderModel
          valueGetter: (row) => (row as OrderModel).orderDate,
          valueFormatter: (value) {
            final date = value as DateTime;
            return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
          },
        ),
        VooDataColumn(
          field: 'status',
          label: 'Status',
          width: 100,
          sortable: true,
          filterable: true,
          // REQUIRED for typed objects: Extract value from OrderModel
          valueGetter: (row) => (row as OrderModel).status,
          cellBuilder: (context, value, row) {
            Color color;
            IconData icon;
            switch (value) {
              case 'Active':
                color = Colors.green;
                icon = Icons.check_circle;
                break;
              case 'Pending':
                color = Colors.orange;
                icon = Icons.schedule;
                break;
              case 'Completed':
                color = Colors.blue;
                icon = Icons.done_all;
                break;
              case 'Cancelled':
                color = Colors.red;
                icon = Icons.cancel;
                break;
              default:
                color = Colors.grey;
                icon = Icons.help;
            }
            return Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 4),
                Text(
                  value,
                  style: TextStyle(color: color),
                ),
              ],
            );
          },
        ),
        VooDataColumn(
          field: 'paymentMethod',
          label: 'Payment',
          width: 120,
          sortable: true,
          // REQUIRED for typed objects: Extract value from OrderModel
          valueGetter: (row) => (row as OrderModel).paymentMethod,
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
    return VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('VooDataGrid with Typed Objects'),
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
          ),
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.blue.shade50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Using Typed Objects with VooDataGrid',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This example demonstrates how to use VooDataGrid with custom typed objects (OrderModel).',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning, color: Colors.amber.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'IMPORTANT: When using typed objects, you MUST provide a valueGetter function for each column to extract the field value from your object.',
                              style: TextStyle(
                                color: Colors.amber.shade900,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                    onRowTap: (data) {
                      // The data parameter is the typed OrderModel object
                      final order = data as OrderModel;
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Order Details: ${order.orderId}'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow('Site Number', order.siteNumber),
                              _buildDetailRow('Customer', order.customerName),
                              _buildDetailRow('Product', order.product),
                              _buildDetailRow('Quantity', order.quantity.toString()),
                              _buildDetailRow(
                                  'Unit Price', '\$${order.unitPrice.toStringAsFixed(2)}'),
                              _buildDetailRow(
                                  'Total', '\$${order.totalAmount.toStringAsFixed(2)}'),
                              _buildDetailRow('Status', order.status),
                              _buildDetailRow('Payment', order.paymentMethod),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

/// Example of implementing a remote data source with typed objects
class TypedRemoteDataSource extends VooDataGridSource {
  final Future<PagedResult<OrderModel>> Function({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) fetchOrders;

  TypedRemoteDataSource({required this.fetchOrders})
      : super(mode: VooDataGridMode.remote);

  @override
  Future<VooDataGridResponse> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    final result = await fetchOrders(
      page: page,
      pageSize: pageSize,
      filters: filters,
      sorts: sorts,
    );

    // Convert typed result to VooDataGridResponse
    return VooDataGridResponse(
      rows: result.items, // List<OrderModel> gets cast to List<dynamic>
      totalRows: result.totalCount,
      page: page,
      pageSize: pageSize,
    );
  }
}

/// Example paged result model
class PagedResult<T> {
  final List<T> items;
  final int totalCount;
  final int pageNumber;
  final int pageSize;

  PagedResult({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
  });
}