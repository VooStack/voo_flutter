/// Advanced date and time picker selection modes
enum VooDateTimeSelectionMode {
  /// Year only (e.g., 2024)
  year,

  /// Year and month (e.g., January 2024)
  yearMonth,

  /// Year, month, and day (e.g., January 15, 2024)
  yearMonthDay,

  /// Month and day only (e.g., January 15)
  monthDay,

  /// Day and time (e.g., 15th at 3:30 PM)
  dayTime,

  /// Full date and time (e.g., January 15, 2024 at 3:30 PM)
  yearMonthDayTime,

  /// Time only (e.g., 3:30 PM)
  time,

  /// Date range (start and end dates)
  dateRange,

  /// Date and time range (start and end with times)
  dateTimeRange,
}
