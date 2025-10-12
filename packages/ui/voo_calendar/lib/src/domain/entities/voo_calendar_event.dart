import 'package:flutter/material.dart';

/// Calendar event
class VooCalendarEvent {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final Widget? child;
  final Color? color;
  final IconData? icon;
  final bool isAllDay;
  final Map<String, dynamic>? metadata;

  const VooCalendarEvent({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.color,
    this.icon,
    this.isAllDay = false,
    this.metadata,
    this.child,
  });

  /// Creates a minimal calendar event for use with custom event builders.
  /// This constructor is useful when using [eventBuilder] or [eventBuilderWithInfo]
  /// where you provide your own child widget for rendering.
  ///
  /// Example:
  /// ```dart
  /// VooCalendarEvent.custom(
  ///   id: 'event-1',
  ///   startTime: DateTime(2025, 10, 11, 14, 0),
  ///   endTime: DateTime(2025, 10, 11, 15, 30),
  ///   child: MyCustomEventWidget(),
  ///   metadata: {'customData': myData},
  /// )
  /// ```
  const VooCalendarEvent.custom({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.child,
    this.color,
    this.metadata,
  }) : title = '',
       description = null,
       icon = null,
       isAllDay = false;

  Duration get duration => endTime.difference(startTime);

  bool isOnDate(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final startDateOnly = DateTime(
      startTime.year,
      startTime.month,
      startTime.day,
    );
    final endDateOnly = DateTime(endTime.year, endTime.month, endTime.day);

    return (dateOnly.isAtSameMomentAs(startDateOnly) ||
        dateOnly.isAtSameMomentAs(endDateOnly) ||
        (dateOnly.isAfter(startDateOnly) && dateOnly.isBefore(endDateOnly)));
  }
}
