import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

/// Example demonstrating action buttons in data grid
/// Shows how to use excludeFromApi and onCellTap for action columns
class ActionButtonsExample extends StatefulWidget {
  const ActionButtonsExample({super.key});

  @override
  State<ActionButtonsExample> createState() => _ActionButtonsExampleState();
}

class _ActionButtonsExampleState extends State<ActionButtonsExample> {
  late VooDataGridController<Order> controller;
  late OrderDataSource dataSource;

  @override
  void initState() {
    super.initState();

    dataSource = OrderDataSource();
    controller = VooDataGridController<Order>(
      dataSource: dataSource,
      columns: [
        VooDataColumn<Order>(
          field: 'id',
          label: 'Order ID',
          width: 100,
          sortable: true,
          filterable: true,
          valueGetter: (order) => order.id,
        ),
        VooDataColumn<Order>(
          field: 'customerName',
          label: 'Customer',
          flex: 2,
          sortable: true,
          filterable: true,
          valueGetter: (order) => order.customerName,
        ),
        VooDataColumn<Order>(
          field: 'status',
          label: 'Status',
          width: 120,
          sortable: true,
          filterable: true,
          valueGetter: (order) => order.status,
          cellBuilder: (context, value, row) {
            Color statusColor;
            switch (value) {
              case 'pending':
                statusColor = Colors.orange;
                break;
              case 'processing':
                statusColor = Colors.blue;
                break;
              case 'completed':
                statusColor = Colors.green;
                break;
              case 'cancelled':
                statusColor = Colors.red;
                break;
              default:
                statusColor = Colors.grey;
            }
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: statusColor),
              ),
              child: Text(
                value.toString().toUpperCase(),
                style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
        VooDataColumn<Order>(
          field: 'total',
          label: 'Total',
          width: 120,
          sortable: true,
          filterable: true,
          textAlign: TextAlign.right,
          valueGetter: (order) => order.total,
          valueFormatter: (value) => '\$${value.toStringAsFixed(2)}',
        ),
        VooDataColumn<Order>(
          field: 'orderDate',
          label: 'Order Date',
          width: 150,
          sortable: true,
          filterable: true,
          valueGetter: (order) => order.orderDate,
          valueFormatter: (value) {
            if (value is DateTime) {
              return '${value.day}/${value.month}/${value.year}';
            }
            return value.toString();
          },
        ),
        // Action button column - excluded from API
        VooDataColumn<Order>(
          field: 'actions',
          label: 'Actions',
          width: 200,
          sortable: false,
          filterable: false,
          excludeFromApi: true, // This column won't be included in API requests
          cellBuilder: (context, value, order) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility, size: 20),
                  tooltip: 'View',
                  onPressed: () => _viewOrder(context, order),
                  color: Colors.blue,
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  tooltip: 'Edit',
                  onPressed: () => _editOrder(context, order),
                  color: Colors.green,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  tooltip: 'Delete',
                  onPressed: () => _deleteOrder(context, order),
                  color: Colors.red,
                ),
              ],
            );
          },
        ),
        // Another action column with clickable cell
        VooDataColumn<Order>(
          field: 'quickAction',
          label: 'Quick Action',
          width: 120,
          sortable: false,
          filterable: false,
          excludeFromApi: true,
          onCellTap: (context, order, value) {
            // Handle cell tap
            _processOrder(context, order);
          },
          cellBuilder: (context, value, order) {
            return Center(
              child: ElevatedButton(
                onPressed: () => _processOrder(context, order),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: const Text('Process', style: TextStyle(fontSize: 12)),
              ),
            );
          },
        ),
      ],
    );

    // Load initial data
    dataSource.setLocalData(generateSampleOrders());
  }

  @override
  void dispose() {
    controller.dispose();
    dataSource.dispose();
    super.dispose();
  }

  void _viewOrder(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order Details #${order.id}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer: ${order.customerName}'),
            Text('Status: ${order.status}'),
            Text('Total: \$${order.total.toStringAsFixed(2)}'),
            Text('Date: ${order.orderDate.toString().substring(0, 10)}'),
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
  }

  void _editOrder(BuildContext context, Order order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit order #${order.id}'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {},
        ),
      ),
    );
  }

  void _deleteOrder(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete order #${order.id}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                final orders = List<Order>.from(dataSource.allRows);
                orders.removeWhere((o) => o.id == order.id);
                dataSource.setLocalData(orders);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order #${order.id} deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _processOrder(BuildContext context, Order order) {
    if (order.status == 'pending') {
      setState(() {
        order.status = 'processing';
        dataSource.setLocalData(dataSource.allRows);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order #${order.id} is now processing'),
          backgroundColor: Colors.blue,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order #${order.id} cannot be processed (status: ${order.status})'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  List<Order> generateSampleOrders() {
    return List.generate(50, (index) {
      final statuses = ['pending', 'processing', 'completed', 'cancelled'];
      final customers = [
        'John Doe',
        'Jane Smith',
        'Bob Johnson',
        'Alice Brown',
        'Charlie Wilson',
        'Eva Martinez',
        'David Lee',
        'Sarah Davis',
      ];

      return Order(
        id: 1000 + index,
        customerName: customers[index % customers.length],
        status: statuses[index % statuses.length],
        total: (index + 1) * 99.99,
        orderDate: DateTime.now().subtract(Duration(days: index)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Action Buttons Example'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Data Grid with Action Buttons',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'This example demonstrates:',
                  style: TextStyle(fontSize: 14),
                ),
                const Text('• Action columns that are excluded from API requests'),
                const Text('• Custom cell builders for buttons and status badges'),
                const Text('• onCellTap callback for clickable cells'),
                const Text('• Interactive operations like view, edit, and delete'),
              ],
            ),
          ),
          Expanded(
            child: VooDataGrid<Order>(
              controller: controller,
              onRowTap: (order) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Row tapped: Order #${order.id}'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Sample Order model
class Order {
  final int id;
  final String customerName;
  String status;
  final double total;
  final DateTime orderDate;

  Order({
    required this.id,
    required this.customerName,
    required this.status,
    required this.total,
    required this.orderDate,
  });
}

/// Data source for orders
class OrderDataSource extends VooDataGridSource<Order> {
  OrderDataSource() : super(mode: VooDataGridMode.local);
}