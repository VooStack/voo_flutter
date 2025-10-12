import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

import 'package:voo_calendar/src/calendar.dart';
import 'package:voo_calendar/src/calendar_config.dart';
import 'package:voo_calendar/src/calendar_theme.dart';
import 'package:voo_calendar/src/presentation/atoms/schedule_event_card_widget.dart';

/// Schedule view for VooCalendar
class VooCalendarScheduleView extends StatefulWidget {
  final VooCalendarController controller;
  final VooCalendarTheme theme;
  final void Function(DateTime date) onDateSelected;
  final void Function(VooCalendarEvent event)? onEventTap;
  final Widget Function(BuildContext context, VooCalendarEvent event)? eventBuilder;
  final bool compact;
  final VooScheduleViewConfig config;

  const VooCalendarScheduleView({
    super.key,
    required this.controller,
    required this.theme,
    required this.onDateSelected,
    this.onEventTap,
    this.eventBuilder,
    required this.compact,
    this.config = const VooScheduleViewConfig(),
  });

  @override
  State<VooCalendarScheduleView> createState() => _VooCalendarScheduleViewState();
}

class _VooCalendarScheduleViewState extends State<VooCalendarScheduleView> {
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
    widget.controller.attachScheduleViewScrollController(_scrollController);
  }

  @override
  void dispose() {
    // Only dispose if we own the controller
    if (_ownsScrollController) {
      _scrollController.dispose();
    }
    widget.controller.detachScheduleViewScrollController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final textDirection = Directionality.of(context);

    // Group events by date
    final Map<DateTime, List<VooCalendarEvent>> eventsByDate = {};
    for (final event in widget.controller.events) {
      final dateKey = DateTime(event.startTime.year, event.startTime.month, event.startTime.day);
      eventsByDate.putIfAbsent(dateKey, () => []).add(event);
    }

    final sortedDates = eventsByDate.keys.toList()..sort();

    if (sortedDates.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 48, color: widget.theme.outsideMonthTextColor),
            SizedBox(height: design.spacingMd),
            Text('No events scheduled', style: widget.theme.monthTextStyle),
          ],
        ),
      );
    }

    // Merge padding with scrollPadding
    final basePadding = (widget.config.padding ?? EdgeInsets.all(design.spacingMd)).resolve(textDirection);
    final scrollPadding = (widget.config.scrollPadding ?? EdgeInsets.zero).resolve(textDirection);
    final combinedPadding = EdgeInsets.only(
      left: basePadding.left + scrollPadding.left,
      right: basePadding.right + scrollPadding.right,
      top: basePadding.top + scrollPadding.top,
      bottom: basePadding.bottom + scrollPadding.bottom,
    );

    Widget listView = ListView.builder(
      controller: _scrollController,
      padding: combinedPadding,
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final events = eventsByDate[date]!;
        final isSelected = widget.controller.isDateSelected(date);
        final isToday = _isToday(date);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            InkWell(
              onTap: () => widget.onDateSelected(date),
              child: Container(
                padding: EdgeInsets.all(design.spacingMd),
                decoration: BoxDecoration(
                  color: isSelected
                      ? widget.theme.selectedDayBackgroundColor
                      : isToday
                      ? widget.theme.todayBackgroundColor
                      : widget.theme.headerBackgroundColor.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(design.radiusSm),
                ),
                child: Row(
                  children: [
                    Text(
                      DateFormat('EEEE, MMMM d').format(date),
                      style: widget.theme.dayTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? widget.theme.selectedDayTextColor
                            : isToday
                            ? widget.theme.todayTextColor
                            : null,
                      ),
                    ),
                    const Spacer(),
                    Text('${events.length} event${events.length == 1 ? '' : 's'}', style: widget.theme.eventDescriptionTextStyle),
                  ],
                ),
              ),
            ),
            SizedBox(height: design.spacingSm),
            // Events for this date
            ...events.map((event) {
              if (widget.eventBuilder != null) {
                return Padding(
                  padding: EdgeInsets.only(left: design.spacingLg, bottom: design.spacingSm),
                  child: widget.eventBuilder!(context, event),
                );
              }
              return Padding(
                padding: EdgeInsets.only(left: design.spacingLg, bottom: design.spacingSm),
                child: ScheduleEventCardWidget(event: event, theme: widget.theme, onTap: () => widget.onEventTap?.call(event), compact: widget.compact),
              );
            }),
            if (index < sortedDates.length - 1) Divider(height: design.spacingLg * 2),
          ],
        );
      },
    );

    // Wrap with scrollbar if needed
    if (widget.config.showScrollbar) {
      listView = Scrollbar(
        controller: _scrollController,
        child: listView,
      );
    }

    return listView;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}
