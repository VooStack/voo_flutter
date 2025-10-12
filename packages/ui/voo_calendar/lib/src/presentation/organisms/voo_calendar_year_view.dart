import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

import 'package:voo_calendar/src/calendar.dart';
import 'package:voo_calendar/src/calendar_config.dart';
import 'package:voo_calendar/src/calendar_theme.dart';

/// Year view for VooCalendar
class VooCalendarYearView extends StatefulWidget {
  final VooCalendarController controller;
  final VooCalendarTheme theme;
  final void Function(int month) onMonthSelected;
  final bool compact;
  final VooYearViewConfig config;

  const VooCalendarYearView({
    super.key,
    required this.controller,
    required this.theme,
    required this.onMonthSelected,
    required this.compact,
    this.config = const VooYearViewConfig(),
  });

  @override
  State<VooCalendarYearView> createState() => _VooCalendarYearViewState();
}

class _VooCalendarYearViewState extends State<VooCalendarYearView> {
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
    widget.controller.attachYearViewScrollController(_scrollController);
  }

  @override
  void dispose() {
    // Only dispose if we own the controller
    if (_ownsScrollController) {
      _scrollController.dispose();
    }
    widget.controller.detachYearViewScrollController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final textDirection = Directionality.of(context);
    final year = widget.controller.focusedDate.year;

    // Merge padding with scrollPadding
    final basePadding = (widget.config.padding ?? EdgeInsets.all(design.spacingLg)).resolve(textDirection);
    final scrollPadding = (widget.config.scrollPadding ?? EdgeInsets.zero).resolve(textDirection);
    final combinedPadding = EdgeInsets.only(
      left: basePadding.left + scrollPadding.left,
      right: basePadding.right + scrollPadding.right,
      top: basePadding.top + scrollPadding.top,
      bottom: basePadding.bottom + scrollPadding.bottom,
    );

    Widget gridView = GridView.builder(
      controller: _scrollController,
      padding: combinedPadding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.compact ? 3 : 4,
        mainAxisSpacing: design.spacingMd,
        crossAxisSpacing: design.spacingMd,
        childAspectRatio: widget.compact ? 1.2 : 1.5,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        final month = index + 1;
        final monthDate = DateTime(year, month);
        final monthName = DateFormat('MMMM').format(monthDate);
        final hasEvents = widget.controller.events.any((event) => event.startTime.year == year && event.startTime.month == month);

        return InkWell(
          onTap: () => widget.onMonthSelected(month),
          borderRadius: BorderRadius.circular(design.radiusMd),
          child: Container(
            padding: EdgeInsets.all(design.spacingMd),
            decoration: BoxDecoration(
              border: Border.all(color: widget.theme.borderColor),
              borderRadius: BorderRadius.circular(design.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(monthName, style: widget.theme.monthTextStyle),
                const Spacer(),
                if (hasEvents) ...[
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(color: widget.theme.eventIndicatorColor, shape: BoxShape.circle),
                      ),
                      SizedBox(width: design.spacingXs),
                      Text('Has events', style: widget.theme.eventDescriptionTextStyle),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );

    // Wrap with scrollbar if needed
    if (widget.config.showScrollbar) {
      gridView = Scrollbar(
        controller: _scrollController,
        child: gridView,
      );
    }

    return gridView;
  }
}
