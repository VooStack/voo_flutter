# VooDataGrid Refactoring Guide

## Overview
This guide demonstrates how to refactor the remaining `_build` methods in the voo_data_grid package to use the new atomic design components.

## Atomic Design Structure Created
```
lib/src/presentation/widgets/
├── atoms/           ✅ Created with 7 components
├── molecules/       ✅ Created with 11 components  
└── organisms/       ✅ Existing
```

## Example Refactoring Pattern

### Before (Using _build methods):
```dart
class _VooDataGridState<T> extends State<VooDataGrid<T>> {
  Widget _buildFilterChips(VooDesignSystemData design) {
    final filters = widget.controller.dataSource.filters;
    if (filters.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(design.spacingSm),
      // ... decoration
      child: Wrap(
        children: [
          ...filters.entries.map((entry) {
            // Complex inline logic
            return InputChip(/*...*/);
          }),
          if (filters.length > 1)
            ActionChip(/*...*/),
        ],
      ),
    );
  }
}
```

### After (Using atomic components):
```dart
import 'package:voo_data_grid/src/presentation/widgets/molecules/molecules.dart';

class _VooDataGridState<T> extends State<VooDataGrid<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Replace _buildFilterChips() with:
        FilterChipListMolecule(
          filters: _prepareFilterChipData(),
          onFilterRemoved: (field) {
            widget.controller.dataSource.applyFilter(field, null);
          },
          onClearAll: widget.controller.dataSource.clearFilters,
        ),
      ],
    );
  }
  
  Map<String, FilterChipData> _prepareFilterChipData() {
    return Map.fromEntries(
      widget.controller.dataSource.filters.entries.map((entry) {
        final column = widget.controller.columns.firstWhere(
          (col) => col.field == entry.key,
        );
        final displayValue = column.valueFormatter?.call(entry.value.value) 
            ?? entry.value.value?.toString() ?? '';
        return MapEntry(
          entry.key,
          FilterChipData(
            label: column.label,
            value: entry.value.value,
            displayValue: displayValue,
          ),
        );
      }),
    );
  }
}
```

## Refactoring Steps for Each _build Method

### 1. _buildResponsiveToolbar → DataGridToolbarMolecule
```dart
// Replace:
_buildResponsiveToolbar(design, constraints.maxWidth)

// With:
DataGridToolbarMolecule(
  onRefresh: widget.controller.dataSource.refresh,
  onFilterToggle: widget.controller.toggleFilters,
  filtersVisible: widget.controller.showFilters,
  activeFilterCount: widget.controller.dataSource.filters.length,
  displayMode: _effectiveDisplayMode,
  onDisplayModeChanged: (mode) => setState(() => _userSelectedMode = mode),
  showViewModeToggle: _isMobile(constraints.maxWidth),
  additionalActions: widget.toolbarActions,
  isMobile: _isMobile(constraints.maxWidth),
  onShowMobileFilters: () => _showMobileFilterSheet(context),
)
```

### 2. _buildTextFilter → TextFilterFieldMolecule
```dart
// Replace:
_buildTextFilter(column)

// With:
TextFilterFieldMolecule(
  value: _tempFilters[column.field]?.toString(),
  onChanged: (value) {
    setState(() {
      _tempFilters[column.field] = value;
    });
  },
  hintText: column.filterHint ?? 'Enter ${column.label.toLowerCase()}...',
  label: column.label,
)
```

### 3. _buildNumberFilter → NumberFilterFieldMolecule
```dart
// Replace:
_buildNumberFilter(column)

// With:
NumberFilterFieldMolecule(
  value: _tempFilters[column.field] as num?,
  onChanged: (value) {
    setState(() {
      _tempFilters[column.field] = value;
    });
  },
  hintText: column.filterHint ?? 'Enter number...',
  label: column.label,
  allowDecimals: column.filterType == FilterType.decimal,
)
```

### 4. _buildDateFilter → DateFilterFieldMolecule
```dart
// Replace:
_buildDateFilter(column)

// With:
DateFilterFieldMolecule(
  value: _tempFilters[column.field] as DateTime?,
  onChanged: (date) {
    setState(() {
      _tempFilters[column.field] = date;
    });
  },
  hintText: column.filterHint ?? 'Select date...',
  label: column.label,
)
```

### 5. _buildDropdownFilter → DropdownFilterFieldMolecule
```dart
// Replace:
_buildDropdownFilter(column)

// With:
DropdownFilterFieldMolecule<dynamic>(
  value: _tempFilters[column.field],
  onChanged: (value) {
    setState(() {
      _tempFilters[column.field] = value;
    });
  },
  options: column.filterOptions ?? [],
  hintText: column.filterHint ?? 'Select ${column.label.toLowerCase()}...',
  label: column.label,
)
```

### 6. _buildCheckboxFilter → CheckboxFilterFieldMolecule
```dart
// Replace:
_buildCheckboxFilter(column)

// With:
CheckboxFilterFieldMolecule(
  value: _tempFilters[column.field] == true,
  onChanged: (value) {
    setState(() {
      _tempFilters[column.field] = value;
    });
  },
  label: column.filterHint ?? 'Enable',
)
```

### 7. _buildResponsivePagination → PaginationControlsMolecule
```dart
// Replace:
_buildResponsivePagination(constraints.maxWidth)

// With:
PaginationControlsMolecule(
  currentPage: widget.controller.dataSource.currentPage,
  totalPages: widget.controller.dataSource.totalPages,
  onPageChanged: (page) {
    widget.controller.dataSource.setPage(page);
  },
  showFirstLast: !_isMobile(constraints.maxWidth),
  showPageIndicator: true,
)
```

## Breaking Down Large Files

### Current data_grid.dart (1,270 lines) should be split into:

1. **voo_data_grid.dart** (Main widget, ~200 lines)
   - Just the main widget class and its state
   - Delegates to sub-components

2. **mobile_filter_sheet.dart** (New file, ~150 lines)
   - Extract _MobileFilterSheet class
   - Uses filter field molecules

3. **data_grid_layout.dart** (New file, ~200 lines)
   - Handles responsive layout logic
   - Table vs card view switching

4. **data_grid_filter_row.dart** (New file, ~150 lines)
   - Filter row implementation
   - Uses filter field molecules

5. **data_grid_card_item.dart** (New file, ~100 lines)
   - Card view item rendering
   - Extract from _buildCardView

## Benefits After Refactoring

1. **Testability**: Each component can be tested in isolation
2. **Reusability**: Atoms and molecules can be used elsewhere
3. **Maintainability**: Smaller, focused files are easier to maintain
4. **Performance**: Smaller widgets = more efficient rebuilds
5. **Discoverability**: Developers can easily find components
6. **Compliance**: Follows rules.md requirements

## Next Steps

1. Complete refactoring of data_grid.dart using this pattern
2. Split large files into smaller, focused components
3. Add unit tests for each new component
4. Update examples to use new components
5. Deprecate old patterns gradually

## Component Hierarchy

```
VooDataGrid (Organism)
├── DataGridToolbarMolecule
│   ├── ToolbarButtonAtom
│   ├── ViewModeToggleAtom
│   └── [Additional Actions]
├── FilterChipListMolecule
│   ├── FilterChipAtom (multiple)
│   └── ClearAllChipAtom
├── DataGridHeader (Organism)
│   └── DataGridHeaderCellMolecule (multiple)
│       └── SortIndicatorAtom
├── DataGridBody (Organism)
│   └── DataGridRow (multiple)
└── PaginationControlsMolecule
    ├── PaginationButtonAtom (multiple)
    └── PageIndicatorAtom
```

## Testing Strategy

For each new component:
```dart
// Example test for FilterChipAtom
testWidgets('FilterChipAtom displays label and value', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: FilterChipAtom(
          label: 'Status',
          value: 'Active',
          onDeleted: () {},
        ),
      ),
    ),
  );
  
  expect(find.text('Status: Active'), findsOneWidget);
  expect(find.byIcon(Icons.close), findsOneWidget);
});
```

## Migration Checklist

- [x] Create atoms/ and molecules/ folders
- [x] Extract 7 atom components
- [x] Extract 11 molecule components
- [x] Create barrel export files
- [ ] Refactor data_grid.dart to use new components
- [ ] Split data_grid.dart into multiple files
- [ ] Add comprehensive tests
- [ ] Update documentation
- [ ] Mark old patterns as deprecated
- [ ] Update examples

## Estimated Completion

- **Completed**: 60% (structure and components created)
- **Remaining**: 40% (integration and testing)
- **Time Estimate**: 1-2 days for full refactoring