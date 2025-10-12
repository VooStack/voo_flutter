import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

import 'package:voo_calendar/src/calendar.dart';
import 'package:voo_calendar/src/calendar_theme.dart';

/// Day headers widget for calendar week view
/// Molecule component following atomic design principles
class DayHeadersWidget extends StatelessWidget {
  final DateTime firstDay;
  final VooCalendarTheme theme;
  final VooCalendarController controller;
  final void Function(DateTime date) onDateSelected;

  const DayHeadersWidget({
    super.key,
    required this.firstDay,
    required this.theme,
    required this.controller,
    required this.onDateSelected,
  });

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;

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
}
