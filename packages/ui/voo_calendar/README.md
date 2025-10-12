# voo_calendar

Advanced calendar widget for Flutter with multiple view modes and customization options.

## Features

- **Multiple View Modes**: Month, week, day, year, and schedule views
- **Event Management**: Display and manage calendar events
- **Selection Modes**: Single, multiple, and range selection
- **Customization**: Highly customizable themes and styles
- **Localization**: Built-in support for multiple languages
- **Performance**: Optimized for smooth scrolling and interaction
- **Gestures**: Swipe navigation and pinch-to-zoom support

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  voo_calendar: ^0.2.0
  voo_ui_core: ^0.1.0
```

## Usage

### Basic Example

```dart
import 'package:voo_calendar/voo_calendar.dart';

VooCalendar(
  initialDate: DateTime.now(),
  view: VooCalendarView.month,
  onDateSelected: (date) {
    print('Selected date: $date');
  },
)
```

### With Events

```dart
VooCalendar(
  initialDate: DateTime.now(),
  events: [
    VooCalendarEvent(
      id: '1',
      title: 'Meeting',
      startTime: DateTime(2024, 1, 15, 10, 0),
      endTime: DateTime(2024, 1, 15, 11, 0),
      color: Colors.blue,
    ),
    VooCalendarEvent(
      id: '2',
      title: 'Lunch',
      startTime: DateTime(2024, 1, 15, 12, 0),
      endTime: DateTime(2024, 1, 15, 13, 0),
      color: Colors.green,
    ),
  ],
  onEventTap: (event) {
    print('Tapped event: ${event.title}');
  },
)
```

### With Controller

```dart
final controller = VooCalendarController();

VooCalendar(
  controller: controller,
  view: VooCalendarView.month,
  selectionMode: VooCalendarSelectionMode.range,
  onRangeSelected: (start, end) {
    print('Selected range: $start to $end');
  },
)

// Programmatically control the calendar
controller.goToDate(DateTime(2024, 6, 1));
controller.changeView(VooCalendarView.week);
controller.selectDate(DateTime(2024, 6, 15));
```

### Custom Theme

```dart
VooCalendar(
  theme: VooCalendarTheme(
    backgroundColor: Colors.white,
    headerColor: Colors.blue,
    headerTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    weekdayTextStyle: TextStyle(
      color: Colors.grey,
      fontSize: 14,
    ),
    dayTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 16,
    ),
    selectedDayColor: Colors.blue,
    todayColor: Colors.red,
    eventColor: Colors.green,
  ),
)
```

## View Modes

### Month View
Shows a traditional month calendar grid with all days of the month.

### Week View
Displays a single week with hourly time slots for detailed scheduling.

### Day View
Shows a single day with hourly breakdown for precise event planning.

**Customization Options:**
- Add trailing widgets to hour lines for quick actions
- Show only hours with events for a compact view
- Dynamic height adjustment for overlapping events
- Column-based layout for side-by-side events (Google Calendar style)
- Comprehensive spacing and positioning controls

```dart
VooCalendar(
  initialView: VooCalendarView.day,
  dayViewConfig: VooDayViewConfig(
    // Add action buttons to each hour line
    hourLineTrailingBuilder: (context, hour) {
      return IconButton(
        icon: const Icon(Icons.add_circle_outline),
        onPressed: () => addEventAt(hour),
        tooltip: 'Add event',
      );
    },
    // Show only hours that have events
    showOnlyHoursWithEvents: true,
    // Enable dynamic height for overlapping events
    enableDynamicHeight: true,
    // Enable column layout for side-by-side events
    enableColumnLayout: true,
    // Customize spacing and positioning
    minEventHeight: 60.0,
    eventSpacing: 8.0,
    eventLeftPadding: 8.0,
    eventRightPadding: 8.0,
    trailingBuilderWidth: 48, // Reserve space for trailing widgets
  ),
)
```

### Custom Event Widgets

For custom event rendering with proper dimension handling (recommended for day view), extend `VooCalendarEventWidget` or use `eventBuilderWithInfo`.

#### Why Use Custom Event Widgets?

When using custom widgets (like domain-specific UI for meals, workouts, product logs, etc.), you need to ensure they respect the calendar's allocated dimensions. This is especially important for:
- ✅ Dynamic height layouts (overlapping events stacking correctly)
- ✅ Column layouts (side-by-side events on desktop)
- ✅ Mobile vs desktop responsiveness

#### Approach 1: Extending `VooCalendarEventWidget` (Recommended)

Create a reusable custom event widget class by extending `VooCalendarEventWidget`:

```dart
import 'package:voo_calendar/voo_calendar.dart';

/// Custom event widget for product logs in a nutrition tracking app
class ProductLogEventWidget extends VooCalendarEventWidget {
  final ProductLog productLog;

  const ProductLogEventWidget({
    super.key,
    required super.event,
    required super.renderInfo,
    required this.productLog,
  });

  @override
  Widget buildContent(BuildContext context) {
    // VooCalendarEventWidget automatically handles sizing and overflow protection
    // You just build your content here
    return Container(
      decoration: BoxDecoration(
        color: event.color?.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: event.color ?? Colors.grey),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (event.icon != null) ...[
                Icon(event.icon, size: 16),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: Text(
                  productLog.productName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${productLog.servings} servings • ${productLog.calories} cal',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
```

Then use your custom widget in the calendar:

```dart
VooCalendar(
  controller: controller,
  initialView: VooCalendarView.day,
  eventBuilderWithInfo: (context, event, renderInfo) {
    final productLog = event.metadata?['productLog'] as ProductLog?;
    if (productLog == null) return const SizedBox.shrink();

    return ProductLogEventWidget(
      event: event,
      renderInfo: renderInfo,
      productLog: productLog,
    );
  },
  dayViewConfig: const VooDayViewConfig(
    enableDynamicHeight: true,
    minEventHeight: 60.0,
    eventSpacing: 8.0,
  ),
)
```

#### Approach 2: Using `eventBuilderWithInfo` (Quick & Simple)

If you don't want to create a widget class, use `eventBuilderWithInfo` directly:

```dart
VooCalendar(
  initialView: VooCalendarView.day,
  eventBuilderWithInfo: (context, event, renderInfo) {
    // renderInfo provides:
    // - allocatedHeight: exact height for this event
    // - allocatedWidth: exact width (or null for full width)
    // - isMobile: whether it's mobile layout (<600px)
    // - isCompact: whether compact mode is enabled
    // - hourHeight: current hour slot height

    return SizedBox(
      height: renderInfo.allocatedHeight,
      width: renderInfo.allocatedWidth,
      child: YourCustomEventWidget(event: event),
    );
  },
  dayViewConfig: const VooDayViewConfig(
    enableDynamicHeight: true, // Events auto-stack without overlap
    enableColumnLayout: true,  // Side-by-side on desktop
  ),
)
```

#### Real-World Example: Nutrition Diary

```dart
class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  late final VooCalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = VooCalendarController(
      initialDate: DateTime.now(),
      initialView: VooCalendarView.day,
    );
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  List<VooCalendarEvent> _convertLogsToEvents(List<ProductLog> logs) {
    return logs.map((log) {
      return VooCalendarEvent(
        id: log.id,
        title: log.productName,
        description: '${log.servings} servings',
        startTime: log.consumedAt,
        endTime: log.consumedAt.add(const Duration(minutes: 30)),
        color: _getColorForMealType(log.mealType),
        icon: _getIconForMealType(log.mealType),
        metadata: {'productLog': log}, // Store domain object
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiaryBloc, DiaryState>(
      builder: (context, state) {
        final events = _convertLogsToEvents(state.productLogs);
        _calendarController.setEvents(events);

        return VooCalendar(
          controller: _calendarController,
          initialView: VooCalendarView.day,

          // Use VooCalendarEventWidget for automatic dimension handling
          eventBuilderWithInfo: (context, event, renderInfo) {
            final productLog = event.metadata?['productLog'] as ProductLog?;
            if (productLog == null) return const SizedBox.shrink();

            return ProductLogEventWidget(
              event: event,
              renderInfo: renderInfo,
              productLog: productLog,
              onTap: () => _editProductLog(productLog),
            );
          },

          dayViewConfig: const VooDayViewConfig(
            hourHeight: 80.0,
            enableDynamicHeight: true, // Auto-expand hours with multiple events
            enableColumnLayout: true,  // Side-by-side on desktop
            minEventHeight: 60.0,      // Minimum height per event
            eventSpacing: 8.0,         // Space between stacked events
          ),
        );
      },
    );
  }
}
```

#### Key Benefits

- ✅ **Automatic Sizing**: Your widgets always fit properly
- ✅ **No Overlap**: Events stack correctly on mobile
- ✅ **Responsive**: Auto-adapts to mobile vs desktop layouts
- ✅ **Type-Safe**: Access your domain objects via metadata
- ✅ **Reusable**: Create widget classes for different event types

### Year View
Provides an overview of the entire year with month grids.

### Schedule View
Lists events in a chronological list format.

## Components

### Main Components
- `VooCalendar` - Main calendar widget
- `VooCalendarController` - Calendar controller for programmatic control
- `VooCalendarTheme` - Theme configuration
- `VooCalendarEvent` - Event data model

### View Implementations
- `VooCalendarMonthView` - Month view implementation
- `VooCalendarWeekView` - Week view implementation
- `VooCalendarDayView` - Day view implementation
- `VooCalendarYearView` - Year view implementation
- `VooCalendarScheduleView` - Schedule view implementation

### Configuration Classes
- `VooDayViewConfig` - Day view configuration with 20+ customization options
- `VooWeekViewConfig` - Week view configuration
- `VooMonthViewConfig` - Month view configuration
- `VooYearViewConfig` - Year view configuration
- `VooScheduleViewConfig` - Schedule view configuration

## Selection Modes

- **None**: No selection allowed
- **Single**: Select a single date
- **Multiple**: Select multiple dates
- **Range**: Select a date range

## Customization

The calendar is highly customizable through the `VooCalendarTheme` class. You can customize:

- Colors (background, header, selection, today marker)
- Text styles (header, weekdays, days, events)
- Spacing and padding
- Border styles
- Event indicators

## License

MIT