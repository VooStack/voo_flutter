import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

import 'package:voo_calendar/src/calendar.dart';
import 'package:voo_calendar/src/calendar_theme.dart';

/// Calendar header widget with navigation and title
/// Molecule component following atomic design principles
class CalendarHeaderWidget extends StatelessWidget {
  final DateTime focusedDate;
  final VooCalendarView currentView;
  final VooCalendarTheme theme;
  final VoidCallback onPreviousPeriod;
  final VoidCallback onNextPeriod;
  final VoidCallback onTodayTap;
  final bool compact;

  const CalendarHeaderWidget({
    super.key,
    required this.focusedDate,
    required this.currentView,
    required this.theme,
    required this.onPreviousPeriod,
    required this.onNextPeriod,
    required this.onTodayTap,
    this.compact = false,
  });

  String _getHeaderText() {
    final formatString = switch (currentView) {
      VooCalendarView.month => 'MMMM yyyy',
      VooCalendarView.week => 'MMM d - ',
      VooCalendarView.day => 'EEEE, MMMM d, yyyy',
      VooCalendarView.year => 'yyyy',
      VooCalendarView.schedule => 'MMMM yyyy',
    };

    String headerText = DateFormat(formatString).format(focusedDate);

    if (currentView == VooCalendarView.week) {
      final weekEnd = focusedDate.add(const Duration(days: 6));
      if (focusedDate.month != weekEnd.month) {
        headerText += DateFormat('MMM d, yyyy').format(weekEnd);
      } else {
        headerText += DateFormat('d, yyyy').format(weekEnd);
      }
    }

    return headerText;
  }

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;

    return Container(
      padding: EdgeInsets.all(design.spacingMd),
      decoration: BoxDecoration(
        color: theme.headerBackgroundColor,
        border: Border(bottom: BorderSide(color: theme.borderColor)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onPreviousPeriod,
            tooltip: 'Previous',
          ),
          Expanded(
            child: Text(
              _getHeaderText(),
              style: theme.headerTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onNextPeriod,
            tooltip: 'Next',
          ),
          if (!compact) ...[
            SizedBox(width: design.spacingMd),
            OutlinedButton(
              onPressed: onTodayTap,
              child: const Text('Today'),
            ),
          ],
        ],
      ),
    );
  }
}
