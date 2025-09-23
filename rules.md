# Development Rules for VooFlutter

## Core Development Principles

### 0. KISS (Keep It Simple, Stupid) - The Prime Directive
- **Simplicity above all else**: Every solution should be as simple as possible, but no simpler
- **Avoid over-engineering**: Don't add complexity for hypothetical future needs
- **Clear over clever**: Readable, maintainable code beats clever one-liners
- **When in doubt, choose the simpler approach**: If two solutions work, pick the simpler one

### 1. Planning & Task Management
- **Always plan before implementation**: Read relevant code, understand the context, create a detailed todo list
- **Use tasks/todo.md for tracking**: Document all planned changes with checkboxes
- **Get approval before major changes**: Present plan to maintainers before proceeding
- **Mark tasks as complete progressively**: Update status as work progresses, not in batches

### 2. Code Quality Standards
- **Simplicity is paramount**: Every change should be as minimal and simple as possible
- **Single Responsibility**: Each function/class should do one thing well
- **No massive changes**: Break large changes into small, reviewable commits
- **Clean Architecture compliance**: Strict separation of concerns across all layers
- **Zero lint issues policy**: Never commit code with lint warnings or errors
  - Run `flutter analyze` before every commit
  - Fix all warnings, not just errors
  - Use `flutter analyze --fatal-warnings` in CI/CD

### 3. Import & Module Rules
- **No relative imports**: Always use absolute imports from package root
- **Package imports first**: Order imports as dart, flutter, package, then local
- **Barrel exports**: Use index files for clean public APIs

### 4. Architecture Rules

#### Naming Conventions

##### File Naming Rules
- **Use snake_case**: All Dart files must use snake_case
  - ✅ `data_grid.dart`, `user_profile_widget.dart`
  - ❌ `DataGrid.dart`, `userProfileWidget.dart`
- **Match class names**: File names should match the primary class they contain
  - File `user_profile_widget.dart` contains class `UserProfileWidget`
- **Descriptive suffixes**: Use appropriate suffixes for clarity
  - Widgets: `_widget.dart` (e.g., `button_widget.dart`)
  - Screens/Pages: `_screen.dart` or `_page.dart`
  - Models: `_model.dart`
  - Services: `_service.dart`
  - Repositories: `_repository.dart`
  - Controllers: `_controller.dart`
  - Utils: `_utils.dart`
- **Test files**: Must end with `_test.dart` and mirror source structure
  - Source: `lib/src/widgets/button_widget.dart`
  - Test: `test/src/widgets/button_widget_test.dart`

##### Class Naming Rules
- **Use PascalCase**: All classes must use PascalCase
  - ✅ `UserProfileWidget`, `DataGridController`
  - ❌ `userProfileWidget`, `data_grid_controller`
- **Descriptive suffixes**: Clearly indicate the class purpose
  - Widgets: `*Widget` (e.g., `ButtonWidget`, `HeaderWidget`)
  - Stateless: `*Widget` (no special suffix needed)
  - Stateful: `*Widget` with `*State` for state class
  - Controllers: `*Controller`
  - Services: `*Service`
  - Repositories: `*Repository`
  - Models: `*Model` or just descriptive name (e.g., `User`, `Product`)
  - BLoCs: `*Bloc`
  - Cubits: `*Cubit`
- **Interface naming**: Prefix abstract classes with `I` or use descriptive names
  - ✅ `IUserRepository`, `BaseWidget`, `AbstractService`
  - ❌ `UserRepositoryInterface` (too verbose)

##### Widget Naming Rules
- **Atomic Design Folder Structure Only**:
  - Atomic design level is indicated ONLY by folder structure
  - Files and classes should NOT contain `atom`, `molecule`, or `organism` suffixes
  - Folder structure: `atoms/`, `molecules/`, `organisms/`, `templates/`, `pages/`
  - Example structure:
    ```
    presentation/
    ├── atoms/
    │   └── button_widget.dart (contains class ButtonWidget)
    ├── molecules/
    │   └── search_bar.dart (contains class SearchBar)
    └── organisms/
        └── header.dart (contains class Header)
    ```
- **File and Class Naming**:
  - ✅ Folder: `atoms/` → File: `button_widget.dart` → Class: `ButtonWidget`
  - ✅ Folder: `molecules/` → File: `form_section.dart` → Class: `FormSection`
  - ✅ Folder: `organisms/` → File: `voo_form.dart` → Class: `VooForm`
  - ❌ File: `button_atom.dart` (Don't add atomic suffix to files)
  - ❌ Class: `ButtonAtom` (Don't add atomic suffix to classes)
- **Component clarity**: Name should immediately convey purpose
  - ✅ `UserAvatarWidget`, `NavigationDrawer`
  - ❌ `Avatar`, `Drawer` (too generic)

##### Variable & Method Naming Rules
- **Use camelCase**: All variables and methods use camelCase
  - ✅ `userName`, `getUserData()`, `isLoading`
  - ❌ `user_name`, `GetUserData()`, `IsLoading`
- **Boolean naming**: Prefix with `is`, `has`, `can`, `should`
  - ✅ `isLoading`, `hasError`, `canEdit`, `shouldRefresh`
  - ❌ `loading`, `error`, `editable`
- **Private members**: Prefix with underscore
  - ✅ `_controller`, `_calculateTotal()`
  - Use sparingly, prefer proper encapsulation
- **Constants**: Use SCREAMING_SNAKE_CASE or lowerCamelCase
  - ✅ `const MAX_RETRY_COUNT = 3` or `const maxRetryCount = 3`
  - Prefer lowerCamelCase for Dart conventions

##### Package & Directory Naming Rules
- **Use snake_case**: All directories and packages use snake_case
  - ✅ `voo_core`, `data_grid`, `user_management`
  - ❌ `VooCore`, `dataGrid`, `UserManagement`
- **Logical grouping**: Group by feature or layer
  - By feature: `features/authentication/`, `features/shopping_cart/`
  - By layer: `presentation/`, `domain/`, `data/`
  - By type: `widgets/`, `models/`, `services/`

##### Enum Naming Rules
- **Use PascalCase**: Enum types use PascalCase
  - ✅ `enum UserRole { admin, user, guest }`
  - ❌ `enum user_role { Admin, User, Guest }`
- **Values use camelCase**: Enum values should be camelCase
  - ✅ `UserStatus.active`, `UserStatus.inactive`
  - ❌ `UserStatus.ACTIVE`, `UserStatus.Active`

##### File Refactoring Rules
- **No v2 or optimized naming**: When refactoring a file, ALWAYS replace the original file
  - ❌ Never create `data_grid_v2.dart` or `optimized_data_grid.dart`
  - ✅ Always replace the existing `data_grid.dart` directly
  - This prevents confusion and maintains clean codebase
  - Old versions belong in git history, not in the codebase

##### Import Naming Rules
- **Avoid naming imports unless necessary**: Only use `as` for conflicts
  - ✅ `import 'package:flutter/material.dart';`
  - ⚠️ `import 'package:flutter/material.dart' as material;` (only if needed)
- **Consistent aliasing**: When aliasing is necessary, use clear prefixes
  - ✅ `import 'package:http/http.dart' as http;`
  - ❌ `import 'package:http/http.dart' as h;`

#### Clean Architecture Layers
1. **Domain Layer**
   - Pure business logic
   - No external dependencies
   - Abstract repository interfaces
   - Entity definitions

2. **Data Layer**
   - Repository implementations
   - Data sources (local/remote)
   - Data models (separate from domain entities)
   - Mappers between models and entities

3. **Presentation Layer**
   - UI components following atomic design
   - State management (BLoC pattern)
   - No business logic
   - No direct data layer access

#### Widget Development Rules
- **Atomic Design Pattern**: 
  - Atoms: Basic UI elements
  - Molecules: Simple component groups
  - Organisms: Complex component sections
- **One class per file**: Each class should be in its own file
  - Improves code organization and maintainability
  - Makes files easier to find and understand
  - Reduces merge conflicts in version control
- **No function widgets**: Always use proper widget classes
- **No _buildXXX methods**: DO NOT use methods like _buildSwitchField that return widgets
  - Instead, create separate widget classes following atomic design
  - Each widget type should be in its own file
  - This improves code readability and maintainability
  - Primary focus is developer experience
- **No static widget creation methods**: Avoid static methods for creating widgets or form fields
  - Use factory constructors instead (e.g., VooField.text() not VooFieldUtils.textField())
  - Static methods are bad practice and harder to test/mock
  - Factory constructors provide better IDE support and discoverability
- **Stateless when possible**: Only use StatefulWidget when necessary
- **Theme compliance**: Use app theme for all styling

### 5. Testing Requirements
- **Test coverage minimum**: 80% for business logic
- **Unit tests required**: For all repository implementations
- **Widget tests required**: For all custom widgets
- **Integration tests**: For critical user flows
- **Mock dependencies**: Use Mockito for dependency mocking

### 6. Documentation Standards
- **README updates mandatory**: Keep documentation in sync with code
- **API documentation**: Document all public APIs with dartdoc
- **Example usage**: Provide examples for complex features
- **Changelog updates**: Document all changes in CHANGELOG.md

### 7. Git & Version Control
- **Conventional commits**: Use conventional commit format
- **Small commits**: One logical change per commit
- **Branch naming**: feature/, bugfix/, hotfix/, docs/
- **PR requirements**: Tests passing, documentation updated, changelog updated

### 8. Performance Guidelines
- **Const constructors**: Use const where possible
- **Lazy loading**: Implement lazy loading for lists
- **Memory management**: Dispose controllers and subscriptions
- **Build optimization**: Minimize widget rebuilds

### 9. Error Handling
- **Never ignore errors**: Always handle or propagate errors appropriately
- **User-friendly messages**: Provide clear error messages to users
- **Logging**: Log all errors with appropriate severity
- **Recovery strategies**: Implement graceful degradation

### 10. Security Practices
- **No hardcoded secrets**: Use environment variables
- **Input validation**: Validate all user inputs
- **Secure storage**: Use secure storage for sensitive data
- **API security**: Implement proper authentication/authorization

## Package-Specific Rules

### VooCore Package
- Maintain backward compatibility for all public APIs
- Document breaking changes prominently
- Keep dependencies minimal
- Provide migration guides for major updates

### VooLogging Package
- Ensure log levels are used correctly
- Implement log rotation to prevent storage issues
- Sanitize sensitive information from logs
- Maintain DevTools compatibility

### VooAnalytics Package
- Respect user privacy settings
- Implement data anonymization
- Batch analytics events for performance
- Provide opt-out mechanisms

### VooPerformance Package
- Keep performance monitoring lightweight
- Implement sampling for high-frequency events
- Provide performance budgets
- Document performance baselines

### VooDevTools Extension
- Maintain compatibility with latest DevTools
- Keep UI responsive with large data sets
- Implement efficient data filtering
- Provide export capabilities

### Package Reuse & Dependencies
- **Use existing packages**: Always use existing VooFlutter packages instead of duplicating functionality
  - Use `voo_tokens` for design tokens (spacing, typography, elevation, radius)
  - Use `voo_responsive` for responsive utilities and breakpoints
  - Use `voo_core` for shared utilities and base classes
  - Use `voo_ui_core` for common UI components
  - Use `voo_forms` for form-related widgets and validation
  - Use `voo_navigation` for adaptive navigation components
- **No duplicate implementations**: Never create duplicate token systems or utilities that already exist in other packages
- **Check before creating**: Before creating a new widget or utility, check if it exists in:
  1. The current package
  2. Related VooFlutter packages
  3. Standard Flutter/Material widgets
- **Extend, don't duplicate**: If existing functionality needs enhancement, extend the original package rather than duplicating

## Melos & Monorepo Rules
- Run `melos bootstrap` after dependency changes
- Use melos scripts for common tasks
- Keep package versions synchronized
- Test all packages before publishing

## Code Review Checklist
- [ ] Changes follow clean architecture
- [ ] No relative imports used
- [ ] Tests written and passing
- [ ] Documentation updated
- [ ] README reflects changes
- [ ] Changelog updated
- [ ] Performance impact considered
- [ ] Security implications reviewed
- [ ] Breaking changes documented
- [ ] Melos scripts still working

## Prohibited Practices
❌ Direct UI to Data layer communication
❌ Business logic in widgets
❌ Relative imports
❌ Ignoring errors
❌ Hardcoded secrets
❌ Massive refactors without approval
❌ Breaking changes without migration path
❌ Undocumented public APIs
❌ Functions returning widgets
❌ Skipping tests