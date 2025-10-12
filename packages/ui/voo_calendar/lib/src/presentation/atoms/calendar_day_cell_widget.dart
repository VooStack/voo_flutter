import 'package:flutter/material.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

import 'package:voo_calendar/src/calendar.dart';
import 'package:voo_calendar/src/calendar_theme.dart';

/// Calendar day cell widget for displaying individual days
/// Atom component following atomic design principles
class CalendarDayCellWidget extends StatelessWidget {
  final DateTime date;
  final VooCalendarTheme theme;
  final bool isSelected;
  final bool isToday;
  final bool isOutsideMonth;
  final bool isRangeStart;
  final bool isRangeEnd;
  final bool isInRange;
  final List<VooCalendarEvent> events;
  final VoidCallback? onTap;
  final bool compact;

  const CalendarDayCellWidget({
    super.key,
    required this.date,
    required this.theme,
    required this.isSelected,
    required this.isToday,
    required this.isOutsideMonth,
    required this.isRangeStart,
    required this.isRangeEnd,
    required this.isInRange,
    required this.events,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;

    Color? backgroundColor;
    Color? textColor;
    BoxDecoration? decoration;

    if (isSelected || isRangeStart || isRangeEnd) {
      backgroundColor = theme.selectedDayBackgroundColor;
      textColor = theme.selectedDayTextColor;
    } else if (isInRange) {
      backgroundColor = theme.rangeBackgroundColor;
      textColor = theme.dayTextColor;
    } else if (isToday) {
      backgroundColor = theme.todayBackgroundColor;
      textColor = theme.todayTextColor;
    }

    if (isRangeStart) {
      decoration = BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(design.radiusSm),
          bottomLeft: Radius.circular(design.radiusSm),
          topRight: isRangeEnd ? Radius.circular(design.radiusSm) : Radius.zero,
          bottomRight:
              isRangeEnd ? Radius.circular(design.radiusSm) : Radius.zero,
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
      textColor = theme.outsideMonthTextColor;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(design.radiusSm),
      child: Container(
        decoration: decoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              date.day.toString(),
              style: theme.dayTextStyle.copyWith(
                color: textColor,
                fontWeight: isToday ? FontWeight.bold : null,
              ),
            ),
            if (events.isNotEmpty && !compact) ...[
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: events.take(3).map((event) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: event.color ?? theme.eventIndicatorColor,
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
}
