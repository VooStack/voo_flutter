import 'dart:convert';

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

/// Main example screen showing the node canvas editor.
class NodeCanvasExample extends StatefulWidget {
  /// Creates the node canvas example.
  const NodeCanvasExample({super.key});

  @override
  State<NodeCanvasExample> createState() => _NodeCanvasExampleState();
}

class _NodeCanvasExampleState extends State<NodeCanvasExample> {
  late final CanvasController _controller;
  bool _isRunning = false;

  /// Node templates available in the palette.
  final List<NodeTemplate> _templates = [
    // Triggers category
    NodeTemplate(
      type: 'start',
      label: 'Start',
      description: 'Entry point of the flow',
      icon: Icons.play_circle_outline,
      color: Colors.green,
      category: 'Triggers',
      defaultSize: const Size(120, 80),
      defaultPorts: const [
        NodePort(id: 'out1', type: PortType.output),
      ],
    ),
    NodeTemplate(
      type: 'timer',
      label: 'Timer',
      description: 'Triggers on schedule',
      icon: Icons.timer_outlined,
      color: Colors.green,
      category: 'Triggers',
      defaultSize: const Size(120, 80),
      defaultPorts: const [
        NodePort(id: 'out1', type: PortType.output),
      ],
    ),

    // Processing category
    NodeTemplate(
      type: 'process',
      label: 'Process',
      description: 'Execute an action',
      icon: Icons.settings_outlined,
      color: Colors.blue,
      category: 'Processing',
      defaultSize: const Size(140, 100),
      defaultPorts: const [
        NodePort(id: 'in1', type: PortType.input),
        NodePort(id: 'out1', type: PortType.output),
      ],
    ),
    NodeTemplate(
      type: 'transform',
      label: 'Transform',
      description: 'Transform data',
      icon: Icons.transform,
      color: Colors.blue,
      category: 'Processing',
      defaultSize: const Size(140, 100),
      defaultPorts: const [
        NodePort(id: 'in1', type: PortType.input),
        NodePort(id: 'out1', type: PortType.output),
      ],
    ),
    NodeTemplate(
      type: 'filter',
      label: 'Filter',
      description: 'Filter items',
      icon: Icons.filter_alt_outlined,
      color: Colors.blue,
      category: 'Processing',
      defaultSize: const Size(140, 100),
      defaultPorts: const [
        NodePort(id: 'in1', type: PortType.input),
        NodePort(id: 'out1', type: PortType.output),
      ],
    ),

    // Logic category
    NodeTemplate(
      type: 'condition',
      label: 'Condition',
      description: 'Branch based on logic',
      icon: Icons.call_split,
      color: Colors.orange,
      category: 'Logic',
      defaultSize: const Size(140, 100),
      defaultPorts: const [
        NodePort(id: 'in1', type: PortType.input),
        NodePort(id: 'true', type: PortType.output, label: 'True'),
        NodePort(id: 'false', type: PortType.output, label: 'False'),
      ],
    ),
    NodeTemplate(
      type: 'merge',
      label: 'Merge',
      description: 'Combine inputs',
      icon: Icons.merge,
      color: Colors.orange,
      category: 'Logic',
      defaultSize: const Size(120, 100),
      defaultPorts: const [
        NodePort(id: 'in1', type: PortType.input),
        NodePort(id: 'in2', type: PortType.input),
        NodePort(id: 'out1', type: PortType.output),
      ],
    ),
    // Multi-directional ports demo (new feature!)
    NodeTemplate(
      type: 'hub',
      label: 'Hub',
      description: 'Multi-directional hub',
      icon: Icons.hub_outlined,
      color: Colors.purple,
      category: 'Logic',
      defaultSize: const Size(100, 100),
      defaultPorts: const [
        // Ports on all 4 sides!
        NodePort(id: 'top', type: PortType.input, position: PortPosition.top),
        NodePort(
          id: 'bottom',
          type: PortType.output,
          position: PortPosition.bottom,
        ),
        NodePort(id: 'left', type: PortType.input, position: PortPosition.left),
        NodePort(
          id: 'right',
          type: PortType.output,
          position: PortPosition.right,
        ),
      ],
    ),

    // Output category
    NodeTemplate(
      type: 'end',
      label: 'End',
      description: 'End of the flow',
      icon: Icons.stop_circle_outlined,
      color: Colors.red,
      category: 'Output',
      defaultSize: const Size(120, 80),
      defaultPorts: const [
        NodePort(id: 'in1', type: PortType.input),
      ],
    ),
    NodeTemplate(
      type: 'log',
      label: 'Log',
      description: 'Log output',
      icon: Icons.article_outlined,
      color: Colors.red,
      category: 'Output',
      defaultSize: const Size(120, 80),
      defaultPorts: const [
        NodePort(id: 'in1', type: PortType.input),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = CanvasController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSave() {
    final json = _controller.toJson();
    final jsonString = const JsonEncoder.withIndent('  ').convert(json);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Canvas JSON'),
        content: SingleChildScrollView(
          child: SelectableText(
            jsonString,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleLoad() {
    // Sample JSON to load
    final sampleJson = {
      'nodes': [
        {
          'id': 'loaded_start',
          'position': {'dx': 50.0, 'dy': 150.0},
          'size': {'width': 120.0, 'height': 80.0},
          'ports': [
            {'id': 'out1', 'type': 'output'},
          ],
          'metadata': {'type': 'start'},
        },
        {
          'id': 'loaded_process',
          'position': {'dx': 250.0, 'dy': 130.0},
          'size': {'width': 140.0, 'height': 100.0},
          'ports': [
            {'id': 'in1', 'type': 'input'},
            {'id': 'out1', 'type': 'output'},
          ],
          'metadata': {'type': 'process'},
        },
        {
          'id': 'loaded_end',
          'position': {'dx': 480.0, 'dy': 150.0},
          'size': {'width': 120.0, 'height': 80.0},
          'ports': [
            {'id': 'in1', 'type': 'input'},
          ],
          'metadata': {'type': 'end'},
        },
      ],
      'connections': [
        {
          'id': 'conn1',
          'sourceNodeId': 'loaded_start',
          'sourcePortId': 'out1',
          'targetNodeId': 'loaded_process',
          'targetPortId': 'in1',
        },
        {
          'id': 'conn2',
          'sourceNodeId': 'loaded_process',
          'sourcePortId': 'out1',
          'targetNodeId': 'loaded_end',
          'targetPortId': 'in1',
        },
      ],
    };

    _controller.fromJson(
      sampleJson,
      nodeBuilder: _rebuildNodeWidget,
    );

    _showSnackBar('Loaded sample canvas');
  }

  void _handleClear() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Canvas'),
        content: const Text('Are you sure you want to clear all nodes and connections?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _controller.clear();
              _showSnackBar('Canvas cleared');
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  /// Simulates running the flow by highlighting nodes in sequence.
  Future<void> _handleRun() async {
    if (_isRunning) {
      _stopSimulation();
      return;
    }

    final nodes = _controller.state.nodes;
    if (nodes.isEmpty) {
      _showSnackBar('Add some nodes first!');
      return;
    }

    // Find start nodes (nodes with only output ports or nodes with 'start' type)
    final startNodes = nodes.where((n) {
      final type = n.metadata?['type'] as String?;
      if (type == 'start') return true;
      // Or nodes with no input connections
      final hasInputConnections = _controller.state.connections
          .any((c) => c.targetNodeId == n.id);
      return !hasInputConnections;
    }).toList();

    if (startNodes.isEmpty) {
      _showSnackBar('No start node found!');
      return;
    }

    setState(() => _isRunning = true);

    _showSnackBar('Running flow simulation...');

    // Build execution order based on connections
    final executionOrder = _buildExecutionOrder(startNodes.first);

    // Execute nodes in order with visual feedback
    for (var i = 0; i < executionOrder.length && _isRunning; i++) {
      final nodeId = executionOrder[i];

      // Highlight current node with color
      _controller.updateNode(nodeId, (node) {
        return node.copyWith(
          backgroundColor: Colors.green.withValues(alpha: 0.8),
          borderColor: Colors.greenAccent,
        );
      });

      await Future.delayed(const Duration(milliseconds: 800));

      // Dim the previous node (mark as completed)
      if (_isRunning) {
        _controller.updateNode(nodeId, (node) {
          return node.copyWith(
            backgroundColor: Colors.grey.withValues(alpha: 0.5),
            borderColor: Colors.grey,
          );
        });
      }
    }

    if (_isRunning) {
      _showSnackBar('Flow completed!');

      // Reset all node colors after a brief pause
      await Future.delayed(const Duration(seconds: 1));
      _resetNodeColors();
    }

    setState(() => _isRunning = false);
  }

  void _stopSimulation() {
    setState(() => _isRunning = false);
    _resetNodeColors();
    _showSnackBar('Simulation stopped');
  }

  void _resetNodeColors() {
    for (final node in _controller.state.nodes) {
      _controller.updateNode(node.id, (n) {
        // Clear custom colors to revert to default
        return CanvasNode(
          id: n.id,
          position: n.position,
          size: n.size,
          ports: n.ports,
          child: n.child,
          isSelected: n.isSelected,
          isDragging: n.isDragging,
          metadata: n.metadata,
          // Reset colors to null (defaults)
        );
      });
    }
  }

  /// Builds an execution order by traversing connections from start node.
  List<String> _buildExecutionOrder(CanvasNode startNode) {
    final order = <String>[];
    final visited = <String>{};
    final queue = [startNode.id];

    while (queue.isNotEmpty) {
      final nodeId = queue.removeAt(0);
      if (visited.contains(nodeId)) continue;

      visited.add(nodeId);
      order.add(nodeId);

      // Find connected nodes (outputs of this node)
      final connections = _controller.state.connections
          .where((c) => c.sourceNodeId == nodeId);

      for (final conn in connections) {
        if (!visited.contains(conn.targetNodeId)) {
          queue.add(conn.targetNodeId);
        }
      }
    }

    return order;
  }

  /// Cycles the color of selected nodes.
  void _handleColorCycle() {
    final selectedNodes = _controller.state.nodes
        .where((n) => n.isSelected)
        .toList();

    if (selectedNodes.isEmpty) {
      _showSnackBar('Select a node first!');
      return;
    }

    const colors = [
      Colors.blue,
      Colors.purple,
      Colors.pink,
      Colors.red,
      Colors.orange,
      Colors.amber,
      Colors.green,
      Colors.teal,
      Colors.cyan,
    ];

    for (final node in selectedNodes) {
      // Get current color index
      final currentColor = node.backgroundColor;
      var colorIndex = 0;
      if (currentColor != null) {
        for (var i = 0; i < colors.length; i++) {
          if (colors[i].toARGB32() == currentColor.toARGB32()) {
            colorIndex = (i + 1) % colors.length;
            break;
          }
        }
      }

      _controller.updateNode(node.id, (n) {
        return n.copyWith(
          backgroundColor: colors[colorIndex].withValues(alpha: 0.7),
          borderColor: colors[colorIndex],
        );
      });
    }

    _showSnackBar('Color cycled!');
  }

  /// Disconnects all connections from selected nodes.
  void _handleDisconnectSelected() {
    final selectedNodes = _controller.state.nodes
        .where((n) => n.isSelected)
        .toList();

    if (selectedNodes.isEmpty) {
      _showSnackBar('Select a node first!');
      return;
    }

    var totalDisconnected = 0;
    for (final node in selectedNodes) {
      final disconnected = _controller.disconnectNode(node.id);
      totalDisconnected += disconnected.length;
    }

    if (totalDisconnected > 0) {
      _showSnackBar('Disconnected $totalDisconnected connection(s)');
    } else {
      _showSnackBar('No connections to disconnect');
    }
  }

  /// Rebuilds a node's widget content from its metadata.
  CanvasNode _rebuildNodeWidget(CanvasNode node) {
    final nodeType = node.metadata?['type'] as String?;
    if (nodeType == null) return node;

    // Find the matching template
    final template = _templates.where((t) => t.type == nodeType).firstOrNull;
    if (template == null) return node;

    return node.copyWith(
      child: _NodeContent(template: template),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VooNodeCanvas Editor'),
        actions: [
          // Run/Stop simulation
          IconButton(
            icon: Icon(_isRunning ? Icons.stop : Icons.play_arrow),
            tooltip: _isRunning ? 'Stop Simulation' : 'Run Flow',
            onPressed: _handleRun,
            color: _isRunning ? Colors.red : null,
          ),
          // Color cycle for selected nodes
          IconButton(
            icon: const Icon(Icons.palette),
            tooltip: 'Cycle Color (select a node)',
            onPressed: _handleColorCycle,
          ),
          // Disconnect selected nodes
          IconButton(
            icon: const Icon(Icons.link_off),
            tooltip: 'Disconnect Selected',
            onPressed: _handleDisconnectSelected,
          ),
          const VerticalDivider(),
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Load Sample',
            onPressed: _handleLoad,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Export JSON',
            onPressed: _handleSave,
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Clear Canvas',
            onPressed: _handleClear,
          ),
        ],
      ),
      body: VooCanvasEditor(
        controller: _controller,
        templates: _templates,
        config: const CanvasConfig(
          gridSize: 20,
          showGrid: true,
          snapToGrid: false,
          minZoom: 0.25,
          maxZoom: 2.0,
        ),
        palettePosition: PalettePosition.left,
        paletteWidth: 220,
        showToolbar: true,
        toolbarPosition: ToolbarPosition.top,
        nodeBuilder: (template, node) => _NodeContent(template: template),
        onNodeTap: (node) {
          _showSnackBar('Tapped: ${node.id}');
        },
        onNodeCreated: (node, template) {
          _showSnackBar('Created: ${template.label}');
        },
        onConnectionCreated: (connection) {
          _showSnackBar(
            'Connected: ${connection.sourceNodeId} → ${connection.targetNodeId}',
          );
        },
        onConnectionRemoved: (connectionId) {
          // Connection was removed (via Delete key or disconnect)
          debugPrint('Connection removed: $connectionId');
        },
        onConnectionTap: (connection) {
          _showSnackBar(
            'Connection selected (press Delete/Backspace to remove)',
          );
        },
      ),
    );
  }
}

/// Custom node content widget.
class _NodeContent extends StatelessWidget {
  const _NodeContent({required this.template});

  final NodeTemplate template;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = template.color ?? theme.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.85),
            color.withValues(alpha: 0.65),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (template.icon != null)
            Icon(
              template.icon,
              color: Colors.white.withValues(alpha: 0.9),
              size: 24,
            ),
          const SizedBox(height: 4),
          Text(
            template.label,
            style: theme.textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (template.description != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                template.description!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}
