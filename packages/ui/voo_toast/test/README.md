# VooToast Test Suite

Comprehensive test coverage for the VooToast package following clean architecture principles.

## Test Structure

```
test/
├── domain/                 # Domain layer tests
│   ├── entities/           # Entity tests
│   │   ├── toast_test.dart
│   │   └── toast_config_test.dart
│   └── enums/              # Enum tests
│       ├── toast_type_test.dart
│       ├── toast_position_test.dart
│       └── toast_animation_test.dart
├── data/                   # Data layer tests
│   └── repositories/       # Repository tests
│       └── toast_repository_impl_test.dart
├── presentation/           # Presentation layer tests
│   ├── state/              # State management tests
│   │   └── voo_toast_controller_test.dart
│   └── widgets/            # Widget tests
│       ├── molecules/
│       │   └── voo_toast_card_test.dart
│       └── organisms/
│           └── voo_toast_overlay_test.dart
├── integration/            # Integration tests
│   └── toast_integration_test.dart
└── all_tests.dart          # Test runner
```

## Running Tests

### Run all tests:
```bash
flutter test
```

### Run specific layer tests:
```bash
# Domain layer tests
flutter test test/domain/

# Data layer tests
flutter test test/data/

# Presentation layer tests
flutter test test/presentation/

# Integration tests
flutter test test/integration/
```

### Run specific test files:
```bash
# Entity tests
flutter test test/domain/entities/toast_test.dart

# Controller tests
flutter test test/presentation/state/voo_toast_controller_test.dart

# Widget tests
flutter test test/presentation/widgets/
```

### Run with coverage:
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Test Categories

### Domain Layer Tests
- **Entity Tests**: Validate Toast and ToastConfig entities, including equality, copyWith, and property validation
- **Enum Tests**: Ensure all enum values are correctly defined and behave as expected

### Data Layer Tests
- **Repository Tests**: Test the toast repository implementation, including adding, removing, and streaming toasts

### Presentation Layer Tests
- **State Management Tests**: Test VooToastController functionality, including singleton pattern, toast operations, and configuration
- **Widget Tests**: Test individual widgets (VooToastCard, VooToastOverlay) for rendering and behavior

### Integration Tests
- **Full Flow Tests**: Test complete user flows including showing, dismissing, and interacting with toasts

## Test Coverage Goals

- Domain Layer: 100% coverage
- Data Layer: 90% coverage
- Presentation Layer: 80% coverage
- Overall: 85% coverage

## Writing New Tests

When adding new features or fixing bugs:

1. Write tests first (TDD approach)
2. Follow the existing test structure
3. Place tests in the appropriate layer directory
4. Use descriptive test names
5. Test both success and failure cases
6. Include edge cases and boundary conditions

## Test Utilities

Common test utilities and mocks can be added to:
- `test/utils/` - Test helpers and utilities
- `test/mocks/` - Mock objects for testing

## Continuous Integration

Tests are automatically run on:
- Pull requests
- Commits to main branch
- Release builds

Ensure all tests pass before merging PRs.