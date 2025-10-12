import 'package:flutter/material.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

import 'package:voo_calendar/src/calendar.dart';
import 'package:voo_calendar/src/calendar_theme.dart';
import 'package:voo_calendar/src/presentation/atoms/event_card_widget.dart';
import 'package:voo_calendar/src/presentation/molecules/day_headers_widget.dart';

/// Week view for VooCalendar
class VooCalendarWeekView extends StatelessWidget {
  final VooCalendarController controller;
  final VooCalendarTheme theme;
  final int firstDayOfWeek;
  final void Function(DateTime date) onDateSelected;
  final void Function(VooCalendarEvent event)? onEventTap;
  final Widget Function(BuildContext context, VooCalendarEvent event)? eventBuilder;
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
    final firstDayOfWeekDate = focusedDate.subtract(Duration(days: daysFromStartOfWeek));

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
                      child: Text(compact ? '${hours[index]}' : '${hours[index].toString().padLeft(2, '0')}:00', style: theme.timeTextStyle),
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
              DayHeadersWidget(firstDay: firstDayOfWeekDate, theme: theme, controller: controller, onDateSelected: onDateSelected),
              // Day content
              Expanded(
                child: Row(
                  children: List.generate(7, (dayIndex) {
                    final date = firstDayOfWeekDate.add(Duration(days: dayIndex));
                    final events = controller.getEventsForDate(date);
                    final isSelected = controller.isDateSelected(date);
                    final isToday = _isToday(date);

                    return Expanded(child: _buildDayColumn(context, date, events, isSelected, isToday, design));
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDayColumn(BuildContext context, DateTime date, List<VooCalendarEvent> events, bool isSelected, bool isToday, VooDesignSystemData design) {
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
                      bottom: BorderSide(color: theme.gridLineColor, width: hour == 23 ? 0 : 0.5),
                    ),
                  ),
                ),
              );
            }),
          ),
          // Events
          ...events.map((event) {
            if (eventBuilder != null) {
              return Positioned(top: _getEventTop(event), left: 2, right: 2, height: _getEventHeight(event), child: eventBuilder!(context, event));
            }
            return Positioned(
              top: _getEventTop(event),
              left: 2,
              right: 2,
              height: _getEventHeight(event),
              child: EventCardWidget(event: event, theme: theme, onTap: () => onEventTap?.call(event), compact: compact),
            );
          }),
        ],
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
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}
