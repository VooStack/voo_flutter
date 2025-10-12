import 'package:flutter/material.dart';
import 'package:voo_calendar/src/calendar.dart';
import 'package:voo_calendar/src/domain/entities/voo_calendar_event_render_info.dart';

/// Base widget for rendering calendar events with proper dimension handling
/// Extend this class for custom event widgets that work correctly with
/// the calendar's dynamic height and column layout systems
abstract class BaseCalendarEventWidget extends StatelessWidget {
  /// The calendar event to render
  final VooCalendarEvent event;

  /// Rendering information (dimensions, layout context)
  final VooCalendarEventRenderInfo renderInfo;

  const BaseCalendarEventWidget({
    super.key,
    required this.event,
    required this.renderInfo,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: renderInfo.allocatedHeight,
      width: renderInfo.allocatedWidth,
      child: buildContent(context),
    );
  }

  /// Build the content of the event widget
  /// This is where you implement your custom rendering logic
  Widget buildContent(BuildContext context);
}
