import 'package:flutter/material.dart';

/// Theme configuration for VooCalendar following Material 3 design
class VooCalendarTheme {
  /// Background color of the calendar
  final Color backgroundColor;
  
  /// Header background color
  final Color headerBackgroundColor;
  
  /// Header text color
  final Color headerTextColor;
  
  /// Header text style
  final TextStyle headerTextStyle;
  
  /// Weekday text style
  final TextStyle weekdayTextStyle;
  
  /// Day text style
  final TextStyle dayTextStyle;
  
  /// Day text color
  final Color dayTextColor;
  
  /// Selected day background color
  final Color selectedDayBackgroundColor;
  
  /// Selected day text color
  final Color selectedDayTextColor;
  
  /// Today background color
  final Color todayBackgroundColor;
  
  /// Today text color
  final Color todayTextColor;
  
  /// Outside month text color
  final Color outsideMonthTextColor;
  
  /// Range selection background color
  final Color rangeBackgroundColor;
  
  /// Weekend text color
  final Color weekendTextColor;
  
  /// Border color
  final Color borderColor;
  
  /// Grid line color
  final Color gridLineColor;
  
  /// Event indicator color
  final Color eventIndicatorColor;
  
  /// Event background color
  final Color eventBackgroundColor;
  
  /// Event title text style
  final TextStyle eventTitleTextStyle;
  
  /// Event description text style
  final TextStyle eventDescriptionTextStyle;
  
  /// Event time text style
  final TextStyle eventTimeTextStyle;
  
  /// Week number background color
  final Color weekNumberBackgroundColor;
  
  /// Week number text style
  final TextStyle weekNumberTextStyle;
  
  /// Month text style (for year view)
  final TextStyle monthTextStyle;
  
  /// Time text style (for day/week views)
  final TextStyle timeTextStyle;
  
  /// Disabled date color
  final Color disabledDateColor;
  
  /// Holiday text color
  final Color holidayTextColor;
  
  const VooCalendarTheme({
    required this.backgroundColor,
    required this.headerBackgroundColor,
    required this.headerTextColor,
    required this.headerTextStyle,
    required this.weekdayTextStyle,
    required this.dayTextStyle,
    required this.dayTextColor,
    required this.selectedDayBackgroundColor,
    required this.selectedDayTextColor,
    required this.todayBackgroundColor,
    required this.todayTextColor,
    required this.outsideMonthTextColor,
    required this.rangeBackgroundColor,
    required this.weekendTextColor,
    required this.borderColor,
    required this.gridLineColor,
    required this.eventIndicatorColor,
    required this.eventBackgroundColor,
    required this.eventTitleTextStyle,
    required this.eventDescriptionTextStyle,
    required this.eventTimeTextStyle,
    required this.weekNumberBackgroundColor,
    required this.weekNumberTextStyle,
    required this.monthTextStyle,
    required this.timeTextStyle,
    required this.disabledDateColor,
    required this.holidayTextColor,
  });
  
  /// Creates a calendar theme from the current Material 3 theme context
  factory VooCalendarTheme.fromContext(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    return VooCalendarTheme(
      backgroundColor: colorScheme.surface,
      headerBackgroundColor: colorScheme.surfaceContainerHighest,
      headerTextColor: colorScheme.onSurface,
      headerTextStyle: textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      weekdayTextStyle: textTheme.labelMedium!.copyWith(
        color: colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w500,
      ),
      dayTextStyle: textTheme.bodyMedium!.copyWith(
        color: colorScheme.onSurface,
      ),
      dayTextColor: colorScheme.onSurface,
      selectedDayBackgroundColor: colorScheme.primary,
      selectedDayTextColor: colorScheme.onPrimary,
      todayBackgroundColor: colorScheme.primaryContainer,
      todayTextColor: colorScheme.onPrimaryContainer,
      outsideMonthTextColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
      rangeBackgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.3),
      weekendTextColor: colorScheme.error,
      borderColor: colorScheme.outline,
      gridLineColor: colorScheme.outlineVariant.withValues(alpha: 0.3),
      eventIndicatorColor: colorScheme.primary,
      eventBackgroundColor: colorScheme.primaryContainer,
      eventTitleTextStyle: textTheme.bodyMedium!.copyWith(
        color: colorScheme.onPrimaryContainer,
        fontWeight: FontWeight.w500,
      ),
      eventDescriptionTextStyle: textTheme.bodySmall!.copyWith(
        color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
      ),
      eventTimeTextStyle: textTheme.labelSmall!.copyWith(
        color: colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
      ),
      weekNumberBackgroundColor: colorScheme.surfaceContainerHigh,
      weekNumberTextStyle: textTheme.labelSmall!.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      monthTextStyle: textTheme.titleSmall!.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w500,
      ),
      timeTextStyle: textTheme.labelSmall!.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      disabledDateColor: colorScheme.onSurface.withValues(alpha: 0.3),
      holidayTextColor: colorScheme.error,
    );
  }
  
  /// Creates a light theme for the calendar
  factory VooCalendarTheme.light() {
    return VooCalendarTheme(
      backgroundColor: Colors.white,
      headerBackgroundColor: Colors.grey.shade100,
      headerTextColor: Colors.black87,
      headerTextStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      weekdayTextStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.black54,
      ),
      dayTextStyle: const TextStyle(
        fontSize: 14,
        color: Colors.black87,
      ),
      dayTextColor: Colors.black87,
      selectedDayBackgroundColor: Colors.blue,
      selectedDayTextColor: Colors.white,
      todayBackgroundColor: Colors.blue.shade100,
      todayTextColor: Colors.blue.shade900,
      outsideMonthTextColor: Colors.black38,
      rangeBackgroundColor: Colors.blue.shade50,
      weekendTextColor: Colors.red.shade700,
      borderColor: Colors.grey.shade300,
      gridLineColor: Colors.grey.shade200,
      eventIndicatorColor: Colors.blue,
      eventBackgroundColor: Colors.blue.shade100,
      eventTitleTextStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      eventDescriptionTextStyle: const TextStyle(
        fontSize: 11,
        color: Colors.black54,
      ),
      eventTimeTextStyle: const TextStyle(
        fontSize: 10,
        color: Colors.black45,
      ),
      weekNumberBackgroundColor: Colors.grey.shade50,
      weekNumberTextStyle: const TextStyle(
        fontSize: 10,
        color: Colors.black45,
      ),
      monthTextStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      timeTextStyle: const TextStyle(
        fontSize: 11,
        color: Colors.black54,
      ),
      disabledDateColor: Colors.black26,
      holidayTextColor: Colors.red,
    );
  }
  
  /// Creates a dark theme for the calendar
  factory VooCalendarTheme.dark() {
    return VooCalendarTheme(
      backgroundColor: const Color(0xFF1E1E1E),
      headerBackgroundColor: const Color(0xFF2C2C2C),
      headerTextColor: Colors.white,
      headerTextStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      weekdayTextStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.white70,
      ),
      dayTextStyle: const TextStyle(
        fontSize: 14,
        color: Colors.white,
      ),
      dayTextColor: Colors.white,
      selectedDayBackgroundColor: Colors.blue.shade400,
      selectedDayTextColor: Colors.white,
      todayBackgroundColor: Colors.blue.shade900,
      todayTextColor: Colors.blue.shade100,
      outsideMonthTextColor: Colors.white38,
      rangeBackgroundColor: Colors.blue.shade900.withValues(alpha: 0.3),
      weekendTextColor: Colors.red.shade300,
      borderColor: Colors.white24,
      gridLineColor: Colors.white12,
      eventIndicatorColor: Colors.blue.shade400,
      eventBackgroundColor: Colors.blue.shade900,
      eventTitleTextStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      eventDescriptionTextStyle: const TextStyle(
        fontSize: 11,
        color: Colors.white70,
      ),
      eventTimeTextStyle: const TextStyle(
        fontSize: 10,
        color: Colors.white60,
      ),
      weekNumberBackgroundColor: const Color(0xFF2C2C2C),
      weekNumberTextStyle: const TextStyle(
        fontSize: 10,
        color: Colors.white60,
      ),
      monthTextStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      timeTextStyle: const TextStyle(
        fontSize: 11,
        color: Colors.white70,
      ),
      disabledDateColor: Colors.white30,
      holidayTextColor: Colors.red.shade300,
    );
  }
  
  /// Creates a copy with overrides
  VooCalendarTheme copyWith({
    Color? backgroundColor,
    Color? headerBackgroundColor,
    Color? headerTextColor,
    TextStyle? headerTextStyle,
    TextStyle? weekdayTextStyle,
    TextStyle? dayTextStyle,
    Color? dayTextColor,
    Color? selectedDayBackgroundColor,
    Color? selectedDayTextColor,
    Color? todayBackgroundColor,
    Color? todayTextColor,
    Color? outsideMonthTextColor,
    Color? rangeBackgroundColor,
    Color? weekendTextColor,
    Color? borderColor,
    Color? gridLineColor,
    Color? eventIndicatorColor,
    Color? eventBackgroundColor,
    TextStyle? eventTitleTextStyle,
    TextStyle? eventDescriptionTextStyle,
    TextStyle? eventTimeTextStyle,
    Color? weekNumberBackgroundColor,
    TextStyle? weekNumberTextStyle,
    TextStyle? monthTextStyle,
    TextStyle? timeTextStyle,
    Color? disabledDateColor,
    Color? holidayTextColor,
  }) {
    return VooCalendarTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      headerBackgroundColor: headerBackgroundColor ?? this.headerBackgroundColor,
      headerTextColor: headerTextColor ?? this.headerTextColor,
      headerTextStyle: headerTextStyle ?? this.headerTextStyle,
      weekdayTextStyle: weekdayTextStyle ?? this.weekdayTextStyle,
      dayTextStyle: dayTextStyle ?? this.dayTextStyle,
      dayTextColor: dayTextColor ?? this.dayTextColor,
      selectedDayBackgroundColor: selectedDayBackgroundColor ?? this.selectedDayBackgroundColor,
      selectedDayTextColor: selectedDayTextColor ?? this.selectedDayTextColor,
      todayBackgroundColor: todayBackgroundColor ?? this.todayBackgroundColor,
      todayTextColor: todayTextColor ?? this.todayTextColor,
      outsideMonthTextColor: outsideMonthTextColor ?? this.outsideMonthTextColor,
      rangeBackgroundColor: rangeBackgroundColor ?? this.rangeBackgroundColor,
      weekendTextColor: weekendTextColor ?? this.weekendTextColor,
      borderColor: borderColor ?? this.borderColor,
      gridLineColor: gridLineColor ?? this.gridLineColor,
      eventIndicatorColor: eventIndicatorColor ?? this.eventIndicatorColor,
      eventBackgroundColor: eventBackgroundColor ?? this.eventBackgroundColor,
      eventTitleTextStyle: eventTitleTextStyle ?? this.eventTitleTextStyle,
      eventDescriptionTextStyle: eventDescriptionTextStyle ?? this.eventDescriptionTextStyle,
      eventTimeTextStyle: eventTimeTextStyle ?? this.eventTimeTextStyle,
      weekNumberBackgroundColor: weekNumberBackgroundColor ?? this.weekNumberBackgroundColor,
      weekNumberTextStyle: weekNumberTextStyle ?? this.weekNumberTextStyle,
      monthTextStyle: monthTextStyle ?? this.monthTextStyle,
      timeTextStyle: timeTextStyle ?? this.timeTextStyle,
      disabledDateColor: disabledDateColor ?? this.disabledDateColor,
      holidayTextColor: holidayTextColor ?? this.holidayTextColor,
    );
  }
}