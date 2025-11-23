import 'package:flutter_test/flutter_test.dart';

import 'package:voo_node_canvas/voo_node_canvas.dart';

void main() {
  group('CanvasController', () {
    late CanvasController controller;

    setUp(() {
      controller = CanvasController();
    });

    tearDown(() {
      controller.dispose();
    });

    group('Node Operations', () {
      test('addNode adds node to state', () {
        const node = CanvasNode(
          id: 'node1',
          position: Offset(100, 100),
        );

        controller.addNode(node);

        expect(controller.state.nodes, hasLength(1));
        expect(controller.state.nodes.first.id, 'node1');
      });

      test('removeNode removes node from state', () {
        const node = CanvasNode(
          id: 'node1',
          position: Offset(100, 100),
        );

        controller.addNode(node);
        controller.removeNode('node1');

        expect(controller.state.nodes, isEmpty);
      });

      test('removeNode also removes related connections', () {
        controller.addNode(const CanvasNode(
          id: 'node1',
          position: Offset(100, 100),
          ports: [NodePort(id: 'out1', type: PortType.output)],
        ));
        controller.addNode(const CanvasNode(
          id: 'node2',
          position: Offset(300, 100),
          ports: [NodePort(id: 'in1', type: PortType.input)],
        ));
        controller.addConnection(const NodeConnection(
          id: 'conn1',
          sourceNodeId: 'node1',
          sourcePortId: 'out1',
          targetNodeId: 'node2',
          targetPortId: 'in1',
        ));

        controller.removeNode('node1');

        expect(controller.state.connections, isEmpty);
      });

      test('moveNode updates node position', () {
        controller.addNode(const CanvasNode(
          id: 'node1',
          position: Offset(100, 100),
        ));

        controller.moveNode('node1', const Offset(200, 200));

        expect(controller.state.nodes.first.position, const Offset(200, 200));
      });

      test('moveNode snaps to grid when enabled', () {
        controller.updateConfig(const CanvasConfig(
          snapToGrid: true,
          gridSize: 20,
        ));
        controller.addNode(const CanvasNode(
          id: 'node1',
          position: Offset(100, 100),
        ));

        controller.moveNode('node1', const Offset(115, 127));

        expect(controller.state.nodes.first.position, const Offset(120, 120));
      });

      test('selectNode updates node selection', () {
        controller.addNode(const CanvasNode(
          id: 'node1',
          position: Offset(100, 100),
        ));

        controller.selectNode('node1');

        expect(controller.state.selectedNodeIds, contains('node1'));
        expect(controller.state.nodes.first.isSelected, true);
      });

      test('selectNode with addToSelection allows multiple selection', () {
        controller.addNode(const CanvasNode(
          id: 'node1',
          position: Offset(100, 100),
        ));
        controller.addNode(const CanvasNode(
          id: 'node2',
          position: Offset(200, 200),
        ));

        controller.selectNode('node1');
        controller.selectNode('node2', addToSelection: true);

        expect(controller.state.selectedNodeIds, hasLength(2));
      });

      test('deselectAllNodes clears selection', () {
        controller.addNode(const CanvasNode(
          id: 'node1',
          position: Offset(100, 100),
        ));
        controller.selectNode('node1');

        controller.deselectAllNodes();

        expect(controller.state.selectedNodeIds, isEmpty);
        expect(controller.state.nodes.first.isSelected, false);
      });

      test('startDraggingNode and endDraggingNode manage drag state', () {
        controller.addNode(const CanvasNode(
          id: 'node1',
          position: Offset(100, 100),
        ));

        controller.startDraggingNode('node1');
        expect(controller.state.draggingNodeId, 'node1');
        expect(controller.state.nodes.first.isDragging, true);

        controller.endDraggingNode();
        expect(controller.state.draggingNodeId, isNull);
        expect(controller.state.nodes.first.isDragging, false);
      });
    });

    group('Connection Operations', () {
      setUp(() {
        controller.addNode(const CanvasNode(
          id: 'node1',
          position: Offset(100, 100),
          ports: [NodePort(id: 'out1', type: PortType.output)],
        ));
        controller.addNode(const CanvasNode(
          id: 'node2',
          position: Offset(300, 100),
          ports: [NodePort(id: 'in1', type: PortType.input)],
        ));
      });

      test('addConnection creates connection', () {
        const connection = NodeConnection(
          id: 'conn1',
          sourceNodeId: 'node1',
          sourcePortId: 'out1',
          targetNodeId: 'node2',
          targetPortId: 'in1',
        );

        controller.addConnection(connection);

        expect(controller.state.connections, hasLength(1));
      });

      test('addConnection validates port types', () {
        // Try to connect input to input (invalid)
        controller.addNode(const CanvasNode(
          id: 'node3',
          position: Offset(500, 100),
          ports: [NodePort(id: 'in2', type: PortType.input)],
        ));

        controller.addConnection(const NodeConnection(
          id: 'conn1',
          sourceNodeId: 'node2',
          sourcePortId: 'in1', // This is an input port, not output
          targetNodeId: 'node3',
          targetPortId: 'in2',
        ));

        expect(controller.state.connections, isEmpty);
      });

      test('addConnection prevents duplicates', () {
        const connection = NodeConnection(
          id: 'conn1',
          sourceNodeId: 'node1',
          sourcePortId: 'out1',
          targetNodeId: 'node2',
          targetPortId: 'in1',
        );

        controller.addConnection(connection);
        controller.addConnection(connection.copyWith(id: 'conn2'));

        expect(controller.state.connections, hasLength(1));
      });

      test('removeConnection removes connection', () {
        controller.addConnection(const NodeConnection(
          id: 'conn1',
          sourceNodeId: 'node1',
          sourcePortId: 'out1',
          targetNodeId: 'node2',
          targetPortId: 'in1',
        ));

        controller.removeConnection('conn1');

        expect(controller.state.connections, isEmpty);
      });

      test('startConnection and cancelConnection manage state', () {
        controller.startConnection('node1', 'out1');

        expect(controller.state.connectingFromNodeId, 'node1');
        expect(controller.state.connectingFromPortId, 'out1');
        expect(controller.state.isConnecting, true);

        controller.cancelConnection();

        expect(controller.state.connectingFromNodeId, isNull);
        expect(controller.state.isConnecting, false);
      });

      test('completeConnection creates valid connection', () {
        controller.startConnection('node1', 'out1');
        controller.completeConnection('node2', 'in1');

        expect(controller.state.connections, hasLength(1));
        expect(controller.state.isConnecting, false);
      });
    });

    group('Viewport Operations', () {
      test('setViewportOffset updates offset', () {
        controller.setViewportOffset(const Offset(100, 200));

        expect(controller.state.viewport.offset, const Offset(100, 200));
      });

      test('setViewportZoom clamps to valid range', () {
        controller.setViewportZoom(0.1); // Below min
        expect(controller.state.viewport.zoom, 0.25);

        controller.setViewportZoom(5.0); // Above max
        expect(controller.state.viewport.zoom, 2.0);

        controller.setViewportZoom(1.5); // Within range
        expect(controller.state.viewport.zoom, 1.5);
      });

      test('zoomAtPoint zooms around focal point', () {
        controller.zoomAtPoint(2.0, const Offset(100, 100));

        expect(controller.state.viewport.zoom, 2.0);
        // Offset should be adjusted to keep focal point stationary
        expect(controller.state.viewport.offset, isNot(Offset.zero));
      });

      test('resetViewport resets to initial state', () {
        controller.setViewportOffset(const Offset(100, 200));
        controller.setViewportZoom(1.5);

        controller.resetViewport();

        expect(controller.state.viewport.offset, Offset.zero);
        expect(controller.state.viewport.zoom, 1.0);
      });
    });

    group('Selection Operations', () {
      test('clearSelection clears all selections', () {
        controller.addNode(const CanvasNode(
          id: 'node1',
          position: Offset(100, 100),
          ports: [NodePort(id: 'out1', type: PortType.output)],
        ));
        controller.addNode(const CanvasNode(
          id: 'node2',
          position: Offset(300, 100),
          ports: [NodePort(id: 'in1', type: PortType.input)],
        ));
        controller.addConnection(const NodeConnection(
          id: 'conn1',
          sourceNodeId: 'node1',
          sourcePortId: 'out1',
          targetNodeId: 'node2',
          targetPortId: 'in1',
        ));

        controller.selectNode('node1');
        controller.selectConnection('conn1', addToSelection: true);

        controller.clearSelection();

        expect(controller.state.selectedNodeIds, isEmpty);
        expect(controller.state.selectedConnectionIds, isEmpty);
      });

      test('deleteSelected removes selected items', () {
        controller.addNode(const CanvasNode(
          id: 'node1',
          position: Offset(100, 100),
        ));
        controller.addNode(const CanvasNode(
          id: 'node2',
          position: Offset(200, 200),
        ));

        controller.selectNode('node1');
        controller.deleteSelected();

        expect(controller.state.nodes, hasLength(1));
        expect(controller.state.nodes.first.id, 'node2');
      });
    });

    test('notifies listeners on state changes', () {
      var notified = false;
      controller.addListener(() => notified = true);

      controller.addNode(const CanvasNode(
        id: 'node1',
        position: Offset(100, 100),
      ));

      expect(notified, true);
    });
  });
}
