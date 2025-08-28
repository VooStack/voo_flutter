# Changelog

## [0.1.3] - 2025-01-28

### Changed
- **One Class Per File Rule**: Refactored voo_field_options.dart into separate files
  - Each enum and class now in its own file following rules.md
  - Created separate files for: LabelPosition, FieldVariant, ErrorDisplayMode, ValidationTrigger, FocusBehavior
  - VooFieldOptions and VooFieldOptionsProvider now in separate files
- **Removed Duplicate Responsive Logic**: Now using voo_ui_core's VooSpacingSize and VooDesignSystemData
  - Eliminated duplicate size/spacing definitions
  - Using voo_ui_core's existing responsive utilities
  - Better integration with overall design system

### Fixed
- Import paths now properly organized
- No more duplicate responsive logic between packages

## [0.1.2] - 2025-01-28

### Added
- **VooSimpleForm**: New simplified form builder for amazing developer experience
  - Works seamlessly with VooField factory constructors
  - Supports all form layouts (vertical, horizontal, grid, stepped, tabbed)
  - Built-in support for VooFieldOptions inheritance
  - Extension method `.toForm()` for even simpler form creation
- **Atomic Layout Widgets**: Replaced all _buildXXX methods with proper atomic widgets
  - `VooFormVerticalLayout`: Vertical form layout organism
  - `VooFormHorizontalLayout`: Horizontal scrolling form layout
  - `VooFormGridLayout`: Responsive grid layout with column spanning
  - `VooFormSteppedLayout`: Wizard-style stepped form layout
  - `VooFormTabbedLayout`: Tabbed form layout
  - `VooFormProgress`: Progress indicator molecule
  - `VooFormActions`: Form action buttons molecule
- **Best Practices Example**: Comprehensive example demonstrating all new features

### Changed
- **VooFormBuilder**: Refactored to use atomic widgets instead of _buildXXX methods
  - Improved separation of concerns
  - Better testability and maintainability
  - Follows atomic design principles strictly
- **Theme Integration**: All form components now properly use theme colors
  - Removed hardcoded green/red colors in favor of theme.colorScheme.tertiary/error
  - Consistent theming throughout all form elements

### Fixed
- Fixed VooFormController import path issues in new atomic widgets
- Fixed type errors in VooFormSection references
- Removed unused _validateCurrentStep method from VooFormBuilder

## [0.1.1] - 2025-01-28

### Added
- New VooField API with factory constructors for better developer experience:
  - `VooField.text()`, `VooField.email()`, `VooField.password()`
  - `VooField.dropdown()`, `VooField.checkbox()`, `VooField.radio()`
  - `VooField.date()`, `VooField.time()`, `VooField.slider()`
  - And more field types following best practices (no static methods)
- VooFieldOptions system with enum-based configuration:
  - Presets: `VooFieldOptions.material`, `.compact`, `.comfortable`, `.minimal`
  - Configurable label position, field variant, size, density, validation triggers
  - Inheritable options from parent forms for consistency
- VooFieldOptionsProvider using InheritedWidget pattern for option inheritance
- Parent forms can set defaultFieldOptions that cascade to all children
- New atomic widgets for better code organization:
  - `VooSliderFormField` for slider inputs
  - `VooDateFormField` for date selection
  - `VooTimeFormField` for time selection
- Added rule to rules.md: No `_buildXXX` methods that return widgets

### Changed
- **BREAKING**: Removed all hardcoded colors - everything now uses Theme.of(context)
- **BREAKING**: Refactored VooFieldWidget to follow atomic design (no _buildXXX methods)
- Improved theme integration - respects app's ColorScheme automatically
- Updated VooFormConfig to support defaultFieldOptions
- Enhanced field option inheritance from parent forms

### Deprecated
- **VooFieldUtils**: Static methods violate best practices. Use VooField factory constructors instead:
  ```dart
  // OLD (deprecated)
  VooFieldUtils.textField(id: 'name', name: 'name')
  
  // NEW (recommended) 
  VooField.text(name: 'name')
  ```
  Migration guide:
  - `VooFieldUtils.textField()` → `VooField.text()`
  - `VooFieldUtils.emailField()` → `VooField.email()`
  - `VooFieldUtils.passwordField()` → `VooField.password()`
  - `VooFieldUtils.phoneField()` → `VooField.phone()`
  - `VooFieldUtils.dropdownField()` → `VooField.dropdown()`
  - All other static methods have equivalent factory constructors
  - Will be removed in version 0.2.0

### Fixed
- Fixed green color appearing in switches and other components when not in theme
- Fixed amber color in rating widgets - now uses theme primary color
- Fixed type mismatches in VooField factory constructors
- Fixed VooFormField<bool> type errors in checkbox and switch fields
- Removed deprecated API usage warnings
- Fixed enum conflicts between form_config.dart and voo_field_options.dart

### Developer Experience
- Intuitive factory constructor API (VooField.text instead of static methods)
- Enum-based configuration for better type safety and IDE support
- Consistent theming throughout all form components
- Better code organization following atomic design principles

## [0.1.0] - 2025-01-27

### Added
- Initial release of voo_forms package
- Comprehensive form builder with clean architecture
- 20+ field types support including:
  - Text, Email, Password, Phone, URL
  - Number, Slider, Rating
  - Date, Time, DateTime
  - Boolean, Checkbox, Switch
  - Dropdown, Radio, MultiSelect
  - Color picker, File upload
- Form sections with collapsible support
- Form headers for better organization and categorization
- Advanced validation system with 20+ built-in validators:
  - Required, Email, Phone, URL validation
  - Min/Max length and value validators
  - Pattern matching validators
  - Password strength validators
  - Credit card, postal code validators
  - Custom validation support
- 15+ text input formatters:
  - Phone number formatting (US and international)
  - Credit card formatting
  - Currency formatting
  - Date and time formatting
  - Custom mask formatters
- Form controller with state management:
  - Real-time validation
  - Field dependencies
  - Form submission handling
  - Progress tracking
- Multiple form layouts:
  - Vertical, Horizontal, Grid
  - Stepped/Wizard forms
  - Tabbed forms
- Responsive design supporting all screen sizes
- Material 3 compliance
- Theme customization support
- Comprehensive utility classes:
  - VooFormUtils for form operations
  - VooFieldUtils for field creation
  - VooFormTheme for styling
- Export formats:
  - JSON serialization/deserialization
  - Form summary generation
  - Configuration export
- Full TypeScript-like type safety with generics
- Atomic design pattern implementation
- Cross-platform support (iOS, Android, Web, Desktop)