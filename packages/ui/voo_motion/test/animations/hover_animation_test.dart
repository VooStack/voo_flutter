// ignore_for_file: unused_local_variable

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_motion/voo_motion.dart';

void main() {
  group('Hover Animations', () {
    testWidgets('hoverGrow extension should apply hover grow animation',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              width: 100,
              height: 100,
              color: Colors.blue,
            ).hoverGrow(
              growScale: 1.1,
            ),
          ),
        ),
      );

      expect(find.byType(VooHoverGrowAnimation), findsOneWidget);
      final animation = tester.widget<VooHoverGrowAnimation>(
        find.byType(VooHoverGrowAnimation),
      );
      expect(animation.growScale, 1.1);
    });

    testWidgets('hoverLift extension should apply hover lift animation',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Card(
              child: Text('Hover me'),
            ).hoverLift(
              liftHeight: 10,
            ),
          ),
        ),
      );

      expect(find.byType(VooHoverLiftAnimation), findsOneWidget);
      final animation = tester.widget<VooHoverLiftAnimation>(
        find.byType(VooHoverLiftAnimation),
      );
      expect(animation.liftHeight, 10);
    });

    testWidgets('hoverGlow extension should apply hover glow animation',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Icon(Icons.star).hoverGlow(
              glowColor: Colors.yellow,
            ),
          ),
        ),
      );

      expect(find.byType(VooHoverGlowAnimation), findsOneWidget);
      final animation = tester.widget<VooHoverGlowAnimation>(
        find.byType(VooHoverGlowAnimation),
      );
      expect(animation.glowColor, Colors.yellow);
    });

    testWidgets('hoverTilt extension should apply hover tilt animation',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              width: 100,
              height: 100,
              color: Colors.red,
            ).hoverTilt(
              tiltAngle: 0.1,
            ),
          ),
        ),
      );

      expect(find.byType(VooHoverTiltAnimation), findsOneWidget);
      final animation = tester.widget<VooHoverTiltAnimation>(
        find.byType(VooHoverTiltAnimation),
      );
      expect(animation.tiltAngle, 0.1);
    });

    testWidgets('hoverShine extension should apply hover shine animation',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Text('Shiny').hoverShine(
              shineColor: Colors.white30,
            ),
          ),
        ),
      );

      expect(find.byType(VooHoverShineAnimation), findsOneWidget);
      final animation = tester.widget<VooHoverShineAnimation>(
        find.byType(VooHoverShineAnimation),
      );
      expect(animation.shineColor, Colors.white30);
    });

    testWidgets('hoverRotate extension should apply hover rotate animation',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Icon(Icons.refresh).hoverRotate(
              rotationAngle: 0.2,
              rotationAxis: Axis.horizontal,
            ),
          ),
        ),
      );

      expect(find.byType(VooHoverRotateAnimation), findsOneWidget);
      final animation = tester.widget<VooHoverRotateAnimation>(
        find.byType(VooHoverRotateAnimation),
      );
      expect(animation.rotationAngle, 0.2);
      expect(animation.rotationAxis, Axis.horizontal);
    });

    testWidgets('hoverColor extension should apply hover color animation',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              width: 100,
              height: 100,
              color: Colors.grey,
            ).hoverColor(
              hoverColor: Colors.blue,
            ),
          ),
        ),
      );

      expect(find.byType(VooHoverColorAnimation), findsOneWidget);
      final animation = tester.widget<VooHoverColorAnimation>(
        find.byType(VooHoverColorAnimation),
      );
      expect(animation.hoverColor, Colors.blue);
    });

    testWidgets('hoverBlur extension should apply hover blur animation',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Text('Blur on hover').hoverBlur(
              blurAmount: 10,
            ),
          ),
        ),
      );

      expect(find.byType(VooHoverBlurAnimation), findsOneWidget);
      final animation = tester.widget<VooHoverBlurAnimation>(
        find.byType(VooHoverBlurAnimation),
      );
      expect(animation.blurAmount, 10);
    });

    testWidgets(
        'hoverUnderline extension should apply hover underline animation',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Text('Underline me').hoverUnderline(
              underlineColor: Colors.red,
              thickness: 3,
            ),
          ),
        ),
      );

      expect(find.byType(VooHoverUnderlineAnimation), findsOneWidget);
      final animation = tester.widget<VooHoverUnderlineAnimation>(
        find.byType(VooHoverUnderlineAnimation),
      );
      expect(animation.underlineColor, Colors.red);
      expect(animation.underlineThickness, 3);
    });

    testWidgets('hoverBorder extension should apply hover border animation',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              width: 100,
              height: 100,
              color: Colors.white,
            ).hoverBorder(
              borderColor: Colors.green,
              borderWidth: 4,
            ),
          ),
        ),
      );

      expect(find.byType(VooHoverBorderAnimation), findsOneWidget);
      final animation = tester.widget<VooHoverBorderAnimation>(
        find.byType(VooHoverBorderAnimation),
      );
      expect(animation.borderColor, Colors.green);
      expect(animation.borderWidth, 4);
    });

    testWidgets('hover animations should respond to mouse events',
        (tester) async {
      bool hoverStarted = false;
      bool hoverExited = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Container(
                width: 100,
                height: 100,
                color: Colors.blue,
              ).hoverGrow(
                onHover: () => hoverStarted = true,
                onExit: () => hoverExited = true,
              ),
            ),
          ),
        ),
      );

      // Find the MouseRegion
      final mouseRegion = tester.widget<MouseRegion>(
        find.descendant(
          of: find.byType(VooHoverGrowAnimation),
          matching: find.byType(MouseRegion),
        ),
      );

      // Simulate mouse enter
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(
          location: tester.getCenter(find.byType(Container)),);
      addTearDown(gesture.removePointer);

      // Check hover callbacks
      expect(mouseRegion.cursor, SystemMouseCursors.click);
    });

    testWidgets('multiple hover animations can be chained', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              width: 100,
              height: 100,
              color: Colors.blue,
            ).hoverGrow().hoverGlow().hoverLift(),
          ),
        ),
      );

      expect(find.byType(VooHoverGrowAnimation), findsOneWidget);
      expect(find.byType(VooHoverGlowAnimation), findsOneWidget);
      expect(find.byType(VooHoverLiftAnimation), findsOneWidget);
    });
  });
}
