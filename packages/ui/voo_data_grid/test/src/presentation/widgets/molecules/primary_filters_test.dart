import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

void main() {
  group('PrimaryFilterButton', () {
    testWidgets('displays label correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryFilterButton(label: 'Test Filter', isSelected: false, onPressed: () {}),
          ),
        ),
      );

      expect(find.text('Test Filter'), findsOneWidget);
    });

    testWidgets('displays icon when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryFilterButton(label: 'Test Filter', icon: Icons.filter_list, isSelected: false, onPressed: () {}),
          ),
        ),
      );

      expect(find.byIcon(Icons.filter_list), findsOneWidget);
    });

    testWidgets('displays count badge when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryFilterButton(label: 'Test Filter', count: 42, isSelected: false, onPressed: () {}),
          ),
        ),
      );

      expect(find.text('42'), findsOneWidget);
    });

    testWidgets('changes appearance when selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: const ColorScheme.light(primary: Colors.blue, primaryContainer: Colors.lightBlue),
          ),
          home: Scaffold(
            body: Column(
              children: [
                PrimaryFilterButton(label: 'Selected', isSelected: true, onPressed: () {}),
                PrimaryFilterButton(label: 'Not Selected', isSelected: false, onPressed: () {}),
              ],
            ),
          ),
        ),
      );

      // Both buttons should be visible
      expect(find.text('Selected'), findsOneWidget);
      expect(find.text('Not Selected'), findsOneWidget);

      // Check that selected button has different styling
      // Find the Container widget within the PrimaryFilterButton
      final selectedButtonFinder = find.descendant(
        of: find.ancestor(of: find.text('Selected'), matching: find.byType(PrimaryFilterButton)),
        matching: find.byType(Container),
      );

      final unselectedButtonFinder = find.descendant(
        of: find.ancestor(of: find.text('Not Selected'), matching: find.byType(PrimaryFilterButton)),
        matching: find.byType(Container),
      );

      // Get the first Container (which has the decoration)
      final selectedButton = tester.widget<Container>(selectedButtonFinder.first);
      final unselectedButton = tester.widget<Container>(unselectedButtonFinder.first);

      // Check decoration differences
      final selectedDecoration = selectedButton.decoration as BoxDecoration?;
      final unselectedDecoration = unselectedButton.decoration as BoxDecoration?;

      expect(selectedDecoration?.color, isNot(equals(unselectedDecoration?.color)));
    });

    testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryFilterButton(
              label: 'Test Filter',
              isSelected: false,
              onPressed: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Test Filter'));
      expect(wasPressed, isTrue);
    });
  });

  group('PrimaryFiltersBar', () {
    final testFilters = [
      const PrimaryFilter(
        field: 'field1',
        label: 'Filter 1',
        icon: Icons.filter_1,
        count: 10,
        filter: VooDataFilter(operator: VooFilterOperator.equals, value: 'value1'),
      ),
      const PrimaryFilter(
        field: 'field2',
        label: 'Filter 2',
        icon: Icons.filter_2,
        count: 20,
        filter: VooDataFilter(operator: VooFilterOperator.equals, value: 'value2'),
      ),
      const PrimaryFilter(
        field: 'field3',
        label: 'Filter 3',
        icon: Icons.filter_3,
        count: 30,
        filter: VooDataFilter(operator: VooFilterOperator.equals, value: 'value3'),
      ),
    ];

    testWidgets('displays all filters', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryFiltersBar(filters: testFilters, onFilterChanged: (_, __) {}),
          ),
        ),
      );

      expect(find.text('Filter 1'), findsOneWidget);
      expect(find.text('Filter 2'), findsOneWidget);
      expect(find.text('Filter 3'), findsOneWidget);
    });

    testWidgets('displays "All" option when showAllOption is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryFiltersBar(filters: testFilters, allOptionLabel: 'All Items', onFilterChanged: (_, __) {}),
          ),
        ),
      );

      expect(find.text('All Items'), findsOneWidget);
    });

    testWidgets('hides "All" option when showAllOption is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryFiltersBar(filters: testFilters, showAllOption: false, onFilterChanged: (_, __) {}),
          ),
        ),
      );

      expect(find.text('All'), findsNothing);
    });

    testWidgets('highlights selected filter', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryFiltersBar(filters: testFilters, selectedFilter: testFilters[1].filter, onFilterChanged: (_, __) {}),
          ),
        ),
      );

      // Filter 2 should be selected
      final filter2Button = find.ancestor(of: find.text('Filter 2'), matching: find.byType(PrimaryFilterButton));

      final buttonWidget = tester.widget<PrimaryFilterButton>(filter2Button);
      expect(buttonWidget.isSelected, isTrue);
    });

    testWidgets('calls onFilterChanged when filter is tapped', (WidgetTester tester) async {
      String? selectedField;
      VooDataFilter? selectedFilter;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryFiltersBar(
              filters: testFilters,
              onFilterChanged: (field, filter) {
                selectedField = field;
                selectedFilter = filter;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Filter 2'));
      expect(selectedField, equals('field2'));
      expect(selectedFilter?.value, equals('value2'));

      await tester.tap(find.text('All'));
      expect(selectedField, equals('field1'));
      expect(selectedFilter, isNull);
    });

    testWidgets('scrolls horizontally when filters overflow', (WidgetTester tester) async {
      final manyFilters = List.generate(
        20,
        (index) => PrimaryFilter(
          field: 'field$index',
          label: 'Filter $index',
          filter: VooDataFilter(operator: VooFilterOperator.equals, value: 'value$index'),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300, // Constrain width to force scrolling
              child: PrimaryFiltersBar(filters: manyFilters, onFilterChanged: (_, __) {}),
            ),
          ),
        ),
      );

      // Check that ScrollView is present
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      // Check that first filter is visible initially
      expect(find.text('Filter 0'), findsOneWidget);

      // Simply verify that all filter items exist in the widget tree
      expect(find.text('Filter 19'), findsOneWidget);

      // Verify that the scroll view is scrollable (has overflow)
      final scrollView = tester.widget<SingleChildScrollView>(find.byType(SingleChildScrollView));
      expect(scrollView.scrollDirection, Axis.horizontal);

      // Test that we can scroll
      final scrollableState = tester.state<ScrollableState>(find.byType(Scrollable));
      final initialPosition = scrollableState.position.pixels;

      // Perform scroll gesture
      await tester.drag(find.byType(SingleChildScrollView), const Offset(-200, 0));
      await tester.pump();

      // Verify that scroll position changed
      final newPosition = scrollableState.position.pixels;
      expect(newPosition, greaterThan(initialPosition));
    });
  });

  group('VooDataGrid with Primary Filters', () {
    late VooDataGridController<Map<String, dynamic>> controller;
    late VooDataGridSource<Map<String, dynamic>> dataSource;

    setUp(() {
      dataSource = _TestDataSource();
      controller = VooDataGridController(
        dataSource: dataSource,
        columns: [
          VooDataColumn<Map<String, dynamic>>(field: 'id', label: 'ID', valueGetter: (row) => row['id']),
          VooDataColumn<Map<String, dynamic>>(field: 'status', label: 'Status', valueGetter: (row) => row['status']),
        ],
      );
    });

    testWidgets('shows primary filters when showPrimaryFilters is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDataGrid(
              controller: controller,
              showPrimaryFilters: true,
              primaryFilters: const [
                PrimaryFilter(
                  field: 'status',
                  label: 'Active',
                  filter: VooDataFilter(operator: VooFilterOperator.equals, value: 'active'),
                ),
                PrimaryFilter(
                  field: 'status',
                  label: 'Inactive',
                  filter: VooDataFilter(operator: VooFilterOperator.equals, value: 'inactive'),
                ),
              ],
              onFilterChanged: (_, __) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Inactive'), findsOneWidget);
    });

    testWidgets('hides primary filters when showPrimaryFilters is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDataGrid(
              controller: controller,
              primaryFilters: const [
                PrimaryFilter(
                  field: 'status',
                  label: 'Active',
                  filter: VooDataFilter(operator: VooFilterOperator.equals, value: 'active'),
                ),
              ],
              onFilterChanged: (_, __) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Active'), findsNothing);
    });

    testWidgets('calls onFilterChanged when filter is selected', (WidgetTester tester) async {
      String? selectedField;
      VooDataFilter? selectedFilter;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDataGrid(
              controller: controller,
              showPrimaryFilters: true,
              primaryFilters: const [
                PrimaryFilter(
                  field: 'status',
                  label: 'Active',
                  filter: VooDataFilter(operator: VooFilterOperator.equals, value: 'active'),
                ),
                PrimaryFilter(
                  field: 'status',
                  label: 'Inactive',
                  filter: VooDataFilter(operator: VooFilterOperator.equals, value: 'inactive'),
                ),
              ],
              onFilterChanged: (field, filter) {
                selectedField = field;
                selectedFilter = filter;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Active'));
      expect(selectedField, equals('status'));
      expect(selectedFilter?.value, equals('active'));

      await tester.tap(find.text('All'));
      expect(selectedField, equals('status'));
      expect(selectedFilter, isNull);
    });
  });

  group('VooDataGridStateless with Primary Filters', () {
    late List<VooDataColumn<Map<String, dynamic>>> columns;
    late VooDataGridState<Map<String, dynamic>> state;

    setUp(() {
      columns = [
        VooDataColumn<Map<String, dynamic>>(field: 'id', label: 'ID', valueGetter: (row) => row['id']),
        VooDataColumn<Map<String, dynamic>>(field: 'status', label: 'Status', valueGetter: (row) => row['status']),
      ];

      state = const VooDataGridState<Map<String, dynamic>>(
        rows: [
          {'id': 1, 'status': 'active'},
          {'id': 2, 'status': 'inactive'},
          {'id': 3, 'status': 'active'},
        ],
        totalRows: 3,
        pageSize: 10,
      );
    });

    testWidgets('shows primary filters in stateless widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDataGridStateless(
              state: state,
              columns: columns,
              showPrimaryFilters: true,
              primaryFilters: const [
                PrimaryFilter(
                  field: 'status',
                  label: 'Active',
                  filter: VooDataFilter(operator: VooFilterOperator.equals, value: 'active'),
                ),
                PrimaryFilter(
                  field: 'status',
                  label: 'Inactive',
                  filter: VooDataFilter(operator: VooFilterOperator.equals, value: 'inactive'),
                ),
              ],
              onFilterChanged: (_, __) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Inactive'), findsOneWidget);
    });

    testWidgets('integrates with state management', (WidgetTester tester) async {
      VooDataFilter? selectedFilter;
      final filteredState = state.copyWith(
        rows: [
          {'id': 1, 'status': 'active'},
          {'id': 3, 'status': 'active'},
        ],
        totalRows: 2,
      );

      const activeFilter = VooDataFilter(operator: VooFilterOperator.equals, value: 'active');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                final currentState = selectedFilter == activeFilter ? filteredState : state;

                return VooDataGridStateless(
                  state: currentState,
                  columns: columns,
                  showPrimaryFilters: true,
                  selectedPrimaryFilter: selectedFilter,
                  primaryFilters: const [
                    PrimaryFilter(field: 'status', label: 'Active', filter: activeFilter, count: 2),
                    PrimaryFilter(
                      field: 'status',
                      label: 'Inactive',
                      filter: VooDataFilter(operator: VooFilterOperator.equals, value: 'inactive'),
                      count: 1,
                    ),
                  ],
                  onFilterChanged: (field, filter) {
                    setState(() {
                      selectedFilter = filter;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initially shows all rows
      expect(state.rows.length, equals(3));

      // Tap on Active filter
      await tester.tap(find.text('Active'));
      await tester.pumpAndSettle();

      // Should now show filtered state
      expect(selectedFilter, equals(activeFilter));
    });
  });
}

// Test data source for testing
class _TestDataSource extends VooDataGridSource<Map<String, dynamic>> {
  _TestDataSource() : super(mode: VooDataGridMode.local) {
    setLocalData([
      {'id': 1, 'status': 'active'},
      {'id': 2, 'status': 'inactive'},
      {'id': 3, 'status': 'active'},
      {'id': 4, 'status': 'inactive'},
      {'id': 5, 'status': 'pending'},
    ]);
  }

  @override
  Future<VooDataGridResponse<Map<String, dynamic>>> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async => VooDataGridResponse<Map<String, dynamic>>(rows: [], totalRows: 0, page: page, pageSize: pageSize);
}
