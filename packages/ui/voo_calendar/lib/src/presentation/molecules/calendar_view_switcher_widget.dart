import 'package:flutter/material.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

import 'package:voo_calendar/src/calendar.dart';
import 'package:voo_calendar/src/calendar_theme.dart';

/// Calendar view switcher widget for switching between calendar views
/// Molecule component following atomic design principles
class CalendarViewSwitcherWidget extends StatelessWidget {
  final List<VooCalendarView> availableViews;
  final VooCalendarView currentView;
  final VooCalendarTheme theme;
  final void Function(VooCalendarView view) onViewChanged;
  final bool compact;

  const CalendarViewSwitcherWidget({
    super.key,
    required this.availableViews,
    required this.currentView,
    required this.theme,
    required this.onViewChanged,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: design.spacingMd,
        vertical: design.spacingSm,
      ),
      decoration: BoxDecoration(
        color: theme.headerBackgroundColor.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(color: theme.borderColor, width: 0.5),
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SegmentedButton<VooCalendarView>(
            segments: availableViews.map((view) {
              IconData icon;
              String label;
              switch (view) {
                case VooCalendarView.month:
                  icon = Icons.calendar_view_month;
                  label = 'Month';
                  break;
                case VooCalendarView.week:
                  icon = Icons.calendar_view_week;
                  label = 'Week';
                  break;
                case VooCalendarView.day:
                  icon = Icons.calendar_view_day;
                  label = 'Day';
                  break;
                case VooCalendarView.year:
                  icon = Icons.calendar_today;
                  label = 'Year';
                  break;
                case VooCalendarView.schedule:
                  icon = Icons.schedule;
                  label = 'Schedule';
                  break;
              }
              return ButtonSegment(
                value: view,
                icon: Icon(icon, size: compact ? 18 : null),
                label: compact ? null : Text(label),
              );
            }).toList(),
            selected: {currentView},
            onSelectionChanged: (selection) => onViewChanged(selection.first),
          ),
        ),
      ),
    );
  }
}
