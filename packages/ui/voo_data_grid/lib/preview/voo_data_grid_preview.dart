import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';
import 'dart:math';
import 'dart:convert';
import 'voo_data_grid_preview_empty.dart' show VooDataGridEmptyStatePreview;

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WidgetPreviewScaffold(),
  ));
}

class WidgetPreviewScaffold extends StatelessWidget {
  const WidgetPreviewScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voo Data Grid Previews'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Basic Data Grid'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VooDataGridBasicPreview(),
              ),
            ),
          ),
          ListTile(
            title: const Text('Large Dataset with Scrolling'),
            subtitle:
                const Text('100+ rows, 15+ columns for testing scrolling'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VooDataGridLargeDatasetPreview(),
              ),
            ),
          ),
          ListTile(
            title: const Text('Advanced Filtering with API Output'),
            subtitle:
                const Text('Complex filters with request/response display'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const VooDataGridAdvancedFilteringPreview(),
              ),
            ),
          ),
          ListTile(
            title: const Text('Synchronized Scrolling Demo'),
            subtitle: const Text('Shows header/body scroll synchronization'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const VooDataGridSynchronizedScrollingPreview(),
              ),
            ),
          ),
          ListTile(
            title: const Text('Real-world Order Management'),
            subtitle: const Text('Complete example with all features'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VooDataGridOrderManagementPreview(),
              ),
            ),
          ),
          ListTile(
            title: const Text('Filterable Data Grid'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VooDataGridFilterablePreview(),
              ),
            ),
          ),
          ListTile(
            title: const Text('Selectable Data Grid'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VooDataGridSelectablePreview(),
              ),
            ),
          ),
          ListTile(
            title: const Text('Paginated Data Grid'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VooDataGridPaginatedPreview(),
              ),
            ),
          ),
          ListTile(
            title: const Text('Empty State with Headers'),
            subtitle: const Text('Shows column headers even with no data'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VooDataGridEmptyStatePreview(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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

// Mock data generator
class MockDataGenerator {
  static final Random _random = Random();

  static final List<String> _firstNames = [
    'John',
    'Jane',
    'Michael',
    'Sarah',
    'David',
    'Emily',
    'James',
    'Jessica',
    'Robert',
    'Jennifer',
    'William',
    'Linda',
    'Richard',
    'Patricia',
    'Thomas'
  ];

  static final List<String> _lastNames = [
    'Smith',
    'Johnson',
    'Williams',
    'Brown',
    'Jones',
    'Garcia',
    'Miller',
    'Davis',
    'Rodriguez',
    'Martinez',
    'Hernandez',
    'Lopez',
    'Gonzalez'
  ];

  static final List<String> _companies = [
    'Tech Solutions Inc',
    'Global Systems Corp',
    'Innovation Labs LLC',
    'Digital Services Group',
    'Cloud Computing Co',
    'Data Analytics Inc',
    'Software Development Ltd',
    'Mobile Apps Inc',
    'AI Research Corp',
    'Blockchain Technologies',
    'Quantum Computing Lab',
    'Cybersecurity Systems'
  ];

  static final List<String> _departments = [
    'Engineering',
    'Sales',
    'Marketing',
    'HR',
    'Finance',
    'Operations',
    'Customer Support',
    'Research',
    'Legal',
    'IT',
    'Product',
    'Design'
  ];

  static final List<String> _locations = [
    'New York, NY',
    'San Francisco, CA',
    'Austin, TX',
    'Seattle, WA',
    'Boston, MA',
    'Chicago, IL',
    'Denver, CO',
    'Miami, FL',
    'Portland, OR',
    'Atlanta, GA',
    'Phoenix, AZ',
    'Las Vegas, NV',
    'Nashville, TN'
  ];

  static final List<String> _statuses = [
    'Active',
    'Pending',
    'Inactive',
    'Hold',
    'Processing'
  ];

  static final List<String> _products = [
    'Laptop Pro',
    'Smartphone X',
    'Tablet Ultra',
    'Smart Watch',
    'Wireless Earbuds',
    'Monitor 4K',
    'Keyboard Mechanical',
    'Mouse Gaming',
    'Webcam HD',
    'Microphone USB',
    'Speaker Bluetooth',
    'Headphones Noise Canceling',
    'Charger Fast',
    'Cable USB-C',
    'Hub USB',
    'SSD External',
    'Router WiFi 6',
    'Smart Home Hub',
    'Security Camera'
  ];

  static String randomName() =>
      '${_firstNames[_random.nextInt(_firstNames.length)]} ${_lastNames[_random.nextInt(_lastNames.length)]}';

  static String randomCompany() =>
      _companies[_random.nextInt(_companies.length)];

  static String randomDepartment() =>
      _departments[_random.nextInt(_departments.length)];

  static String randomLocation() =>
      _locations[_random.nextInt(_locations.length)];

  static String randomStatus() => _statuses[_random.nextInt(_statuses.length)];

  static String randomProduct() => _products[_random.nextInt(_products.length)];

  static String randomEmail(String name) =>
      '${name.toLowerCase().replaceAll(' ', '.')}@${[
        'gmail.com',
        'company.com',
        'email.com'
      ][_random.nextInt(3)]}';

  static String randomPhone() =>
      '+1 (${_random.nextInt(900) + 100}) ${_random.nextInt(900) + 100}-${_random.nextInt(9000) + 1000}';

  static double randomPrice() => _random.nextDouble() * 10000;

  static int randomQuantity() => _random.nextInt(1000) + 1;

  static DateTime randomDate() =>
      DateTime.now().subtract(Duration(days: _random.nextInt(365)));

  static Map<String, dynamic> generateEmployee(int id) {
    final name = randomName();
    return {
      'id': id,
      'employeeId': 'EMP${id.toString().padLeft(6, '0')}',
      'name': name,
      'email': randomEmail(name),
      'phone': randomPhone(),
      'department': randomDepartment(),
      'location': randomLocation(),
      'company': randomCompany(),
      'salary': randomPrice() * 10,
      'startDate': randomDate().toIso8601String(),
      'status': randomStatus(),
      'performanceScore': (_random.nextDouble() * 5).toStringAsFixed(1),
      'projectsCompleted': randomQuantity() ~/ 10,
      'hoursWorked': randomQuantity() * 2,
      'vacationDays': _random.nextInt(30),
      'manager': randomName(),
    };
  }

  static Map<String, dynamic> generateOrder(int id) {
    return {
      'orderId': 'ORD${id.toString().padLeft(8, '0')}',
      'orderDate': randomDate().toIso8601String(),
      'customerId': 'CUST${_random.nextInt(10000).toString().padLeft(6, '0')}',
      'customerName': randomName(),
      'customerCompany': randomCompany(),
      'customerEmail': randomEmail(randomName()),
      'shippingAddress': randomLocation(),
      'billingAddress': randomLocation(),
      'product': randomProduct(),
      'quantity': randomQuantity(),
      'unitPrice': randomPrice(),
      'totalAmount': randomPrice() * randomQuantity(),
      'discount': _random.nextDouble() * 100,
      'tax': _random.nextDouble() * 100,
      'shippingCost': _random.nextDouble() * 50,
      'orderStatus': randomStatus(),
      'paymentMethod': [
        'Credit Card',
        'PayPal',
        'Bank Transfer',
        'Check'
      ][_random.nextInt(4)],
      'trackingNumber':
          'TRK${_random.nextInt(999999999).toString().padLeft(9, '0')}',
      'estimatedDelivery': DateTime.now()
          .add(Duration(days: _random.nextInt(30)))
          .toIso8601String(),
      'notes': 'Customer notes for order $id',
    };
  }
}

// Widget previews for voo_data_grid components

@pragma('preview')
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
        const VooDataColumn(
          field: 'id',
          label: 'ID',
          width: 60,
          sortable: true,
        ),
        const VooDataColumn(
          field: 'name',
          label: 'Name',
          flex: 2,
          sortable: true,
        ),
        const VooDataColumn(
          field: 'email',
          label: 'Email',
          flex: 3,
          sortable: true,
        ),
        const VooDataColumn(
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
    return VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Basic Data Grid'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: VooDataGrid(
              controller: _controller,
              onRowTap: (data) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Selected: ${data['name']}')),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

@pragma('preview')
class VooDataGridLargeDatasetPreview extends StatefulWidget {
  const VooDataGridLargeDatasetPreview({super.key});

  @override
  State<VooDataGridLargeDatasetPreview> createState() =>
      _VooDataGridLargeDatasetPreviewState();
}

class _VooDataGridLargeDatasetPreviewState
    extends State<VooDataGridLargeDatasetPreview> {
  late VooDataGridController _controller;
  late LocalDataGridSource _dataSource;

  @override
  void initState() {
    super.initState();

    // Generate large dataset with many columns for scrolling
    final employees =
        List.generate(200, (i) => MockDataGenerator.generateEmployee(i + 1));

    _dataSource = LocalDataGridSource(data: employees);
    _dataSource.changePageSize(50);

    _controller = VooDataGridController(
      dataSource: _dataSource,
      columns: [
        const VooDataColumn(
          field: 'employeeId',
          label: 'Employee ID',
          width: 120,
          frozen: true, // Frozen column
          sortable: true,
        ),
        const VooDataColumn(
          field: 'name',
          label: 'Full Name',
          width: 150,
          frozen: true, // Frozen column
          sortable: true,
        ),
        const VooDataColumn(
          field: 'email',
          label: 'Email Address',
          width: 200,
          sortable: true,
        ),
        const VooDataColumn(
          field: 'phone',
          label: 'Phone Number',
          width: 140,
        ),
        const VooDataColumn(
          field: 'department',
          label: 'Department',
          width: 120,
          sortable: true,
          filterable: true,
        ),
        const VooDataColumn(
          field: 'location',
          label: 'Location',
          width: 140,
          sortable: true,
          filterable: true,
        ),
        const VooDataColumn(
          field: 'company',
          label: 'Company',
          width: 180,
          sortable: true,
          filterable: true,
        ),
        VooDataColumn(
          field: 'salary',
          label: 'Salary',
          width: 120,
          sortable: true,
          textAlign: TextAlign.right,
          valueFormatter: (value) => '\$${value.toStringAsFixed(0)}',
        ),
        const VooDataColumn(
          field: 'startDate',
          label: 'Start Date',
          width: 100,
          sortable: true,
        ),
        const VooDataColumn(
          field: 'status',
          label: 'Status',
          width: 90,
          sortable: true,
          filterable: true,
        ),
        const VooDataColumn(
          field: 'performanceScore',
          label: 'Performance',
          width: 110,
          sortable: true,
        ),
        const VooDataColumn(
          field: 'projectsCompleted',
          label: 'Projects',
          width: 90,
          sortable: true,
        ),
        const VooDataColumn(
          field: 'hoursWorked',
          label: 'Hours',
          width: 80,
          sortable: true,
        ),
        const VooDataColumn(
          field: 'vacationDays',
          label: 'Vacation',
          width: 90,
        ),
        const VooDataColumn(
          field: 'manager',
          label: 'Manager',
          width: 150,
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
    return VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Large Dataset (200 rows, 15 columns)'),
            actions: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Scroll both horizontally and vertically',
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
                color: Colors.blue.shade50,
                child: const Text(
                  'Frozen columns (ID & Name) stay visible while scrolling horizontally.\nTry scrolling the grid in both directions!',
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: VooDataGrid(
                    controller: _controller,
                    showPagination: true,
                    showToolbar: true,
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

@pragma('preview')
class VooDataGridAdvancedFilteringPreview extends StatefulWidget {
  const VooDataGridAdvancedFilteringPreview({super.key});

  @override
  State<VooDataGridAdvancedFilteringPreview> createState() =>
      _VooDataGridAdvancedFilteringPreviewState();
}

class _VooDataGridAdvancedFilteringPreviewState
    extends State<VooDataGridAdvancedFilteringPreview> {
  late VooDataGridController _controller;
  late AdvancedRemoteDataSource _dataSource;
  String _lastApiRequest = 'No request yet';
  String _lastApiResponse = 'No response yet';
  bool _showFilters = false;

  // Sample data for demonstration
  late List<Map<String, dynamic>> _mockData;

  @override
  void initState() {
    super.initState();

    // Generate mock orders
    _mockData =
        List.generate(100, (i) => MockDataGenerator.generateOrder(i + 1));

    // Initialize advanced data source with mock HTTP client
    _dataSource = AdvancedRemoteDataSource(
      apiEndpoint: '/api/orders',
      httpClient: _mockHttpClient,
      useAdvancedFilters: true,
    );

    _controller = VooDataGridController(
      dataSource: _dataSource,
      columns: [
        const VooDataColumn(
          field: 'orderId',
          label: 'Order ID',
          width: 120,
          sortable: true,
        ),
        const VooDataColumn(
          field: 'customerName',
          label: 'Customer',
          width: 150,
          sortable: true,
          filterable: true,
        ),
        const VooDataColumn(
          field: 'customerCompany',
          label: 'Company',
          width: 180,
          sortable: true,
          filterable: true,
        ),
        const VooDataColumn(
          field: 'product',
          label: 'Product',
          width: 150,
          sortable: true,
          filterable: true,
        ),
        VooDataColumn(
          field: 'quantity',
          label: 'Qty',
          width: 60,
          sortable: true,
          textAlign: TextAlign.right,
        ),
        VooDataColumn(
          field: 'totalAmount',
          label: 'Total',
          width: 100,
          sortable: true,
          textAlign: TextAlign.right,
          valueFormatter: (value) => '\$${value.toStringAsFixed(2)}',
        ),
        const VooDataColumn(
          field: 'orderStatus',
          label: 'Status',
          width: 90,
          sortable: true,
          filterable: true,
        ),
        const VooDataColumn(
          field: 'orderDate',
          label: 'Date',
          width: 100,
          sortable: true,
        ),
      ],
    );
  }

  Future<Map<String, dynamic>> _mockHttpClient(
    String url,
    Map<String, dynamic> body,
    Map<String, String>? headers,
  ) async {
    // Store request for display
    setState(() {
      _lastApiRequest = const JsonEncoder.withIndent('  ').convert(body);
    });

    await Future.delayed(const Duration(milliseconds: 500));

    // Apply filters to mock data
    var filteredData = List.from(_mockData);

    // Apply string filters
    if (body.containsKey('stringFilters')) {
      final filters = body['stringFilters'] as List;
      for (final filter in filters) {
        final field = _mapFieldName(filter['fieldName']);
        final value = filter['value'].toString().toLowerCase();
        final operator = filter['operator'];

        filteredData = filteredData.where((item) {
          final itemValue = item[field]?.toString().toLowerCase() ?? '';
          bool matches = _applyOperator(itemValue, value, operator);

          // Apply secondary filter if exists
          if (filter['secondaryFilter'] != null) {
            final secondary = filter['secondaryFilter'];
            final secondaryValue = secondary['value'].toString().toLowerCase();
            final secondaryOperator = secondary['operator'];
            final secondaryMatches =
                _applyOperator(itemValue, secondaryValue, secondaryOperator);

            if (secondary['logic'] == 'And') {
              matches = matches && secondaryMatches;
            } else {
              matches = matches || secondaryMatches;
            }
          }

          return matches;
        }).toList();
      }
    }

    // Apply int filters
    if (body.containsKey('intFilters')) {
      final filters = body['intFilters'] as List;
      for (final filter in filters) {
        final field = _mapFieldName(filter['fieldName']);
        final value = filter['value'] as int;
        final operator = filter['operator'];

        filteredData = filteredData.where((item) {
          final itemValue = item[field] as int? ?? 0;
          return _applyNumericOperator(itemValue, value, operator);
        }).toList();
      }
    }

    final response = {
      'data': filteredData.take(body['pageSize'] ?? 20).toList(),
      'total': filteredData.length,
      'page': body['pageNumber'] ?? 1,
      'pageSize': body['pageSize'] ?? 20,
    };

    // Store response for display
    setState(() {
      _lastApiResponse = const JsonEncoder.withIndent('  ').convert(response);
    });

    return response;
  }

  String _mapFieldName(String fieldName) {
    // Map API field names to data keys
    final parts = fieldName.split('.');
    return parts.last[0].toLowerCase() + parts.last.substring(1);
  }

  bool _applyOperator(String value, String filterValue, String operator) {
    switch (operator) {
      case 'Contains':
        return value.contains(filterValue);
      case 'NotContains':
        return !value.contains(filterValue);
      case 'StartsWith':
        return value.startsWith(filterValue);
      case 'EndsWith':
        return value.endsWith(filterValue);
      case 'Equals':
        return value == filterValue;
      case 'NotEquals':
        return value != filterValue;
      default:
        return true;
    }
  }

  bool _applyNumericOperator(num value, num filterValue, String operator) {
    switch (operator) {
      case 'GreaterThan':
        return value > filterValue;
      case 'GreaterThanOrEqual':
        return value >= filterValue;
      case 'LessThan':
        return value < filterValue;
      case 'LessThanOrEqual':
        return value <= filterValue;
      case 'Equals':
        return value == filterValue;
      case 'NotEquals':
        return value != filterValue;
      default:
        return true;
    }
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
            title: const Text('Advanced Filtering with API Output'),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _showFilters = !_showFilters;
                  });
                },
                child: Text(_showFilters ? 'Hide Filters' : 'Show Filters'),
              ),
            ],
          ),
          body: Row(
            children: [
              // Data Grid
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    if (_showFilters) ...[
                      Container(
                        height: 200,
                        padding: const EdgeInsets.all(16.0),
                        child: AdvancedFilterWidget(
                          dataSource: _dataSource,
                          fields: const [
                            FilterFieldConfig(
                              fieldName: 'customerName',
                              displayName: 'Customer Name',
                              type: FilterType.string,
                            ),
                            FilterFieldConfig(
                              fieldName: 'customerCompany',
                              displayName: 'Company',
                              type: FilterType.string,
                            ),
                            FilterFieldConfig(
                              fieldName: 'product',
                              displayName: 'Product',
                              type: FilterType.string,
                            ),
                            FilterFieldConfig(
                              fieldName: 'quantity',
                              displayName: 'Quantity',
                              type: FilterType.int,
                            ),
                            FilterFieldConfig(
                              fieldName: 'totalAmount',
                              displayName: 'Total Amount',
                              type: FilterType.decimal,
                            ),
                          ],
                          onFilterApplied: (request) {
                            // Request will be shown in the API output panel
                          },
                        ),
                      ),
                    ],
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.filter_1),
                            label: const Text('Example: Product Filter'),
                            onPressed: () {
                              _dataSource.setAdvancedFilterRequest(
                                AdvancedFilterRequest(
                                  stringFilters: [
                                    StringFilter(
                                      fieldName: 'product',
                                      value: 'Smart',
                                      operator: 'Contains',
                                      secondaryFilter: const SecondaryFilter(
                                        logic: FilterLogic.and,
                                        value: 'Hub',
                                        operator: 'NotContains',
                                      ),
                                    ),
                                  ],
                                  pageNumber: 1,
                                  pageSize: 20,
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.filter_2),
                            label: const Text('Example: Quantity Range'),
                            onPressed: () {
                              _dataSource.setAdvancedFilterRequest(
                                AdvancedFilterRequest(
                                  intFilters: [
                                    IntFilter(
                                      fieldName: 'quantity',
                                      value: 100,
                                      operator: 'GreaterThan',
                                      secondaryFilter: const SecondaryFilter(
                                        logic: FilterLogic.and,
                                        value: 500,
                                        operator: 'LessThan',
                                      ),
                                    ),
                                  ],
                                  pageNumber: 1,
                                  pageSize: 20,
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.clear),
                            label: const Text('Clear'),
                            onPressed: () {
                              _dataSource.clearAdvancedFilters();
                            },
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // API Output Panel
              Container(
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border(
                    left: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade700,
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.code, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'API Request/Response',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            const TabBar(
                              tabs: [
                                Tab(text: 'Request'),
                                Tab(text: 'Response'),
                              ],
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  // Request Tab
                                  Container(
                                    padding: const EdgeInsets.all(16.0),
                                    child: SingleChildScrollView(
                                      child: SelectableText(
                                        _lastApiRequest,
                                        style: const TextStyle(
                                          fontFamily: 'monospace',
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Response Tab
                                  Container(
                                    padding: const EdgeInsets.all(16.0),
                                    child: SingleChildScrollView(
                                      child: SelectableText(
                                        _lastApiResponse,
                                        style: const TextStyle(
                                          fontFamily: 'monospace',
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@pragma('preview')
class VooDataGridSynchronizedScrollingPreview extends StatefulWidget {
  const VooDataGridSynchronizedScrollingPreview({super.key});

  @override
  State<VooDataGridSynchronizedScrollingPreview> createState() =>
      _VooDataGridSynchronizedScrollingPreviewState();
}

class _VooDataGridSynchronizedScrollingPreviewState
    extends State<VooDataGridSynchronizedScrollingPreview> {
  late VooDataGridController _controller;
  late LocalDataGridSource _dataSource;
  double _headerScrollOffset = 0;
  double _bodyScrollOffset = 0;

  @override
  void initState() {
    super.initState();

    // Generate data with many columns to demonstrate scrolling
    final data = List.generate(50, (i) {
      final order = MockDataGenerator.generateOrder(i + 1);
      return {
        ...order,
        'extra1': 'Extra Field 1 - Row $i',
        'extra2': 'Extra Field 2 - Row $i',
        'extra3': 'Extra Field 3 - Row $i',
        'extra4': 'Extra Field 4 - Row $i',
        'extra5': 'Extra Field 5 - Row $i',
      };
    });

    _dataSource = LocalDataGridSource(data: data);

    _controller = VooDataGridController(
      dataSource: _dataSource,
      columns: [
        const VooDataColumn(
          field: 'orderId',
          label: 'Order ID',
          width: 120,
          frozen: true,
        ),
        const VooDataColumn(
          field: 'customerName',
          label: 'Customer Name',
          width: 150,
        ),
        const VooDataColumn(
          field: 'customerCompany',
          label: 'Company',
          width: 200,
        ),
        const VooDataColumn(
          field: 'customerEmail',
          label: 'Email',
          width: 200,
        ),
        const VooDataColumn(
          field: 'shippingAddress',
          label: 'Shipping',
          width: 150,
        ),
        const VooDataColumn(
          field: 'billingAddress',
          label: 'Billing',
          width: 150,
        ),
        const VooDataColumn(
          field: 'product',
          label: 'Product',
          width: 150,
        ),
        const VooDataColumn(
          field: 'quantity',
          label: 'Quantity',
          width: 80,
        ),
        const VooDataColumn(
          field: 'unitPrice',
          label: 'Unit Price',
          width: 100,
        ),
        const VooDataColumn(
          field: 'totalAmount',
          label: 'Total',
          width: 100,
        ),
        const VooDataColumn(
          field: 'orderStatus',
          label: 'Status',
          width: 90,
        ),
        const VooDataColumn(
          field: 'paymentMethod',
          label: 'Payment',
          width: 120,
        ),
        const VooDataColumn(
          field: 'trackingNumber',
          label: 'Tracking',
          width: 140,
        ),
        const VooDataColumn(
          field: 'extra1',
          label: 'Extra 1',
          width: 150,
        ),
        const VooDataColumn(
          field: 'extra2',
          label: 'Extra 2',
          width: 150,
        ),
        const VooDataColumn(
          field: 'extra3',
          label: 'Extra 3',
          width: 150,
        ),
        const VooDataColumn(
          field: 'extra4',
          label: 'Extra 4',
          width: 150,
        ),
        const VooDataColumn(
          field: 'extra5',
          label: 'Extra 5',
          width: 150,
        ),
      ],
    );

    // Listen to scroll controllers
    _controller.horizontalScrollController.addListener(_onHeaderScroll);
    _controller.bodyHorizontalScrollController.addListener(_onBodyScroll);

    _dataSource.loadData();
  }

  void _onHeaderScroll() {
    setState(() {
      _headerScrollOffset = _controller.horizontalScrollController.offset;
    });
  }

  void _onBodyScroll() {
    setState(() {
      _bodyScrollOffset = _controller.bodyHorizontalScrollController.offset;
    });
  }

  @override
  void dispose() {
    _controller.horizontalScrollController.removeListener(_onHeaderScroll);
    _controller.bodyHorizontalScrollController.removeListener(_onBodyScroll);
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
            title: const Text('Synchronized Scrolling Demo'),
          ),
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.green.shade50,
                child: Column(
                  children: [
                    const Text(
                      'Header and body scroll together horizontally!',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Chip(
                          label: Text(
                              'Header Offset: ${_headerScrollOffset.toStringAsFixed(1)}'),
                          backgroundColor: Colors.blue.shade100,
                        ),
                        const SizedBox(width: 16),
                        Chip(
                          label: Text(
                              'Body Offset: ${_bodyScrollOffset.toStringAsFixed(1)}'),
                          backgroundColor: Colors.orange.shade100,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if ((_headerScrollOffset - _bodyScrollOffset).abs() < 1)
                      const Chip(
                        label: Text('✓ Synchronized!'),
                        backgroundColor: Colors.green,
                        labelStyle: TextStyle(color: Colors.white),
                      )
                    else
                      const Chip(
                        label: Text('⚠ Out of sync!'),
                        backgroundColor: Colors.red,
                        labelStyle: TextStyle(color: Colors.white),
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

@pragma('preview')
class VooDataGridOrderManagementPreview extends StatefulWidget {
  const VooDataGridOrderManagementPreview({super.key});

  @override
  State<VooDataGridOrderManagementPreview> createState() =>
      _VooDataGridOrderManagementPreviewState();
}

class _VooDataGridOrderManagementPreviewState
    extends State<VooDataGridOrderManagementPreview> {
  late VooDataGridController _controller;
  late AdvancedRemoteDataSource _dataSource;
  late List<Map<String, dynamic>> _mockOrders;

  @override
  void initState() {
    super.initState();

    // Generate comprehensive order data
    _mockOrders =
        List.generate(250, (i) => MockDataGenerator.generateOrder(i + 1));

    _dataSource = AdvancedRemoteDataSource(
      apiEndpoint: '/api/orders',
      httpClient: _mockHttpClient,
      useAdvancedFilters: true,
    );

    _dataSource.setSelectionMode(VooSelectionMode.multiple);

    _controller = VooDataGridController(
      dataSource: _dataSource,
      columns: [
        const VooDataColumn(
          field: 'orderId',
          label: 'Order #',
          width: 100,
          frozen: true,
          sortable: true,
        ),
        const VooDataColumn(
          field: 'orderDate',
          label: 'Date',
          width: 100,
          sortable: true,
          filterable: true,
        ),
        const VooDataColumn(
          field: 'customerName',
          label: 'Customer',
          width: 150,
          sortable: true,
          filterable: true,
        ),
        const VooDataColumn(
          field: 'customerCompany',
          label: 'Company',
          width: 180,
          sortable: true,
          filterable: true,
        ),
        const VooDataColumn(
          field: 'product',
          label: 'Product',
          width: 150,
          sortable: true,
          filterable: true,
        ),
        VooDataColumn(
          field: 'quantity',
          label: 'Qty',
          width: 60,
          sortable: true,
          textAlign: TextAlign.right,
        ),
        VooDataColumn(
          field: 'unitPrice',
          label: 'Price',
          width: 90,
          sortable: true,
          textAlign: TextAlign.right,
          valueFormatter: (value) => '\$${value.toStringAsFixed(2)}',
        ),
        VooDataColumn(
          field: 'totalAmount',
          label: 'Total',
          width: 100,
          sortable: true,
          textAlign: TextAlign.right,
          valueFormatter: (value) => '\$${value.toStringAsFixed(2)}',
          cellBuilder: (context, value, row) {
            final amount = value as double;
            final color = amount > 5000
                ? Colors.green
                : (amount > 1000 ? Colors.orange : Colors.red);
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
          field: 'orderStatus',
          label: 'Status',
          width: 100,
          sortable: true,
          filterable: true,
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
              case 'Hold':
                color = Colors.red;
                icon = Icons.pause_circle;
                break;
              case 'Processing':
                color = Colors.blue;
                icon = Icons.sync;
                break;
              default:
                color = Colors.grey;
                icon = Icons.cancel;
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
        const VooDataColumn(
          field: 'paymentMethod',
          label: 'Payment',
          width: 120,
          sortable: true,
        ),
        const VooDataColumn(
          field: 'shippingAddress',
          label: 'Ship To',
          width: 150,
        ),
        const VooDataColumn(
          field: 'trackingNumber',
          label: 'Tracking',
          width: 140,
        ),
        const VooDataColumn(
          field: 'estimatedDelivery',
          label: 'Est. Delivery',
          width: 100,
        ),
      ],
      showFilters: false,
    );
  }

  Future<Map<String, dynamic>> _mockHttpClient(
    String url,
    Map<String, dynamic> body,
    Map<String, String>? headers,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));

    var data = List.from(_mockOrders);

    // Apply filters
    if (body.containsKey('filters')) {
      // Handle standard filters
    }

    // Apply sorts
    if (body.containsKey('sorts')) {
      // Handle sorting
    }

    // Pagination
    final page = body['pagination']?['page'] ?? 0;
    final pageSize = body['pagination']?['pageSize'] ?? 20;
    final start = page * pageSize;
    final end = (start + pageSize).clamp(0, data.length);

    return {
      'data': data.sublist(start, end),
      'total': data.length,
      'page': page,
      'pageSize': pageSize,
    };
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
            title: const Text('Order Management System'),
            actions: [
              AnimatedBuilder(
                animation: _dataSource,
                builder: (context, _) {
                  final selected = _dataSource.selectedRows.length;
                  if (selected > 0) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Center(
                        child: Chip(
                          label: Text('$selected orders selected'),
                          onDeleted: () => _dataSource.clearSelection(),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('New Order'),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.file_download),
                      label: const Text('Export'),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.print),
                      label: const Text('Print'),
                      onPressed: () {},
                    ),
                    const Spacer(),
                    const Text('View: '),
                    const SizedBox(width: 8),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'all', label: Text('All')),
                        ButtonSegment(value: 'active', label: Text('Active')),
                        ButtonSegment(value: 'pending', label: Text('Pending')),
                        ButtonSegment(value: 'hold', label: Text('On Hold')),
                      ],
                      selected: const {'all'},
                      onSelectionChanged: (value) {
                        // Apply quick filter
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: VooDataGrid(
                  controller: _controller,
                  showPagination: true,
                  showToolbar: true,
                  onRowTap: (row) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Order ${row['orderId']}'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Customer: ${row['customerName']}'),
                            Text('Product: ${row['product']}'),
                            Text(
                                'Total: \$${row['totalAmount'].toStringAsFixed(2)}'),
                            Text('Status: ${row['orderStatus']}'),
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
                  onRowDoubleTap: (row) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Edit order ${row['orderId']}')),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Keep the original preview classes for compatibility

@pragma('preview')
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
        const VooDataColumn(
          field: 'name',
          label: 'Product',
          flex: 2,
          sortable: true,
          filterable: true,
        ),
        const VooDataColumn(
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
          filterable: true,
          valueFormatter: (value) => '\$${value.toStringAsFixed(2)}',
        ),
        const VooDataColumn(
          field: 'stock',
          label: 'Stock',
          width: 80,
          sortable: true,
          filterable: true,
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
    return VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Filterable Data Grid'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: VooDataGrid(
              controller: _controller,
              // Search is enabled through toolbar
            ),
          ),
        ),
      ),
    );
  }
}

@pragma('preview')
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
        const VooDataColumn(
          field: 'task',
          label: 'Task',
          flex: 3,
          sortable: true,
        ),
        const VooDataColumn(
          field: 'assignee',
          label: 'Assignee',
          width: 120,
          sortable: true,
        ),
        VooDataColumn(
          field: 'priority',
          label: 'Priority',
          width: 100,
          sortable: true,
          cellBuilder: (context, value, row) {
            Color color;
            switch (value) {
              case 'High':
                color = Colors.red;
                break;
              case 'Medium':
                color = Colors.orange;
                break;
              default:
                color = Colors.green;
            }
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                value,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
        const VooDataColumn(
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
    return VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Selectable Data Grid'),
            actions: [
              if (selectedCount > 0)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text('$selectedCount selected'),
                  ),
                ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: VooDataGrid(
              controller: _controller,
              // Selection is handled through data source
            ),
          ),
        ),
      ),
    );
  }
}

@pragma('preview')
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
        const VooDataColumn(
          field: 'id',
          label: 'ID',
          width: 60,
          sortable: true,
        ),
        const VooDataColumn(
          field: 'title',
          label: 'Title',
          flex: 2,
          sortable: true,
        ),
        const VooDataColumn(
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
    return VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Paginated Data Grid'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
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
