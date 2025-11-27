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
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
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
    _dataSource = AdvancedRemoteDataSource(
      apiEndpoint: '/api/orders',
      httpClient: _mockHttpClient,
      useAdvancedFilters: true,
    );

    // Initialize controller with columns
    _controller = VooDataGridController(
      dataSource: _dataSource,
      columns: [
        const VooDataColumn(
          field: 'siteNumber',
          label: 'Site #',
          sortable: true,
          filterable: true,
          width: 80,
        ),
        const VooDataColumn(
          field: 'siteName',
          label: 'Site Name',
          sortable: true,
          filterable: true,
          width: 250,
        ),
        const VooDataColumn(
          field: 'siteAddress',
          label: 'Address',
          sortable: true,
          filterable: true,
          width: 200,
        ),
        const VooDataColumn(
          field: 'clientCompanyName',
          label: 'Client Company',
          sortable: true,
          filterable: true,
          width: 250,
        ),
        const VooDataColumn(
          field: 'projectManager',
          label: 'PM',
          sortable: true,
          filterable: true,
          width: 120,
        ),
        VooDataColumn(
          field: 'orderStatus',
          label: 'Status',
          sortable: true,
          filterable: true,
          width: 120,
          filterWidgetType: VooFilterWidgetType.dropdown,
          filterOptions: const [
            VooFilterOption(value: 'Pending', label: 'Pending'),
            VooFilterOption(value: 'Processing', label: 'Processing'),
            VooFilterOption(value: 'Shipped', label: 'Shipped'),
            VooFilterOption(value: 'Delivered', label: 'Delivered'),
            VooFilterOption(value: 'Hold', label: 'On Hold'),
            VooFilterOption(value: 'Cancelled', label: 'Cancelled'),
            VooFilterOption(value: 'Refunded', label: 'Refunded'),
          ],
        ),
        VooDataColumn(
          field: 'priority',
          label: 'Priority',
          sortable: true,
          filterable: true,
          width: 100,
          filterWidgetType: VooFilterWidgetType.dropdown,
          filterOptions: const [
            VooFilterOption(value: 'Low', label: 'Low'),
            VooFilterOption(value: 'Medium', label: 'Medium'),
            VooFilterOption(value: 'High', label: 'High'),
            VooFilterOption(value: 'Urgent', label: 'Urgent'),
            VooFilterOption(value: 'Critical', label: 'Critical'),
          ],
        ),
        const VooDataColumn(
          field: 'orderDate',
          label: 'Order Date',
          sortable: true,
          filterable: true,
          width: 130,
          dataType: VooDataColumnType.date,
          filterWidgetType: VooFilterWidgetType.datePicker,
        ),
        const VooDataColumn(
          field: 'dueDate',
          label: 'Due Date',
          sortable: true,
          filterable: true,
          width: 130,
          dataType: VooDataColumnType.date,
          filterWidgetType: VooFilterWidgetType.datePicker,
        ),
        const VooDataColumn(
          field: 'orderCost',
          label: 'Cost',
          sortable: true,
          filterable: true,
          width: 120,
          textAlign: TextAlign.right,
          dataType: VooDataColumnType.number,
          filterWidgetType: VooFilterWidgetType.numberField,
        ),
        const VooDataColumn(
          field: 'notes',
          label: 'Notes',
          sortable: false,
          filterable: true,
          width: 200,
        ),
      ],
    );
  }

  // Mock HTTP client for demonstration
  Future<Map<String, dynamic>> _mockHttpClient(
    String url,
    Map<String, dynamic> body,
    Map<String, String>? headers,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Generate mock data based on filters
    final random = Random();
    final statuses = [
      'Pending',
      'Processing',
      'Shipped',
      'Delivered',
      'Hold',
      'Cancelled',
      'Refunded',
    ];
    final clients = [
      'Tech Solutions Inc',
      'Summit Medical Properties',
      'Global Logistics Corp',
      'Innovation Labs LLC',
      'Digital Services Group',
      'Enterprise Resource Planning Solutions International Corp',
      'Advanced Manufacturing Systems & Technologies Ltd',
      'Healthcare Management Consulting Partners',
      'Financial Advisory Services LLC',
      'Real Estate Development & Investment Group',
      'Environmental Solutions & Sustainability Consulting',
      'Telecommunications Infrastructure Management Inc',
      'Data Analytics & Business Intelligence Solutions',
      'Supply Chain Optimization Specialists',
      'Cloud Computing & Infrastructure Services',
    ];

    final siteNames = [
      'Main Distribution Center',
      'Regional Office Complex Building A',
      'Manufacturing Plant #3',
      'Research & Development Facility',
      'Corporate Headquarters',
      'Warehouse Facility North',
      'Customer Service Center',
      'Technical Support Hub',
      'Data Processing Center',
      'Quality Assurance Laboratory',
      'International Operations Center',
      'Emergency Response Facility',
      'Training & Development Campus',
      'Innovation Lab & Testing Facility',
      'Logistics Hub - East Coast Operations',
    ];

    final addresses = [
      '123 Main Street, Boston, MA 02101',
      '456 Commerce Blvd, Suite 200, New York, NY 10001',
      '789 Industrial Way, Los Angeles, CA 90001',
      '321 Technology Drive, Austin, TX 78701',
      '654 Business Park Lane, Chicago, IL 60601',
      '987 Corporate Center, Atlanta, GA 30301',
      '147 Market Street, San Francisco, CA 94102',
      '258 Innovation Avenue, Seattle, WA 98101',
      '369 Enterprise Road, Miami, FL 33101',
      '741 Development Plaza, Denver, CO 80201',
    ];

    final projectManagers = [
      'John Smith',
      'Jane Doe',
      'Michael Johnson',
      'Emily Williams',
      'Robert Brown',
      'Sarah Davis',
      'William Miller',
      'Jennifer Wilson',
      'David Garcia',
      'Lisa Anderson',
    ];

    final priorities = ['Low', 'Medium', 'High', 'Urgent', 'Critical'];

    final notes = [
      'Standard processing required',
      'Expedited shipping requested by client',
      'Requires additional quality checks before shipment',
      'Special handling instructions: Fragile equipment',
      'Customer requested delivery confirmation',
      'Bulk order - coordinate with warehouse team',
      'Pending approval from management',
      'Follow-up required with supplier',
      'Documentation needs to be updated',
      'Priority customer - handle with care',
      '',
      '',
      '', // Some empty notes for variety
    ];

    // Generate larger dataset for testing PDF export
    final dataCount = 500; // Increase to 500 rows for better testing
    final data = List.generate(dataCount, (index) {
      final siteNumber = 68000 + index;
      final orderDate = DateTime.now().subtract(
        Duration(days: random.nextInt(365)),
      );
      final dueDate = orderDate.add(Duration(days: 7 + random.nextInt(21)));

      return {
        'siteNumber': siteNumber,
        'siteName':
            '${siteNames[random.nextInt(siteNames.length)]} - Unit ${index % 20 + 1}',
        'siteAddress': addresses[random.nextInt(addresses.length)],
        'clientCompanyName': clients[random.nextInt(clients.length)],
        'projectManager':
            projectManagers[random.nextInt(projectManagers.length)],
        'orderStatus': statuses[random.nextInt(statuses.length)],
        'priority': priorities[random.nextInt(priorities.length)],
        'orderDate': orderDate.toIso8601String(),
        'dueDate': dueDate.toIso8601String(),
        'orderCost': (random.nextDouble() * 50000).toStringAsFixed(2),
        'notes': notes[random.nextInt(notes.length)],
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
          final itemValue =
              item[_fieldNameToKey(field)]?.toString().toLowerCase() ?? '';

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

    return {
      'data': filteredData,
      'total': filteredData.length,
      'page': body['pageNumber'] ?? 1,
      'pageSize': body['pageSize'] ?? 50,
    };
  }

  String _fieldNameToKey(String fieldName) {
    // Convert field names like "Site.Name" to "siteName"
    if (fieldName == 'Name' || fieldName == 'SiteName') return 'siteName';
    if (fieldName == 'SiteNumber') return 'siteNumber';
    if (fieldName == 'SiteAddress') return 'siteAddress';
    if (fieldName == 'CompanyName') return 'clientCompanyName';
    if (fieldName == 'ProjectManager') return 'projectManager';
    if (fieldName == 'OrderStatus') return 'orderStatus';
    if (fieldName == 'Priority') return 'priority';
    if (fieldName == 'OrderDate') return 'orderDate';
    if (fieldName == 'DueDate') return 'dueDate';
    if (fieldName == 'OrderCost') return 'orderCost';
    if (fieldName == 'Notes') return 'notes';
    return fieldName;
  }

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;

    return Scaffold(
      appBar: AppBar(
        title: const Text('VooDataGrid Advanced Filtering'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
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
                    Text(
                      'Demo Controls',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
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
                  FilterFieldConfig(
                    fieldName: 'Site.SiteNumber',
                    displayName: 'Site Number',
                    type: FilterType.int,
                  ),
                  FilterFieldConfig(
                    fieldName: 'Site.Name',
                    displayName: 'Site Name',
                    type: FilterType.string,
                  ),
                  FilterFieldConfig(
                    fieldName: 'Site.Address',
                    displayName: 'Site Address',
                    type: FilterType.string,
                  ),
                  FilterFieldConfig(
                    fieldName: 'Client.CompanyName',
                    displayName: 'Client Company',
                    type: FilterType.string,
                  ),
                  FilterFieldConfig(
                    fieldName: 'ProjectManager',
                    displayName: 'Project Manager',
                    type: FilterType.string,
                  ),
                  FilterFieldConfig(
                    fieldName: 'OrderStatus',
                    displayName: 'Order Status',
                    type: FilterType.string,
                  ),
                  FilterFieldConfig(
                    fieldName: 'Priority',
                    displayName: 'Priority',
                    type: FilterType.string,
                  ),
                  FilterFieldConfig(
                    fieldName: 'OrderDate',
                    displayName: 'Order Date',
                    type: FilterType.date,
                  ),
                  FilterFieldConfig(
                    fieldName: 'DueDate',
                    displayName: 'Due Date',
                    type: FilterType.date,
                  ),
                  FilterFieldConfig(
                    fieldName: 'OrderCost',
                    displayName: 'Order Cost',
                    type: FilterType.decimal,
                  ),
                  FilterFieldConfig(
                    fieldName: 'Notes',
                    displayName: 'Notes',
                    type: FilterType.string,
                  ),
                ],
                onFilterApplied: (request) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Applied ${request.hasFilters ? "filters" : "no filters"}',
                      ),
                    ),
                  );
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
                    filter: const VooDataFilter(
                      operator: VooFilterOperator.equals,
                      value: 'Pending',
                    ),
                  ),
                  PrimaryFilter(
                    field: 'orderStatus',
                    label: 'Processing',
                    icon: Icons.settings,
                    count: 5,
                    filter: const VooDataFilter(
                      operator: VooFilterOperator.equals,
                      value: 'Processing',
                    ),
                  ),
                  PrimaryFilter(
                    field: 'orderStatus',
                    label: 'Shipped',
                    icon: Icons.local_shipping,
                    count: 23,
                    filter: const VooDataFilter(
                      operator: VooFilterOperator.equals,
                      value: 'Shipped',
                    ),
                  ),
                  PrimaryFilter(
                    field: 'orderStatus',
                    label: 'Delivered',
                    icon: Icons.check_circle,
                    count: 45,
                    filter: const VooDataFilter(
                      operator: VooFilterOperator.equals,
                      value: 'Delivered',
                    ),
                  ),
                  PrimaryFilter(
                    field: 'orderStatus',
                    label: 'On Hold',
                    icon: Icons.pause_circle,
                    count: 3,
                    filter: const VooDataFilter(
                      operator: VooFilterOperator.equals,
                      value: 'Hold',
                    ),
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
                emptyStateWidget: const VooEmptyState(
                  icon: Icons.table_rows_outlined,
                  title: 'No Data',
                  message: 'Apply filters to see results',
                ),
                onRowTap: (row) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Tapped: Site ${row['siteNumber']}'),
                    ),
                  );
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
          secondaryFilter: const SecondaryFilter(
            logic: FilterLogic.and,
            value: 1011,
            operator: 'LessThan',
          ),
        ),
      ],
      pageNumber: 1,
      pageSize: 20,
    );

    _dataSource.setAdvancedFilterRequest(request);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Applied: Site Number > 1006 AND < 1011')),
    );
  }

  void _applyExampleFilter2() {
    // Example: Site name contains "Tech" but not "Park"
    final request = AdvancedFilterRequest(
      stringFilters: [
        StringFilter(
          fieldName: 'Site.Name',
          value: 'Tech',
          operator: 'Contains',
          secondaryFilter: const SecondaryFilter(
            logic: FilterLogic.and,
            value: 'Park',
            operator: 'NotContains',
          ),
        ),
      ],
      pageNumber: 1,
      pageSize: 20,
    );

    _dataSource.setAdvancedFilterRequest(request);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Applied: Site Name contains "Tech" AND not "Park"'),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
