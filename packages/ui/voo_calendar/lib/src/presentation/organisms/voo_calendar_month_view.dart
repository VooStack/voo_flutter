import 'package:flutter/material.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

import 'package:voo_calendar/src/calendar.dart';
import 'package:voo_calendar/src/calendar_config.dart';
import 'package:voo_calendar/src/calendar_theme.dart';
import 'package:voo_calendar/src/presentation/atoms/calendar_day_cell_widget.dart';
import 'package:voo_calendar/src/presentation/atoms/week_number_widget.dart';
import 'package:voo_calendar/src/presentation/molecules/weekday_headers_widget.dart';

/// Month view for VooCalendar
class VooCalendarMonthView extends StatefulWidget {
  final VooCalendarController controller;
  final VooCalendarTheme theme;
  final int firstDayOfWeek;
  final bool showWeekNumbers;
  final void Function(DateTime date) onDateSelected;
  final void Function(VooCalendarEvent event)? onEventTap;
  final Widget Function(BuildContext context, DateTime date, bool isSelected, bool isToday, bool isOutsideMonth, List<VooCalendarEvent> events)? dayBuilder;
  final Widget Function(BuildContext context, VooCalendarEvent event)? eventBuilder;
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
    int daysFromStartOfWeek = (firstDayOfMonth.weekday - widget.firstDayOfWeek) % 7;
    final firstDateToShow = firstDayOfMonth.subtract(Duration(days: daysFromStartOfWeek));

    // Calculate total days to show (always show 6 weeks)
    const int weeksToShow = 6;
    const int daysToShow = weeksToShow * 7;

    // Build index to date mapping for gesture detection
    _indexToDate.clear();
    for (int i = 0; i < daysToShow; i++) {
      _indexToDate[i] = firstDateToShow.add(Duration(days: i));
    }

    final gestureConfig = widget.gestureConfig ?? const VooCalendarGestureConfig();

    return Column(
      children: [
        // Weekday headers
        WeekdayHeadersWidget(theme: widget.theme, firstDayOfWeek: widget.firstDayOfWeek, showWeekNumbers: widget.showWeekNumbers, compact: widget.compact),
        // Calendar grid with gesture detection
        Expanded(
          child: GestureDetector(
            onPanStart: gestureConfig.enableDragSelection
                ? (details) {
                    final RenderBox box = context.findRenderObject() as RenderBox;
                    final localPosition = box.globalToLocal(details.globalPosition);
                    _handleDragStart(localPosition, design);
                  }
                : null,
            onPanUpdate: gestureConfig.enableDragSelection
                ? (details) {
                    final RenderBox box = context.findRenderObject() as RenderBox;
                    final localPosition = box.globalToLocal(details.globalPosition);
                    _handleDragUpdate(localPosition, design);
                  }
                : null,
            onPanEnd: gestureConfig.enableDragSelection ? (_) => _handleDragEnd() : null,
            child: GridView.builder(
              padding: EdgeInsets.all(design.spacingMd),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.showWeekNumbers ? 8 : 7,
                mainAxisSpacing: design.spacingXs,
                crossAxisSpacing: design.spacingXs,
                childAspectRatio: widget.compact ? 1.2 : 1.0,
              ),
              itemCount: daysToShow + (widget.showWeekNumbers ? weeksToShow : 0),
              itemBuilder: (context, index) {
                if (widget.showWeekNumbers && index % 8 == 0) {
                  // Week number cell
                  final weekIndex = index ~/ 8;
                  final weekDate = firstDateToShow.add(Duration(days: weekIndex * 7));
                  return WeekNumberWidget(weekNumber: _getWeekNumber(weekDate), theme: widget.theme);
                }

                final dayIndex = widget.showWeekNumbers ? index - (index ~/ 8) - 1 : index;

                if (dayIndex < 0 || dayIndex >= daysToShow) {
                  return const SizedBox.shrink();
                }

                final date = firstDateToShow.add(Duration(days: dayIndex));
                final isOutsideMonth = date.month != focusedDate.month;
                final isToday = _isToday(date);
                final isSelected = widget.controller.isDateSelected(date) || widget.controller.isDragSelecting(date);
                final isRangeStart = widget.controller.isRangeStart(date);
                final isRangeEnd = widget.controller.isRangeEnd(date);
                final isInRange = widget.controller.isDateInRange(date);
                final events = widget.controller.getEventsForDate(date);

                if (widget.dayBuilder != null) {
                  return GestureDetector(
                    onTap: () => widget.onDateSelected(date),
                    onLongPress: gestureConfig.enableLongPressRange ? () => widget.controller.startDragSelection(date) : null,
                    child: widget.dayBuilder!(context, date, isSelected, isToday, isOutsideMonth, events),
                  );
                }

                return CalendarDayCellWidget(
                  date: date,
                  theme: widget.theme,
                  isSelected: isSelected,
                  isToday: isToday,
                  isOutsideMonth: isOutsideMonth,
                  isRangeStart: isRangeStart,
                  isRangeEnd: isRangeEnd,
                  isInRange: isInRange,
                  events: events,
                  onTap: () => widget.onDateSelected(date),
                  compact: widget.compact,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  int _getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return ((daysSinceFirstDay + firstDayOfYear.weekday - 1) / 7).ceil();
  }
}
