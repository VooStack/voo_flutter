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
        onConnectionTap: (connection) {
          _showSnackBar('Connection: ${connection.id}');
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
