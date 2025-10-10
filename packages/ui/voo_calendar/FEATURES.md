# VooCalendar Features

## Day View Customization

### Hour Line Trailing Builder
Add custom widgets to the trailing edge of each hour line in day view.

**Use Cases:**
- Quick action buttons (e.g., add event)
- Status indicators
- Custom labels or badges
- Interactive controls

**Example:**
```dart
VooCalendar(
  dayViewHourLineTrailingBuilder: (context, hour) {
    return IconButton(
      icon: const Icon(Icons.add_circle_outline, size: 20),
      onPressed: () {
        // Add event at this hour
        print('Add event at $hour:00');
      },
      tooltip: 'Add event',
    );
  },
)
```

### Show Only Hours with Events
Display a compact day view showing only hours that have scheduled events.

**Use Cases:**
- Sparse schedules with few events
- Focus on busy hours
- Reduce scrolling
- Better space utilization

**Example:**
```dart
VooCalendar(
  dayViewShowOnlyHoursWithEvents: true,
)
```

**Behavior:**
- Filters hour rows to show only hours with events
- Maintains proper event positioning and timing
- Falls back to showing hour 0 if no events exist
- Events render at correct positions within visible hours

### Combined Usage
Both features can be used together for maximum customization:

```dart
VooCalendar(
  dayViewShowOnlyHoursWithEvents: true,
  dayViewHourLineTrailingBuilder: (context, hour) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('${_getEventCount(hour)} events'),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _addEventAt(hour),
        ),
      ],
    );
  },
)
```

## View Switcher Improvements

### Responsive Overflow Fix
The view switcher now handles small screens gracefully:
- Horizontal scrolling for narrow displays
- No overflow errors on mobile devices
- Smooth scrolling experience
- Maintains all view options

## Alignment Improvements

### Day View Alignment
All elements in day view are now perfectly centered:
- Time labels: vertically centered
- Hour lines: properly aligned
- Trailing widgets: vertically centered
- Consistent visual appearance

## Demo

See the example app's "Views" page for interactive demonstrations:
1. Switch to Day view
2. Toggle "Show Only Hours with Events" to see compact view
3. Toggle "Show Hour Line Actions" to see trailing widgets
4. Sample events demonstrate the features in action

## API Reference

### VooCalendar Parameters

#### dayViewHourLineTrailingBuilder
```dart
final Widget Function(BuildContext context, int hour)? dayViewHourLineTrailingBuilder;
```
Builder function for creating trailing widgets on hour lines in day view.
- **context**: Build context
- **hour**: Hour value (0-23)
- **Returns**: Widget to display at the end of the hour line

#### dayViewShowOnlyHoursWithEvents
```dart
final bool dayViewShowOnlyHoursWithEvents;
```
When true, day view only displays hours that contain events.
- **Default**: `false`
- **Type**: `bool`

## Implementation Details

### Files Modified
1. `/lib/src/calendar.dart` - Added parameters and fixed overflow
2. `/lib/src/calendar_views.dart` - Implemented day view features
3. `/example/lib/pages/calendar_views_page.dart` - Added demo

### Key Changes
- Wrapped SegmentedButton in SingleChildScrollView for overflow fix
- Added hour filtering logic in VooCalendarDayView
- Implemented trailing widget rendering in hour grid
- Updated event positioning for filtered hours
- Centered alignment for time labels and widgets

## Migration Guide

No breaking changes. All new features are opt-in with sensible defaults:
- `dayViewHourLineTrailingBuilder` defaults to `null` (no trailing widgets)
- `dayViewShowOnlyHoursWithEvents` defaults to `false` (show all hours)

Existing code continues to work without modifications.
