import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/src/domain/entities/data_grid_column.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_column_type.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_filter.dart';
import 'package:voo_data_grid/src/domain/entities/voo_filter_operator.dart';
import 'package:voo_data_grid/src/domain/entities/voo_filter_option.dart';
import 'package:voo_data_grid/src/domain/entities/voo_filter_widget_type.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/multi_select_filter.dart';

void main() {
  group('MultiSelectFilter Widget Tests', () {
    late List<VooFilterOption> filterOptions;
    late VooDataColumn<Map<String, dynamic>> column;

    setUp(() {
      filterOptions = [
        const VooFilterOption(label: 'Admin', value: 'admin-id'),
        const VooFilterOption(label: 'User', value: 'user-id'),
        const VooFilterOption(label: 'Editor', value: 'editor-id'),
        const VooFilterOption(label: 'Viewer', value: 'viewer-id'),
      ];

      column = VooDataColumn<Map<String, dynamic>>(
        field: 'roles',
        label: 'Roles',
        dataType: VooDataColumnType.multiSelect,
        filterWidgetType: VooFilterWidgetType.multiSelect,
        filterOptions: filterOptions,
        filterHint: 'Select roles...',
      );
    });

    Widget buildTestWidget({
      VooDataFilter? currentFilter,
      required void Function(dynamic) onFilterChanged,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: MultiSelectFilter<Map<String, dynamic>>(
            column: column,
            currentFilter: currentFilter,
            onFilterChanged: onFilterChanged,
            getFilterOptions: (col) => col.filterOptions ?? [],
          ),
        ),
      );
    }

    group('Initial rendering', () {
      testWidgets('should display filter hint when no values selected', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            onFilterChanged: (_) {},
          ),
        );

        expect(find.text('Select roles...'), findsOneWidget);
        expect(find.text('selected'), findsNothing);
      });

      testWidgets('should display count when values are selected', (tester) async {
        final currentFilter = VooDataFilter(
          operator: VooFilterOperator.inList,
          value: ['admin-id', 'user-id'],
        );

        await tester.pumpWidget(
          buildTestWidget(
            currentFilter: currentFilter,
            onFilterChanged: (_) {},
          ),
        );

        expect(find.text('2 selected'), findsOneWidget);
        expect(find.text('Select roles...'), findsNothing);
      });

      testWidgets('should display dropdown icon', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            onFilterChanged: (_) {},
          ),
        );

        expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
      });
    });

    group('Popup menu interaction', () {
      testWidgets('should open popup menu when tapped', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            onFilterChanged: (_) {},
          ),
        );

        await tester.tap(find.text('Select roles...'));
        await tester.pumpAndSettle();

        // All filter options should be visible
        expect(find.text('Admin'), findsOneWidget);
        expect(find.text('User'), findsOneWidget);
        expect(find.text('Editor'), findsOneWidget);
        expect(find.text('Viewer'), findsOneWidget);
      });

      testWidgets('should show checkboxes for all options', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            onFilterChanged: (_) {},
          ),
        );

        await tester.tap(find.text('Select roles...'));
        await tester.pumpAndSettle();

        expect(find.byType(CheckboxListTile), findsNWidgets(4));
      });

      testWidgets('should show checked state for selected values', (tester) async {
        final currentFilter = VooDataFilter(
          operator: VooFilterOperator.inList,
          value: ['admin-id', 'editor-id'],
        );

        await tester.pumpWidget(
          buildTestWidget(
            currentFilter: currentFilter,
            onFilterChanged: (_) {},
          ),
        );

        await tester.tap(find.text('2 selected'));
        await tester.pumpAndSettle();

        // Find checkboxes by their state
        final checkboxes = tester.widgetList<CheckboxListTile>(find.byType(CheckboxListTile));
        final checkedCount = checkboxes.where((cb) => cb.value == true).length;

        expect(checkedCount, equals(2));
      });
    });

    group('Selection state management', () {
      testWidgets('should update selection when checkbox is tapped', (tester) async {
        dynamic capturedValue;
        int callCount = 0;

        await tester.pumpWidget(
          buildTestWidget(
            onFilterChanged: (value) {
              capturedValue = value;
              callCount++;
            },
          ),
        );

        // Open menu
        await tester.tap(find.text('Select roles...'));
        await tester.pumpAndSettle();

        // Tap Admin checkbox
        await tester.tap(find.ancestor(
          of: find.text('Admin'),
          matching: find.byType(CheckboxListTile),
        ));
        await tester.pumpAndSettle();

        expect(callCount, equals(1));
        expect(capturedValue, isA<List>());
        expect((capturedValue as List).contains('admin-id'), isTrue);
      });

      testWidgets('should add multiple selections', (tester) async {
        dynamic capturedValue;

        await tester.pumpWidget(
          buildTestWidget(
            onFilterChanged: (value) {
              capturedValue = value;
            },
          ),
        );

        await tester.tap(find.text('Select roles...'));
        await tester.pumpAndSettle();

        // Select Admin
        await tester.tap(find.ancestor(
          of: find.text('Admin'),
          matching: find.byType(CheckboxListTile),
        ));
        await tester.pumpAndSettle();

        // Select User
        await tester.tap(find.ancestor(
          of: find.text('User'),
          matching: find.byType(CheckboxListTile),
        ));
        await tester.pumpAndSettle();

        expect((capturedValue as List).length, equals(2));
        expect(capturedValue.contains('admin-id'), isTrue);
        expect(capturedValue.contains('user-id'), isTrue);
      });

      testWidgets('should remove selection when unchecking', (tester) async {
        final currentFilter = VooDataFilter(
          operator: VooFilterOperator.inList,
          value: ['admin-id', 'user-id'],
        );

        dynamic capturedValue;

        await tester.pumpWidget(
          buildTestWidget(
            currentFilter: currentFilter,
            onFilterChanged: (value) {
              capturedValue = value;
            },
          ),
        );

        await tester.tap(find.text('2 selected'));
        await tester.pumpAndSettle();

        // Uncheck Admin
        await tester.tap(find.ancestor(
          of: find.text('Admin'),
          matching: find.byType(CheckboxListTile),
        ));
        await tester.pumpAndSettle();

        expect((capturedValue as List).length, equals(1));
        expect(capturedValue.contains('user-id'), isTrue);
        expect(capturedValue.contains('admin-id'), isFalse);
      });

      testWidgets('should return null when all selections removed', (tester) async {
        final currentFilter = VooDataFilter(
          operator: VooFilterOperator.inList,
          value: ['admin-id'],
        );

        dynamic capturedValue = 'initial';

        await tester.pumpWidget(
          buildTestWidget(
            currentFilter: currentFilter,
            onFilterChanged: (value) {
              capturedValue = value;
            },
          ),
        );

        await tester.tap(find.text('1 selected'));
        await tester.pumpAndSettle();

        // Uncheck the only selected item
        await tester.tap(find.ancestor(
          of: find.text('Admin'),
          matching: find.byType(CheckboxListTile),
        ));
        await tester.pumpAndSettle();

        expect(capturedValue, isNull);
      });
    });

    group('State persistence', () {
      testWidgets('should maintain selection state after selections', (tester) async {
        List<dynamic>? lastValue;

        await tester.pumpWidget(
          buildTestWidget(
            onFilterChanged: (value) {
              lastValue = value as List<dynamic>?;
            },
          ),
        );

        // Open menu and select
        await tester.tap(find.text('Select roles...'));
        await tester.pumpAndSettle();

        await tester.tap(find.ancestor(
          of: find.text('Admin'),
          matching: find.byType(CheckboxListTile),
        ));
        await tester.pumpAndSettle();

        // Verify Admin was selected
        expect(lastValue, isNotNull);
        expect(lastValue!.contains('admin-id'), isTrue);
        expect(lastValue!.length, equals(1));
      });

      testWidgets('should update when currentFilter changes', (tester) async {
        final ValueNotifier<VooDataFilter?> filterNotifier = ValueNotifier(null);

        await tester.pumpWidget(
          ValueListenableBuilder<VooDataFilter?>(
            valueListenable: filterNotifier,
            builder: (context, filter, _) {
              return buildTestWidget(
                currentFilter: filter,
                onFilterChanged: (_) {},
              );
            },
          ),
        );

        // Initially no selection
        expect(find.text('Select roles...'), findsOneWidget);

        // Update filter from outside
        filterNotifier.value = VooDataFilter(
          operator: VooFilterOperator.inList,
          value: ['admin-id', 'user-id'],
        );
        await tester.pumpAndSettle();

        // Should show count
        expect(find.text('2 selected'), findsOneWidget);
      });
    });

    group('Edge cases', () {
      testWidgets('should handle empty filter options list', (tester) async {
        final emptyColumn = VooDataColumn<Map<String, dynamic>>(
          field: 'roles',
          label: 'Roles',
          filterOptions: [],
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MultiSelectFilter<Map<String, dynamic>>(
                column: emptyColumn,
                onFilterChanged: (_) {},
                getFilterOptions: (col) => col.filterOptions ?? [],
              ),
            ),
          ),
        );

        await tester.tap(find.text('Select...'));
        await tester.pumpAndSettle();

        // Should show empty menu
        expect(find.byType(CheckboxListTile), findsNothing);
      });

      testWidgets('should handle filter value that is not a list', (tester) async {
        final currentFilter = VooDataFilter(
          operator: VooFilterOperator.equals,
          value: 'single-value', // Not a list
        );

        await tester.pumpWidget(
          buildTestWidget(
            currentFilter: currentFilter,
            onFilterChanged: (_) {},
          ),
        );

        // Should show hint, treating non-list as empty
        expect(find.text('Select roles...'), findsOneWidget);
      });

      testWidgets('should handle rapid consecutive selections', (tester) async {
        final List<dynamic> capturedValues = [];

        await tester.pumpWidget(
          buildTestWidget(
            onFilterChanged: (value) {
              capturedValues.add(value);
            },
          ),
        );

        await tester.tap(find.text('Select roles...'));
        await tester.pumpAndSettle();

        // Rapidly select multiple items
        await tester.tap(find.ancestor(of: find.text('Admin'), matching: find.byType(CheckboxListTile)));
        await tester.pump();
        await tester.tap(find.ancestor(of: find.text('User'), matching: find.byType(CheckboxListTile)));
        await tester.pump();
        await tester.tap(find.ancestor(of: find.text('Editor'), matching: find.byType(CheckboxListTile)));
        await tester.pumpAndSettle();

        expect(capturedValues.length, equals(3));
        final lastValue = capturedValues.last as List;
        expect(lastValue.length, equals(3));
      });
    });

    group('Visual styling', () {
      testWidgets('should apply theme colors', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            ),
            home: Scaffold(
              body: MultiSelectFilter<Map<String, dynamic>>(
                column: column,
                onFilterChanged: (_) {},
                getFilterOptions: (col) => col.filterOptions ?? [],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Widget should render without errors
        expect(find.byType(MultiSelectFilter<Map<String, dynamic>>), findsOneWidget);
      });

      testWidgets('should show different text color for hint vs selected', (tester) async {
        // Test with no selection
        await tester.pumpWidget(
          buildTestWidget(
            onFilterChanged: (_) {},
          ),
        );

        final hintText = tester.widget<Text>(find.text('Select roles...'));
        final hintStyle = hintText.style;

        // Now test with selection
        final currentFilter = VooDataFilter(
          operator: VooFilterOperator.inList,
          value: ['admin-id'],
        );

        await tester.pumpWidget(
          buildTestWidget(
            currentFilter: currentFilter,
            onFilterChanged: (_) {},
          ),
        );

        final selectedText = tester.widget<Text>(find.text('1 selected'));
        final selectedStyle = selectedText.style;

        // Colors should be different (hint is typically more muted)
        expect(hintStyle?.color != selectedStyle?.color, isTrue);
      });
    });
  });
}