import 'package:flutter/material.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

import 'package:voo_calendar/src/calendar_theme.dart';

/// Weekday headers widget for calendar month view
/// Molecule component following atomic design principles
class WeekdayHeadersWidget extends StatelessWidget {
  final VooCalendarTheme theme;
  final int firstDayOfWeek;
  final bool showWeekNumbers;
  final bool compact;

  const WeekdayHeadersWidget({
    super.key,
    required this.theme,
    required this.firstDayOfWeek,
    this.showWeekNumbers = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    // Rotate weekdays based on firstDayOfWeek
    final rotatedWeekdays = [
      ...weekdays.sublist(firstDayOfWeek - 1),
      ...weekdays.sublist(0, firstDayOfWeek - 1),
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: design.spacingMd),
      height: 32,
      decoration: BoxDecoration(
        color: theme.headerBackgroundColor.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(color: theme.borderColor, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          if (showWeekNumbers)
            SizedBox(
              width: 40,
              child: Center(
                child: Text('W', style: theme.weekdayTextStyle),
              ),
            ),
          ...rotatedWeekdays.map(
            (day) => Expanded(
              child: Center(
                child: Text(
                  compact ? day[0] : day,
                  style: theme.weekdayTextStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
