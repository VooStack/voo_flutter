import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

import 'package:voo_calendar/src/calendar.dart';
import 'package:voo_calendar/src/calendar_theme.dart';

/// Year view for VooCalendar
class VooCalendarYearView extends StatelessWidget {
  final VooCalendarController controller;
  final VooCalendarTheme theme;
  final void Function(int month) onMonthSelected;
  final bool compact;

  const VooCalendarYearView({super.key, required this.controller, required this.theme, required this.onMonthSelected, required this.compact});

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final year = controller.focusedDate.year;

    return GridView.builder(
      padding: EdgeInsets.all(design.spacingLg),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: compact ? 3 : 4,
        mainAxisSpacing: design.spacingMd,
        crossAxisSpacing: design.spacingMd,
        childAspectRatio: compact ? 1.2 : 1.5,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        final month = index + 1;
        final monthDate = DateTime(year, month);
        final monthName = DateFormat('MMMM').format(monthDate);
        final hasEvents = controller.events.any((event) => event.startTime.year == year && event.startTime.month == month);

        return InkWell(
          onTap: () => onMonthSelected(month),
          borderRadius: BorderRadius.circular(design.radiusMd),
          child: Container(
            padding: EdgeInsets.all(design.spacingMd),
            decoration: BoxDecoration(
              border: Border.all(color: theme.borderColor),
              borderRadius: BorderRadius.circular(design.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(monthName, style: theme.monthTextStyle),
                const Spacer(),
                if (hasEvents) ...[
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(color: theme.eventIndicatorColor, shape: BoxShape.circle),
                      ),
                      SizedBox(width: design.spacingXs),
                      Text('Has events', style: theme.eventDescriptionTextStyle),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
