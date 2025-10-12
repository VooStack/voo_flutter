import 'package:voo_calendar/src/domain/enums/selection_feedback.dart';

/// Gesture configuration for calendar selection
class VooCalendarGestureConfig {
  /// Enable drag selection for multiple dates
  final bool enableDragSelection;

  /// Enable long press to start range selection
  final bool enableLongPressRange;

  /// Enable swipe to change months/weeks/days
  final bool enableSwipeNavigation;

  /// Minimum drag distance to start selection
  final double dragThreshold;

  /// Selection feedback type
  final SelectionFeedback selectionFeedback;

  /// Allow diagonal drag selection
  final bool allowDiagonalSelection;

  const VooCalendarGestureConfig({
    this.enableDragSelection = true,
    this.enableLongPressRange = true,
    this.enableSwipeNavigation = true,
    this.dragThreshold = 10.0,
    this.selectionFeedback = SelectionFeedback.haptic,
    this.allowDiagonalSelection = true,
  });
}
