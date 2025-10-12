import 'package:flutter/material.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

import 'package:voo_calendar/src/calendar.dart';
import 'package:voo_calendar/src/calendar_config.dart';
import 'package:voo_calendar/src/calendar_theme.dart';
import 'package:voo_calendar/src/domain/entities/voo_calendar_event_render_info.dart';
import 'package:voo_calendar/src/presentation/atoms/event_card_widget.dart';

/// Day view for VooCalendar
class VooCalendarDayView extends StatefulWidget {
  final VooCalendarController controller;
  final VooCalendarTheme theme;
  final void Function(VooCalendarEvent event)? onEventTap;
  final Widget Function(BuildContext context, VooCalendarEvent event)? eventBuilder;
  final Widget Function(BuildContext context, VooCalendarEvent event, VooCalendarEventRenderInfo renderInfo)? eventBuilderWithInfo;
  final bool compact;

  /// Configuration for day view customization
  final VooDayViewConfig config;

  const VooCalendarDayView({
    super.key,
    required this.controller,
    required this.theme,
    this.onEventTap,
    this.eventBuilder,
    this.eventBuilderWithInfo,
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
        _scrollController.animateTo(scrollHour * hourHeight, duration: const Duration(milliseconds: 300), curve: Curves.easeOutCubic);
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
      final checkTime = DateTime(widget.controller.focusedDate.year, widget.controller.focusedDate.month, widget.controller.focusedDate.day, hour, minute);

      int overlapCount = 0;
      for (final event in eventsInHour) {
        if (checkTime.isAfter(event.startTime) && checkTime.isBefore(event.endTime)) {
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
  Map<int, double> _calculateDynamicHeights(List<int> hours, List<VooCalendarEvent> events, double baseHourHeight, double minEventHeight, double eventSpacing) {
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
        hourHeights[hour] = requiredHeight > baseHourHeight ? requiredHeight : baseHourHeight;
      }
    }

    return hourHeights;
  }

  /// Get events that overlap at a specific time slot
  List<VooCalendarEvent> _getOverlappingEvents(VooCalendarEvent event, List<VooCalendarEvent> allEvents) {
    return allEvents.where((other) {
      if (event == other) return false;
      // Check if events overlap
      return event.startTime.isBefore(other.endTime) && event.endTime.isAfter(other.startTime);
    }).toList();
  }

  /// Calculate column-based layout for overlapping events (Google Calendar style)
  Map<VooCalendarEvent, _DayViewEventLayout> _calculateColumnLayout(List<VooCalendarEvent> events) {
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
        while (columns[column] != null && columns[column]!.isAfter(event.startTime)) {
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
        layouts[event] = _DayViewEventLayout(event: event, column: layouts[event]!.column, totalColumns: totalColumns);
      }
    }

    return layouts;
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
    final Map<VooCalendarEvent, _DayViewEventLayout>? eventLayouts = shouldUseColumnLayout ? _calculateColumnLayout(events) : null;

    // Filter hours based on showOnlyHoursWithEvents or hour range
    List<int> hours;
    if (config.showOnlyHoursWithEvents) {
      // Get unique hours that have events
      final hoursWithEvents = events.map((e) => e.startTime.hour).toSet().toList()..sort();
      hours = hoursWithEvents.isNotEmpty ? hoursWithEvents : [config.firstHour];
    } else {
      hours = List.generate(config.lastHour - config.firstHour + 1, (i) => config.firstHour + i);
    }

    // Calculate dynamic heights if enabled OR if on mobile
    final Map<int, double> hourHeights = (config.enableDynamicHeight || shouldUseDynamicHeight)
        ? _calculateDynamicHeights(hours, events, hourHeight, config.minEventHeight, config.eventSpacing)
        : {for (var hour in hours) hour: hourHeight};

    // Pre-calculate event positions for mobile stacking
    // This fixes the bug where events with identical properties get the same position
    final Map<VooCalendarEvent, int> eventStackPositions = {};
    if (!shouldUseColumnLayout) {
      // Group events by hour
      for (final hour in hours) {
        final eventsInHour = events.where((e) => e.startTime.hour == hour).toList();
        // Sort by start time to ensure consistent ordering
        eventsInHour.sort((a, b) => a.startTime.compareTo(b.startTime));

        // Assign stack positions based on their index in the sorted list
        for (int i = 0; i < eventsInHour.length; i++) {
          eventStackPositions[eventsInHour[i]] = i;
        }
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final timeColumnWidth = config.timeColumnWidth ?? (widget.compact ? 50.0 : 60.0);
        final totalHeight = (config.enableDynamicHeight || shouldUseDynamicHeight)
            ? hourHeights.values.reduce((a, b) => a + b)
            : (hours.length * hourHeight + (config.showHalfHourLines ? hours.length * (hourHeight / 2) : 0));

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
                          padding: EdgeInsets.only(right: design.spacingXs),
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
                                Text(timeFormatter(hour), style: widget.theme.timeTextStyle.copyWith(fontSize: widget.compact ? 10 : 11, height: 1.0)),
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
                            onTap: config.onHourLineTap != null ? () => config.onHourLineTap!(hour) : null,
                            child: Container(
                              height: height,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: lineColor, width: index == hours.length - 1 ? 0 : lineThickness),
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

                          // Use pre-calculated stack position for mobile
                          if (!shouldUseColumnLayout) {
                            // On mobile: use the pre-calculated stack position
                            final stackPosition = eventStackPositions[event] ?? 0;
                            topOffset += stackPosition * (config.minEventHeight + config.eventSpacing);
                          }

                          // Use minimum event height when dynamic
                          eventHeight = config.minEventHeight;
                        } else {
                          topOffset = config.showOnlyHoursWithEvents ? hourIndex * hourHeight + (event.startTime.minute / 60) * hourHeight : _getEventTop(event, hourHeight);
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
                          final availableWidth = constraints.maxWidth - (config.showTimeLabels ? (config.timeColumnWidth ?? (widget.compact ? 50.0 : 60.0)) : 0);

                          // Calculate column width (subtract padding and gaps)
                          final totalHorizontalPadding = leftPadding + rightPadding;
                          final totalGaps = (totalColumns - 1) * config.eventHorizontalGap;
                          final usableWidth = availableWidth - totalHorizontalPadding - totalGaps;
                          final columnWidth = usableWidth / totalColumns;

                          // Calculate left position for this column
                          leftPadding = leftPadding + (column * columnWidth) + (column * config.eventHorizontalGap);
                          width = columnWidth;
                          rightPadding = 0; // Right padding is handled by width
                        }

                        final allocatedHeight = eventHeight - config.eventTopPadding - config.eventBottomPadding;
                        final allocatedWidth = width;

                        // Create render info for the event
                        final renderInfo = VooCalendarEventRenderInfo(
                          allocatedHeight: allocatedHeight,
                          allocatedWidth: allocatedWidth,
                          isCompact: widget.compact,
                          isMobile: isMobile,
                          hourHeight: hourHeight,
                        );

                        // Use eventBuilderWithInfo if provided (recommended), otherwise fall back to eventBuilder
                        Widget eventWidget;
                        if (widget.eventBuilderWithInfo != null) {
                          eventWidget = widget.eventBuilderWithInfo!(context, event, renderInfo);
                        } else if (widget.eventBuilder != null) {
                          eventWidget = widget.eventBuilder!(context, event);
                        } else {
                          eventWidget = EventCardWidget(
                            event: event,
                            theme: widget.theme,
                            onTap: () => widget.onEventTap?.call(event),
                            compact: widget.compact,
                            allocatedHeight: allocatedHeight,
                          );
                        }

                        return Positioned(
                          top: topOffset + config.eventTopPadding,
                          left: leftPadding,
                          right: width == null ? rightPadding : null,
                          width: width,
                          height: allocatedHeight,
                          child: eventWidget,
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

/// Event layout data for column-based layout
class _DayViewEventLayout {
  final VooCalendarEvent event;
  final int column;
  final int totalColumns;

  _DayViewEventLayout({required this.event, required this.column, required this.totalColumns});
}
