# Changelog

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