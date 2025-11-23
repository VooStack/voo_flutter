import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:voo_node_canvas/voo_node_canvas.dart';

void main() {
  group('CanvasViewport', () {
    test('creates with default values', () {
      const viewport = CanvasViewport();

      expect(viewport.offset, Offset.zero);
      expect(viewport.zoom, 1.0);
    });

    test('creates with custom values', () {
      const viewport = CanvasViewport(
        offset: Offset(100, 200),
        zoom: 1.5,
      );

      expect(viewport.offset, const Offset(100, 200));
      expect(viewport.zoom, 1.5);
    });

    test('screenToCanvas converts correctly at zoom 1.0', () {
      const viewport = CanvasViewport(
        offset: Offset(50, 50),
        zoom: 1.0,
      );

      final canvasPoint = viewport.screenToCanvas(const Offset(150, 150));
      expect(canvasPoint, const Offset(100, 100));
    });

    test('screenToCanvas converts correctly at zoom 2.0', () {
      const viewport = CanvasViewport(
        offset: Offset(100, 100),
        zoom: 2.0,
      );

      final canvasPoint = viewport.screenToCanvas(const Offset(200, 200));
      expect(canvasPoint, const Offset(50, 50));
    });

    test('canvasToScreen converts correctly at zoom 1.0', () {
      const viewport = CanvasViewport(
        offset: Offset(50, 50),
        zoom: 1.0,
      );

      final screenPoint = viewport.canvasToScreen(const Offset(100, 100));
      expect(screenPoint, const Offset(150, 150));
    });

    test('canvasToScreen converts correctly at zoom 2.0', () {
      const viewport = CanvasViewport(
        offset: Offset(100, 100),
        zoom: 2.0,
      );

      final screenPoint = viewport.canvasToScreen(const Offset(50, 50));
      expect(screenPoint, const Offset(200, 200));
    });

    test('transformMatrix creates correct matrix', () {
      const viewport = CanvasViewport(
        offset: Offset(10, 20),
        zoom: 2.0,
      );

      final matrix = viewport.transformMatrix;
      // Test by transforming a point
      final transformed = MatrixUtils.transformPoint(
        matrix,
        const Offset(100, 100),
      );
      // At zoom 2.0 with offset (10, 20):
      // x = 10 + 100 * 2 = 210
      // y = 20 + 100 * 2 = 220
      expect(transformed.dx, closeTo(210, 0.001));
      expect(transformed.dy, closeTo(220, 0.001));
    });

    test('copyWith creates new instance with updated values', () {
      const original = CanvasViewport(
        offset: Offset(100, 100),
        zoom: 1.0,
      );

      final copied = original.copyWith(
        offset: const Offset(200, 200),
        zoom: 1.5,
      );

      expect(copied.offset, const Offset(200, 200));
      expect(copied.zoom, 1.5);
      expect(original.offset, const Offset(100, 100)); // Original unchanged
      expect(original.zoom, 1.0);
    });

    test('throws assertion error for non-positive zoom', () {
      expect(
        () => CanvasViewport(zoom: 0),
        throwsAssertionError,
      );
      expect(
        () => CanvasViewport(zoom: -1),
        throwsAssertionError,
      );
    });

    test('equality works correctly', () {
      const viewport1 = CanvasViewport(offset: Offset(10, 10), zoom: 1.0);
      const viewport2 = CanvasViewport(offset: Offset(10, 10), zoom: 1.0);
      const viewport3 = CanvasViewport(offset: Offset(20, 20), zoom: 1.0);

      expect(viewport1, equals(viewport2));
      expect(viewport1, isNot(equals(viewport3)));
    });
  });
}
