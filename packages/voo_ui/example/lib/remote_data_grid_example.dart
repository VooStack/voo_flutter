import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:voo_ui/voo_ui.dart';

/// Example showing how to use DataGridRequestBuilder with different API standards
class RemoteDataGridExample extends StatefulWidget {
  const RemoteDataGridExample({super.key});

  @override
  State<RemoteDataGridExample> createState() => _RemoteDataGridExampleState();
}

class _RemoteDataGridExampleState extends State<RemoteDataGridExample> {
  late final VooDataGridController _controller;
  ApiFilterStandard _selectedStandard = ApiFilterStandard.jsonApi;
  
  // Sample filters and sorts for demonstration
  final _sampleFilters = {
    'status': VooDataFilter(
      operator: VooFilterOperator.equals,
      value: 'active',
    ),
    'age': VooDataFilter(
      operator: VooFilterOperator.greaterThan,
      value: 25,
    ),
    'department': VooDataFilter(
      operator: VooFilterOperator.inList,
      value: ['engineering', 'design'],
    ),
    'salary': VooDataFilter(
      operator: VooFilterOperator.between,
      value: 50000,
      valueTo: 100000,
    ),
  };
  
  final _sampleSorts = [
    VooColumnSort(field: 'name', direction: VooSortDirection.ascending),
    VooColumnSort(field: 'createdAt', direction: VooSortDirection.descending),
  ];

  @override
  void initState() {
    super.initState();
    
    // Initialize controller with mock data source
    final dataSource = MockDataSource();
    _controller = VooDataGridController(
      columns: _buildColumns(),
      dataSource: dataSource,
    );
    
    // Load sample data
    dataSource.setLocalData(_generateMockData());
  }

  List<VooDataColumn> _buildColumns() {
    return [
      VooDataColumn(
        field: 'id',
        label: 'ID',
        width: 80,
        frozen: true,
        dataType: VooDataColumnType.number,
      ),
      VooDataColumn(
        field: 'name',
        label: 'Name',
        width: 200,
        filterable: true,
        sortable: true,
        dataType: VooDataColumnType.text,
      ),
      VooDataColumn(
        field: 'email',
        label: 'Email',
        width: 250,
        filterable: true,
        sortable: true,
        dataType: VooDataColumnType.text,
      ),
      VooDataColumn(
        field: 'department',
        label: 'Department',
        width: 150,
        filterable: true,
        filterWidgetType: VooFilterWidgetType.dropdown,
        filterOptions: const [
          VooFilterOption(value: 'engineering', label: 'Engineering'),
          VooFilterOption(value: 'design', label: 'Design'),
          VooFilterOption(value: 'marketing', label: 'Marketing'),
          VooFilterOption(value: 'sales', label: 'Sales'),
        ],
        dataType: VooDataColumnType.text,
      ),
      VooDataColumn(
        field: 'age',
        label: 'Age',
        width: 100,
        filterable: true,
        sortable: true,
        filterWidgetType: VooFilterWidgetType.numberField,
        dataType: VooDataColumnType.number,
      ),
      VooDataColumn(
        field: 'salary',
        label: 'Salary',
        width: 150,
        filterable: true,
        sortable: true,
        filterWidgetType: VooFilterWidgetType.numberRange,
        dataType: VooDataColumnType.number,
        valueFormatter: (value) => '\$${value.toString()}',
      ),
      VooDataColumn(
        field: 'status',
        label: 'Status',
        width: 120,
        filterable: true,
        filterWidgetType: VooFilterWidgetType.dropdown,
        filterOptions: const [
          VooFilterOption(value: 'active', label: 'Active'),
          VooFilterOption(value: 'inactive', label: 'Inactive'),
          VooFilterOption(value: 'pending', label: 'Pending'),
        ],
        dataType: VooDataColumnType.text,
        cellBuilder: (context, row, column) {
          final status = row['status'] as String? ?? 'unknown';
          final color = status == 'active' 
              ? Colors.green 
              : status == 'inactive' 
                  ? Colors.red 
                  : Colors.orange;
          return Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color),
              ),
              child: Text(
                status.toUpperCase(),
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    ];
  }

  List<Map<String, dynamic>> _generateMockData() {
    return List.generate(100, (index) => {
      'id': index + 1,
      'name': 'User ${index + 1}',
      'email': 'user${index + 1}@example.com',
      'department': ['engineering', 'design', 'marketing', 'sales'][index % 4],
      'age': 25 + (index % 40),
      'salary': 50000 + (index * 1000),
      'status': ['active', 'inactive', 'pending'][index % 3],
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildRequestExample() {
    final builder = StandardApiRequestBuilder(standard: _selectedStandard);
    final request = builder.buildRequest(
      page: 0,
      pageSize: 20,
      filters: _sampleFilters,
      sorts: _sampleSorts,
    );
    
    String formattedRequest = '';
    String requestType = '';
    
    switch (_selectedStandard) {
      case ApiFilterStandard.simple:
        requestType = 'GET Request with Query Parameters:';
        final params = request as Map<String, String>;
        formattedRequest = 'GET /api/users?' + params.entries
            .map((e) => '${e.key}=${e.value}')
            .join('&');
        break;
        
      case ApiFilterStandard.jsonApi:
        requestType = 'GET Request (JSON:API Standard):';
        final params = request as Map<String, String>;
        formattedRequest = 'GET /api/users?' + params.entries
            .map((e) => '${e.key}=${e.value}')
            .join('&');
        break;
        
      case ApiFilterStandard.odata:
        requestType = 'GET Request (OData Standard):';
        formattedRequest = 'GET /api/users?' + (request as String);
        break;
        
      case ApiFilterStandard.mongodb:
        requestType = 'POST Request Body (MongoDB/Elasticsearch Style):';
        formattedRequest = _prettyPrintJson(request as Map<String, dynamic>);
        break;
        
      case ApiFilterStandard.custom:
        requestType = 'POST Request Body (Custom Format):';
        formattedRequest = _prettyPrintJson(request as Map<String, dynamic>);
        break;
    }
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            requestType,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(4),
            ),
            child: SelectableText(
              formattedRequest,
              style: const TextStyle(
                fontFamily: 'monospace',
                color: Colors.greenAccent,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  String _prettyPrintJson(Map<String, dynamic> json) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Data Grid - API Standards'),
      ),
      body: Column(
        children: [
          // API Standard Selector
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select API Standard:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: ApiFilterStandard.values.map((standard) {
                    return ChoiceChip(
                      label: Text(_getStandardLabel(standard)),
                      selected: _selectedStandard == standard,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedStandard = standard;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          
          // Request Example
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildRequestExample(),
                  
                  // Data Grid
                  Container(
                    height: 400,
                    margin: const EdgeInsets.all(16),
                    child: VooDataGrid(
                      controller: _controller,
                      showPagination: true,
                    ),
                  ),
                  
                  // Implementation Example
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue.shade200),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue.shade50,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Implementation Example:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: SelectableText(
                            _getImplementationExample(),
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
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
    );
  }
  
  String _getStandardLabel(ApiFilterStandard standard) {
    switch (standard) {
      case ApiFilterStandard.simple:
        return 'Simple REST';
      case ApiFilterStandard.jsonApi:
        return 'JSON:API';
      case ApiFilterStandard.odata:
        return 'OData';
      case ApiFilterStandard.mongodb:
        return 'MongoDB/ES';
      case ApiFilterStandard.custom:
        return 'Custom';
    }
  }
  
  String _getImplementationExample() {
    return '''
// 1. Create your data source with selected API standard
class MyDataSource extends VooDataGridSource {
  MyDataSource() : super(mode: VooDataGridMode.remote);
  
  @override
  Future<VooDataGridResponse> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    // Use the StandardApiRequestBuilder with your preferred standard
    final builder = StandardApiRequestBuilder(
      standard: ApiFilterStandard.$_selectedStandard,
    );
    
    final request = builder.buildRequest(
      page: page,
      pageSize: pageSize,
      filters: filters,
      sorts: sorts,
    );
    
    // Make your API call based on the standard
    ${_getApiCallExample()}
  }
}''';
  }
  
  String _getApiCallExample() {
    switch (_selectedStandard) {
      case ApiFilterStandard.simple:
      case ApiFilterStandard.jsonApi:
      case ApiFilterStandard.odata:
        return '''final response = await http.get(
      Uri.parse('https://api.example.com/users')
          .replace(queryParameters: request),
    );''';
      case ApiFilterStandard.mongodb:
      case ApiFilterStandard.custom:
        return '''final response = await dio.post(
      'https://api.example.com/users/search',
      data: request,
    );''';
    }
  }
}

/// Mock data source for demonstration
class MockDataSource extends VooDataGridSource {
  MockDataSource() : super(mode: VooDataGridMode.local);
}