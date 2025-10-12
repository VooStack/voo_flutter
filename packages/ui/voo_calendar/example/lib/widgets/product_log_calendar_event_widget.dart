import 'package:flutter/material.dart';
import 'package:voo_calendar/voo_calendar.dart';

/// Example implementation showing how to create a custom calendar event widget
/// that properly respects allocated dimensions for dynamic height layouts
///
/// This widget wraps your existing ProductLogListTile (or any widget) and
/// ensures it works correctly with the calendar's layout system
class ProductLogCalendarEventWidget extends BaseCalendarEventWidget {
  /// Your custom content builder
  final Widget Function(BuildContext context, VooCalendarEvent event) contentBuilder;

  const ProductLogCalendarEventWidget({
    super.key,
    required super.event,
    required super.renderInfo,
    required this.contentBuilder,
  });

  @override
  Widget buildContent(BuildContext context) {
    // The base class already wraps this in a SizedBox with proper dimensions
    // Your content will automatically respect the allocated height/width
    return contentBuilder(context, event);
  }
}

/// Alternative: Direct function approach if you don't want to extend BaseCalendarEventWidget
/// Use this in your VooCalendar's eventBuilderWithInfo parameter
Widget buildProductLogEvent(
  BuildContext context,
  VooCalendarEvent event,
  VooCalendarEventRenderInfo renderInfo,
  Widget Function(BuildContext context, VooCalendarEvent event) contentBuilder,
) {
  return SizedBox(
    height: renderInfo.allocatedHeight,
    width: renderInfo.allocatedWidth,
    child: contentBuilder(context, event),
  );
}
