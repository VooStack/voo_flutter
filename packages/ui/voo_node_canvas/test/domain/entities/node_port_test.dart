import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:voo_node_canvas/voo_node_canvas.dart';

void main() {
  group('NodePort', () {
    test('creates with required parameters', () {
      const port = NodePort(
        id: 'port1',
        type: PortType.input,
      );

      expect(port.id, 'port1');
      expect(port.type, PortType.input);
      expect(port.label, isNull);
      expect(port.offset, Offset.zero);
      expect(port.color, isNull);
    });

    test('creates with all parameters', () {
      const port = NodePort(
        id: 'port2',
        type: PortType.output,
        label: 'Output',
        offset: Offset(10, 20),
        color: Colors.blue,
      );

      expect(port.id, 'port2');
      expect(port.type, PortType.output);
      expect(port.label, 'Output');
      expect(port.offset, const Offset(10, 20));
      expect(port.color, Colors.blue);
    });

    test('copyWith creates new instance with updated values', () {
      const original = NodePort(
        id: 'port1',
        type: PortType.input,
        label: 'Input',
      );

      final copied = original.copyWith(
        label: 'New Label',
        color: Colors.red,
      );

      expect(copied.id, 'port1');
      expect(copied.type, PortType.input);
      expect(copied.label, 'New Label');
      expect(copied.color, Colors.red);
      expect(original.label, 'Input'); // Original unchanged
    });

    test('equality works correctly', () {
      const port1 = NodePort(
        id: 'port1',
        type: PortType.input,
      );
      const port2 = NodePort(
        id: 'port1',
        type: PortType.input,
      );
      const port3 = NodePort(
        id: 'port2',
        type: PortType.input,
      );

      expect(port1, equals(port2));
      expect(port1, isNot(equals(port3)));
    });
  });
}
