import 'package:flutter/material.dart';
import 'package:voo_calendar/src/domain/entities/voo_calendar_event.dart';

/// Configuration for Day View
class VooDayViewConfig {
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

  /// Builder to determine height for each event.
  /// Receives the event and returns the height in pixels.
  /// If not provided, uses minEventHeight for all events.
  ///
  /// Example:
  /// ```dart
  /// eventHeightBuilder: (event) {
  ///   // Custom widgets get taller heights
  ///   if (event.child != null) return 120.0;
  ///   // Error logs get medium height
  ///   if (event.metadata?['type'] == 'error') return 100.0;
  ///   // Default events use minimum height
  ///   return 80.0;
  /// }
  /// ```
  final double Function(VooCalendarEvent event)? eventHeightBuilder;

  /// Minimum height for each event when using dynamic height (default: 80.0)
  /// Used as fallback when eventHeightBuilder is not provided
  final double minEventHeight;

  /// Spacing between stacked events when using dynamic height (default: 8.0)
  final double eventSpacing;

  /// Left padding for events to prevent overlap with time labels (default: 8.0)
  final double eventLeftPadding;

  /// Right padding for events to prevent overlap with trailing builders (default: 8.0)
  final double eventRightPadding;

  /// Top padding for events within hour slots (default: 4.0)
  final double eventTopPadding;

  /// Bottom padding for events within hour slots (default: 4.0)
  final double eventBottomPadding;

  /// Minimum gap between events when multiple events are in the same hour (default: 4.0)
  final double eventHorizontalGap;

  /// Enable column layout for overlapping events (like Google Calendar)
  /// When true, overlapping events will be laid out side-by-side on desktop/tablet
  ///
  /// **Responsive Behavior:**
  /// - Mobile (< 600px): Automatically uses vertical stacking regardless of this setting
  /// - Tablet/Desktop (≥ 600px): Uses column layout when enabled
  ///
  /// This ensures optimal space utilization on all screen sizes.
  ///
  /// Note: Dynamic height is always enabled. Events are automatically sized using
  /// eventHeightBuilder or minEventHeight.
  final bool enableColumnLayout;

  /// Width reserved for trailing builder content to prevent event overlap (default: 0)
  final double trailingBuilderWidth;

  /// External scroll controller for programmatic scrolling
  /// If not provided, an internal controller will be created
  final ScrollController? scrollController;

  /// Whether to show a scrollbar (default: false)
  final bool showScrollbar;

  /// Padding around the day view content
  final EdgeInsetsGeometry? padding;

  const VooDayViewConfig({
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
    this.eventHeightBuilder,
    this.minEventHeight = 80.0,
    this.eventSpacing = 8.0,
    this.eventLeftPadding = 8.0,
    this.eventRightPadding = 8.0,
    this.eventTopPadding = 4.0,
    this.eventBottomPadding = 4.0,
    this.eventHorizontalGap = 4.0,
    this.enableColumnLayout = true,
    this.trailingBuilderWidth = 0.0,
    this.scrollController,
    this.showScrollbar = false,
    this.padding,
  });

  /// Create a copy with modified properties
  VooDayViewConfig copyWith({
    Widget Function(BuildContext context, int hour)? hourLineTrailingBuilder,
    Widget Function(BuildContext context, int hour)? hourLineLeadingBuilder,
    bool? showOnlyHoursWithEvents,
    double? hourHeight,
    String Function(int hour)? timeLabelFormatter,
    int? initialScrollHour,
    ScrollPhysics? scrollPhysics,
    bool? showTimeLabels,
    double? timeColumnWidth,
    int? firstHour,
    int? lastHour,
    Color? hourLineColor,
    double? hourLineThickness,
    bool? showHalfHourLines,
    void Function(int hour)? onHourLineTap,
    double Function(VooCalendarEvent event)? eventHeightBuilder,
    double? minEventHeight,
    double? eventSpacing,
    double? eventLeftPadding,
    double? eventRightPadding,
    double? eventTopPadding,
    double? eventBottomPadding,
    double? eventHorizontalGap,
    bool? enableColumnLayout,
    double? trailingBuilderWidth,
    ScrollController? scrollController,
    bool? showScrollbar,
    EdgeInsetsGeometry? padding,
  }) {
    return VooDayViewConfig(
      hourLineTrailingBuilder: hourLineTrailingBuilder ?? this.hourLineTrailingBuilder,
      hourLineLeadingBuilder: hourLineLeadingBuilder ?? this.hourLineLeadingBuilder,
      showOnlyHoursWithEvents: showOnlyHoursWithEvents ?? this.showOnlyHoursWithEvents,
      hourHeight: hourHeight ?? this.hourHeight,
      timeLabelFormatter: timeLabelFormatter ?? this.timeLabelFormatter,
      initialScrollHour: initialScrollHour ?? this.initialScrollHour,
      scrollPhysics: scrollPhysics ?? this.scrollPhysics,
      showTimeLabels: showTimeLabels ?? this.showTimeLabels,
      timeColumnWidth: timeColumnWidth ?? this.timeColumnWidth,
      firstHour: firstHour ?? this.firstHour,
      lastHour: lastHour ?? this.lastHour,
      hourLineColor: hourLineColor ?? this.hourLineColor,
      hourLineThickness: hourLineThickness ?? this.hourLineThickness,
      showHalfHourLines: showHalfHourLines ?? this.showHalfHourLines,
      onHourLineTap: onHourLineTap ?? this.onHourLineTap,
      eventHeightBuilder: eventHeightBuilder ?? this.eventHeightBuilder,
      minEventHeight: minEventHeight ?? this.minEventHeight,
      eventSpacing: eventSpacing ?? this.eventSpacing,
      eventLeftPadding: eventLeftPadding ?? this.eventLeftPadding,
      eventRightPadding: eventRightPadding ?? this.eventRightPadding,
      eventTopPadding: eventTopPadding ?? this.eventTopPadding,
      eventBottomPadding: eventBottomPadding ?? this.eventBottomPadding,
      eventHorizontalGap: eventHorizontalGap ?? this.eventHorizontalGap,
      enableColumnLayout: enableColumnLayout ?? this.enableColumnLayout,
      trailingBuilderWidth: trailingBuilderWidth ?? this.trailingBuilderWidth,
      scrollController: scrollController ?? this.scrollController,
      showScrollbar: showScrollbar ?? this.showScrollbar,
      padding: padding ?? this.padding,
    );
  }
}

/// Configuration for Week View
class VooWeekViewConfig {
  /// Custom hour height (default: 60.0)
  final double? hourHeight;

  /// Custom scroll physics
  final ScrollPhysics? scrollPhysics;

  /// Show/hide time labels
  final bool showTimeLabels;

  /// Time column width
  final double? timeColumnWidth;

  /// First hour to display (0-23)
  final int firstHour;

  /// Last hour to display (0-23)
  final int lastHour;

  /// Builder to determine height for each event.
  /// Receives the event and returns the height in pixels.
  /// If not provided, uses minEventHeight for all events.
  ///
  /// Example:
  /// ```dart
  /// eventHeightBuilder: (event) {
  ///   // Custom widgets get taller heights
  ///   if (event.child != null) return 120.0;
  ///   // Default events use minimum height
  ///   return 80.0;
  /// }
  /// ```
  final double Function(VooCalendarEvent event)? eventHeightBuilder;

  /// Minimum height for each event (default: 80.0)
  /// Used as fallback when eventHeightBuilder is not provided
  final double minEventHeight;

  /// External scroll controller for programmatic scrolling
  /// If not provided, an internal controller will be created
  final ScrollController? scrollController;

  /// Whether to show a scrollbar (default: false)
  final bool showScrollbar;

  /// Padding around the week view content
  final EdgeInsetsGeometry? padding;

  const VooWeekViewConfig({
    this.hourHeight,
    this.scrollPhysics,
    this.showTimeLabels = true,
    this.timeColumnWidth,
    this.firstHour = 0,
    this.lastHour = 23,
    this.eventHeightBuilder,
    this.minEventHeight = 80.0,
    this.scrollController,
    this.showScrollbar = false,
    this.padding,
  });

  /// Create a copy with modified properties
  VooWeekViewConfig copyWith({
    double? hourHeight,
    ScrollPhysics? scrollPhysics,
    bool? showTimeLabels,
    double? timeColumnWidth,
    int? firstHour,
    int? lastHour,
    double Function(VooCalendarEvent event)? eventHeightBuilder,
    double? minEventHeight,
    ScrollController? scrollController,
    bool? showScrollbar,
    EdgeInsetsGeometry? padding,
  }) {
    return VooWeekViewConfig(
      hourHeight: hourHeight ?? this.hourHeight,
      scrollPhysics: scrollPhysics ?? this.scrollPhysics,
      showTimeLabels: showTimeLabels ?? this.showTimeLabels,
      timeColumnWidth: timeColumnWidth ?? this.timeColumnWidth,
      firstHour: firstHour ?? this.firstHour,
      lastHour: lastHour ?? this.lastHour,
      eventHeightBuilder: eventHeightBuilder ?? this.eventHeightBuilder,
      minEventHeight: minEventHeight ?? this.minEventHeight,
      scrollController: scrollController ?? this.scrollController,
      showScrollbar: showScrollbar ?? this.showScrollbar,
      padding: padding ?? this.padding,
    );
  }
}

/// Configuration for Month View
class VooMonthViewConfig {
  /// Show week numbers
  final bool showWeekNumbers;

  /// First day of week (1 = Monday, 7 = Sunday)
  final int firstDayOfWeek;

  /// Number of weeks to display
  final int weeksToShow;

  /// Show events as indicators
  final bool showEventIndicators;

  /// Maximum number of event indicators to show
  final int maxEventIndicators;

  /// Builder to determine height for each event.
  /// Receives the event and returns the height in pixels.
  /// If not provided, uses minEventHeight for all events.
  ///
  /// Example:
  /// ```dart
  /// eventHeightBuilder: (event) {
  ///   // Custom widgets get taller heights
  ///   if (event.child != null) return 120.0;
  ///   // Default events use minimum height
  ///   return 80.0;
  /// }
  /// ```
  final double Function(VooCalendarEvent event)? eventHeightBuilder;

  /// Minimum height for each event (default: 80.0)
  /// Used as fallback when eventHeightBuilder is not provided
  final double minEventHeight;

  /// External scroll controller for programmatic scrolling
  /// If not provided, an internal controller will be created
  final ScrollController? scrollController;

  /// Whether to show a scrollbar (default: false)
  final bool showScrollbar;

  /// Padding around the month view content
  final EdgeInsetsGeometry? padding;

  const VooMonthViewConfig({
    this.showWeekNumbers = false,
    this.firstDayOfWeek = 1,
    this.weeksToShow = 6,
    this.showEventIndicators = true,
    this.maxEventIndicators = 3,
    this.eventHeightBuilder,
    this.minEventHeight = 80.0,
    this.scrollController,
    this.showScrollbar = false,
    this.padding,
  });

  /// Create a copy with modified properties
  VooMonthViewConfig copyWith({
    bool? showWeekNumbers,
    int? firstDayOfWeek,
    int? weeksToShow,
    bool? showEventIndicators,
    int? maxEventIndicators,
    double Function(VooCalendarEvent event)? eventHeightBuilder,
    double? minEventHeight,
    ScrollController? scrollController,
    bool? showScrollbar,
    EdgeInsetsGeometry? padding,
  }) {
    return VooMonthViewConfig(
      showWeekNumbers: showWeekNumbers ?? this.showWeekNumbers,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      weeksToShow: weeksToShow ?? this.weeksToShow,
      showEventIndicators: showEventIndicators ?? this.showEventIndicators,
      maxEventIndicators: maxEventIndicators ?? this.maxEventIndicators,
      eventHeightBuilder: eventHeightBuilder ?? this.eventHeightBuilder,
      minEventHeight: minEventHeight ?? this.minEventHeight,
      scrollController: scrollController ?? this.scrollController,
      showScrollbar: showScrollbar ?? this.showScrollbar,
      padding: padding ?? this.padding,
    );
  }
}

/// Configuration for Year View
class VooYearViewConfig {
  /// Number of columns in the grid
  final int columns;

  /// Show event indicators on months
  final bool showEventIndicators;

  /// External scroll controller for programmatic scrolling
  /// If not provided, an internal controller will be created
  final ScrollController? scrollController;

  /// Whether to show a scrollbar (default: false)
  final bool showScrollbar;

  /// Padding around the year view content
  final EdgeInsetsGeometry? padding;

  const VooYearViewConfig({
    this.columns = 4,
    this.showEventIndicators = true,
    this.scrollController,
    this.showScrollbar = false,
    this.padding,
  });

  /// Create a copy with modified properties
  VooYearViewConfig copyWith({
    int? columns,
    bool? showEventIndicators,
    ScrollController? scrollController,
    bool? showScrollbar,
    EdgeInsetsGeometry? padding,
  }) {
    return VooYearViewConfig(
      columns: columns ?? this.columns,
      showEventIndicators: showEventIndicators ?? this.showEventIndicators,
      scrollController: scrollController ?? this.scrollController,
      showScrollbar: showScrollbar ?? this.showScrollbar,
      padding: padding ?? this.padding,
    );
  }
}

/// Configuration for Schedule View
class VooScheduleViewConfig {
  /// Show date headers
  final bool showDateHeaders;

  /// Show event icons
  final bool showEventIcons;

  /// Group events by date
  final bool groupByDate;

  /// External scroll controller for programmatic scrolling
  /// If not provided, an internal controller will be created
  final ScrollController? scrollController;

  /// Whether to show a scrollbar (default: false)
  final bool showScrollbar;

  /// Padding around the schedule view content
  final EdgeInsetsGeometry? padding;

  const VooScheduleViewConfig({
    this.showDateHeaders = true,
    this.showEventIcons = true,
    this.groupByDate = true,
    this.scrollController,
    this.showScrollbar = false,
    this.padding,
  });

  /// Create a copy with modified properties
  VooScheduleViewConfig copyWith({
    bool? showDateHeaders,
    bool? showEventIcons,
    bool? groupByDate,
    ScrollController? scrollController,
    bool? showScrollbar,
    EdgeInsetsGeometry? padding,
  }) {
    return VooScheduleViewConfig(
      showDateHeaders: showDateHeaders ?? this.showDateHeaders,
      showEventIcons: showEventIcons ?? this.showEventIcons,
      groupByDate: groupByDate ?? this.groupByDate,
      scrollController: scrollController ?? this.scrollController,
      showScrollbar: showScrollbar ?? this.showScrollbar,
      padding: padding ?? this.padding,
    );
  }
}
