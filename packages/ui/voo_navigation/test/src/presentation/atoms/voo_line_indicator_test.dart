import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_navigation/src/presentation/atoms/voo_line_indicator.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  group('VooLineIndicator', () {
    testWidgets('should show indicator when selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: VooLineIndicator(
            isSelected: true,
            color: Colors.blue,
            height: 3.0,
            padding: const EdgeInsets.all(8.0),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            animate: false,
            position: VooLineIndicatorPosition.bottom,
            child: const Text('Test'),
          ),
        ),
      );

      // Should find the child text
      expect(find.text('Test'), findsOneWidget);

      // Should find a Container for the indicator
      final containers = find.byType(Container);
      expect(containers, findsWidgets);
    });

    testWidgets('should hide indicator when not selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: VooLineIndicator(
            isSelected: false,
            color: Colors.red,
            height: 3.0,
            padding: const EdgeInsets.all(8.0),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            animate: false,
            position: VooLineIndicatorPosition.bottom,
            child: const Text('Test'),
          ),
        ),
      );

      // Should still find the child text
      expect(find.text('Test'), findsOneWidget);

      // The indicator should be transparent or height 0 when not selected
      final containers = tester.widgetList<Container>(find.byType(Container));

      // Find the indicator container (not the wrapper)
      for (final container in containers) {
        if (container.decoration != null) {
          final decoration = container.decoration as BoxDecoration;
          // When not selected, indicator should be transparent
          if (decoration.color != null) {
            expect(decoration.color?.a, 0.0);
          }
        }
      }
    });

    testWidgets('should animate when animate is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: VooLineIndicator(
            isSelected: true,
            color: Colors.green,
            height: 3.0,
            padding: const EdgeInsets.all(8.0),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            animate: true,
            position: VooLineIndicatorPosition.bottom,
            child: const Text('Animated'),
          ),
        ),
      );

      // Should find AnimatedContainer
      expect(find.byType(AnimatedContainer), findsWidgets);

      // Pump to complete animation
      await tester.pumpAndSettle();

      // Child should still be present
      expect(find.text('Animated'), findsOneWidget);
    });

    testWidgets('should support top position', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: VooLineIndicator(
            isSelected: true,
            color: Colors.purple,
            height: 3.0,
            padding: const EdgeInsets.all(8.0),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            animate: false,
            position: VooLineIndicatorPosition.top,
            child: const Text('Top'),
          ),
        ),
      );

      // Verify the structure based on top position
      expect(find.text('Top'), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('should support left position', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: VooLineIndicator(
            isSelected: true,
            color: Colors.orange,
            width: 3.0,
            padding: const EdgeInsets.all(8.0),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            animate: false,
            position: VooLineIndicatorPosition.left,
            child: const Text('Left'),
          ),
        ),
      );

      // Verify the structure based on left position
      expect(find.text('Left'), findsOneWidget);
      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('should support right position', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: VooLineIndicator(
            isSelected: true,
            color: Colors.teal,
            width: 3.0,
            padding: const EdgeInsets.all(8.0),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            animate: false,
            position: VooLineIndicatorPosition.right,
            child: const Text('Right'),
          ),
        ),
      );

      // Verify the structure based on right position
      expect(find.text('Right'), findsOneWidget);
      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('should apply correct color when selected', (WidgetTester tester) async {
      const testColor = Colors.indigo;

      await tester.pumpWidget(
        createTestApp(
          child: VooLineIndicator(
            isSelected: true,
            color: testColor,
            height: 3.0,
            padding: const EdgeInsets.all(8.0),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            animate: false,
            position: VooLineIndicatorPosition.bottom,
            child: const Text('Colored'),
          ),
        ),
      );

      // Find containers with decoration
      final containers = tester.widgetList<Container>(find.byType(Container));

      bool foundColoredIndicator = false;
      for (final container in containers) {
        if (container.decoration != null) {
          final decoration = container.decoration as BoxDecoration;
          if (decoration.color == testColor) {
            foundColoredIndicator = true;
            break;
          }
        }
      }

      expect(foundColoredIndicator, true);
    });

    testWidgets('should apply padding correctly', (WidgetTester tester) async {
      const testPadding = EdgeInsets.all(16.0);

      await tester.pumpWidget(
        createTestApp(
          child: VooLineIndicator(
            isSelected: true,
            color: Colors.cyan,
            height: 3.0,
            padding: testPadding,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            animate: false,
            position: VooLineIndicatorPosition.bottom,
            child: const Text('Padded'),
          ),
        ),
      );

      // Find Padding widget
      expect(find.byType(Padding), findsWidgets);

      // Check if one of the Padding widgets has our test padding
      final paddings = tester.widgetList<Padding>(find.byType(Padding));
      bool foundPadding = false;
      for (final padding in paddings) {
        if (padding.padding == testPadding) {
          foundPadding = true;
          break;
        }
      }

      expect(foundPadding, true);
    });
  });
}