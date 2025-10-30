import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_circular_progress/src/domain/entities/circular_progress_config.dart';

import '../lib/voo_circular_progress.dart';

void main() {
  group('CircularProgressConfig', () {
    test('creates a valid config with default values', () {
      const config = CircularProgressConfig();

      expect(config.size, 200.0);
      expect(config.gapBetweenRings, 8.0);
      expect(config.animationDuration, const Duration(milliseconds: 1000));
      expect(config.animationCurve, Curves.easeInOutCubic);
    });

    test('creates a config with custom values', () {
      const config = CircularProgressConfig(size: 300, gapBetweenRings: 10, animationDuration: Duration(milliseconds: 500), animationCurve: Curves.bounceOut);

      expect(config.size, 300);
      expect(config.gapBetweenRings, 10);
      expect(config.animationDuration, const Duration(milliseconds: 500));
      expect(config.animationCurve, Curves.bounceOut);
    });

    test('copyWith creates a new instance with updated values', () {
      const config = CircularProgressConfig();

      final updated = config.copyWith(size: 250);

      expect(updated.size, 250);
      expect(updated.gapBetweenRings, 8.0);
    });

    test('equality works correctly', () {
      const config1 = CircularProgressConfig();
      const config2 = CircularProgressConfig();
      const config3 = CircularProgressConfig(size: 300);

      expect(config1, equals(config2));
      expect(config1, isNot(equals(config3)));
    });

    test('asserts on invalid values', () {
      expect(() => CircularProgressConfig(size: 0), throwsA(isA<AssertionError>()));

      expect(() => CircularProgressConfig(gapBetweenRings: -1), throwsA(isA<AssertionError>()));
    });
  });
}
