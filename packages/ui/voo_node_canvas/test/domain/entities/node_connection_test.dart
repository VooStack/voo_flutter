import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:voo_node_canvas/voo_node_canvas.dart';

void main() {
  group('NodeConnection', () {
    test('creates with required parameters', () {
      const connection = NodeConnection(
        id: 'conn1',
        sourceNodeId: 'node1',
        sourcePortId: 'out1',
        targetNodeId: 'node2',
        targetPortId: 'in1',
      );

      expect(connection.id, 'conn1');
      expect(connection.sourceNodeId, 'node1');
      expect(connection.sourcePortId, 'out1');
      expect(connection.targetNodeId, 'node2');
      expect(connection.targetPortId, 'in1');
      expect(connection.style, ConnectionStyle.bezier);
      expect(connection.color, isNull);
      expect(connection.strokeWidth, 2.0);
      expect(connection.isSelected, false);
      expect(connection.data, isNull);
    });

    test('creates with all parameters', () {
      const connection = NodeConnection(
        id: 'conn2',
        sourceNodeId: 'node1',
        sourcePortId: 'out1',
        targetNodeId: 'node2',
        targetPortId: 'in1',
        style: ConnectionStyle.straight,
        color: Colors.red,
        strokeWidth: 3.0,
        isSelected: true,
        data: {'key': 'value'},
      );

      expect(connection.id, 'conn2');
      expect(connection.style, ConnectionStyle.straight);
      expect(connection.color, Colors.red);
      expect(connection.strokeWidth, 3.0);
      expect(connection.isSelected, true);
      expect(connection.data, {'key': 'value'});
    });

    test('copyWith creates new instance with updated values', () {
      const original = NodeConnection(
        id: 'conn1',
        sourceNodeId: 'node1',
        sourcePortId: 'out1',
        targetNodeId: 'node2',
        targetPortId: 'in1',
      );

      final copied = original.copyWith(
        style: ConnectionStyle.stepped,
        isSelected: true,
      );

      expect(copied.id, 'conn1');
      expect(copied.style, ConnectionStyle.stepped);
      expect(copied.isSelected, true);
      expect(original.style, ConnectionStyle.bezier); // Original unchanged
    });

    test('equality works correctly', () {
      const conn1 = NodeConnection(
        id: 'conn1',
        sourceNodeId: 'node1',
        sourcePortId: 'out1',
        targetNodeId: 'node2',
        targetPortId: 'in1',
      );
      const conn2 = NodeConnection(
        id: 'conn1',
        sourceNodeId: 'node1',
        sourcePortId: 'out1',
        targetNodeId: 'node2',
        targetPortId: 'in1',
      );
      const conn3 = NodeConnection(
        id: 'conn2',
        sourceNodeId: 'node1',
        sourcePortId: 'out1',
        targetNodeId: 'node2',
        targetPortId: 'in1',
      );

      expect(conn1, equals(conn2));
      expect(conn1, isNot(equals(conn3)));
    });
  });
}
