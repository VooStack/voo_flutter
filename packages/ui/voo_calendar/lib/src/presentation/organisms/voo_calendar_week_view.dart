import 'package:flutter/material.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

import 'package:voo_calendar/src/calendar.dart';
import 'package:voo_calendar/src/calendar_config.dart';
import 'package:voo_calendar/src/calendar_theme.dart';
import 'package:voo_calendar/src/presentation/atoms/event_card_widget.dart';
import 'package:voo_calendar/src/presentation/molecules/day_headers_widget.dart';

/// Week view for VooCalendar
class VooCalendarWeekView extends StatefulWidget {
  final VooCalendarController controller;
  final VooCalendarTheme theme;
  final int firstDayOfWeek;
  final void Function(DateTime date) onDateSelected;
  final void Function(VooCalendarEvent event)? onEventTap;
  final Widget Function(BuildContext context, VooCalendarEvent event)? eventBuilder;
  final bool compact;
  final VooWeekViewConfig config;

  static const double _hourHeight = 60.0;

  const VooCalendarWeekView({
    super.key,
    required this.controller,
    required this.theme,
    required this.firstDayOfWeek,
    required this.onDateSelected,
    this.onEventTap,
    this.eventBuilder,
    required this.compact,
    this.config = const VooWeekViewConfig(),
  });

  @override
  State<VooCalendarWeekView> createState() => _VooCalendarWeekViewState();
}

class _VooCalendarWeekViewState extends State<VooCalendarWeekView> {
  late ScrollController _scrollController;
  bool _ownsScrollController = false;

  @override
  void initState() {
    super.initState();
    // Use external controller if provided, otherwise create internal one
    if (widget.config.scrollController != null) {
      _scrollController = widget.config.scrollController!;
      _ownsScrollController = false;
    } else {
      _scrollController = ScrollController();
      _ownsScrollController = true;
    }

    // Attach scroll controller to calendar controller for programmatic access
    widget.controller.attachWeekViewScrollController(_scrollController);
  }

  @override
  void dispose() {
    // Only dispose if we own the controller
    if (_ownsScrollController) {
      _scrollController.dispose();
    }
    widget.controller.detachWeekViewScrollController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final focusedDate = widget.controller.focusedDate;

    // Calculate first day of week
    int daysFromStartOfWeek = (focusedDate.weekday - widget.firstDayOfWeek) % 7;
    final firstDayOfWeekDate = focusedDate.subtract(Duration(days: daysFromStartOfWeek));

    // Generate hours based on config (default 0-24)
    final hours = List.generate(widget.config.lastHour - widget.config.firstHour + 1, (i) => widget.config.firstHour + i);

    // Merge base padding with scrollPadding
    final basePadding = widget.config.padding ?? EdgeInsets.zero;
    final scrollPadding = widget.config.scrollPadding ?? EdgeInsets.zero;
    final topPadding = basePadding.resolve(TextDirection.ltr).top + scrollPadding.top;
    final bottomPadding = basePadding.resolve(TextDirection.ltr).bottom + scrollPadding.bottom;
    final leftPadding = basePadding.resolve(TextDirection.ltr).left + scrollPadding.left;
    final rightPadding = basePadding.resolve(TextDirection.ltr).right + scrollPadding.right;

    Widget content = Padding(
      padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
      child: Row(
        children: [
          // Time column
          SizedBox(
            width: widget.compact ? 40 : 60,
            child: Column(
              children: [
                // Header spacer
                Container(height: 60),
                // Hour labels
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
                    itemCount: hours.length,
                    itemExtent: 60,
                    itemBuilder: (context, index) {
                      // Hour 24 represents midnight of the next day, display as 00:00
                      final hour = hours[index];
                      final displayHour = hour == 24 ? 0 : hour;
                      return Container(
                        padding: EdgeInsets.only(right: design.spacingXs),
                        alignment: Alignment.topRight,
                        child: Text(widget.compact ? '$displayHour' : '${displayHour.toString().padLeft(2, '0')}:00', style: widget.theme.timeTextStyle),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Days columns
          Expanded(
            child: Column(
              children: [
                // Day headers
                DayHeadersWidget(firstDay: firstDayOfWeekDate, theme: widget.theme, controller: widget.controller, onDateSelected: widget.onDateSelected),
                // Day content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
                    child: Row(
                      children: List.generate(7, (dayIndex) {
                        final date = firstDayOfWeekDate.add(Duration(days: dayIndex));
                        final events = widget.controller.getEventsForDate(date);
                        final isSelected = widget.controller.isDateSelected(date);
                        final isToday = _isToday(date);

                        return Expanded(child: _buildDayColumn(context, date, events, isSelected, isToday, design));
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // Wrap with scrollbar if needed
    if (widget.config.showScrollbar) {
      content = Scrollbar(controller: _scrollController, child: content);
    }

    return content;
  }

  Widget _buildDayColumn(BuildContext context, DateTime date, List<VooCalendarEvent> events, bool isSelected, bool isToday, VooDesignSystemData design) {
    return Container(
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: widget.theme.gridLineColor)),
        color: isSelected
            ? widget.theme.selectedDayBackgroundColor.withValues(alpha: 0.1)
            : isToday
            ? widget.theme.todayBackgroundColor.withValues(alpha: 0.05)
            : null,
      ),
      child: Stack(
        children: [
          // Hour grid
          Column(
            children: List.generate(24, (hour) {
              return Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: widget.theme.gridLineColor, width: hour == 23 ? 0 : 0.5),
                    ),
                  ),
                ),
              );
            }),
          ),
          // Events
          ...events.map((event) {
            if (widget.eventBuilder != null) {
              return Positioned(top: _getEventTop(event), left: 2, right: 2, height: _getEventHeight(event), child: widget.eventBuilder!(context, event));
            }
            return Positioned(
              top: _getEventTop(event),
              left: 2,
              right: 2,
              height: _getEventHeight(event),
              child: EventCardWidget(event: event, theme: widget.theme, onTap: () => widget.onEventTap?.call(event), compact: widget.compact),
            );
          }),
        ],
      ),
    );
  }

  double _getEventTop(VooCalendarEvent event) {
    final hour = event.startTime.hour;
    final minute = event.startTime.minute;
    return (hour + minute / 60) * VooCalendarWeekView._hourHeight;
  }

  double _getEventHeight(VooCalendarEvent event) {
    final duration = event.duration.inMinutes;
    return (duration / 60) * VooCalendarWeekView._hourHeight;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}
