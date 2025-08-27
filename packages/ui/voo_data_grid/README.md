# VooDataGrid

A powerful and flexible data grid widget for Flutter with advanced features like sorting, filtering, pagination, and remote data support.

[![pub package](https://img.shields.io/pub/v/voo_data_grid.svg)](https://pub.dev/packages/voo_data_grid)
[![style: flutter_lints](https://img.shields.io/badge/style-flutter__lints-4BC0F5.svg)](https://pub.dev/packages/flutter_lints)

## Features

- **Type-Safe Generic Support**: Full compile-time type safety with generic type parameters
- **Flexible Data Display**: Display tabular data with customizable columns and rows
- **Sorting**: Built-in column sorting with custom comparators
- **Advanced Filtering**: 
  - Multiple filter types (string, int, date, decimal)
  - Secondary filters with AND/OR logic
  - Complex compound filters
  - Legacy filter format support
  - Built-in filter UI widget
  - Filters remain visible during error states
- **Pagination**: Server-side and client-side pagination support
- **Selection**: Row selection with single and multi-select modes
- **Remote Data**: Built-in support for fetching data from REST APIs
- **Synchronized Scrolling**: Uniform horizontal scrolling between header and body
- **Performance**: Optimized for large datasets with efficient rendering
- **API Standards**: Support for 7 API standards (Voo, Simple REST, JSON:API, OData, MongoDB, GraphQL, Custom)
- **Field Prefix Support**: Automatic field name prefixing for nested properties
- **Action Columns**: Support for clickable cells and action buttons
- **Enhanced Error Handling**: Comprehensive error handling with graceful fallbacks
- **Customization**: Highly customizable headers, cells, and styling
- **Responsive**: Adapts to different screen sizes
- **Empty State**: Headers and filters remain visible with empty data for better UX

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  voo_data_grid: ^0.5.4
  voo_ui_core: ^0.1.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

class DataGridExample extends StatefulWidget {
  @override
  State<DataGridExample> createState() => _DataGridExampleState();
}

class _DataGridExampleState extends State<DataGridExample> {
  late VooDataGridController controller;
  
  @override
  void initState() {
    super.initState();
    controller = VooDataGridController(
      dataSource: VooLocalDataSource(data: _generateData()),
      columns: _buildColumns(),
    );
  }
  
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  
  List<VooDataGridColumn> _buildColumns() {
    return [
      VooDataGridColumn(
        key: 'id',
        label: 'ID',
        width: 80,
        getValue: (item) => item['id'].toString(),
      ),
      VooDataGridColumn(
        key: 'name',
        label: 'Name',
        getValue: (item) => item['name'],
        sortable: true,
      ),
      VooDataGridColumn(
        key: 'email',
        label: 'Email',
        getValue: (item) => item['email'],
        sortable: true,
        filterable: true,
      ),
      VooDataGridColumn(
        key: 'status',
        label: 'Status',
        getValue: (item) => item['status'],
        cellBuilder: (context, item, column) {
          final status = column.getValue(item);
          final color = status == 'Active' ? Colors.green : Colors.orange;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(status),
          );
        },
      ),
    ];
  }
  
  List<Map<String, dynamic>> _generateData() {
    return List.generate(100, (index) => {
      'id': index + 1,
      'name': 'User ${index + 1}',
      'email': 'user${index + 1}@example.com',
      'status': index % 3 == 0 ? 'Inactive' : 'Active',
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: Scaffold(
        appBar: AppBar(title: const Text('Data Grid Example')),
        body: VooDataGrid(
          controller: controller,
          onRowTap: (item) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Tapped: ${item['name']}')),
            );
          },
        ),
      ),
    );
  }
}
```

### Using Typed Objects (Generic Support)

VooDataGrid fully supports typed objects with compile-time type safety:

```dart
// Define your data model
class OrderModel {
  final int id;
  final String orderNumber;
  final String customerName;
  final double amount;
  final FileStatus? status;
  
  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.customerName,
    required this.amount,
    this.status,
  });
}

class FileStatus {
  final String code;
  final String name;
  final Color color;
  
  FileStatus({required this.code, required this.name, required this.color});
}

// Create strongly typed controller
class TypedDataExample extends StatefulWidget {
  @override
  State<TypedDataExample> createState() => _TypedDataExampleState();
}

class _TypedDataExampleState extends State<TypedDataExample> {
  late VooDataGridController<OrderModel> controller;
  
  @override
  void initState() {
    super.initState();
    
    // Create typed data source
    final dataSource = TypedDataSource();
    dataSource.setLocalData([
      OrderModel(
        id: 1,
        orderNumber: 'ORD-001',
        customerName: 'John Doe',
        amount: 1500.00,
        status: FileStatus(code: 'ACTIVE', name: 'Active', color: Colors.green),
      ),
      // ... more data
    ]);
    
    controller = VooDataGridController<OrderModel>(
      dataSource: dataSource,
    );
    
    // Define columns with type-safe valueGetter
    controller.setColumns([
      VooDataColumn<OrderModel>(
        field: 'orderNumber',
        label: 'Order #',
        // No casting needed - row is already typed as OrderModel
        valueGetter: (row) => row.orderNumber,
      ),
      VooDataColumn<OrderModel>(
        field: 'customerName',
        label: 'Customer',
        valueGetter: (row) => row.customerName,
      ),
      VooDataColumn<OrderModel>(
        field: 'amount',
        label: 'Amount',
        valueGetter: (row) => row.amount,
        valueFormatter: (value) => '\$${value.toStringAsFixed(2)}',
      ),
      VooDataColumn<OrderModel>(
        field: 'status',
        label: 'Status',
        // Handle nullable nested properties safely
        valueGetter: (row) => row.status?.name,
        cellBuilder: (context, value, row) {
          final status = row.status;
          if (status == null) return const Text('N/A');
          
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: status.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status.name,
              style: TextStyle(color: status.color),
            ),
          );
        },
      ),
    ]);
  }
  
  @override
  Widget build(BuildContext context) {
    return VooDataGrid<OrderModel>(
      controller: controller,
      onRowTap: (OrderModel order) {
        // Type-safe row access
        print('Order ${order.orderNumber} tapped');
      },
    );
  }
}

// Custom data source for typed objects
class TypedDataSource extends VooDataGridSource<OrderModel> {
  TypedDataSource() : super(mode: VooDataGridMode.local);
  
  @override
  Future<VooDataGridResponse<OrderModel>> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    // Implement remote fetching if needed
    return VooDataGridResponse<OrderModel>(
      rows: [],
      totalRows: 0,
      page: page,
      pageSize: pageSize,
    );
  }
}
```

**Important Notes for Typed Objects:**
- You MUST provide a `valueGetter` function for each column when using typed objects
- The grid cannot use reflection to access properties dynamically
- All callbacks (onRowTap, cellBuilder, etc.) receive properly typed data
- Map objects work without valueGetter (backward compatibility)

### Remote Data Example

```dart
class RemoteDataExample extends StatefulWidget {
  @override
  State<RemoteDataExample> createState() => _RemoteDataExampleState();
}

class _RemoteDataExampleState extends State<RemoteDataExample> {
  late VooDataGridController controller;
  
  @override
  void initState() {
    super.initState();
    controller = VooDataGridController(
      dataSource: RemoteDataGridSource(
        apiEndpoint: 'https://api.example.com/users',
        apiStandard: ApiFilterStandard.jsonApi,
        headers: {
          'Authorization': 'Bearer YOUR_TOKEN',
        },
        httpClient: (url, requestData, headers) async {
          // Use your preferred HTTP client (dio, http, etc.)
          final response = await dio.get(url, 
            queryParameters: requestData['params'],
            options: Options(headers: headers),
          );
          return response.data;
        },
      ),
      columns: _buildColumns(),
    );
  }
  
  // ... rest of the implementation
}
```

### With Pagination

```dart
VooDataGrid(
  controller: VooDataGridController(
    dataSource: dataSource,
    columns: columns,
    paginationConfig: VooPaginationConfig(
      enabled: true,
      pageSize: 20,
      pageSizeOptions: [10, 20, 50, 100],
    ),
  ),
)
```

### With Filtering

```dart
List<VooDataGridColumn> _buildColumns() {
  return [
    VooDataGridColumn(
      key: 'name',
      label: 'Name',
      getValue: (item) => item['name'],
      filterable: true,
      filterType: FilterType.text,
    ),
    VooDataGridColumn(
      key: 'age',
      label: 'Age',
      getValue: (item) => item['age'].toString(),
      filterable: true,
      filterType: FilterType.number,
    ),
    VooDataGridColumn(
      key: 'created_at',
      label: 'Created',
      getValue: (item) => item['created_at'],
      filterable: true,
      filterType: FilterType.date,
    ),
    VooDataGridColumn(
      key: 'status',
      label: 'Status',
      getValue: (item) => item['status'],
      filterable: true,
      filterType: FilterType.select,
      filterOptions: ['Active', 'Inactive', 'Pending'],
    ),
  ];
}
```

### With Row Selection

```dart
VooDataGrid(
  controller: VooDataGridController(
    dataSource: dataSource,
    columns: columns,
    selectionMode: SelectionMode.multiple,
  ),
  onSelectionChanged: (selectedItems) {
    print('Selected ${selectedItems.length} items');
  },
)
```

### Custom Cell Rendering

```dart
VooDataGridColumn(
  key: 'avatar',
  label: 'Avatar',
  getValue: (item) => item['avatar_url'],
  cellBuilder: (context, item, column) {
    final url = column.getValue(item);
    return CircleAvatar(
      backgroundImage: NetworkImage(url),
      radius: 16,
    );
  },
)
```

### Custom Header

```dart
VooDataGridColumn(
  key: 'actions',
  label: 'Actions',
  headerBuilder: (context, column) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.settings, size: 16),
        const SizedBox(width: 4),
        Text(column.label),
      ],
    );
  },
  cellBuilder: (context, item, column) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, size: 16),
          onPressed: () => _editItem(item),
        ),
        IconButton(
          icon: const Icon(Icons.delete, size: 16),
          onPressed: () => _deleteItem(item),
        ),
      ],
    );
  },
)
```

## Advanced Filtering

### Complex Filter with Secondary Conditions

```dart
// Using AdvancedRemoteDataSource for complex filtering
final dataSource = AdvancedRemoteDataSource(
  apiEndpoint: '/api/orders',
  httpClient: httpClient,
  useAdvancedFilters: true,
);

// Apply complex filter programmatically
final filterRequest = AdvancedFilterRequest(
  stringFilters: [
    StringFilter(
      fieldName: 'Site.Name',
      value: 'Tech',
      operator: 'Contains',
      secondaryFilter: SecondaryFilter(
        logic: FilterLogic.and,
        value: 'Park',
        operator: 'NotContains',
      ),
    ),
  ],
  intFilters: [
    IntFilter(
      fieldName: 'Site.SiteNumber',
      value: 1006,
      operator: 'GreaterThan',
      secondaryFilter: SecondaryFilter(
        logic: FilterLogic.and,
        value: 1011,
        operator: 'LessThan',
      ),
    ),
  ],
  logic: FilterLogic.and,
  pageNumber: 1,
  pageSize: 20,
);

dataSource.setAdvancedFilterRequest(filterRequest);
```

### Using Advanced Filter Widget

```dart
AdvancedFilterWidget(
  dataSource: dataSource,
  fields: [
    FilterFieldConfig(
      fieldName: 'Site.SiteNumber',
      displayName: 'Site Number',
      type: FilterType.int,
    ),
    FilterFieldConfig(
      fieldName: 'Client.CompanyName',
      displayName: 'Client',
      type: FilterType.string,
    ),
    FilterFieldConfig(
      fieldName: 'OrderDate',
      displayName: 'Order Date',
      type: FilterType.date,
    ),
    FilterFieldConfig(
      fieldName: 'OrderCost',
      displayName: 'Cost',
      type: FilterType.decimal,
    ),
  ],
  onFilterApplied: (request) {
    print('Applied filters: ${request.toJson()}');
  },
)
```

## API Standards Support

VooDataGrid includes integrated support for 7 different API standards through the `DataGridRequestBuilder` class. Each data source can have its own HTTP client with custom interceptors and authentication.

### Voo API Standard

The Voo API Standard is designed for enterprise applications with typed filters:

```dart
final dataSource = RemoteDataGridSource(
  apiEndpoint: '/api/data',
  apiStandard: ApiFilterStandard.voo,
  fieldPrefix: 'Site', // Optional: prefix for nested properties
  httpClient: (url, requestData, headers) async {
    final response = await dio.post(url, data: requestData);
    return response.data;
  },
);

// Example request format for Voo API Standard:
{
  "pageNumber": 1,
  "pageSize": 20,
  "logic": "And",
  "intFilters": [
    {
      "fieldName": "Site.siteNumber",
      "value": 100,
      "operator": "GreaterThanOrEqual"
    },
    {
      "fieldName": "Site.siteNumber",
      "value": 200,
      "operator": "LessThanOrEqual"
    }
  ],
  "stringFilters": [
    {
      "fieldName": "Site.name",
      "value": "Tech",
      "operator": "Contains"
    }
  ]
}
```

**Important Notes for Voo API Standard:**
- Number ranges are sent as two separate filters (GreaterThanOrEqual and LessThanOrEqual)
- The "Between" operator is not supported - it's automatically converted to two filters
- Filters are organized by type: stringFilters, intFilters, dateFilters, decimalFilters
- Field prefix is automatically applied to all field names when set

### Simple REST Standard
```dart
final dataSource = RemoteDataGridSource(
  apiEndpoint: 'https://api.example.com/products',
  apiStandard: ApiFilterStandard.simple,
  httpClient: (url, requestData, headers) async {
    // Generates: ?page=0&limit=20&status=active&age_gt=25&sort=-created_at
    final params = requestData['params'] as Map<String, String>;
    final response = await dio.get(url, queryParameters: params);
    return response.data;
  },
);
```

### JSON:API Standard
```dart
final dataSource = RemoteDataGridSource(
  apiEndpoint: 'https://api.example.com/products',
  apiStandard: ApiFilterStandard.jsonApi,
  httpClient: (url, requestData, headers) async {
    // Generates: ?page[number]=1&page[size]=20&filter[status]=active&sort=-created_at
    final params = requestData['params'] as Map<String, String>;
    final response = await dio.get(url, queryParameters: params);
    return response.data;
  },
);
```

### OData Standard
```dart
final dataSource = RemoteDataGridSource(
  apiEndpoint: 'https://api.example.com/odata/products',
  apiStandard: ApiFilterStandard.odata,
  httpClient: (url, requestData, headers) async {
    // Generates: ?$top=20&$skip=0&$filter=status eq 'active'&$orderby=name asc
    final params = requestData['params'] as Map<String, String>;
    final response = await dio.get(url, queryParameters: params);
    return response.data;
  },
);
```

### MongoDB/Elasticsearch Standard
```dart
final dataSource = RemoteDataGridSource(
  apiEndpoint: 'https://api.example.com/search',
  apiStandard: ApiFilterStandard.mongodb,
  httpClient: (url, requestData, headers) async {
    // Sends POST body with MongoDB-style query
    final body = requestData['body'];
    final response = await dio.post(url, data: body);
    return response.data;
  },
);
```

### GraphQL Standard
```dart
final dataSource = RemoteDataGridSource(
  apiEndpoint: 'https://api.example.com/graphql',
  apiStandard: ApiFilterStandard.graphql,
  httpClient: (url, requestData, headers) async {
    // Sends GraphQL query with variables
    final response = await dio.post(url, data: {
      'query': requestData['query'],
      'variables': requestData['variables'],
    });
    return response.data;
  },
);
```

### Custom Standard (Default)
```dart
final dataSource = RemoteDataGridSource(
  apiEndpoint: 'https://api.example.com/data',
  apiStandard: ApiFilterStandard.custom,
  httpClient: (url, requestData, headers) async {
    // Uses VooDataGrid's default format
    final response = await dio.post(url, data: requestData);
    return response.data;
  },
);
```

### Response Format
```json
{
  "data": [...],
  "current_page": 1,
  "total": 100,
  "per_page": 20,
  "last_page": 5
}
```

### Spring Boot Format
```json
{
  "content": [...],
  "pageable": {
    "pageNumber": 0,
    "pageSize": 20
  },
  "totalElements": 100,
  "totalPages": 5
}
```

### Custom Format
```dart
VooRemoteDataSource(
  url: 'https://api.example.com/data',
  apiStandard: ApiStandard.custom,
  responseParser: (response) {
    return DataGridResponse(
      data: response['items'],
      total: response['count'],
      page: response['page'],
      pageSize: response['limit'],
    );
  },
)
```

## Controller API

```dart
final controller = VooDataGridController(...);

// Refresh data
await controller.refresh();

// Navigate pages
controller.nextPage();
controller.previousPage();
controller.goToPage(3);

// Change page size
controller.setPageSize(50);

// Sorting
controller.sortBy('name', ascending: true);
controller.clearSort();

// Filtering
controller.setFilter('name', 'John');
controller.setFilters({
  'name': 'John',
  'status': 'Active',
});
controller.clearFilter('name');
controller.clearAllFilters();

// Selection
controller.selectAll();
controller.clearSelection();
controller.toggleSelection(item);
final selected = controller.selectedItems;

// Get current state
final currentPage = controller.currentPage;
final totalPages = controller.totalPages;
final isLoading = controller.isLoading;
final hasError = controller.hasError;
```

## Customization

### Styling

```dart
VooDataGrid(
  controller: controller,
  headerStyle: const DataGridHeaderStyle(
    backgroundColor: Colors.blue,
    textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    height: 56,
  ),
  rowStyle: DataGridRowStyle(
    height: 48,
    alternateColor: Colors.grey.shade50,
    hoverColor: Colors.blue.shade50,
  ),
  borderStyle: const DataGridBorderStyle(
    horizontal: BorderSide(color: Colors.grey),
    vertical: BorderSide(color: Colors.grey),
  ),
)
```

### Empty State

```dart
VooDataGrid(
  controller: controller,
  emptyStateBuilder: (context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text('No data available'),
        ],
      ),
    );
  },
)
```

### Loading State

```dart
VooDataGrid(
  controller: controller,
  loadingBuilder: (context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  },
)
```

### Error State

```dart
VooDataGrid(
  controller: controller,
  errorBuilder: (context, error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: $error'),
          ElevatedButton(
            onPressed: controller.refresh,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  },
)
```

## Error Handling

VooDataGrid provides comprehensive error handling with graceful fallbacks:

### Enhanced Error Recovery

- **Filters remain visible during errors**: Headers and filter row stay accessible even when data loading fails
- **Type-safe error handling**: Comprehensive try-catch blocks around valueGetter functions
- **Detailed error logging**: Debug mode provides detailed type information for troubleshooting

### Handling Type Mismatches

```dart
// The grid gracefully handles type mismatches
VooDataColumn<OrderModel>(
  field: 'status',
  label: 'Status',
  valueGetter: (row) {
    // This is protected with error handling
    return row.status?.name;
  },
  // Fallback for null or error cases
  valueFormatter: (value) => value ?? 'N/A',
)
```

### Debug Logging

In debug mode, detailed error information is logged:

```
[VooDataGrid Error] Failed to get value for column "status":
Error: type 'Null' is not a subtype of type 'String'
Row type: OrderModel
Column field: status
ValueGetter type: (OrderModel) => String?
```

## Widget Previews\n\nVooDataGrid includes comprehensive preview widgets for testing and development:\n\n### Available Previews\n\n1. **VooDataGridPreview** - Large dataset demo with 200+ rows and 15+ columns\n2. **VooDataGridApiStandardsPreview** - Interactive API standards configuration tool\n3. **VooDataGridEmptyStatePreview** - Demonstrates empty state with persistent headers\n4. **VooDataGridTypedObjectsPreview** - Demonstrates using VooDataGrid with typed objects\n\n### Using Previews\n\n```dart\nimport 'package:voo_data_grid/voo_data_grid.dart';\n\n// In your development/testing environment\nvoid main() {\n  runApp(const VooDataGridApiStandardsPreview());\n}\n```\n\n### Interactive API Standards Preview\n\nThe API standards preview provides:\n- Live switching between all 6 API standards\n- Real-time request format viewer\n- Copy-paste ready code examples\n- Interactive filter and sort testing\n\n## Performance Tips

1. **Use pagination** for large datasets
2. **Implement virtual scrolling** for very large lists
3. **Use `const` constructors** where possible
4. **Optimize cell builders** to be lightweight
5. **Cache remote data** when appropriate
6. **Use proper keys** for columns to optimize rebuilds

## Migration Guide

### From v0.5.1 to v0.5.2

**Bug Fixes & Improvements:**
- Fixed VooApiStandard number range filtering (now uses GreaterThanOrEqual/LessThanOrEqual instead of Between)
- Fixed filters disappearing when data loading fails  
- Enhanced error handling for type mismatches in valueGetter functions
- Added comprehensive error logging in debug mode

### From v0.5.0 to v0.5.1

**New Features:**
- Added field prefix support for nested properties
- Added action columns with `excludeFromApi` flag
- Added `onCellTap` callback for clickable cells

### From v0.4.0 to v0.5.0

**Breaking Changes:**
- All components now use generic type parameters for type safety
- `valueGetter` now has proper type signature: `dynamic Function(T row)`
- No casting needed in valueGetter functions anymore
- Compile-time type checking for all row data

### From v0.2.0 to v0.3.0

**Breaking Changes:**
- `StandardApiRequestBuilder` renamed to `DataGridRequestBuilder`
- API standards now integrated directly into `DataGridRequestBuilder`
- Preview files moved from `/preview` to `/lib/preview`

### From voo_ui

If you're migrating from the monolithic `voo_ui` package:

1. Update your dependencies:
```yaml
dependencies:
  voo_data_grid: ^0.5.4
  voo_ui_core: ^0.1.0  # Required for design system
```

2. Update imports:
```dart
// Old
import 'package:voo_ui/voo_ui.dart';

// New
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';
```

3. The API has been improved but remains similar. Main changes:
   - Controller is now required
   - Column configuration is more flexible
   - Better TypeScript support

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see the [LICENSE](LICENSE) file for details