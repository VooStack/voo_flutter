import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:voo_node_canvas/voo_node_canvas.dart';

void main() {
  group('CanvasConfig', () {
    test('creates with default values', () {
      const config = CanvasConfig();

      expect(config.gridSize, 20.0);
      expect(config.showGrid, true);
      expect(config.snapToGrid, false);
      expect(config.minZoom, 0.25);
      expect(config.maxZoom, 2.0);
      expect(config.initialZoom, 1.0);
      expect(config.gridColor, isNull);
      expect(config.backgroundColor, isNull);
      expect(config.connectionStyle, ConnectionStyle.bezier);
      expect(config.connectionColor, isNull);
      expect(config.connectionStrokeWidth, 2.0);
      expect(config.portRadius, 6.0);
      expect(config.portColor, isNull);
      expect(config.selectedColor, isNull);
      expect(config.enablePan, true);
      expect(config.enableZoom, true);
      expect(config.enableNodeDrag, true);
    });

    test('creates with custom values', () {
      const config = CanvasConfig(
        gridSize: 30.0,
        showGrid: false,
        snapToGrid: true,
        minZoom: 0.5,
        maxZoom: 3.0,
        initialZoom: 1.5,
        gridColor: Colors.grey,
        connectionStyle: ConnectionStyle.straight,
        portRadius: 8.0,
        enablePan: false,
      );

      expect(config.gridSize, 30.0);
      expect(config.showGrid, false);
      expect(config.snapToGrid, true);
      expect(config.minZoom, 0.5);
      expect(config.maxZoom, 3.0);
      expect(config.initialZoom, 1.5);
      expect(config.gridColor, Colors.grey);
      expect(config.connectionStyle, ConnectionStyle.straight);
      expect(config.portRadius, 8.0);
      expect(config.enablePan, false);
    });

    test('copyWith creates new instance with updated values', () {
      const original = CanvasConfig(
        gridSize: 20.0,
        showGrid: true,
      );

      final copied = original.copyWith(
        gridSize: 40.0,
        showGrid: false,
      );

      expect(copied.gridSize, 40.0);
      expect(copied.showGrid, false);
      expect(original.gridSize, 20.0); // Original unchanged
      expect(original.showGrid, true);
    });

    test('throws assertion error for invalid zoom range', () {
      expect(
        () => CanvasConfig(minZoom: 2.0, maxZoom: 1.0),
        throwsAssertionError,
      );
    });

    test('throws assertion error for initial zoom outside range', () {
      expect(
        () => CanvasConfig(minZoom: 0.5, maxZoom: 1.5, initialZoom: 2.0),
        throwsAssertionError,
      );
    });

    test('throws assertion error for non-positive grid size', () {
      expect(
        () => CanvasConfig(gridSize: 0),
        throwsAssertionError,
      );
      expect(
        () => CanvasConfig(gridSize: -10),
        throwsAssertionError,
      );
    });

    test('equality works correctly', () {
      const config1 = CanvasConfig(gridSize: 20);
      const config2 = CanvasConfig(gridSize: 20);
      const config3 = CanvasConfig(gridSize: 30);

      expect(config1, equals(config2));
      expect(config1, isNot(equals(config3)));
    });
  });
}
