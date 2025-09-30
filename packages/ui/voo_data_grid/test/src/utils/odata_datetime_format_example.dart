// Example demonstrating how to configure DateTime format for OData filters
// This is a reference example, not a test file

import 'package:voo_data_grid/src/utils/data_grid_request_builder.dart';

void main() {
  // Example 1: Default UTC format (recommended for PostgreSQL with timestamptz)
  const utcBuilder = DataGridRequestBuilder(
    standard: ApiFilterStandard.odata,
    // odataDateTimeFormat defaults to ODataDateTimeFormat.utc
  );

  // Generates: $filter=createdAt ge 2024-09-30T15:15:30.000Z
  // Best for:
  // - PostgreSQL with 'timestamp with time zone' columns
  // - Most modern OData implementations
  // - When your backend properly handles UTC strings

  // Example 2: Unspecified format (for .NET backends with DateTime issues)
  const unspecifiedBuilder = DataGridRequestBuilder(
    standard: ApiFilterStandard.odata,
    odataDateTimeFormat: ODataDateTimeFormat.unspecified,
  );

  // Generates: $filter=createdAt ge 2024-09-30T15:15:30.000
  // Use when:
  // - Getting "DateTime with Kind=Unspecified" errors
  // - Your .NET OData backend doesn't properly parse 'Z' suffix
  // - Using SQL Server 'datetime' columns (not datetime2 or datetimeoffset)
  // - Backend expects DateTime without timezone information

  // Example 3: Full configuration for a real-world scenario
  const myBuilder = DataGridRequestBuilder(
    standard: ApiFilterStandard.odata,
    fieldPrefix: 'data', // Optional: prefix all fields
    odataDateTimeFormat: ODataDateTimeFormat.unspecified, // For .NET backend
  );

  // Usage in VooDataGrid:
  //
  // VooDataGrid(
  //   dataSource: VooRemoteDataSource(
  //     fetchData: (params) async {
  //       // Build OData request
  //       final request = myBuilder.buildRequest(
  //         page: params.page,
  //         pageSize: params.pageSize,
  //         filters: params.filters,
  //         sorts: params.sorts,
  //       );
  //
  //       // Make API call
  //       final response = await http.get(
  //         Uri.parse('https://api.example.com/users').replace(
  //           queryParameters: request['params'],
  //         ),
  //       );
  //
  //       // Return data
  //       return VooDataResult(/* ... */);
  //     },
  //   ),
  //   columns: [
  //     VooDataColumn(
  //       field: 'createdDate',
  //       label: 'Created Date',
  //       dataType: VooDataColumnType.date,
  //       filterable: true,
  //     ),
  //   ],
  // )

  print('OData DateTime Format Configuration Examples');
  print('UTC Format: ${utcBuilder.odataDateTimeFormat}');
  print('Unspecified Format: ${unspecifiedBuilder.odataDateTimeFormat}');
  print('Custom Builder: ${myBuilder.odataDateTimeFormat}');
}