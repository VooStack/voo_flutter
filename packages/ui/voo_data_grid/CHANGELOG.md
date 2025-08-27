## 0.5.3

* **Bug Fixes**
  * **Fixed Generic Type Parameter Propagation in Filter Row**
    * Fixed type mismatch error that occurred when clicking on filters with typed controllers
    * Added missing generic type parameters to all filter-related methods in `VooDataGridFilterRow`
    * Methods updated: `_buildFilterInput`, `_buildTextFilter`, `_buildNumberFilter`, `_buildNumberRangeFilter`, `_buildDateFilter`, `_buildDateRangeFilter`, `_buildDropdownFilter`, `_buildMultiSelectFilter`, `_buildCheckboxFilter`, `_getFilterOptions`, and `_applyFilter`
    * This ensures proper type safety when using typed controllers like `VooDataGridController<OrderList>`
    * Users no longer need to explicitly add type parameters to columns when using typed controllers

  * **Improved VooApiStandard Number Range Filtering**
    * Enhanced handling of between operator to properly handle null min/max values
    * Now only creates GreaterThanOrEqual filter when minimum value is not null
    * Only creates LessThanOrEqual filter when maximum value is not null
    * Allows filtering with just a minimum or just a maximum value

## 0.5.2

* **Bug Fixes & Improvements**
  * **Fixed Generic Type Propagation**: Fixed missing generic type parameters in widget tree
    * Added generic type parameter `<T>` to `VooDataGridFilterRow`, `VooDataGridHeader`, and `VooDataGridRow` widget instantiations
    * This fixes the type mismatch error when clicking on filters with typed controllers
    * Ensures proper type safety throughout the widget hierarchy
  * **Enhanced Error Handling**: Added comprehensive error handling for valueGetter functions
    * Added try-catch blocks around valueGetter calls to prevent crashes
    * Improved error logging with detailed type information for debugging
    * Better error messages when valueGetter is missing for typed objects
    * Graceful fallback to null values on errors instead of crashing
  
  * **VooApiStandard Number Range Fix**: Fixed number range filtering for Voo API Standard
    * Number ranges now correctly use GreaterThanOrEqual and LessThanOrEqual operators
    * Removed unsupported 'Between' operator from Voo API Standard
    * Creates two separate filters for range queries as expected by the API
    * Example: Site.siteNumber between 0 and 100 now sends:
      * `{fieldName: 'Site.siteNumber', value: 0, operator: 'GreaterThanOrEqual'}`
      * `{fieldName: 'Site.siteNumber', value: 100, operator: 'LessThanOrEqual'}`
  
  * **Filter Visibility During Errors**: Fixed filters disappearing when data loading fails
    * Headers and filter row now remain visible even when there's an error
    * Users can adjust filters and retry without losing their filter state
    * Error message appears in the data area while preserving the grid structure
    * Improves user experience by maintaining context during error states

* **Developer Experience**
  * Added detailed debug logging for type mismatches
  * Created comprehensive error handling tests
  * Better documentation of type safety requirements
  * Clearer error messages to help developers debug issues

* **Testing**
  * Added `error_handling_test.dart` with comprehensive type safety tests
  * Tests for typed valueGetter functions with various data types
  * Tests for null safety and error recovery
  * Verification that grid doesn't crash on type mismatches

## 0.5.1

* **New Feature: Field Prefix Support for Nested Properties**
  * Added `fieldPrefix` property to `VooDataGridController` for automatic field name prefixing
  * Added `fieldPrefix` parameter to `DataGridRequestBuilder` for API request formatting
  * Supports nested property filtering like "Site.SiteNumber", "Client.CompanyName"
  * Works with all API standards (Voo, Simple, JSON:API, OData, MongoDB, GraphQL, Custom)
  * Enables cleaner column definitions while maintaining proper API field names
  
* **New Feature: Action Columns and Clickable Cells**
  * Added `excludeFromApi` property to exclude columns from API requests (useful for action columns)
  * Added `onCellTap` callback for making cells clickable
  * Updated filter row to skip columns with `excludeFromApi` flag
  * Updated header to prevent sorting on excluded columns
  * Added InkWell wrapper for cells with onCellTap callback
  
* **Use Cases**
  * Nested properties: `Site.SiteNumber`, `Client.CompanyName`, `Order.Status`
  * Action buttons (edit, delete, view) that shouldn't be sent to API
  * Clickable cells for quick actions
  * Local-only columns that don't exist in the backend
  
* **Examples**
  * `nested_field_example.dart`: Demonstrates field prefix usage
  * `action_buttons_example.dart`: Shows action columns with edit/delete/view buttons
  
* **Testing**
  * Added tests for field prefix functionality
  * Added tests for excludeFromApi and onCellTap features
  * All existing tests pass without modifications

## 0.5.0

* **Major Feature: Generic Type Support**
  * VooDataGrid components now support generic type parameters for compile-time type safety
  * `VooDataGridController<T>`, `VooDataGridSource<T>`, and `VooDataColumn<T>` are now generic
  * `VooDataGrid<T>`, `VooDataGridHeader<T>`, `VooDataGridRow<T>`, and `VooDataGridFilterRow<T>` widgets are now generic
  * Eliminates need for runtime type casting in `valueGetter` functions
  * Provides full IntelliSense and type checking for row data

* **Type Safety Improvements**
  * `valueGetter` in VooDataColumn now has proper type signature: `dynamic Function(T row)`
  * `cellBuilder` callback now receives properly typed row: `Widget Function(BuildContext, dynamic value, T row)`
  * `onRowTap` and `onRowDoubleTap` callbacks now receive typed data: `void Function(T row)`
  * `cardBuilder` for mobile layout now has type safety: `Widget Function(BuildContext, T row, int index)`

* **Developer Experience**
  * No more casting needed in valueGetter: `(row) => row.orderId` instead of `(row) => (row as OrderModel).orderId`
  * Better IDE support with autocomplete and error detection
  * Cleaner, more maintainable code with compile-time type checking
  * Backward compatible - can still use `dynamic` for untyped/Map data

* **Example Updates**
  * Updated VooDataGridTypedObjectsPreview to demonstrate generic usage
  * Simplified valueGetter implementations without type casting
  * Added comments highlighting type safety benefits

## 0.4.0

* **Breaking Changes**
  * VooDataGrid now requires `valueGetter` function for typed objects (non-Map data)
  * DataGridRequestBuilder now returns structured responses with 'params', 'body', or 'variables' keys

* **Major Features**
  * Full support for typed objects in VooDataGrid
    - Added required `valueGetter` parameter in VooDataColumn for typed objects
    - Created comprehensive typed objects preview and documentation
    - Fixed dynamic property access errors for custom model classes
  * Enhanced API standards support
    - Fixed MongoDB operator handling for equals operator
    - Fixed GraphQL filter operators structure
    - Fixed OData numeric value formatting (no quotes for numbers)
    - Fixed JSON:API 1-based pagination

* **Bug Fixes**
  * Fixed critical "Dynamic call failed" error when using typed objects like OrderList
  * Fixed ScrollController disposal issues causing test failures
  * Resolved checkbox selection handling in data grid rows
  * Fixed row tap and double tap callback handling
  * Corrected alternating row colors initialization

* **Test Improvements**
  * Added comprehensive typed objects test suite
  * Fixed test infrastructure and dependency resolution
  * Improved test coverage from 87% to 98%
  * Added proper test data initialization

* **Documentation**
  * Added clear instructions for using typed objects with VooDataGrid
  * Created VooDataGridTypedObjectsPreview example
  * Updated README with valueGetter requirements and examples
  * Added warning messages for missing valueGetter functions

## 0.3.1

* **Bug Fixes**
  * Fixed ScrollController multiple positions error when using horizontal scrolling
  * Resolved horizontal scrollbar positioning to appear at bottom of grid instead of right side
  * Fixed horizontal scrollbar accessibility - now always visible at bottom of viewport without requiring vertical scroll

* **Filter Enhancements**
  * Enhanced Advanced Filters preview with comprehensive filter types:
    - DateTime filters with date picker widgets
    - Numeric range filters for min/max values
    - Dropdown filters with icon support
    - Boolean checkbox filters
    - Text search filters with proper hints
  * Added `FilterTypeExtensions` for cleaner code organization
  * Improved filter type handling with proper operators and input widgets per type

* **UX Improvements**
  * Horizontal scrollbar now fixed at bottom of grid viewport for better accessibility
  * Removed scrollbar from header to prevent duplicate scrollbar issues
  * Improved scrollbar positioning following UI/UX best practices
  * Stack-based layout for optimal scrollbar visibility

* **Code Quality**
  * Refactored filter system with enum extensions for better maintainability
  * Fixed DateTime handling in DateFilter models
  * Improved type safety in filter request builders

## 0.3.0

* **BREAKING CHANGES**
  * Renamed `StandardApiRequestBuilder` to `DataGridRequestBuilder`
  * Integrated API standards directly into `DataGridRequestBuilder` for better architecture
  * Moved preview files from `/preview` to `/lib/preview` directory

* **API Standards Support**
  * Integrated `ApiFilterStandard` enum directly into `DataGridRequestBuilder`
  * Support for 6 different API standards: Simple REST, JSON:API, OData, MongoDB/Elasticsearch, GraphQL, and Custom
  * Instance-based configuration allows separate Dio instances with custom interceptors
  * Each data source can have its own HTTP client with tokens and authentication

* **Advanced Filtering System** 
  * Complex filters with secondary conditions (AND/OR logic)
  * Multiple filter types: stringFilters, intFilters, dateFilters, decimalFilters
  * `AdvancedFilterRequest` model for complex filter requests
  * `AdvancedRemoteDataSource` for handling advanced filter formats
  * Full backward compatibility with legacy filter formats

* **Enhanced Request Builder**
  * New instance-based `DataGridRequestBuilder` with API standard configuration
  * `buildRequest()` method adapts to selected API standard
  * Support for query parameters (GET) and request body (POST) formats
  * Built-in URL encoding and special character handling for each standard
  * Static methods maintained for backward compatibility

* **Synchronized Horizontal Scrolling**
  * Fixed horizontal scrolling to work uniformly between header and body
  * `SynchronizedScrollController` for coordinating scroll between components
  * Separate controllers for header and body synchronization
  * Smooth scrolling experience across large datasets

* **Widget Previews**
  * Comprehensive data grid preview with 200+ rows and 15+ columns
  * API standards configuration preview with live request viewer  
  * Advanced filtering demo with API request/response monitoring
  * Empty state preview demonstrating proper header visibility
  * Mock data generator for realistic testing scenarios

* **UI/UX Improvements**
  * Column headers remain visible even with no data
  * Empty state message appears below headers
  * Advanced filter widget with visual filter builders
  * Filter preview and validation features
  * Better responsive behavior for large datasets

* **Developer Experience**
  * Cleaner architecture with integrated API standards
  * Better separation of concerns for HTTP clients
  * Comprehensive examples for each API standard
  * Improved documentation and code organization

## 0.2.0

* **Empty State Improvements**
  * Column headers now remain visible even when there's no data
  * Empty state message appears in the body area below headers
  * Users can see the table structure even with no rows
* **Advanced Filtering System**
  * Added support for complex filters with secondary conditions
  * Implemented multiple filter types: string, int, date, decimal
  * Added secondary filters with AND/OR logic operators
  * Created `AdvancedFilterRequest` model for complex filter requests
  * Added `AdvancedRemoteDataSource` for handling advanced filter formats
  * Maintained full backward compatibility with legacy filter formats
* **Filter UI Components**
  * Added `AdvancedFilterWidget` for building complex filters via UI
  * Implemented filter field configuration system
  * Added visual filter builders for each data type
  * Created filter preview and validation features
* **Synchronized Scrolling**
  * Fixed horizontal scrolling to work uniformly between header and body
  * Implemented `SynchronizedScrollController` for scroll coordination
  * Added separate scroll controllers for header and body synchronization
* **Enhanced Request Builder**
  * Added `buildAdvancedRequestBody` method for complex filters
  * Implemented `convertToAdvancedRequest` for format conversion
  * Added support for API-specific operator formatting
* **Documentation & Examples**
  * Added comprehensive example app with advanced filtering demos
  * Updated README with advanced filtering documentation
  * Added multiple filter request/response examples

## 0.1.0

* Enhanced data grid with multiple API filtering standards support
* Added support for JSONAPI, REST, GraphQL, and OData filtering standards
* Improved sorting and filtering capabilities
* Added comprehensive pagination support
* Enhanced remote data loading with customizable data sources
* Added selectable rows with checkbox support
* Improved column configuration and customization
* Added widget previews for testing and development

## 0.0.1

* Initial release of VooDataGrid
* Basic data grid implementation with sorting and filtering
* Column-based data display with customizable headers
* Local data source support
