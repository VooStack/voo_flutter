## 0.4.2

### 🧹 Code Quality Improvements

**Example App Formatting** - Applied automatic code formatting to example app for better consistency:

#### Improvements:
- **IMPROVE**: Applied linter formatting to advanced_examples_page.dart
- **IMPROVE**: Condensed method calls and widget constructors to single line
- **IMPROVE**: Removed unnecessary line breaks for better readability
- **IMPROVE**: Improved code consistency across example application

No functional changes - purely formatting improvements to example code.

## 0.4.1

### 🐛 Code Quality Improvements

**Linter Formatting** - Applied automatic code formatting for consistency:

#### Improvements:
- **IMPROVE**: Applied linter formatting to VooCalendarEventWidget
- **IMPROVE**: Condensed constructor parameters to single line for better readability
- **IMPROVE**: Improved code consistency across the package

No functional changes - purely formatting improvements.

## 0.4.0

### 🔄 Major API Refactor - Composition Over Inheritance

**VooCalendarEventWidget Refactored to Composition Pattern** - Following Flutter best practices and rules.md principles:

#### Breaking Changes:
- **BREAKING**: `VooCalendarEventWidget` is no longer an abstract class
  - **Old** (inheritance): Extend class and override `buildContent()`
  - **New** (composition): Use `child` or `builder` parameters
  - Migration is simple - see guide below

#### Why This Change:
- ✅ **Composition over inheritance** - Core principle from rules.md
- ✅ **Flutter best practice** - Follows pattern of AnimatedBuilder, ValueListenableBuilder
- ✅ **Less boilerplate** - No need to create classes for simple wrappers
- ✅ **More flexible** - Choose between child or builder based on needs
- ✅ **Better DX** - Cleaner, more intuitive API

####New API:

**Approach 1: Builder (when you need event data)**
```dart
VooCalendarEventWidget(
  event: event,
  renderInfo: renderInfo,
  builder: (context, event, renderInfo) {
    return ProductLogListTile(productLog: event.metadata['productLog']);
  },
)
```

**Approach 2: Child (when you don't need event data)**
```dart
VooCalendarEventWidget(
  renderInfo: renderInfo,
  child: ProductLogListTile(productLog: productLog),
)
```

### Migration Guide:

**Before (0.3.x):**
```dart
class ProductEventWidget extends VooCalendarEventWidget {
  final ProductLog productLog;

  const ProductEventWidget({
    super.key,
    required super.event,
    required super.renderInfo,
    required this.productLog,
  });

  @override
  Widget buildContent(BuildContext context) {
    return ProductLogListTile(productLog: productLog);
  }
}

// Usage
return ProductEventWidget(
  event: event,
  renderInfo: renderInfo,
  productLog: productLog,
);
```

**After (0.4.0):**
```dart
// No class needed! Use builder directly
return VooCalendarEventWidget(
  event: event,
  renderInfo: renderInfo,
  builder: (context, event, renderInfo) {
    final productLog = event.metadata?['productLog'] as ProductLog;
    return ProductLogListTile(productLog: productLog);
  },
);
```

### Benefits:
- Less code to maintain
- No inheritance hierarchies
- Follows Flutter conventions
- Easier to understand and use

## 0.3.4

### 📚 Documentation & Example Improvements

**Enhanced Custom Event Widget Examples** - Improved developer experience with better examples and navigation:

#### New Features:
- **FEAT**: Added "Advanced Examples" section to example app with dedicated navigation
- **FEAT**: Interactive custom event height example showing problem vs solution side-by-side
- **FEAT**: `ProductEventWidget` class demonstrating VooCalendarEventWidget extension pattern
- **FEAT**: Example includes 6 events with overlapping times (breakfast & snack scenarios)
- **FEAT**: Mobile-friendly drawer navigation for 6+ top-level destinations

#### Improvements:
- **IMPROVE**: Example app now uses drawer on mobile instead of bottom navigation (fixes overflow)
- **IMPROVE**: Custom event height example starts at 8 AM to show events immediately
- **IMPROVE**: Visual debugging borders show allocated space for events
- **IMPROVE**: Compact widget sizing with scrollable content for better space utilization
- **IMPROVE**: Clear documentation of VooCalendarEventWidget as the recommended approach

#### Bug Fixes:
- **FIX**: Navigation overflow on mobile devices with 6 tabs
- **FIX**: Custom event content overflow in example
- **FIX**: Events not visible on initial load in custom height example

### Use Cases:
Perfect for developers learning how to implement custom event widgets (ProductLogListTile, meal entries, workout cards, etc.) that properly respect calendar layout constraints and don't overflow into other hour slots.

## 0.3.3

### 🔄 API Improvements - Better Naming

**Renamed `BaseCalendarEventWidget` → `VooCalendarEventWidget`** - Improved naming to follow package conventions:

#### Breaking Changes:
- **BREAKING**: `BaseCalendarEventWidget` renamed to `VooCalendarEventWidget`
  - Migration: Simply rename `extends BaseCalendarEventWidget` to `extends VooCalendarEventWidget`
  - All functionality remains identical

#### Improvements:
- **IMPROVE**: Better discoverability - follows `Voo*` naming pattern
- **IMPROVE**: Enhanced documentation with usage examples in class docs
- **IMPROVE**: README reorganized to show `VooCalendarEventWidget` as the primary approach
- **IMPROVE**: Clearer API that communicates official widget for custom events

#### Why This Change:
- Follows package naming conventions (`VooCalendar`, `VooCalendarEvent`, `VooCalendarEventWidget`)
- Makes it clear this is the official widget for extending calendar events
- More developer-friendly and easier to discover

### Migration Guide:
```dart
// Before (0.3.2)
class MyEventWidget extends BaseCalendarEventWidget {
  ...
}

// After (0.3.3)
class MyEventWidget extends VooCalendarEventWidget {
  ...
}
```

## 0.3.2

### ✨ Custom Event Widget Support with Proper Dimension Handling

**New Builder API for Custom Events** - Added proper support for custom event widgets that respect calendar layout dimensions:

#### New Features:
- **FEAT**: `eventBuilderWithInfo` - New event builder that provides render info (allocated dimensions, layout context)
- **FEAT**: `VooCalendarEventRenderInfo` - Data class containing allocated height, width, and layout context
- **FEAT**: `VooCalendarEventWidget` - Abstract base class for creating custom event widgets
- **FEAT**: Automatic dimension handling for custom events in day view
- **FEAT**: Support for custom widgets that properly respect dynamic height and column layouts

#### Problem Solved:
- **FIX**: Custom event widgets (like `ProductLogListTile`) now work correctly with dynamic height
- **FIX**: Events with custom builders no longer ignore allocated dimensions
- **FIX**: Overlapping custom events now stack properly on mobile without overlap
- **FIX**: Custom widgets respect column layout widths on desktop

#### API Changes:
```dart
// OLD: eventBuilder (still works, but doesn't provide dimensions)
VooCalendar(
  eventBuilder: (context, event) => MyCustomWidget(event),
)

// NEW: eventBuilderWithInfo (quick approach)
VooCalendar(
  eventBuilderWithInfo: (context, event, renderInfo) {
    return SizedBox(
      height: renderInfo.allocatedHeight,
      width: renderInfo.allocatedWidth,
      child: MyCustomWidget(event),
    );
  },
)

// BEST: Extend VooCalendarEventWidget (recommended)
class MyEventWidget extends VooCalendarEventWidget {
  @override
  Widget buildContent(BuildContext context) {
    return MyCustomWidget(event);
  }
}
```

#### File Structure (Following Rules.md):
```
lib/src/
├── domain/entities/
│   └── voo_calendar_event_render_info.dart (NEW)
└── presentation/atoms/
    └── voo_calendar_event_widget.dart (NEW)
```

#### Use Cases:
- Custom event widgets that need proper sizing in day view
- Product logs, meal entries, workout sessions, etc.
- Any domain-specific event representation
- Widgets that need to adapt to mobile vs desktop layouts

### Verification:
- ✅ All tests pass
- ✅ Zero lint/analyze issues
- ✅ Follows rules.md (one class per file, clean architecture)
- ✅ Backward compatible (old `eventBuilder` still works)
- ✅ Example implementation provided

## 0.3.1

### 🐛 Critical Bug Fixes & Architecture Improvements

**Mobile Day View Event Stacking** - Fixed critical bug where overlapping events were not displaying correctly on mobile:

#### Fixed Issues:
- **FIX**: Fixed mobile day view event stacking bug where duplicate events with identical times overlapped instead of stacking
  - **Root Cause**: `indexWhere()` was returning the same index (0) for all events with matching time+title, causing them to render at the same position
  - **Solution**: Implemented pre-calculated stack positions using `Map<VooCalendarEvent, int>` based on sort order
  - **Impact**: All overlapping events now display correctly without overlap on mobile devices
- **FIX**: Events with identical start times now stack vertically with proper spacing
- **FIX**: Each event receives a unique vertical position based on its index in the sorted events list

#### Code Quality & Architecture:
- **IMPROVE**: Refactored calendar views to follow rules.md one-class-per-file principle
  - Split `calendar_views.dart` (6 classes) into individual files
  - Each view now in dedicated file: `voo_calendar_month_view.dart`, `voo_calendar_week_view.dart`, etc.
- **IMPROVE**: Split `EventCardWidget` and `ScheduleEventCardWidget` into separate files
- **IMPROVE**: Organized files following atomic design pattern in `presentation/organisms/`
- **IMPROVE**: Updated `calendar_views.dart` to barrel export file for all view widgets
- **IMPROVE**: Created comprehensive test infrastructure following atomic design
  - Added `test/helpers/test_helpers.dart` for shared test utilities
  - Created `test/presentation/organisms/` structure for view tests
  - Test helpers support multiple screen sizes (mobile/tablet/desktop)

#### File Structure Changes:
```
lib/src/presentation/
├── atoms/
│   ├── event_card_widget.dart (cleaned)
│   └── schedule_event_card_widget.dart (NEW)
└── organisms/
    ├── voo_calendar_day_view.dart (NEW - with bug fix)
    ├── voo_calendar_month_view.dart (NEW)
    ├── voo_calendar_schedule_view.dart (NEW)
    ├── voo_calendar_week_view.dart (NEW)
    └── voo_calendar_year_view.dart (NEW)
```

#### Technical Details:
- Event stack positions are pre-calculated before rendering to ensure consistent positioning
- Sort order based on `startTime` comparison ensures deterministic event ordering
- Mobile detection uses `context.isMobile` for responsive behavior
- All changes maintain backward compatibility with existing API

### Verification:
- ✅ All tests pass
- ✅ Zero lint/analyze issues
- ✅ Follows rules.md conventions
- ✅ Mobile day view displays all 5 overlapping events correctly
- ✅ Events stack without overlap on all screen sizes

## 0.3.0

### 📱 Responsive Day View

**Intelligent Responsive Layout** - Day view now automatically adapts to screen size for optimal user experience:

#### ✨ New Features:
- **FEAT**: Automatic responsive layout detection using `voo_responsive` package
- **FEAT**: Mobile-optimized vertical stacking with dynamic height expansion (<600px width)
- **FEAT**: Desktop/tablet column layout with fixed hour heights (≥600px width)
- **FEAT**: Seamless transition between layout modes based on screen width

#### 📐 Mobile Behavior (<600px):
- Events stack vertically within their hour slots
- Hour slots automatically expand to fit all events without overlapping
- Dynamic height ensures all events are fully visible
- Perfect for touch interfaces with limited horizontal space

#### 💻 Desktop/Tablet Behavior (≥600px):
- Google Calendar-style column layout for overlapping events
- Events display side-by-side for better space utilization
- Fixed 80px hour heights for consistent visual rhythm
- Optimal for mouse/trackpad interaction with more screen real estate

#### 🔧 Implementation Details:
- Uses `context.isMobile` from `voo_responsive` for breakpoint detection
- Automatically enables dynamic height on mobile devices
- Column layout intelligently disabled on mobile to prevent cramped UI
- Minute-precise event positioning works across both layout modes

#### 🎯 Developer Experience:
- Zero configuration required - works automatically out of the box
- `enableColumnLayout` setting respected on desktop/tablet only
- Dynamic height expansion automatically enabled on mobile
- Consistent API across all screen sizes

### Use Case
Perfect for building responsive calendar applications that work seamlessly across all device types. The calendar automatically provides the best layout for each screen size without requiring conditional logic in your code.

## 0.2.0

### 🚀 Major Refactoring - Production-Grade Calendar

**Configuration-Based Architecture** - Complete refactoring to use configuration objects for better maintainability and scalability:

#### 💥 Breaking Changes:
- **BREAKING**: Removed individual day view parameters from `VooCalendar` constructor
  - ❌ `dayViewHourLineTrailingBuilder` → Use `dayViewConfig.hourLineTrailingBuilder`
  - ❌ `dayViewShowOnlyHoursWithEvents` → Use `dayViewConfig.showOnlyHoursWithEvents`
  - ❌ `dayViewEnableDynamicHeight` → Use `dayViewConfig.enableDynamicHeight`
  - ❌ `dayViewMinEventHeight` → Use `dayViewConfig.minEventHeight`
  - ❌ `dayViewEventSpacing` → Use `dayViewConfig.eventSpacing`

#### ✨ New Configuration Classes:
- **FEAT**: `VooDayViewConfig` - Comprehensive day view configuration with 20+ options
- **FEAT**: `VooWeekViewConfig` - Week view configuration for consistent customization
- **FEAT**: `VooMonthViewConfig` - Month view configuration with grid options
- **FEAT**: `VooYearViewConfig` - Year view layout configuration
- **FEAT**: `VooScheduleViewConfig` - Schedule view customization options

#### 🎨 Advanced Event Layout System:
- **FEAT**: Google Calendar-style column layout for overlapping events (`enableColumnLayout`)
- **FEAT**: Events can now be displayed side-by-side instead of just stacked
- **FEAT**: Intelligent overlap detection and grouping algorithm
- **FEAT**: Automatic column width calculation based on concurrent events
- **FEAT**: Configurable horizontal gaps between adjacent events (`eventHorizontalGap`)

#### 📐 Enhanced Spacing & Positioning:
- **FEAT**: `eventLeftPadding` - Left padding for events to prevent overlap with time labels (default: 8.0)
- **FEAT**: `eventRightPadding` - Right padding for events to prevent overlap with trailing builders (default: 8.0)
- **FEAT**: `eventTopPadding` - Top padding within hour slots (default: 4.0)
- **FEAT**: `eventBottomPadding` - Bottom padding within hour slots (default: 4.0)
- **FEAT**: `trailingBuilderWidth` - Reserved width for trailing builders to prevent event overlap (default: 0)

#### 🔧 Improved Dynamic Height:
- **FIX**: Dynamic height now properly calculates space for all overlapping events
- **FIX**: Events no longer overlap with `hourLineTrailingBuilder` widgets
- **FIX**: Better spacing calculation includes padding buffers for visual breathing room
- **IMPROVE**: `minEventHeight` default increased from 40.0 to 60.0 for better readability
- **IMPROVE**: `eventSpacing` default increased from 4.0 to 8.0 for improved visual hierarchy

#### 🎯 Production-Ready Features:
- **IMPROVE**: Cleaner API with grouped configuration objects
- **IMPROVE**: Better separation of concerns between calendar and view configurations
- **IMPROVE**: More intuitive parameter naming and organization
- **IMPROVE**: Enhanced documentation with clear examples
- **IMPROVE**: TypeScript-style config objects with `copyWith` methods

### Migration Guide

**Before (0.1.x):**
```dart
VooCalendar(
  dayViewHourLineTrailingBuilder: (context, hour) => Icon(Icons.add),
  dayViewShowOnlyHoursWithEvents: true,
  dayViewEnableDynamicHeight: true,
  dayViewMinEventHeight: 40.0,
  dayViewEventSpacing: 4.0,
)
```

**After (0.2.0):**
```dart
VooCalendar(
  dayViewConfig: VooDayViewConfig(
    hourLineTrailingBuilder: (context, hour) => Icon(Icons.add),
    showOnlyHoursWithEvents: true,
    enableDynamicHeight: true,
    enableColumnLayout: true,  // NEW: Google Calendar-style layout
    minEventHeight: 60.0,
    eventSpacing: 8.0,
    eventLeftPadding: 8.0,     // NEW: Prevent overlap with time labels
    eventRightPadding: 8.0,    // NEW: Prevent overlap with trailing builders
    trailingBuilderWidth: 48,  // NEW: Reserve space for trailing widgets
  ),
)
```

### Technical Improvements
- Implemented proper event layout algorithm using column-based positioning
- Added comprehensive padding system to prevent UI element overlaps
- Improved dynamic height calculation with proper spacing buffers
- Enhanced code organization with dedicated configuration classes
- Better type safety with structured configuration objects
- Reduced parameter pollution in main widget constructor

## 0.1.5

### 🐛 Bug Fixes

**Day View Time Label Alignment** - Fixed visual misalignment between time labels and events:

#### Fixed Issues:
- **FIX**: Corrected time label vertical alignment - Changed from `Alignment.centerRight` to `Alignment.topRight` to align labels with hour line boundaries
- **FIX**: Removed extra font line spacing by setting `height: 1.0` on time labels
- **FIX**: Added 2px upward offset using `Transform.translate` to compensate for font baseline positioning
- **FIX**: Time labels now perfectly align with event start positions

#### Visual Impact:
- Events starting at 09:00 now visually align exactly with the "09:00" label
- Eliminates the perception that events start 10 minutes before their actual time
- Matches standard calendar app conventions (Google Calendar, Apple Calendar, etc.)
- Consistent alignment between day view and week view time labels

### Technical Details
The fix addresses font rendering characteristics where Text widgets have intrinsic line height and baseline offsets that were causing time labels to appear centered in hour slots rather than aligned with the hour boundaries where events actually start.

## 0.1.4

### ✨ Dynamic Height for Day View

**Day View Dynamic Height** - Added intelligent height adjustment for overlapping events:

#### New Features:
- **FEAT**: `enableDynamicHeight` - Automatically expand hour slots to fit all overlapping events without cutting off content
- **FEAT**: `minEventHeight` - Set minimum height for events when using dynamic height mode (default: 40.0)
- **FEAT**: `eventSpacing` - Configure spacing between vertically stacked events (default: 4.0)
- **FEAT**: Smart overlap detection - Calculates maximum overlapping events per hour for optimal layout
- **FEAT**: Automatic event stacking - Events are intelligently positioned to avoid overlap

#### Implementation:
- Hour slots automatically expand based on the number of overlapping events
- Events are vertically stacked with customizable spacing
- Maintains minimum event height for readability
- Seamlessly integrates with existing day view customization options

#### VooCalendar Parameters:
- `dayViewEnableDynamicHeight` - Enable dynamic height adjustment
- `dayViewMinEventHeight` - Minimum height for each event
- `dayViewEventSpacing` - Spacing between stacked events

### Use Case
Perfect for busy schedules with multiple events in the same time slot. The view automatically adjusts to display all events clearly without overlapping or cutting off content.

## 0.1.3

### ✨ Major Customization Update

**Day View Customization** - Added 14 new customization parameters for VooCalendarDayView:

#### New Parameters:
- **FEAT**: `hourLineTrailingBuilder` - Add custom widgets to the trailing edge of hour lines
- **FEAT**: `hourLineLeadingBuilder` - Add custom widgets before time labels
- **FEAT**: `showOnlyHoursWithEvents` - Display only hours with scheduled events
- **FEAT**: `hourHeight` - Customize the height of each hour row (default: 60.0)
- **FEAT**: `timeLabelFormatter` - Custom time label formatting function
- **FEAT**: `initialScrollHour` - Set initial scroll position to specific hour
- **FEAT**: `scrollPhysics` - Custom scroll physics for day view
- **FEAT**: `showTimeLabels` - Toggle time label visibility
- **FEAT**: `timeColumnWidth` - Custom width for time column
- **FEAT**: `firstHour` - Set first hour to display (0-23)
- **FEAT**: `lastHour` - Set last hour to display (0-23)
- **FEAT**: `hourLineColor` - Custom color for hour separator lines
- **FEAT**: `hourLineThickness` - Custom thickness for hour separator lines
- **FEAT**: `onHourLineTap` - Callback when hour line is tapped

#### Enhanced Example App:
- **FEAT**: Interactive day view customization demos
- **FEAT**: Toggle switches for all new features
- **FEAT**: Sample events demonstrating customization options

### Bug Fixes
- **FIX**: Fixed RenderFlex overflow error in view switcher on small screens
- **FIX**: Centered alignment for time labels, hour lines, and trailing widgets in day view
- **FIX**: Event positioning now works correctly with custom hour heights
- **FIX**: Hour range filtering properly respects first/last hour settings

### UI/UX Improvements
- **IMPROVE**: View switcher now scrolls horizontally on narrow displays
- **IMPROVE**: Day view elements are now properly centered for better visual consistency
- **IMPROVE**: Hour lines are now tappable with optional callback
- **IMPROVE**: Time labels support custom formatting

### Breaking Changes
None - all new parameters are optional with sensible defaults

## 0.1.2

 - **FEAT**: add example modules and run configurations for VooFlutter packages.

## 0.1.1

 - **FIX**: ensure proper disposal of scroll controllers in VooDataGridController.
 - **FEAT**: Introduce voo_tokens package for design tokens and responsive utilities.
 - **FEAT**: Update changelog for version 0.4.0 with new features, bug fixes, and documentation improvements.
 - **FEAT**: Implement advanced filtering in VooDataGrid.
 - **FEAT**: Update LICENSE files to include full MIT License text.
 - **FEAT**: Implement Windows runner for Voo Data Grid example.

## 0.1.0

* Enhanced calendar widget with multiple view modes
* Added month, week, and day view support
* Implemented event management system with add, edit, and delete capabilities
* Added customizable event colors and categories
* Implemented drag-and-drop event rescheduling
* Added recurring event support
* Enhanced accessibility features
* Added localization support for multiple languages
* Improved performance with efficient rendering
* Added comprehensive theming and customization options

## 0.0.1

* Initial release of VooCalendar
* Basic calendar implementation with month view
* Simple event display functionality
* Date selection and navigation
