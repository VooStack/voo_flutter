import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

void main() {
  runApp(const ComprehensiveTestApp());
}

class ComprehensiveTestApp extends StatelessWidget {
  const ComprehensiveTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: MaterialApp(
        title: 'VooDataGrid Comprehensive Test',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const ComprehensiveTestPage(),
      ),
    );
  }
}

class ComprehensiveTestPage extends StatefulWidget {
  const ComprehensiveTestPage({super.key});

  @override
  State<ComprehensiveTestPage> createState() => _ComprehensiveTestPageState();
}

class _ComprehensiveTestPageState extends State<ComprehensiveTestPage> {
  // Test data
  final List<Map<String, dynamic>> testData = List.generate(
    50,
    (index) => {
      'id': index + 1,
      'site_number': 'SITE${(index + 1).toString().padLeft(3, '0')}',
      'site_name': 'Site ${index + 1}',
      'jurisdiction': ['City A', 'City B', 'City C'][index % 3],
      'zoning': ['ZL', 'ZV', 'BV', 'FV', 'CO', 'ON', 'SD'][index % 7],
      'ZL': index % 3 == 0 ? 'Active' : null,
      'ZV': index % 3 == 1 ? 'Pending' : null,
      'BV': index % 3 == 2 ? 'Approved' : null,
      'FV': index % 4 == 0 ? 'In Review' : null,
      'CO': index % 4 == 1 ? 'Complete' : null,
      'ON': index % 4 == 2 ? 'On Hold' : null,
      'SD': index % 4 == 3 ? 'Scheduled' : null,
    },
  );

  // Columns configuration
  late final List<VooDataColumn<Map<String, dynamic>>> columns;

  // State for stateless grid
  late VooDataGridState<Map<String, dynamic>> gridState;

  // Controller for regular grid
  late VooDataGridController<Map<String, dynamic>> gridController;

  bool useStatelessGrid = false;
  final List<String> eventLog = [];

  @override
  void initState() {
    super.initState();
    
    columns = [
      const VooDataColumn(
        field: 'site_number',
        label: 'Site Number',
        width: 150,
        frozen: true,
        sortable: true,
        filterable: true,
        filterWidgetType: VooFilterWidgetType.textField,
      ),
      const VooDataColumn(
        field: 'site_name',
        label: 'Site Name',
        width: 200,
        sortable: true,
        filterable: true,
        filterWidgetType: VooFilterWidgetType.textField,
      ),
      VooDataColumn(
        field: 'jurisdiction',
        label: 'Jurisdiction',
        width: 150,
        sortable: true,
        filterable: true,
        filterWidgetType: VooFilterWidgetType.dropdown,
        filterOptions: const [
          VooFilterOption(value: 'City A', label: 'City A'),
          VooFilterOption(value: 'City B', label: 'City B'),
          VooFilterOption(value: 'City C', label: 'City C'),
        ],
      ),
      VooDataColumn(
        field: 'zoning',
        label: 'Zoning',
        width: 120,
        sortable: true,
        filterable: true,
        filterWidgetType: VooFilterWidgetType.dropdown,
        filterOptions: const [
          VooFilterOption(value: 'ZL', label: 'ZL'),
          VooFilterOption(value: 'ZV', label: 'ZV'),
          VooFilterOption(value: 'BV', label: 'BV'),
          VooFilterOption(value: 'FV', label: 'FV'),
          VooFilterOption(value: 'CO', label: 'CO'),
          VooFilterOption(value: 'ON', label: 'ON'),
          VooFilterOption(value: 'SD', label: 'SD'),
        ],
      ),
      VooDataColumn(
        field: 'ZL',
        label: 'ZL',
        width: 100,
        sortable: true,
        filterable: true,
        filterWidgetType: VooFilterWidgetType.dropdown,
        filterOptions: const [
          VooFilterOption(value: 'Active', label: 'Active'),
        ],
      ),
      VooDataColumn(
        field: 'ZV',
        label: 'ZV',
        width: 100,
        sortable: true,
        filterable: true,
        filterWidgetType: VooFilterWidgetType.dropdown,
        filterOptions: const [
          VooFilterOption(value: 'Pending', label: 'Pending'),
        ],
      ),
      VooDataColumn(
        field: 'BV',
        label: 'BV',
        width: 100,
        sortable: true,
        filterable: true,
        filterWidgetType: VooFilterWidgetType.dropdown,
        filterOptions: const [
          VooFilterOption(value: 'Approved', label: 'Approved'),
        ],
      ),
      VooDataColumn(
        field: 'FV',
        label: 'FV',
        width: 100,
        sortable: true,
        filterable: true,
        filterWidgetType: VooFilterWidgetType.dropdown,
        filterOptions: const [
          VooFilterOption(value: 'In Review', label: 'In Review'),
        ],
      ),
      VooDataColumn(
        field: 'CO',
        label: 'CO',
        width: 100,
        sortable: true,
        filterable: true,
        filterWidgetType: VooFilterWidgetType.dropdown,
        filterOptions: const [
          VooFilterOption(value: 'Complete', label: 'Complete'),
        ],
      ),
      VooDataColumn(
        field: 'ON',
        label: 'ON',
        width: 100,
        sortable: true,
        filterable: true,
        filterWidgetType: VooFilterWidgetType.dropdown,
        filterOptions: const [
          VooFilterOption(value: 'On Hold', label: 'On Hold'),
        ],
      ),
      VooDataColumn(
        field: 'SD',
        label: 'SD',
        width: 100,
        sortable: true,
        filterable: true,
        filterWidgetType: VooFilterWidgetType.dropdown,
        filterOptions: const [
          VooFilterOption(value: 'Scheduled', label: 'Scheduled'),
        ],
      ),
    ];

    // Initialize state for stateless grid
    gridState = VooDataGridState<Map<String, dynamic>>(
      rows: testData.take(10).toList(),
      totalRows: testData.length,
      currentPage: 0,
      pageSize: 10,
      isLoading: false,
      filtersVisible: false,
      selectionMode: VooSelectionMode.multiple,
    );

    // Initialize controller for regular grid
    final dataSource = VooLocalDataSource<Map<String, dynamic>>(
      data: testData,
      selectionMode: VooSelectionMode.multiple,
    );
    
    gridController = VooDataGridController<Map<String, dynamic>>(
      dataSource: dataSource,
      columns: columns,
    );
  }

  @override
  void dispose() {
    gridController.dispose();
    super.dispose();
  }

  void _logEvent(String event) {
    setState(() {
      eventLog.insert(0, '${DateTime.now().toIso8601String()}: $event');
      if (eventLog.length > 20) {
        eventLog.removeRange(20, eventLog.length);
      }
    });
  }

  void _handleSort(String field, VooSortDirection direction) {
    _logEvent('SORT: $field - ${direction.name}');
    
    setState(() {
      if (direction == VooSortDirection.none) {
        gridState = gridState.copyWith(sorts: []);
      } else {
        gridState = gridState.copyWith(
          sorts: [VooColumnSort(field: field, direction: direction)],
        );
      }
      
      // Apply sorting to data
      final filteredData = _applyFiltering(testData, gridState.filters);
      final sortedData = _applySorting(filteredData, gridState.sorts);
      final paginatedData = _applyPagination(sortedData, gridState.currentPage, gridState.pageSize);
      gridState = gridState.copyWith(
        rows: paginatedData,
        totalRows: filteredData.length,
      );
    });
  }

  void _handleFilter(String field, VooDataFilter? filter) {
    _logEvent('FILTER: $field - ${filter?.value ?? 'cleared'}');
    
    setState(() {
      final newFilters = Map<String, VooDataFilter>.from(gridState.filters);
      if (filter == null) {
        newFilters.remove(field);
      } else {
        newFilters[field] = filter;
      }
      
      gridState = gridState.copyWith(filters: newFilters);
      
      // Apply filtering and pagination
      final filteredData = _applyFiltering(testData, newFilters);
      final sortedData = _applySorting(filteredData, gridState.sorts);
      final paginatedData = _applyPagination(sortedData, 0, gridState.pageSize);
      
      gridState = gridState.copyWith(
        rows: paginatedData,
        totalRows: filteredData.length,
        currentPage: 0,
      );
    });
  }

  void _handlePageChanged(int page) {
    _logEvent('PAGE: ${page + 1}');
    
    setState(() {
      gridState = gridState.copyWith(currentPage: page);
      
      // Apply pagination
      final filteredData = _applyFiltering(testData, gridState.filters);
      final sortedData = _applySorting(filteredData, gridState.sorts);
      final paginatedData = _applyPagination(sortedData, page, gridState.pageSize);
      
      gridState = gridState.copyWith(rows: paginatedData);
    });
  }

  void _handlePageSizeChanged(int pageSize) {
    _logEvent('PAGE SIZE: $pageSize');
    
    setState(() {
      final filteredData = _applyFiltering(testData, gridState.filters);
      final sortedData = _applySorting(filteredData, gridState.sorts);
      final paginatedData = _applyPagination(sortedData, 0, pageSize);
      
      gridState = gridState.copyWith(
        pageSize: pageSize,
        currentPage: 0,
        rows: paginatedData,
      );
    });
  }

  void _handleRowSelected(Map<String, dynamic> row) {
    _logEvent('ROW SELECTED: ${row['site_number']}');
    
    setState(() {
      final newSelection = Set<Map<String, dynamic>>.from(gridState.selectedRows);
      newSelection.add(row);
      gridState = gridState.copyWith(selectedRows: newSelection);
    });
  }

  void _handleRowDeselected(Map<String, dynamic> row) {
    _logEvent('ROW DESELECTED: ${row['site_number']}');
    
    setState(() {
      final newSelection = Set<Map<String, dynamic>>.from(gridState.selectedRows);
      newSelection.remove(row);
      gridState = gridState.copyWith(selectedRows: newSelection);
    });
  }

  void _handleSelectAll() {
    _logEvent('SELECT ALL');
    
    setState(() {
      gridState = gridState.copyWith(
        selectedRows: gridState.rows.toSet(),
      );
    });
  }

  void _handleDeselectAll() {
    _logEvent('DESELECT ALL');
    
    setState(() {
      gridState = gridState.copyWith(selectedRows: {});
    });
  }

  void _handleToggleFilters() {
    _logEvent('TOGGLE FILTERS: ${!gridState.filtersVisible}');
    
    setState(() {
      gridState = gridState.copyWith(filtersVisible: !gridState.filtersVisible);
    });
  }

  void _handleFiltersCleared() {
    _logEvent('FILTERS CLEARED');
    
    setState(() {
      gridState = gridState.copyWith(filters: {});
      
      // Re-apply data without filters
      final sortedData = _applySorting(testData, gridState.sorts);
      final paginatedData = _applyPagination(sortedData, 0, gridState.pageSize);
      
      gridState = gridState.copyWith(
        rows: paginatedData,
        totalRows: testData.length,
        currentPage: 0,
      );
    });
  }

  List<Map<String, dynamic>> _applyFiltering(
    List<Map<String, dynamic>> data,
    Map<String, VooDataFilter> filters,
  ) {
    if (filters.isEmpty) return data;
    
    return data.where((row) {
      for (final entry in filters.entries) {
        final field = entry.key;
        final filter = entry.value;
        final value = row[field];
        
        if (filter.operator == VooFilterOperator.equals) {
          if (value != filter.value) return false;
        } else if (filter.operator == VooFilterOperator.contains) {
          if (value == null || !value.toString().toLowerCase().contains(
                filter.value.toString().toLowerCase())) {
            return false;
          }
        }
      }
      return true;
    }).toList();
  }

  List<Map<String, dynamic>> _applySorting(
    List<Map<String, dynamic>> data,
    List<VooColumnSort> sorts,
  ) {
    if (sorts.isEmpty) return data;
    
    final sortedData = List<Map<String, dynamic>>.from(data);
    for (final sort in sorts) {
      sortedData.sort((a, b) {
        final aValue = a[sort.field];
        final bValue = b[sort.field];
        
        if (aValue == null && bValue == null) return 0;
        if (aValue == null) return 1;
        if (bValue == null) return -1;
        
        final comparison = aValue.toString().compareTo(bValue.toString());
        return sort.direction == VooSortDirection.ascending ? comparison : -comparison;
      });
    }
    
    return sortedData;
  }

  List<Map<String, dynamic>> _applyPagination(
    List<Map<String, dynamic>> data,
    int page,
    int pageSize,
  ) {
    final start = page * pageSize;
    final end = (start + pageSize).clamp(0, data.length);
    
    if (start >= data.length) return [];
    return data.sublist(start, end);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('VooDataGrid Comprehensive Test'),
        actions: [
          const Text('Grid Type: '),
          Switch(
            value: useStatelessGrid,
            onChanged: (value) {
              setState(() {
                useStatelessGrid = value;
                _logEvent('SWITCHED TO: ${value ? 'Stateless' : 'Controller'} Grid');
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                useStatelessGrid ? 'Stateless' : 'Controller',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          // Main Grid Area
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Status Bar
                  if (gridState.selectedRows.isNotEmpty || 
                      gridState.filters.isNotEmpty ||
                      gridState.sorts.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          if (gridState.selectedRows.isNotEmpty)
                            Chip(
                              label: Text('${gridState.selectedRows.length} selected'),
                              backgroundColor: Colors.green.shade100,
                            ),
                          const SizedBox(width: 8),
                          if (gridState.filters.isNotEmpty)
                            Chip(
                              label: Text('${gridState.filters.length} filters'),
                              backgroundColor: Colors.orange.shade100,
                            ),
                          const SizedBox(width: 8),
                          if (gridState.sorts.isNotEmpty)
                            Chip(
                              label: Text('${gridState.sorts.length} sorts'),
                              backgroundColor: Colors.purple.shade100,
                            ),
                        ],
                      ),
                    ),
                  
                  // The Grid
                  Expanded(
                    child: useStatelessGrid
                        ? VooDataGridStateless<Map<String, dynamic>>(
                            state: gridState,
                            columns: columns,
                            onSortChanged: _handleSort,
                            onFilterChanged: _handleFilter,
                            onPageChanged: _handlePageChanged,
                            onPageSizeChanged: _handlePageSizeChanged,
                            onRowSelected: _handleRowSelected,
                            onRowDeselected: _handleRowDeselected,
                            onSelectAll: _handleSelectAll,
                            onDeselectAll: _handleDeselectAll,
                            onToggleFilters: _handleToggleFilters,
                            onFiltersCleared: _handleFiltersCleared,
                            onRowTap: (row) {
                              _logEvent('ROW TAP: ${row['site_number']}');
                            },
                            onRowDoubleTap: (row) {
                              _logEvent('ROW DOUBLE TAP: ${row['site_number']}');
                            },
                          )
                        : VooDataGrid<Map<String, dynamic>>(
                            controller: gridController,
                            onRowTap: (row) {
                              _logEvent('ROW TAP: ${row['site_number']}');
                            },
                            onRowDoubleTap: (row) {
                              _logEvent('ROW DOUBLE TAP: ${row['site_number']}');
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          
          // Event Log Panel
          Container(
            width: 300,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(
                left: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey.shade200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Event Log',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear_all),
                        onPressed: () {
                          setState(() {
                            eventLog.clear();
                          });
                        },
                        tooltip: 'Clear Log',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: eventLog.length,
                    itemBuilder: (context, index) {
                      final event = eventLog[index];
                      final parts = event.split(': ');
                      final timestamp = parts[0].split('T')[1].split('.')[0];
                      final message = parts.sublist(1).join(': ');
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 4),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                timestamp,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              Text(
                                message,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Extension to add copyWith method to VooDataGridState
extension VooDataGridStateCopyWith<T> on VooDataGridState<T> {
  VooDataGridState<T> copyWith({
    List<T>? rows,
    int? totalRows,
    int? currentPage,
    int? pageSize,
    bool? isLoading,
    String? error,
    Map<String, VooDataFilter>? filters,
    List<VooColumnSort>? sorts,
    Set<T>? selectedRows,
    VooSelectionMode? selectionMode,
    bool? filtersVisible,
  }) {
    return VooDataGridState<T>(
      rows: rows ?? this.rows,
      totalRows: totalRows ?? this.totalRows,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      filters: filters ?? this.filters,
      sorts: sorts ?? this.sorts,
      selectedRows: selectedRows ?? this.selectedRows,
      selectionMode: selectionMode ?? this.selectionMode,
      filtersVisible: filtersVisible ?? this.filtersVisible,
    );
  }
}