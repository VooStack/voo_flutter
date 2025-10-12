import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

import 'package:voo_calendar/src/calendar.dart';
import 'package:voo_calendar/src/calendar_theme.dart';

/// Schedule event card widget for displaying events in schedule view
/// Atom component with extended layout for schedule view
class ScheduleEventCardWidget extends StatelessWidget {
  final VooCalendarEvent event;
  final VooCalendarTheme theme;
  final VoidCallback? onTap;
  final bool compact;

  const ScheduleEventCardWidget({
    super.key,
    required this.event,
    required this.theme,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(design.radiusSm),
      child: Container(
        padding: EdgeInsets.all(design.spacingMd),
        decoration: BoxDecoration(
          color: event.color?.withValues(alpha: 0.1) ??
              theme.eventBackgroundColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(design.radiusSm),
          border: Border.all(
            color: event.color?.withValues(alpha: 0.3) ??
                theme.eventBackgroundColor,
          ),
        ),
        child: Row(
          children: [
            if (event.icon != null) ...[
              Icon(
                event.icon,
                size: 20,
                color: event.color ?? theme.eventIndicatorColor,
              ),
              SizedBox(width: design.spacingMd),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: theme.eventTitleTextStyle.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (event.description != null && !compact) ...[
                    SizedBox(height: design.spacingXs),
                    Text(
                      event.description!,
                      style: theme.eventDescriptionTextStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (!event.isAllDay) ...[
              SizedBox(width: design.spacingMd),
              Text(
                '${DateFormat('HH:mm').format(event.startTime)} - ${DateFormat('HH:mm').format(event.endTime)}',
                style: theme.eventTimeTextStyle,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
