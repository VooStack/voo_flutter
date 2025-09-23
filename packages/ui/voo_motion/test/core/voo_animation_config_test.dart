import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_motion/voo_motion.dart';

void main() {
  group('VooAnimationConfig', () {
    test('should create with default values', () {
      const config = VooAnimationConfig();

      expect(config.duration, const Duration(milliseconds: 500));
      expect(config.delay, Duration.zero);
      expect(config.curve, Curves.easeInOut);
      expect(config.repeat, false);
      expect(config.reverse, false);
      expect(config.repeatCount, 1);
      expect(config.autoPlay, true);
      expect(config.onStart, null);
      expect(config.onComplete, null);
    });

    test('should create with custom values', () {
      var startCalled = false;
      var completeCalled = false;

      final config = VooAnimationConfig(
        duration: const Duration(seconds: 1),
        delay: const Duration(milliseconds: 100),
        curve: Curves.bounceOut,
        repeat: true,
        reverse: true,
        repeatCount: 3,
        autoPlay: false,
        onStart: () => startCalled = true,
        onComplete: () => completeCalled = true,
      );

      expect(config.duration, const Duration(seconds: 1));
      expect(config.delay, const Duration(milliseconds: 100));
      expect(config.curve, Curves.bounceOut);
      expect(config.repeat, true);
      expect(config.reverse, true);
      expect(config.repeatCount, 3);
      expect(config.autoPlay, false);

      config.onStart?.call();
      expect(startCalled, true);

      config.onComplete?.call();
      expect(completeCalled, true);
    });

    test('copyWith should create new instance with updated values', () {
      const original = VooAnimationConfig();

      final updated = original.copyWith(duration: const Duration(seconds: 2), curve: Curves.linear, repeat: true);

      expect(updated.duration, const Duration(seconds: 2));
      expect(updated.curve, Curves.linear);
      expect(updated.repeat, true);

      // Other values should remain the same
      expect(updated.delay, original.delay);
      expect(updated.reverse, original.reverse);
      expect(updated.repeatCount, original.repeatCount);
      expect(updated.autoPlay, original.autoPlay);
    });

    test('predefined configs should have correct values', () {
      expect(VooAnimationConfig.fast.duration, const Duration(milliseconds: 300));
      expect(VooAnimationConfig.slow.duration, const Duration(milliseconds: 800));
      expect(VooAnimationConfig.spring.curve, Curves.elasticOut);
      expect(VooAnimationConfig.bounce.curve, Curves.bounceOut);
    });
  });
}
