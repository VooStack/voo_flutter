/// Configuration for what components are selectable
class VooDateTimeComponents {
  final bool year;
  final bool month;
  final bool day;
  final bool hour;
  final bool minute;
  final bool second;

  const VooDateTimeComponents({
    this.year = true,
    this.month = true,
    this.day = true,
    this.hour = false,
    this.minute = false,
    this.second = false,
  });

  /// Preset for year only selection
  static const yearOnly = VooDateTimeComponents(
    year: true,
    month: false,
    day: false,
  );

  /// Preset for year and month selection
  static const yearMonth = VooDateTimeComponents(
    year: true,
    month: true,
    day: false,
  );

  /// Preset for full date selection
  static const date = VooDateTimeComponents(year: true, month: true, day: true);

  /// Preset for month and day only
  static const monthDay = VooDateTimeComponents(
    year: false,
    month: true,
    day: true,
  );

  /// Preset for time only
  static const time = VooDateTimeComponents(
    year: false,
    month: false,
    day: false,
    hour: true,
    minute: true,
  );

  /// Preset for day and time
  static const dayTime = VooDateTimeComponents(
    year: false,
    month: false,
    day: true,
    hour: true,
    minute: true,
  );

  /// Preset for full date and time
  static const dateTime = VooDateTimeComponents(
    year: true,
    month: true,
    day: true,
    hour: true,
    minute: true,
  );
}
