import 'package:flutter/material.dart';
import 'package:voo_calendar/src/calendar.dart';
import 'package:voo_calendar/src/domain/entities/voo_calendar_event_render_info.dart';

/// Official widget for rendering custom calendar events with proper dimension handling
///
/// Extend this class to create custom event widgets that automatically work correctly
/// with the calendar's dynamic height and column layout systems.
///
/// Example:
/// ```dart
/// class ProductEventWidget extends VooCalendarEventWidget {
///   final ProductLog productLog;
///
///   const ProductEventWidget({
///     super.key,
///     required super.event,
///     required super.renderInfo,
///     required this.productLog,
///   });
///
///   @override
///   Widget buildContent(BuildContext context) {
///     return ProductLogListTile(productLog: productLog);
///   }
/// }
/// ```
abstract class VooCalendarEventWidget extends StatelessWidget {
  /// The calendar event to render
  final VooCalendarEvent event;

  /// Rendering information (dimensions, layout context)
  final VooCalendarEventRenderInfo renderInfo;

  const VooCalendarEventWidget({
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
