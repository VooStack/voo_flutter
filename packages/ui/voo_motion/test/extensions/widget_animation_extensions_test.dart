// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_motion/voo_motion.dart';

void main() {
  group('Widget Animation Extensions', () {
    testWidgets('dropIn extension should apply drop animation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Text('Drop In Test').dropIn(
              duration: const Duration(milliseconds: 200),
            ),
          ),
        ),
      );

      expect(find.byType(VooDropAnimation), findsOneWidget);
      expect(find.text('Drop In Test'), findsOneWidget);
    });

    testWidgets('fadeIn extension should apply fade animation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Text('Fade Test').fadeIn(
              duration: const Duration(milliseconds: 200),
            ),
          ),
        ),
      );

      expect(find.byType(VooFadeAnimation), findsOneWidget);
      expect(find.text('Fade Test'), findsOneWidget);
    });

    testWidgets('slideInLeft extension should apply slide animation',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Text('Slide Test').slideInLeft(
              duration: const Duration(milliseconds: 200),
            ),
          ),
        ),
      );

      expect(find.byType(VooSlideAnimation), findsOneWidget);
      expect(find.text('Slide Test'), findsOneWidget);
    });

    testWidgets('scaleIn extension should apply scale animation',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Text('Scale Test').scaleIn(
              duration: const Duration(milliseconds: 200),
            ),
          ),
        ),
      );

      expect(find.byType(VooScaleAnimation), findsOneWidget);
      expect(find.text('Scale Test'), findsOneWidget);
    });

    testWidgets('rotate extension should apply rotation animation',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Icon(Icons.refresh).rotate(
              duration: const Duration(milliseconds: 200),
            ),
          ),
        ),
      );

      expect(find.byType(VooRotationAnimation), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('bounce extension should apply bounce animation',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Text('Bounce Test').bounce(
              duration: const Duration(milliseconds: 200),
            ),
          ),
        ),
      );

      expect(find.byType(VooBounceAnimation), findsOneWidget);
      expect(find.text('Bounce Test'), findsOneWidget);
    });

    testWidgets('shake extension should apply shake animation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Text('Shake Test').shake(
              duration: const Duration(milliseconds: 200),
            ),
          ),
        ),
      );

      expect(find.byType(VooShakeAnimation), findsOneWidget);
      expect(find.text('Shake Test'), findsOneWidget);
    });

    testWidgets('flipX extension should apply horizontal flip animation',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Card(
              child: Text('Flip X'),
            ).flipX(
              duration: const Duration(milliseconds: 200),
            ),
          ),
        ),
      );

      expect(find.byType(VooFlipAnimation), findsOneWidget);
      final flipAnimation = tester.widget<VooFlipAnimation>(
        find.byType(VooFlipAnimation),
      );
      expect(flipAnimation.direction, FlipDirection.horizontal);
    });

    testWidgets('flipY extension should apply vertical flip animation',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Card(
              child: Text('Flip Y'),
            ).flipY(
              duration: const Duration(milliseconds: 200),
            ),
          ),
        ),
      );

      expect(find.byType(VooFlipAnimation), findsOneWidget);
      final flipAnimation = tester.widget<VooFlipAnimation>(
        find.byType(VooFlipAnimation),
      );
      expect(flipAnimation.direction, FlipDirection.vertical);
    });

    testWidgets('blur extension should apply blur animation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Text('Blur Test').blur(
              duration: const Duration(milliseconds: 200),
            ),
          ),
        ),
      );

      expect(find.byType(VooBlurAnimation), findsOneWidget);
      expect(find.text('Blur Test'), findsOneWidget);
    });

    testWidgets('glow extension should apply glow animation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Text('Glow Test').glow(
              duration: const Duration(milliseconds: 200),
            ),
          ),
        ),
      );

      expect(find.byType(VooGlowAnimation), findsOneWidget);
      expect(find.text('Glow Test'), findsOneWidget);
    });

    testWidgets('pulse extension should apply pulse animation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Text('Pulse Test').pulse(
              duration: const Duration(milliseconds: 200),
            ),
          ),
        ),
      );

      expect(find.byType(VooPulseAnimation), findsOneWidget);
      expect(find.text('Pulse Test'), findsOneWidget);
    });

    testWidgets('shimmer extension should apply shimmer animation',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Text('Shimmer Test').shimmer(
              duration: const Duration(milliseconds: 200),
            ),
          ),
        ),
      );

      expect(find.byType(VooShimmerAnimation), findsOneWidget);
      expect(find.text('Shimmer Test'), findsOneWidget);
    });

    testWidgets('wave extension should apply wave animation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Text('Wave Test').wave(
              duration: const Duration(milliseconds: 200),
            ),
          ),
        ),
      );

      expect(find.byType(VooWaveAnimation), findsOneWidget);
      expect(find.text('Wave Test'), findsOneWidget);
    });

    testWidgets('ripple extension should apply ripple animation',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Text('Ripple Test').ripple(
              duration: const Duration(milliseconds: 200),
            ),
          ),
        ),
      );

      expect(find.byType(VooRippleAnimation), findsOneWidget);
      expect(find.text('Ripple Test'), findsOneWidget);
    });

    testWidgets('chaining animations should work', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Text('Chain Test')
                .fadeIn(duration: const Duration(milliseconds: 100))
                .scaleIn(duration: const Duration(milliseconds: 100)),
          ),
        ),
      );

      // Should have both animations applied
      expect(find.byType(VooFadeAnimation), findsOneWidget);
      expect(find.byType(VooScaleAnimation), findsOneWidget);
      expect(find.text('Chain Test'), findsOneWidget);
    });

    testWidgets('animation parameters should be customizable', (tester) async {
      var startCalled = false;
      var completeCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Text('Custom Test').fadeIn(
              duration: const Duration(seconds: 1),
              delay: const Duration(milliseconds: 500),
              curve: Curves.bounceOut,
              from: 0.2,
              onStart: () => startCalled = true,
              onComplete: () => completeCalled = true,
              repeat: false,
              reverse: false,
              autoPlay: false,
            ),
          ),
        ),
      );

      final fadeAnimation = tester.widget<VooFadeAnimation>(
        find.byType(VooFadeAnimation),
      );

      expect(fadeAnimation.config.duration, const Duration(seconds: 1));
      expect(fadeAnimation.config.delay, const Duration(milliseconds: 500));
      expect(fadeAnimation.config.curve, Curves.bounceOut);
      expect(fadeAnimation.config.repeat, false);
      expect(fadeAnimation.config.reverse, false);
      expect(fadeAnimation.config.autoPlay, false);
      expect(fadeAnimation.fromOpacity, 0.2);
      expect(fadeAnimation.toOpacity, 1.0);
    });
  });
}
