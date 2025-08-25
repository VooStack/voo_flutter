# Voo UI

[![pub package](https://img.shields.io/pub/v/voo_ui.svg)](https://pub.dev/packages/voo_ui)
[![pub points](https://img.shields.io/pub/points/voo_ui)](https://pub.dev/packages/voo_ui/score)
[![flutter platform](https://img.shields.io/badge/Platform-Flutter-blue.svg)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A comprehensive Flutter UI component library built with Material 3 design principles and atomic design pattern. Voo UI provides production-ready, customizable widgets with built-in theming, responsive design, and accessibility features.

## ✨ Features

### 🎨 Design System
- **Material 3 Support**: Full Material You (Material 3) theming with dynamic color support
- **Atomic Design Pattern**: Components organized as atoms, molecules, and organisms
- **Responsive Design**: Adaptive layouts that work across mobile, tablet, and desktop
- **Dark Mode**: Built-in dark mode support with seamless transitions
- **Custom Theming**: Extensive customization through VooDesignSystem

### 📊 Advanced Data Grid
- **Three Operation Modes**: Local, Remote, and Mixed (hybrid) data handling
- **Smart Filtering**: Automatic filter input selection based on data type
- **Multi-Column Sorting**: Sort by multiple columns with visual indicators
- **Built-in Pagination**: Customizable page sizes with navigation controls
- **Row Selection**: Single and multiple selection modes
- **Frozen Columns**: Keep important columns visible while scrolling
- **Custom Cell Rendering**: Full control over cell appearance and behavior
- **Performance Optimized**: Efficient rendering for large datasets
- **Responsive Design**: Automatic adaptation for mobile, tablet, and desktop screens
- **Mobile Card View**: Beautiful card-based layout for mobile devices
- **Priority Columns**: Smart column visibility based on screen size
- **Mobile Filter Bottom Sheet**: Material Design 3 modal bottom sheet for filters on mobile/tablet
- **Filter Chips**: Visual representation of active filters with easy removal
- **Responsive Filter UI**: Inline filters on desktop, bottom sheet on mobile/tablet
- **Touch-Optimized**: Large tap targets and mobile-friendly controls

### 📅 Advanced Calendar
- **Five View Modes**: Month, Week, Day, Year, and Schedule views
- **Flexible Selection**: Single, multiple, or range date selection
- **Event Management**: Add, display, and interact with calendar events
- **Custom Builders**: Full control over day and event rendering
- **Integrated Picker**: Date/time picker with field and inline modes
- **Material 3 Theme**: Follows Material Design 3 principles
- **Swipe Navigation**: Intuitive gesture-based navigation
- **Responsive Design**: Adapts to different screen sizes
- **Localization Ready**: Works with intl package for date formatting

### 🧩 Component Library

#### Foundation Components
- **VooDesignSystem**: Central design token management
- **VooTheme**: Comprehensive Material 3 theming
- **VooColors**: Semantic color system with status indicators
- **VooTypography**: Type scale following Material Design
- **VooSpacing**: Consistent spacing system

#### Input Components
- **VooTextField**: Material 3 outlined text field with floating labels
- **VooButton**: Multiple variants (elevated, outlined, text, tonal)
- **VooDropdown**: Enhanced dropdown with icons and subtitles
- **VooSearchBar**: Material 3 search bar with clear action
- **VooCalendar**: Highly customizable calendar with multiple views
- **VooDateTimePicker**: Material 3 date and time picker with calendar integration

#### Display Components
- **VooCard**: Material 3 cards with interaction states
- **VooListTile**: Enhanced list tiles with selection support
- **VooStatusBadge**: HTTP status and semantic badges
- **VooTimestampText**: Intelligent relative time display

#### Layout Components
- **VooContainer**: Responsive container with animation support
- **VooPageHeader**: Page headers with actions and icons
- **VooAppBar**: Enhanced app bar with sliver support

#### Feedback Components
- **VooEmptyState**: Beautiful empty states with actions
- **VooStatusBadge**: Color-coded status indicators

## 🚀 Getting Started

### Installation

Add `voo_ui` to your `pubspec.yaml`:

```yaml
dependencies:
  voo_ui: ^0.1.0
```

Run the following command:

```bash
flutter pub get
```

### Quick Setup

1. **Wrap your app with VooDesignSystem:**

```dart
import 'package:voo_ui/voo_ui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VooDesignSystem(
      child: MaterialApp(
        theme: VooTheme.light(),
        darkTheme: VooTheme.dark(),
        home: MyHomePage(),
      ),
    );
  }
}
```

2. **Or use VooMaterialApp for automatic setup:**

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VooMaterialApp(
      title: 'My Voo App',
      theme: VooTheme.light(),
      darkTheme: VooTheme.dark(),
      home: MyHomePage(),
    );
  }
}
```

## 📅 Calendar Widget

### Overview

The VooCalendar is a highly customizable Material 3 calendar widget with multiple view modes, event support, and date selection capabilities.

### Features

- **Multiple Views**: Month, Week, Day, Year, and Schedule views
- **Selection Modes**: Single date, multiple dates, or date range selection
- **Event Support**: Display and manage events with custom styling
- **Customizable Theme**: Full control over colors, text styles, and appearance
- **Responsive Design**: Adapts to different screen sizes
- **Swipe Navigation**: Navigate between periods with swipe gestures
- **Date/Time Picker**: Integrated picker for forms and inputs

### Basic Calendar Example

```dart
import 'package:voo_ui/voo_ui.dart';

class CalendarExample extends StatefulWidget {
  @override
  State<CalendarExample> createState() => _CalendarExampleState();
}

class _CalendarExampleState extends State<CalendarExample> {
  late VooCalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VooCalendarController(
      initialDate: DateTime.now(),
      initialView: VooCalendarView.month,
      selectionMode: VooCalendarSelectionMode.single,
    );
    
    // Add sample events
    _controller.addEvent(
      VooCalendarEvent(
        id: '1',
        title: 'Team Meeting',
        description: 'Weekly sync with the team',
        startTime: DateTime.now().add(Duration(days: 2, hours: 10)),
        endTime: DateTime.now().add(Duration(days: 2, hours: 11)),
        color: Colors.blue,
        icon: Icons.group,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return VooCalendar(
      controller: _controller,
      availableViews: [
        VooCalendarView.month,
        VooCalendarView.week,
        VooCalendarView.day,
        VooCalendarView.year,
        VooCalendarView.schedule,
      ],
      onDateSelected: (date) {
        print('Selected date: $date');
      },
      onEventTap: (event) {
        print('Tapped event: ${event.title}');
      },
    );
  }
}
```

### Date Range Selection

```dart
VooCalendar(
  controller: VooCalendarController(
    selectionMode: VooCalendarSelectionMode.range,
  ),
  onRangeSelected: (start, end) {
    if (start != null && end != null) {
      print('Selected range: $start to $end');
    }
  },
)
```

### Custom Day Builder

```dart
VooCalendar(
  dayBuilder: (context, date, isSelected, isToday, isOutsideMonth, events) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : null,
        border: isToday ? Border.all(color: Colors.red, width: 2) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              date.day.toString(),
              style: TextStyle(
                color: isSelected ? Colors.white : null,
                fontWeight: isToday ? FontWeight.bold : null,
              ),
            ),
          ),
          if (events.isNotEmpty)
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  events.length.toString(),
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  },
)
```

### Date/Time Picker

```dart
// Date picker field
VooDateTimePicker(
  mode: VooDateTimePickerMode.date,
  labelText: 'Select Date',
  onDateTimeChanged: (dateTime) {
    print('Selected: $dateTime');
  },
)

// Time picker field
VooDateTimePicker(
  mode: VooDateTimePickerMode.time,
  labelText: 'Select Time',
  use24HourFormat: true,
  onDateTimeChanged: (dateTime) {
    print('Selected time: ${dateTime?.hour}:${dateTime?.minute}');
  },
)

// Date and time picker
VooDateTimePicker(
  mode: VooDateTimePickerMode.dateTime,
  labelText: 'Select Date & Time',
  onDateTimeChanged: (dateTime) {
    print('Selected: $dateTime');
  },
)

// Date range picker
VooDateTimePicker(
  mode: VooDateTimePickerMode.dateRange,
  labelText: 'Select Date Range',
  onDateRangeChanged: (range) {
    print('Selected range: ${range?.start} to ${range?.end}');
  },
)

// Inline calendar
VooDateTimePicker(
  mode: VooDateTimePickerMode.date,
  isInline: true,
  onDateTimeChanged: (dateTime) {
    print('Selected: $dateTime');
  },
)
```

### Custom Theme

```dart
VooCalendar(
  theme: VooCalendarTheme(
    backgroundColor: Colors.grey.shade900,
    headerBackgroundColor: Colors.black,
    selectedDayBackgroundColor: Colors.orange,
    todayBackgroundColor: Colors.orange.shade200,
    eventIndicatorColor: Colors.green,
    // ... more customization options
  ),
)
```

### Calendar Controller API

```dart
final controller = VooCalendarController();

// Navigate periods
controller.nextPeriod();
controller.previousPeriod();
controller.goToToday();

// Change views
controller.setView(VooCalendarView.week);

// Manage events
controller.addEvent(event);
controller.removeEvent(eventId);
controller.setEvents(eventsList);

// Get events for a date
final events = controller.getEventsForDate(DateTime.now());

// Selection
controller.selectDate(date);
controller.setSelectionMode(VooCalendarSelectionMode.multiple);
```

## 📊 Data Grid Remote Filtering

### API Standards Support

VooDataGrid supports **5 different API filtering standards** out of the box, making it compatible with virtually any backend:

1. **Simple REST** - Basic query parameters (most common)
2. **JSON:API** - Modern REST standard (used by GitHub, Stripe)
3. **OData** - Microsoft enterprise standard
4. **MongoDB/Elasticsearch** - NoSQL query DSL
5. **Custom** - Flexible custom format

### How Requests Look for Each Standard

#### 1. Simple REST
```http
GET /api/users?page=0&limit=20&status=active&age_gt=25&department_in=engineering,design&salary_from=50000&salary_to=100000&sort=name,-createdAt
```

#### 2. JSON:API Standard
```http
GET /api/users?page[number]=1&page[size]=20&filter[status]=active&filter[age][gt]=25&filter[department][in]=engineering,design&filter[salary][between]=50000,100000&sort=name,-createdAt
```

#### 3. OData Standard
```http
GET /api/users?$top=20&$skip=0&$filter=status eq 'active' and age gt 25 and (department eq 'engineering' or department eq 'design') and (salary ge 50000 and salary le 100000)&$orderby=name asc,createdAt desc
```

#### 4. MongoDB/Elasticsearch Style (POST)
```json
POST /api/users/search
{
  "from": 0,
  "size": 20,
  "query": {
    "bool": {
      "must": [
        { "term": { "status": "active" } },
        { "range": { "age": { "gt": 25 } } },
        { "terms": { "department": ["engineering", "design"] } },
        { "range": { "salary": { "gte": 50000, "lte": 100000 } } }
      ]
    }
  },
  "sort": [
    { "name": { "order": "asc" } },
    { "createdAt": { "order": "desc" } }
  ]
}
```

#### 5. Custom Format (Default)
```json
POST /api/users
{
  "pagination": {
    "page": 0,
    "pageSize": 20,
    "offset": 0,
    "limit": 20
  },
  "filters": [
    { "field": "status", "operator": "eq", "value": "active" },
    { "field": "age", "operator": "gt", "value": 25 },
    { "field": "department", "operator": "in", "values": ["engineering", "design"] },
    { "field": "salary", "operator": "between", "value": 50000, "valueTo": 100000 }
  ],
  "sorts": [
    { "field": "name", "direction": "asc" },
    { "field": "createdAt", "direction": "desc" }
  ]
}
```

### Using the Standard API Request Builder

#### Basic Usage

```dart
import 'package:voo_ui/voo_ui.dart';

// Build complete request body for POST requests
final requestBody = DataGridRequestBuilder.buildRequestBody(
  page: 0,
  pageSize: 20,
  filters: {
    'status': VooDataFilter(
      operator: VooFilterOperator.equals,
      value: 'active',
    ),
    'created': VooDataFilter(
      operator: VooFilterOperator.greaterThan,
      value: DateTime(2024, 1, 1),
    ),
  },
  sorts: [
    VooColumnSort(field: 'name', direction: VooSortDirection.ascending),
    VooColumnSort(field: 'created', direction: VooSortDirection.descending),
  ],
  additionalParams: {
    'includeDeleted': false,
    'expand': ['profile', 'permissions'],
  },
);

// This generates:
// {
//   "pagination": {
//     "page": 0,
//     "pageSize": 20,
//     "offset": 0,
//     "limit": 20
//   },
//   "filters": [
//     {
//       "field": "status",
//       "operator": "eq",
//       "value": "active"
//     },
//     {
//       "field": "created",
//       "operator": "gt",
//       "value": "2024-01-01T00:00:00.000"
//     }
//   ],
//   "sorts": [
//     {"field": "name", "direction": "asc"},
//     {"field": "created", "direction": "desc"}
//   ],
//   "metadata": {
//     "includeDeleted": false,
//     "expand": ["profile", "permissions"]
//   }
// }
```

#### Query Parameters for GET Requests

```dart
// Build query parameters for GET requests
final queryParams = DataGridRequestBuilder.buildQueryParams(
  page: 0,
  pageSize: 20,
  filters: filters,
  sorts: sorts,
);

// Use with your HTTP client
final response = await http.get(
  Uri.parse('https://api.example.com/users').replace(
    queryParameters: queryParams,
  ),
);
```

#### Custom Remote Data Source

```dart
class UserDataSource extends VooDataGridSource {
  final Dio dio;
  final String apiEndpoint;

  UserDataSource({
    required this.dio,
    required this.apiEndpoint,
  }) : super(mode: VooDataGridMode.remote);

  @override
  Future<VooDataGridResponse> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    // Build request using the utility
    final requestBody = DataGridRequestBuilder.buildRequestBody(
      page: page,
      pageSize: pageSize,
      filters: filters,
      sorts: sorts,
    );

    // Make API call
    final response = await dio.post(
      apiEndpoint,
      data: requestBody,
    );

    // Parse response using the utility
    return DataGridRequestBuilder.parseResponse(
      json: response.data,
      dataKey: 'users',      // Key containing array of records
      totalKey: 'totalCount', // Key containing total count
      pageKey: 'currentPage', // Optional: page number in response
      pageSizeKey: 'pageSize', // Optional: page size in response
    );
  }
}
```

#### Filter Operators

The request builder supports all standard filter operators with API-friendly string representations:

| Operator | API String | Usage |
|----------|------------|-------|
| equals | `eq` | Exact match |
| notEquals | `ne` | Not equal |
| contains | `contains` | Text contains |
| notContains | `not_contains` | Text doesn't contain |
| startsWith | `starts_with` | Text starts with |
| endsWith | `ends_with` | Text ends with |
| greaterThan | `gt` | Greater than |
| greaterThanOrEqual | `gte` | Greater than or equal |
| lessThan | `lt` | Less than |
| lessThanOrEqual | `lte` | Less than or equal |
| between | `between` | Range (requires `valueTo`) |
| inList | `in` | Value in list |
| notInList | `not_in` | Value not in list |
| isNull | `is_null` | Is null |
| isNotNull | `is_not_null` | Is not null |

#### Complete Example with Error Handling

```dart
class ProductDataSource extends VooDataGridSource {
  final String baseUrl = 'https://api.example.com';
  final Dio dio;

  ProductDataSource({required this.dio}) : super(mode: VooDataGridMode.remote);

  @override
  Future<VooDataGridResponse> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    try {
      // Build request
      final requestBody = DataGridRequestBuilder.buildRequestBody(
        page: page,
        pageSize: pageSize,
        filters: filters,
        sorts: sorts,
        additionalParams: {
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );

      // Make API call with proper headers
      final response = await dio.post(
        '$baseUrl/products/search',
        data: requestBody,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // Parse and return response
      return DataGridRequestBuilder.parseResponse(
        json: response.data,
        dataKey: 'products',
        totalKey: 'total',
      );
    } on DioException catch (e) {
      // Handle API errors
      print('API Error: ${e.message}');
      return const VooDataGridResponse(
        rows: [],
        totalRows: 0,
        page: 0,
        pageSize: 20,
      );
    }
  }
}
```

## 📊 Data Grid Examples

### Responsive Data Grid

The data grid automatically adapts to different screen sizes:

```dart
VooDataGrid(
  controller: _controller,
  displayMode: VooDataGridDisplayMode.auto, // Automatically switches between table and card view
  mobilePriorityColumns: ['name', 'email', 'status'], // Columns to show on mobile
  cardBuilder: (context, row, index) { // Optional custom card builder for mobile
    return Card(
      child: ListTile(
        title: Text(row['name']),
        subtitle: Text(row['email']),
        trailing: StatusBadge(status: row['status']),
      ),
    );
  },
  onRowTap: (row) {
    // On mobile, shows bottom sheet; on desktop, shows dialog
    if (MediaQuery.of(context).size.width < 600) {
      _showMobileDetails(context, row);
    } else {
      _showDesktopDetails(context, row);
    }
  },
)
```

### Display Modes

```dart
// Force specific display mode
VooDataGrid(
  controller: _controller,
  displayMode: VooDataGridDisplayMode.cards, // Always show as cards
  // or VooDataGridDisplayMode.table for always table
  // or VooDataGridDisplayMode.auto for responsive
)
```

### Mobile Filters

The data grid uses Material Design 3 patterns for filters on different screen sizes:

**Mobile (< 600px):**
- Filters open in a **modal bottom sheet**
- Active filters shown as **chips** below toolbar
- Touch-friendly controls with large tap targets
- Apply/Cancel buttons for batch filtering

**Tablet (600-900px):**
- Filters also use bottom sheet for consistency
- More columns visible than mobile
- Filter chips show active filters

**Desktop (> 900px):**
- **Inline filter row** below headers
- Real-time filtering as you type
- All columns visible

```dart
// The data grid automatically handles filters based on screen size
VooDataGrid(
  controller: _controller,
  // No special configuration needed - filters adapt automatically!
)

// Access filters programmatically
controller.dataSource.applyFilter(
  'status',
  VooDataFilter(
    operator: VooFilterOperator.equals,
    value: 'active',
  ),
);

// Clear all filters
controller.dataSource.clearFilters();
```

### Basic Data Grid

```dart
class DataGridExample extends StatefulWidget {
  @override
  State<DataGridExample> createState() => _DataGridExampleState();
}

class _DataGridExampleState extends State<DataGridExample> {
  late final UserDataSource _dataSource;
  late final VooDataGridController _controller;

  @override
  void initState() {
    super.initState();
    _dataSource = UserDataSource();
    _controller = VooDataGridController(dataSource: _dataSource);
  }

  @override
  Widget build(BuildContext context) {
    return VooDataGrid(
      controller: _controller,
      columns: [
        VooDataColumn(
          field: 'id',
          label: 'ID',
          width: 80,
          frozen: true,
          dataType: VooDataColumnType.number,
        ),
        VooDataColumn(
          field: 'name',
          label: 'Name',
          dataType: VooDataColumnType.text,
          filterHint: 'Search by name...',
        ),
        VooDataColumn(
          field: 'email',
          label: 'Email',
          dataType: VooDataColumnType.text,
        ),
        VooDataColumn(
          field: 'role',
          label: 'Role',
          dataType: VooDataColumnType.select,
          filterOptions: [
            VooFilterOption(value: 'admin', label: 'Admin', icon: Icons.admin_panel_settings),
            VooFilterOption(value: 'user', label: 'User', icon: Icons.person),
            VooFilterOption(value: 'moderator', label: 'Moderator', icon: Icons.shield),
          ],
        ),
        VooDataColumn(
          field: 'status',
          label: 'Status',
          dataType: VooDataColumnType.select,
          cellBuilder: (context, value, row) {
            final color = value == 'active' ? Colors.green : Colors.grey;
            return Row(
              children: [
                Icon(Icons.circle, size: 10, color: color),
                const SizedBox(width: 8),
                Text(value, style: TextStyle(color: color)),
              ],
            );
          },
        ),
        VooDataColumn(
          field: 'lastLogin',
          label: 'Last Login',
          dataType: VooDataColumnType.date,
          valueFormatter: (value) {
            if (value is DateTime) {
              final diff = DateTime.now().difference(value);
              if (diff.inDays > 0) return '${diff.inDays} days ago';
              if (diff.inHours > 0) return '${diff.inHours} hours ago';
              return '${diff.inMinutes} minutes ago';
            }
            return 'Never';
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _dataSource.dispose();
    super.dispose();
  }
}
```

### Data Source Implementation

```dart
// Remote data source
class UserDataSource extends VooDataGridSource {
  UserDataSource() : super(mode: VooDataGridMode.remote);

  @override
  Future<VooDataGridResponse> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    // Make API call with filters and sorts
    final response = await api.getUsers(
      page: page,
      pageSize: pageSize,
      filters: filters,
      sorts: sorts,
    );
    
    return VooDataGridResponse(
      rows: response.data,
      totalRows: response.total,
      page: page,
      pageSize: pageSize,
    );
  }
}

// Local data source
class LocalDataSource extends VooDataGridSource {
  LocalDataSource() : super(mode: VooDataGridMode.local);
  
  void loadData(List<Map<String, dynamic>> data) {
    setLocalData(data);
  }
}

// Mixed mode (remote fetch, local filter/sort)
class MixedDataSource extends VooDataGridSource {
  MixedDataSource() : super(mode: VooDataGridMode.mixed);
  
  @override
  Future<VooDataGridResponse> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    // Fetch all data once, then filter/sort locally
    final response = await api.getAllData();
    return VooDataGridResponse(
      rows: response.data,
      totalRows: response.data.length,
      page: 0,
      pageSize: 999999,
    );
  }
}
```

## 🎨 Design System Usage

### Accessing Design Tokens

```dart
Widget build(BuildContext context) {
  final design = context.vooDesign;
  
  return Container(
    padding: EdgeInsets.all(design.spacingMd),
    margin: EdgeInsets.symmetric(horizontal: design.spacingLg),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(design.radiusMd),
      color: Theme.of(context).colorScheme.surface,
    ),
    child: Column(
      children: [
        Icon(Icons.star, size: design.iconSizeLg),
        SizedBox(height: design.spacingMd),
        Text(
          'Content',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    ),
  );
}
```

### Custom Design System

```dart
VooDesignSystem(
  spacingUnit: 4.0,
  radiusUnit: 4.0,
  animationDurationUnit: 100,
  child: MaterialApp(
    theme: VooTheme.light(
      primaryColor: Colors.blue,
      customColors: {
        'brand': Colors.purple,
        'success': Colors.green,
        'warning': Colors.orange,
        'danger': Colors.red,
      },
    ),
    home: MyApp(),
  ),
);
```

## 🔮 Roadmap & Future Widgets

### Version 0.2.0
- ✅ **VooDataGrid**: Advanced data grid with filtering and sorting
- 🚧 **VooChart**: Custom-built interactive charts with animations
- 🚧 **VooCalendar**: Material 3 calendar with event support
- 🚧 **VooDatePicker**: Enhanced date picker with range selection
- 🚧 **VooTimePicker**: Material 3 time picker
- 🚧 **VooStepper**: Horizontal and vertical steppers
- 🚧 **VooTimeline**: Timeline component with custom markers

### Version 0.3.0
- **VooAvatar**: Avatar with online status and groups
- **VooChip**: Material 3 chips (input, choice, filter, action)
- **VooTooltip**: Rich tooltips with custom content
- **VooBadge**: Notification badges with animations
- **VooTabs**: Enhanced tab bar with custom indicators
- **VooBottomSheet**: Draggable bottom sheet with snap points
- **VooNavigationRail**: Adaptive navigation for tablets

### Version 0.4.0
- **VooSpeedDial**: FAB with speed dial actions
- **VooDataTable**: Simplified table for basic use cases
- **VooTreeView**: Expandable tree view component
- **VooKanban**: Drag-and-drop kanban board
- **VooGanttChart**: Project timeline visualization
- **VooSlider**: Enhanced slider with custom thumbs
- **VooRating**: Star rating component

### Version 0.5.0
- **VooForm**: Form builder with validation
- **VooWizard**: Multi-step wizard with progress
- **VooUploader**: File upload with progress and preview
- **VooImageViewer**: Image gallery with zoom
- **VooVideoPlayer**: Custom video player controls
- **VooAudioPlayer**: Audio player with waveform
- **VooColorPicker**: Material 3 color picker

### Version 1.0.0
- **VooRichTextEditor**: WYSIWYG editor
- **VooCodeEditor**: Syntax highlighted code editor
- **VooMarkdownViewer**: Markdown renderer
- **VooMaps**: Map integration with markers
- **VooGraphEditor**: Node-based graph editor
- **VooDashboard**: Dashboard builder components
- **VooAnalytics**: Analytics dashboard widgets

## 📖 API Documentation

### Design System Properties

#### Spacing Values
```dart
context.vooDesign.spacingXs   // 4.0
context.vooDesign.spacingSm   // 8.0
context.vooDesign.spacingMd   // 12.0
context.vooDesign.spacingLg   // 16.0
context.vooDesign.spacingXl   // 24.0
context.vooDesign.spacingXxl  // 32.0
context.vooDesign.spacingXxxl // 48.0
```

#### Border Radius
```dart
context.vooDesign.radiusXs   // 2.0
context.vooDesign.radiusSm   // 4.0
context.vooDesign.radiusMd   // 8.0
context.vooDesign.radiusLg   // 12.0
context.vooDesign.radiusXl   // 16.0
context.vooDesign.radiusXxl  // 24.0
context.vooDesign.radiusFull // 999.0
```

#### Component Sizes
```dart
context.vooDesign.iconSizeSm  // 16.0
context.vooDesign.iconSizeMd  // 20.0
context.vooDesign.iconSizeLg  // 24.0
context.vooDesign.iconSizeXl  // 32.0
context.vooDesign.iconSizeXxl // 48.0
```

#### Animation
```dart
context.vooDesign.animationDuration     // 300ms
context.vooDesign.animationDurationFast // 150ms
context.vooDesign.animationDurationSlow // 500ms
context.vooDesign.animationCurve        // Curves.easeInOut
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup

1. Clone the repository
2. Run `flutter pub get`
3. Run tests with `flutter test`
4. Submit a pull request

### Code Style

- Follow Effective Dart guidelines
- Use the provided linter rules
- Add dartdoc comments for public APIs
- Include examples for new components

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

- **Documentation**: [https://voo-ui-docs.com](https://voo-ui-docs.com)
- **Issues**: [GitHub Issues](https://github.com/yourusername/voo_ui/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/voo_ui/discussions)

## 📊 Package Stats

![Pub Version](https://img.shields.io/pub/v/voo_ui)
![Pub Likes](https://img.shields.io/pub/likes/voo_ui)
![Pub Points](https://img.shields.io/pub/points/voo_ui)
![Pub Popularity](https://img.shields.io/pub/popularity/voo_ui)

---

Made with ❤️ by the Voo Team