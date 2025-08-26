import 'package:flutter_test/flutter_test.dart';
import 'package:voo_calendar/voo_calendar.dart';

void main() {
  group('VooCalendar exports', () {
    test('exports are available', () {
      // Test that main classes are exported and can be referenced
      expect(VooCalendarView, isNotNull);
      expect(VooCalendarSelectionMode, isNotNull);
      expect(VooCalendar, isNotNull);
      expect(VooCalendarController, isNotNull);
      expect(VooCalendarTheme, isNotNull);
    });

    test('VooCalendarView enum values exist', () {
      expect(VooCalendarView.values, contains(VooCalendarView.month));
      expect(VooCalendarView.values, contains(VooCalendarView.week));
      expect(VooCalendarView.values, contains(VooCalendarView.day));
      expect(VooCalendarView.values, contains(VooCalendarView.year));
      expect(VooCalendarView.values, contains(VooCalendarView.schedule));
    });

    test('VooCalendarSelectionMode enum values exist', () {
      expect(VooCalendarSelectionMode.values, contains(VooCalendarSelectionMode.none));
      expect(VooCalendarSelectionMode.values, contains(VooCalendarSelectionMode.single));
      expect(VooCalendarSelectionMode.values, contains(VooCalendarSelectionMode.multiple));
      expect(VooCalendarSelectionMode.values, contains(VooCalendarSelectionMode.range));
    });
  });
}