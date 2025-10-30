import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_circular_progress/src/domain/entities/progress_ring.dart';

void main() {
  group('ProgressRing', () {
    test('creates a valid progress ring', () {
      const ring = ProgressRing(
        current: 50,
        goal: 100,
        color: Colors.blue,
      );

      expect(ring.current, 50);
      expect(ring.goal, 100);
      expect(ring.color, Colors.blue);
      expect(ring.strokeWidth, 12.0);
    });

    test('calculates progress correctly', () {
      const ring = ProgressRing(
        current: 75,
        goal: 100,
        color: Colors.blue,
      );

      expect(ring.progress, 0.75);
      expect(ring.percentageInt, 75);
    });

    test('clamps progress to 1.0 when current exceeds goal', () {
      const ring = ProgressRing(
        current: 150,
        goal: 100,
        color: Colors.blue,
      );

      expect(ring.progress, 1.0);
      expect(ring.percentageInt, 100);
    });

    test('detects when goal is reached', () {
      const ring1 = ProgressRing(
        current: 100,
        goal: 100,
        color: Colors.blue,
      );

      const ring2 = ProgressRing(
        current: 50,
        goal: 100,
        color: Colors.blue,
      );

      expect(ring1.isGoalReached, true);
      expect(ring2.isGoalReached, false);
    });

    test('copyWith creates a new instance with updated values', () {
      const ring = ProgressRing(
        current: 50,
        goal: 100,
        color: Colors.blue,
      );

      final updated = ring.copyWith(current: 75);

      expect(updated.current, 75);
      expect(updated.goal, 100);
      expect(updated.color, Colors.blue);
    });

    test('equality works correctly', () {
      const ring1 = ProgressRing(
        current: 50,
        goal: 100,
        color: Colors.blue,
      );

      const ring2 = ProgressRing(
        current: 50,
        goal: 100,
        color: Colors.blue,
      );

      const ring3 = ProgressRing(
        current: 75,
        goal: 100,
        color: Colors.blue,
      );

      expect(ring1, equals(ring2));
      expect(ring1, isNot(equals(ring3)));
    });

    test('asserts on invalid values', () {
      expect(
        () => ProgressRing(
          current: -1,
          goal: 100,
          color: Colors.blue,
        ),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => ProgressRing(
          current: 50,
          goal: 0,
          color: Colors.blue,
        ),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => ProgressRing(
          current: 50,
          goal: 100,
          color: Colors.blue,
          strokeWidth: 0,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
