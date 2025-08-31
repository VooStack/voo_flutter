# VooDataGrid Test Suite

## Overview
Comprehensive test suite for the voo_data_grid package following clean architecture principles and rules.md requirements.

## Test Structure

The test directory mirrors the `lib/src` structure exactly as required by rules.md:

```
test/
├── src/
│   ├── data/                    # Data layer tests
│   │   ├── datasources/          # Datasource tests
│   │   ├── models/               # Model tests
│   │   └── repositories/         # Repository implementation tests
│   ├── domain/                   # Domain layer tests
│   │   ├── entities/             # Entity tests
│   │   ├── repositories/         # Repository interface tests
│   │   └── usecases/             # Use case tests
│   ├── presentation/             # Presentation layer tests
│   │   ├── controllers/          # Controller tests
│   │   └── widgets/              # Widget tests
│   │       ├── atoms/            # Atomic component tests
│   │       ├── molecules/        # Molecule component tests
│   │       └── organisms/        # Organism component tests
│   ├── adapters/                 # Adapter tests
│   └── utils/                    # Utility tests
├── integration/                  # Integration tests
├── fixtures/                     # Test data and fixtures
├── helpers/                      # Test helpers and utilities
└── mocks/                        # Mock objects for testing
```

## Test Categories

### Unit Tests
- **Domain Layer**: Business logic, entities, use cases
- **Data Layer**: Models, datasources, repository implementations
- **Utils**: Helper functions, formatters, builders

### Widget Tests
- **Atoms**: Basic UI elements (buttons, icons, chips)
- **Molecules**: Simple component groups (filters, controls)
- **Organisms**: Complex components (data grid, dialogs)

### Integration Tests
- End-to-end flows
- API standards compliance
- OData v4 compliance
- User interaction flows

## Running Tests

### All Tests
```bash
flutter test
```

### Specific Layer
```bash
# Domain layer tests
flutter test test/src/domain/

# Data layer tests
flutter test test/src/data/

# Widget tests
flutter test test/src/presentation/widgets/

# Integration tests
flutter test test/integration/
```

### Specific Category
```bash
# Atom widget tests
flutter test test/src/presentation/widgets/atoms/

# Model tests
flutter test test/src/data/models/
```

### With Coverage
```bash
# Generate coverage report
flutter test --coverage

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# View coverage
open coverage/html/index.html
```

## Test Dependencies

### Required Packages
- `flutter_test`: Core testing framework
- `test`: Additional test utilities
- `mockito`: Mock generation
- `build_runner`: Code generation
- `golden_toolkit`: Golden testing

### Setup
```bash
# Install dependencies
flutter pub get

# Generate mocks (if needed)
dart run build_runner build --delete-conflicting-outputs
```

## Test Helpers

### `test/helpers/test_helpers.dart`
- `makeTestableWidget()`: Wraps widgets with MaterialApp and Scaffold
- `wrapWithMaterial()`: Simple Material wrapper
- `pumpAndSettle()`: Helper for animations
- Various finder helpers

### `test/helpers/widget_test_helpers.dart`
- `TestDataGridSource`: Test implementation of data source
- `TestDataGridController`: Test controller
- Widget creation helpers
- Interaction helpers (tap, scroll, enter text)

### `test/fixtures/mock_data.dart`
- `testGridData`: 100 sample data rows
- `testColumns`: Standard column configurations
- Data builders for various scenarios
- Test factories for common objects

### `test/mocks/manual_mocks.dart`
- Manual mocks for generic classes
- `MockVooDataGridSource<T>`
- `MockDataGridController`
- Stub implementations

## Coverage Goals

| Layer | Target | Priority |
|-------|--------|----------|
| Domain (Business Logic) | 90%+ | High |
| Repository Implementations | 85%+ | High |
| Widgets | 80%+ | Medium |
| Controllers | 80%+ | Medium |
| Utils | 95%+ | Low |
| **Overall** | **80%+** | **Required** |

## Best Practices

### Test Structure
```dart
group('ClassName', () {
  group('methodName', () {
    test('should [expected behavior] when [condition]', () {
      // Arrange
      // Act
      // Assert
    });
  });
});
```

### Naming Conventions
- Test files: `{source_file}_test.dart`
- Test groups: Match class/method names
- Test descriptions: Clear behavior expectations

### Key Principles
1. **Single Assertion**: One logical assertion per test
2. **AAA Pattern**: Arrange, Act, Assert
3. **Independent Tests**: No inter-test dependencies
4. **Fast Execution**: Unit tests < 100ms
5. **Deterministic**: Same results every run
6. **No Side Effects**: Clean state between tests

## Common Commands

```bash
# Run tests matching a pattern
flutter test --name "VooDataFilter"

# Run tests with verbose output
flutter test -v

# Run specific test file
flutter test test/src/domain/entities/voo_data_filter_test.dart

# Watch mode (re-run on changes)
flutter test --watch
```

## Troubleshooting

### Issue: Tests timing out
- Check for missing `await` statements
- Look for infinite loops
- Increase timeout if needed: `timeout: Timeout(Duration(seconds: 10))`

### Issue: Widget tests failing
- Ensure proper widget wrapping with `makeTestableWidget()`
- Check for missing `pumpAndSettle()` after interactions
- Verify theme and MediaQuery availability

### Issue: Mock generation failing
- Run `dart run build_runner build --delete-conflicting-outputs`
- Check `@GenerateMocks` annotations
- Ensure classes aren't generic (manual mocks needed)

## Contributing

When adding new tests:
1. Follow the existing structure
2. Mirror the source file location
3. Use consistent naming
4. Include all test categories (unit, widget, integration)
5. Update coverage if below 80%
6. Run `flutter analyze` before committing