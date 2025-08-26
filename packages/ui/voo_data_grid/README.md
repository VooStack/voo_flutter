# VooDataGrid

A powerful and flexible data grid widget for Flutter with advanced features like sorting, filtering, pagination, and remote data support.

[![pub package](https://img.shields.io/pub/v/voo_data_grid.svg)](https://pub.dev/packages/voo_data_grid)
[![style: flutter_lints](https://img.shields.io/badge/style-flutter__lints-4BC0F5.svg)](https://pub.dev/packages/flutter_lints)

## Features

- **Flexible Data Display**: Display tabular data with customizable columns and rows
- **Sorting**: Built-in column sorting with custom comparators
- **Filtering**: Advanced filtering capabilities with multiple filter types  
- **Pagination**: Server-side and client-side pagination support
- **Selection**: Row selection with single and multi-select modes
- **Remote Data**: Built-in support for fetching data from REST APIs
- **Performance**: Optimized for large datasets with efficient rendering
- **API Standards**: Support for multiple API standards (Laravel, Spring Boot, custom)
- **Customization**: Highly customizable headers, cells, and styling
- **Responsive**: Adapts to different screen sizes

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  voo_data_grid: ^0.1.0
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
      dataSource: VooRemoteDataSource(
        url: 'https://api.example.com/users',
        apiStandard: ApiStandard.laravel,
        headers: {
          'Authorization': 'Bearer YOUR_TOKEN',
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

## API Standards Support

The data grid supports multiple API response formats out of the box:

### Laravel Format
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

## Performance Tips

1. **Use pagination** for large datasets
2. **Implement virtual scrolling** for very large lists
3. **Use `const` constructors** where possible
4. **Optimize cell builders** to be lightweight
5. **Cache remote data** when appropriate
6. **Use proper keys** for columns to optimize rebuilds

## Migration from voo_ui

If you're migrating from the monolithic `voo_ui` package:

1. Update your dependencies:
```yaml
dependencies:
  voo_data_grid: ^0.1.0
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