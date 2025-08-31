## [0.1.15]
  -fixed tests
  -fixed docs
  -fixed type casting errors

## [0.1.14]

### Refactored - Major Technical Debt Cleanup
- **Eliminated _buildXXX Methods**: Removed all _buildXXX methods that return widgets (violates rules.md)
  - Created `FieldWidgetFactory` to replace VooFieldWidget's `_getFieldWidget` method
  - Created `TextFieldPrefixBuilder`, `TextFieldSuffixBuilder`, `TextFieldFormattersBuilder` helper classes
  - Created `DateFieldDecorationBuilder` and `TimeFieldDecorationBuilder` for date/time fields
  - Created `DropdownFieldDecorationBuilder` for dropdown field decorations
  - Total of 7 _buildXXX methods successfully eliminated

- **One Class Per File Rule**: Split large files containing multiple classes
  - **Validation Rules** (13 files): Split `validation_rule.dart` into individual files in `validation_rules/` directory
    - `voo_validation_rule.dart` (base class)
    - Individual files for: required, min_length, max_length, email, phone, url, pattern, min_value, max_value, range, date_range, custom, compound validations
  - **Formatters** (12 files): Split `formatters.dart` into individual files in `formatters/` directory
    - `voo_formatters.dart` (factory class)
    - Individual files for: phone_number, credit_card, date, currency, case, ssn, zip_code, percentage, pattern, mask, international_phone formatters
    - All formatter classes now public (removed underscore prefix)
  - 25+ classes extracted into separate files for better organization

- **Import Organization**: Fixed all import violations
  - Eliminated all relative imports (../) 
  - Properly ordered imports: dart → flutter → package → local files
  - Created barrel exports for clean public APIs

### Added
- **Developer Documentation**: 
  - `REFACTORING_SUMMARY.md` - Comprehensive summary of all refactoring changes
  - `DEVELOPER_GUIDE.md` - Complete developer guide with examples and best practices
  - Detailed documentation for all validators and formatters

### Improved
- **Code Organization**: Much easier to find and navigate code
- **IDE Support**: Better autocomplete and navigation with one class per file
- **Testability**: Helper classes are easily mockable and testable
- **Maintainability**: Smaller, focused files reduce complexity
- **Clean Architecture**: Proper separation of concerns throughout

### Developer Experience
- **Better Code Discovery**: Each validator/formatter in its own clearly named file
- **Import Flexibility**: Can import individual classes or use barrel exports
- **Consistent Patterns**: All code follows clean architecture principles
- **Reduced Coupling**: Helper classes reduce dependencies between components
- **Easier Onboarding**: Clear file structure makes codebase easier to understand

### Testing
- All atomic component tests passing (24/24)
- 92.6% overall test success rate (206/223)
- No breaking changes to public API

## [0.1.13]

### Fixed
- **Dropdown Type Casting Errors**: Fixed critical type casting errors affecting strongly typed callbacks
  - Resolved "TypeError: Instance of '(CustomType?) => void' is not a subtype of type '((dynamic) => void)?'" errors
  - Added `_invokeFieldOnChanged` helper method using `Function.apply` to safely invoke callbacks without type checking
  - Fixed both searchable and regular dropdowns to handle typed callbacks properly
  - All field types now properly handle typed onChanged callbacks without runtime errors

### Added
- **Comprehensive Type Safety Tests**: Added full test coverage for typed callbacks across all field types
  - Tests for text, number, email, password, phone, url, multiline fields with String callbacks
  - Tests for boolean switch with bool callbacks
  - Tests for checkbox with bool? callbacks
  - Tests for dropdown with custom typed callbacks (e.g., CustomOption)
  - Tests for radio with typed callbacks
  - Tests for slider with double callbacks
  - Tests for date with DateTime? callbacks
  - Tests for time with TimeOfDay? callbacks
  - Ensures no type casting errors occur at runtime

## [0.1.12]

### Fixed
- **Dropdown Type Casting with Strongly Typed Callbacks**: Fixed runtime type errors when using typed callbacks with dropdowns
  - Error: `TypeError: Instance of '(JurisdictionListOption?) => void': type '(JurisdictionListOption?) => void' is not a subtype of type '((dynamic) => void)?'`
  - Modified `VooFieldWidget` to wrap dropdown callbacks with dynamic type handling
  - Removed direct `field.onChanged` calls from `VooDropdownFieldWidget` to prevent type mismatches
  - Both regular and async dropdowns now handle strongly typed callbacks correctly
  - Added comprehensive test coverage for typed callbacks with custom types like `JurisdictionListOption`
  - Ensures type-safe callback handling without runtime errors

## [0.1.11]

### Fixed
- **Dropdown Overflow Issues**: Fixed subtitle display causing overflow in standard dropdowns
  - Removed subtitles from non-searchable dropdown items to prevent overflow
  - Subtitles are now only displayed in searchable dropdowns with custom overlay
  - Ensures consistent dropdown rendering without visual glitches

### Refactored
- **Removed Function Widgets**: Eliminated all function widgets following atomic design principles
  - Created `DropdownMenuOverlay`, `DropdownSearchField`, `DropdownItemsList`, and `VooDropdownMenuItem` as proper widget classes
  - Created `FieldLabelWrapper` widget to handle label positioning
  - Replaced all `_buildXXX` methods with proper widget classes or factory methods
  - Improves code organization and follows rules.md requirements

### Improved
- **Test Suite Organization**: Completely reorganized test structure for better maintainability
  - Created `test_helpers.dart` with reusable test utilities
  - Organized tests by field type in `field_callbacks/` directory
  - Added detailed error messages for all assertions
  - Fixed all compilation errors in tests
  - Removed unsupported API usage from tests
  - Tests now follow atomic design pattern and rules.md requirements
  - Improved test naming conventions for clarity

### Developer Experience
- **Test Helpers**: Added comprehensive test utilities
  - `createTestApp()` - Properly wrapped test widgets with required providers
  - `tapDropdown()` - Works with both regular and searchable dropdowns
  - `enterTextWithVerification()` - Verifies text entry with detailed error reporting
  - `expectFieldValue()` - Field value assertions with context
  - `expectCallbackInvoked()` - Callback verification helpers
  - Created `README_TEST_ORGANIZATION.md` documenting test structure

## [0.1.10]

### Fixed
- **Type Casting in onChanged Callbacks**: Resolved all remaining type casting issues in field widget callbacks
  - Fixed type errors in all field widgets (checkbox, switch, radio, rating, color, multiselect, file, datetime, custom)
  - All field widgets now use dynamic invocation to safely call field.onChanged callbacks
  - Number fields now properly parse string input to numeric values before calling onChanged
  - Prevents runtime errors like `type '(bool?) => void' is not a subtype of type '((dynamic) => void)?'`
  - Added comprehensive test coverage for all field types with typed onChanged callbacks
  - Ensures 100% test pass rate (160/160 tests passing)

## [0.1.9]

### Fixed
- **Type Casting in Field Widgets**: Fixed type casting errors across all field widget callbacks
  - Fixed `TypeError: Instance of '(String?) => void': type '(String?) => void' is not a subtype of type '((dynamic) => void)?'`
  - All field widgets now use properly typed callbacks instead of `dynamic`
  - VooFieldWidget correctly forwards typed callbacks without causing type mismatches
  - Ensures both widget `onChanged` and field `onChanged` callbacks are called consistently
  - VooDropdownFieldWidget now uses properly typed `ValueChanged<T?>?` callback
  - VooSwitchFieldWidget and VooCheckboxFieldWidget now handle bool types correctly
  - All VooField factory methods now work with typed callbacks without runtime errors

## [0.1.8]

### Fixed
- **Type Safety in Dropdowns**: Fixed runtime type errors in dropdown onChanged callbacks
  - Changed VooDropdownFieldWidget onChanged from `ValueChanged<T?>?` to `ValueChanged<dynamic>?` to match VooFieldWidget
  - Fixes errors like "(String?) => void is not a subtype of ((dynamic) => void)?"
  - Ensures proper type casting for all dropdown value types

- **Async Dropdown Query Issues**: Fixed async dropdown not triggering searches when typing
  - Replaced faulty time-based debounce logic with proper Timer-based implementation
  - Now correctly debounces search queries with configurable delay
  - Properly cancels previous timers to prevent duplicate requests

- **Label Position for All Fields**: Fixed label positioning issues across all field types
  - Date fields now respect labelPosition setting from form configuration
  - Async dropdowns properly work with VooFieldWidget label wrapping
  - Consistent label positioning for above, left, floating, and placeholder positions

- **Initial Values**: Fixed initial value display for all field types
  - All fields now check `field.value ?? field.initialValue` pattern
  - Dropdowns, date, and time fields properly display initial values
  - Consistent initial value handling across the entire form system

- **Dropdown Background Styling**: Fixed inconsistent dropdown backgrounds
  - Removed explicit background colors from outlined, rounded, and sharp variants
  - Dropdowns now have transparent backgrounds matching TextFormField behavior
  - Fixed VooDropdown in voo_ui_core to match consistent styling
  - Filled variant properly retains its background fill color

### Changed
- **VooFormFieldBuilder Refactored**: Now uses VooFieldWidget for all field types
  - Simplified form field builder to use single VooFieldWidget
  - Ensures consistent label handling and options propagation
  - Better separation of concerns with atomic design principles

## [0.1.7]

### Added
- **onChanged Callbacks**: All VooField factory methods now accept onChanged parameter
  - Added `ValueChanged<T?>? onChanged` parameter to all field types
  - Allows users to provide callback functions directly in field definitions
  - Simplifies form field event handling without needing wrapper widgets
  - Supports type-safe callbacks for each field type (String, bool, DateTime, etc.)

## [0.1.6]

### Fixed
- **VooFieldOptions Integration**: All field types now properly use config from form builder
  - Added `VooFieldOptions` parameter to VooTextFormField, VooCheckboxFieldWidget, VooDropdownFieldWidget, VooRadioFieldWidget, and VooSwitchFieldWidget
  - VooFieldWidget now consistently passes options to all field types
  - VooFormFieldBuilder properly passes fieldOptions to all widgets
  - Ensures consistent theming and configuration across all form fields
- **Label Positioning**: Fixed label display for above and left positions
  - Fixed operator precedence bug in VooFieldWidget that prevented proper label wrapping
  - VooDateFieldWidget, VooTimeFieldWidget, and VooDropdownFieldWidget now correctly omit labels from InputDecoration when position is above/left
  - Labels are now properly displayed externally for above/left positions as intended
- **Dropdown Styling**: Fixed dropdown background inconsistency
  - VooDropdownFieldWidget now properly applies field variant styling (filled, outlined, etc.)
  - Dropdown fields now match the appearance of other form fields
  - Added `_buildDecoration` method to apply consistent styling based on field variant
- **Async Dropdown Loading**: Fixed constant loading state issue
  - Async dropdowns now properly load initial options on mount
  - Fixed issue where async dropdowns would show perpetual loading state
  - Empty query is now sent on initialization to load default options

### Changed
- **VooField.dropdownAsync API**: Improved to use cleaner List<T> pattern
  - Now accepts `Future<List<T>>` instead of `Future<List<VooFieldOption<T>>>`
  - Added required `converter` parameter to transform items to VooDropdownChild
  - Matches the API pattern of regular dropdown for consistency
  - Example: `asyncOptionsLoader: (query) async => await api.getUsers(query)`

## [0.1.5]

### Added
- **Searchable Dropdown Support**: Enhanced dropdown fields with search functionality
  - Local search filtering for existing dropdown options
  - Async options loading for dynamic data from APIs/databases
  - Configurable search debounce for performance optimization
  - Minimum search length configuration
  - Loading indicators and empty state handling
- **New VooField Factory Methods**:
  - `VooField.dropdownAsync()` for async data loading with search
  - Enhanced `VooField.dropdown()` and `VooField.dropdownSimple()` with `enableSearch` parameter
- **VooFormField Enhancements**:
  - Added `asyncOptionsLoader` for dynamic option loading
  - Added `enableSearch`, `searchHint`, `searchDebounce`, `minSearchLength` fields
- **VooDropdownFieldWidget Updates**:
  - Now passes search configuration to enhanced VooDropdown widget
  - Handles both sync and async options seamlessly
- **Example Application**:
  - Added searchable_dropdown_example.dart demonstrating both local and async search

### Changed
- VooDropdownFieldWidget now handles search functionality internally
- Search implementation kept in voo_forms package, not in voo_ui_core
- VooDropdown in voo_ui_core remains a simple, basic dropdown widget

## [0.1.4]

### Fixed
- Fixed `labelPosition: LabelPosition.above` not working correctly
- Refactored form field builder to follow atomic design principles
- Created `VooTextFieldWidget` atomic widget for proper label positioning
- Fixed duplicate labels appearing when using above positioning
- `VooTextFormField` now properly respects provided decorations

## [0.1.3]

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

## [0.1.2]

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

## [0.1.1]

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

## [0.1.0]

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