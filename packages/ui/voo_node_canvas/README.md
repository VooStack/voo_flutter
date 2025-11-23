# VooNodeCanvas

A node-based canvas widget for creating visual node graphs in Flutter. Build flow editors, node-based tools, workflow designers, and more with an infinite canvas that supports drag-and-drop nodes and connections.

## Features

- **Infinite Canvas**: Pan and zoom seamlessly across an unlimited workspace
- **Draggable Nodes**: Place and move nodes anywhere on the canvas
- **Connection System**: Link nodes via input/output ports with smooth bezier curves
- **Grid Background**: Visual alignment aid with optional snap-to-grid
- **Selection**: Select and manipulate multiple nodes and connections
- **Node Palette**: Drag-and-drop node templates with category organization
- **Canvas Editor**: Ready-to-use editor widget with palette and toolbar
- **JSON Serialization**: Export/import canvas state for persistence
- **Customizable**: Extensive configuration options for appearance and behavior
- **Responsive**: Works across all device sizes using voo_responsive

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  voo_node_canvas: ^0.1.0
```

## Quick Start

```dart
import 'package:voo_node_canvas/voo_node_canvas.dart';

// Create a controller
final controller = CanvasController();

// Add nodes
controller.addNode(CanvasNode(
  id: 'start',
  position: const Offset(100, 100),
  ports: const [
    NodePort(id: 'out1', type: PortType.output),
  ],
  child: const Text('Start'),
));

controller.addNode(CanvasNode(
  id: 'end',
  position: const Offset(400, 100),
  ports: const [
    NodePort(id: 'in1', type: PortType.input),
  ],
  child: const Text('End'),
));

// Build the canvas
VooNodeCanvas(
  controller: controller,
  config: const CanvasConfig(
    gridSize: 20,
    snapToGrid: true,
    showGrid: true,
  ),
  onNodeMoved: (nodeId, position) {
    print('Node $nodeId moved to $position');
  },
  onConnectionCreated: (connection) {
    print('Connected ${connection.sourceNodeId} to ${connection.targetNodeId}');
  },
)
```

## Core Concepts

### Nodes

Nodes are the draggable widgets on the canvas. Each node has:

- **id**: Unique identifier
- **position**: Location on the canvas (Offset)
- **size**: Dimensions of the node (Size)
- **ports**: Connection points (input/output)
- **child**: Custom widget content

```dart
CanvasNode(
  id: 'process',
  position: const Offset(200, 150),
  size: const Size(150, 100),
  ports: const [
    NodePort(id: 'in1', type: PortType.input),
    NodePort(id: 'out1', type: PortType.output),
    NodePort(id: 'out2', type: PortType.output),
  ],
  child: MyCustomNodeWidget(),
)
```

### Ports

Ports are connection points on nodes:

- **PortType.input**: Receives connections
- **PortType.output**: Initiates connections

Connections can only be made from output ports to input ports.

### Connections

Connections link nodes together:

```dart
NodeConnection(
  id: 'conn1',
  sourceNodeId: 'node1',
  sourcePortId: 'out1',
  targetNodeId: 'node2',
  targetPortId: 'in1',
  style: ConnectionStyle.bezier,
)
```

### Canvas Configuration

Customize the canvas behavior:

```dart
CanvasConfig(
  gridSize: 20.0,           // Grid cell size
  showGrid: true,           // Show background grid
  snapToGrid: true,         // Snap nodes to grid
  minZoom: 0.25,            // Minimum zoom level
  maxZoom: 2.0,             // Maximum zoom level
  enablePan: true,          // Allow canvas panning
  enableZoom: true,         // Allow canvas zooming
  enableNodeDrag: true,     // Allow node dragging
  connectionStyle: ConnectionStyle.bezier,
)
```

## Controller API

The `CanvasController` provides methods to manipulate the canvas:

### Node Operations

```dart
controller.addNode(node);              // Add a node
controller.removeNode('nodeId');       // Remove a node
controller.moveNode('nodeId', offset); // Move a node
controller.selectNode('nodeId');       // Select a node
controller.deselectAllNodes();         // Deselect all nodes
```

### Connection Operations

```dart
controller.addConnection(connection);     // Add a connection
controller.removeConnection('connId');    // Remove a connection
controller.startConnection('nodeId', 'portId');
controller.completeConnection('targetNodeId', 'targetPortId');
controller.cancelConnection();
```

### Viewport Operations

```dart
controller.setViewportOffset(offset);    // Pan the canvas
controller.setViewportZoom(zoom);        // Set zoom level
controller.zoomAtPoint(zoom, point);     // Zoom at specific point
controller.resetViewport();              // Reset to initial view
```

### Selection Operations

```dart
controller.selectNode('nodeId', addToSelection: true);
controller.selectConnection('connId');
controller.clearSelection();
controller.deleteSelected();
```

## Canvas Editor

The `VooCanvasEditor` provides a complete editing experience with a palette, canvas, and toolbar:

```dart
VooCanvasEditor(
  controller: controller,
  templates: [
    NodeTemplate(
      type: 'start',
      label: 'Start',
      icon: Icons.play_circle,
      color: Colors.green,
      category: 'Triggers',
      defaultPorts: const [
        NodePort(id: 'out1', type: PortType.output),
      ],
    ),
    NodeTemplate(
      type: 'process',
      label: 'Process',
      icon: Icons.settings,
      color: Colors.blue,
      category: 'Processing',
      defaultPorts: const [
        NodePort(id: 'in1', type: PortType.input),
        NodePort(id: 'out1', type: PortType.output),
      ],
    ),
  ],
  nodeBuilder: (template, node) => MyNodeWidget(template: template),
  palettePosition: PalettePosition.left,
  paletteWidth: 220,
  showToolbar: true,
  onNodeCreated: (node, template) {
    print('Created ${template.label}');
  },
)
```

### Node Templates

Templates define blueprints for creating nodes:

```dart
NodeTemplate(
  type: 'condition',           // Unique type identifier
  label: 'Condition',          // Display name
  description: 'Branch logic', // Optional description
  icon: Icons.call_split,      // Icon for palette
  color: Colors.orange,        // Theme color
  category: 'Logic',           // Category for grouping
  defaultSize: const Size(140, 100),
  defaultPorts: const [
    NodePort(id: 'in1', type: PortType.input),
    NodePort(id: 'true', type: PortType.output, label: 'True'),
    NodePort(id: 'false', type: PortType.output, label: 'False'),
  ],
  defaultMetadata: {'version': 1},
)
```

### Node Palette

Display templates in a draggable palette:

```dart
NodePalette(
  templates: templates,
  direction: Axis.vertical,
  showCategories: true,
  onTemplateTap: (template) => createNode(template),
  onTemplateDragStarted: (template) => print('Dragging'),
)
```

## JSON Serialization

Export and import canvas state for persistence:

```dart
// Export to JSON
final json = controller.toJson();
final jsonString = jsonEncode(json);

// Import from JSON
controller.fromJson(
  jsonDecode(jsonString),
  nodeBuilder: (node) {
    // Rebuild widget content from metadata
    final type = node.metadata?['type'] as String?;
    return node.copyWith(child: MyNodeWidget(type: type));
  },
);

// Clear canvas
controller.clear();
```

### Example JSON Export

```json
{
  "nodes": [
    {
      "id": "node_1732345678901_1",
      "position": {
        "dx": 100.0,
        "dy": 150.0
      },
      "size": {
        "width": 120.0,
        "height": 80.0
      },
      "ports": [
        {
          "id": "out1",
          "type": "output"
        }
      ],
      "metadata": {
        "type": "start"
      }
    },
    {
      "id": "node_1732345678902_2",
      "position": {
        "dx": 300.0,
        "dy": 130.0
      },
      "size": {
        "width": 140.0,
        "height": 100.0
      },
      "ports": [
        {
          "id": "in1",
          "type": "input"
        },
        {
          "id": "out1",
          "type": "output"
        }
      ],
      "metadata": {
        "type": "process"
      }
    },
    {
      "id": "node_1732345678903_3",
      "position": {
        "dx": 520.0,
        "dy": 150.0
      },
      "size": {
        "width": 120.0,
        "height": 80.0
      },
      "ports": [
        {
          "id": "in1",
          "type": "input"
        }
      ],
      "metadata": {
        "type": "end"
      }
    }
  ],
  "connections": [
    {
      "id": "conn_1732345678904",
      "sourceNodeId": "node_1732345678901_1",
      "sourcePortId": "out1",
      "targetNodeId": "node_1732345678902_2",
      "targetPortId": "in1"
    },
    {
      "id": "conn_1732345678905",
      "sourceNodeId": "node_1732345678902_2",
      "sourcePortId": "out1",
      "targetNodeId": "node_1732345678903_3",
      "targetPortId": "in1"
    }
  ],
  "viewport": {
    "offset": {
      "dx": 0.0,
      "dy": 0.0
    },
    "zoom": 1.0
  }
}
```

## Connection Styles

Three connection styles are available:

- **ConnectionStyle.bezier**: Smooth curved lines (default)
- **ConnectionStyle.straight**: Direct straight lines
- **ConnectionStyle.stepped**: Right-angled stepped lines

## Callbacks

Handle user interactions:

```dart
VooNodeCanvas(
  controller: controller,
  onNodeTap: (node) { },
  onNodeMoved: (nodeId, position) { },
  onNodeDragStart: (nodeId) { },
  onNodeDragEnd: (nodeId) { },
  onConnectionCreated: (connection) { },
  onConnectionRemoved: (connectionId) { },
  onConnectionTap: (connection) { },
  onCanvasTap: () { },
  onViewportChanged: (offset, zoom) { },
)
```

## Theming

Colors adapt to the Flutter theme. Override specific colors via CanvasConfig:

```dart
CanvasConfig(
  gridColor: Colors.grey.withOpacity(0.2),
  backgroundColor: Colors.white,
  connectionColor: Colors.blue,
  portColor: Colors.green,
  selectedColor: Colors.orange,
)
```

## Architecture

This package follows clean architecture principles:

```
lib/
├── src/
│   ├── domain/
│   │   ├── entities/    # Data models
│   │   └── enums/       # Enumerations
│   └── presentation/
│       ├── state/       # Controller and state
│       └── widgets/     # UI components (atoms, molecules, organisms)
└── voo_node_canvas.dart # Public API
```

## Dependencies

- `voo_tokens`: Design tokens for consistent styling
- `voo_responsive`: Responsive design utilities
- `equatable`: Value equality for entities

## Example

See the [example](example/) directory for a complete demo application.

## License

MIT License - see [LICENSE](LICENSE) for details.
