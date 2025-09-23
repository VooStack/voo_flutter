import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voo_ui_core/voo_ui_core.dart';
import 'calendar_theme.dart';
import 'calendar_views.dart';

/// Calendar view types
enum VooCalendarView {
  /// Month view showing all days in a month grid
  month,

  /// Week view showing 7 days horizontally
  week,

  /// Day view showing single day with hourly slots
  day,

  /// Year view showing all months in a year
  year,

  /// Schedule view showing events as a list
  schedule,
}

/// Calendar selection mode
enum VooCalendarSelectionMode {
  /// No selection allowed
  none,

  /// Single date selection
  single,

  /// Multiple individual dates
  multiple,

  /// Date range selection
  range,
}

/// Calendar event
class VooCalendarEvent {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
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
  });

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

enum SelectionFeedback { none, haptic, visual, both }

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
}

/// Highly customizable Material 3 calendar widget
class VooCalendar extends StatefulWidget {
  /// Controller for the calendar
  final VooCalendarController? controller;

  /// Initial date to display
  final DateTime? initialDate;

  /// First selectable date
  final DateTime? firstDate;

  /// Last selectable date
  final DateTime? lastDate;

  /// Initial view type
  final VooCalendarView initialView;

  /// Selection mode
  final VooCalendarSelectionMode selectionMode;

  /// Available views for view switcher
  final List<VooCalendarView> availableViews;

  /// Show view switcher
  final bool showViewSwitcher;

  /// Show navigation header
  final bool showHeader;

  /// Show week numbers
  final bool showWeekNumbers;

  /// First day of week (1 = Monday, 7 = Sunday)
  final int firstDayOfWeek;

  /// Custom header builder
  final Widget Function(BuildContext context, DateTime focusedDate)?
  headerBuilder;

  /// Date selected callback
  final void Function(DateTime date)? onDateSelected;

  /// Date range selected callback
  final void Function(DateTime? start, DateTime? end)? onRangeSelected;

  /// View changed callback
  final void Function(VooCalendarView view)? onViewChanged;

  /// Event tap callback
  final void Function(VooCalendarEvent event)? onEventTap;

  /// Custom day builder
  final Widget Function(
    BuildContext context,
    DateTime date,
    bool isSelected,
    bool isToday,
    bool isOutsideMonth,
    List<VooCalendarEvent> events,
  )?
  dayBuilder;

  /// Custom event builder
  final Widget Function(BuildContext context, VooCalendarEvent event)?
  eventBuilder;

  /// Calendar decoration
  final BoxDecoration? decoration;

  /// Calendar theme
  final VooCalendarTheme? theme;

  /// Compact mode for smaller displays
  final bool compact;

  /// Enable swipe gestures for navigation
  final bool enableSwipeNavigation;

  /// Gesture configuration for advanced selection
  final VooCalendarGestureConfig? gestureConfig;

  const VooCalendar({
    super.key,
    this.controller,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.initialView = VooCalendarView.month,
    this.selectionMode = VooCalendarSelectionMode.single,
    this.availableViews = const [
      VooCalendarView.month,
      VooCalendarView.week,
      VooCalendarView.day,
    ],
    this.showViewSwitcher = true,
    this.showHeader = true,
    this.showWeekNumbers = false,
    this.firstDayOfWeek = 1,
    this.headerBuilder,
    this.onDateSelected,
    this.onRangeSelected,
    this.onViewChanged,
    this.onEventTap,
    this.dayBuilder,
    this.eventBuilder,
    this.decoration,
    this.theme,
    this.compact = false,
    this.enableSwipeNavigation = true,
    this.gestureConfig,
  });

  @override
  State<VooCalendar> createState() => _VooCalendarState();
}

class _VooCalendarState extends State<VooCalendar> {
  late VooCalendarController _controller;
  late VooCalendarTheme _theme;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        VooCalendarController(
          initialDate: widget.initialDate,
          initialView: widget.initialView,
          selectionMode: widget.selectionMode,
        );
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    _theme = widget.theme ?? VooCalendarTheme.fromContext(context);

    // Responsive breakpoints
    final screenWidth = MediaQuery.of(context).size.width;
    final isPhone = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 900;
    final isDesktop = screenWidth >= 900;

    // Adjust compact mode based on screen size
    final effectiveCompact = widget.compact || isPhone;

    // Adjust available views for small screens
    List<VooCalendarView> effectiveViews = widget.availableViews;
    if (isPhone && effectiveViews.contains(VooCalendarView.week)) {
      // On phone, prefer day view over week view
      effectiveViews = effectiveViews
          .map((v) => v == VooCalendarView.week ? VooCalendarView.day : v)
          .toList();
    }

    // Determine padding based on screen size
    final contentPadding = isDesktop
        ? EdgeInsets.all(design.spacingLg)
        : isTablet
        ? EdgeInsets.all(design.spacingMd)
        : EdgeInsets.all(design.spacingSm);

    return Container(
      padding: contentPadding,
      decoration:
          widget.decoration ??
          BoxDecoration(
            color: _theme.backgroundColor,
            borderRadius: BorderRadius.circular(design.radiusMd),
            border: Border.all(color: _theme.borderColor),
          ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showHeader) _buildHeader(design),
          if (widget.showViewSwitcher && effectiveViews.length > 1)
            _buildViewSwitcher(design),
          Expanded(
            child: _buildCalendarView(
              design,
              effectiveCompact: effectiveCompact,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(VooDesignSystemData design) {
    if (widget.headerBuilder != null) {
      return widget.headerBuilder!(context, _controller.focusedDate);
    }

    final formatString = switch (_controller.currentView) {
      VooCalendarView.month => 'MMMM yyyy',
      VooCalendarView.week => 'MMM d - ',
      VooCalendarView.day => 'EEEE, MMMM d, yyyy',
      VooCalendarView.year => 'yyyy',
      VooCalendarView.schedule => 'MMMM yyyy',
    };

    String headerText = DateFormat(
      formatString,
    ).format(_controller.focusedDate);

    if (_controller.currentView == VooCalendarView.week) {
      final weekEnd = _controller.focusedDate.add(const Duration(days: 6));
      if (_controller.focusedDate.month != weekEnd.month) {
        headerText += DateFormat('MMM d, yyyy').format(weekEnd);
      } else {
        headerText += DateFormat('d, yyyy').format(weekEnd);
      }
    }

    return Container(
      padding: EdgeInsets.all(design.spacingMd),
      decoration: BoxDecoration(
        color: _theme.headerBackgroundColor,
        border: Border(bottom: BorderSide(color: _theme.borderColor)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _controller.previousPeriod,
            tooltip: 'Previous',
          ),
          Expanded(
            child: Text(
              headerText,
              style: _theme.headerTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _controller.nextPeriod,
            tooltip: 'Next',
          ),
          if (!widget.compact) ...[
            SizedBox(width: design.spacingMd),
            OutlinedButton(
              onPressed: _controller.goToToday,
              child: const Text('Today'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildViewSwitcher(VooDesignSystemData design) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: design.spacingMd,
        vertical: design.spacingSm,
      ),
      decoration: BoxDecoration(
        color: _theme.headerBackgroundColor.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(color: _theme.borderColor, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SegmentedButton<VooCalendarView>(
            segments: widget.availableViews.map((view) {
              IconData icon;
              String label;
              switch (view) {
                case VooCalendarView.month:
                  icon = Icons.calendar_view_month;
                  label = 'Month';
                  break;
                case VooCalendarView.week:
                  icon = Icons.calendar_view_week;
                  label = 'Week';
                  break;
                case VooCalendarView.day:
                  icon = Icons.calendar_view_day;
                  label = 'Day';
                  break;
                case VooCalendarView.year:
                  icon = Icons.calendar_today;
                  label = 'Year';
                  break;
                case VooCalendarView.schedule:
                  icon = Icons.schedule;
                  label = 'Schedule';
                  break;
              }
              return ButtonSegment(
                value: view,
                icon: Icon(icon, size: widget.compact ? 18 : null),
                label: widget.compact ? null : Text(label),
              );
            }).toList(),
            selected: {_controller.currentView},
            onSelectionChanged: (selection) {
              _controller.setView(selection.first);
              widget.onViewChanged?.call(selection.first);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarView(
    VooDesignSystemData design, {
    bool? effectiveCompact,
  }) {
    final compact = effectiveCompact ?? widget.compact;
    final content = switch (_controller.currentView) {
      VooCalendarView.month => VooCalendarMonthView(
        controller: _controller,
        theme: _theme,
        firstDayOfWeek: widget.firstDayOfWeek,
        showWeekNumbers: widget.showWeekNumbers,
        dayBuilder: widget.dayBuilder,
        eventBuilder: widget.eventBuilder,
        onDateSelected: (date) {
          _controller.selectDate(date);
          widget.onDateSelected?.call(date);
          if (_controller.selectionMode == VooCalendarSelectionMode.range) {
            widget.onRangeSelected?.call(
              _controller.rangeStart,
              _controller.rangeEnd,
            );
          }
        },
        onEventTap: widget.onEventTap,
        compact: compact,
        gestureConfig: widget.gestureConfig,
      ),
      VooCalendarView.week => VooCalendarWeekView(
        controller: _controller,
        theme: _theme,
        firstDayOfWeek: widget.firstDayOfWeek,
        eventBuilder: widget.eventBuilder,
        onDateSelected: (date) {
          _controller.selectDate(date);
          widget.onDateSelected?.call(date);
        },
        onEventTap: widget.onEventTap,
        compact: compact,
      ),
      VooCalendarView.day => VooCalendarDayView(
        controller: _controller,
        theme: _theme,
        eventBuilder: widget.eventBuilder,
        onEventTap: widget.onEventTap,
        compact: compact,
      ),
      VooCalendarView.year => VooCalendarYearView(
        controller: _controller,
        theme: _theme,
        onMonthSelected: (month) {
          _controller.setFocusedDate(
            DateTime(_controller.focusedDate.year, month),
          );
          _controller.setView(VooCalendarView.month);
        },
        compact: compact,
      ),
      VooCalendarView.schedule => VooCalendarScheduleView(
        controller: _controller,
        theme: _theme,
        eventBuilder: widget.eventBuilder,
        onEventTap: widget.onEventTap,
        onDateSelected: (date) {
          _controller.selectDate(date);
          widget.onDateSelected?.call(date);
        },
        compact: compact,
      ),
    };

    if (widget.enableSwipeNavigation) {
      return GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            _controller.previousPeriod();
          } else if (details.primaryVelocity! < 0) {
            _controller.nextPeriod();
          }
        },
        child: content,
      );
    }

    return content;
  }
}
