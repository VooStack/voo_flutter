/// VooDataGrid Examples - Showcasing all filter types and API integrations
///
/// This file demonstrates:
/// 1. All built-in filter widget types
/// 2. Custom filters with operator selection
/// 3. DataGridRequestBuilder for various API standards (OData, REST, GraphQL, MongoDB)
/// 4. VooAdaptiveOverlay integration
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_adaptive_overlay/voo_adaptive_overlay.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

// =============================================================================
// EXAMPLE 1: All Built-in Filter Types
// =============================================================================

/// Example showing all built-in filter widget types
List<VooDataColumn<Map<String, dynamic>>> get allFilterTypesColumns => [
  // Text filter - simple text search
  const VooDataColumn(field: 'name', label: 'Name', filterable: true, filterWidgetType: VooFilterWidgetType.textField, filterHint: 'Search names...'),

  // Number filter - numeric input only
  const VooDataColumn(field: 'quantity', label: 'Quantity', filterable: true, dataType: VooDataColumnType.number, filterWidgetType: VooFilterWidgetType.numberField),

  // Number range filter - min/max inputs for between queries
  const VooDataColumn(field: 'price', label: 'Price', filterable: true, dataType: VooDataColumnType.number, filterWidgetType: VooFilterWidgetType.numberRange),

  // Dropdown filter - single selection from options
  const VooDataColumn(
    field: 'status',
    label: 'Status',
    filterable: true,
    filterWidgetType: VooFilterWidgetType.dropdown,
    filterOptions: [
      VooFilterOption(value: 'active', label: 'Active'),
      VooFilterOption(value: 'pending', label: 'Pending'),
      VooFilterOption(value: 'inactive', label: 'Inactive'),
    ],
  ),

  // Multi-select filter - multiple selections
  const VooDataColumn(
    field: 'tags',
    label: 'Tags',
    filterable: true,
    filterWidgetType: VooFilterWidgetType.multiSelect,
    filterOptions: [
      VooFilterOption(value: 'urgent', label: 'Urgent'),
      VooFilterOption(value: 'important', label: 'Important'),
      VooFilterOption(value: 'low', label: 'Low Priority'),
      VooFilterOption(value: 'archived', label: 'Archived'),
    ],
  ),

  // Date picker filter
  const VooDataColumn(field: 'createdAt', label: 'Created Date', filterable: true, dataType: VooDataColumnType.date, filterWidgetType: VooFilterWidgetType.datePicker),

  // Date range filter - start and end dates
  const VooDataColumn(field: 'dateRange', label: 'Date Range', filterable: true, dataType: VooDataColumnType.date, filterWidgetType: VooFilterWidgetType.dateRange),

  // Checkbox filter - boolean true/false
  const VooDataColumn(field: 'isActive', label: 'Active Only', filterable: true, dataType: VooDataColumnType.boolean, filterWidgetType: VooFilterWidgetType.checkbox),
];

// =============================================================================
// EXAMPLE 2: Custom Filter with Operator Selection
// =============================================================================

/// Custom filter widget that allows selecting comparison operators
/// Use this approach when you need advanced filtering like >, <, >=, <=, between
class OperatorSelectFilter extends StatefulWidget {
  final dynamic currentValue;
  final VooFilterOperator? currentOperator;
  final void Function(dynamic) onChanged;
  final String label;

  const OperatorSelectFilter({super.key, this.currentValue, this.currentOperator, required this.onChanged, required this.label});

  @override
  State<OperatorSelectFilter> createState() => _OperatorSelectFilterState();
}

class _OperatorSelectFilterState extends State<OperatorSelectFilter> {
  VooFilterOperator _selectedOperator = VooFilterOperator.equals;
  final _valueController = TextEditingController();
  final _valueToController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedOperator = widget.currentOperator ?? VooFilterOperator.equals;
    _valueController.text = widget.currentValue?.toString() ?? '';
  }

  @override
  void dispose() {
    _valueController.dispose();
    _valueToController.dispose();
    super.dispose();
  }

  String get _displayText {
    if (_valueController.text.isEmpty) return 'Filter...';
    final value = _valueController.text;
    final valueTo = _valueToController.text;
    switch (_selectedOperator) {
      case VooFilterOperator.equals:
        return '= $value';
      case VooFilterOperator.greaterThan:
        return '> $value';
      case VooFilterOperator.greaterThanOrEqual:
        return '>= $value';
      case VooFilterOperator.lessThan:
        return '< $value';
      case VooFilterOperator.lessThanOrEqual:
        return '<= $value';
      case VooFilterOperator.between:
        return '$value - $valueTo';
      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasValue = _valueController.text.isNotEmpty;

    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        onTap: () => _showOperatorPopup(context),
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _displayText,
                  style: TextStyle(fontSize: 13, color: hasValue ? theme.textTheme.bodyMedium?.color : theme.hintColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (hasValue)
                GestureDetector(
                  onTap: () {
                    _valueController.clear();
                    _valueToController.clear();
                    widget.onChanged(null);
                    setState(() {});
                  },
                  child: Icon(Icons.clear, size: 16, color: theme.hintColor),
                )
              else
                Icon(Icons.tune, size: 16, color: theme.hintColor),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showOperatorPopup(BuildContext context) async {
    const operators = <(VooFilterOperator, String, String)>[
      (VooFilterOperator.equals, '=', 'Equals'),
      (VooFilterOperator.greaterThan, '>', 'Greater than'),
      (VooFilterOperator.greaterThanOrEqual, '>=', 'Greater or equal'),
      (VooFilterOperator.lessThan, '<', 'Less than'),
      (VooFilterOperator.lessThanOrEqual, '<=', 'Less or equal'),
      (VooFilterOperator.between, '↔', 'Between'),
    ];

    await VooAdaptiveOverlay.show(
      context: context,
      title: Text('Filter: ${widget.label}'),
      config: const VooOverlayConfig(constraints: VooOverlayConstraints(maxWidth: 320, maxHeight: 400)),
      builder: (ctx, scrollController) => StatefulBuilder(
        builder: (context, setDialogState) {
          final isBetween = _selectedOperator == VooFilterOperator.between;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Operator selection chips
                Text(
                  'Condition',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Theme.of(context).hintColor),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: operators.map((op) {
                    final (operator, symbol, label) = op;
                    final isSelected = _selectedOperator == operator;
                    return Tooltip(
                      message: label,
                      child: InkWell(
                        onTap: () {
                          setDialogState(() => _selectedOperator = operator);
                          setState(() {});
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            symbol,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Value input(s)
                Text(
                  isBetween ? 'Range' : 'Value',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Theme.of(context).hintColor),
                ),
                const SizedBox(height: 8),
                if (isBetween)
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _valueController,
                          decoration: InputDecoration(
                            hintText: 'Min',
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.-]'))],
                        ),
                      ),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('to')),
                      Expanded(
                        child: TextField(
                          controller: _valueToController,
                          decoration: InputDecoration(
                            hintText: 'Max',
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.-]'))],
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: _valueController,
                    decoration: InputDecoration(
                      hintText: 'Enter value...',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.-]'))],
                    autofocus: true,
                  ),
              ],
            ),
          );
        },
      ),
      actions: [
        VooOverlayAction(
          label: 'Clear',
          onPressed: () {
            _valueController.clear();
            _valueToController.clear();
            widget.onChanged(null);
            setState(() {});
            Navigator.pop(context);
          },
        ),
        VooOverlayAction(
          label: 'Apply',
          isPrimary: true,
          onPressed: () {
            final value = num.tryParse(_valueController.text);
            final valueTo = num.tryParse(_valueToController.text);

            if (value == null && _selectedOperator != VooFilterOperator.between) {
              widget.onChanged(null);
            } else {
              widget.onChanged({'operator': _selectedOperator, 'value': value, if (_selectedOperator == VooFilterOperator.between) 'valueTo': valueTo});
            }
            setState(() {});
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

/// Example column with custom operator selection filter
VooDataColumn<Map<String, dynamic>> customOperatorFilterColumn() {
  return VooDataColumn<Map<String, dynamic>>(
    field: 'amount',
    label: 'Amount',
    filterable: true,
    dataType: VooDataColumnType.number,
    filterWidgetType: VooFilterWidgetType.custom,
    filterBuilder: (context, column, currentValue, onChanged) {
      // Extract operator and value from current filter if present
      VooFilterOperator? operator;
      dynamic value;
      if (currentValue is Map) {
        operator = currentValue['operator'] as VooFilterOperator?;
        value = currentValue['value'];
      }

      return OperatorSelectFilter(label: column.label, currentValue: value, currentOperator: operator, onChanged: onChanged);
    },
  );
}

// =============================================================================
// EXAMPLE 3: DataGridRequestBuilder for Various API Standards
// =============================================================================

/// Example: Building OData v4 requests for .NET APIs
void odataRequestExample() {
  const builder = DataGridRequestBuilder(
    standard: ApiFilterStandard.odata,
    odataDateTimeFormat: ODataDateTimeFormat.utc, // For .NET APIs
  );

  final request = builder.buildRequest(
    page: 0,
    pageSize: 20,
    filters: {
      'status': const VooDataFilter(operator: VooFilterOperator.equals, value: 'active'),
      'price': const VooDataFilter(operator: VooFilterOperator.greaterThan, value: 100),
      'name': const VooDataFilter(operator: VooFilterOperator.contains, value: 'widget'),
      'createdAt': VooDataFilter(operator: VooFilterOperator.greaterThanOrEqual, value: DateTime(2024, 1, 1)),
    },
    sorts: [
      const VooColumnSort(field: 'createdAt', direction: VooSortDirection.descending),
      const VooColumnSort(field: 'name', direction: VooSortDirection.ascending),
    ],
    additionalParams: {
      'includeCount': true,
      'select': ['id', 'name', 'price', 'status'],
      'expand': ['category', 'supplier'],
    },
  );

  // Result contains:
  // params['$skip'] = '0'
  // params['$top'] = '20'
  // params['$count'] = 'true'
  // params['$select'] = 'id,name,price,status'
  // params['$expand'] = 'category,supplier'
  // params['$filter'] = "status eq 'active' and price gt 100 and contains(name, 'widget') and createdAt ge 2024-01-01T00:00:00.000Z"
  // params['$orderby'] = 'createdAt desc,name asc'
  print('OData request params: ${request['params']}');
}

/// Example: Building simple REST requests
void simpleRestExample() {
  const builder = DataGridRequestBuilder(standard: ApiFilterStandard.simple);

  final request = builder.buildRequest(
    page: 1,
    pageSize: 25,
    filters: {
      'category': const VooDataFilter(operator: VooFilterOperator.equals, value: 'electronics'),
      'price': const VooDataFilter(operator: VooFilterOperator.between, value: 100, valueTo: 500),
    },
    sorts: [const VooColumnSort(field: 'name', direction: VooSortDirection.ascending)],
  );

  // Result:
  // params['page'] = '1'
  // params['limit'] = '25'
  // params['category'] = 'electronics'
  // params['price_from'] = '100'
  // params['price_to'] = '500'
  // params['sort'] = 'name'
  print('Simple REST params: ${request['params']}');
}

/// Example: Building MongoDB-style requests
void mongoDbExample() {
  const builder = DataGridRequestBuilder(standard: ApiFilterStandard.mongodb);

  final request = builder.buildRequest(
    page: 0,
    pageSize: 50,
    filters: {
      'tags': const VooDataFilter(operator: VooFilterOperator.inList, value: ['urgent', 'important']),
      'views': const VooDataFilter(operator: VooFilterOperator.greaterThan, value: 1000),
      'title': const VooDataFilter(operator: VooFilterOperator.contains, value: 'flutter'),
    },
    sorts: [const VooColumnSort(field: 'createdAt', direction: VooSortDirection.descending)],
  );

  // Result body:
  // {
  //   'skip': 0,
  //   'limit': 50,
  //   'query': {
  //     'tags': { '$in': ['urgent', 'important'] },
  //     'views': { '$gt': 1000 },
  //     'title': { '$regex': 'flutter', '$options': 'i' }
  //   },
  //   'sort': { 'createdAt': -1 }
  // }
  print('MongoDB request body: ${request['body']}');
}

/// Example: Building GraphQL variables
void graphqlExample() {
  const builder = DataGridRequestBuilder(standard: ApiFilterStandard.graphql);

  final request = builder.buildRequest(
    page: 0,
    pageSize: 10,
    filters: {
      'status': const VooDataFilter(operator: VooFilterOperator.equals, value: 'published'),
      'rating': const VooDataFilter(operator: VooFilterOperator.greaterThanOrEqual, value: 4),
    },
    sorts: [const VooColumnSort(field: 'rating', direction: VooSortDirection.descending)],
  );

  // Result:
  // variables['page'] = 0
  // variables['pageSize'] = 10
  // variables['where'] = { 'status': { 'eq': 'published' }, 'rating': { 'gte': 4 } }
  // variables['orderBy'] = [{ 'field': 'rating', 'direction': 'DESC' }]
  print('GraphQL variables: ${request['variables']}');
}

// =============================================================================
// EXAMPLE 4: Parsing API Responses
// =============================================================================

/// Example: Parsing OData v4 responses from .NET
void parseODataResponseExample() {
  // Typical OData response from ASP.NET Core
  final json = {
    '@odata.context': r'$metadata#Products',
    '@odata.count': 150,
    '@odata.nextLink': r'Products?$skip=20',
    'value': [
      {'id': 1, 'name': 'Widget A', 'price': 29.99},
      {'id': 2, 'name': 'Widget B', 'price': 49.99},
    ],
  };

  final response = DataGridRequestBuilder.parseODataResponse(json: json, page: 0, pageSize: 20);

  print('Total rows: ${response.totalRows}'); // 150
  print('Rows returned: ${response.rows.length}'); // 2

  // Extract metadata
  final metadata = DataGridRequestBuilder.extractODataMetadata(json);
  print('Has next page: ${metadata['hasNextPage']}'); // true
  print('Next link: ${metadata['@odata.nextLink']}');
}

/// Example: Parsing generic API responses
void parseGenericResponseExample() {
  // Custom API response format
  final json = {
    'items': [
      {'id': 1, 'name': 'Item 1'},
      {'id': 2, 'name': 'Item 2'},
    ],
    'totalCount': 100,
    'currentPage': 1,
    'itemsPerPage': 20,
  };

  final response = DataGridRequestBuilder.parseResponse(
    json: json,
    dataKey: 'items', // Custom key for data array
    totalKey: 'totalCount', // Custom key for total count
    pageKey: 'currentPage',
    pageSizeKey: 'itemsPerPage',
  );

  print('Parsed ${response.rows.length} rows of ${response.totalRows} total');
}

// =============================================================================
// EXAMPLE 5: Complete Data Source Implementation with OData
// =============================================================================

/// Example OData data source for ASP.NET Core backend
class ODataProductsSource extends VooDataGridSource<Map<String, dynamic>> {
  final String baseUrl;

  ODataProductsSource({required this.baseUrl});

  // Request builder configured for OData
  static const _builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata, odataDateTimeFormat: ODataDateTimeFormat.utc);

  @override
  Future<VooDataGridResponse<Map<String, dynamic>>> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    // Build OData query parameters
    final request = _builder.buildRequest(
      page: page,
      pageSize: pageSize,
      filters: filters,
      sorts: sorts,
      additionalParams: {
        'includeCount': true,
        'expand': ['Category', 'Supplier'],
      },
    );

    final params = request['params'] as Map<String, String>;

    // Build URL with query parameters
    final uri = Uri.parse(baseUrl).replace(queryParameters: params);

    // Make HTTP request (using your preferred HTTP client)
    // final response = await http.get(uri);
    // final json = jsonDecode(response.body);

    // For demo, simulate response
    final json = {
      '@odata.count': 100,
      'value': List.generate(
        pageSize,
        (i) => {
          'id': page * pageSize + i + 1,
          'name': 'Product ${page * pageSize + i + 1}',
          'price': (i + 1) * 10.99,
          'category': {'name': 'Category ${i % 3 + 1}'},
        },
      ),
    };

    final response = DataGridRequestBuilder.parseODataResponse(json: json, page: page, pageSize: pageSize);

    // Cast the response to the correct type
    return VooDataGridResponse<Map<String, dynamic>>(
      rows: response.rows.cast<Map<String, dynamic>>(),
      totalRows: response.totalRows,
      page: response.page,
      pageSize: response.pageSize,
    );
  }
}

// =============================================================================
// EXAMPLE 6: Using VooDataGridStateless for External State Management
// =============================================================================

/// Example using VooDataGridStateless with BLoC or other state management
class StatelessGridExample extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final int totalRows;
  final int currentPage;
  final bool isLoading;
  final Function(String field, VooSortDirection direction) onSort;
  final Function(String field, VooDataFilter? filter) onFilter;
  final Function(int page) onPageChange;

  const StatelessGridExample({
    super.key,
    required this.data,
    required this.totalRows,
    required this.currentPage,
    required this.isLoading,
    required this.onSort,
    required this.onFilter,
    required this.onPageChange,
  });

  @override
  Widget build(BuildContext context) {
    return VooDataGridStateless<Map<String, dynamic>>(
      state: VooDataGridState(rows: data, totalRows: totalRows, currentPage: currentPage, pageSize: 20, isLoading: isLoading, filtersVisible: true),
      columns: [
        const VooDataColumn(field: 'id', label: 'ID', width: 80),
        const VooDataColumn(field: 'name', label: 'Name', filterable: true),
        const VooDataColumn(
          field: 'status',
          label: 'Status',
          filterable: true,
          filterWidgetType: VooFilterWidgetType.dropdown,
          filterOptions: [
            VooFilterOption(value: 'active', label: 'Active'),
            VooFilterOption(value: 'inactive', label: 'Inactive'),
          ],
        ),
      ],
      onSortChanged: onSort,
      onFilterChanged: onFilter,
      onPageChanged: onPageChange,
    );
  }
}

// =============================================================================
// EXAMPLE 7: Export Configuration
// =============================================================================

/// Example showing export configuration
ExportConfig get exportConfigExample =>
    const ExportConfig(format: ExportFormat.pdf, title: 'Product Catalog', subtitle: 'Generated from VooDataGrid', companyName: 'Acme Corporation', author: 'Sales Team');

// =============================================================================
// EXAMPLE 8: String Operator Filter - Custom Text Search with Operators
// =============================================================================

/// Custom string filter widget with operator selection
/// Supports: contains, notContains, startsWith, endsWith, equals, notEquals
///
/// This is perfect for text columns where users need precise control over
/// how text matching works (e.g., search "apple" vs "starts with apple")
class StringOperatorFilter extends StatefulWidget {
  final dynamic currentValue;
  final void Function(dynamic) onChanged;
  final String label;
  final String? hint;

  const StringOperatorFilter({super.key, this.currentValue, required this.onChanged, required this.label, this.hint});

  @override
  State<StringOperatorFilter> createState() => _StringOperatorFilterState();
}

class _StringOperatorFilterState extends State<StringOperatorFilter> {
  VooFilterOperator _selectedOperator = VooFilterOperator.contains;
  final _textController = TextEditingController();

  static const _operators = <(VooFilterOperator, String, IconData)>[
    (VooFilterOperator.contains, 'Contains', Icons.text_fields),
    (VooFilterOperator.notContains, 'Not contains', Icons.block),
    (VooFilterOperator.startsWith, 'Starts with', Icons.first_page),
    (VooFilterOperator.endsWith, 'Ends with', Icons.last_page),
    (VooFilterOperator.equals, 'Exactly', Icons.check),
    (VooFilterOperator.notEquals, 'Not exactly', Icons.close),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.currentValue is Map) {
      _selectedOperator = widget.currentValue['operator'] as VooFilterOperator? ?? VooFilterOperator.contains;
      _textController.text = widget.currentValue['value']?.toString() ?? '';
    } else if (widget.currentValue != null) {
      _textController.text = widget.currentValue.toString();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String get _displayText {
    if (_textController.text.isEmpty) return widget.hint ?? 'Search...';
    final value = _textController.text;
    final opLabel = _operators.firstWhere((o) => o.$1 == _selectedOperator).$2.toLowerCase();
    return '$opLabel "$value"';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasValue = _textController.text.isNotEmpty;

    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        onTap: () => _showStringFilterPopup(context),
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _displayText,
                  style: TextStyle(fontSize: 13, color: hasValue ? theme.textTheme.bodyMedium?.color : theme.hintColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (hasValue)
                GestureDetector(
                  onTap: () {
                    _textController.clear();
                    widget.onChanged(null);
                    setState(() {});
                  },
                  child: Icon(Icons.clear, size: 16, color: theme.hintColor),
                )
              else
                Icon(Icons.search, size: 16, color: theme.hintColor),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showStringFilterPopup(BuildContext context) async {
    await VooAdaptiveOverlay.show(
      context: context,
      title: Text('Filter: ${widget.label}'),
      config: const VooOverlayConfig(constraints: VooOverlayConstraints(maxWidth: 360, maxHeight: 450)),
      builder: (ctx, scrollController) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Search text input
                Text(
                  'Search text',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Theme.of(context).hintColor),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Enter search text...',
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                    prefixIcon: const Icon(Icons.search, size: 20),
                  ),
                  autofocus: true,
                  onChanged: (_) => setDialogState(() {}),
                ),
                const SizedBox(height: 16),

                // Match type selection
                Text(
                  'Match type',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Theme.of(context).hintColor),
                ),
                const SizedBox(height: 8),
                ...List.generate(_operators.length, (index) {
                  final (operator, label, icon) = _operators[index];
                  final isSelected = _selectedOperator == operator;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: InkWell(
                      onTap: () {
                        setDialogState(() => _selectedOperator = operator);
                        setState(() {});
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            Icon(icon, size: 20, color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                label,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                            if (isSelected) Icon(Icons.check, size: 20, color: Theme.of(context).colorScheme.primary),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
      actions: [
        VooOverlayAction(
          label: 'Clear',
          onPressed: () {
            _textController.clear();
            _selectedOperator = VooFilterOperator.contains;
            widget.onChanged(null);
            setState(() {});
            Navigator.pop(context);
          },
        ),
        VooOverlayAction(
          label: 'Apply',
          isPrimary: true,
          onPressed: () {
            if (_textController.text.isEmpty) {
              widget.onChanged(null);
            } else {
              widget.onChanged({'operator': _selectedOperator, 'value': _textController.text});
            }
            setState(() {});
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

/// Example column with string operator filter
VooDataColumn<Map<String, dynamic>> stringOperatorFilterColumn({required String field, required String label, String? hint}) {
  return VooDataColumn<Map<String, dynamic>>(
    field: field,
    label: label,
    filterable: true,
    filterWidgetType: VooFilterWidgetType.custom,
    filterBuilder: (context, column, currentValue, onChanged) {
      return StringOperatorFilter(label: column.label, currentValue: currentValue, onChanged: onChanged, hint: hint);
    },
  );
}

// =============================================================================
// EXAMPLE 9: Star Rating Filter - Creative Custom Filter
// =============================================================================

/// Custom filter for star ratings - shows clickable stars
/// Perfect for filtering products/reviews by minimum rating
class StarRatingFilter extends StatefulWidget {
  final dynamic currentValue;
  final void Function(dynamic) onChanged;
  final int maxStars;

  const StarRatingFilter({super.key, this.currentValue, required this.onChanged, this.maxStars = 5});

  @override
  State<StarRatingFilter> createState() => _StarRatingFilterState();
}

class _StarRatingFilterState extends State<StarRatingFilter> {
  int? _selectedRating;

  @override
  void initState() {
    super.initState();
    if (widget.currentValue is Map) {
      _selectedRating = widget.currentValue['value'] as int?;
    } else if (widget.currentValue != null) {
      _selectedRating = int.tryParse(widget.currentValue.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Star buttons
          ...List.generate(widget.maxStars, (index) {
            final starValue = index + 1;
            final isSelected = _selectedRating != null && starValue <= _selectedRating!;

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (_selectedRating == starValue) {
                    // Deselect if clicking same star
                    _selectedRating = null;
                    widget.onChanged(null);
                  } else {
                    _selectedRating = starValue;
                    widget.onChanged({'operator': VooFilterOperator.greaterThanOrEqual, 'value': starValue});
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Icon(isSelected ? Icons.star : Icons.star_border, size: 20, color: isSelected ? Colors.amber : theme.hintColor),
              ),
            );
          }),
          // Clear button
          if (_selectedRating != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedRating = null;
                  widget.onChanged(null);
                });
              },
              child: Icon(Icons.clear, size: 16, color: theme.hintColor),
            ),
          ],
        ],
      ),
    );
  }
}

/// Example column with star rating filter
VooDataColumn<Map<String, dynamic>> starRatingFilterColumn() {
  return VooDataColumn<Map<String, dynamic>>(
    field: 'rating',
    label: 'Rating',
    filterable: true,
    dataType: VooDataColumnType.number,
    filterWidgetType: VooFilterWidgetType.custom,
    filterBuilder: (context, column, currentValue, onChanged) {
      return StarRatingFilter(currentValue: currentValue, onChanged: onChanged);
    },
    cellBuilder: (context, row, column) {
      final rating = row['rating'] as num? ?? 0;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (index) {
          return Icon(index < rating ? Icons.star : Icons.star_border, size: 16, color: Colors.amber);
        }),
      );
    },
  );
}

// =============================================================================
// EXAMPLE 10: Complete Product Catalog - All Features Together
// =============================================================================

/// Complete example demonstrating all VooDataGrid features
class ProductCatalogExample extends StatefulWidget {
  const ProductCatalogExample({super.key});

  @override
  State<ProductCatalogExample> createState() => _ProductCatalogExampleState();
}

class _ProductCatalogExampleState extends State<ProductCatalogExample> {
  late final VooDataGridController<Map<String, dynamic>> _controller;

  @override
  void initState() {
    super.initState();
    _controller = VooDataGridController<Map<String, dynamic>>(
      dataSource: _ProductDataSource(),
      columns: [
        // Basic ID column (non-filterable)
        const VooDataColumn(field: 'id', label: 'ID', width: 70, filterable: false),

        // String filter with operator selection (contains, startsWith, etc.)
        stringOperatorFilterColumn(field: 'name', label: 'Product Name', hint: 'Search products...'),

        // Dropdown filter for category
        const VooDataColumn(
          field: 'category',
          label: 'Category',
          filterable: true,
          filterWidgetType: VooFilterWidgetType.dropdown,
          filterOptions: [
            VooFilterOption(value: 'electronics', label: 'Electronics'),
            VooFilterOption(value: 'clothing', label: 'Clothing'),
            VooFilterOption(value: 'home', label: 'Home & Garden'),
            VooFilterOption(value: 'sports', label: 'Sports'),
          ],
        ),

        // Number operator filter for price (=, >, <, between)
        customOperatorFilterColumn(),

        // Star rating filter
        starRatingFilterColumn(),

        // Multi-select for tags
        const VooDataColumn(
          field: 'tags',
          label: 'Tags',
          filterable: true,
          filterWidgetType: VooFilterWidgetType.multiSelect,
          filterOptions: [
            VooFilterOption(value: 'bestseller', label: 'Bestseller'),
            VooFilterOption(value: 'new', label: 'New'),
            VooFilterOption(value: 'sale', label: 'On Sale'),
            VooFilterOption(value: 'limited', label: 'Limited Edition'),
          ],
        ),

        // Date filter for creation date
        const VooDataColumn(field: 'createdAt', label: 'Added Date', filterable: true, dataType: VooDataColumnType.date, filterWidgetType: VooFilterWidgetType.dateRange),

        // Checkbox filter for availability
        const VooDataColumn(field: 'inStock', label: 'In Stock', filterable: true, dataType: VooDataColumnType.boolean, filterWidgetType: VooFilterWidgetType.checkbox),
      ],
      showFilters: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VooDataGrid<Map<String, dynamic>>(
      controller: _controller,
      showPagination: true,
      showExportButton: true,
      exportConfig: const ExportConfig(format: ExportFormat.pdf, title: 'Product Catalog'),
    );
  }
}

/// Sample data source for the product catalog
class _ProductDataSource extends VooDataGridSource<Map<String, dynamic>> {
  @override
  Future<VooDataGridResponse<Map<String, dynamic>>> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Sample data
    final allProducts = List.generate(
      100,
      (i) => {
        'id': i + 1,
        'name': 'Product ${i + 1}',
        'category': ['electronics', 'clothing', 'home', 'sports'][i % 4],
        'amount': (i + 1) * 9.99,
        'rating': (i % 5) + 1,
        'tags': i % 3 == 0 ? ['bestseller', 'new'] : (i % 2 == 0 ? ['sale'] : []),
        'createdAt': DateTime.now().subtract(Duration(days: i)),
        'inStock': i % 5 != 0,
      },
    );

    // Apply pagination
    final startIndex = page * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, allProducts.length);
    final pageData = startIndex < allProducts.length ? allProducts.sublist(startIndex, endIndex) : <Map<String, dynamic>>[];

    return VooDataGridResponse(rows: pageData, totalRows: allProducts.length, page: page, pageSize: pageSize);
  }
}

// =============================================================================
// EXAMPLE 11: How Custom Filters Work with DataGridRequestBuilder
// =============================================================================

/// This example shows how custom filter values are handled by the request builder
void customFilterIntegrationExample() {
  const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

  // When using StringOperatorFilter, it returns a map with operator and value
  final filters = <String, VooDataFilter>{
    // From StringOperatorFilter: { operator: contains, value: 'widget' }
    'name': const VooDataFilter(operator: VooFilterOperator.contains, value: 'widget'),

    // From StringOperatorFilter: { operator: startsWith, value: 'Pro' }
    'sku': const VooDataFilter(operator: VooFilterOperator.startsWith, value: 'Pro'),

    // From OperatorSelectFilter: { operator: between, value: 10, valueTo: 100 }
    'price': const VooDataFilter(operator: VooFilterOperator.between, value: 10, valueTo: 100),

    // From StarRatingFilter: { operator: greaterThanOrEqual, value: 4 }
    'rating': const VooDataFilter(operator: VooFilterOperator.greaterThanOrEqual, value: 4),
  };

  final request = builder.buildRequest(page: 0, pageSize: 20, filters: filters, sorts: []);

  // OData result:
  // $filter = contains(name, 'widget') and startswith(sku, 'Pro') and (price ge 10 and price le 100) and rating ge 4
  print('OData filter: ${request['params']['\$filter']}');
}

// =============================================================================
// EXAMPLE 12: Boolean/Status Filter with Icons
// =============================================================================

/// Custom filter that shows status as colored badges
class StatusBadgeFilter extends StatefulWidget {
  final dynamic currentValue;
  final void Function(dynamic) onChanged;
  final List<({String value, String label, Color color})> statuses;

  const StatusBadgeFilter({super.key, this.currentValue, required this.onChanged, required this.statuses});

  @override
  State<StatusBadgeFilter> createState() => _StatusBadgeFilterState();
}

class _StatusBadgeFilterState extends State<StatusBadgeFilter> {
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    if (widget.currentValue is Map) {
      _selectedStatus = widget.currentValue['value'] as String?;
    } else if (widget.currentValue != null) {
      _selectedStatus = widget.currentValue.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget.statuses.map((status) {
            final isSelected = _selectedStatus == status.value;

            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (_selectedStatus == status.value) {
                      _selectedStatus = null;
                      widget.onChanged(null);
                    } else {
                      _selectedStatus = status.value;
                      widget.onChanged({'operator': VooFilterOperator.equals, 'value': status.value});
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? status.color : status.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: status.color),
                  ),
                  child: Text(
                    status.label,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: isSelected ? Colors.white : status.color),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Example column with status badge filter
VooDataColumn<Map<String, dynamic>> statusBadgeFilterColumn() {
  return VooDataColumn<Map<String, dynamic>>(
    field: 'status',
    label: 'Status',
    filterable: true,
    filterWidgetType: VooFilterWidgetType.custom,
    filterBuilder: (context, column, currentValue, onChanged) {
      return StatusBadgeFilter(
        currentValue: currentValue,
        onChanged: onChanged,
        statuses: const [
          (value: 'active', label: 'Active', color: Colors.green),
          (value: 'pending', label: 'Pending', color: Colors.orange),
          (value: 'inactive', label: 'Inactive', color: Colors.red),
          (value: 'archived', label: 'Archived', color: Colors.grey),
        ],
      );
    },
    cellBuilder: (context, row, column) {
      final status = row['status'] as String? ?? 'unknown';
      final colors = {'active': Colors.green, 'pending': Colors.orange, 'inactive': Colors.red, 'archived': Colors.grey};
      final color = colors[status] ?? Colors.grey;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
        child: Text(
          status.toUpperCase(),
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
        ),
      );
    },
  );
}
