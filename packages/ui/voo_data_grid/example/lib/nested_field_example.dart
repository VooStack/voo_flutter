import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

/// Example demonstrating nested field filtering with field prefix
///
/// This example shows how to use the fieldPrefix feature to filter
/// nested properties like "Site.SiteNumber", "Client.CompanyName", etc.
class NestedFieldExample extends StatefulWidget {
  const NestedFieldExample({super.key});

  @override
  State<NestedFieldExample> createState() => _NestedFieldExampleState();
}

class _NestedFieldExampleState extends State<NestedFieldExample> {
  late VooDataGridController controller;
  late RemoteDataSource dataSource;

  @override
  void initState() {
    super.initState();

    // Create data source with Voo API standard and field prefix
    dataSource = RemoteDataSource(
      apiEndpoint: 'https://api.example.com/orders',
      apiStandard: ApiFilterStandard.voo,
      fieldPrefix: 'Site', // This will prefix all field names with "Site."
    );

    // Create controller with field prefix
    controller = VooDataGridController(
      dataSource: dataSource,
      fieldPrefix: 'Site',
      columns: [
        VooDataColumn(
          field: 'SiteNumber',
          label: 'Site Number',
          sortable: true,
          filterable: true,
          width: 120,
        ),
        VooDataColumn(
          field: 'Name',
          label: 'Site Name',
          sortable: true,
          filterable: true,
          flex: 1,
        ),
        VooDataColumn(
          field: 'Address',
          label: 'Address',
          filterable: true,
          flex: 2,
        ),
        VooDataColumn(
          field: 'Status',
          label: 'Status',
          sortable: true,
          filterable: true,
          width: 100,
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

  void _showFilterExample() {
    // Example of how the filters will be sent to the API
    final exampleRequest = {
      "pageNumber": 1,
      "pageSize": 20,
      "logic": "And",
      "intFilters": [
        {"fieldName": "Site.SiteNumber", "value": 100, "operator": "Equals"},
      ],
      "stringFilters": [
        {"fieldName": "Site.Name", "value": "Tech", "operator": "Contains"},
      ],
      "sortBy": "Site.Name",
      "sortDescending": false,
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Example API Request'),
        content: SingleChildScrollView(
          child: Text(
            'When you filter by SiteNumber=100 and Name contains "Tech",\n'
            'this is what gets sent to the API:\n\n'
            '${_prettyPrintJson(exampleRequest)}',
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
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

  void _changeFieldPrefix(String? newPrefix) {
    setState(() {
      // Update the field prefix
      controller.setFieldPrefix(newPrefix);

      // Create new data source with updated prefix
      dataSource = RemoteDataSource(
        apiEndpoint: 'https://api.example.com/orders',
        apiStandard: ApiFilterStandard.voo,
        fieldPrefix: newPrefix,
      );

      // Update controller's data source
      controller = VooDataGridController(
        dataSource: dataSource,
        fieldPrefix: newPrefix,
        columns: controller.columns,
      );

      // Reload data
      dataSource.loadData();
    });
  }

  String _prettyPrintJson(Map<String, dynamic> json) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nested Field Filtering Example'),
        actions: [
          PopupMenuButton<String?>(
            onSelected: _changeFieldPrefix,
            itemBuilder: (context) => [
              const PopupMenuItem(value: null, child: Text('No Prefix')),
              const PopupMenuItem(value: 'Site', child: Text('Site Prefix')),
              const PopupMenuItem(
                value: 'Client',
                child: Text('Client Prefix'),
              ),
              const PopupMenuItem(value: 'Order', child: Text('Order Prefix')),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Text('Prefix: '),
                  Text(
                    controller.fieldPrefix ?? 'None',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
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
                  'Nested Field Filtering Demo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Current field prefix: ${controller.fieldPrefix ?? "None"}',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                const Text(
                  'When filtering, field names will be prefixed automatically.\n'
                  'For example: "SiteNumber" becomes "Site.SiteNumber" in the API request.',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _showFilterExample,
                  child: const Text('Show Example API Request'),
                ),
              ],
            ),
          ),
          Expanded(child: VooDataGrid(controller: controller)),
        ],
      ),
    );
  }
}

/// Example remote data source that simulates API calls
class RemoteDataSource extends VooDataGridSource {
  final String apiEndpoint;
  final ApiFilterStandard apiStandard;
  final String? fieldPrefix;

  RemoteDataSource({
    required this.apiEndpoint,
    this.apiStandard = ApiFilterStandard.voo,
    this.fieldPrefix,
  }) : super(mode: VooDataGridMode.remote);

  @override
  Future<VooDataGridResponse> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    // Build request with field prefix
    final requestBuilder = DataGridRequestBuilder(
      standard: apiStandard,
      fieldPrefix: fieldPrefix,
    );

    final request = requestBuilder.buildRequest(
      page: page,
      pageSize: pageSize,
      filters: filters,
      sorts: sorts,
    );

    // Log the request to demonstrate the field prefix in action
    print('API Request with field prefix "$fieldPrefix":');
    print(const JsonEncoder.withIndent('  ').convert(request));

    // Simulate API response with dummy data
    await Future.delayed(const Duration(milliseconds: 500));

    // Generate dummy data
    final rows = List.generate(
      20,
      (index) => {
        'SiteNumber': 100 + index,
        'Name': 'Site ${100 + index}',
        'Address': '${100 + index} Main Street',
        'Status': index % 3 == 0 ? 'Active' : 'Inactive',
      },
    );

    return VooDataGridResponse(
      rows: rows,
      totalRows: 100,
      page: page,
      pageSize: pageSize,
    );
  }
}
