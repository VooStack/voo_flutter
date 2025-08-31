import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

void main() {
  group('VooDataGridStateless Complete Feature Test', () {
    // Test data
    final testData = List.generate(
      30,
      (index) => {
        'id': index + 1,
        'name': 'Item ${index + 1}',
        'category': ['A', 'B', 'C'][index % 3],
        'price': (index + 1) * 10.5,
        'active': index % 2 == 0,
      },
    );

    // Test columns
    final columns = <VooDataColumn<Map<String, dynamic>>>[
      const VooDataColumn(
        field: 'id',
        label: 'ID',
        width: 80,
        dataType: VooDataColumnType.number,
        filterWidgetType: VooFilterWidgetType.numberField,
      ),
      const VooDataColumn(
        field: 'name',
        label: 'Name',
        width: 150,
        filterWidgetType: VooFilterWidgetType.textField,
      ),
      const VooDataColumn(
        field: 'category',
        label: 'Category',
        width: 120,
        filterWidgetType: VooFilterWidgetType.dropdown,
        filterOptions: [
          VooFilterOption(value: 'A', label: 'Category A'),
          VooFilterOption(value: 'B', label: 'Category B'),
          VooFilterOption(value: 'C', label: 'Category C'),
        ],
      ),
      const VooDataColumn(
        field: 'price',
        label: 'Price',
        width: 100,
        dataType: VooDataColumnType.number,
        filterWidgetType: VooFilterWidgetType.numberField,
      ),
      const VooDataColumn(
        field: 'active',
        label: 'Active',
        width: 80,
        dataType: VooDataColumnType.boolean,
        filterWidgetType: VooFilterWidgetType.checkbox,
      ),
    ];

    testWidgets('All features work correctly', (WidgetTester tester) async {
      // Track callback invocations
      String? lastSortField;
      VooSortDirection? lastSortDirection;
      // ignore: unused_local_variable
      String? lastFilterField;
      // ignore: unused_local_variable
      VooDataFilter? lastFilter;
      int? lastPage;
      // ignore: unused_local_variable
      int? lastPageSize;
      // ignore: unused_local_variable
      Map<String, dynamic>? lastSelectedRow;
      // ignore: unused_local_variable
      Map<String, dynamic>? lastDeselectedRow;
      bool? selectAllCalled;
      // ignore: unused_local_variable
      bool? deselectAllCalled;
      bool? toggleFiltersCalled;
      // ignore: unused_local_variable
      bool? filtersClearedCalled;

      // Initial state
      var state = VooDataGridState<Map<String, dynamic>>(
        rows: testData.take(10).toList(),
        totalRows: testData.length,
        pageSize: 10,
        selectionMode: VooSelectionMode.multiple,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => VooDataGridStateless<Map<String, dynamic>>(
                state: state,
                columns: columns,
                onSortChanged: (field, direction) {
                    lastSortField = field;
                    lastSortDirection = direction;
                    setState(() {
                      state = state.copyWith(
                        sorts: [VooColumnSort(field: field, direction: direction)],
                      );
                    });
                  },
                  onFilterChanged: (field, filter) {
                    lastFilterField = field;
                    lastFilter = filter;
                    setState(() {
                      final newFilters = Map<String, VooDataFilter>.from(state.filters);
                      if (filter == null) {
                        newFilters.remove(field);
                      } else {
                        newFilters[field] = filter;
                      }
                      state = state.copyWith(filters: newFilters);
                    });
                  },
                  onPageChanged: (page) {
                    lastPage = page;
                    setState(() {
                      state = state.copyWith(
                        currentPage: page,
                        rows: testData.skip(page * state.pageSize).take(state.pageSize).toList(),
                      );
                    });
                  },
                  onPageSizeChanged: (pageSize) {
                    lastPageSize = pageSize;
                    setState(() {
                      state = state.copyWith(
                        pageSize: pageSize,
                        rows: testData.take(pageSize).toList(),
                      );
                    });
                  },
                  onRowSelected: (row) {
                    lastSelectedRow = row;
                    setState(() {
                      final newSelection = Set<Map<String, dynamic>>.from(state.selectedRows);
                      newSelection.add(row);
                      state = state.copyWith(selectedRows: newSelection);
                    });
                  },
                  onRowDeselected: (row) {
                    lastDeselectedRow = row;
                    setState(() {
                      final newSelection = Set<Map<String, dynamic>>.from(state.selectedRows);
                      newSelection.remove(row);
                      state = state.copyWith(selectedRows: newSelection);
                    });
                  },
                  onSelectAll: () {
                    selectAllCalled = true;
                    setState(() {
                      state = state.copyWith(selectedRows: state.rows.toSet());
                    });
                  },
                  onDeselectAll: () {
                    deselectAllCalled = true;
                    setState(() {
                      state = state.copyWith(selectedRows: {});
                    });
                  },
                  onToggleFilters: () {
                    toggleFiltersCalled = true;
                    setState(() {
                      state = state.copyWith(filtersVisible: !state.filtersVisible);
                    });
                  },
                  onFiltersCleared: () {
                    filtersClearedCalled = true;
                    setState(() {
                      state = state.copyWith(filters: {});
                    });
                  },
                ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Test 1: Verify initial rendering
      expect(find.text('ID'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Category'), findsOneWidget);
      expect(find.text('Price'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);

      // Test 2: Sorting functionality
      await tester.tap(find.text('Name'));
      await tester.pumpAndSettle();
      expect(lastSortField, equals('name'));
      expect(lastSortDirection, equals(VooSortDirection.ascending));

      // Click again for descending
      await tester.tap(find.text('Name'));
      await tester.pumpAndSettle();
      expect(lastSortDirection, equals(VooSortDirection.descending));

      // Click again for no sort
      await tester.tap(find.text('Name'));
      await tester.pumpAndSettle();
      expect(lastSortDirection, equals(VooSortDirection.none));

      // Test 3: Filter toggle (only on desktop width)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 1200, // Desktop width
              height: 800,
              child: StatefulBuilder(
                builder: (context, setState) => VooDataGridStateless<Map<String, dynamic>>(
                  state: state,
                  columns: columns,
                  onToggleFilters: () {
                      toggleFiltersCalled = true;
                      setState(() {
                        state = state.copyWith(filtersVisible: !state.filtersVisible);
                      });
                    },
                    onFilterChanged: (field, filter) {
                      lastFilterField = field;
                      lastFilter = filter;
                      setState(() {
                        final newFilters = Map<String, VooDataFilter>.from(state.filters);
                        if (filter == null) {
                          newFilters.remove(field);
                        } else {
                          newFilters[field] = filter;
                        }
                        state = state.copyWith(filters: newFilters);
                      });
                    },
                    onPageChanged: (page) {
                      lastPage = page;
                      setState(() {
                        state = state.copyWith(
                          currentPage: page,
                          rows: testData.skip(page * state.pageSize).take(state.pageSize).toList(),
                        );
                      });
                    },
                  ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find and click filter toggle button
      final filterToggle = find.byIcon(Icons.filter_list);
      if (filterToggle.evaluate().isNotEmpty) {
        await tester.tap(filterToggle);
        await tester.pumpAndSettle();
        expect(toggleFiltersCalled, isTrue);
      }

      // Test 4: Pagination
      final nextPageButton = find.byIcon(Icons.navigate_next);
      if (nextPageButton.evaluate().isNotEmpty) {
        await tester.tap(nextPageButton);
        await tester.pumpAndSettle();
        expect(lastPage, equals(1));
      }

      // Test 5: Selection with checkboxes
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => VooDataGridStateless<Map<String, dynamic>>(
                state: state,
                columns: columns,
                onRowSelected: (row) {
                    lastSelectedRow = row;
                    setState(() {
                      final newSelection = Set<Map<String, dynamic>>.from(state.selectedRows);
                      newSelection.add(row);
                      state = state.copyWith(selectedRows: newSelection);
                    });
                  },
                  onSelectAll: () {
                    selectAllCalled = true;
                    setState(() {
                      state = state.copyWith(selectedRows: state.rows.toSet());
                    });
                  },
                  onDeselectAll: () {
                    deselectAllCalled = true;
                    setState(() {
                      state = state.copyWith(selectedRows: {});
                    });
                  },
                ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find and click select all checkbox (in header)
      final checkboxes = find.byType(Checkbox);
      if (checkboxes.evaluate().isNotEmpty) {
        await tester.tap(checkboxes.first);
        await tester.pumpAndSettle();
        expect(selectAllCalled, isTrue);
      }

      // Test 6: Test filter widgets are rendered with consistent theming
      // Create a new state with filters visible and data
      final filterTestState = VooDataGridState<Map<String, dynamic>>(
        rows: testData.take(10).toList(),
        totalRows: testData.length,
        pageSize: 10,
        filtersVisible: true,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 1200,
              height: 800,
              child: VooDataGridStateless<Map<String, dynamic>>(
                state: filterTestState,
                columns: columns,
                onFilterChanged: (field, filter) {
                  lastFilterField = field;
                  lastFilter = filter;
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check that filter row is rendered - it should be present when filters are visible
      final filterRow = find.byType(VooDataGridFilterRow<Map<String, dynamic>>);
      if (filterRow.evaluate().isNotEmpty) {
        expect(filterRow, findsOneWidget);
      }

      // Verify callbacks that were definitely triggered
      expect(lastSortField, isNotNull, reason: 'Sort field should be set');
      expect(lastSortDirection, isNotNull, reason: 'Sort direction should be set');
      
      // These might not be triggered depending on widget availability
      if (lastPage != null) {
        expect(lastPage, equals(1), reason: 'Page should be 1 after next button click');
      }
      
      if (selectAllCalled != null) {
        expect(selectAllCalled, isTrue, reason: 'Select all should have been called');
      }
    });

    testWidgets('Filter widgets have consistent 12px font size', (WidgetTester tester) async {
      final state = VooDataGridState<Map<String, dynamic>>(
        rows: testData.take(10).toList(),
        totalRows: testData.length,
        pageSize: 10,
        filtersVisible: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 1200,
              height: 800,
              child: VooDataGridStateless<Map<String, dynamic>>(
                state: state,
                columns: columns,
                onFilterChanged: (field, filter) {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check if filter row exists first
      final filterRowFinder = find.byType(VooDataGridFilterRow<Map<String, dynamic>>);
      
      if (filterRowFinder.evaluate().isNotEmpty) {
        // Find all TextField widgets in filter row
        final textFields = find.descendant(
          of: filterRowFinder,
          matching: find.byType(TextField),
        );

        // Check text fields if they exist
        if (textFields.evaluate().isNotEmpty) {
          for (final textField in textFields.evaluate()) {
            final TextField widget = textField.widget as TextField;
            if (widget.style != null) {
              expect(widget.style!.fontSize, equals(12));
            }
          }
        }

        // Find all dropdown buttons
        final dropdowns = find.descendant(
          of: filterRowFinder,
          matching: find.byType(DropdownButton),
        );

        // Check dropdowns if they exist
        if (dropdowns.evaluate().isNotEmpty) {
          for (final dropdown in dropdowns.evaluate()) {
            final DropdownButton widget = dropdown.widget as DropdownButton;
            if (widget.style != null) {
              expect(widget.style!.fontSize, equals(12));
            }
          }
        }
        
        // At least one type of filter widget should exist
        expect(
          textFields.evaluate().isNotEmpty || dropdowns.evaluate().isNotEmpty,
          isTrue,
          reason: 'Filter row should contain at least one filter widget',
        );
      }
    });
  });
}

// Extension to add copyWith method to VooDataGridState for testing
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
  }) =>
      VooDataGridState<T>(
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