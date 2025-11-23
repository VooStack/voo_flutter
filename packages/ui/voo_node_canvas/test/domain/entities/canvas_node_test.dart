import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:voo_node_canvas/voo_node_canvas.dart';

void main() {
  group('CanvasNode', () {
    test('creates with required parameters', () {
      const node = CanvasNode(
        id: 'node1',
        position: Offset(100, 200),
      );

      expect(node.id, 'node1');
      expect(node.position, const Offset(100, 200));
      expect(node.size, const Size(150, 100));
      expect(node.ports, isEmpty);
      expect(node.child, isNull);
      expect(node.isSelected, false);
      expect(node.isDragging, false);
      expect(node.data, isNull);
    });

    test('creates with all parameters', () {
      const ports = [
        NodePort(id: 'in1', type: PortType.input),
        NodePort(id: 'out1', type: PortType.output),
      ];

      const node = CanvasNode(
        id: 'node2',
        position: Offset(50, 75),
        size: Size(200, 150),
        ports: ports,
        isSelected: true,
        isDragging: true,
        data: 'custom data',
      );

      expect(node.id, 'node2');
      expect(node.position, const Offset(50, 75));
      expect(node.size, const Size(200, 150));
      expect(node.ports, hasLength(2));
      expect(node.isSelected, true);
      expect(node.isDragging, true);
      expect(node.data, 'custom data');
    });

    test('center returns correct position', () {
      const node = CanvasNode(
        id: 'node1',
        position: Offset(100, 100),
        size: Size(200, 100),
      );

      expect(node.center, const Offset(200, 150));
    });

    test('bounds returns correct rectangle', () {
      const node = CanvasNode(
        id: 'node1',
        position: Offset(50, 100),
        size: Size(200, 150),
      );

      expect(node.bounds, const Rect.fromLTWH(50, 100, 200, 150));
    });

    test('copyWith creates new instance with updated values', () {
      const original = CanvasNode(
        id: 'node1',
        position: Offset(100, 100),
        isSelected: false,
      );

      final copied = original.copyWith(
        position: const Offset(200, 200),
        isSelected: true,
      );

      expect(copied.id, 'node1');
      expect(copied.position, const Offset(200, 200));
      expect(copied.isSelected, true);
      expect(original.position, const Offset(100, 100)); // Original unchanged
      expect(original.isSelected, false);
    });

    test('equality works correctly', () {
      const node1 = CanvasNode(
        id: 'node1',
        position: Offset(100, 100),
      );
      const node2 = CanvasNode(
        id: 'node1',
        position: Offset(100, 100),
      );
      const node3 = CanvasNode(
        id: 'node1',
        position: Offset(200, 200),
      );

      expect(node1, equals(node2));
      expect(node1, isNot(equals(node3)));
    });
  });
}
