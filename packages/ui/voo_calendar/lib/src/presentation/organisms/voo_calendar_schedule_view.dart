import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

import 'package:voo_calendar/src/calendar.dart';
import 'package:voo_calendar/src/calendar_theme.dart';
import 'package:voo_calendar/src/presentation/atoms/schedule_event_card_widget.dart';

/// Schedule view for VooCalendar
class VooCalendarScheduleView extends StatelessWidget {
  final VooCalendarController controller;
  final VooCalendarTheme theme;
  final void Function(DateTime date) onDateSelected;
  final void Function(VooCalendarEvent event)? onEventTap;
  final Widget Function(BuildContext context, VooCalendarEvent event)? eventBuilder;
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
      final dateKey = DateTime(event.startTime.year, event.startTime.month, event.startTime.day);
      eventsByDate.putIfAbsent(dateKey, () => []).add(event);
    }

    final sortedDates = eventsByDate.keys.toList()..sort();

    if (sortedDates.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 48, color: theme.outsideMonthTextColor),
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
                    Text('${events.length} event${events.length == 1 ? '' : 's'}', style: theme.eventDescriptionTextStyle),
                  ],
                ),
              ),
            ),
            SizedBox(height: design.spacingSm),
            // Events for this date
            ...events.map((event) {
              if (eventBuilder != null) {
                return Padding(
                  padding: EdgeInsets.only(left: design.spacingLg, bottom: design.spacingSm),
                  child: eventBuilder!(context, event),
                );
              }
              return Padding(
                padding: EdgeInsets.only(left: design.spacingLg, bottom: design.spacingSm),
                child: ScheduleEventCardWidget(event: event, theme: theme, onTap: () => onEventTap?.call(event), compact: compact),
              );
            }),
            if (index < sortedDates.length - 1) Divider(height: design.spacingLg * 2),
          ],
        );
      },
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}
