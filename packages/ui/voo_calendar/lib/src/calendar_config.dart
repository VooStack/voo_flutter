import 'package:flutter/material.dart';

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

  /// Enable dynamic height adjustment based on number of events
  /// When true, hour slots will expand to fit all events without overlapping
  final bool enableDynamicHeight;

  /// Minimum height for each event when using dynamic height (default: 60.0)
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
  /// When true, overlapping events will be laid out side-by-side
  final bool enableColumnLayout;

  /// Width reserved for trailing builder content to prevent event overlap (default: 0)
  final double trailingBuilderWidth;

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
    this.enableDynamicHeight = false,
    this.minEventHeight = 60.0,
    this.eventSpacing = 8.0,
    this.eventLeftPadding = 8.0,
    this.eventRightPadding = 8.0,
    this.eventTopPadding = 4.0,
    this.eventBottomPadding = 4.0,
    this.eventHorizontalGap = 4.0,
    this.enableColumnLayout = true,
    this.trailingBuilderWidth = 0.0,
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
    bool? enableDynamicHeight,
    double? minEventHeight,
    double? eventSpacing,
    double? eventLeftPadding,
    double? eventRightPadding,
    double? eventTopPadding,
    double? eventBottomPadding,
    double? eventHorizontalGap,
    bool? enableColumnLayout,
    double? trailingBuilderWidth,
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
      enableDynamicHeight: enableDynamicHeight ?? this.enableDynamicHeight,
      minEventHeight: minEventHeight ?? this.minEventHeight,
      eventSpacing: eventSpacing ?? this.eventSpacing,
      eventLeftPadding: eventLeftPadding ?? this.eventLeftPadding,
      eventRightPadding: eventRightPadding ?? this.eventRightPadding,
      eventTopPadding: eventTopPadding ?? this.eventTopPadding,
      eventBottomPadding: eventBottomPadding ?? this.eventBottomPadding,
      eventHorizontalGap: eventHorizontalGap ?? this.eventHorizontalGap,
      enableColumnLayout: enableColumnLayout ?? this.enableColumnLayout,
      trailingBuilderWidth: trailingBuilderWidth ?? this.trailingBuilderWidth,
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

  const VooWeekViewConfig({
    this.hourHeight,
    this.scrollPhysics,
    this.showTimeLabels = true,
    this.timeColumnWidth,
    this.firstHour = 0,
    this.lastHour = 23,
  });

  /// Create a copy with modified properties
  VooWeekViewConfig copyWith({
    double? hourHeight,
    ScrollPhysics? scrollPhysics,
    bool? showTimeLabels,
    double? timeColumnWidth,
    int? firstHour,
    int? lastHour,
  }) {
    return VooWeekViewConfig(
      hourHeight: hourHeight ?? this.hourHeight,
      scrollPhysics: scrollPhysics ?? this.scrollPhysics,
      showTimeLabels: showTimeLabels ?? this.showTimeLabels,
      timeColumnWidth: timeColumnWidth ?? this.timeColumnWidth,
      firstHour: firstHour ?? this.firstHour,
      lastHour: lastHour ?? this.lastHour,
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

  const VooMonthViewConfig({
    this.showWeekNumbers = false,
    this.firstDayOfWeek = 1,
    this.weeksToShow = 6,
    this.showEventIndicators = true,
    this.maxEventIndicators = 3,
  });

  /// Create a copy with modified properties
  VooMonthViewConfig copyWith({
    bool? showWeekNumbers,
    int? firstDayOfWeek,
    int? weeksToShow,
    bool? showEventIndicators,
    int? maxEventIndicators,
  }) {
    return VooMonthViewConfig(
      showWeekNumbers: showWeekNumbers ?? this.showWeekNumbers,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      weeksToShow: weeksToShow ?? this.weeksToShow,
      showEventIndicators: showEventIndicators ?? this.showEventIndicators,
      maxEventIndicators: maxEventIndicators ?? this.maxEventIndicators,
    );
  }
}

/// Configuration for Year View
class VooYearViewConfig {
  /// Number of columns in the grid
  final int columns;

  /// Show event indicators on months
  final bool showEventIndicators;

  const VooYearViewConfig({
    this.columns = 4,
    this.showEventIndicators = true,
  });

  /// Create a copy with modified properties
  VooYearViewConfig copyWith({
    int? columns,
    bool? showEventIndicators,
  }) {
    return VooYearViewConfig(
      columns: columns ?? this.columns,
      showEventIndicators: showEventIndicators ?? this.showEventIndicators,
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

  const VooScheduleViewConfig({
    this.showDateHeaders = true,
    this.showEventIcons = true,
    this.groupByDate = true,
  });

  /// Create a copy with modified properties
  VooScheduleViewConfig copyWith({
    bool? showDateHeaders,
    bool? showEventIcons,
    bool? groupByDate,
  }) {
    return VooScheduleViewConfig(
      showDateHeaders: showDateHeaders ?? this.showDateHeaders,
      showEventIcons: showEventIcons ?? this.showEventIcons,
      groupByDate: groupByDate ?? this.groupByDate,
    );
  }
}
