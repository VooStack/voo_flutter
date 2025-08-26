import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';
import 'dart:convert';

/// Example data source that demonstrates different API standards
class ApiStandardDataSource extends VooDataGridSource {
  final ApiFilterStandard apiStandard;
  final void Function(Map<String, dynamic>)? onRequestBuilt;
  
  ApiStandardDataSource({
    required this.apiStandard,
    this.onRequestBuilt,
  }) : super(mode: VooDataGridMode.local) {
    // Initialize with sample data
    _loadInitialData();
  }

  void _loadInitialData() {
    final data = List.generate(50, (i) => {
      'id': i + 1,
      'name': 'Product ${i + 1}',
      'category': ['Electronics', 'Books', 'Clothing', 'Food'][i % 4],
      'price': ((i + 1) * 15.99),
      'stock': (i + 1) * 5,
      'rating': (i % 5) + 1,
      'dateAdded': DateTime.now().subtract(Duration(days: i)).toIso8601String(),
    });
    setLocalData(data);
    loadData();
  }

  @override
  Future<VooDataGridResponse> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    // Build request using the selected API standard
    final requestBuilder = StandardApiRequestBuilder(
      standard: apiStandard,
    );

    // Build the request with all parameters
    final request = requestBuilder.buildRequest(
      page: page,
      pageSize: pageSize,
      filters: filters,
      sorts: sorts,
      additionalParams: {'endpoint': '/api/products'},
    );
    
    // Notify listener about the built request
    onRequestBuilt?.call(request);

    // Simulate API response (in real app, you would make HTTP request here)
    return VooDataGridResponse(
      rows: rows,
      totalRows: totalRows,
      page: page,
      pageSize: pageSize,
    );
  }
}

@pragma('preview')
class VooDataGridApiStandardsPreview extends StatefulWidget {
  const VooDataGridApiStandardsPreview({super.key});

  @override
  State<VooDataGridApiStandardsPreview> createState() => _VooDataGridApiStandardsPreviewState();
}

class _VooDataGridApiStandardsPreviewState extends State<VooDataGridApiStandardsPreview> {
  late VooDataGridController _controller;
  late ApiStandardDataSource _dataSource;
  ApiFilterStandard _selectedStandard = ApiFilterStandard.simple;
  Map<String, dynamic> _lastRequest = {};
  final ScrollController _requestScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeDataSource();
  }

  void _initializeDataSource() {
    _dataSource = ApiStandardDataSource(
      apiStandard: _selectedStandard,
      onRequestBuilt: (request) {
        setState(() {
          _lastRequest = request;
        });
      },
    );

    _controller = VooDataGridController(
      dataSource: _dataSource,
      columns: [
        const VooDataColumn(
          field: 'id',
          label: 'ID',
          width: 80,
          sortable: true,
        ),
        const VooDataColumn(
          field: 'name',
          label: 'Product Name',
          width: 200,
          sortable: true,
          filterable: true,
        ),
        const VooDataColumn(
          field: 'category',
          label: 'Category',
          width: 150,
          sortable: true,
          filterable: true,
        ),
        VooDataColumn(
          field: 'price',
          label: 'Price',
          width: 120,
          sortable: true,
          filterable: true,
          textAlign: TextAlign.right,
          valueFormatter: (value) => '\$${value?.toStringAsFixed(2) ?? '0.00'}',
        ),
        const VooDataColumn(
          field: 'stock',
          label: 'Stock',
          width: 100,
          sortable: true,
          filterable: true,
          textAlign: TextAlign.right,
        ),
        const VooDataColumn(
          field: 'rating',
          label: 'Rating',
          width: 100,
          sortable: true,
          filterable: true,
        ),
        const VooDataColumn(
          field: 'dateAdded',
          label: 'Date Added',
          width: 150,
          sortable: true,
        ),
      ],
    );
  }

  void _changeApiStandard(ApiFilterStandard? standard) {
    if (standard == null) return;
    
    setState(() {
      _selectedStandard = standard;
    });

    // Dispose old controller and data source
    _controller.dispose();
    _dataSource.dispose();

    // Create new ones with the selected standard
    _initializeDataSource();

    // Trigger a sample request to show the format
    _triggerSampleRequest();
  }

  void _triggerSampleRequest() {
    // Apply some filters and sorts to generate a request
    _dataSource.applyFilter('category', VooDataFilter(
      value: 'Electronics',
      operator: VooFilterOperator.equals,
    ));
    _dataSource.applyFilter('price', VooDataFilter(
      value: 50,
      operator: VooFilterOperator.greaterThan,
    ));
    _dataSource.applySort('name', VooSortDirection.ascending);
    _dataSource.applySort('price', VooSortDirection.descending);
    _dataSource.loadData();
  }

  String _getApiStandardDescription(ApiFilterStandard standard) {
    switch (standard) {
      case ApiFilterStandard.simple:
        return 'Simple REST-style parameters (default)';
      case ApiFilterStandard.jsonApi:
        return 'JSON:API specification format';
      case ApiFilterStandard.odata:
        return 'OData query format (\$filter, \$orderby)';
      case ApiFilterStandard.mongodb:
        return 'MongoDB/Elasticsearch query format';
      case ApiFilterStandard.graphql:
        return 'GraphQL variables format';
      case ApiFilterStandard.custom:
        return 'Custom format (define your own)';
    }
  }

  Widget _buildApiStandardSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'API Standard Configuration',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Select how filters and sorts are formatted in API requests:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ApiFilterStandard.values.map((standard) {
                return ChoiceChip(
                  label: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        standard.name.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _getApiStandardDescription(standard),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  selected: _selectedStandard == standard,
                  onSelected: (selected) {
                    if (selected) {
                      _changeApiStandard(standard);
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _triggerSampleRequest,
              icon: const Icon(Icons.refresh),
              label: const Text('Generate Sample Request'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestViewer() {
    final encoder = const JsonEncoder.withIndent('  ');
    final formattedJson = encoder.convert(_lastRequest);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.code, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Generated API Request (${_selectedStandard.name.toUpperCase()})',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  onPressed: () {
                    // In a real app, copy to clipboard
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Request copied to clipboard')),
                    );
                  },
                  tooltip: 'Copy request',
                ),
              ],
            ),
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: Scrollbar(
              controller: _requestScrollController,
              child: SingleChildScrollView(
                controller: _requestScrollController,
                padding: const EdgeInsets.all(16.0),
                child: SelectableText(
                  formattedJson,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageExample() {
    final examples = {
      ApiFilterStandard.simple: '''
// Simple REST Style
final dataSource = RemoteDataSource(
  fetchData: (request) async {
    final response = await http.get(
      Uri.parse('https://api.example.com/products')
        .replace(queryParameters: request['params']),
    );
    return json.decode(response.body);
  },
);''',
      ApiFilterStandard.jsonApi: '''
// JSON:API Format
final dataSource = RemoteDataSource(
  apiStandard: ApiFilterStandard.jsonApi,
  fetchData: (request) async {
    final response = await http.get(
      Uri.parse(request['url'])
        .replace(queryParameters: request['params']),
    );
    return json.decode(response.body);
  },
);''',
      ApiFilterStandard.odata: '''
// OData Format
final dataSource = RemoteDataSource(
  apiStandard: ApiFilterStandard.odata,
  fetchData: (request) async {
    final response = await http.get(
      Uri.parse('https://api.example.com/odata/products')
        .replace(queryParameters: request['params']),
    );
    return json.decode(response.body);
  },
);''',
      ApiFilterStandard.mongodb: '''
// MongoDB/Elasticsearch Format
final dataSource = RemoteDataSource(
  apiStandard: ApiFilterStandard.mongodb,
  fetchData: (request) async {
    final response = await http.post(
      Uri.parse('https://api.example.com/products/search'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request['body']),
    );
    return json.decode(response.body);
  },
);''',
      ApiFilterStandard.graphql: '''
// GraphQL Format
final dataSource = RemoteDataSource(
  apiStandard: ApiFilterStandard.graphql,
  fetchData: (request) async {
    final response = await http.post(
      Uri.parse('https://api.example.com/graphql'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'query': request['query'],
        'variables': request['variables'],
      }),
    );
    return json.decode(response.body);
  },
);''',
      ApiFilterStandard.custom: '''
// Custom Format
final dataSource = RemoteDataSource(
  apiStandard: ApiFilterStandard.custom,
  customRequestBuilder: (filters, sorts, page, pageSize) {
    // Build your custom request format here
    return {
      'customFilters': filters.map((k, v) => MapEntry(k, v.value)),
      'customSorts': sorts.map((s) => s.field).toList(),
      'pagination': {'page': page, 'size': pageSize},
    };
  },
);''',
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.integration_instructions, color: Theme.of(context).colorScheme.secondary),
                const SizedBox(width: 8),
                Text(
                  'Usage Example',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                examples[_selectedStandard] ?? '',
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

  @override
  void dispose() {
    _controller.dispose();
    _dataSource.dispose();
    _requestScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('API Standards Configuration'),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          body: Row(
            children: [
              // Left side - Configuration and examples
              SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildApiStandardSelector(),
                      const SizedBox(height: 16),
                      _buildRequestViewer(),
                      const SizedBox(height: 16),
                      _buildUsageExample(),
                    ],
                  ),
                ),
              ),
              // Right side - Data grid
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        color: Theme.of(context).colorScheme.surface,
                        child: Row(
                          children: [
                            const Text(
                              'Data Grid with Selected API Standard',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Text(
                              'Standard: ${_selectedStandard.name.toUpperCase()}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
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
                          ),
                        ),
                      ),
                    ],
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
    home: VooDataGridApiStandardsPreview(),
  ));
}