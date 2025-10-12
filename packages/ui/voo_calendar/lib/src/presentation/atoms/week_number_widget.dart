import 'package:flutter/material.dart';

import 'package:voo_calendar/src/calendar_theme.dart';

/// Week number widget for displaying week numbers in calendar
/// Atom component following atomic design principles
class WeekNumberWidget extends StatelessWidget {
  final int weekNumber;
  final VooCalendarTheme theme;

  const WeekNumberWidget({
    super.key,
    required this.weekNumber,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.weekNumberBackgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          weekNumber.toString(),
          style: theme.weekNumberTextStyle,
        ),
      ),
    );
  }
}
