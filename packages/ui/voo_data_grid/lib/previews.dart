import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

// Simple local data source implementation for previews
class _LocalDataGridSource extends VooDataGridSource {
  _LocalDataGridSource({
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
  }) async =>
      VooDataGridResponse(
        rows: [],
        totalRows: 0,
        page: page,
        pageSize: pageSize,
      );
}

@Preview(name: 'Basic Data Grid')
Widget basicDataGrid() {
  final data = List.generate(
    20,
    (index) => {
      'id': index + 1,
      'name': 'User ${index + 1}',
      'email': 'user${index + 1}@example.com',
      'status': index % 3 == 0 ? 'Active' : 'Inactive',
      'created': DateTime.now().subtract(Duration(days: index)),
    },
  );

  final dataSource = _LocalDataGridSource(data: data);

  final controller = VooDataGridController(
    dataSource: dataSource,
    columns: [
      const VooDataColumn<dynamic>(
        field: 'id',
        label: 'ID',
        width: 60,
      ),
      const VooDataColumn<dynamic>(
        field: 'name',
        label: 'Name',
        flex: 2,
      ),
      const VooDataColumn<dynamic>(
        field: 'email',
        label: 'Email',
        flex: 3,
      ),
      const VooDataColumn<dynamic>(
        field: 'status',
        label: 'Status',
        width: 100,
      ),
    ],
  );

  dataSource.loadData();

  return Material(
    child: SizedBox(
      height: 400,
      child: VooDataGrid(controller: controller),
    ),
  );
}

@Preview(name: 'Wide Grid with Scrollbars')
Widget wideDataGridWithScrollbars() {
  final data = List.generate(
    100,
    (index) {
      final row = <String, dynamic>{
        'id': index + 1,
      };
      // Generate 20 columns
      for (int i = 0; i < 20; i++) {
        row['col_$i'] = 'Cell R${index}C$i';
      }
      return row;
    },
  );

  final dataSource = _LocalDataGridSource(data: data);

  final columns = <VooDataColumn>[
    const VooDataColumn<dynamic>(
      field: 'id',
      label: 'ID',
      width: 60,
    ),
  ];

  for (int i = 0; i < 20; i++) {
    columns.add(
      VooDataColumn<dynamic>(
        field: 'col_$i',
        label: 'Column ${i + 1}',
        width: 120,
      ),
    );
  }

  final controller = VooDataGridController(
    dataSource: dataSource,
    columns: columns,
  );

  dataSource.loadData();

  return Material(
    child: SizedBox(
      height: 400,
      width: 800,
      child: VooDataGrid(
        controller: controller,
        alwaysShowHorizontalScrollbar: true,
        alwaysShowVerticalScrollbar: true,
      ),
    ),
  );
}

@Preview(name: 'Advanced Filters')
Widget advancedFiltersGrid() {
  final now = DateTime.now();
  final data = List.generate(
    100,
    (index) => {
      'id': index + 1,
      'product': 'Product ${index + 1}',
      'category': [
        'Electronics',
        'Books',
        'Clothing',
        'Food',
        'Toys',
      ][index % 5],
      'price': (index + 1) * 9.99,
      'stock': index * 5,
      'rating': 1.0 + (index % 5),
      'featured': index % 3 == 0,
      'created': now.subtract(Duration(days: index)),
      'lastOrder': now.subtract(Duration(hours: index * 3)),
      'discount': (index % 4) * 10,
      'available': index % 2 == 0,
      'supplier': ['Supplier A', 'Supplier B', 'Supplier C'][index % 3],
    },
  );

  final dataSource = _LocalDataGridSource(data: data);

  final controller = VooDataGridController(
    dataSource: dataSource,
    columns: [
      const VooDataColumn<dynamic>(
        field: 'product',
        label: 'Product',
        flex: 2,
        filterWidgetType: VooFilterWidgetType.textField,
        filterHint: 'Search products...',
      ),
      const VooDataColumn<dynamic>(
        field: 'category',
        label: 'Category',
        width: 120,
        filterWidgetType: VooFilterWidgetType.dropdown,
        filterOptions: [
          VooFilterOption(
            value: 'Electronics',
            label: 'Electronics',
            icon: Icons.devices,
          ),
          VooFilterOption(
            value: 'Books',
            label: 'Books',
            icon: Icons.book,
          ),
          VooFilterOption(
            value: 'Clothing',
            label: 'Clothing',
            icon: Icons.checkroom,
          ),
          VooFilterOption(
            value: 'Food',
            label: 'Food',
            icon: Icons.restaurant,
          ),
          VooFilterOption(
            value: 'Toys',
            label: 'Toys',
            icon: Icons.toys,
          ),
        ],
      ),
      VooDataColumn<dynamic>(
        field: 'price',
        label: 'Price',
        width: 100,
        filterWidgetType: VooFilterWidgetType.numberRange,
        valueFormatter: (value) => '\$${value.toStringAsFixed(2)}',
        filterHint: 'Min price...',
      ),
      const VooDataColumn<dynamic>(
        field: 'stock',
        label: 'Stock',
        width: 80,
        filterWidgetType: VooFilterWidgetType.numberField,
        filterHint: 'Min stock...',
      ),
      VooDataColumn<dynamic>(
        field: 'rating',
        label: 'Rating',
        width: 100,
        filterWidgetType: VooFilterWidgetType.numberRange,
        filterHint: 'Min rating...',
        cellBuilder: (context, value, row) {
          final rating = (value ?? 0.0) as double;
          return Row(
            children: List.generate(5, (i) {
              if (i < rating.floor()) {
                return const Icon(Icons.star, size: 14, color: Colors.amber);
              }
              return const Icon(Icons.star_border, size: 14, color: Colors.grey);
            }),
          );
        },
      ),
      VooDataColumn<dynamic>(
        field: 'created',
        label: 'Created Date',
        width: 120,
        filterWidgetType: VooFilterWidgetType.datePicker,
        valueFormatter: (value) {
          if (value is DateTime) {
            return '${value.month}/${value.day}/${value.year}';
          }
          return '';
        },
        filterHint: 'Select date...',
      ),
      VooDataColumn<dynamic>(
        field: 'available',
        label: 'Available',
        width: 100,
        filterWidgetType: VooFilterWidgetType.checkbox,
        cellBuilder: (context, value, row) {
          final isAvailable = value as bool? ?? false;
          return Icon(
            isAvailable ? Icons.check_circle : Icons.cancel,
            color: isAvailable ? Colors.green : Colors.red,
            size: 20,
          );
        },
      ),
      const VooDataColumn<dynamic>(
        field: 'supplier',
        label: 'Supplier',
        width: 120,
        filterWidgetType: VooFilterWidgetType.dropdown,
        filterOptions: [
          VooFilterOption(
            value: 'Supplier A',
            label: 'Supplier A',
          ),
          VooFilterOption(
            value: 'Supplier B',
            label: 'Supplier B',
          ),
          VooFilterOption(
            value: 'Supplier C',
            label: 'Supplier C',
          ),
        ],
      ),
    ],
    showFilters: true,
  );

  dataSource.loadData();

  return Material(
    child: SizedBox(
      height: 600,
      child: VooDataGrid(controller: controller),
    ),
  );
}

@Preview(name: 'API Output - Simple REST')
Widget apiOutputSimpleRest() {
  // Create request builder with Simple REST standard
  const requestBuilder = DataGridRequestBuilder(
    standard: ApiFilterStandard.simple,
  );

  // Build sample request
  final request = requestBuilder.buildRequest(
    page: 1,
    pageSize: 20,
    filters: {
      'name': const VooDataFilter(
        operator: VooFilterOperator.contains,
        value: 'John',
      ),
      'status': const VooDataFilter(
        operator: VooFilterOperator.equals,
        value: 'active',
      ),
    },
    sorts: [
      const VooColumnSort(field: 'name', direction: VooSortDirection.ascending),
    ],
  );

  final jsonOutput = const JsonEncoder.withIndent('  ').convert(request);

  return Material(
    child: Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Simple REST API Request:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
            ),
            child: SelectableText(
              jsonOutput,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

@Preview(name: 'API Output - JSON:API')
Widget apiOutputJsonApi() {
  const requestBuilder = DataGridRequestBuilder(
    standard: ApiFilterStandard.jsonApi,
  );

  final request = requestBuilder.buildRequest(
    page: 2,
    pageSize: 15,
    filters: {
      'category': const VooDataFilter(
        operator: VooFilterOperator.equals,
        value: 'electronics',
      ),
      'price': const VooDataFilter(
        operator: VooFilterOperator.greaterThan,
        value: 100,
      ),
    },
    sorts: [
      const VooColumnSort(field: 'price', direction: VooSortDirection.descending),
      const VooColumnSort(field: 'name', direction: VooSortDirection.ascending),
    ],
  );

  final jsonOutput = const JsonEncoder.withIndent('  ').convert(request);

  return Material(
    child: Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'JSON:API Request:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
            ),
            child: SelectableText(
              jsonOutput,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

@Preview(name: 'API Output - OData')
Widget apiOutputOData() {
  const requestBuilder = DataGridRequestBuilder(
    standard: ApiFilterStandard.odata,
  );

  final request = requestBuilder.buildRequest(
    page: 1,
    pageSize: 50,
    filters: {
      'department': const VooDataFilter(
        operator: VooFilterOperator.equals,
        value: 'Sales',
      ),
      'salary': const VooDataFilter(
        operator: VooFilterOperator.between,
        value: [50000, 100000],
      ),
    },
    sorts: [
      const VooColumnSort(field: 'salary', direction: VooSortDirection.descending),
    ],
  );

  final jsonOutput = const JsonEncoder.withIndent('  ').convert(request);

  return Material(
    child: Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'OData Request:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
            ),
            child: SelectableText(
              jsonOutput,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

@Preview(name: 'API Output - MongoDB')
Widget apiOutputMongoDB() {
  const requestBuilder = DataGridRequestBuilder(
    standard: ApiFilterStandard.mongodb,
  );

  final request = requestBuilder.buildRequest(
    page: 1,
    pageSize: 25,
    filters: {
      'status': const VooDataFilter(
        operator: VooFilterOperator.inList,
        value: ['active', 'pending'],
      ),
      'created': const VooDataFilter(
        operator: VooFilterOperator.greaterThanOrEqual,
        value: '2024-01-01',
      ),
    },
    sorts: [
      const VooColumnSort(field: 'created', direction: VooSortDirection.descending),
    ],
  );

  final jsonOutput = const JsonEncoder.withIndent('  ').convert(request);

  return Material(
    child: Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MongoDB Query:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
            ),
            child: SelectableText(
              jsonOutput,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

@Preview(name: 'API Output - Voo Standard')
Widget apiOutputVooStandard() {
  const requestBuilder = DataGridRequestBuilder(
    standard: ApiFilterStandard.voo,
  );

  final request = requestBuilder.buildRequest(
    page: 1,
    pageSize: 20,
    filters: {
      'Site.Name': const VooDataFilter(
        operator: VooFilterOperator.contains,
        value: 'Tech',
      ),
      'Client.CompanyName': const VooDataFilter(
        operator: VooFilterOperator.contains,
        value: 'Solutions',
      ),
      'Site.SiteNumber': const VooDataFilter(
        operator: VooFilterOperator.greaterThan,
        value: 1006,
      ),
      'OrderStatus': const VooDataFilter(
        operator: VooFilterOperator.equals,
        value: 0,
      ),
      'OrderDate': const VooDataFilter(
        operator: VooFilterOperator.greaterThanOrEqual,
        value: '2024-01-01T00:00:00Z',
      ),
      'OrderCost': const VooDataFilter(
        operator: VooFilterOperator.greaterThanOrEqual,
        value: 1000.00,
      ),
    },
    sorts: [
      const VooColumnSort(field: 'OrderDate', direction: VooSortDirection.descending),
    ],
  );

  final jsonOutput = const JsonEncoder.withIndent('  ').convert(request);

  return Material(
    child: Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Voo API Standard Request:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
            ),
            child: SelectableText(
              jsonOutput,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

@Preview(name: 'API Output - GraphQL')
Widget apiOutputGraphQL() {
  const requestBuilder = DataGridRequestBuilder(
    standard: ApiFilterStandard.graphql,
  );

  final request = requestBuilder.buildRequest(
    page: 3,
    pageSize: 10,
    filters: {
      'type': const VooDataFilter(
        operator: VooFilterOperator.equals,
        value: 'premium',
      ),
      'score': const VooDataFilter(
        operator: VooFilterOperator.greaterThanOrEqual,
        value: 4.5,
      ),
    },
    sorts: [
      const VooColumnSort(field: 'score', direction: VooSortDirection.descending),
    ],
  );

  final jsonOutput = const JsonEncoder.withIndent('  ').convert(request);

  return Material(
    child: Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'GraphQL Variables:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
            ),
            child: SelectableText(
              jsonOutput,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

@Preview(name: 'Single Sort Constraint')
Widget singleSortConstraint() {
  final data = List.generate(
    30,
    (index) => {
      'id': index + 1,
      'name': 'Item ${index + 1}',
      'value': (index + 1) * 10,
      'status': index % 2 == 0 ? 'Active' : 'Inactive',
    },
  );

  final dataSource = _LocalDataGridSource(data: data);

  final controller = VooDataGridController(
    dataSource: dataSource,
    columns: [
      const VooDataColumn<dynamic>(
        field: 'id',
        label: 'ID',
        width: 60,
      ),
      const VooDataColumn<dynamic>(
        field: 'name',
        label: 'Name',
        flex: 2,
      ),
      const VooDataColumn<dynamic>(
        field: 'value',
        label: 'Value',
        width: 100,
      ),
      const VooDataColumn<dynamic>(
        field: 'status',
        label: 'Status',
        width: 100,
      ),
    ],
    // constraints: VooDataGridConstraints.singleSort, // Constraints would be added here
  );

  dataSource.loadData();

  return Material(
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.blue.withValues(alpha: 0.1),
          child: const Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                'Single Sort Mode: Only one column can be sorted at a time',
                style: TextStyle(fontSize: 12, color: Colors.blue),
              ),
            ],
          ),
        ),
        Expanded(
          child: VooDataGrid(controller: controller),
        ),
      ],
    ),
  );
}

@Preview(name: 'Custom Cells Data Grid')
Widget customCellsDataGrid() {
  final employees = List.generate(
    30,
    (index) => {
      'id': index + 1,
      'name': [
        'John Doe',
        'Jane Smith',
        'Bob Johnson',
        'Alice Brown',
      ][index % 4],
      'department': ['Engineering', 'Sales', 'HR', 'Marketing'][index % 4],
      'salary': 50000 + (index * 2500),
      'performance': (index % 5) * 20 + 20,
      'active': index % 3 != 0,
    },
  );

  final dataSource = _LocalDataGridSource(data: employees);

  final controller = VooDataGridController(
    dataSource: dataSource,
    columns: [
      VooDataColumn<dynamic>(
        field: 'name',
        label: 'Employee',
        flex: 2,
        cellBuilder: (context, value, row) {
          final name = value as String;
          final initials = name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join();

          return Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Colors.blue.withValues(alpha: 0.2),
                child: Text(
                  initials,
                  style: const TextStyle(fontSize: 10, color: Colors.blue),
                ),
              ),
              const SizedBox(width: 8),
              Text(name),
            ],
          );
        },
      ),
      VooDataColumn<dynamic>(
        field: 'department',
        label: 'Department',
        width: 120,
        cellBuilder: (context, value, row) {
          final dept = value as String;
          final colors = {
            'Engineering': Colors.blue,
            'Sales': Colors.green,
            'HR': Colors.orange,
            'Marketing': Colors.purple,
          };

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: (colors[dept] ?? Colors.grey).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (colors[dept] ?? Colors.grey).withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              dept,
              style: TextStyle(
                color: colors[dept] ?? Colors.grey,
                fontSize: 12,
              ),
            ),
          );
        },
      ),
      VooDataColumn<dynamic>(
        field: 'salary',
        label: 'Salary',
        width: 100,
        valueFormatter: (value) => '\$${(value / 1000).toStringAsFixed(0)}k',
      ),
      VooDataColumn<dynamic>(
        field: 'performance',
        label: 'Performance',
        width: 120,
        cellBuilder: (context, value, row) {
          final performance = value as int;
          final color = performance >= 80
              ? Colors.green
              : performance >= 60
                  ? Colors.orange
                  : Colors.red;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$performance%', style: const TextStyle(fontSize: 10)),
              const SizedBox(height: 2),
              LinearProgressIndicator(
                value: performance / 100,
                backgroundColor: Colors.grey.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 3,
              ),
            ],
          );
        },
      ),
      VooDataColumn<dynamic>(
        field: 'active',
        label: 'Status',
        width: 80,
        cellBuilder: (context, value, row) {
          final active = value as bool;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active ? Colors.green : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                active ? 'Active' : 'Inactive',
                style: TextStyle(
                  fontSize: 11,
                  color: active ? Colors.green : Colors.grey,
                ),
              ),
            ],
          );
        },
      ),
    ],
  );

  dataSource.loadData();

  return Material(
    child: SizedBox(
      height: 450,
      child: VooDataGrid(controller: controller),
    ),
  );
}

@Preview(name: 'Primary Filters Data Grid')
Widget primaryFiltersDataGrid() => const PrimaryFiltersDataGridPreview();

class PrimaryFiltersDataGridPreview extends StatefulWidget {
  const PrimaryFiltersDataGridPreview({super.key});

  @override
  State<PrimaryFiltersDataGridPreview> createState() => _PrimaryFiltersDataGridPreviewState();
}

class _PrimaryFiltersDataGridPreviewState extends State<PrimaryFiltersDataGridPreview> {
  VooDataFilter? selectedFilter;
  late List<Map<String, dynamic>> orders;
  late _LocalDataGridSource dataSource;
  late VooDataGridController controller;
  late Map<String, int> statusCounts;

  @override
  void initState() {
    super.initState();

    // Sample order data
    orders = List.generate(
      100,
      (index) {
        final statuses = ['pending', 'processing', 'shipped', 'delivered', 'cancelled'];
        final status = statuses[index % 5];
        return {
          'id': 'ORD-${1000 + index}',
          'customer': 'Customer ${index % 20 + 1}',
          'product': 'Product ${index % 10 + 1}',
          'amount': (index + 1) * 25.99,
          'status': status,
          'date': DateTime.now().subtract(Duration(days: index)),
        };
      },
    );

    // Create data source with initial data
    dataSource = _LocalDataGridSource(data: orders);

    // Define columns
    controller = VooDataGridController(
      dataSource: dataSource,
      columns: [
        const VooDataColumn<dynamic>(
          field: 'id',
          label: 'Order ID',
          width: 100,
        ),
        const VooDataColumn<dynamic>(
          field: 'customer',
          label: 'Customer',
          flex: 2,
        ),
        const VooDataColumn<dynamic>(
          field: 'product',
          label: 'Product',
          flex: 2,
        ),
        VooDataColumn<dynamic>(
          field: 'amount',
          label: 'Amount',
          width: 100,
          valueFormatter: (value) => '\$${value.toStringAsFixed(2)}',
          textAlign: TextAlign.right,
        ),
        VooDataColumn<dynamic>(
          field: 'status',
          label: 'Status',
          width: 120,
          cellBuilder: (context, value, row) {
            final status = value as String;
            final colors = {
              'pending': Colors.orange,
              'processing': Colors.blue,
              'shipped': Colors.purple,
              'delivered': Colors.green,
              'cancelled': Colors.red,
            };
            final icons = {
              'pending': Icons.pending_outlined,
              'processing': Icons.settings,
              'shipped': Icons.local_shipping,
              'delivered': Icons.check_circle,
              'cancelled': Icons.cancel,
            };

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colors[status]?.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colors[status]?.withValues(alpha: 0.3) ?? Colors.grey,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icons[status],
                    size: 14,
                    color: colors[status],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: colors[status],
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        VooDataColumn<dynamic>(
          field: 'date',
          label: 'Date',
          width: 100,
          valueFormatter: (value) {
            if (value is DateTime) {
              return '${value.month}/${value.day}/${value.year}';
            }
            return '';
          },
        ),
      ],
    );

    dataSource.loadData();

    // Count orders by status
    statusCounts = <String, int>{};
    for (final order in orders) {
      final status = order['status'] as String?;
      if (status != null) {
        statusCounts[status] = (statusCounts[status] ?? 0) + 1;
      }
    }
  }

  @override
  Widget build(BuildContext context) => Material(
        child: SizedBox(
          height: 600,
          child: VooDataGrid(
            controller: controller,
            showPrimaryFilters: true,
            primaryFilters: [
              PrimaryFilter(
                field: 'status',
                label: 'Pending',
                icon: Icons.schedule,
                count: statusCounts['pending'],
                filter: const VooDataFilter(
                  operator: VooFilterOperator.equals,
                  value: 'pending',
                ),
              ),
              PrimaryFilter(
                field: 'status',
                label: 'Processing',
                icon: Icons.sync,
                count: statusCounts['processing'],
                filter: const VooDataFilter(
                  operator: VooFilterOperator.equals,
                  value: 'processing',
                ),
              ),
              PrimaryFilter(
                field: 'status',
                label: 'Shipped',
                icon: Icons.local_shipping_outlined,
                count: statusCounts['shipped'],
                filter: const VooDataFilter(
                  operator: VooFilterOperator.equals,
                  value: 'shipped',
                ),
              ),
              PrimaryFilter(
                field: 'status',
                label: 'Delivered',
                icon: Icons.check_circle_outline,
                count: statusCounts['delivered'],
                filter: const VooDataFilter(
                  operator: VooFilterOperator.equals,
                  value: 'delivered',
                ),
              ),
              PrimaryFilter(
                field: 'status',
                label: 'Cancelled',
                icon: Icons.cancel_outlined,
                count: statusCounts['cancelled'],
                filter: const VooDataFilter(
                  operator: VooFilterOperator.equals,
                  value: 'cancelled',
                ),
              ),
            ],
            selectedPrimaryFilter: selectedFilter,
            onFilterChanged: (field, filter) {
              setState(() {
                selectedFilter = filter;

                // Apply filter to data source
                if (filter != null) {
                  // Filter by selected status
                  final filteredData = orders.where((order) => order['status'] == filter.value).toList();
                  dataSource.setLocalData(filteredData);
                } else {
                  // Show all data
                  dataSource.setLocalData(orders);
                }
              });
            },
          ),
        ),
      );
}

@Preview(name: 'Stateless Data Grid')
Widget statelessDataGrid() => const StatelessDataGridPreview();

class StatelessDataGridPreview extends StatefulWidget {
  const StatelessDataGridPreview({super.key});

  @override
  State<StatelessDataGridPreview> createState() => _StatelessDataGridPreviewState();
}

class _StatelessDataGridPreviewState extends State<StatelessDataGridPreview> {
  late List<Map<String, dynamic>> products;
  late VooDataGridState<Map<String, dynamic>> currentState;
  late List<VooDataColumn<Map<String, dynamic>>> columns;

  @override
  void initState() {
    super.initState();

    // Sample data model
    products = List.generate(
      50,
      (index) => {
        'id': 'P${index + 1}',
        'name': 'Product ${index + 1}',
        'price': (index + 1) * 10.0,
        'stock': (index + 1) * 5,
        'category': index % 3 == 0
            ? 'Electronics'
            : index % 2 == 0
                ? 'Clothing'
                : 'Food',
        'created': DateTime.now().subtract(Duration(days: index)),
      },
    );

    // Create initial state
    currentState = VooDataGridState<Map<String, dynamic>>(
      rows: products.take(10).toList(),
      totalRows: products.length,
      pageSize: 10,
      sorts: [
        const VooColumnSort(
          field: 'name',
          direction: VooSortDirection.ascending,
        ),
      ],
      filters: {},
      filtersVisible: true,
    );

    // Define columns
    columns = [
      VooDataColumn<Map<String, dynamic>>(
        field: 'id',
        label: 'ID',
        width: 80,
        valueGetter: (row) => row['id'],
      ),
      VooDataColumn<Map<String, dynamic>>(
        field: 'name',
        label: 'Product Name',
        valueGetter: (row) => row['name'],
      ),
      VooDataColumn<Map<String, dynamic>>(
        field: 'price',
        label: 'Price',
        valueGetter: (row) => row['price'],
        valueFormatter: (value) => '\$${value.toStringAsFixed(2)}',
      ),
      VooDataColumn<Map<String, dynamic>>(
        field: 'stock',
        label: 'Stock',
        valueGetter: (row) => row['stock'],
        cellBuilder: (context, value, row) {
          final stock = value as int;
          final color = stock > 20
              ? Colors.green
              : stock > 10
                  ? Colors.orange
                  : Colors.red;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              stock.toString(),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
      VooDataColumn<Map<String, dynamic>>(
        field: 'category',
        label: 'Category',
        valueGetter: (row) => row['category'],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) => Material(
        child: SizedBox(
          height: 600,
          child: VooDataGridStateless<Map<String, dynamic>>(
            state: currentState,
            columns: columns,
            onToggleFilters: () {
              setState(() {
                currentState = currentState.copyWith(
                  filtersVisible: !currentState.filtersVisible,
                );
              });
            },
            onPageChanged: (page) {
              setState(() {
                final start = page * currentState.pageSize;
                final end = (start + currentState.pageSize).clamp(0, products.length);
                currentState = currentState.copyWith(
                  currentPage: page,
                  rows: products.sublist(start, end),
                );
              });
            },
            onPageSizeChanged: (size) {
              setState(() {
                currentState = currentState.copyWith(
                  pageSize: size,
                  currentPage: 0,
                  rows: products.take(size).toList(),
                );
              });
            },
            onSortChanged: (field, direction) {
              setState(() {
                List<VooColumnSort> newSorts = [];
                // ignore: unnecessary_null_comparison
                if (direction != null) {
                  newSorts = [
                    VooColumnSort(
                      field: field,
                      direction: direction,
                    ),
                  ];
                }

                // Sort the data
                final sortedProducts = List<Map<String, dynamic>>.from(products);
                if (newSorts.isNotEmpty) {
                  final sort = newSorts.first;
                  sortedProducts.sort((a, b) {
                    final aValue = a[sort.field];
                    final bValue = b[sort.field];
                    if (aValue == null && bValue == null) return 0;
                    if (aValue == null) return 1;
                    if (bValue == null) return -1;

                    final comparison = aValue.toString().compareTo(bValue.toString());
                    return sort.direction == VooSortDirection.ascending ? comparison : -comparison;
                  });
                }

                final start = currentState.currentPage * currentState.pageSize;
                final end = (start + currentState.pageSize).clamp(0, sortedProducts.length);

                currentState = currentState.copyWith(
                  sorts: newSorts,
                  rows: sortedProducts.sublist(start, end),
                );
              });
            },
            onFilterChanged: (field, filter) {
              setState(() {
                final newFilters = Map<String, VooDataFilter>.from(currentState.filters);
                if (filter == null) {
                  newFilters.remove(field);
                } else {
                  newFilters[field] = filter;
                }

                // Filter the data
                final filteredProducts = products.where((row) {
                  for (final entry in newFilters.entries) {
                    final value = row[entry.key]?.toString().toLowerCase() ?? '';
                    final filterValue = entry.value.value?.toString().toLowerCase() ?? '';
                    if (!value.contains(filterValue)) {
                      return false;
                    }
                  }
                  return true;
                }).toList();

                const start = 0; // Reset to first page when filtering
                final end = currentState.pageSize.clamp(0, filteredProducts.length);

                currentState = currentState.copyWith(
                  filters: newFilters,
                  currentPage: 0,
                  rows: filteredProducts.sublist(start, end),
                  totalRows: filteredProducts.length,
                );
              });
            },
            onRowTap: (row) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tapped: ${row['name']}'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ),
      );
}
