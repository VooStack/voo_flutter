import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

void main() {
  group('PrimaryFilterButton', () {
    testWidgets('displays label correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryFilterButton(
              label: 'Test Filter',
              isSelected: false,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Filter'), findsOneWidget);
    });

    testWidgets('displays icon when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryFilterButton(
              label: 'Test Filter',
              icon: Icons.filter_list,
              isSelected: false,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.filter_list), findsOneWidget);
    });

    testWidgets('displays count badge when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryFilterButton(
              label: 'Test Filter',
              count: 42,
              isSelected: false,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('42'), findsOneWidget);
    });

    testWidgets('changes appearance when selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              primaryContainer: Colors.lightBlue,
            ),
          ),
          home: Scaffold(
            body: Column(
              children: [
                PrimaryFilterButton(
                  label: 'Selected',
                  isSelected: true,
                  onPressed: () {},
                ),
                PrimaryFilterButton(
                  label: 'Not Selected',
                  isSelected: false,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      );

      // Both buttons should be visible
      expect(find.text('Selected'), findsOneWidget);
      expect(find.text('Not Selected'), findsOneWidget);

      // Check that selected button has different styling
      final selectedButton = tester.widget<Container>(
        find
            .descendant(
              of: find
                  .ancestor(
                    of: find.text('Selected'),
                    matching: find.byType(Container),
                  )
                  .first,
              matching: find.byType(Container),
            )
            .first,
      );

      final unselectedButton = tester.widget<Container>(
        find
            .descendant(
              of: find
                  .ancestor(
                    of: find.text('Not Selected'),
                    matching: find.byType(Container),
                  )
                  .first,
              matching: find.byType(Container),
            )
            .first,
      );

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
        id: 'filter1',
        label: 'Filter 1',
        icon: Icons.filter_1,
        count: 10,
        value: 'value1',
      ),
      const PrimaryFilter(
        id: 'filter2',
        label: 'Filter 2',
        icon: Icons.filter_2,
        count: 20,
        value: 'value2',
      ),
      const PrimaryFilter(
        id: 'filter3',
        label: 'Filter 3',
        icon: Icons.filter_3,
        count: 30,
        value: 'value3',
      ),
    ];

    testWidgets('displays all filters', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryFiltersBar(
              filters: testFilters,
              onFilterSelected: (_) {},
            ),
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
            body: PrimaryFiltersBar(
              filters: testFilters,
              allOptionLabel: 'All Items',
              onFilterSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('All Items'), findsOneWidget);
    });

    testWidgets('hides "All" option when showAllOption is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryFiltersBar(
              filters: testFilters,
              showAllOption: false,
              onFilterSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('All'), findsNothing);
    });

    testWidgets('highlights selected filter', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryFiltersBar(
              filters: testFilters,
              selectedFilterId: 'filter2',
              onFilterSelected: (_) {},
            ),
          ),
        ),
      );

      // Filter 2 should be selected
      final filter2Button = find.ancestor(
        of: find.text('Filter 2'),
        matching: find.byType(PrimaryFilterButton),
      );

      final buttonWidget = tester.widget<PrimaryFilterButton>(filter2Button);
      expect(buttonWidget.isSelected, isTrue);
    });

    testWidgets('calls onFilterSelected when filter is tapped', (WidgetTester tester) async {
      String? selectedId;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryFiltersBar(
              filters: testFilters,
              onFilterSelected: (id) {
                selectedId = id;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Filter 2'));
      expect(selectedId, equals('filter2'));

      await tester.tap(find.text('All'));
      expect(selectedId, isNull);
    });

    testWidgets('scrolls horizontally when filters overflow', (WidgetTester tester) async {
      final manyFilters = List.generate(
        20,
        (index) => PrimaryFilter(
          id: 'filter$index',
          label: 'Filter $index',
          value: 'value$index',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300, // Constrain width to force scrolling
              child: PrimaryFiltersBar(
                filters: manyFilters,
                onFilterSelected: (_) {},
              ),
            ),
          ),
        ),
      );

      // Check that ScrollView is present
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      // Check that not all filters are visible initially
      expect(find.text('Filter 0'), findsOneWidget);
      expect(find.text('Filter 19'), findsNothing);

      // Scroll to the end
      await tester.drag(find.byType(SingleChildScrollView), const Offset(-500, 0));
      await tester.pumpAndSettle();

      // Now the last filter should be visible
      expect(find.text('Filter 19'), findsOneWidget);
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
          VooDataColumn<Map<String, dynamic>>(
            field: 'id',
            label: 'ID',
            valueGetter: (row) => row['id'],
          ),
          VooDataColumn<Map<String, dynamic>>(
            field: 'status',
            label: 'Status',
            valueGetter: (row) => row['status'],
          ),
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
                  id: 'active',
                  label: 'Active',
                  value: 'active',
                ),
                PrimaryFilter(
                  id: 'inactive',
                  label: 'Inactive',
                  value: 'inactive',
                ),
              ],
              onPrimaryFilterSelected: (_) {},
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
                  id: 'active',
                  label: 'Active',
                  value: 'active',
                ),
              ],
              onPrimaryFilterSelected: (_) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Active'), findsNothing);
    });

    testWidgets('calls onPrimaryFilterSelected when filter is selected', (WidgetTester tester) async {
      String? selectedId;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDataGrid(
              controller: controller,
              showPrimaryFilters: true,
              primaryFilters: const [
                PrimaryFilter(
                  id: 'active',
                  label: 'Active',
                  value: 'active',
                ),
                PrimaryFilter(
                  id: 'inactive',
                  label: 'Inactive',
                  value: 'inactive',
                ),
              ],
              onPrimaryFilterSelected: (id) {
                selectedId = id;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Active'));
      expect(selectedId, equals('active'));

      await tester.tap(find.text('All'));
      expect(selectedId, isNull);
    });
  });

  group('VooDataGridStateless with Primary Filters', () {
    late List<VooDataColumn<Map<String, dynamic>>> columns;
    late VooDataGridState<Map<String, dynamic>> state;

    setUp(() {
      columns = [
        VooDataColumn<Map<String, dynamic>>(
          field: 'id',
          label: 'ID',
          valueGetter: (row) => row['id'],
        ),
        VooDataColumn<Map<String, dynamic>>(
          field: 'status',
          label: 'Status',
          valueGetter: (row) => row['status'],
        ),
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
                  id: 'active',
                  label: 'Active',
                  value: 'active',
                ),
                PrimaryFilter(
                  id: 'inactive',
                  label: 'Inactive',
                  value: 'inactive',
                ),
              ],
              onPrimaryFilterSelected: (_) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Inactive'), findsOneWidget);
    });

    testWidgets('integrates with state management', (WidgetTester tester) async {
      String? selectedFilterId;
      final filteredState = state.copyWith(
        rows: [
          {'id': 1, 'status': 'active'},
          {'id': 3, 'status': 'active'},
        ],
        totalRows: 2,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                final currentState = selectedFilterId == 'active' ? filteredState : state;

                return VooDataGridStateless(
                  state: currentState,
                  columns: columns,
                  showPrimaryFilters: true,
                  selectedPrimaryFilterId: selectedFilterId,
                  primaryFilters: const [
                    PrimaryFilter(
                      id: 'active',
                      label: 'Active',
                      value: 'active',
                      count: 2,
                    ),
                    PrimaryFilter(
                      id: 'inactive',
                      label: 'Inactive',
                      value: 'inactive',
                      count: 1,
                    ),
                  ],
                  onPrimaryFilterSelected: (id) {
                    setState(() {
                      selectedFilterId = id;
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
      expect(selectedFilterId, equals('active'));
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
  }) async =>
      VooDataGridResponse<Map<String, dynamic>>(
        rows: [],
        totalRows: 0,
        page: page,
        pageSize: pageSize,
      );
}
