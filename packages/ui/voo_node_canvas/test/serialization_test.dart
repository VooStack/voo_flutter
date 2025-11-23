import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:voo_node_canvas/voo_node_canvas.dart';

void main() {
  group('JSON Serialization', () {
    group('NodePort', () {
      test('serializes to JSON correctly', () {
        const port = NodePort(
          id: 'port1',
          type: PortType.input,
          label: 'Input 1',
          offset: Offset(5, 10),
        );

        final json = port.toJson();

        expect(json['id'], 'port1');
        expect(json['type'], 'input');
        expect(json['label'], 'Input 1');
        expect(json['offset']['dx'], 5.0);
        expect(json['offset']['dy'], 10.0);
      });

      test('deserializes from JSON correctly', () {
        final json = {
          'id': 'port2',
          'type': 'output',
          'label': 'Output 1',
          'offset': {'dx': 3.0, 'dy': 7.0},
        };

        final port = NodePort.fromJson(json);

        expect(port.id, 'port2');
        expect(port.type, PortType.output);
        expect(port.label, 'Output 1');
        expect(port.offset, const Offset(3, 7));
      });

      test('roundtrips correctly', () {
        const original = NodePort(
          id: 'port1',
          type: PortType.output,
          label: 'Test Port',
          offset: Offset(10, 20),
        );

        final json = original.toJson();
        final restored = NodePort.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.type, original.type);
        expect(restored.label, original.label);
        expect(restored.offset, original.offset);
      });

      test('handles minimal JSON', () {
        final json = {
          'id': 'minimal',
          'type': 'input',
        };

        final port = NodePort.fromJson(json);

        expect(port.id, 'minimal');
        expect(port.type, PortType.input);
        expect(port.label, isNull);
        expect(port.offset, Offset.zero);
      });
    });

    group('CanvasNode', () {
      test('serializes to JSON correctly', () {
        const node = CanvasNode(
          id: 'node1',
          position: Offset(100, 200),
          size: Size(150, 100),
          ports: [
            NodePort(id: 'in1', type: PortType.input),
            NodePort(id: 'out1', type: PortType.output),
          ],
          metadata: {'type': 'process', 'label': 'My Node'},
        );

        final json = node.toJson();

        expect(json['id'], 'node1');
        expect(json['position']['dx'], 100.0);
        expect(json['position']['dy'], 200.0);
        expect(json['ports'], hasLength(2));
        expect(json['metadata']['type'], 'process');
        expect(json['metadata']['label'], 'My Node');
      });

      test('deserializes from JSON correctly', () {
        final json = {
          'id': 'node2',
          'position': {'dx': 50.0, 'dy': 75.0},
          'size': {'width': 200.0, 'height': 150.0},
          'ports': [
            {'id': 'in1', 'type': 'input'},
          ],
          'metadata': {'custom': 'data'},
        };

        final node = CanvasNode.fromJson(json);

        expect(node.id, 'node2');
        expect(node.position, const Offset(50, 75));
        expect(node.size, const Size(200, 150));
        expect(node.ports, hasLength(1));
        expect(node.metadata?['custom'], 'data');
      });

      test('roundtrips correctly', () {
        const original = CanvasNode(
          id: 'roundtrip',
          position: Offset(123, 456),
          size: Size(180, 120),
          ports: [
            NodePort(id: 'p1', type: PortType.input, label: 'In'),
            NodePort(id: 'p2', type: PortType.output, label: 'Out'),
          ],
          metadata: {'key': 'value', 'number': 42},
        );

        final json = original.toJson();
        final restored = CanvasNode.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.position, original.position);
        expect(restored.size, original.size);
        expect(restored.ports.length, original.ports.length);
        expect(restored.metadata, original.metadata);
      });

      test('handles default size', () {
        const node = CanvasNode(
          id: 'default',
          position: Offset(0, 0),
        );

        final json = node.toJson();

        // Default size should not be serialized
        expect(json.containsKey('size'), false);
      });

      test('handles empty ports', () {
        const node = CanvasNode(
          id: 'empty',
          position: Offset(0, 0),
          ports: [],
        );

        final json = node.toJson();

        // Empty ports should not be serialized
        expect(json.containsKey('ports'), false);
      });
    });

    group('NodeConnection', () {
      test('serializes to JSON correctly', () {
        const connection = NodeConnection(
          id: 'conn1',
          sourceNodeId: 'node1',
          sourcePortId: 'out1',
          targetNodeId: 'node2',
          targetPortId: 'in1',
          style: ConnectionStyle.straight,
          color: Colors.red,
          strokeWidth: 3.0,
          metadata: {'priority': 'high'},
        );

        final json = connection.toJson();

        expect(json['id'], 'conn1');
        expect(json['sourceNodeId'], 'node1');
        expect(json['sourcePortId'], 'out1');
        expect(json['targetNodeId'], 'node2');
        expect(json['targetPortId'], 'in1');
        expect(json['style'], 'straight');
        expect(json['color'], isNotNull);
        expect(json['strokeWidth'], 3.0);
        expect(json['metadata']['priority'], 'high');
      });

      test('deserializes from JSON correctly', () {
        final json = {
          'id': 'conn2',
          'sourceNodeId': 'a',
          'sourcePortId': 'b',
          'targetNodeId': 'c',
          'targetPortId': 'd',
          'style': 'stepped',
          'strokeWidth': 4.0,
        };

        final connection = NodeConnection.fromJson(json);

        expect(connection.id, 'conn2');
        expect(connection.sourceNodeId, 'a');
        expect(connection.sourcePortId, 'b');
        expect(connection.targetNodeId, 'c');
        expect(connection.targetPortId, 'd');
        expect(connection.style, ConnectionStyle.stepped);
        expect(connection.strokeWidth, 4.0);
      });

      test('roundtrips correctly', () {
        const original = NodeConnection(
          id: 'roundtrip',
          sourceNodeId: 'src',
          sourcePortId: 'srcPort',
          targetNodeId: 'tgt',
          targetPortId: 'tgtPort',
          style: ConnectionStyle.bezier,
          strokeWidth: 2.5,
          metadata: {'test': true},
        );

        final json = original.toJson();
        final restored = NodeConnection.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.sourceNodeId, original.sourceNodeId);
        expect(restored.sourcePortId, original.sourcePortId);
        expect(restored.targetNodeId, original.targetNodeId);
        expect(restored.targetPortId, original.targetPortId);
        expect(restored.style, original.style);
        expect(restored.strokeWidth, original.strokeWidth);
        expect(restored.metadata, original.metadata);
      });

      test('handles default values', () {
        const connection = NodeConnection(
          id: 'default',
          sourceNodeId: 's',
          sourcePortId: 'sp',
          targetNodeId: 't',
          targetPortId: 'tp',
        );

        final json = connection.toJson();

        // Default values should not be serialized
        expect(json.containsKey('style'), false);
        expect(json.containsKey('strokeWidth'), false);
      });
    });

    group('CanvasViewport', () {
      test('serializes to JSON correctly', () {
        const viewport = CanvasViewport(
          offset: Offset(100, 200),
          zoom: 1.5,
        );

        final json = viewport.toJson();

        expect(json['offset']['dx'], 100.0);
        expect(json['offset']['dy'], 200.0);
        expect(json['zoom'], 1.5);
      });

      test('deserializes from JSON correctly', () {
        final json = {
          'offset': {'dx': 50.0, 'dy': 75.0},
          'zoom': 0.8,
        };

        final viewport = CanvasViewport.fromJson(json);

        expect(viewport.offset, const Offset(50, 75));
        expect(viewport.zoom, 0.8);
      });

      test('roundtrips correctly', () {
        const original = CanvasViewport(
          offset: Offset(123, 456),
          zoom: 1.25,
        );

        final json = original.toJson();
        final restored = CanvasViewport.fromJson(json);

        expect(restored.offset, original.offset);
        expect(restored.zoom, original.zoom);
      });

      test('handles default values', () {
        const viewport = CanvasViewport();

        final json = viewport.toJson();

        // Default values should not be serialized
        expect(json.containsKey('offset'), false);
        expect(json.containsKey('zoom'), false);
      });
    });

    group('CanvasController', () {
      test('exports to JSON correctly', () {
        final controller = CanvasController();

        controller.addNode(const CanvasNode(
          id: 'node1',
          position: Offset(100, 100),
          ports: [NodePort(id: 'out1', type: PortType.output)],
        ));

        controller.addNode(const CanvasNode(
          id: 'node2',
          position: Offset(300, 200),
          ports: [NodePort(id: 'in1', type: PortType.input)],
        ));

        controller.addConnection(const NodeConnection(
          id: 'conn1',
          sourceNodeId: 'node1',
          sourcePortId: 'out1',
          targetNodeId: 'node2',
          targetPortId: 'in1',
        ));

        final json = controller.toJson();

        expect(json['nodes'], hasLength(2));
        expect(json['connections'], hasLength(1));
        expect(json['viewport'], isNotNull);

        controller.dispose();
      });

      test('imports from JSON correctly', () {
        final json = {
          'nodes': [
            {
              'id': 'imported1',
              'position': {'dx': 50.0, 'dy': 50.0},
              'ports': [
                {'id': 'out1', 'type': 'output'},
              ],
              'metadata': {'type': 'start'},
            },
            {
              'id': 'imported2',
              'position': {'dx': 200.0, 'dy': 100.0},
              'ports': [
                {'id': 'in1', 'type': 'input'},
              ],
              'metadata': {'type': 'end'},
            },
          ],
          'connections': [
            {
              'id': 'conn1',
              'sourceNodeId': 'imported1',
              'sourcePortId': 'out1',
              'targetNodeId': 'imported2',
              'targetPortId': 'in1',
            },
          ],
          'viewport': {
            'offset': {'dx': 10.0, 'dy': 20.0},
            'zoom': 0.9,
          },
        };

        final controller = CanvasController();
        controller.fromJson(json);

        expect(controller.state.nodes, hasLength(2));
        expect(controller.state.connections, hasLength(1));
        expect(controller.state.viewport.offset, const Offset(10, 20));
        expect(controller.state.viewport.zoom, 0.9);

        final node1 = controller.state.getNodeById('imported1');
        expect(node1?.metadata?['type'], 'start');

        controller.dispose();
      });

      test('roundtrips full canvas state', () {
        final original = CanvasController();

        original.addNode(const CanvasNode(
          id: 'n1',
          position: Offset(100, 100),
          size: Size(150, 100),
          ports: [
            NodePort(id: 'in1', type: PortType.input),
            NodePort(id: 'out1', type: PortType.output),
          ],
          metadata: {'type': 'process'},
        ));

        original.addNode(const CanvasNode(
          id: 'n2',
          position: Offset(400, 200),
          ports: [
            NodePort(id: 'in1', type: PortType.input),
          ],
        ));

        original.addConnection(const NodeConnection(
          id: 'c1',
          sourceNodeId: 'n1',
          sourcePortId: 'out1',
          targetNodeId: 'n2',
          targetPortId: 'in1',
        ));

        original.setViewportOffset(const Offset(50, 100));
        original.setViewportZoom(1.5);

        // Export and import
        final json = original.toJson();
        final restored = CanvasController();
        restored.fromJson(json);

        // Verify nodes
        expect(restored.state.nodes.length, original.state.nodes.length);
        for (var i = 0; i < original.state.nodes.length; i++) {
          expect(restored.state.nodes[i].id, original.state.nodes[i].id);
          expect(restored.state.nodes[i].position, original.state.nodes[i].position);
          expect(restored.state.nodes[i].size, original.state.nodes[i].size);
          expect(restored.state.nodes[i].ports.length,
              original.state.nodes[i].ports.length);
          expect(restored.state.nodes[i].metadata, original.state.nodes[i].metadata);
        }

        // Verify connections
        expect(restored.state.connections.length,
            original.state.connections.length);
        expect(restored.state.connections[0].id,
            original.state.connections[0].id);
        expect(restored.state.connections[0].sourceNodeId,
            original.state.connections[0].sourceNodeId);

        // Verify viewport
        expect(restored.state.viewport.offset, original.state.viewport.offset);
        expect(restored.state.viewport.zoom, original.state.viewport.zoom);

        original.dispose();
        restored.dispose();
      });

      test('supports JSON string serialization', () {
        final controller = CanvasController();

        controller.addNode(const CanvasNode(
          id: 'test',
          position: Offset(100, 100),
          metadata: {'type': 'test'},
        ));

        // Convert to JSON string (like saving to database)
        final json = controller.toJson();
        final jsonString = jsonEncode(json);

        // Parse JSON string (like loading from database)
        final parsedJson = jsonDecode(jsonString) as Map<String, dynamic>;

        final restored = CanvasController();
        restored.fromJson(parsedJson);

        expect(restored.state.nodes, hasLength(1));
        expect(restored.state.nodes[0].id, 'test');
        expect(restored.state.nodes[0].metadata?['type'], 'test');

        controller.dispose();
        restored.dispose();
      });

      test('nodeBuilder rebuilds widget content on load', () {
        final json = {
          'nodes': [
            {
              'id': 'node1',
              'position': {'dx': 100.0, 'dy': 100.0},
              'metadata': {'type': 'custom', 'title': 'My Node'},
            },
          ],
        };

        final controller = CanvasController();
        controller.fromJson(
          json,
          nodeBuilder: (node) {
            final type = node.metadata?['type'] as String?;
            final title = node.metadata?['title'] as String?;
            return node.copyWith(
              child: Text('$type: $title'),
            );
          },
        );

        expect(controller.state.nodes, hasLength(1));
        expect(controller.state.nodes[0].child, isA<Text>());

        controller.dispose();
      });

      test('clears canvas correctly', () {
        final controller = CanvasController();

        controller.addNode(const CanvasNode(
          id: 'node1',
          position: Offset(100, 100),
          ports: [NodePort(id: 'out1', type: PortType.output)],
        ));

        controller.addNode(const CanvasNode(
          id: 'node2',
          position: Offset(300, 200),
          ports: [NodePort(id: 'in1', type: PortType.input)],
        ));

        controller.addConnection(const NodeConnection(
          id: 'conn1',
          sourceNodeId: 'node1',
          sourcePortId: 'out1',
          targetNodeId: 'node2',
          targetPortId: 'in1',
        ));

        expect(controller.state.nodes, hasLength(2));
        expect(controller.state.connections, hasLength(1));

        controller.clear();

        expect(controller.state.nodes, isEmpty);
        expect(controller.state.connections, isEmpty);

        controller.dispose();
      });

      test('excludes viewport when includeViewport is false', () {
        final controller = CanvasController();
        controller.setViewportOffset(const Offset(100, 100));
        controller.setViewportZoom(1.5);

        final json = controller.toJson(includeViewport: false);

        expect(json.containsKey('viewport'), false);

        controller.dispose();
      });
    });
  });
}
