import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: MaterialApp(
        title: 'VooDataGrid Advanced Filtering Demo',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true),
        home: const DataGridExamplePage(),
      ),
    );
  }
}

class DataGridExamplePage extends StatefulWidget {
  const DataGridExamplePage({super.key});

  @override
  State<DataGridExamplePage> createState() => _DataGridExamplePageState();
}

class _DataGridExamplePageState extends State<DataGridExamplePage> {
  late VooDataGridController _controller;
  late AdvancedRemoteDataSource _dataSource;
  bool _showAdvancedFilters = false;
  VooDataFilter? _selectedPrimaryFilter;

  @override
  void initState() {
    super.initState();

    // Initialize data source with mock API
    _dataSource = AdvancedRemoteDataSource(apiEndpoint: '/api/orders', httpClient: _mockHttpClient, useAdvancedFilters: true);

    // Initialize controller with columns
    _controller = VooDataGridController(
      dataSource: _dataSource,
      columns: [
        const VooDataColumn(field: 'siteNumber', label: 'Site Number', sortable: true, filterable: true, width: 120),
        const VooDataColumn(field: 'siteName', label: 'Site Name', sortable: true, filterable: true, width: 200),
        const VooDataColumn(field: 'clientCompanyName', label: 'Client', sortable: true, filterable: true, width: 200),
        const VooDataColumn(field: 'orderStatus', label: 'Status', sortable: true, filterable: true, width: 120),
        const VooDataColumn(field: 'orderDate', label: 'Order Date', sortable: true, filterable: true, width: 150),
        const VooDataColumn(field: 'orderCost', label: 'Cost', sortable: true, filterable: true, width: 120, textAlign: TextAlign.right),
      ],
    );
  }

  // Mock HTTP client for demonstration
  Future<Map<String, dynamic>> _mockHttpClient(String url, Map<String, dynamic> body, Map<String, String>? headers) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Generate mock data based on filters
    final random = Random();
    final statuses = ['Pending', 'Processing', 'Shipped', 'Delivered', 'Hold'];
    final clients = ['Tech Solutions Inc', 'Summit Medical Properties', 'Global Logistics Corp', 'Innovation Labs LLC', 'Digital Services Group'];

    final data = List.generate(20, (index) {
      final siteNumber = 1000 + random.nextInt(100);
      return {
        'siteNumber': siteNumber,
        'siteName': 'Site ${siteNumber % 10 + 1}',
        'clientCompanyName': clients[random.nextInt(clients.length)],
        'orderStatus': statuses[random.nextInt(statuses.length)],
        'orderDate': DateTime.now().subtract(Duration(days: random.nextInt(365))).toIso8601String(),
        'orderCost': (random.nextDouble() * 10000).toStringAsFixed(2),
      };
    });

    // Apply filters if present
    var filteredData = List.from(data);

    // Check for advanced filters
    if (body.containsKey('stringFilters')) {
      final stringFilters = body['stringFilters'] as List<dynamic>? ?? [];
      for (final filter in stringFilters) {
        final field = filter['fieldName'].toString().split('.').last;
        final value = filter['value'].toString().toLowerCase();
        final operator = filter['operator'];

        filteredData = filteredData.where((item) {
          final itemValue = item[_fieldNameToKey(field)]?.toString().toLowerCase() ?? '';

          switch (operator) {
            case 'Contains':
              return itemValue.contains(value);
            case 'NotContains':
              return !itemValue.contains(value);
            case 'StartsWith':
              return itemValue.startsWith(value);
            case 'EndsWith':
              return itemValue.endsWith(value);
            case 'Equals':
              return itemValue == value;
            case 'NotEquals':
              return itemValue != value;
            default:
              return true;
          }
        }).toList();
      }
    }

    if (body.containsKey('intFilters')) {
      final intFilters = body['intFilters'] as List<dynamic>? ?? [];
      for (final filter in intFilters) {
        final field = filter['fieldName'].toString().split('.').last;
        final value = filter['value'] as int;
        final operator = filter['operator'];

        filteredData = filteredData.where((item) {
          final itemValue = item[_fieldNameToKey(field)] as int? ?? 0;

          switch (operator) {
            case 'GreaterThan':
              return itemValue > value;
            case 'GreaterThanOrEqual':
              return itemValue >= value;
            case 'LessThan':
              return itemValue < value;
            case 'LessThanOrEqual':
              return itemValue <= value;
            case 'Equals':
              return itemValue == value;
            case 'NotEquals':
              return itemValue != value;
            default:
              return true;
          }
        }).toList();

        // Handle secondary filter
        if (filter['secondaryFilter'] != null) {
          final secondaryFilter = filter['secondaryFilter'];
          final secondaryValue = secondaryFilter['value'] as int;
          final secondaryOperator = secondaryFilter['operator'];
          final logic = secondaryFilter['logic'];

          if (logic == 'And') {
            filteredData = filteredData.where((item) {
              final itemValue = item[_fieldNameToKey(field)] as int? ?? 0;
              switch (secondaryOperator) {
                case 'LessThan':
                  return itemValue < secondaryValue;
                case 'LessThanOrEqual':
                  return itemValue <= secondaryValue;
                case 'GreaterThan':
                  return itemValue > secondaryValue;
                case 'GreaterThanOrEqual':
                  return itemValue >= secondaryValue;
                default:
                  return true;
              }
            }).toList();
          }
        }
      }
    }

    return {'data': filteredData, 'total': filteredData.length, 'page': body['pageNumber'] ?? 1, 'pageSize': body['pageSize'] ?? 20};
  }

  String _fieldNameToKey(String fieldName) {
    // Convert field names like "Site.Name" to "siteName"
    if (fieldName == 'Name' || fieldName == 'SiteName') return 'siteName';
    if (fieldName == 'SiteNumber') return 'siteNumber';
    if (fieldName == 'CompanyName') return 'clientCompanyName';
    if (fieldName == 'OrderStatus') return 'orderStatus';
    if (fieldName == 'OrderDate') return 'orderDate';
    if (fieldName == 'OrderCost') return 'orderCost';
    return fieldName;
  }

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;

    return Scaffold(
      appBar: AppBar(title: const Text('VooDataGrid Advanced Filtering'), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Padding(
        padding: EdgeInsets.all(design.spacingMd),
        child: Column(
          children: [
            // Demo controls
            Card(
              child: Padding(
                padding: EdgeInsets.all(design.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Demo Controls', style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(height: design.spacingSm),
                    Wrap(
                      spacing: design.spacingSm,
                      runSpacing: design.spacingSm,
                      children: [
                        FilledButton.icon(
                          icon: const Icon(Icons.filter_alt),
                          label: const Text('Show Advanced Filters'),
                          onPressed: () {
                            setState(() {
                              _showAdvancedFilters = !_showAdvancedFilters;
                            });
                          },
                        ),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.code),
                          label: const Text('Example: Site Number Range'),
                          onPressed: () {
                            _applyExampleFilter1();
                          },
                        ),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.code),
                          label: const Text('Example: Complex String Filter'),
                          onPressed: () {
                            _applyExampleFilter2();
                          },
                        ),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.clear),
                          label: const Text('Clear Filters'),
                          onPressed: () {
                            _dataSource.clearAdvancedFilters();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: design.spacingMd),

            // Advanced filter widget
            if (_showAdvancedFilters) ...[
              AdvancedFilterWidget(
                dataSource: _dataSource,
                fields: const [
                  FilterFieldConfig(fieldName: 'Site.SiteNumber', displayName: 'Site Number', type: FilterType.int),
                  FilterFieldConfig(fieldName: 'Site.Name', displayName: 'Site Name', type: FilterType.string),
                  FilterFieldConfig(fieldName: 'Client.CompanyName', displayName: 'Client Company', type: FilterType.string),
                  FilterFieldConfig(fieldName: 'OrderStatus', displayName: 'Order Status', type: FilterType.string),
                  FilterFieldConfig(fieldName: 'OrderDate', displayName: 'Order Date', type: FilterType.date),
                  FilterFieldConfig(fieldName: 'OrderCost', displayName: 'Order Cost', type: FilterType.decimal),
                ],
                onFilterApplied: (request) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Applied ${request.hasFilters ? "filters" : "no filters"}')));
                },
              ),
              SizedBox(height: design.spacingMd),
            ],

            // Data grid
            Expanded(
              child: VooDataGrid(
                showExportButton: true,
                controller: _controller,
                showToolbar: true,
                showPagination: true,
                showPrimaryFilters: true,
                primaryFilters: [
                  PrimaryFilter(
                    field: 'orderStatus',
                    label: 'Pending',
                    icon: Icons.pending_outlined,
                    count: 12,
                    filter: const VooDataFilter(operator: VooFilterOperator.equals, value: 'Pending'),
                  ),
                  PrimaryFilter(
                    field: 'orderStatus',
                    label: 'Processing',
                    icon: Icons.settings,
                    count: 5,
                    filter: const VooDataFilter(operator: VooFilterOperator.equals, value: 'Processing'),
                  ),
                  PrimaryFilter(
                    field: 'orderStatus',
                    label: 'Shipped',
                    icon: Icons.local_shipping,
                    count: 23,
                    filter: const VooDataFilter(operator: VooFilterOperator.equals, value: 'Shipped'),
                  ),
                  PrimaryFilter(
                    field: 'orderStatus',
                    label: 'Delivered',
                    icon: Icons.check_circle,
                    count: 45,
                    filter: const VooDataFilter(operator: VooFilterOperator.equals, value: 'Delivered'),
                  ),
                  PrimaryFilter(
                    field: 'orderStatus',
                    label: 'On Hold',
                    icon: Icons.pause_circle,
                    count: 3,
                    filter: const VooDataFilter(operator: VooFilterOperator.equals, value: 'Hold'),
                  ),
                ],
                selectedPrimaryFilter: _selectedPrimaryFilter,
                onFilterChanged: (field, filter) {
                  setState(() {
                    _selectedPrimaryFilter = filter;
                  });

                  // Apply the filter directly to the data source
                  _dataSource.applyFilter(field, filter);
                },
                theme: VooDataGridTheme.fromContext(context),
                emptyStateWidget: const VooEmptyState(icon: Icons.table_rows_outlined, title: 'No Data', message: 'Apply filters to see results'),
                onRowTap: (row) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tapped: Site ${row['siteNumber']}')));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _applyExampleFilter1() {
    // Example: Site number between 1006 and 1011
    final request = AdvancedFilterRequest(
      intFilters: [
        IntFilter(
          fieldName: 'Site.SiteNumber',
          value: 1006,
          operator: 'GreaterThan',
          secondaryFilter: const SecondaryFilter(logic: FilterLogic.and, value: 1011, operator: 'LessThan'),
        ),
      ],
      pageNumber: 1,
      pageSize: 20,
    );

    _dataSource.setAdvancedFilterRequest(request);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Applied: Site Number > 1006 AND < 1011')));
  }

  void _applyExampleFilter2() {
    // Example: Site name contains "Tech" but not "Park"
    final request = AdvancedFilterRequest(
      stringFilters: [
        StringFilter(
          fieldName: 'Site.Name',
          value: 'Tech',
          operator: 'Contains',
          secondaryFilter: const SecondaryFilter(logic: FilterLogic.and, value: 'Park', operator: 'NotContains'),
        ),
      ],
      pageNumber: 1,
      pageSize: 20,
    );

    _dataSource.setAdvancedFilterRequest(request);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Applied: Site Name contains "Tech" AND not "Park"')));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
