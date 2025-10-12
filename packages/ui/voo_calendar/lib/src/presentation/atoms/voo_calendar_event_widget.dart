import 'package:flutter/material.dart';
import 'package:voo_calendar/src/calendar.dart';
import 'package:voo_calendar/src/domain/entities/voo_calendar_event_render_info.dart';

/// Official widget for rendering custom calendar events with proper dimension handling
///
/// Automatically constrains child widgets to respect the calendar's allocated dimensions,
/// preventing overflow into adjacent hour slots or events.
///
/// This widget follows Flutter's composition pattern - use either `child` for static content
/// or `builder` when you need access to event data.
///
/// **Example 1: Simple child wrapper**
/// ```dart
/// VooCalendarEventWidget(
///   renderInfo: renderInfo,
///   child: ProductLogListTile(productLog: productLog),
/// )
/// ```
///
/// **Example 2: Builder with event data**
/// ```dart
/// VooCalendarEventWidget(
///   event: event,
///   renderInfo: renderInfo,
///   builder: (context, event, renderInfo) {
///     final productLog = event.metadata?['productLog'] as ProductLog;
///     return ProductLogListTile(productLog: productLog);
///   },
/// )
/// ```
///
/// **Features:**
/// - Automatic dimension handling (allocatedHeight, allocatedWidth)
/// - Built-in overflow protection
/// - Works with dynamic height and column layouts
/// - Composition over inheritance (Flutter best practice)
class VooCalendarEventWidget extends StatelessWidget {
  /// The calendar event to render (required when using builder)
  final VooCalendarEvent? event;

  /// Rendering information (dimensions, layout context)
  final VooCalendarEventRenderInfo renderInfo;

  /// Static child widget (use when you don't need event data)
  final Widget? child;

  /// Builder function (use when you need access to event data)
  final Widget Function(BuildContext context, VooCalendarEvent event, VooCalendarEventRenderInfo renderInfo)? builder;

  /// Creates a VooCalendarEventWidget with proper dimension constraints
  ///
  /// Either [child] or [builder] must be provided (but not both).
  /// If using [builder], [event] is required.
  const VooCalendarEventWidget({super.key, this.event, required this.renderInfo, this.child, this.builder})
    : assert((child != null) != (builder != null), 'Either child or builder must be provided, but not both.'),
      assert(builder == null || event != null, 'When using builder, event must be provided.');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: renderInfo.allocatedHeight,
      width: renderInfo.allocatedWidth,
      child: ClipRect(
        // Prevent custom widgets from overflowing their allocated space
        child: child ?? builder!(context, event!, renderInfo),
      ),
    );
  }
}
