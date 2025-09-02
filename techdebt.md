# Technical Debt - VooDataGrid Package

## Overview
This document outlines all technical debt and violations of the development standards defined in `rules.md` for the `voo_data_grid` package. The package currently has significant architectural and code quality issues that need to be addressed.

## Critical Violations

### 1. Atomic Design Pattern Violations ⚠️ CRITICAL

#### Missing Atomic Structure
- **Issue**: The package lacks proper atomic design organization
- **Current State**: Only has an `organisms` folder, missing `atoms` and `molecules`
- **Required Structure**:
  ```
  lib/src/presentation/widgets/
  ├── atoms/       # ❌ MISSING - Basic UI elements
  ├── molecules/   # ❌ MISSING - Simple component groups  
  └── organisms/   # ✅ EXISTS - Complex component sections
  ```

#### Widget Method Violations (Rule 4.4.3)
- **Issue**: Extensive use of `_buildXXX` methods that return widgets
- **Violation**: "No _buildXXX methods: DO NOT use methods like _buildSwitchField that return widgets"
- **Files Affected**:
  - `data_grid.dart`: Contains 26+ `_build` methods:
    - `_buildResponsiveToolbar()`
    - `_buildCardView()`
    - `_buildGridContent()`
    - `_buildDataRows()`
    - `_buildFilterChips()`
    - `_buildFilterField()`
    - `_buildTextFilter()`
    - `_buildNumberFilter()`
    - `_buildDateFilter()`
    - `_buildDropdownFilter()`
    - `_buildMultiSelectFilter()`
    - `_buildCheckboxFilter()`
    - And 14+ more...
  - `advanced_filter_widget.dart`: Contains multiple `_build` methods:
    - `_buildHeader()`
    - `_buildFilterList()`
    - `_buildFilterRow()`
    - `_buildAddFilterButton()`

### 2. Single Responsibility Violations ⚠️ CRITICAL

#### Massive File Sizes
- **Issue**: Files violate single responsibility with excessive line counts
- **Violations**:
  - `data_grid.dart`: **1,270 lines** (handles rendering, filtering, pagination, responsive layout, card view, table view, mobile sheet, etc.)
  - `data_grid_request_builder.dart`: **1,241 lines** (handles all API standards in one file)
  - `previews.dart`: **1,108 lines** 
  - `voo_data_grid_stateless.dart`: **933 lines**
  - `data_grid_filter.dart`: **818 lines**

#### Recommended Maximum: ~200-300 lines per file for widgets

### 3. One Class Per File Violations

- **Issue**: Multiple classes/widgets likely combined in single files
- **Impact**: Violates rule 4.4.2 "One class per file: Each class should be in its own file"
- **Benefits Lost**:
  - Harder to find specific components
  - Increased merge conflicts
  - Reduced code maintainability

### 4. Missing Component Separation

#### Components That Should Be Separate Files:
Based on the `_build` methods, these should be individual widget classes:

**Atoms (Basic UI Elements)**:
- `FilterChip`
- `SortIndicator`
- `PaginationButton`
- `RefreshButton`
- `FilterToggleButton`
- `ViewModeToggle`

**Molecules (Simple Component Groups)**:
- `DataGridToolbar`
- `DataGridPaginationBar`
- `FilterInputField`
- `TextFilterField`
- `NumberFilterField`
- `DateFilterField`
- `DropdownFilterField`
- `MultiSelectFilterField`
- `CheckboxFilterField`
- `DataGridCardItem`
- `DataGridHeaderCell`
- `DataGridDataCell`
- `FilterChipList`
- `MobileFilterSheet`

**Organisms (Complex Component Sections)**:
- `ResponsiveToolbar`
- `DataGridTableView`
- `DataGridCardView`
- `DataGridFilterRow`
- `DataGridHeaderRow`
- `DataGridBodySection`

### 5. Architecture Layer Violations

- **Issue**: Presentation layer contains business logic
- **Examples**:
  - Filter logic embedded in widgets
  - Pagination calculations in UI components
  - API request building logic mixed with UI

### 6. Testing Coverage Issues

- **Issue**: While tests exist, the monolithic structure makes testing difficult
- **Impact**: Hard to unit test individual components when they're embedded as methods

## Impact Assessment

### High Priority (Must Fix)
1. **Atomic Design Structure**: Complete absence of atoms/molecules folders
2. **Widget Methods**: 30+ `_build` methods across multiple files
3. **File Size**: Multiple files exceeding 1000 lines

### Medium Priority (Should Fix)
1. **Component Separation**: Dozens of components need extraction
2. **Business Logic in UI**: Filter/sort logic in presentation layer
3. **Code Organization**: Related components scattered across large files

### Low Priority (Nice to Have)
1. **Documentation**: Component documentation after refactoring
2. **Example Updates**: Update examples to use new atomic components

## Recommended Action Plan

### Phase 1: Create Atomic Structure
1. Create `atoms/` and `molecules/` folders
2. Set up proper folder hierarchy

### Phase 2: Extract Atoms (Smallest Components)
1. Extract basic UI elements from `_build` methods
2. Create individual files for each atom
3. Ensure each follows widget class pattern

### Phase 3: Extract Molecules (Component Groups)
1. Extract composite components
2. Compose molecules from atoms
3. Remove corresponding `_build` methods

### Phase 4: Refactor Organisms
1. Update existing organisms to use new atoms/molecules
2. Remove all remaining `_build` methods
3. Ensure clean composition

### Phase 5: Split Large Files
1. Break down `data_grid.dart` into multiple focused files
2. Separate concerns (layout, filtering, pagination, etc.)
3. Ensure each file has single responsibility

### Phase 6: Clean Architecture Compliance
1. Move business logic to domain layer
2. Create proper use cases
3. Ensure presentation layer only handles UI

## Estimated Effort

- **Total Components to Extract**: ~40-50 widgets
- **Files to Refactor**: 5-7 major files
- **Estimated Time**: 2-3 weeks for complete refactoring
- **Risk Level**: High (extensive changes to core package)

## Migration Strategy

1. **Incremental Approach**: Refactor one component type at a time
2. **Maintain Backward Compatibility**: Keep existing API surface
3. **Parallel Development**: Create new structure alongside old
4. **Gradual Deprecation**: Mark old patterns as deprecated
5. **Testing**: Ensure comprehensive tests for each new component

## Success Metrics

- [ ] Zero `_build` methods returning widgets
- [ ] All widget files under 300 lines
- [x] Complete atomic design structure (atoms/molecules/organisms) ✅
- [x] One class per file (for new components) ✅
- [ ] 80%+ test coverage
- [ ] Clean architecture layer separation
- [ ] No business logic in presentation layer

## Progress Update (Latest Session)

### ✅ Completed Phase 1
1. **Created Atomic Design Structure**
   - Created `atoms/` folder with 7 atomic components
   - Created `molecules/` folder with 11 molecule components
   - Created new `organisms/` components for complex sections
   - Existing `organisms/` folder maintained

2. **Extracted Atoms (Basic UI Elements)**
   - `FilterChipAtom` - Basic filter chip display
   - `ClearAllChipAtom` - Clear all filters action chip
   - `SortIndicatorAtom` - Column sort direction indicator
   - `PaginationButtonAtom` - Navigation button for pagination
   - `PageIndicatorAtom` - Current page display
   - `ToolbarButtonAtom` - Toolbar action buttons with badge support
   - `ViewModeToggleAtom` - Toggle between table/card views

3. **Extracted Molecules (Composite Components)**
   - `TextFilterFieldMolecule` - Text input filtering
   - `NumberFilterFieldMolecule` - Numeric input filtering
   - `DateFilterFieldMolecule` - Date picker filtering
   - `DropdownFilterFieldMolecule` - Dropdown selection filtering
   - `CheckboxFilterFieldMolecule` - Boolean filtering
   - `FilterChipListMolecule` - List of active filter chips
   - `DataGridToolbarMolecule` - Complete toolbar with actions
   - `DataGridHeaderCellMolecule` - Table header cells
   - `PaginationControlsMolecule` - Full pagination controls
   - `AdvancedFilterHeaderMolecule` - Advanced filter header with logic toggle
   - `AdvancedFilterRowMolecule` - Complex filter row configuration

4. **Extracted Organisms (Complex Sections)**
   - `DataGridCardViewOrganism` - Complete card view display logic
   - `DataGridTableViewOrganism` - Complete table view display logic
   - `MobileFilterSheetOrganism` - Mobile filter sheet implementation

5. **Created Barrel Exports**
   - `atoms/atoms.dart` - Export all atoms
   - `molecules/molecules.dart` - Export all molecules

### ✅ Completed Phase 2
1. **Refactored Main Components**
   - ✅ Updated `data_grid.dart` to use new atomic components
   - ✅ Removed ALL _build methods from `data_grid.dart`
   - ✅ Updated `advanced_filter_widget.dart` to remove _build methods
   - ✅ Extracted card view logic to separate organism
   - ✅ Extracted table view logic to separate organism
   - ✅ Extracted mobile filter sheet to separate organism

2. **Removed _build Method Violations**
   - ✅ Eliminated 26+ _build methods from `data_grid.dart`
   - ✅ Eliminated 5+ _build methods from `advanced_filter_widget.dart`
   - ✅ Replaced with proper widget classes and inline components

### 🚧 Remaining Work
1. **Additional Refactoring**
   - Remove _build methods from remaining files:
     - `data_grid_header.dart` (4 _build methods)
     - `data_grid_row.dart` (2 _build methods)
     - `optimized_data_grid_row.dart` (2 _build methods)
     - `data_grid_toolbar_molecule.dart` (2 _build methods)
     - `data_grid_header_cell_molecule.dart` (1 _build method)
     - `advanced_filter_row_molecule.dart` (2 _build methods)

2. **Split Large Files**
   - `data_grid.dart` reduced but still needs further splitting
   - `data_grid_request_builder.dart` (1,241 lines) needs refactoring
   - `voo_data_grid_stateless.dart` (933 lines) needs splitting

3. **Testing**
   - Fix compilation errors in tests
   - Add unit tests for all new components
   - Ensure existing tests still pass

## References

- [rules.md](./rules.md) - Development standards being violated
- [CLAUDE.md](./CLAUDE.md) - AI assistant guidelines mentioning these requirements

## Notes

This technical debt significantly impacts:
- **Developer Experience**: Hard to find and modify components
- **Maintainability**: Difficult to make changes without breaking things  
- **Testing**: Complex to test monolithic components
- **Performance**: Potential unnecessary rebuilds with large widgets
- **Code Review**: Large files make reviews difficult
- **Onboarding**: New developers struggle to understand structure

**Priority**: This should be addressed before adding new features to prevent further technical debt accumulation.