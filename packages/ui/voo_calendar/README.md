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
  voo_calendar: ^0.1.0
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

### Year View
Provides an overview of the entire year with month grids.

### Schedule View
Lists events in a chronological list format.

## Components

- `VooCalendar` - Main calendar widget
- `VooCalendarController` - Calendar controller for programmatic control
- `VooCalendarTheme` - Theme configuration
- `VooCalendarEvent` - Event data model
- `VooCalendarMonthView` - Month view implementation
- `VooCalendarWeekView` - Week view implementation
- `VooCalendarDayView` - Day view implementation
- `VooCalendarYearView` - Year view implementation
- `VooCalendarScheduleView` - Schedule view implementation

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