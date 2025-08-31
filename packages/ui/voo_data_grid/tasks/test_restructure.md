# Test Restructure Task Plan for voo_data_grid

## Overview
Complete test restructure to comply with rules.md requirements and clean architecture principles.

## Current Issues
- Test files scattered in root test/ directory without proper organization
- No clear separation between unit, widget, and integration tests
- Test files don't mirror lib/ structure as required
- Missing proper mocking setup using Mockito
- Test naming doesn't follow conventions

## Test Requirements (from rules.md)
- **Test coverage minimum**: 80% for business logic
- **Unit tests required**: For all repository implementations
- **Widget tests required**: For all custom widgets
- **Integration tests**: For critical user flows
- **Mock dependencies**: Use Mockito for dependency mocking
- **Test files**: Must end with `_test.dart` and mirror source structure

## Tasks

### Phase 1: Setup Test Infrastructure
- [ ] Create proper test directory structure mirroring lib/
- [ ] Set up test utilities and helpers directory
- [ ] Configure Mockito for dependency mocking
- [ ] Create shared test fixtures and data builders
- [ ] Set up coverage configuration

### Phase 2: Create Test Directory Structure
```
test/
├── src/
│   ├── data/
│   │   ├── datasources/
│   │   │   └── voo_data_grid_datasource_test.dart
│   │   ├── models/
│   │   │   ├── voo_data_filter_test.dart
│   │   │   ├── voo_data_grid_request_test.dart
│   │   │   ├── voo_data_grid_response_test.dart
│   │   │   └── voo_sorting_test.dart
│   │   └── repositories/
│   │       └── voo_data_grid_repository_impl_test.dart
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── column_config_test.dart
│   │   │   ├── data_grid_state_test.dart
│   │   │   └── filter_config_test.dart
│   │   ├── repositories/
│   │   │   └── voo_data_grid_repository_test.dart
│   │   └── usecases/
│   │       ├── fetch_data_test.dart
│   │       ├── apply_filters_test.dart
│   │       └── export_data_test.dart
│   ├── presentation/
│   │   ├── controllers/
│   │   │   ├── data_grid_controller_test.dart
│   │   │   └── filter_controller_test.dart
│   │   └── widgets/
│   │       ├── atoms/
│   │       │   ├── action_button_test.dart
│   │       │   ├── checkbox_test.dart
│   │       │   ├── column_header_test.dart
│   │       │   ├── data_cell_test.dart
│   │       │   ├── filter_chip_test.dart
│   │       │   ├── loading_indicator_test.dart
│   │       │   ├── pagination_button_test.dart
│   │       │   └── sort_icon_test.dart
│   │       ├── molecules/
│   │       │   ├── action_column_test.dart
│   │       │   ├── date_filter_test.dart
│   │       │   ├── date_range_filter_test.dart
│   │       │   ├── export_menu_test.dart
│   │       │   ├── filter_bar_test.dart
│   │       │   ├── filter_input_test.dart
│   │       │   ├── multi_select_filter_test.dart
│   │       │   ├── number_filter_test.dart
│   │       │   ├── number_range_filter_test.dart
│   │       │   ├── operator_selector_test.dart
│   │       │   ├── pagination_controls_test.dart
│   │       │   ├── search_bar_test.dart
│   │       │   └── text_filter_test.dart
│   │       └── organisms/
│   │           ├── data_grid_core_organism_test.dart
│   │           ├── data_grid_header_test.dart
│   │           ├── data_grid_body_test.dart
│   │           ├── data_grid_footer_test.dart
│   │           └── filter_dialog_test.dart
│   ├── adapters/
│   │   └── odata_adapter_test.dart
│   └── utils/
│       ├── date_formatter_test.dart
│       ├── filter_builder_test.dart
│       └── odata_query_builder_test.dart
├── integration/
│   ├── data_grid_flow_test.dart
│   ├── filter_flow_test.dart
│   ├── export_flow_test.dart
│   ├── pagination_flow_test.dart
│   └── sorting_flow_test.dart
├── fixtures/
│   ├── mock_data.dart
│   ├── test_data_builders.dart
│   └── test_constants.dart
├── helpers/
│   ├── test_helpers.dart
│   ├── widget_test_helpers.dart
│   └── mock_generators.dart
└── mocks/
    ├── mock_repositories.dart
    ├── mock_datasources.dart
    └── mock_controllers.dart
```

### Phase 3: Migrate Existing Tests
- [ ] Analyze each existing test file
- [ ] Categorize tests (unit/widget/integration)
- [ ] Move tests to appropriate directories
- [ ] Rename tests to follow conventions
- [ ] Update imports to use absolute paths

### Phase 4: Write Missing Unit Tests

#### Data Layer Tests
- [ ] Write tests for VooDataGridDatasource
- [ ] Write tests for all models (serialization/deserialization)
- [ ] Write tests for VooDataGridRepositoryImpl
- [ ] Ensure proper mocking of external dependencies

#### Domain Layer Tests
- [ ] Write tests for all entities
- [ ] Write tests for repository interfaces (contracts)
- [ ] Write tests for all use cases
- [ ] Test business logic isolation

#### Utils Tests
- [ ] Write tests for DateFormatter
- [ ] Write tests for FilterBuilder
- [ ] Write tests for ODataQueryBuilder
- [ ] Write tests for all utility functions

### Phase 5: Write Missing Widget Tests

#### Atoms Tests
- [ ] Test ActionButton widget
- [ ] Test Checkbox widget
- [ ] Test ColumnHeader widget
- [ ] Test DataCell widget
- [ ] Test FilterChip widget
- [ ] Test LoadingIndicator widget
- [ ] Test PaginationButton widget
- [ ] Test SortIcon widget

#### Molecules Tests
- [ ] Test ActionColumn widget
- [ ] Test all filter widgets (date, number, text, etc.)
- [ ] Test ExportMenu widget
- [ ] Test FilterBar widget
- [ ] Test PaginationControls widget
- [ ] Test SearchBar widget

#### Organisms Tests
- [ ] Test DataGridCoreOrganism widget
- [ ] Test DataGridHeader widget
- [ ] Test DataGridBody widget
- [ ] Test DataGridFooter widget
- [ ] Test FilterDialog widget

### Phase 6: Write Integration Tests
- [ ] Complete data grid flow (load, display, interact)
- [ ] Filter application and clearing flow
- [ ] Export functionality flow
- [ ] Pagination navigation flow
- [ ] Sorting behavior flow
- [ ] Error handling scenarios
- [ ] Loading states flow

### Phase 7: Test Quality Improvements
- [ ] Implement proper setUp and tearDown methods
- [ ] Create reusable test widgets
- [ ] Add golden tests for UI components
- [ ] Implement performance tests for large datasets
- [ ] Add edge case tests

### Phase 8: Coverage and Documentation
- [ ] Run coverage report
- [ ] Ensure 80% minimum coverage for business logic
- [ ] Document test patterns and best practices
- [ ] Create test README with running instructions
- [ ] Set up CI/CD test pipeline

## Test Naming Conventions
- File: `{source_file_name}_test.dart`
- Test groups: `group('ClassName', () { ... })`
- Test cases: `test('should [expected behavior] when [condition]', () { ... })`
- Widget tests: `testWidgets('should [render/behave] when [condition]', (tester) async { ... })`

## Mock Setup Requirements
- Use `@GenerateMocks` annotation for Mockito
- Create mock classes for all external dependencies
- Use `when().thenReturn()` for stubbing
- Use `verify()` for interaction testing
- Avoid over-mocking, test real implementations when possible

## Coverage Goals
- **Business Logic (Domain Layer)**: 90%+
- **Repository Implementations**: 85%+
- **Widgets**: 80%+
- **Controllers**: 80%+
- **Utils**: 95%+
- **Overall**: 80%+ minimum

## Testing Best Practices
1. **Arrange-Act-Assert Pattern**: Structure all tests clearly
2. **Single Assertion**: One logical assertion per test
3. **Descriptive Names**: Test names should document behavior
4. **Independent Tests**: No test should depend on another
5. **Fast Tests**: Unit tests should run in milliseconds
6. **Deterministic**: Tests should always produce same results
7. **No Side Effects**: Tests shouldn't affect external systems

## Priority Order
1. **High Priority**: Domain layer tests (business logic)
2. **High Priority**: Repository implementation tests
3. **Medium Priority**: Widget tests for organisms
4. **Medium Priority**: Integration tests for critical flows
5. **Low Priority**: Widget tests for atoms
6. **Low Priority**: Utility function tests

## Success Criteria
- [ ] All tests follow the file structure convention
- [ ] Test files mirror lib/ structure exactly
- [ ] All test files use `_test.dart` suffix
- [ ] No relative imports in test files
- [ ] Mockito properly configured and used
- [ ] 80%+ code coverage achieved
- [ ] All tests passing
- [ ] Tests run in under 30 seconds
- [ ] Clear test documentation
- [ ] CI/CD pipeline configured

## Notes
- Start with high-value tests that cover critical business logic
- Focus on testing behavior, not implementation details
- Keep tests maintainable and readable
- Update tests when refactoring code
- Use test-driven development for new features