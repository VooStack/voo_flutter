import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

import 'package:voo_calendar/src/calendar.dart';
import 'package:voo_calendar/src/calendar_theme.dart';

/// Event card widget for displaying calendar events
/// Atom component following atomic design principles
class EventCardWidget extends StatelessWidget {
  final VooCalendarEvent event;
  final VooCalendarTheme theme;
  final VoidCallback? onTap;
  final bool compact;
  final double? allocatedHeight;
  final EdgeInsets? padding;

  const EventCardWidget({
    super.key,
    required this.event,
    required this.theme,
    this.onTap,
    this.compact = false,
    this.allocatedHeight,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final showDescription = event.description != null &&
        !compact &&
        (allocatedHeight == null || allocatedHeight! > 40);
    final showTime = allocatedHeight == null || allocatedHeight! > 30;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(design.radiusXs),
      child: Container(
        padding: padding ?? EdgeInsets.all(design.spacingXs),
        decoration: BoxDecoration(
          color: event.color ?? theme.eventBackgroundColor,
          borderRadius: BorderRadius.circular(design.radiusXs),
          border: Border.all(
            color: (event.color ?? theme.eventBackgroundColor)
                .withValues(alpha: 0.8),
          ),
          boxShadow: allocatedHeight != null
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (event.icon != null) ...[
                  Icon(
                    event.icon,
                    size: 12,
                    color: Colors.white,
                  ),
                  SizedBox(width: design.spacingXs),
                ],
                Expanded(
                  child: Text(
                    event.title,
                    style: theme.eventTitleTextStyle.copyWith(
                      fontSize: compact ? 11 : 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: compact ? 1 : 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (showDescription) ...[
              SizedBox(height: design.spacingXs),
              Text(
                event.description!,
                style: theme.eventDescriptionTextStyle.copyWith(
                  fontSize: 10,
                ),
                maxLines: compact ? 1 : 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (showTime)
              Text(
                DateFormat('HH:mm').format(event.startTime),
                style: theme.eventTimeTextStyle.copyWith(fontSize: 9),
              ),
          ],
        ),
      ),
    );
  }
}
