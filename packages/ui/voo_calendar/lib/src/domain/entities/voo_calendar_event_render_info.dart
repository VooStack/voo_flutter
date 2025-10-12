/// Information about how an event should be rendered in the calendar
/// Provides dimensions and context for custom event builders
class VooCalendarEventRenderInfo {
  /// The allocated height for this event
  final double allocatedHeight;

  /// The allocated width for this event (null if full width)
  final double? allocatedWidth;

  /// Whether the calendar is in compact mode
  final bool isCompact;

  /// Whether this is a mobile layout (<600px)
  final bool isMobile;

  /// The hour height being used
  final double hourHeight;

  const VooCalendarEventRenderInfo({
    required this.allocatedHeight,
    this.allocatedWidth,
    required this.isCompact,
    required this.isMobile,
    required this.hourHeight,
  });

  /// Creates a copy with updated values
  VooCalendarEventRenderInfo copyWith({
    double? allocatedHeight,
    double? allocatedWidth,
    bool? isCompact,
    bool? isMobile,
    double? hourHeight,
  }) {
    return VooCalendarEventRenderInfo(
      allocatedHeight: allocatedHeight ?? this.allocatedHeight,
      allocatedWidth: allocatedWidth ?? this.allocatedWidth,
      isCompact: isCompact ?? this.isCompact,
      isMobile: isMobile ?? this.isMobile,
      hourHeight: hourHeight ?? this.hourHeight,
    );
  }
}
