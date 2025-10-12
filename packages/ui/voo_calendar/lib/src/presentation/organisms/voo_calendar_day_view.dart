import 'package:flutter/material.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

import 'package:voo_calendar/src/calendar.dart';
import 'package:voo_calendar/src/calendar_config.dart';
import 'package:voo_calendar/src/calendar_theme.dart';
import 'package:voo_calendar/src/domain/entities/voo_calendar_event_render_info.dart';
import 'package:voo_calendar/src/presentation/atoms/event_card_widget.dart';
import 'package:voo_calendar/src/presentation/atoms/voo_calendar_event_widget.dart';

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

  /// Calculate dynamic height for each hour based on events that START in that hour
  Map<int, double> _calculateDynamicHeights(List<int> hours, List<VooCalendarEvent> events, double baseHourHeight, double minEventHeight, double eventSpacing) {
    final Map<int, double> hourHeights = {};

    for (final hour in hours) {
      // Get all events that START in this hour (not just overlap with it)
      final eventsInHour = events.where((event) {
        final eventStartHour = event.startTime.hour;
        return eventStartHour == hour;
      }).toList();

      if (eventsInHour.isEmpty) {
        // No events, use base height
        hourHeights[hour] = baseHourHeight;
      } else {
        // Calculate height needed for each event using eventHeightBuilder if provided
        double totalHeight = 0;
        for (final event in eventsInHour) {
          // Use eventHeightBuilder if provided, otherwise use minEventHeight
          final eventHeight = widget.config.eventHeightBuilder?.call(event) ?? minEventHeight;
          totalHeight += eventHeight;
        }

        // Add spacing between events
        final totalSpacing = ((eventsInHour.length - 1) * eventSpacing);
        // Add padding buffer
        final paddingBuffer = widget.config.eventTopPadding + widget.config.eventBottomPadding;
        final requiredHeight = totalHeight + totalSpacing + paddingBuffer;

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

    // ✨ ALWAYS calculate dynamic heights for plug-and-play behavior
    final Map<int, double> hourHeights = _calculateDynamicHeights(hours, events, hourHeight, config.minEventHeight, config.eventSpacing);

    // Pre-calculate event stack positions for ALL overlapping events in each hour
    // This is critical for proper stacking - we must consider ALL events that overlap in an hour, not just ones that start there
    final Map<VooCalendarEvent, int> eventStackPositions = {};
    if (!shouldUseColumnLayout) {
      for (final hour in hours) {
        // Get ALL events that overlap with this hour (not just ones that start in it)
        final eventsInHour = events.where((event) {
          final eventStartHour = event.startTime.hour;
          final eventEndHour = event.endTime.hour;
          return hour >= eventStartHour && hour <= eventEndHour;
        }).toList();

        // Sort by start time, then by ID for consistent ordering
        eventsInHour.sort((a, b) {
          final startCompare = a.startTime.compareTo(b.startTime);
          if (startCompare != 0) return startCompare;
          return a.id.compareTo(b.id);
        });

        // Assign stack positions based on their sorted order
        // Each event gets a unique position in the stack for this hour
        for (int i = 0; i < eventsInHour.length; i++) {
          // If event doesn't have a position yet, or this hour requires a higher stack position, update it
          final currentPosition = eventStackPositions[eventsInHour[i]] ?? -1;
          if (i > currentPosition) {
            eventStackPositions[eventsInHour[i]] = i;
          }
        }
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final timeColumnWidth = config.timeColumnWidth ?? (widget.compact ? 50.0 : 60.0);
        // Always use dynamic heights for total calculation
        final totalHeight = hourHeights.values.reduce((a, b) => a + b);

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
                                Flexible(
                                  child: Text(
                                    timeFormatter(hour),
                                    style: widget.theme.timeTextStyle.copyWith(fontSize: widget.compact ? 10 : 11, height: 1.0),
                                    overflow: TextOverflow.clip,
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

                        // ✨ Calculate position with automatic dynamic heights
                        // Calculate cumulative offset for dynamic heights
                        double topOffset = 0;
                        for (int i = 0; i < hourIndex; i++) {
                          topOffset += hourHeights[hours[i]] ?? hourHeight;
                        }

                        // ✨ Use eventHeightBuilder if provided, otherwise use minEventHeight
                        final baseEventHeight = config.eventHeightBuilder?.call(event) ?? config.minEventHeight;

                        double eventHeight;
                        if (!shouldUseColumnLayout) {
                          // Vertical stacking: use pre-calculated stack position
                          final stackPosition = eventStackPositions[event] ?? 0;
                          final stackOffset = stackPosition * (baseEventHeight + config.eventSpacing);
                          topOffset += stackOffset;

                          // Use the calculated height from builder or default
                          eventHeight = baseEventHeight;
                        } else {
                          // Column layout: use calculated height from builder or minimum event height
                          eventHeight = baseEventHeight;
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

                        // Automatically detect and handle custom child widgets
                        Widget eventWidget;
                        if (widget.eventBuilderWithInfo != null) {
                          // User provided custom builder with render info
                          eventWidget = widget.eventBuilderWithInfo!(context, event, renderInfo);
                        } else if (widget.eventBuilder != null) {
                          // User provided simple custom builder
                          eventWidget = widget.eventBuilder!(context, event);
                        } else if (event.child != null) {
                          // ✨ AUTO-MAGIC: Event has custom child widget - wrap it with proper constraints
                          eventWidget = VooCalendarEventWidget(event: event, renderInfo: renderInfo, builder: (context, event, renderInfo) => event.child!);
                        } else {
                          // Default: Use standard event card
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
}

/// Event layout data for column-based layout
class _DayViewEventLayout {
  final VooCalendarEvent event;
  final int column;
  final int totalColumns;

  _DayViewEventLayout({required this.event, required this.column, required this.totalColumns});
}
