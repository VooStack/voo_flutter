# Development Rules for VooFlutter

## Core Development Principles

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

### 3. Import & Module Rules
- **No relative imports**: Always use absolute imports from package root
- **Package imports first**: Order imports as dart, flutter, package, then local
- **Barrel exports**: Use index files for clean public APIs

### 4. Architecture Rules

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