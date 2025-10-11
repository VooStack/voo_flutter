import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'calendar.dart';
import 'calendar_theme.dart';
import 'calendar_config.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Month view for VooCalendar
class VooCalendarMonthView extends StatefulWidget {
  final VooCalendarController controller;
  final VooCalendarTheme theme;
  final int firstDayOfWeek;
  final bool showWeekNumbers;
  final void Function(DateTime date) onDateSelected;
  final void Function(VooCalendarEvent event)? onEventTap;
  final Widget Function(
    BuildContext context,
    DateTime date,
    bool isSelected,
    bool isToday,
    bool isOutsideMonth,
    List<VooCalendarEvent> events,
  )?
  dayBuilder;
  final Widget Function(BuildContext context, VooCalendarEvent event)?
  eventBuilder;
  final bool compact;
  final VooCalendarGestureConfig? gestureConfig;
  final VooMonthViewConfig config;

  const VooCalendarMonthView({
    super.key,
    required this.controller,
    required this.theme,
    required this.firstDayOfWeek,
    required this.showWeekNumbers,
    required this.onDateSelected,
    this.onEventTap,
    this.dayBuilder,
    this.eventBuilder,
    required this.compact,
    this.gestureConfig,
    this.config = const VooMonthViewConfig(),
  });

  @override
  State<VooCalendarMonthView> createState() => _VooCalendarMonthViewState();
}

class _VooCalendarMonthViewState extends State<VooCalendarMonthView> {
  final Map<int, DateTime> _indexToDate = {};

  void _handleDragStart(Offset position, VooDesignSystemData design) {
    // Find which cell was tapped based on position
    final date = _getDateFromPosition(position, design);
    if (date != null) {
      widget.controller.startDragSelection(date);
    }
  }

  void _handleDragUpdate(Offset position, VooDesignSystemData design) {
    final date = _getDateFromPosition(position, design);
    if (date != null) {
      widget.controller.updateDragSelection(date);
    }
  }

  void _handleDragEnd() {
    widget.controller.endDragSelection();
  }

  DateTime? _getDateFromPosition(Offset position, VooDesignSystemData design) {
    // This is a simplified calculation - you'll need to refine based on actual grid layout
    // For now, return null to avoid errors
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final focusedDate = widget.controller.focusedDate;
    final firstDayOfMonth = DateTime(focusedDate.year, focusedDate.month, 1);

    // Calculate first day to show (might be from previous month)
    int daysFromStartOfWeek =
        (firstDayOfMonth.weekday - widget.firstDayOfWeek) % 7;
    final firstDateToShow = firstDayOfMonth.subtract(
      Duration(days: daysFromStartOfWeek),
    );

    // Calculate total days to show (always show 6 weeks)
    const int weeksToShow = 6;
    const int daysToShow = weeksToShow * 7;

    // Build index to date mapping for gesture detection
    _indexToDate.clear();
    for (int i = 0; i < daysToShow; i++) {
      _indexToDate[i] = firstDateToShow.add(Duration(days: i));
    }

    final gestureConfig =
        widget.gestureConfig ?? const VooCalendarGestureConfig();

    return Column(
      children: [
        // Weekday headers
        _buildWeekdayHeaders(design),
        // Calendar grid with gesture detection
        Expanded(
          child: GestureDetector(
            onPanStart: gestureConfig.enableDragSelection
                ? (details) {
                    final RenderBox box =
                        context.findRenderObject() as RenderBox;
                    final localPosition = box.globalToLocal(
                      details.globalPosition,
                    );
                    _handleDragStart(localPosition, design);
                  }
                : null,
            onPanUpdate: gestureConfig.enableDragSelection
                ? (details) {
                    final RenderBox box =
                        context.findRenderObject() as RenderBox;
                    final localPosition = box.globalToLocal(
                      details.globalPosition,
                    );
                    _handleDragUpdate(localPosition, design);
                  }
                : null,
            onPanEnd: gestureConfig.enableDragSelection
                ? (_) => _handleDragEnd()
                : null,
            child: GridView.builder(
              padding: EdgeInsets.all(design.spacingMd),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.showWeekNumbers ? 8 : 7,
                mainAxisSpacing: design.spacingXs,
                crossAxisSpacing: design.spacingXs,
                childAspectRatio: widget.compact ? 1.2 : 1.0,
              ),
              itemCount:
                  daysToShow + (widget.showWeekNumbers ? weeksToShow : 0),
              itemBuilder: (context, index) {
                if (widget.showWeekNumbers && index % 8 == 0) {
                  // Week number cell
                  final weekIndex = index ~/ 8;
                  final weekDate = firstDateToShow.add(
                    Duration(days: weekIndex * 7),
                  );
                  return _buildWeekNumber(weekDate);
                }

                final dayIndex = widget.showWeekNumbers
                    ? index - (index ~/ 8) - 1
                    : index;

                if (dayIndex < 0 || dayIndex >= daysToShow) {
                  return const SizedBox.shrink();
                }

                final date = firstDateToShow.add(Duration(days: dayIndex));
                final isOutsideMonth = date.month != focusedDate.month;
                final isToday = _isToday(date);
                final isSelected =
                    widget.controller.isDateSelected(date) ||
                    widget.controller.isDragSelecting(date);
                final isRangeStart = widget.controller.isRangeStart(date);
                final isRangeEnd = widget.controller.isRangeEnd(date);
                final isInRange = widget.controller.isDateInRange(date);
                final events = widget.controller.getEventsForDate(date);

                if (widget.dayBuilder != null) {
                  return GestureDetector(
                    onTap: () => widget.onDateSelected(date),
                    onLongPress: gestureConfig.enableLongPressRange
                        ? () => widget.controller.startDragSelection(date)
                        : null,
                    child: widget.dayBuilder!(
                      context,
                      date,
                      isSelected,
                      isToday,
                      isOutsideMonth,
                      events,
                    ),
                  );
                }

                return _buildDay(
                  context,
                  date,
                  isSelected: isSelected,
                  isToday: isToday,
                  isOutsideMonth: isOutsideMonth,
                  isRangeStart: isRangeStart,
                  isRangeEnd: isRangeEnd,
                  isInRange: isInRange,
                  events: events,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeekdayHeaders(VooDesignSystemData design) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    // Rotate weekdays based on firstDayOfWeek
    final rotatedWeekdays = [
      ...weekdays.sublist(widget.firstDayOfWeek - 1),
      ...weekdays.sublist(0, widget.firstDayOfWeek - 1),
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: design.spacingMd),
      height: 32,
      decoration: BoxDecoration(
        color: widget.theme.headerBackgroundColor.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(color: widget.theme.borderColor, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          if (widget.showWeekNumbers)
            SizedBox(
              width: 40,
              child: Center(
                child: Text('W', style: widget.theme.weekdayTextStyle),
              ),
            ),
          ...rotatedWeekdays.map(
            (day) => Expanded(
              child: Center(
                child: Text(
                  widget.compact ? day[0] : day,
                  style: widget.theme.weekdayTextStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekNumber(DateTime weekDate) {
    final weekNumber = _getWeekNumber(weekDate);
    return Container(
      decoration: BoxDecoration(
        color: widget.theme.weekNumberBackgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          weekNumber.toString(),
          style: widget.theme.weekNumberTextStyle,
        ),
      ),
    );
  }

  Widget _buildDay(
    BuildContext context,
    DateTime date, {
    required bool isSelected,
    required bool isToday,
    required bool isOutsideMonth,
    required bool isRangeStart,
    required bool isRangeEnd,
    required bool isInRange,
    required List<VooCalendarEvent> events,
  }) {
    final design = context.vooDesign;

    Color? backgroundColor;
    Color? textColor;
    BoxDecoration? decoration;

    if (isSelected || isRangeStart || isRangeEnd) {
      backgroundColor = widget.theme.selectedDayBackgroundColor;
      textColor = widget.theme.selectedDayTextColor;
    } else if (isInRange) {
      backgroundColor = widget.theme.rangeBackgroundColor;
      textColor = widget.theme.dayTextColor;
    } else if (isToday) {
      backgroundColor = widget.theme.todayBackgroundColor;
      textColor = widget.theme.todayTextColor;
    }

    if (isRangeStart) {
      decoration = BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(design.radiusSm),
          bottomLeft: Radius.circular(design.radiusSm),
          topRight: isRangeEnd ? Radius.circular(design.radiusSm) : Radius.zero,
          bottomRight: isRangeEnd
              ? Radius.circular(design.radiusSm)
              : Radius.zero,
        ),
      );
    } else if (isRangeEnd) {
      decoration = BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(design.radiusSm),
          bottomRight: Radius.circular(design.radiusSm),
        ),
      );
    } else if (backgroundColor != null) {
      decoration = BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(design.radiusSm),
      );
    }

    if (isOutsideMonth) {
      textColor = widget.theme.outsideMonthTextColor;
    }

    return InkWell(
      onTap: () => widget.onDateSelected(date),
      borderRadius: BorderRadius.circular(design.radiusSm),
      child: Container(
        decoration: decoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              date.day.toString(),
              style: widget.theme.dayTextStyle.copyWith(
                color: textColor,
                fontWeight: isToday ? FontWeight.bold : null,
              ),
            ),
            if (events.isNotEmpty && !widget.compact) ...[
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: events.take(3).map((event) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: event.color ?? widget.theme.eventIndicatorColor,
                      shape: BoxShape.circle,
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  int _getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return ((daysSinceFirstDay + firstDayOfYear.weekday - 1) / 7).ceil();
  }
}

/// Week view for VooCalendar
class VooCalendarWeekView extends StatelessWidget {
  final VooCalendarController controller;
  final VooCalendarTheme theme;
  final int firstDayOfWeek;
  final void Function(DateTime date) onDateSelected;
  final void Function(VooCalendarEvent event)? onEventTap;
  final Widget Function(BuildContext context, VooCalendarEvent event)?
  eventBuilder;
  final bool compact;

  static const double _hourHeight = 60.0;

  const VooCalendarWeekView({
    super.key,
    required this.controller,
    required this.theme,
    required this.firstDayOfWeek,
    required this.onDateSelected,
    this.onEventTap,
    this.eventBuilder,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final focusedDate = controller.focusedDate;

    // Calculate first day of week
    int daysFromStartOfWeek = (focusedDate.weekday - firstDayOfWeek) % 7;
    final firstDayOfWeekDate = focusedDate.subtract(
      Duration(days: daysFromStartOfWeek),
    );

    final hours = List.generate(24, (i) => i);

    return Row(
      children: [
        // Time column
        SizedBox(
          width: compact ? 40 : 60,
          child: Column(
            children: [
              // Header spacer
              Container(height: 60),
              // Hour labels
              Expanded(
                child: ListView.builder(
                  itemCount: hours.length,
                  itemExtent: 60,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.only(right: design.spacingXs),
                      alignment: Alignment.topRight,
                      child: Text(
                        compact
                            ? '${hours[index]}'
                            : '${hours[index].toString().padLeft(2, '0')}:00',
                        style: theme.timeTextStyle,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // Days columns
        Expanded(
          child: Column(
            children: [
              // Day headers
              _buildDayHeaders(firstDayOfWeekDate, design),
              // Day content
              Expanded(
                child: Row(
                  children: List.generate(7, (dayIndex) {
                    final date = firstDayOfWeekDate.add(
                      Duration(days: dayIndex),
                    );
                    final events = controller.getEventsForDate(date);
                    final isSelected = controller.isDateSelected(date);
                    final isToday = _isToday(date);

                    return Expanded(
                      child: _buildDayColumn(
                        context,
                        date,
                        events,
                        isSelected,
                        isToday,
                        design,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDayHeaders(DateTime firstDay, VooDesignSystemData design) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: theme.headerBackgroundColor.withValues(alpha: 0.5),
        border: Border(bottom: BorderSide(color: theme.borderColor)),
      ),
      child: Row(
        children: List.generate(7, (index) {
          final date = firstDay.add(Duration(days: index));
          final isToday = _isToday(date);
          final isSelected = controller.isDateSelected(date);

          return Expanded(
            child: InkWell(
              onTap: () => onDateSelected(date),
              child: Container(
                margin: EdgeInsets.all(design.spacingXs),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.selectedDayBackgroundColor
                      : isToday
                      ? theme.todayBackgroundColor
                      : null,
                  borderRadius: BorderRadius.circular(design.radiusSm),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('E').format(date),
                      style: theme.weekdayTextStyle.copyWith(
                        color: isSelected ? theme.selectedDayTextColor : null,
                      ),
                    ),
                    Text(
                      date.day.toString(),
                      style: theme.dayTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? theme.selectedDayTextColor
                            : isToday
                            ? theme.todayTextColor
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDayColumn(
    BuildContext context,
    DateTime date,
    List<VooCalendarEvent> events,
    bool isSelected,
    bool isToday,
    VooDesignSystemData design,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: theme.gridLineColor)),
        color: isSelected
            ? theme.selectedDayBackgroundColor.withValues(alpha: 0.1)
            : isToday
            ? theme.todayBackgroundColor.withValues(alpha: 0.05)
            : null,
      ),
      child: Stack(
        children: [
          // Hour grid
          Column(
            children: List.generate(24, (hour) {
              return Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: theme.gridLineColor,
                        width: hour == 23 ? 0 : 0.5,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          // Events
          ...events.map((event) {
            if (eventBuilder != null) {
              return Positioned(
                top: _getEventTop(event),
                left: 2,
                right: 2,
                height: _getEventHeight(event),
                child: eventBuilder!(context, event),
              );
            }
            return Positioned(
              top: _getEventTop(event),
              left: 2,
              right: 2,
              height: _getEventHeight(event),
              child: _buildEvent(event, design),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEvent(VooCalendarEvent event, VooDesignSystemData design) {
    return InkWell(
      onTap: () => onEventTap?.call(event),
      child: Container(
        padding: EdgeInsets.all(design.spacingXs),
        decoration: BoxDecoration(
          color: event.color ?? theme.eventBackgroundColor,
          borderRadius: BorderRadius.circular(design.radiusXs),
          border: Border.all(
            color: (event.color ?? theme.eventBackgroundColor).withValues(
              alpha: 0.8,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: theme.eventTitleTextStyle,
              maxLines: compact ? 1 : 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (!compact && event.description != null)
              Text(
                event.description!,
                style: theme.eventDescriptionTextStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }

  double _getEventTop(VooCalendarEvent event) {
    final hour = event.startTime.hour;
    final minute = event.startTime.minute;
    return (hour + minute / 60) * _hourHeight;
  }

  double _getEventHeight(VooCalendarEvent event) {
    final duration = event.duration.inMinutes;
    return (duration / 60) * _hourHeight;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}

/// Event layout data for column-based layout
class _DayViewEventLayout {
  final VooCalendarEvent event;
  final int column;
  final int totalColumns;

  _DayViewEventLayout({
    required this.event,
    required this.column,
    required this.totalColumns,
  });
}

/// Day view for VooCalendar
class VooCalendarDayView extends StatefulWidget {
  final VooCalendarController controller;
  final VooCalendarTheme theme;
  final void Function(VooCalendarEvent event)? onEventTap;
  final Widget Function(BuildContext context, VooCalendarEvent event)?
  eventBuilder;
  final bool compact;

  /// Configuration for day view customization
  final VooDayViewConfig config;

  const VooCalendarDayView({
    super.key,
    required this.controller,
    required this.theme,
    this.onEventTap,
    this.eventBuilder,
    required this.compact,
    this.config = const VooDayViewConfig(),
  });

  // Legacy constructor for backward compatibility
  @Deprecated('Use VooDayViewConfig instead of individual parameters')
  factory VooCalendarDayView.legacy({
    Key? key,
    required VooCalendarController controller,
    required VooCalendarTheme theme,
    void Function(VooCalendarEvent event)? onEventTap,
    Widget Function(BuildContext context, VooCalendarEvent event)? eventBuilder,
    required bool compact,
    Widget Function(BuildContext context, int hour)? hourLineTrailingBuilder,
    Widget Function(BuildContext context, int hour)? hourLineLeadingBuilder,
    bool showOnlyHoursWithEvents = false,
    double? hourHeight,
    String Function(int hour)? timeLabelFormatter,
    int? initialScrollHour,
    ScrollPhysics? scrollPhysics,
    bool showTimeLabels = true,
    double? timeColumnWidth,
    int firstHour = 0,
    int lastHour = 23,
    Color? hourLineColor,
    double? hourLineThickness,
    bool showHalfHourLines = false,
    void Function(int hour)? onHourLineTap,
    bool enableDynamicHeight = false,
    double? minEventHeight,
    double? eventSpacing,
  }) {
    return VooCalendarDayView(
      key: key,
      controller: controller,
      theme: theme,
      onEventTap: onEventTap,
      eventBuilder: eventBuilder,
      compact: compact,
      config: VooDayViewConfig(
        hourLineTrailingBuilder: hourLineTrailingBuilder,
        hourLineLeadingBuilder: hourLineLeadingBuilder,
        showOnlyHoursWithEvents: showOnlyHoursWithEvents,
        hourHeight: hourHeight,
        timeLabelFormatter: timeLabelFormatter,
        initialScrollHour: initialScrollHour,
        scrollPhysics: scrollPhysics,
        showTimeLabels: showTimeLabels,
        timeColumnWidth: timeColumnWidth,
        firstHour: firstHour,
        lastHour: lastHour,
        hourLineColor: hourLineColor,
        hourLineThickness: hourLineThickness,
        showHalfHourLines: showHalfHourLines,
        onHourLineTap: onHourLineTap,
        enableDynamicHeight: enableDynamicHeight,
        minEventHeight: minEventHeight ?? 40.0,
        eventSpacing: eventSpacing ?? 4.0,
      ),
    );
  }

  @override
  State<VooCalendarDayView> createState() => _VooCalendarDayViewState();
}

class _VooCalendarDayViewState extends State<VooCalendarDayView> {
  final ScrollController _scrollController = ScrollController();
  static const double _defaultHourHeight = 60.0;

  @override
  void initState() {
    super.initState();
    // Scroll to initial hour on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final scrollHour = widget.config.initialScrollHour ?? DateTime.now().hour;
      final hourHeight = widget.config.hourHeight ?? _defaultHourHeight;
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          scrollHour * hourHeight,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _defaultTimeFormatter(int hour) {
    return '${hour.toString().padLeft(2, '0')}:00';
  }

  /// Calculate the number of overlapping events for a given hour
  int _getMaxOverlappingEventsForHour(int hour, List<VooCalendarEvent> events) {
    final eventsInHour = events.where((event) {
      final eventStartHour = event.startTime.hour;
      final eventEndHour = event.endTime.hour;
      return hour >= eventStartHour && hour <= eventEndHour;
    }).toList();

    if (eventsInHour.isEmpty) return 0;

    // Find the maximum number of events overlapping at any minute in this hour
    int maxOverlap = 0;
    for (int minute = 0; minute < 60; minute++) {
      final checkTime = DateTime(
        widget.controller.focusedDate.year,
        widget.controller.focusedDate.month,
        widget.controller.focusedDate.day,
        hour,
        minute,
      );

      int overlapCount = 0;
      for (final event in eventsInHour) {
        if (checkTime.isAfter(event.startTime) &&
            checkTime.isBefore(event.endTime)) {
          overlapCount++;
        } else if (checkTime.isAtSameMomentAs(event.startTime)) {
          overlapCount++;
        }
      }

      if (overlapCount > maxOverlap) {
        maxOverlap = overlapCount;
      }
    }

    return maxOverlap;
  }

  /// Calculate dynamic height for each hour based on events
  Map<int, double> _calculateDynamicHeights(
    List<int> hours,
    List<VooCalendarEvent> events,
    double baseHourHeight,
    double minEventHeight,
    double eventSpacing,
  ) {
    final Map<int, double> hourHeights = {};

    for (final hour in hours) {
      final maxOverlap = _getMaxOverlappingEventsForHour(hour, events);

      if (maxOverlap == 0) {
        // No events, use base height
        hourHeights[hour] = baseHourHeight;
      } else {
        // Calculate height needed to fit all overlapping events with proper spacing
        // Add top and bottom padding for each event
        final totalEventHeight = (maxOverlap * minEventHeight);
        final totalSpacing = ((maxOverlap - 1) * eventSpacing);
        // Add extra padding for visual breathing room
        final paddingBuffer = widget.config.eventTopPadding + widget.config.eventBottomPadding;
        final requiredHeight = totalEventHeight + totalSpacing + paddingBuffer;

        // Use the maximum of base height and required height
        hourHeights[hour] = requiredHeight > baseHourHeight
            ? requiredHeight
            : baseHourHeight;
      }
    }

    return hourHeights;
  }

  /// Get events that overlap at a specific time slot
  List<VooCalendarEvent> _getOverlappingEvents(
    VooCalendarEvent event,
    List<VooCalendarEvent> allEvents,
  ) {
    return allEvents.where((other) {
      if (event == other) return false;
      // Check if events overlap
      return event.startTime.isBefore(other.endTime) &&
          event.endTime.isAfter(other.startTime);
    }).toList();
  }

  /// Calculate column-based layout for overlapping events (Google Calendar style)
  Map<VooCalendarEvent, _DayViewEventLayout> _calculateColumnLayout(
    List<VooCalendarEvent> events,
  ) {
    final Map<VooCalendarEvent, _DayViewEventLayout> layouts = {};

    // Group overlapping events
    final List<List<VooCalendarEvent>> groups = [];
    final Set<VooCalendarEvent> processed = {};

    for (final event in events) {
      if (processed.contains(event)) continue;

      // Find all events that overlap with this event (directly or transitively)
      final group = <VooCalendarEvent>[event];
      final queue = <VooCalendarEvent>[event];
      processed.add(event);

      while (queue.isNotEmpty) {
        final current = queue.removeAt(0);
        final overlapping = _getOverlappingEvents(current, events);

        for (final other in overlapping) {
          if (!processed.contains(other)) {
            group.add(other);
            queue.add(other);
            processed.add(other);
          }
        }
      }

      groups.add(group);
    }

    // Assign columns to each group
    for (final group in groups) {
      // Sort by start time, then by duration (longer events first)
      group.sort((a, b) {
        final startCompare = a.startTime.compareTo(b.startTime);
        if (startCompare != 0) return startCompare;
        return b.duration.compareTo(a.duration);
      });

      // Track which columns are occupied at each time point
      final columns = <int, DateTime>{};
      int maxColumn = 0;

      for (final event in group) {
        // Find the first available column
        int column = 0;
        while (columns[column] != null &&
            columns[column]!.isAfter(event.startTime)) {
          column++;
        }

        columns[column] = event.endTime;
        maxColumn = column > maxColumn ? column : maxColumn;

        layouts[event] = _DayViewEventLayout(
          event: event,
          column: column,
          totalColumns: 0, // Will be updated after processing all events in group
        );
      }

      // Update total columns for all events in the group
      final totalColumns = maxColumn + 1;
      for (final event in group) {
        layouts[event] = _DayViewEventLayout(
          event: event,
          column: layouts[event]!.column,
          totalColumns: totalColumns,
        );
      }
    }

    return layouts;
  }

  /// Calculate the vertical offset for stacked events
  double _calculateStackedEventOffset(
    VooCalendarEvent event,
    List<VooCalendarEvent> allEvents,
    double eventHeight,
    double eventSpacing,
  ) {
    // Only stack events that start at the SAME minute
    // Events starting at different minutes will use minute offsets instead
    final sameStartTimeEvents = allEvents.where((other) {
      return other.startTime.hour == event.startTime.hour &&
          other.startTime.minute == event.startTime.minute;
    }).toList();

    if (sameStartTimeEvents.length <= 1) return 0;

    // Sort by original list index for stable ordering
    sameStartTimeEvents.sort((a, b) {
      return allEvents.indexOf(a).compareTo(allEvents.indexOf(b));
    });

    // Use indexWhere with identical() for object identity comparison
    final index = sameStartTimeEvents.indexWhere((e) => identical(e, event));
    return index >= 0 ? index * (eventHeight + eventSpacing) : 0;
  }

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final theme = widget.theme;
    final config = widget.config;
    final focusedDate = widget.controller.focusedDate;
    final events = widget.controller.getEventsForDate(focusedDate);
    final hourHeight = config.hourHeight ?? _defaultHourHeight;
    final timeFormatter = config.timeLabelFormatter ?? _defaultTimeFormatter;

    // Responsive column layout: Enable on desktop/tablet, disable on mobile
    // Mobile (< 600px): Vertical stacking with dynamic height expansion
    // Desktop (≥ 600px): Column layout (Google Calendar style)
    final isMobile = context.isMobile;
    final shouldUseColumnLayout = config.enableColumnLayout && !isMobile;
    final shouldUseDynamicHeight = isMobile; // Always use dynamic height on mobile

    // Calculate column layout for events if enabled and not on mobile
    final Map<VooCalendarEvent, _DayViewEventLayout>? eventLayouts =
        shouldUseColumnLayout ? _calculateColumnLayout(events) : null;

    // Filter hours based on showOnlyHoursWithEvents or hour range
    List<int> hours;
    if (config.showOnlyHoursWithEvents) {
      // Get unique hours that have events
      final hoursWithEvents = events
          .map((e) => e.startTime.hour)
          .toSet()
          .toList()
        ..sort();
      hours = hoursWithEvents.isNotEmpty ? hoursWithEvents : [config.firstHour];
    } else {
      hours = List.generate(
        config.lastHour - config.firstHour + 1,
        (i) => config.firstHour + i,
      );
    }

    // Calculate dynamic heights if enabled OR if on mobile
    final Map<int, double> hourHeights = (config.enableDynamicHeight || shouldUseDynamicHeight)
        ? _calculateDynamicHeights(
            hours,
            events,
            hourHeight,
            config.minEventHeight,
            config.eventSpacing,
          )
        : {for (var hour in hours) hour: hourHeight};

    return LayoutBuilder(
      builder: (context, constraints) {
        final timeColumnWidth = config.timeColumnWidth ??
            (widget.compact ? 50.0 : 60.0);
        final totalHeight = (config.enableDynamicHeight || shouldUseDynamicHeight)
            ? hourHeights.values.reduce((a, b) => a + b)
            : (hours.length * hourHeight +
                (config.showHalfHourLines ? hours.length * (hourHeight / 2) : 0));

        return SingleChildScrollView(
          controller: _scrollController,
          physics: config.scrollPhysics,
          child: SizedBox(
            height: totalHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time column with leading builders
                if (config.showTimeLabels)
                  SizedBox(
                    width: timeColumnWidth,
                    child: Column(
                      children: hours.map((hour) {
                        final height = hourHeights[hour] ?? hourHeight;
                        return Container(
                          height: height,
                          padding: EdgeInsets.only(
                            right: design.spacingXs,
                          ),
                          alignment: Alignment.topRight,
                          child: Transform.translate(
                            offset: const Offset(0, -2),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (config.hourLineLeadingBuilder != null)
                                  Padding(
                                    padding: EdgeInsets.only(right: design.spacingXs),
                                    child: config.hourLineLeadingBuilder!(context, hour),
                                  ),
                                Text(
                                  timeFormatter(hour),
                                  style: widget.theme.timeTextStyle.copyWith(
                                    fontSize: widget.compact ? 10 : 11,
                                    height: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                // Day content
                Expanded(
                  child: Stack(
                    children: [
                      // Hour grid
                      Column(
                        children: hours.asMap().entries.map((entry) {
                          final index = entry.key;
                          final hour = entry.value;
                          final height = hourHeights[hour] ?? hourHeight;
                          final lineColor = config.hourLineColor ?? theme.gridLineColor;
                          final lineThickness = config.hourLineThickness ?? 0.5;

                          return InkWell(
                            onTap: config.onHourLineTap != null
                                ? () => config.onHourLineTap!(hour)
                                : null,
                            child: Container(
                              height: height,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: lineColor,
                                    width: index == hours.length - 1 ? 0 : lineThickness,
                                  ),
                                ),
                              ),
                              child: config.hourLineTrailingBuilder != null
                                  ? Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(right: design.spacingXs),
                                        child: config.hourLineTrailingBuilder!(context, hour),
                                      ),
                                    )
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                      // Events
                      ...events.map((event) {
                        // Calculate position based on visible hours
                        final eventHour = event.startTime.hour;
                        final hourIndex = hours.indexOf(eventHour);
                        if (hourIndex == -1) return const SizedBox.shrink();

                        double topOffset;
                        double eventHeight;

                        if (config.enableDynamicHeight || shouldUseDynamicHeight) {
                          // Calculate cumulative offset for dynamic heights
                          topOffset = 0;
                          for (int i = 0; i < hourIndex; i++) {
                            topOffset += hourHeights[hours[i]] ?? hourHeight;
                          }

                          // When column layout is enabled (and not on mobile), don't add vertical stacking
                          // Events will be arranged horizontally in columns instead
                          if (shouldUseColumnLayout) {
                            // Position all events at the top of the hour
                            // Column layout will arrange them side-by-side
                            // No minute offset or stack offset needed
                          } else {
                            // On mobile with dynamic height: stack ALL events in the hour vertically
                            // Don't use minute offsets - just stack from top to bottom
                            // Get all events in this hour and find this event's index
                            final eventsInHour = events.where((e) => e.startTime.hour == eventHour).toList();
                            final eventIndex = eventsInHour.indexWhere((e) => identical(e, event));
                            if (eventIndex >= 0) {
                              topOffset += eventIndex * (config.minEventHeight + config.eventSpacing);
                            }
                          }

                          // Use minimum event height when dynamic
                          eventHeight = config.minEventHeight;
                        } else {
                          topOffset = config.showOnlyHoursWithEvents
                              ? hourIndex * hourHeight + (event.startTime.minute / 60) * hourHeight
                              : _getEventTop(event, hourHeight);
                          eventHeight = _getEventHeight(event, hourHeight);
                        }

                        // Calculate proper left and right padding to avoid overlaps
                        double leftPadding = config.eventLeftPadding;
                        double rightPadding = config.eventRightPadding + config.trailingBuilderWidth;
                        double? width;

                        // Apply column layout if enabled
                        if (eventLayouts != null && eventLayouts.containsKey(event)) {
                          final layout = eventLayouts[event]!;
                          final totalColumns = layout.totalColumns;
                          final column = layout.column;

                          // Calculate available width
                          final availableWidth = constraints.maxWidth -
                              (config.showTimeLabels
                                  ? (config.timeColumnWidth ?? (widget.compact ? 50.0 : 60.0))
                                  : 0);

                          // Calculate column width (subtract padding and gaps)
                          final totalHorizontalPadding = leftPadding + rightPadding;
                          final totalGaps = (totalColumns - 1) * config.eventHorizontalGap;
                          final usableWidth = availableWidth - totalHorizontalPadding - totalGaps;
                          final columnWidth = usableWidth / totalColumns;

                          // Calculate left position for this column
                          leftPadding = leftPadding +
                              (column * columnWidth) +
                              (column * config.eventHorizontalGap);
                          width = columnWidth;
                          rightPadding = 0; // Right padding is handled by width
                        }

                        if (widget.eventBuilder != null) {
                          return Positioned(
                            top: topOffset + config.eventTopPadding,
                            left: leftPadding,
                            right: width == null ? rightPadding : null,
                            width: width,
                            height: eventHeight - config.eventTopPadding - config.eventBottomPadding,
                            child: widget.eventBuilder!(context, event),
                          );
                        }
                        final allocatedHeight = eventHeight - config.eventTopPadding - config.eventBottomPadding;
                        return Positioned(
                          top: topOffset + config.eventTopPadding,
                          left: leftPadding,
                          right: width == null ? rightPadding : null,
                          width: width,
                          height: allocatedHeight,
                          child: _buildEvent(event, design, allocatedHeight),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEvent(VooCalendarEvent event, VooDesignSystemData design, double allocatedHeight) {
    // Use allocated height instead of calculated height to determine what content to show
    // This fixes overflow issues when enableDynamicHeight is true
    final showDescription = event.description != null && !widget.compact && allocatedHeight > 40;
    final showTime = allocatedHeight > 30;

    return InkWell(
      onTap: () => widget.onEventTap?.call(event),
      child: Container(
        padding: EdgeInsets.all(design.spacingXs),
        decoration: BoxDecoration(
          color: event.color ?? widget.theme.eventBackgroundColor,
          borderRadius: BorderRadius.circular(design.radiusXs),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (event.icon != null) ...[
                  Icon(event.icon, size: 12, color: Colors.white),
                  SizedBox(width: design.spacingXs),
                ],
                Expanded(
                  child: Text(
                    event.title,
                    style: widget.theme.eventTitleTextStyle.copyWith(
                      fontSize: widget.compact ? 11 : 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (showDescription) ...[
              SizedBox(height: design.spacingXs),
              Text(
                event.description!,
                style: widget.theme.eventDescriptionTextStyle.copyWith(
                  fontSize: 10,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (showTime)
              Text(
                DateFormat('HH:mm').format(event.startTime),
                style: widget.theme.eventTimeTextStyle.copyWith(fontSize: 9),
              ),
          ],
        ),
      ),
    );
  }

  double _getEventTop(VooCalendarEvent event, double hourHeight) {
    // Don't subtract firstHour here - the hours list is already filtered
    // so hour 0 in the visual grid is firstHour
    final hour = event.startTime.hour - widget.config.firstHour;
    final minute = event.startTime.minute;
    return (hour + minute / 60) * hourHeight;
  }

  double _getEventHeight(VooCalendarEvent event, double hourHeight) {
    final duration = event.duration.inMinutes;
    // Subtract a small amount to prevent overlapping with hour line borders
    final calculatedHeight = (duration / 60) * hourHeight;
    return calculatedHeight > 4 ? calculatedHeight - 4 : calculatedHeight;
  }
}

/// Year view for VooCalendar
class VooCalendarYearView extends StatelessWidget {
  final VooCalendarController controller;
  final VooCalendarTheme theme;
  final void Function(int month) onMonthSelected;
  final bool compact;

  const VooCalendarYearView({
    super.key,
    required this.controller,
    required this.theme,
    required this.onMonthSelected,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final year = controller.focusedDate.year;

    return GridView.builder(
      padding: EdgeInsets.all(design.spacingLg),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: compact ? 3 : 4,
        mainAxisSpacing: design.spacingMd,
        crossAxisSpacing: design.spacingMd,
        childAspectRatio: compact ? 1.2 : 1.5,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        final month = index + 1;
        final monthDate = DateTime(year, month);
        final monthName = DateFormat('MMMM').format(monthDate);
        final hasEvents = controller.events.any(
          (event) =>
              event.startTime.year == year && event.startTime.month == month,
        );

        return InkWell(
          onTap: () => onMonthSelected(month),
          borderRadius: BorderRadius.circular(design.radiusMd),
          child: Container(
            padding: EdgeInsets.all(design.spacingMd),
            decoration: BoxDecoration(
              border: Border.all(color: theme.borderColor),
              borderRadius: BorderRadius.circular(design.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(monthName, style: theme.monthTextStyle),
                const Spacer(),
                if (hasEvents) ...[
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: theme.eventIndicatorColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: design.spacingXs),
                      Text(
                        'Has events',
                        style: theme.eventDescriptionTextStyle,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Schedule view for VooCalendar
class VooCalendarScheduleView extends StatelessWidget {
  final VooCalendarController controller;
  final VooCalendarTheme theme;
  final void Function(DateTime date) onDateSelected;
  final void Function(VooCalendarEvent event)? onEventTap;
  final Widget Function(BuildContext context, VooCalendarEvent event)?
  eventBuilder;
  final bool compact;

  const VooCalendarScheduleView({
    super.key,
    required this.controller,
    required this.theme,
    required this.onDateSelected,
    this.onEventTap,
    this.eventBuilder,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;

    // Group events by date
    final Map<DateTime, List<VooCalendarEvent>> eventsByDate = {};
    for (final event in controller.events) {
      final dateKey = DateTime(
        event.startTime.year,
        event.startTime.month,
        event.startTime.day,
      );
      eventsByDate.putIfAbsent(dateKey, () => []).add(event);
    }

    final sortedDates = eventsByDate.keys.toList()..sort();

    if (sortedDates.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 48,
              color: theme.outsideMonthTextColor,
            ),
            SizedBox(height: design.spacingMd),
            Text('No events scheduled', style: theme.monthTextStyle),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(design.spacingMd),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final events = eventsByDate[date]!;
        final isSelected = controller.isDateSelected(date);
        final isToday = _isToday(date);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            InkWell(
              onTap: () => onDateSelected(date),
              child: Container(
                padding: EdgeInsets.all(design.spacingMd),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.selectedDayBackgroundColor
                      : isToday
                      ? theme.todayBackgroundColor
                      : theme.headerBackgroundColor.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(design.radiusSm),
                ),
                child: Row(
                  children: [
                    Text(
                      DateFormat('EEEE, MMMM d').format(date),
                      style: theme.dayTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? theme.selectedDayTextColor
                            : isToday
                            ? theme.todayTextColor
                            : null,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${events.length} event${events.length == 1 ? '' : 's'}',
                      style: theme.eventDescriptionTextStyle,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: design.spacingSm),
            // Events for this date
            ...events.map((event) {
              if (eventBuilder != null) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: design.spacingLg,
                    bottom: design.spacingSm,
                  ),
                  child: eventBuilder!(context, event),
                );
              }
              return Padding(
                padding: EdgeInsets.only(
                  left: design.spacingLg,
                  bottom: design.spacingSm,
                ),
                child: _buildEvent(event, design),
              );
            }),
            if (index < sortedDates.length - 1)
              Divider(height: design.spacingLg * 2),
          ],
        );
      },
    );
  }

  Widget _buildEvent(VooCalendarEvent event, VooDesignSystemData design) {
    return InkWell(
      onTap: () => onEventTap?.call(event),
      borderRadius: BorderRadius.circular(design.radiusSm),
      child: Container(
        padding: EdgeInsets.all(design.spacingMd),
        decoration: BoxDecoration(
          color:
              event.color?.withValues(alpha: 0.1) ??
              theme.eventBackgroundColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(design.radiusSm),
          border: Border.all(
            color:
                event.color?.withValues(alpha: 0.3) ??
                theme.eventBackgroundColor,
          ),
        ),
        child: Row(
          children: [
            if (event.icon != null) ...[
              Icon(
                event.icon,
                size: 20,
                color: event.color ?? theme.eventIndicatorColor,
              ),
              SizedBox(width: design.spacingMd),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: theme.eventTitleTextStyle.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (event.description != null && !compact) ...[
                    SizedBox(height: design.spacingXs),
                    Text(
                      event.description!,
                      style: theme.eventDescriptionTextStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (!event.isAllDay) ...[
              SizedBox(width: design.spacingMd),
              Text(
                '${DateFormat('HH:mm').format(event.startTime)} - ${DateFormat('HH:mm').format(event.endTime)}',
                style: theme.eventTimeTextStyle,
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
