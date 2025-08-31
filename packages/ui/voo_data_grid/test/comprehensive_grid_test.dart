import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/src/presentation/widgets/organisms/data_grid_card_view.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

void main() {
  group('Comprehensive VooDataGrid Tests', () {
    // Test data
    final testData = List.generate(
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

    // Test columns configuration
    final testColumns = <VooDataColumn<Map<String, dynamic>>>[
      const VooDataColumn(
        field: 'site_number',
        label: 'Site Number',
        width: 150,
        frozen: true,
        filterWidgetType: VooFilterWidgetType.textField,
      ),
      const VooDataColumn(
        field: 'site_name',
        label: 'Site Name',
        width: 200,
        filterWidgetType: VooFilterWidgetType.textField,
      ),
      const VooDataColumn(
        field: 'jurisdiction',
        label: 'Jurisdiction',
        width: 150,
        filterWidgetType: VooFilterWidgetType.dropdown,
        filterOptions: [
          VooFilterOption(value: 'City A', label: 'City A'),
          VooFilterOption(value: 'City B', label: 'City B'),
          VooFilterOption(value: 'City C', label: 'City C'),
        ],
      ),
      const VooDataColumn(
        field: 'zoning',
        label: 'Zoning',
        width: 120,
        filterWidgetType: VooFilterWidgetType.dropdown,
        filterOptions: [
          VooFilterOption(value: 'ZL', label: 'ZL'),
          VooFilterOption(value: 'ZV', label: 'ZV'),
          VooFilterOption(value: 'BV', label: 'BV'),
          VooFilterOption(value: 'FV', label: 'FV'),
          VooFilterOption(value: 'CO', label: 'CO'),
          VooFilterOption(value: 'ON', label: 'ON'),
          VooFilterOption(value: 'SD', label: 'SD'),
        ],
      ),
      const VooDataColumn(
        field: 'ZL',
        label: 'ZL',
        width: 100,
        filterWidgetType: VooFilterWidgetType.dropdown,
        filterOptions: [
          VooFilterOption(value: 'Active', label: 'Active'),
        ],
      ),
      const VooDataColumn(
        field: 'ZV',
        label: 'ZV',
        width: 100,
        filterWidgetType: VooFilterWidgetType.dropdown,
        filterOptions: [
          VooFilterOption(value: 'Pending', label: 'Pending'),
        ],
      ),
      const VooDataColumn(
        field: 'BV',
        label: 'BV',
        width: 100,
        filterWidgetType: VooFilterWidgetType.dropdown,
        filterOptions: [
          VooFilterOption(value: 'Approved', label: 'Approved'),
        ],
      ),
      const VooDataColumn(
        field: 'FV',
        label: 'FV',
        width: 100,
        filterWidgetType: VooFilterWidgetType.dropdown,
        filterOptions: [
          VooFilterOption(value: 'In Review', label: 'In Review'),
        ],
      ),
      const VooDataColumn(
        field: 'CO',
        label: 'CO',
        width: 100,
        filterWidgetType: VooFilterWidgetType.dropdown,
        filterOptions: [
          VooFilterOption(value: 'Complete', label: 'Complete'),
        ],
      ),
      const VooDataColumn(
        field: 'ON',
        label: 'ON',
        width: 100,
        filterWidgetType: VooFilterWidgetType.dropdown,
        filterOptions: [
          VooFilterOption(value: 'On Hold', label: 'On Hold'),
        ],
      ),
      const VooDataColumn(
        field: 'SD',
        label: 'SD',
        width: 100,
        filterWidgetType: VooFilterWidgetType.dropdown,
        filterOptions: [
          VooFilterOption(value: 'Scheduled', label: 'Scheduled'),
        ],
      ),
    ];

    group('VooDataGridStateless Tests', () {
      testWidgets('renders with initial state', (WidgetTester tester) async {
        final state = VooDataGridState<Map<String, dynamic>>(
          rows: testData.take(10).toList(),
          totalRows: testData.length,
          pageSize: 10,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VooDataGridStateless<Map<String, dynamic>>(
                state: state,
                columns: testColumns,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify header columns are rendered
        expect(find.text('Site Number'), findsOneWidget);
        expect(find.text('Site Name'), findsOneWidget);
        expect(find.text('Jurisdiction'), findsOneWidget);
      });

      testWidgets('onSort callback is triggered', (WidgetTester tester) async {
        String? sortedField;
        VooSortDirection? sortDirection;

        final state = VooDataGridState<Map<String, dynamic>>(
          rows: testData.take(10).toList(),
          totalRows: testData.length,
          pageSize: 10,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VooDataGridStateless<Map<String, dynamic>>(
                state: state,
                columns: testColumns,
                onSortChanged: (field, direction) {
                  sortedField = field;
                  sortDirection = direction;
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Click on Site Number header to trigger sort
        await tester.tap(find.text('Site Number'));
        await tester.pumpAndSettle();

        expect(sortedField, equals('site_number'));
        expect(sortDirection, equals(VooSortDirection.ascending));
      });

      testWidgets('onFilter callback is triggered', (WidgetTester tester) async {
        String? filteredField;
        VooDataFilter? filterValue;

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
                height: 600,
                child: VooDataGridStateless<Map<String, dynamic>>(
                  state: state,
                  columns: testColumns,
                  onFilterChanged: (field, filter) {
                    filteredField = field;
                    filterValue = filter;
                  },
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Find and interact with the jurisdiction dropdown filter
        final dropdowns = find.byType(DropdownButton<dynamic>);
        if (dropdowns.evaluate().isNotEmpty) {
          await tester.tap(dropdowns.at(2)); // Jurisdiction dropdown
          await tester.pumpAndSettle();

          // Select City A
          await tester.tap(find.text('City A').last);
          await tester.pumpAndSettle();

          expect(filteredField, equals('jurisdiction'));
          expect(filterValue?.value, equals('City A'));
        }
      });

      testWidgets('onPageChanged callback is triggered', (WidgetTester tester) async {
        int? newPage;

        final state = VooDataGridState<Map<String, dynamic>>(
          rows: testData.take(10).toList(),
          totalRows: testData.length,
          pageSize: 10,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VooDataGridStateless<Map<String, dynamic>>(
                state: state,
                columns: testColumns,
                onPageChanged: (page) {
                  newPage = page;
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Find and click next page button
        final nextButton = find.byIcon(Icons.navigate_next);
        if (nextButton.evaluate().isNotEmpty) {
          await tester.tap(nextButton);
          await tester.pumpAndSettle();

          expect(newPage, equals(1));
        }
      });

      testWidgets('onRowSelected callback is triggered', (WidgetTester tester) async {
        Map<String, dynamic>? selectedRow;

        final state = VooDataGridState<Map<String, dynamic>>(
          rows: testData.take(10).toList(),
          totalRows: testData.length,
          pageSize: 10,
          selectionMode: VooSelectionMode.single,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VooDataGridStateless<Map<String, dynamic>>(
                state: state,
                columns: testColumns,
                onRowSelected: (row) {
                  selectedRow = row;
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Click on the first row
        await tester.tap(find.text('SITE001'));
        await tester.pumpAndSettle();

        expect(selectedRow, isNotNull);
        expect(selectedRow?['site_number'], equals('SITE001'));
      });
    });

    group('VooDataGrid with Controller Tests', () {
      testWidgets('renders with local data source', (WidgetTester tester) async {
        final dataSource = VooLocalDataSource<Map<String, dynamic>>(
          data: testData,
        );

        final controller = VooDataGridController<Map<String, dynamic>>(
          dataSource: dataSource,
          columns: testColumns,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VooDataGrid<Map<String, dynamic>>(
                controller: controller,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify data is rendered
        expect(find.text('SITE001'), findsOneWidget);
        expect(find.text('Site 1'), findsOneWidget);
      });

      testWidgets('sorting works correctly', (WidgetTester tester) async {
        final dataSource = VooLocalDataSource<Map<String, dynamic>>(
          data: testData,
        );

        final controller = VooDataGridController<Map<String, dynamic>>(
          dataSource: dataSource,
          columns: testColumns,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VooDataGrid<Map<String, dynamic>>(
                controller: controller,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Click on Site Number header to sort
        await tester.tap(find.text('Site Number'));
        await tester.pumpAndSettle();

        // Verify sort was applied
        expect(controller.dataSource.sorts.length, equals(1));
        expect(controller.dataSource.sorts.first.field, equals('site_number'));
        expect(controller.dataSource.sorts.first.direction, equals(VooSortDirection.ascending));
      });

      testWidgets('filtering works correctly', (WidgetTester tester) async {
        final dataSource = VooLocalDataSource<Map<String, dynamic>>(
          data: testData,
        );

        final controller = VooDataGridController<Map<String, dynamic>>(
          dataSource: dataSource,
          columns: testColumns,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 1200,
                height: 600,
                child: VooDataGrid<Map<String, dynamic>>(
                  controller: controller,
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Toggle filters
        controller.toggleFilters();
        await tester.pumpAndSettle();

        // Apply filter
        dataSource.applyFilter(
          'jurisdiction',
          const VooDataFilter(
            operator: VooFilterOperator.equals,
            value: 'City A',
          ),
        );
        await tester.pumpAndSettle();

        // Verify filter was applied
        expect(controller.dataSource.filters.length, equals(1));
        expect(controller.dataSource.filters['jurisdiction']?.value, equals('City A'));
      });

      testWidgets('pagination works correctly', (WidgetTester tester) async {
        final dataSource = VooLocalDataSource<Map<String, dynamic>>(
          data: testData,
        );

        final controller = VooDataGridController<Map<String, dynamic>>(
          dataSource: dataSource,
          columns: testColumns,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VooDataGrid<Map<String, dynamic>>(
                controller: controller,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify initial page
        expect(dataSource.currentPage, equals(0));

        // Change page
        dataSource.changePage(1);
        await tester.pumpAndSettle();

        expect(dataSource.currentPage, equals(1));
      });

      testWidgets('selection works correctly', (WidgetTester tester) async {
        final dataSource = VooLocalDataSource<Map<String, dynamic>>(
          data: testData,
        );

        final controller = VooDataGridController<Map<String, dynamic>>(
          dataSource: dataSource,
          columns: testColumns,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VooDataGrid<Map<String, dynamic>>(
                controller: controller,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Select a row
        dataSource.toggleRowSelection(testData[0]);
        await tester.pumpAndSettle();

        expect(dataSource.selectedRows.length, equals(1));
        expect(dataSource.selectedRows.first, equals(testData[0]));

        // Select all
        dataSource.selectAll();
        await tester.pumpAndSettle();

        expect(dataSource.selectedRows.length, equals(dataSource.rows.length));

        // Clear selection
        dataSource.clearSelection();
        await tester.pumpAndSettle();

        expect(dataSource.selectedRows.length, equals(0));
      });
    });

    group('UI Layout Tests', () {
      testWidgets('filter row layout is correct', (WidgetTester tester) async {
        final dataSource = VooLocalDataSource<Map<String, dynamic>>(
          data: testData,
        );

        final controller = VooDataGridController<Map<String, dynamic>>(
          dataSource: dataSource,
          columns: testColumns,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 1200,
                height: 600,
                child: VooDataGrid<Map<String, dynamic>>(
                  controller: controller,
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Toggle filters to show filter row
        controller.toggleFilters();
        await tester.pumpAndSettle();

        // Find filter row
        final filterRow = find.byType(VooDataGridFilterRow);
        expect(filterRow, findsOneWidget);

        // Verify dropdowns are rendered
        final dropdowns = find.byType(DropdownButton);
        expect(dropdowns, findsWidgets);
      });

      testWidgets('responsive layout works correctly', (WidgetTester tester) async {
        final dataSource = VooLocalDataSource<Map<String, dynamic>>(
          data: testData,
        );

        final controller = VooDataGridController<Map<String, dynamic>>(
          dataSource: dataSource,
          columns: testColumns,
        );

        // Test desktop layout
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 1200,
                height: 600,
                child: VooDataGrid<Map<String, dynamic>>(
                  controller: controller,
                  displayMode: VooDataGridDisplayMode.table,
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byType(VooDataGridHeader), findsOneWidget);

        // Test mobile layout
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 400,
                height: 600,
                child: VooDataGrid<Map<String, dynamic>>(
                  controller: controller,
                  displayMode: VooDataGridDisplayMode.cards,
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        // Cards view should be shown on mobile
        expect(find.byType(DataGridCardView), findsOneWidget);
      });
    });
  });
}
