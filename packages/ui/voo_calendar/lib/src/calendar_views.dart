import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'calendar.dart';
import 'calendar_theme.dart';
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

/// Day view for VooCalendar
class VooCalendarDayView extends StatefulWidget {
  final VooCalendarController controller;
  final VooCalendarTheme theme;
  final void Function(VooCalendarEvent event)? onEventTap;
  final Widget Function(BuildContext context, VooCalendarEvent event)?
  eventBuilder;
  final bool compact;

  /// Builder for trailing widgets on hour lines
  final Widget Function(BuildContext context, int hour)? hourLineTrailingBuilder;

  /// Builder for leading widgets on hour lines (before time label)
  final Widget Function(BuildContext context, int hour)? hourLineLeadingBuilder;

  /// Show only hours that have events
  final bool showOnlyHoursWithEvents;

  /// Custom hour height (default: 60.0)
  final double? hourHeight;

  /// Time label formatter
  final String Function(int hour)? timeLabelFormatter;

  /// Initial hour to scroll to (default: current hour)
  final int? initialScrollHour;

  /// Custom scroll physics
  final ScrollPhysics? scrollPhysics;

  /// Show/hide time labels
  final bool showTimeLabels;

  /// Time column width (overrides compact mode width)
  final double? timeColumnWidth;

  /// First hour to display (0-23)
  final int firstHour;

  /// Last hour to display (0-23)
  final int lastHour;

  /// Hour line color
  final Color? hourLineColor;

  /// Hour line thickness
  final double? hourLineThickness;

  /// Show half-hour lines
  final bool showHalfHourLines;

  /// Callback when hour line is tapped
  final void Function(int hour)? onHourLineTap;

  const VooCalendarDayView({
    super.key,
    required this.controller,
    required this.theme,
    this.onEventTap,
    this.eventBuilder,
    required this.compact,
    this.hourLineTrailingBuilder,
    this.hourLineLeadingBuilder,
    this.showOnlyHoursWithEvents = false,
    this.hourHeight,
    this.timeLabelFormatter,
    this.initialScrollHour,
    this.scrollPhysics,
    this.showTimeLabels = true,
    this.timeColumnWidth,
    this.firstHour = 0,
    this.lastHour = 23,
    this.hourLineColor,
    this.hourLineThickness,
    this.showHalfHourLines = false,
    this.onHourLineTap,
  });

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
      final scrollHour = widget.initialScrollHour ?? DateTime.now().hour;
      final hourHeight = widget.hourHeight ?? _defaultHourHeight;
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

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final theme = widget.theme;
    final focusedDate = widget.controller.focusedDate;
    final events = widget.controller.getEventsForDate(focusedDate);
    final hourHeight = widget.hourHeight ?? _defaultHourHeight;
    final timeFormatter = widget.timeLabelFormatter ?? _defaultTimeFormatter;

    // Filter hours based on showOnlyHoursWithEvents or hour range
    List<int> hours;
    if (widget.showOnlyHoursWithEvents) {
      // Get unique hours that have events
      final hoursWithEvents = events
          .map((e) => e.startTime.hour)
          .toSet()
          .toList()
        ..sort();
      hours = hoursWithEvents.isNotEmpty ? hoursWithEvents : [widget.firstHour];
    } else {
      hours = List.generate(
        widget.lastHour - widget.firstHour + 1,
        (i) => widget.firstHour + i,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final timeColumnWidth = widget.timeColumnWidth ??
            (widget.compact ? 50.0 : 60.0);
        final totalHeight = hours.length * hourHeight +
            (widget.showHalfHourLines ? hours.length * (hourHeight / 2) : 0);

        return SingleChildScrollView(
          controller: _scrollController,
          physics: widget.scrollPhysics,
          child: SizedBox(
            height: totalHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time column with leading builders
                if (widget.showTimeLabels)
                  SizedBox(
                    width: timeColumnWidth,
                    child: Column(
                      children: hours.map((hour) {
                        return Container(
                          height: hourHeight,
                          padding: EdgeInsets.only(
                            right: design.spacingXs,
                          ),
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.hourLineLeadingBuilder != null)
                                Padding(
                                  padding: EdgeInsets.only(right: design.spacingXs),
                                  child: widget.hourLineLeadingBuilder!(context, hour),
                                ),
                              Text(
                                timeFormatter(hour),
                                style: widget.theme.timeTextStyle.copyWith(
                                  fontSize: widget.compact ? 10 : 11,
                                ),
                              ),
                            ],
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
                          final lineColor = widget.hourLineColor ?? theme.gridLineColor;
                          final lineThickness = widget.hourLineThickness ?? 0.5;

                          return InkWell(
                            onTap: widget.onHourLineTap != null
                                ? () => widget.onHourLineTap!(hour)
                                : null,
                            child: Container(
                              height: hourHeight,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: lineColor,
                                    width: index == hours.length - 1 ? 0 : lineThickness,
                                  ),
                                ),
                              ),
                              child: widget.hourLineTrailingBuilder != null
                                  ? Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(right: design.spacingXs),
                                        child: widget.hourLineTrailingBuilder!(context, hour),
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

                        final topOffset = widget.showOnlyHoursWithEvents
                            ? hourIndex * hourHeight + (event.startTime.minute / 60) * hourHeight
                            : _getEventTop(event, hourHeight);

                        if (widget.eventBuilder != null) {
                          return Positioned(
                            top: topOffset,
                            left: design.spacingXs,
                            right: design.spacingXs,
                            height: _getEventHeight(event, hourHeight),
                            child: widget.eventBuilder!(context, event),
                          );
                        }
                        return Positioned(
                          top: topOffset,
                          left: design.spacingXs,
                          right: design.spacingXs,
                          height: _getEventHeight(event, hourHeight),
                          child: _buildEvent(event, design, hourHeight),
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

  Widget _buildEvent(VooCalendarEvent event, VooDesignSystemData design, double hourHeight) {
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
            if (event.description != null &&
                !widget.compact &&
                _getEventHeight(event, hourHeight) > 40) ...[
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
            if (_getEventHeight(event, hourHeight) > 30)
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
    final hour = event.startTime.hour;
    final minute = event.startTime.minute;
    return (hour + minute / 60) * hourHeight;
  }

  double _getEventHeight(VooCalendarEvent event, double hourHeight) {
    final duration = event.duration.inMinutes;
    return (duration / 60) * hourHeight;
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
