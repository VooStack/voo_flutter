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
