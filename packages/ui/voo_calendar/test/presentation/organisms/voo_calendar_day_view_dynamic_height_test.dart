import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_calendar/voo_calendar.dart';

void main() {
  group('VooCalendarDayView - Dynamic Height', () {
    late VooCalendarController controller;

    setUp(() {
      controller = VooCalendarController(
        initialDate: DateTime(2025, 10, 12),
        initialView: VooCalendarView.day,
      );
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('should NOT overflow with custom event widgets (dynamic height is always enabled)', (tester) async {
      // Create events with tall custom widgets
      final now = DateTime(2025, 10, 12);
      controller.setEvents([
        VooCalendarEvent.custom(
          id: '1',
          startTime: DateTime(now.year, now.month, now.day, 9, 0),
          endTime: DateTime(now.year, now.month, now.day, 9, 30),
          child: Container(
            height: 150, // Taller than default minEventHeight (80)
            color: Colors.red,
            child: const Text('Tall Custom Widget'),
          ),
        ),
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooCalendar(
              controller: controller,
              initialView: VooCalendarView.day,
              dayViewConfig: const VooDayViewConfig(
                hourHeight: 120.0,
                minEventHeight: 80.0,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should NOT have overflow errors
      expect(tester.takeException(), isNull);
    });

    testWidgets('should clip overflow when custom widget exceeds allocated height', (tester) async {
      final now = DateTime(2025, 10, 12);
      controller.setEvents([
        VooCalendarEvent.custom(
          id: '1',
          startTime: DateTime(now.year, now.month, now.day, 10, 0),
          endTime: DateTime(now.year, now.month, now.day, 10, 30),
          child: Container(
            height: 200, // Very tall widget
            color: Colors.blue,
            padding: const EdgeInsets.all(50), // Extra padding to increase height
            child: const Text('Very Tall Widget'),
          ),
        ),
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooCalendar(
              controller: controller,
              initialView: VooCalendarView.day,
              dayViewConfig: const VooDayViewConfig(
                hourHeight: 120.0,
                minEventHeight: 80.0,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should have ClipRect to prevent overflow
      expect(find.byType(ClipRect), findsWidgets);
      // Should NOT have overflow errors
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle multiple overlapping events with dynamic height', (tester) async {
      final now = DateTime(2025, 10, 12);
      controller.setEvents([
        VooCalendarEvent.custom(
          id: '1',
          startTime: DateTime(now.year, now.month, now.day, 12, 0),
          endTime: DateTime(now.year, now.month, now.day, 12, 30),
          child: Container(height: 100, color: Colors.red, child: const Text('Event 1')),
        ),
        VooCalendarEvent.custom(
          id: '2',
          startTime: DateTime(now.year, now.month, now.day, 12, 0),
          endTime: DateTime(now.year, now.month, now.day, 12, 30),
          child: Container(height: 100, color: Colors.green, child: const Text('Event 2')),
        ),
        VooCalendarEvent.custom(
          id: '3',
          startTime: DateTime(now.year, now.month, now.day, 12, 0),
          endTime: DateTime(now.year, now.month, now.day, 12, 30),
          child: Container(height: 100, color: Colors.blue, child: const Text('Event 3')),
        ),
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooCalendar(
              controller: controller,
              initialView: VooCalendarView.day,
              dayViewConfig: const VooDayViewConfig(
                hourHeight: 120.0,
                minEventHeight: 80.0,
                eventSpacing: 8.0,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should NOT have overflow errors even with 3 overlapping events
      expect(tester.takeException(), isNull);

      // Should find all 3 events
      expect(find.text('Event 1'), findsOneWidget);
      expect(find.text('Event 2'), findsOneWidget);
      expect(find.text('Event 3'), findsOneWidget);
    });

    testWidgets('should auto-detect and handle VooCalendarEvent.custom without eventBuilder', (tester) async {
      final now = DateTime(2025, 10, 12);
      controller.setEvents([
        VooCalendarEvent.custom(
          id: '1',
          startTime: DateTime(now.year, now.month, now.day, 15, 0),
          endTime: DateTime(now.year, now.month, now.day, 15, 30),
          child: Container(
            height: 120,
            color: Colors.orange,
            child: const Text('Auto-detected Custom Widget'),
          ),
        ),
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooCalendar(
              controller: controller,
              initialView: VooCalendarView.day,
              // NO eventBuilder - calendar should auto-detect event.child
              dayViewConfig: const VooDayViewConfig(
                hourHeight: 120.0,
                minEventHeight: 80.0,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should find the custom widget content
      expect(find.text('Auto-detected Custom Widget'), findsOneWidget);
      // Should NOT have overflow
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle mix of standard events and custom widget events', (tester) async {
      final now = DateTime(2025, 10, 12);
      controller.setEvents([
        // Standard event (no child)
        VooCalendarEvent(
          id: '1',
          title: 'Standard Event',
          startTime: DateTime(now.year, now.month, now.day, 14, 0),
          endTime: DateTime(now.year, now.month, now.day, 14, 30),
          color: Colors.purple,
        ),
        // Custom widget event
        VooCalendarEvent.custom(
          id: '2',
          startTime: DateTime(now.year, now.month, now.day, 15, 0),
          endTime: DateTime(now.year, now.month, now.day, 15, 30),
          child: Container(
            height: 100,
            color: Colors.teal,
            child: const Text('Custom Widget'),
          ),
        ),
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooCalendar(
              controller: controller,
              initialView: VooCalendarView.day,
              dayViewConfig: const VooDayViewConfig(
                hourHeight: 120.0,
                minEventHeight: 80.0,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should find both events
      expect(find.text('Standard Event'), findsOneWidget);
      expect(find.text('Custom Widget'), findsOneWidget);
      // Should NOT have overflow
      expect(tester.takeException(), isNull);
    });

    testWidgets('should respect minEventHeight setting', (tester) async {
      final now = DateTime(2025, 10, 12);
      controller.setEvents([
        VooCalendarEvent.custom(
          id: '1',
          startTime: DateTime(now.year, now.month, now.day, 16, 0),
          endTime: DateTime(now.year, now.month, now.day, 16, 30),
          child: Container(
            height: 50, // Smaller than minEventHeight
            color: Colors.pink,
            child: const Text('Small Widget'),
          ),
        ),
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooCalendar(
              controller: controller,
              initialView: VooCalendarView.day,
              dayViewConfig: const VooDayViewConfig(
                hourHeight: 120.0,
                minEventHeight: 100.0, // Larger than widget height
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should NOT have overflow
      expect(tester.takeException(), isNull);
      // Widget should be constrained to at least minEventHeight
      expect(find.text('Small Widget'), findsOneWidget);
    });

    testWidgets('should handle events with SingleChildScrollView children', (tester) async {
      final now = DateTime(2025, 10, 12);
      controller.setEvents([
        VooCalendarEvent.custom(
          id: '1',
          startTime: DateTime(now.year, now.month, now.day, 17, 0),
          endTime: DateTime(now.year, now.month, now.day, 17, 30),
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                10,
                (index) => ListTile(title: Text('Item $index')),
              ),
            ),
          ),
        ),
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooCalendar(
              controller: controller,
              initialView: VooCalendarView.day,
              dayViewConfig: const VooDayViewConfig(
                hourHeight: 120.0,
                minEventHeight: 80.0,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should NOT have overflow even with scrollable content
      expect(tester.takeException(), isNull);
      // Should clip the scrollable content
      expect(find.byType(ClipRect), findsWidgets);
    });
  });

  group('VooCalendarEventWidget - Clip Behavior', () {
    testWidgets('should have ClipRect to prevent overflow', (tester) async {
      final renderInfo = VooCalendarEventRenderInfo(
        allocatedHeight: 80.0,
        allocatedWidth: 200.0,
        isCompact: false,
        isMobile: false,
        hourHeight: 120.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooCalendarEventWidget(
              renderInfo: renderInfo,
              child: Container(
                height: 150, // Taller than allocated
                color: Colors.red,
                child: const Text('Overflowing Content'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should have ClipRect
      expect(find.byType(ClipRect), findsOneWidget);
      // Should NOT have overflow errors
      expect(tester.takeException(), isNull);
    });

    testWidgets('should constrain child to allocated dimensions', (tester) async {
      final renderInfo = VooCalendarEventRenderInfo(
        allocatedHeight: 100.0,
        allocatedWidth: 300.0,
        isCompact: false,
        isMobile: false,
        hourHeight: 120.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooCalendarEventWidget(
              renderInfo: renderInfo,
              child: Container(
                color: Colors.blue,
                child: const Text('Constrained Content'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the SizedBox that constrains dimensions
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.height, equals(100.0));
      expect(sizedBox.width, equals(300.0));
    });
  });
}
