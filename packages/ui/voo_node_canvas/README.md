# VooNodeCanvas

A node-based canvas widget for creating visual node graphs in Flutter. Build flow editors, node-based tools, workflow designers, and more with an infinite canvas that supports drag-and-drop nodes and connections.

## Features

- **Infinite Canvas**: Pan and zoom seamlessly across an unlimited workspace
- **Draggable Nodes**: Place and move nodes anywhere on the canvas
- **Connection System**: Link nodes via input/output ports with smooth bezier curves
- **Grid Background**: Visual alignment aid with optional snap-to-grid
- **Selection**: Select and manipulate multiple nodes and connections
- **Customizable**: Extensive configuration options for appearance and behavior
- **Responsive**: Works across all device sizes using voo_responsive

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  voo_node_canvas: ^0.0.1
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
