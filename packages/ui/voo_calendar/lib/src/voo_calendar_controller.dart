import 'package:flutter/material.dart';

import 'package:voo_calendar/src/domain/entities/voo_calendar_event.dart';
import 'package:voo_calendar/src/domain/enums/voo_calendar_selection_mode.dart';
import 'package:voo_calendar/src/domain/enums/voo_calendar_view.dart';

/// Calendar controller
class VooCalendarController extends ChangeNotifier {
  DateTime _selectedDate;
  DateTime _focusedDate;
  VooCalendarView _currentView;
  final Set<DateTime> _selectedDates = {};
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  final List<VooCalendarEvent> _events = [];
  VooCalendarSelectionMode _selectionMode;

  // Gesture selection state
  DateTime? _dragStartDate;
  DateTime? _dragEndDate;
  bool _isDragging = false;
  final Set<DateTime> _tempSelectedDates = {};

  // Scroll controllers for different views
  ScrollController? _dayViewScrollController;
  ScrollController? _weekViewScrollController;
  ScrollController? _scheduleViewScrollController;
  ScrollController? _monthViewScrollController;
  ScrollController? _yearViewScrollController;

  VooCalendarController({
    DateTime? initialDate,
    VooCalendarView initialView = VooCalendarView.month,
    VooCalendarSelectionMode selectionMode = VooCalendarSelectionMode.single,
  }) : _selectedDate = initialDate ?? DateTime.now(),
       _focusedDate = initialDate ?? DateTime.now(),
       _currentView = initialView,
       _selectionMode = selectionMode {
    if (selectionMode == VooCalendarSelectionMode.single) {
      _selectedDates.add(_selectedDate);
    }
  }

  DateTime get selectedDate => _selectedDate;
  DateTime get focusedDate => _focusedDate;
  VooCalendarView get currentView => _currentView;
  Set<DateTime> get selectedDates => Set.unmodifiable(_selectedDates);
  DateTime? get rangeStart => _rangeStart;
  DateTime? get rangeEnd => _rangeEnd;
  List<VooCalendarEvent> get events => List.unmodifiable(_events);
  VooCalendarSelectionMode get selectionMode => _selectionMode;

  void setView(VooCalendarView view) {
    _currentView = view;
    notifyListeners();
  }

  void setSelectionMode(VooCalendarSelectionMode mode) {
    _selectionMode = mode;
    _clearSelection();
    notifyListeners();
  }

  void selectDate(DateTime date) {
    switch (_selectionMode) {
      case VooCalendarSelectionMode.none:
        break;
      case VooCalendarSelectionMode.single:
        _selectedDate = date;
        _selectedDates.clear();
        _selectedDates.add(date);
        break;
      case VooCalendarSelectionMode.multiple:
        if (_selectedDates.contains(date)) {
          _selectedDates.remove(date);
        } else {
          _selectedDates.add(date);
        }
        _selectedDate = date;
        break;
      case VooCalendarSelectionMode.range:
        if (_rangeStart == null || (_rangeStart != null && _rangeEnd != null)) {
          _rangeStart = date;
          _rangeEnd = null;
        } else {
          if (date.isBefore(_rangeStart!)) {
            _rangeEnd = _rangeStart;
            _rangeStart = date;
          } else {
            _rangeEnd = date;
          }
        }
        _selectedDate = date;
        break;
    }
    notifyListeners();
  }

  // Gesture selection methods
  void startDragSelection(DateTime date) {
    _isDragging = true;
    _dragStartDate = date;
    _dragEndDate = date;
    _tempSelectedDates.clear();

    if (_selectionMode == VooCalendarSelectionMode.range) {
      _rangeStart = date;
      _rangeEnd = null;
    } else if (_selectionMode == VooCalendarSelectionMode.multiple) {
      _tempSelectedDates.add(date);
    }
    notifyListeners();
  }

  void updateDragSelection(DateTime date) {
    if (!_isDragging || _dragStartDate == null) return;

    _dragEndDate = date;

    if (_selectionMode == VooCalendarSelectionMode.range) {
      if (date.isBefore(_dragStartDate!)) {
        _rangeStart = date;
        _rangeEnd = _dragStartDate;
      } else {
        _rangeStart = _dragStartDate;
        _rangeEnd = date;
      }
    } else if (_selectionMode == VooCalendarSelectionMode.multiple) {
      _tempSelectedDates.clear();
      // Add all dates between start and current
      final start = date.isBefore(_dragStartDate!) ? date : _dragStartDate!;
      final end = date.isBefore(_dragStartDate!) ? _dragStartDate! : date;

      for (
        var d = start;
        d.isBefore(end) || d.isAtSameMomentAs(end);
        d = d.add(const Duration(days: 1))
      ) {
        _tempSelectedDates.add(d);
      }
    }
    notifyListeners();
  }

  void endDragSelection() {
    if (!_isDragging) return;

    _isDragging = false;

    if (_selectionMode == VooCalendarSelectionMode.multiple) {
      _selectedDates.addAll(_tempSelectedDates);
      _tempSelectedDates.clear();
    }

    _dragStartDate = null;
    _dragEndDate = null;
    notifyListeners();
  }

  bool isDragSelecting(DateTime date) {
    if (!_isDragging) return false;

    if (_selectionMode == VooCalendarSelectionMode.multiple) {
      return _tempSelectedDates.contains(date);
    } else if (_selectionMode == VooCalendarSelectionMode.range &&
        _dragStartDate != null &&
        _dragEndDate != null) {
      final start = _dragStartDate!.isBefore(_dragEndDate!)
          ? _dragStartDate!
          : _dragEndDate!;
      final end = _dragStartDate!.isBefore(_dragEndDate!)
          ? _dragEndDate!
          : _dragStartDate!;
      return date.isAtSameMomentAs(start) ||
          date.isAtSameMomentAs(end) ||
          (date.isAfter(start) && date.isBefore(end));
    }

    return false;
  }

  void setFocusedDate(DateTime date) {
    _focusedDate = date;
    notifyListeners();
  }

  void addEvent(VooCalendarEvent event) {
    _events.add(event);
    notifyListeners();
  }

  void removeEvent(String eventId) {
    _events.removeWhere((e) => e.id == eventId);
    notifyListeners();
  }

  void setEvents(List<VooCalendarEvent> events) {
    _events.clear();
    _events.addAll(events);
    notifyListeners();
  }

  List<VooCalendarEvent> getEventsForDate(DateTime date) {
    return _events.where((event) => event.isOnDate(date)).toList();
  }

  bool isDateSelected(DateTime date) {
    if (_selectionMode == VooCalendarSelectionMode.single ||
        _selectionMode == VooCalendarSelectionMode.multiple) {
      return _selectedDates.any(
        (selected) =>
            selected.year == date.year &&
            selected.month == date.month &&
            selected.day == date.day,
      );
    } else if (_selectionMode == VooCalendarSelectionMode.range &&
        _rangeStart != null &&
        _rangeEnd != null) {
      return date.isAtSameMomentAs(_rangeStart!) ||
          date.isAtSameMomentAs(_rangeEnd!) ||
          (date.isAfter(_rangeStart!) && date.isBefore(_rangeEnd!));
    }
    return false;
  }

  bool isDateInRange(DateTime date) {
    if (_selectionMode == VooCalendarSelectionMode.range &&
        _rangeStart != null &&
        _rangeEnd != null) {
      return date.isAfter(_rangeStart!) && date.isBefore(_rangeEnd!);
    }
    return false;
  }

  bool isRangeStart(DateTime date) {
    return _rangeStart != null &&
        date.year == _rangeStart!.year &&
        date.month == _rangeStart!.month &&
        date.day == _rangeStart!.day;
  }

  bool isRangeEnd(DateTime date) {
    return _rangeEnd != null &&
        date.year == _rangeEnd!.year &&
        date.month == _rangeEnd!.month &&
        date.day == _rangeEnd!.day;
  }

  void _clearSelection() {
    _selectedDates.clear();
    _rangeStart = null;
    _rangeEnd = null;
  }

  void nextPeriod() {
    switch (_currentView) {
      case VooCalendarView.month:
        _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1);
        break;
      case VooCalendarView.week:
        _focusedDate = _focusedDate.add(const Duration(days: 7));
        break;
      case VooCalendarView.day:
        _focusedDate = _focusedDate.add(const Duration(days: 1));
        break;
      case VooCalendarView.year:
        _focusedDate = DateTime(_focusedDate.year + 1, _focusedDate.month);
        break;
      case VooCalendarView.schedule:
        _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1);
        break;
    }
    notifyListeners();
  }

  void previousPeriod() {
    switch (_currentView) {
      case VooCalendarView.month:
        _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1);
        break;
      case VooCalendarView.week:
        _focusedDate = _focusedDate.subtract(const Duration(days: 7));
        break;
      case VooCalendarView.day:
        _focusedDate = _focusedDate.subtract(const Duration(days: 1));
        break;
      case VooCalendarView.year:
        _focusedDate = DateTime(_focusedDate.year - 1, _focusedDate.month);
        break;
      case VooCalendarView.schedule:
        _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1);
        break;
    }
    notifyListeners();
  }

  void goToToday() {
    _focusedDate = DateTime.now();
    notifyListeners();
  }

  // Scroll controller getters
  ScrollController? get dayViewScrollController => _dayViewScrollController;
  ScrollController? get weekViewScrollController => _weekViewScrollController;
  ScrollController? get scheduleViewScrollController => _scheduleViewScrollController;
  ScrollController? get monthViewScrollController => _monthViewScrollController;
  ScrollController? get yearViewScrollController => _yearViewScrollController;

  /// Attach scroll controllers to this calendar controller
  /// This allows you to control scrolling programmatically
  void attachDayViewScrollController(ScrollController controller) {
    _dayViewScrollController = controller;
  }

  void attachWeekViewScrollController(ScrollController controller) {
    _weekViewScrollController = controller;
  }

  void attachScheduleViewScrollController(ScrollController controller) {
    _scheduleViewScrollController = controller;
  }

  void attachMonthViewScrollController(ScrollController controller) {
    _monthViewScrollController = controller;
  }

  void attachYearViewScrollController(ScrollController controller) {
    _yearViewScrollController = controller;
  }

  /// Detach scroll controllers
  void detachDayViewScrollController() {
    _dayViewScrollController = null;
  }

  void detachWeekViewScrollController() {
    _weekViewScrollController = null;
  }

  void detachScheduleViewScrollController() {
    _scheduleViewScrollController = null;
  }

  void detachMonthViewScrollController() {
    _monthViewScrollController = null;
  }

  void detachYearViewScrollController() {
    _yearViewScrollController = null;
  }

  /// Scroll to a specific hour in day view
  /// [hour] - The hour to scroll to (0-23)
  /// [hourHeight] - Height of each hour in pixels (default: 60.0)
  /// [animated] - Whether to animate the scroll (default: true)
  /// [duration] - Duration of animation (default: 300ms)
  /// [curve] - Animation curve (default: Curves.easeOutCubic)
  void scrollToHourInDayView({
    required int hour,
    double hourHeight = 60.0,
    bool animated = true,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOutCubic,
  }) {
    if (_dayViewScrollController == null || !_dayViewScrollController!.hasClients) {
      return;
    }

    final offset = hour * hourHeight;
    if (animated) {
      _dayViewScrollController!.animateTo(
        offset,
        duration: duration,
        curve: curve,
      );
    } else {
      _dayViewScrollController!.jumpTo(offset);
    }
  }

  /// Scroll to a specific event in day view
  /// Calculates the scroll position based on the event's start time
  /// [event] - The event to scroll to
  /// [hourHeight] - Height of each hour in pixels (default: 60.0)
  /// [animated] - Whether to animate the scroll (default: true)
  /// [duration] - Duration of animation (default: 300ms)
  /// [curve] - Animation curve (default: Curves.easeOutCubic)
  void scrollToEventInDayView({
    required VooCalendarEvent event,
    double hourHeight = 60.0,
    bool animated = true,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOutCubic,
  }) {
    if (_dayViewScrollController == null || !_dayViewScrollController!.hasClients) {
      return;
    }

    final hour = event.startTime.hour;
    final minute = event.startTime.minute;
    final offset = (hour + minute / 60) * hourHeight;

    if (animated) {
      _dayViewScrollController!.animateTo(
        offset,
        duration: duration,
        curve: curve,
      );
    } else {
      _dayViewScrollController!.jumpTo(offset);
    }
  }

  /// Scroll to a specific date in schedule view
  /// [date] - The date to scroll to
  /// [animated] - Whether to animate the scroll (default: true)
  /// [duration] - Duration of animation (default: 300ms)
  /// [curve] - Animation curve (default: Curves.easeOutCubic)
  void scrollToDateInScheduleView({
    required DateTime date,
    bool animated = true,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOutCubic,
  }) {
    if (_scheduleViewScrollController == null || !_scheduleViewScrollController!.hasClients) {
      return;
    }

    // Group events by date to find the index
    final Map<DateTime, List<VooCalendarEvent>> eventsByDate = {};
    for (final event in _events) {
      final dateKey = DateTime(event.startTime.year, event.startTime.month, event.startTime.day);
      eventsByDate.putIfAbsent(dateKey, () => []).add(event);
    }

    final sortedDates = eventsByDate.keys.toList()..sort();
    final targetDate = DateTime(date.year, date.month, date.day);
    final index = sortedDates.indexWhere((d) =>
      d.year == targetDate.year && d.month == targetDate.month && d.day == targetDate.day
    );

    if (index == -1) return;

    // Estimate offset (this is approximate - actual offset depends on item heights)
    // Each date section is roughly 100px + events
    final offset = index * 150.0;

    if (animated) {
      _scheduleViewScrollController!.animateTo(
        offset,
        duration: duration,
        curve: curve,
      );
    } else {
      _scheduleViewScrollController!.jumpTo(offset);
    }
  }

  /// Scroll to a specific event in schedule view
  /// [event] - The event to scroll to
  /// [animated] - Whether to animate the scroll (default: true)
  /// [duration] - Duration of animation (default: 300ms)
  /// [curve] - Animation curve (default: Curves.easeOutCubic)
  void scrollToEventInScheduleView({
    required VooCalendarEvent event,
    bool animated = true,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOutCubic,
  }) {
    scrollToDateInScheduleView(
      date: event.startTime,
      animated: animated,
      duration: duration,
      curve: curve,
    );
  }

  @override
  void dispose() {
    // Note: We don't dispose scroll controllers here because they may be managed externally
    // Users should dispose their own controllers if they create them
    super.dispose();
  }
}
