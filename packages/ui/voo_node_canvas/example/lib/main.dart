import 'package:flutter/material.dart';

import 'package:voo_node_canvas/voo_node_canvas.dart';

void main() {
  runApp(const VooNodeCanvasExampleApp());
}

/// Example app demonstrating the VooNodeCanvas widget.
class VooNodeCanvasExampleApp extends StatelessWidget {
  /// Creates the example app.
  const VooNodeCanvasExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VooNodeCanvas Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const NodeCanvasExample(),
    );
  }
}

/// Main example screen showing the node canvas.
class NodeCanvasExample extends StatefulWidget {
  /// Creates the node canvas example.
  const NodeCanvasExample({super.key});

  @override
  State<NodeCanvasExample> createState() => _NodeCanvasExampleState();
}

class _NodeCanvasExampleState extends State<NodeCanvasExample> {
  late final CanvasController _controller;
  int _nodeCounter = 0;

  @override
  void initState() {
    super.initState();
    _controller = CanvasController();
    _addInitialNodes();
  }

  void _addInitialNodes() {
    // Add a "Start" node
    _controller.addNode(CanvasNode(
      id: 'start',
      position: const Offset(50, 150),
      size: const Size(120, 80),
      ports: const [
        NodePort(id: 'out1', type: PortType.output),
      ],
      child: const _NodeContent(
        title: 'Start',
        color: Colors.green,
      ),
    ));

    // Add a "Process" node
    _controller.addNode(CanvasNode(
      id: 'process1',
      position: const Offset(250, 100),
      size: const Size(140, 100),
      ports: const [
        NodePort(id: 'in1', type: PortType.input),
        NodePort(id: 'out1', type: PortType.output),
      ],
      child: const _NodeContent(
        title: 'Process A',
        color: Colors.blue,
      ),
    ));

    // Add another "Process" node
    _controller.addNode(CanvasNode(
      id: 'process2',
      position: const Offset(250, 250),
      size: const Size(140, 100),
      ports: const [
        NodePort(id: 'in1', type: PortType.input),
        NodePort(id: 'out1', type: PortType.output),
      ],
      child: const _NodeContent(
        title: 'Process B',
        color: Colors.orange,
      ),
    ));

    // Add an "End" node
    _controller.addNode(CanvasNode(
      id: 'end',
      position: const Offset(480, 175),
      size: const Size(120, 80),
      ports: const [
        NodePort(id: 'in1', type: PortType.input),
        NodePort(id: 'in2', type: PortType.input),
      ],
      child: const _NodeContent(
        title: 'End',
        color: Colors.red,
      ),
    ));

    // Add initial connections
    _controller.addConnection(const NodeConnection(
      id: 'conn1',
      sourceNodeId: 'start',
      sourcePortId: 'out1',
      targetNodeId: 'process1',
      targetPortId: 'in1',
    ));

    _nodeCounter = 4;
  }

  void _addNewNode() {
    _nodeCounter++;
    final viewport = _controller.state.viewport;

    // Calculate position in the center of the visible area
    final centerX = (-viewport.offset.dx + 200) / viewport.zoom;
    final centerY = (-viewport.offset.dy + 200) / viewport.zoom;

    _controller.addNode(CanvasNode(
      id: 'node_$_nodeCounter',
      position: Offset(centerX, centerY),
      size: const Size(140, 100),
      ports: const [
        NodePort(id: 'in1', type: PortType.input),
        NodePort(id: 'out1', type: PortType.output),
      ],
      child: _NodeContent(
        title: 'Node $_nodeCounter',
        color: Colors.purple,
      ),
    ));
  }

  void _deleteSelected() {
    _controller.deleteSelected();
  }

  void _resetView() {
    _controller.resetViewport();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VooNodeCanvas Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.center_focus_strong),
            tooltip: 'Reset View',
            onPressed: _resetView,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete Selected',
            onPressed: _deleteSelected,
          ),
        ],
      ),
      body: VooNodeCanvas(
        controller: _controller,
        config: const CanvasConfig(
          gridSize: 20,
          showGrid: true,
          snapToGrid: false, // Disabled for smoother dragging
          minZoom: 0.25,
          maxZoom: 2.0,
        ),
        onNodeTap: (node) {
          _showSnackBar('Tapped: ${node.id}');
        },
        onNodeMoved: (nodeId, position) {
          // Node moved - could save position here
        },
        onConnectionCreated: (connection) {
          _showSnackBar(
            'Connected: ${connection.sourceNodeId} → ${connection.targetNodeId}',
          );
        },
        onConnectionTap: (connection) {
          _showSnackBar('Connection selected: ${connection.id}');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewNode,
        tooltip: 'Add Node',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

/// A simple node content widget.
class _NodeContent extends StatelessWidget {
  const _NodeContent({
    required this.title,
    required this.color,
  });

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.8),
            color.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.widgets,
            color: Colors.white.withValues(alpha: 0.9),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
