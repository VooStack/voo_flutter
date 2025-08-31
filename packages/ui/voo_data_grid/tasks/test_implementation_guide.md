# Test Implementation Guide for voo_data_grid

## Quick Start Commands

### Phase 1: Setup (Execute First)
```bash
# Add test dependencies to pubspec.yaml
flutter pub add --dev mockito build_runner

# Create base test directory structure
mkdir -p test/{src/{data/{datasources,models,repositories},domain/{entities,repositories,usecases},presentation/{controllers,widgets/{atoms,molecules,organisms}},utils},integration,fixtures,helpers,mocks}

# Generate Mockito mocks (after creating mock specifications)
dart run build_runner build --delete-conflicting-outputs
```

## Current State Analysis
- **Total files to test**: 102
- **Data layer**: 16 files
- **Domain layer**: 17 files  
- **Presentation layer**: 67 files
- **Utils**: 2 files
- **Existing tests**: ~20 unorganized test files

## Implementation Steps

### Step 1: Add Test Dependencies
Add to `pubspec.yaml`:
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  mockito: ^5.4.4
  build_runner: ^2.4.0
  test: ^1.24.0
  golden_toolkit: ^0.15.0
```

### Step 2: Create Test Infrastructure Files

#### test/helpers/test_helpers.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget makeTestableWidget({
  required Widget child,
  ThemeData? theme,
}) {
  return MaterialApp(
    theme: theme ?? ThemeData.light(),
    home: Scaffold(body: child),
  );
}

Widget wrapWithMaterial(Widget widget) {
  return MaterialApp(
    home: Material(child: widget),
  );
}
```

#### test/fixtures/mock_data.dart
```dart
final testGridData = List.generate(100, (index) => {
  'id': index + 1,
  'name': 'Item ${index + 1}',
  'price': (index + 1) * 10.0,
  'status': index % 2 == 0 ? 'active' : 'inactive',
  'category': ['Electronics', 'Clothing', 'Food'][index % 3],
  'quantity': (index + 1) * 5,
  'date': DateTime.now().subtract(Duration(days: index)),
});

final testColumns = [
  // Define standard test columns
];
```

#### test/mocks/mock_repositories.dart
```dart
import 'package:mockito/annotations.dart';
import 'package:voo_data_grid/src/domain/repositories/voo_data_grid_repository.dart';
import 'package:voo_data_grid/src/data/datasources/voo_data_grid_datasource.dart';

@GenerateMocks([
  VooDataGridRepository,
  VooDataGridDatasource,
])
void main() {}
```

### Step 3: Migration Map for Existing Tests

| Current Test File | New Location | Type |
|------------------|--------------|------|
| test/voo_data_grid_test.dart | test/integration/exports_test.dart | Integration |
| test/data_grid_widget_test.dart | test/src/presentation/widgets/organisms/voo_data_grid_test.dart | Widget |
| test/atoms/pagination_button_test.dart | test/src/presentation/widgets/atoms/pagination_button_test.dart | Widget |
| test/molecules/text_filter_test.dart | test/src/presentation/widgets/molecules/text_filter_test.dart | Widget |
| test/data_grid_api_standards_test.dart | test/integration/api_standards_test.dart | Integration |
| test/odata_v4_compliance_test.dart | test/src/utils/odata_query_builder_test.dart | Unit |
| test/data_grid_request_builder_test.dart | test/src/data/models/voo_data_grid_request_test.dart | Unit |
| test/action_column_test.dart | test/src/presentation/widgets/molecules/action_column_test.dart | Widget |
| test/typed_column_test.dart | test/src/domain/entities/column_config_test.dart | Unit |
| test/primary_filters_test.dart | test/src/presentation/widgets/molecules/filter_bar_test.dart | Widget |

### Step 4: Test Template Examples

#### Unit Test Template (Domain Layer)
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/src/domain/entities/column_config.dart';

void main() {
  group('ColumnConfig', () {
    group('constructor', () {
      test('should create instance with required parameters', () {
        // Arrange
        const field = 'testField';
        const label = 'Test Label';
        
        // Act
        const column = ColumnConfig(
          field: field,
          label: label,
        );
        
        // Assert
        expect(column.field, equals(field));
        expect(column.label, equals(label));
      });
      
      test('should apply default values for optional parameters', () {
        // Test default values
      });
    });
    
    group('methods', () {
      test('should [expected behavior] when [condition]', () {
        // Test method behavior
      });
    });
  });
}
```

#### Widget Test Template
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/src/presentation/widgets/atoms/pagination_button.dart';
import '../../../helpers/test_helpers.dart';

void main() {
  group('PaginationButton', () {
    testWidgets('should render correctly with label', (tester) async {
      // Arrange
      const label = 'Next';
      var pressed = false;
      
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          child: PaginationButton(
            label: label,
            onPressed: () => pressed = true,
          ),
        ),
      );
      
      // Assert
      expect(find.text(label), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });
    
    testWidgets('should call onPressed when tapped', (tester) async {
      // Test interaction
    });
    
    testWidgets('should be disabled when onPressed is null', (tester) async {
      // Test disabled state
    });
  });
}
```

#### Repository Test Template with Mocks
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:voo_data_grid/src/data/repositories/voo_data_grid_repository_impl.dart';
import '../../../mocks/mock_repositories.mocks.dart';

void main() {
  late VooDataGridRepositoryImpl repository;
  late MockVooDataGridDatasource mockDatasource;
  
  setUp(() {
    mockDatasource = MockVooDataGridDatasource();
    repository = VooDataGridRepositoryImpl(datasource: mockDatasource);
  });
  
  group('VooDataGridRepositoryImpl', () {
    group('fetchData', () {
      test('should return data from datasource', () async {
        // Arrange
        final expectedData = VooDataGridResponse(/*...*/);
        when(mockDatasource.fetchData(any))
            .thenAnswer((_) async => expectedData);
        
        // Act
        final result = await repository.fetchData(/*...*/);
        
        // Assert
        expect(result, equals(expectedData));
        verify(mockDatasource.fetchData(any)).called(1);
      });
      
      test('should handle errors from datasource', () async {
        // Test error handling
      });
    });
  });
}
```

### Step 5: Priority Implementation Order

#### Week 1: Infrastructure & Migration
1. Add dependencies
2. Create directory structure  
3. Set up test helpers and fixtures
4. Configure Mockito
5. Migrate existing tests to new structure

#### Week 2: Domain & Data Layer Tests
1. Entity tests (17 files)
2. Repository interface tests
3. Use case tests
4. Data model tests (16 files)
5. Repository implementation tests

#### Week 3: Widget Tests (Atoms & Molecules)
1. Atom widget tests (~15 files)
2. Molecule widget tests (~25 files)
3. Form field widget tests
4. Filter widget tests

#### Week 4: Widget Tests (Organisms) & Integration
1. Organism widget tests (~27 files)
2. Controller tests
3. Integration test flows
4. Performance tests
5. Coverage analysis

### Step 6: Coverage Commands

```bash
# Run all tests with coverage
flutter test --coverage

# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html

# Open coverage report
open coverage/html/index.html

# Check specific coverage
lcov --list coverage/lcov.info
```

### Step 7: CI/CD Configuration

Add to `.github/workflows/test.yml`:
```yaml
name: Test voo_data_grid

on:
  push:
    paths:
      - 'packages/ui/voo_data_grid/**'
  pull_request:
    paths:
      - 'packages/ui/voo_data_grid/**'

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
        working-directory: packages/ui/voo_data_grid
      - run: flutter test --coverage
        working-directory: packages/ui/voo_data_grid
      - uses: codecov/codecov-action@v3
        with:
          files: packages/ui/voo_data_grid/coverage/lcov.info
```

## Success Metrics
- [ ] 80%+ overall test coverage
- [ ] 90%+ domain layer coverage
- [ ] All tests pass in < 30 seconds
- [ ] No flaky tests
- [ ] Clear test documentation
- [ ] Mockito properly integrated
- [ ] CI/CD pipeline active

## Common Issues & Solutions

### Issue: "Cannot find generator" for Mockito
**Solution**: Run `dart run build_runner build --delete-conflicting-outputs`

### Issue: Widget tests failing with "No MediaQuery found"
**Solution**: Use `makeTestableWidget` helper to wrap widgets

### Issue: Tests timing out
**Solution**: Check for missing `await` statements or infinite loops

### Issue: Coverage not improving
**Solution**: Focus on testing business logic, not getters/setters

## Next Steps
1. Start with Step 1: Add dependencies
2. Create basic structure (Step 2)
3. Begin migration (Step 3)
4. Implement tests layer by layer
5. Monitor coverage continuously