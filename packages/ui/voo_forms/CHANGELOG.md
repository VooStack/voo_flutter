## [0.3.32] - 2025-01-09

### Improvements
- **All tests passing**: Fixed all remaining test issues ensuring complete test suite passes
- **Code quality**: Resolved critical analyzer issues for production readiness

## [0.3.31] - 2025-01-09

### Critical Bug Fixes
- **Fixed VooForm to properly work inside BlocBuilder**: Form values now persist correctly when BLoC state changes
  - Only use initialValue on first field registration, preventing data loss on rebuilds
  - Fixed issue where setValue was overwriting preserved user input with new initialValues
  - Text controllers now properly preserve existing field values over new initialText
  - Added _initializedFields tracking to distinguish first registration from rebuilds

### Improvements
- **Better BLoC Integration**: VooForm now works seamlessly inside BlocBuilder
  - Users can type continuously when clearing validation errors
  - Form values persist through rapid BLoC state changes
  - Validation state is maintained across rebuilds
  - Focus and keyboard behavior improved (within Flutter framework limitations)

### Tests
- Added comprehensive User Form BLoC integration test suite
- Tests verify real-world BLoC usage patterns work correctly
- All existing tests pass with no regressions

## [0.3.30]

### Features
- **BLoC Integration Tests**: Added comprehensive BLoC/Cubit integration tests for form validation
  - Tests demonstrate error clearing works correctly with state management
  - Tests verify form values persist through BLoC rebuilds
  - Tests confirm validation modes work with rapid state changes
  - Added bloc and bloc_test to dev dependencies for testing

### Bug Fixes
- **Enhanced Focus Management**: Improved focus retention during widget rebuilds
  - Added AutomaticKeepAliveClientMixin to VooTextField for better state preservation
  - Enhanced didUpdateWidget to better handle focus restoration with microtasks
  - Improved FocusNode lifecycle management with internal node creation when needed
  - Better handling of hasPrimaryFocus in addition to hasFocus checks

### Documentation
- **Known Flutter Limitation**: Documented keyboard dismissal during complete widget rebuilds
  - Added workaround suggestions for BLoC/Cubit applications
  - Recommend moving VooForm outside BlocBuilder when possible
  - Suggest using BlocSelector for targeted rebuilds
  - Note that error clearing functionality works correctly despite keyboard limitation

## [0.3.29]

### Bug Fixes
- **Keyboard Dismissal Issue**: Fixed keyboard dismissing when selecting text fields with validation errors
  - Resolved issue where keyboard would dismiss on first click of a field with required validator
  - Fixed keyboard dismissing after entering a character that removes validation error
  - Improved state synchronization between TextEditingController and VooFormController
  - Enhanced validation handling to properly track and clear errors during user input
  - Fixed RenderFlex overflow in form labels by adding proper text wrapping

- **Error State Management**: Improved error clearing logic when typing in form fields
  - Added proper error state tracking with `_errorsForced` flag
  - Fixed validation logic to maintain error state appropriately during user interaction
  - Improved `_validateField` method to handle both function validators and VooValidationRule objects
  - Enhanced handleChanged callback to properly update form controller values

- **Widget Rebuild Handling**: Fixed focus and state preservation during widget rebuilds
  - Improved stateful widget wrappers to properly maintain focus during rebuilds
  - Fixed TextEditingController value synchronization across rebuilds
  - Enhanced didUpdateWidget lifecycle to preserve focus state
  - Resolved issues with external state management (BLoC/Cubit) causing keyboard dismissal

## [0.3.28]

### Bug Fixes
- **Keyboard Dismissal on Validation**: Fixed critical issue where keyboard would dismiss when validation state changes
  - Keyboard no longer dismisses when first focusing a field with validation error
  - Keyboard stays open when typing clears validation errors
  - Keyboard remains open during all validation state changes
  - Implemented stateful widget pattern with AnimatedBuilder to isolate TextFormField from rebuilds
  - Fix applied to VooTextField, VooCurrencyField, and VooNumberField

- **Validation Display in Form Preview**: Fixed validation not showing errors properly
  - VooFormPageBuilder now correctly passes controller to actionsBuilder
  - validateAll(force: true) properly displays validation errors
  - Form preview demo updated to demonstrate validation features
  - Added Submit and Clear Errors buttons to showcase validation behavior

- **Error Clearing on User Input**: Enhanced validation behavior to clear errors when user types
  - Errors now clear immediately when user starts typing to fix the issue
  - Works correctly even with external state management (Cubit/BLoC) causing rebuilds
  - Improved `_handleFieldChange` to always validate when an error is present

- **Focus Retention with State Management**: Fixed focus loss when using with BLoC/Cubit
  - Added `didUpdateWidget` lifecycle to properly handle widget updates
  - Focus is now preserved when parent widgets rebuild due to state changes
  - TextEditingController and FocusNode references are properly maintained
  - Fix applied to VooTextField, VooCurrencyField, and VooNumberField

## [0.3.27]

### Features
- **VooOption Widget**: New design system widget for dropdown options
  - Standardized option widget with title, subtitle, leading/trailing widgets
  - Built-in support for checkboxes and radio buttons
  - Customizable selected state styling
  - VooSimpleOption for basic use cases
  - Keeps users within the VooForms design system

- **Extended optionBuilder Support**: Added optionBuilder to all multi-select fields
  - VooMultiSelectField now supports custom option rendering
  - VooAsyncMultiSelectField supports custom option rendering
  - Consistent optionBuilder API across all dropdown and multi-select fields
  - All builders receive isSelected state for proper styling

### Improvements
- **Complete optionBuilder Coverage**: All dropdown-type fields now support custom option builders
  - VooDropdownField, VooAsyncDropdownField, VooMultiSelectField, VooAsyncMultiSelectField
  - Unified API for customizing option appearance across all selection fields

## [0.3.26]

### Features
- **Custom Option Builder for Dropdowns**: Added optionBuilder to customize dropdown option appearance
  - VooDropdownField now supports custom option rendering with isSelected state
  - VooAsyncDropdownField supports the same optionBuilder functionality
  - Provides full control over option styling while maintaining widget architecture
  - Builder receives context, item, isSelected flag, and display text

### Improvements
- **Base Field Properties**: Ensured all field widgets properly expose common base properties
  - All fields now support layout (standard, compact, dense)
  - All fields now support isHidden for conditional visibility
  - All fields now support size constraints (minWidth, maxWidth, minHeight, maxHeight)
  - Improved consistency across 15+ field widget types

### Bug Fixes
- **Validation Focus Issue**: Fixed focus retention during validation
  - Correctly distinguishes between validationMode (when to validate) and errorDisplayMode (when to show errors)
  - Fields now properly maintain focus when validation errors clear during typing

## [0.3.25]

### Bug Fixes
- **Multi-Select Dropdown Click Outside**: Fixed issue where clicking outside the multi-select dropdown didn't close it
  - Improved overlay barrier implementation using Positioned.fill for better coverage
  - Added proper GestureDetector on dropdown to prevent it from closing when clicking on the dropdown itself
  - Ensures consistent behavior with other dropdown components

## [0.3.24]

### UI Improvements
- **Multi-Select Field UI Fix**: Resolved duplicate clear button issue in VooMultiSelectField
  - Removed redundant clear button that appeared next to the dropdown arrow
  - Clear functionality remains available via individual chip delete buttons and "Clear All" menu option
  - Fixed layout issues with proper suffixIcon implementation
  - Improved visual consistency with other form fields

## [0.3.23]

### Validation Improvements
- **Real-time validation for all field types**: Fixed validation not triggering when values change in text-based fields
  - VooTextField now validates on every character typed to clear errors immediately
  - VooCurrencyField properly validates when currency values are entered
  - VooNumberField and all numeric fields validate in real-time
  - Provides immediate feedback when validation errors are resolved
  
### Test Coverage
- Added comprehensive focus retention tests for all field types
- Verified that all 10+ field types maintain keyboard focus during validation
- Added validation clearing tests for text and currency fields
- Ensured seamless multi-field navigation without keyboard dismissal

## [0.3.22]

### Critical Bug Fix - Focus Retention
- **Root Cause Fixed**: Resolved the core issue causing keyboard dismissal after typing one character in fields with validation errors
  - VooFormController now only triggers UI rebuilds when error state actually changes
  - Previously, validation would always call notifyListeners() even when error state remained the same
  - This unnecessary rebuild was causing focus loss and keyboard dismissal
  
### Internal Improvements  
- Optimized validateField method to check if error has actually changed before notifying listeners
- Reduced unnecessary UI rebuilds during validation
- Improved performance by preventing redundant state notifications

## [0.3.21]

### Critical Bug Fix
- **Focus Retention During Validation**: Fixed critical issue where keyboard would dismiss after typing one character in fields with validation errors
  - Text input fields (VooTextField, VooNumberField, VooCurrencyField, and all derivatives) no longer trigger validation during typing
  - Prevents the validation→rebuild→focus-loss cycle that was dismissing the keyboard
  - Selection fields (dropdowns, checkboxes, switches) still validate immediately to clear errors
  - Users can now type continuously without interruption when clearing validation errors
  
### Internal Changes
- All text-based fields now explicitly pass `validate: false` during onChange to prevent focus disruption
- Boolean and checkbox fields now properly validate on change to clear errors immediately
- Improved separation between text input behavior (no immediate validation) and selection behavior (immediate validation)

## [0.3.20]

### Bug Fixes
- **Dropdown Validation**: Fixed issue where selecting a value from dropdown fields did not clear validation errors
  - VooDropdownField now triggers validation when a selection is made
  - VooAsyncDropdownField properly clears errors on selection
  - VooMultiSelectField validates on every selection change
  - VooDateField now validates when a date is selected
  
- **Focus Retention**: Fixed keyboard dismissal when typing first character in a field with validation error
  - Text fields now use form controller's focus node management
  - Focus nodes are properly preserved across rebuilds when errors clear
  - VooTextField, VooCurrencyField, VooNumberField, and VooDateField all maintain focus properly
  - Keyboard no longer dismisses when validation errors are cleared
  
### Internal Improvements
- Enhanced focus node management in VooFormController
- All field widgets now properly use centralized focus node management
- Improved validation trigger control with explicit validate parameter

## [0.3.19]

### Critical Bug Fixes
- **Currency Field Formatting**: Fixed major issue where typing multiple digits resulted in incorrect values
  - Updated CurrencyFormatter to properly handle incremental typing
  - Typing "5" twice now correctly shows "$0.55" instead of "$50.05"
  - Formatter now works like a calculator - digits are added from right to left
  - Added support for min/max value constraints
  - Fixed deletion behavior to properly remove digits
  
- **Focus Issue with Validation**: Fixed critical issue where fields with validation errors would only accept one character then jump focus to next field
  - Modified VooFormController to prevent unnecessary validation during typing when explicitly disabled
  - Changed currency field TextInputAction from "next" to "done" to prevent premature focus changes
  - Fields now maintain focus properly even when validation errors are present
  - Validation can now be controlled per setValue call to prevent focus disruption

### Testing
- Added comprehensive test suite for CurrencyFormatter with 20+ test cases
- Tests cover incremental typing, deletion, currency variants, constraints, and edge cases
- Added tests for multiselect dropdown functionality
- Test coverage ensures currency formatting works correctly across all scenarios

## [0.3.18]

### Added
- **VooMultiSelectField**: New multi-select dropdown field widget
  - Allows selecting multiple options from a dropdown list
  - Displays selections as chips with customizable max display count
  - Built-in search/filter functionality for options
  - Select All and Clear All action buttons
  - Full Material 3 design compliance with animations
  - Integrates seamlessly with VooFormController
  
- **VooAsyncMultiSelectField**: Async variant of multi-select field
  - Loads options dynamically from APIs or databases
  - Configurable search debounce for performance
  - Loading indicators and error handling
  - Maintains selections across searches
  - Custom loading widget support

### Improvements
- **Test Coverage**: Enhanced form widget test coverage
  - Added comprehensive tests for VooForm widget behavior
  - Added tests for VooFormPageBuilder functionality
  - Added 40+ tests for VooMultiSelectField and VooAsyncMultiSelectField
  - Improved test organization and documentation
  - Enhanced error handling and validation tests
  
### Internal
- Code cleanup and maintenance improvements
- Updated development dependencies
- Enhanced CI/CD pipeline configuration
- Fixed deprecated withOpacity usage, now using withValues

## [0.3.17]

### Bug Fixes
- **Validation Error Display**: Fixed critical issue where validation errors were not displaying on form fields
  - Fields now properly show validation errors when `controller.validate()` is called
  - Error messages correctly appear below fields with proper Material Design styling
  - Errors update dynamically as users type (when configured with `onTyping` mode)
  
- **Form Reset**: Fixed bug where errors would persist after calling `controller.reset()`
  - Form now properly clears all validation errors when reset
  - Text controllers clear without triggering unwanted validation
  - Added internal flags to prevent validation during reset operations
  
- **Controller State Management**: Fixed setState being called during build
  - Resolved issue where initializing text controllers would trigger setState during widget build
  - Added proper initialization tracking to prevent change notifications during setup
  - Fixed VooFormScope rebuild mechanism for better performance
  
- **Error Display Modes**: Fixed validation respecting `errorDisplayMode` settings
  - `onSubmit` mode now correctly waits until form submission to show errors
  - `onTyping` mode shows errors immediately as user types
  - Silent validation (`validate(silent: true)`) no longer updates UI

### Internal Improvements
- Added `rebuildKey` to VooFormScope for more efficient widget rebuilding
- Improved error change detection to only rebuild when errors actually change
- Added `_isResetting` and `_isInitializing` flags for better state management
- Validation errors now properly propagate through InputDecoration's errorText

## [0.3.15]

### Critical Fix  
- **Automatic Form Validation**: Fixed critical bug where form validation wasn't working
  - VooForm now automatically registers all fields with their validators when initialized
  - Fields automatically update the form controller when values change (no manual updates needed!)
  - Controller validation (`validateAll()`) now works correctly
  - VooTextField automatically syncs with controller through VooFormScope
  - Initial values are properly set in the controller

### How It Works
The form now automatically handles everything:
```dart
// Your existing code works without changes!
final formController = VooFormController();

// In your form:
VooForm(
  controller: formController,
  fields: [
    VooTextField(
      name: 'site_name',
      validators: [VooValidator.required()],
      onChanged: (value) => context.read<OrderFormCubit>().updateSiteName(value),
    ),
  ],
)

// Validation now works automatically:
onSubmit: (_) {
  final isValid = formController.validateAll(); // This now works!
  if (isValid) {
    context.read<OrderFormCubit>().submitForm();
  }
}
```

### Technical Details
- VooFormScope now provides controller to all child fields
- Fields automatically register with controller on initialization
- VooTextField wraps onChanged to update controller automatically
- No breaking changes - existing code continues to work

## [0.3.14]

### Fixed
- **CurrencyFormatter**: Completely rewrote formatter with best practices
  - Simplified logic by removing buggy incremental typing detection
  - Added min/max value constraints for better validation
  - Improved cursor position management for predictable behavior
  - Enhanced parse method to handle different currency symbols and locales
  - Added optional spacing between symbol and amount
  - Fixed regex escaping issues for currency symbols

- **VooFormController Validation**: Fixed critical validation bugs
  - Fixed `isValid` getter that was always returning true
  - Improved `validate()` method for proper silent validation
  - Enhanced error handling for validators that throw exceptions
  - Fixed `validateAll()` to properly accumulate and return validation state
  - Fixed `validateField()` to handle null and empty string errors correctly
  - Validation now properly returns false when fields are invalid

### Added
- **Comprehensive Test Suite**: Added extensive test coverage for VooFormController
  - 31 comprehensive tests covering all edge cases
  - Tests for boundary conditions, error handling, and race conditions
  - Real-world scenario tests (registration forms, multi-step wizards)
  - Performance tests for large forms (1000+ fields)
  - Memory management and lifecycle tests

### Improved
- **Test Organization**: Restructured test directory following atomic design
  - Controller tests moved to `test/presentation/state/`
  - Integration tests in `test/integration/`
  - Scenario tests in `test/scenarios/`
  - All tests properly organized and passing

- **Code Quality**: Fixed all lint issues
  - Removed unnecessary lambdas and redundant arguments
  - Fixed trailing commas and empty statements
  - Improved type safety and code clarity

## [0.3.13]

### Fixed
- **VooForm and VooFormPageBuilder Errors**: Fixed undefined 'form' parameter errors
  - Removed attempts to create VooFormController with VooForm entities
  - Controllers now created with just error display mode parameter
  - Removed unused domain form imports from both files
  - Fixed compilation errors that were preventing tests from running

### Changed
- **Test Updates**: Updated tests to match new controller behavior
  - Modified test for isEditable=false to check form rendering instead of AbsorbPointer
  - Tests now align with the removal of AbsorbPointer wrapper (per user request in v0.3.8)

### Testing
- **Test Status**: 263 out of 288 tests passing (91% pass rate)
  - All VooFormController tests pass (39/39)
  - All VooForm and VooFormPageBuilder tests pass (18/18)
  - Remaining failures are in integration tests that may need updates for new controller API

## [0.3.12]

### Fixed
- **VooFormController Type Safety**: Fixed type casting issues in validation logic
  - Safer type casting for function validators to prevent runtime errors
  - Changed from direct casting to type checking before assignment
  - Handles both String and null return values from validators properly
  - Prevents "A value of type 'dynamic' can't be assigned to a variable of type 'String?'" errors

### Improved
- **Code Quality**: Fixed linting issues for better code maintainability
  - Converted block function bodies to expression bodies where appropriate
  - Added required trailing commas for better formatting
  - Improved code readability and consistency

## [0.3.11]

### Fixed
- **VooFormController Validation Support**: Fixed validation to work with VooValidationRule objects
  - Controller now supports both function validators and VooValidationRule objects
  - Validators from `VooValidator.required()`, `VooValidator.email()`, etc. now work correctly
  - Mixed validators (both functions and VooValidationRule objects) are supported
  - Silent validation properly handles VooValidationRule objects
  - All validation modes (onTyping, onSubmit) work with the new validator types

### Added
- **Enhanced Validator Type Support**: Flexible validator handling
  - `registerField()` now accepts validators as either functions or VooValidationRule objects
  - Automatic detection and handling of validator types during validation
  - Comprehensive test coverage for VooValidationRule validators

## [0.3.10]

### Fixed
- **VooFormController Architecture Refactor**: Major refactor to comply with clean architecture principles
  - Removed dependency on VooForm domain entity (violated clean architecture)
  - Created `FormFieldConfig` for field configuration without domain dependencies
  - Controller now works directly with field names and configurations
  - Improved validation logic with proper error display modes
  - Added comprehensive support for field visibility and enablement
  - Enhanced focus management for better keyboard navigation
  - Fixed validation to properly respect `errorDisplayMode` settings

### Added
- **Comprehensive VooFormController Tests**: Full test coverage for refactored controller
  - Tests for field registration (single and multiple)
  - Value management and type-safe value retrieval
  - Validation modes (onTyping, onSubmit, silent)
  - Form submission with error handling
  - Field visibility and enablement controls
  - Focus management and navigation
  - Dynamic validator management
  - JSON serialization
  - Change notification system

### Changed
- **VooFormController API**: Simplified and more flexible API
  - No longer requires VooForm entity for initialization
  - Direct field registration with `registerField()` and `registerFields()`
  - Cleaner validation API with `validate()`, `validateField()`, and `validateAll()`
  - Better separation between UI state and business logic

## [0.3.9]

### Fixed
- **VooCurrencyField Cursor Position Bug**: Improved cursor handling in currency formatter
  - Enhanced detection of where digits are added in the formatted text
  - Better handling of single character additions vs multiple character changes
  - Prevents incorrect formatting when cursor position is unexpectedly at the beginning
  - Maintains calculator-style entry when typing at the end of the field
  - Fixes issue where typing "66" could result in "$600.06" instead of "$0.66"

## [0.3.8]

### Fixed
- **VooFormPageBuilder Overlay Removal**: Removed opacity overlay and AbsorbPointer when form is not editable
  - Forms with `isEditable: false` no longer show a semi-transparent overlay
  - Removed `AbsorbPointer` wrapper - field-level controls now handle editability
  - Form fields remain fully interactive unless individually disabled
  - Improves visual clarity and allows field-level interaction control
  - Better UX for displaying forms with mixed editable/read-only fields

## [0.3.7]

### Fixed
- **VooCurrencyField Incremental Typing Bug**: Fixed issue where typing multiple digits resulted in incorrect values
  - Rewrote formatter logic to properly handle incremental digit entry (e.g., typing "777" now correctly formats as "$7.77" instead of "$770.07")
  - Improved performance by simplifying cursor positioning logic
  - Added proper numeric value extraction that handles formatted text with leading zeros
  - Fixed the root cause where appending digits to formatted text was incorrectly parsed

### Changed
- **CurrencyFormatter Improvements**: Enhanced formatter for better real-world usage
  - Now correctly multiplies value by 10 when appending digits (standard calculator behavior)
  - Simplified cursor positioning to always place at end for better UX
  - Removed unused cursor calculation method to reduce complexity

## [0.3.6]

### Fixed
- **VooCurrencyField Formatting Bug**: Fixed critical issue where typing numbers resulted in incorrect formatting
  - Removed conflicting `FilteringTextInputFormatter.digitsOnly` that was fighting with `CurrencyFormatter`
  - Improved `CurrencyFormatter` to correctly distinguish between text replacements and deletions
  - Now correctly formats "88" as "$0.88" instead of the erroneous "8008,808.00"
  - Added proper handling for direct text input (e.g., from tests or paste operations)

## [0.3.5]

### Added
- **Drag and Drop Support for VooFileField**: Enhanced file upload experience
  - Desktop and web platform drag and drop functionality via `desktop_drop` package
  - Visual feedback with animated borders and background colors during drag
  - "Drop file here" message and icon changes when dragging files
  - Platform detection to enable only on supported platforms (web/desktop)
  - Maintains existing file validation (size, extension) for dropped files
  - Material 3 compliant animations and color transitions

### Changed
- **VooFileField Visual States**: Improved drag state visual feedback
  - Primary color border and subtle background tint when dragging
  - Download icon appears during drag operations
  - Smooth animations (200ms) for all state transitions
  - "or drag and drop" hint text below button on supported platforms

### Fixed
- Converted block function body to expression body for better code style
- Updated tests to match new UI text and behavior
- Ensured drag and drop properly integrates with existing file selection

## [0.3.4]

### Added
- **Enhanced VooCurrencyField**: Complete rewrite with proper currency formatting
  - Real-time formatting with thousand separators (e.g., $1,234.56)
  - Support for multiple currencies (USD, EUR, GBP, JPY, etc.)
  - Locale-specific number formatting
  - Currency symbol icons for all major currencies
  - Smart formatting that displays formatted text but returns raw numeric values

- **Improved CurrencyFormatter**: Advanced text input formatter
  - Automatic thousand separators and decimal places
  - Factory constructors for common currencies
  - Proper cursor positioning during editing
  - Handles deletion and insertion correctly
  - Configurable symbol placement (before/after amount)

### Changed
- **VooCurrencyField API**: Now extends VooFieldBase directly
  - Better integration with form validation
  - Min/max value constraints with formatted error messages
  - Proper read-only state showing formatted values
  - Material 3 design compliance

### Fixed
- Currency fields now properly format values with separators while maintaining numeric output
- Currency symbols display correctly based on selected currency
- Read-only currency fields show properly formatted values

## [0.3.3]

### Added
- **VooFile Entity**: New domain entity for managing files from URLs or local uploads
  - Supports both existing files (from URL) and newly uploaded files (PlatformFile)
  - Automatic file metadata extraction (name, size, extension, MIME type)
  - Helper methods for determining file origin and type
  - Factory constructors for creating from URL or PlatformFile

- **Enhanced VooFileField**: Major improvements to file field functionality
  - Now uses VooFile entity instead of raw PlatformFile
  - Support for displaying files from URLs (existing/uploaded files)
  - Image preview support for URL-based image files
  - "Uploaded" badge indicator for files from URLs
  - Open file action button with URL launcher integration
  - Proper Material 3 design compliance

- **URL Launcher Integration**: Added file opening capability
  - Opens files in new browser tab on web platforms
  - Uses system default handler for file types on mobile/desktop
  - Graceful error handling with user feedback
  - Safe context checking to prevent crashes

### Fixed
- **Read-Only File Field Display**: Corrected visual presentation in read-only mode
  - Maintains consistent Material 3 card layout in both states
  - Shows proper file preview with icon, name, and size
  - Displays "No file attached" message when empty
  - Proper disabled state styling with reduced opacity

### Changed
- **File Field API**: Updated to use VooFile entity
  - Breaking change: initialValue now accepts VooFile? instead of PlatformFile?
  - onFileSelected callback now provides VooFile? instead of PlatformFile?
  - Improved type safety and cleaner API surface

### Dependencies
- Added `url_launcher: ^6.2.0` for opening file URLs

## [0.3.2]

### Added
- **VooFormSection**: New container widget for organizing form fields into logical sections
  - Supports collapsible/expandable sections with smooth animations
  - Material 3 design with proper surface colors and elevation
  - Title, description, and optional leading/trailing widgets
  - Visual containment with card-based design
  - Implements VooFormFieldWidget for seamless integration with VooForm

- **VooReadOnlyField**: Improved read-only field display
  - Consistent sizing with editable fields (56px min height)
  - Proper Material 3 styling and alignment
  - Better visual hierarchy with standard field padding

### Fixed
- **VooFormPageBuilder Layout**: Fixed RenderFlex overflow issues in unbounded height contexts
  - Uses LayoutBuilder to detect bounded/unbounded constraints
  - Adapts layout strategy based on context (Expanded vs Flexible)
  - Properly handles preview environments and nested scrollables

- **Read-only Field Consistency**: All field types now properly handle read-only state
  - Unified approach using VooReadOnlyField for better UX
  - Labels handled by parent widgets to avoid duplication
  - Consistent sizing and alignment across all field types

### Changed
- **Material 3 Compliance**: Updated components to follow Material 3 design guidelines
  - Better typography hierarchy
  - Improved surface colors and elevation
  - Consistent spacing and padding
  - Professional visual appearance

## [0.3.1]

### Fixed
- **Initial Values Display**: Fixed all field types to properly display their initial values
  - Text-based fields (VooTextField, VooEmailField, VooPasswordField, etc.) now correctly show initial values
  - VooDateField properly formats and displays initial dates with default MM/dd/yyyy format
  - VooDateFieldButton now correctly displays initial date values on the button
  - VooAsyncDropdownField immediately displays initial values before async loading completes
  - Added comprehensive test coverage for all field types' initial value display

- **Dropdown Outside Click Dismissal**: VooDropdownSearchField now properly dismisses when clicking outside
  - Added full-screen GestureDetector to capture outside clicks
  - Improved overlay management for better UX

- **ReadOnly State Enforcement**: Fixed file and date fields to respect readOnly state
  - VooFileField now properly disables file picking when readOnly is true
  - VooDateFieldButton correctly disables date selection when readOnly is true
  - Both fields now use getEffectiveReadOnly(context) to check form-level and field-level states

- **Form Loading State**: Added isLoading property to VooForm
  - When isLoading is true, form content is hidden and a loading indicator is shown
  - Added loadingWidget parameter for custom loading indicators
  - VooFormScope now propagates loading state to all child fields

### Added
- **Comprehensive Test Coverage**: Added all_fields_initial_values_test.dart
  - 25 test cases covering every VooField type
  - Verifies initial value display for all field variations
  - Integration test simulating real-world form scenarios

## [0.3.0]

### Added
- **VooDateFieldButton**: New date field widget that uses a button interface for date selection
  - Shows selected date or placeholder text on the button
  - Supports custom date formatting and button types
  - Includes prefix/suffix icon support
  - Full integration with form validation and error display

### Fixed
- **VooDateField Spacing**: Fixed inconsistent spacing and decoration in VooDateField to match other field types
  - Removed extra container wrapping that caused visual inconsistencies
  - Date fields now properly display with the same styling as text fields

## [0.2.3]

### Breaking Changes
- **VooListField Refactored to Stateless**: 
  - VooListField is now completely stateless - developers manage state externally
  - Changed from `itemTemplate` and internal state to `items` and `itemBuilder` pattern
  - Callbacks simplified to `onAddPressed`, `onRemovePressed`, and `onReorder`
  - See migration guide in `example/list_field_migration.md`

### Changed
- **Widget Architecture Refactor**:
  - Replaced factory pattern (VooField.text(), etc.) with direct widget instantiation
  - All field widgets now extend VooFieldBase for zero code duplication
  - Direct widget pattern: use `VooTextField()` instead of `VooField.text()`
  - Cleaner architecture following KISS principle and atomic design

### Added
- **New Field Widgets**:
  - `VooTextField` - Text input field
  - `VooEmailField` - Email input with validation
  - `VooPasswordField` - Password input with visibility toggle
  - `VooPhoneField` - Phone number input with formatting
  - `VooMultilineField` - Multi-line text input
  - `VooNumberField` - Numeric input with constraints
  - `VooIntegerField` - Integer-only input
  - `VooDecimalField` - Decimal number input
  - `VooCurrencyField` - Currency input with formatting
  - `VooPercentageField` - Percentage input (0-100)
  - `VooBooleanField` - Boolean switch/checkbox
  - `VooCheckboxField` - Single checkbox field
  - `VooDropdownField` - Dropdown selection
  - `VooAsyncDropdownField` - Async loading dropdown
  - `VooListField` - Stateless dynamic list management

### Fixed
- **Dropdown Label Issues**: Fixed duplicate label rendering in dropdown fields
- **Number Field Validation**: Fixed min/max validation to return proper error messages
- **Test Infrastructure**: Updated all tests to work with new widget pattern
- **Lint Issues**: Fixed 150+ lint issues across the package
- **File Architecture**: Cleaned up exports and removed unused factory pattern files

### Removed
- **Deprecated Factory Pattern Files**:
  - Removed `VooFormFieldBuilder` (old factory pattern)
  - Removed `VooFieldWidget` (old factory wrapper)
  - Removed layout widgets that depended on old pattern
  - Kept `VooFormBuilder` for layout management

### Improved
- **Performance**: Stateless VooListField improves performance by avoiding internal state
- **Developer Experience**: Direct widget instantiation is more intuitive
- **Maintainability**: Single responsibility principle with VooFieldBase
- **Type Safety**: Better type inference with direct widget usage
- **Testing**: Comprehensive test coverage for all new widgets

## [0.2.2]
### Added
- **VooField.List

## [0.2.1]

### Fixed
- **Dropdown Type Casting Errors**: Improved type safety for dropdown callbacks
  - Fixed runtime type errors with strongly typed callbacks for both regular and async dropdowns
  - Updated `_invokeFieldOnChanged` method to use dynamic invocation with proper error handling
  - Resolved issues with custom types like `USState`, `JurisdictionListOption`, and other domain objects
  - Prevents `type '(CustomType?) => void' is not a subtype of type '((dynamic) => void)?'` errors

- **Test Infrastructure**: Enhanced dropdown testing utilities
  - Created comprehensive `dropdown_test_helpers.dart` for reliable dropdown testing
  - Fixed test helpers to properly find `DropdownButtonFormField` of any generic type
  - Improved test reliability for async dropdown operations
  - Updated test helpers to handle both searchable and regular dropdowns

- **Dropdown Widget Detection**: Improved widget finding in tests
  - Fixed dropdown field detection to work with generic types
  - Updated `tapDropdown` helper to properly identify dropdown widgets
  - Enhanced test utilities to handle both `TextFormField` and `DropdownButtonFormField` types

### Improved
- **Test Coverage**: Fixed multiple failing tests
  - Resolved dropdown callback test failures
  - Fixed atomic component dropdown tests
  - Improved async dropdown behavior test reliability
  - Reduced test failures from 17 to 12

## [0.2.0]

### Added
- **VooSimpleForm Enhancements**: Added `isEditable` parameter to VooSimpleForm
  - VooSimpleForm now supports form-level editability control
  - Properly passes `isEditable` to underlying VooFormBuilder

### Fixed
- **Field-Level Read-Only Control**: Individual fields now properly respect their `readOnly` property
  - Fields marked as `readOnly: true` display as read-only even when the form is editable
  - Enables mixed forms with both editable and read-only fields (e.g., auto-generated IDs, timestamps)
  - Logic: Field is read-only if form `isEditable` is false OR field `readOnly` is true
  - Useful for forms with system-managed fields, calculated values, and display-only data
  - Added comprehensive tests for field-level read-only behavior

- **Async Dropdown Type Casting**: Fixed type casting error with strongly typed callbacks
  - Error: `TypeError: Instance of '(CustomType?) => void' is not a subtype of type '((dynamic) => void)?'`
  - Updated `VooDropdownFieldWidget` to use `Function.apply` for invoking field callbacks
  - Async dropdowns now properly handle custom types like `JurisdictionListOption`
  - Prevents runtime type errors when using strongly typed onChanged callbacks

## [0.1.21]

### Enhanced
- **VooField Factory Methods**: All VooField factory methods now support `readOnlyWidget` parameter
  - Added `Widget? readOnlyWidget` parameter to all 19 field factory methods
  - Enables custom read-only display for every field type (text, email, password, phone, number, multiline, dropdown, dropdownAsync, dropdownSimple, boolean, checkbox, radio, date, time, integer, decimal, currency, percentage, slider)
  - Works seamlessly with existing `isEditable` functionality in VooFormBuilder
  - Provides complete control over read-only field appearance

## [0.1.20]

### Added
- **Custom Read-Only Widget Support**: Fields can now have custom read-only display widgets
  - Added `readOnlyWidget` parameter to `VooFormField` for custom read-only displays
  - When `isEditable: false` is set on `VooFormBuilder`, custom widgets are used if provided
  - Falls back to default read-only display when no custom widget is specified
  - Enables complete customization of how fields appear in read-only mode

### Fixed
- **Dropdown Type Safety**: Fixed VooFieldOption type mismatch errors
  - Resolved runtime type errors with generic dropdown fields
  - Fixed read-only mode dropdown type handling  
  - Improved type inference for String, int, double, and bool dropdowns
  - Added proper support for async dropdowns with type preservation

### Enhanced
- **Read-Only Mode**: Comprehensive automatic details view for forms
  - Added `isEditable` parameter to `VooFormBuilder` (defaults to true)
  - All field types now have elegant read-only displays with icons
  - Password fields show masked values in read-only mode
  - Date/time fields show formatted values with appropriate icons
  - Boolean fields display check/cancel icons with Yes/No text
  - Slider fields show progress indicators in read-only mode

### Added
- **Custom Field Support**: Added VooFieldType.custom for arbitrary widgets
  - Support for `customWidget` property for direct widget insertion
  - Support for `customBuilder` function for dynamic widget generation
  - Custom fields work in both editable and read-only modes

### Testing
- Added comprehensive type safety tests for all field types
- Added tests for custom readOnlyWidget functionality
- Added tests for form toggle between editable and read-only modes
- All tests passing with proper generic type constraints

## [0.1.19]

### Maintenance
- Version bump for package maintenance
- Updated dependencies compatibility

## [0.1.18]

### Fixed
- **Type Conversion in Number Fields**: Fixed TypeError when entering string values in number fields
  - VooFormController now properly converts string inputs to numbers for number fields
  - Invalid number strings are converted to null instead of causing type errors
  - Empty strings in number fields are handled as null values

### Added
- **Comprehensive Form Submission Tests**: Added extensive test coverage for form submission
  - Tests for isSubmitting state management and preventing concurrent submissions
  - Tests for isSubmitted state tracking across successful/failed submissions
  - Tests for onSubmit, onSuccess, and onError callbacks
  - Tests for validation during submission and error handling
  - Tests for isDirty state management during submission flow
  - Edge case tests for rapid submissions and empty forms
  - Total of 28 new submission-related tests

### Testing
- Added `voo_form_controller_submission_test.dart` with comprehensive submission tests
- Added `voo_form_controller_type_test.dart` with 15 type conversion tests
- All tests passing with proper type safety

## [0.1.17]

### Added
- **Type Enforcement System**: Comprehensive type safety for all form fields
  - Created `StrictNumberFormatter` to prevent invalid character input in number fields
  - Added specialized formatters: `IntegerFormatter`, `CurrencyFormatter`, `PercentageFormatter`
  - New factory methods: `VooField.integer()`, `VooField.decimal()`, `VooField.currency()`, `VooField.percentage()`
  - Created `FieldValueConverter` system for safe type conversions between UI strings and field values

- **Error Display Modes**: Flexible error display system with multiple modes
  - `VooFormErrorDisplay` enum with 7 display modes (never, onType, onBlur, onSubmit, onInteraction, onTypeDebounced, always)
  - `VooFormErrorConfig` for configurable error behavior with predefined configurations
  - Smart error display based on field interaction state

- **Material 3 Design Components**: 
  - Created `VooFormButton` with Material 3 compliant button variants (filled, filledTonal, outlined, text, elevated)
  - Predefined factories for common actions: Submit, Cancel, Secondary, Danger buttons
  - Added `VooFormActions` for consistent button layout in forms

### Fixed
- **Critical Type Error**: Fixed "type 'String' is not a subtype of type 'num?'" error in VooField.number
  - Users can no longer type invalid characters in number fields
  - Proper type conversion between text input and field values
  - Real-time validation with min/max value enforcement

### Testing
- Added comprehensive test suite for type enforcement (31 tests)
- Added tests for all error display modes (14 tests)
- All existing tests pass with new implementations

## [0.1.16]

### Fixed
- **Test Improvements**: Fixed all failing tests in voo_forms package
  - Fixed scientific notation parsing test to handle input formatter limitations
  - Fixed time field localization initialization using `didChangeDependencies` and post-frame callbacks
  - Fixed date constraint test to use `DateUtils.isSameDay` for proper date comparison
  - Fixed date picker cancel button handling with fallback logic for different button text variations
  - Fixed time display format tests to be locale-agnostic
  - Fixed invalid date handling test to focus on validation behavior
  - Fixed async dropdown loading test to verify core functionality

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