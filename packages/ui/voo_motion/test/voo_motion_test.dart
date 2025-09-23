import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_motion/voo_motion.dart';

void main() {
  group('VooMotion Package', () {
    test('should export all necessary components', () {
      // Core
      expect(VooAnimationConfig, isNotNull);
      expect(VooMotionController, isNotNull);
      expect(VooMotionCurve, isNotNull);

      // Animations
      expect(VooFadeAnimation, isNotNull);
      expect(VooSlideAnimation, isNotNull);
      expect(VooScaleAnimation, isNotNull);
      expect(VooRotationAnimation, isNotNull);
      expect(VooDropAnimation, isNotNull);
      expect(VooBounceAnimation, isNotNull);
      expect(VooShakeAnimation, isNotNull);
      expect(VooFlipAnimation, isNotNull);
      expect(VooBlurAnimation, isNotNull);
      expect(VooGlowAnimation, isNotNull);
      expect(VooPulseAnimation, isNotNull);
      expect(VooShimmerAnimation, isNotNull);
      expect(VooWaveAnimation, isNotNull);
      expect(VooRippleAnimation, isNotNull);
      expect(VooParallaxAnimation, isNotNull);
      expect(VooTypewriterAnimation, isNotNull);

      // Widgets
      expect(VooAnimatedWidget, isNotNull);
      expect(VooStaggerList, isNotNull);
      expect(VooHeroAnimation, isNotNull);

      // Settings
      expect(VooMotionSettings, isNotNull);
      expect(VooMotionSettingsProvider, isNotNull);
    });

    test('VooAnimationConfig should have reasonable defaults', () {
      const config = VooAnimationConfig();

      expect(config.duration.inMilliseconds, 500);
      expect(config.delay, Duration.zero);
      expect(config.curve, Curves.easeInOut);
      expect(config.autoPlay, true);
      expect(config.repeat, false);
      expect(config.reverse, false);
      expect(config.repeatCount, 1);
    });

    test('VooMotionSettings should have sensible defaults', () {
      const settings = VooMotionSettings();

      expect(settings.enabled, true);
      expect(settings.speedMultiplier, 1.0);
      expect(settings.respectAccessibilitySettings, true);
      expect(settings.defaultConfig, isA<VooAnimationConfig>());
    });

    test('VooMotionSettings should apply speed multiplier correctly', () {
      const settings = VooMotionSettings(speedMultiplier: 2.0);
      const originalDuration = Duration(milliseconds: 500);

      final modifiedDuration = settings.applySpeedMultiplier(originalDuration);
      expect(modifiedDuration.inMilliseconds, 1000);
    });

    test('VooMotionSettings should return zero duration when disabled', () {
      const settings = VooMotionSettings(enabled: false);
      const originalDuration = Duration(milliseconds: 500);

      final modifiedDuration = settings.applySpeedMultiplier(originalDuration);
      expect(modifiedDuration, Duration.zero);
    });
  });

  group('Extension Methods', () {
    testWidgets('should be available on all widgets', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                const Text('Test').fadeIn(),
                const Icon(Icons.star).scaleIn(),
                Container(color: Colors.blue).slideInLeft(),
                const Card(child: Text('Card')).dropIn(),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(VooFadeAnimation), findsOneWidget);
      expect(find.byType(VooScaleAnimation), findsOneWidget);
      expect(find.byType(VooSlideAnimation), findsOneWidget);
      expect(find.byType(VooDropAnimation), findsOneWidget);
    });
  });
}
