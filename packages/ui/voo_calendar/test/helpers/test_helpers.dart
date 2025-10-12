import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_calendar/voo_calendar.dart';

/// Helper class for creating test data and widgets
class TestHelpers {
  /// Create a test VooCalendarEvent
  static VooCalendarEvent createEvent({
    required String id,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    Color? color,
    IconData? icon,
    String? description,
  }) {
    return VooCalendarEvent(
      id: id,
      title: title,
      startTime: startTime,
      endTime: endTime,
      color: color ?? Colors.blue,
      icon: icon,
      description: description,
    );
  }

  /// Create multiple events at the same time (for testing overlapping events)
  static List<VooCalendarEvent> createOverlappingEvents({
    required DateTime baseDate,
    required int hour,
    required int count,
    int minuteOffset = 0,
  }) {
    return List.generate(count, (index) {
      return createEvent(
        id: 'event_$index',
        title: 'Event ${index + 1}',
        startTime: baseDate.add(Duration(hours: hour, minutes: minuteOffset * index)),
        endTime: baseDate.add(Duration(hours: hour + 1, minutes: minuteOffset * index)),
        color: Colors.primaries[index % Colors.primaries.length],
      );
    });
  }

  /// Create a default test theme
  static VooCalendarTheme createTestTheme(BuildContext context) {
    return VooCalendarTheme.fromContext(context);
  }

  /// Wrap widget with necessary providers for testing
  static Widget wrapWithMaterialApp(
    Widget child, {
    Size? size,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: size != null
            ? SizedBox(
                width: size.width,
                height: size.height,
                child: child,
              )
            : child,
      ),
    );
  }

  /// Common screen sizes for testing
  static const Size mobileSize = Size(375, 667); // iPhone SE
  static const Size tabletSize = Size(768, 1024); // iPad
  static const Size desktopSize = Size(1920, 1080); // Full HD

  /// Test different screen sizes
  static Future<void> testWithDifferentSizes(
    WidgetTester tester, {
    required Widget Function(Size size) builder,
  }) async {
    // Test mobile
    await tester.binding.setSurfaceSize(mobileSize);
    await tester.pumpWidget(builder(mobileSize));
    await tester.pumpAndSettle();

    // Test tablet
    await tester.binding.setSurfaceSize(tabletSize);
    await tester.pumpWidget(builder(tabletSize));
    await tester.pumpAndSettle();

    // Test desktop
    await tester.binding.setSurfaceSize(desktopSize);
    await tester.pumpWidget(builder(desktopSize));
    await tester.pumpAndSettle();
  }
}
