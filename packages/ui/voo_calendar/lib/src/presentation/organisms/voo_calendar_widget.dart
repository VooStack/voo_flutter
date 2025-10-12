import 'package:flutter/material.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

import 'package:voo_calendar/src/calendar_config.dart';
import 'package:voo_calendar/src/calendar_gesture_config.dart';
import 'package:voo_calendar/src/calendar_theme.dart';
import 'package:voo_calendar/src/calendar_views.dart';
import 'package:voo_calendar/src/domain/entities/voo_calendar_event.dart';
import 'package:voo_calendar/src/domain/entities/voo_calendar_event_render_info.dart';
import 'package:voo_calendar/src/domain/enums/voo_calendar_selection_mode.dart';
import 'package:voo_calendar/src/domain/enums/voo_calendar_view.dart';
import 'package:voo_calendar/src/presentation/molecules/calendar_header_widget.dart';
import 'package:voo_calendar/src/presentation/molecules/calendar_view_switcher_widget.dart';
import 'package:voo_calendar/src/voo_calendar_controller.dart';

/// Highly customizable Material 3 calendar widget
class VooCalendar extends StatefulWidget {
  /// Controller for the calendar
  final VooCalendarController? controller;

  /// Initial date to display
  final DateTime? initialDate;

  /// First selectable date
  final DateTime? firstDate;

  /// Last selectable date
  final DateTime? lastDate;

  /// Initial view type
  final VooCalendarView initialView;

  /// Selection mode
  final VooCalendarSelectionMode selectionMode;

  /// Available views for view switcher
  final List<VooCalendarView> availableViews;

  /// Show view switcher
  final bool showViewSwitcher;

  /// Show navigation header
  final bool showHeader;

  /// Show week numbers
  final bool showWeekNumbers;

  /// First day of week (1 = Monday, 7 = Sunday)
  final int firstDayOfWeek;

  /// Custom header builder
  final Widget Function(BuildContext context, DateTime focusedDate)?
  headerBuilder;

  /// Date selected callback
  final void Function(DateTime date)? onDateSelected;

  /// Date range selected callback
  final void Function(DateTime? start, DateTime? end)? onRangeSelected;

  /// View changed callback
  final void Function(VooCalendarView view)? onViewChanged;

  /// Event tap callback
  final void Function(VooCalendarEvent event)? onEventTap;

  /// Custom day builder
  final Widget Function(
    BuildContext context,
    DateTime date,
    bool isSelected,
    bool isToday,
    bool isOutsideMonth,
    List<VooCalendarEvent> events,
  )?
  dayBuilder;

  /// Custom event builder (legacy - use eventBuilderWithInfo for better layout support)
  final Widget Function(BuildContext context, VooCalendarEvent event)?
  eventBuilder;

  /// Event builder with render info (recommended for day view)
  /// Provides allocated dimensions and layout context for proper rendering
  final Widget Function(
    BuildContext context,
    VooCalendarEvent event,
    VooCalendarEventRenderInfo renderInfo,
  )? eventBuilderWithInfo;

  /// Calendar decoration
  final BoxDecoration? decoration;

  /// Calendar theme
  final VooCalendarTheme? theme;

  /// Compact mode for smaller displays
  final bool compact;

  /// Enable swipe gestures for navigation
  final bool enableSwipeNavigation;

  /// Gesture configuration for advanced selection
  final VooCalendarGestureConfig? gestureConfig;

  /// Configuration for day view customization
  final VooDayViewConfig? dayViewConfig;

  /// Configuration for week view customization
  final VooWeekViewConfig? weekViewConfig;

  /// Configuration for month view customization
  final VooMonthViewConfig? monthViewConfig;

  /// Configuration for year view customization
  final VooYearViewConfig? yearViewConfig;

  /// Configuration for schedule view customization
  final VooScheduleViewConfig? scheduleViewConfig;

  const VooCalendar({
    super.key,
    this.controller,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.initialView = VooCalendarView.month,
    this.selectionMode = VooCalendarSelectionMode.single,
    this.availableViews = const [
      VooCalendarView.month,
      VooCalendarView.week,
      VooCalendarView.day,
    ],
    this.showViewSwitcher = true,
    this.showHeader = true,
    this.showWeekNumbers = false,
    this.firstDayOfWeek = 1,
    this.headerBuilder,
    this.onDateSelected,
    this.onRangeSelected,
    this.onViewChanged,
    this.onEventTap,
    this.dayBuilder,
    this.eventBuilder,
    this.eventBuilderWithInfo,
    this.decoration,
    this.theme,
    this.compact = false,
    this.enableSwipeNavigation = true,
    this.gestureConfig,
    this.dayViewConfig,
    this.weekViewConfig,
    this.monthViewConfig,
    this.yearViewConfig,
    this.scheduleViewConfig,
  });

  @override
  State<VooCalendar> createState() => _VooCalendarState();
}

class _VooCalendarState extends State<VooCalendar> {
  late VooCalendarController _controller;
  late VooCalendarTheme _theme;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        VooCalendarController(
          initialDate: widget.initialDate,
          initialView: widget.initialView,
          selectionMode: widget.selectionMode,
        );
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    _theme = widget.theme ?? VooCalendarTheme.fromContext(context);

    // Responsive breakpoints
    final screenWidth = MediaQuery.of(context).size.width;
    final isPhone = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 900;
    final isDesktop = screenWidth >= 900;

    // Adjust compact mode based on screen size
    final effectiveCompact = widget.compact || isPhone;

    // Adjust available views for small screens
    List<VooCalendarView> effectiveViews = widget.availableViews;
    if (isPhone && effectiveViews.contains(VooCalendarView.week)) {
      // On phone, prefer day view over week view
      effectiveViews = effectiveViews
          .map((v) => v == VooCalendarView.week ? VooCalendarView.day : v)
          .toList();
    }

    // Determine padding based on screen size
    final contentPadding = isDesktop
        ? EdgeInsets.all(design.spacingLg)
        : isTablet
        ? EdgeInsets.all(design.spacingMd)
        : EdgeInsets.all(design.spacingSm);

    return Container(
      padding: contentPadding,
      decoration:
          widget.decoration ??
          BoxDecoration(
            color: _theme.backgroundColor,
            borderRadius: BorderRadius.circular(design.radiusMd),
            border: Border.all(color: _theme.borderColor),
          ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showHeader) _buildHeader(design),
          if (widget.showViewSwitcher && effectiveViews.length > 1)
            _buildViewSwitcher(design),
          Expanded(
            child: _buildCalendarView(
              design,
              effectiveCompact: effectiveCompact,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(VooDesignSystemData design) {
    if (widget.headerBuilder != null) {
      return widget.headerBuilder!(context, _controller.focusedDate);
    }

    return CalendarHeaderWidget(
      focusedDate: _controller.focusedDate,
      currentView: _controller.currentView,
      theme: _theme,
      onPreviousPeriod: _controller.previousPeriod,
      onNextPeriod: _controller.nextPeriod,
      onTodayTap: _controller.goToToday,
      compact: widget.compact,
    );
  }

  Widget _buildViewSwitcher(VooDesignSystemData design) {
    return CalendarViewSwitcherWidget(
      availableViews: widget.availableViews,
      currentView: _controller.currentView,
      theme: _theme,
      onViewChanged: (view) {
        _controller.setView(view);
        widget.onViewChanged?.call(view);
      },
      compact: widget.compact,
    );
  }

  Widget _buildCalendarView(
    VooDesignSystemData design, {
    bool? effectiveCompact,
  }) {
    final compact = effectiveCompact ?? widget.compact;
    final content = switch (_controller.currentView) {
      VooCalendarView.month => VooCalendarMonthView(
        controller: _controller,
        theme: _theme,
        firstDayOfWeek: widget.monthViewConfig?.firstDayOfWeek ?? widget.firstDayOfWeek,
        showWeekNumbers: widget.monthViewConfig?.showWeekNumbers ?? widget.showWeekNumbers,
        dayBuilder: widget.dayBuilder,
        eventBuilder: widget.eventBuilder,
        onDateSelected: (date) {
          _controller.selectDate(date);
          widget.onDateSelected?.call(date);
          if (_controller.selectionMode == VooCalendarSelectionMode.range) {
            widget.onRangeSelected?.call(
              _controller.rangeStart,
              _controller.rangeEnd,
            );
          }
        },
        onEventTap: widget.onEventTap,
        compact: compact,
        gestureConfig: widget.gestureConfig,
        config: widget.monthViewConfig ?? const VooMonthViewConfig(),
      ),
      VooCalendarView.week => VooCalendarWeekView(
        controller: _controller,
        theme: _theme,
        firstDayOfWeek: widget.firstDayOfWeek,
        eventBuilder: widget.eventBuilder,
        onDateSelected: (date) {
          _controller.selectDate(date);
          widget.onDateSelected?.call(date);
        },
        onEventTap: widget.onEventTap,
        compact: compact,
      ),
      VooCalendarView.day => VooCalendarDayView(
        controller: _controller,
        theme: _theme,
        eventBuilder: widget.eventBuilder,
        eventBuilderWithInfo: widget.eventBuilderWithInfo,
        onEventTap: widget.onEventTap,
        compact: compact,
        config: widget.dayViewConfig ?? const VooDayViewConfig(),
      ),
      VooCalendarView.year => VooCalendarYearView(
        controller: _controller,
        theme: _theme,
        onMonthSelected: (month) {
          _controller.setFocusedDate(
            DateTime(_controller.focusedDate.year, month),
          );
          _controller.setView(VooCalendarView.month);
        },
        compact: compact,
      ),
      VooCalendarView.schedule => VooCalendarScheduleView(
        controller: _controller,
        theme: _theme,
        eventBuilder: widget.eventBuilder,
        onEventTap: widget.onEventTap,
        onDateSelected: (date) {
          _controller.selectDate(date);
          widget.onDateSelected?.call(date);
        },
        compact: compact,
      ),
    };

    if (widget.enableSwipeNavigation) {
      return GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            _controller.previousPeriod();
          } else if (details.primaryVelocity! < 0) {
            _controller.nextPeriod();
          }
        },
        child: content,
      );
    }

    return content;
  }
}
