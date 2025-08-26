## 0.2.1

* **API Standards Support**
  * Added `ApiFilterStandard` enum for different API standards (Simple, JSON:API, OData, MongoDB, GraphQL, Custom)
  * Enhanced `StandardApiRequestBuilder` to support multiple API standards
  * Added comprehensive API standards preview demonstrating all formats
  * Exported `data_grid_api_standards.dart` for public use
* **Preview Improvements**  
  * Moved preview files to proper `lib/preview/` directory structure
  * Created interactive API standards configuration preview
  * Added real-time request format viewer for different API standards
  * Included code examples for each API standard integration

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
