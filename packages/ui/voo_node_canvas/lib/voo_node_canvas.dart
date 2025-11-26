/// {@category UI}
library;

/// A node-based canvas widget for creating visual node graphs.
///
/// This library provides a comprehensive system for building node-based
/// interfaces where users can place, drag, and connect widgets on an
/// infinite canvas. Features include:
///
/// - Infinite canvas with pan and zoom support
/// - Draggable nodes with customizable content
/// - Input/output ports for creating connections
/// - Smooth bezier curve connections between nodes
/// - Grid background with snap-to-grid support
/// - Selection and deletion of nodes and connections
/// - Responsive design supporting all device sizes
///
/// Example usage:
/// ```dart
/// final controller = CanvasController();
///
/// // Add some nodes
/// controller.addNode(CanvasNode(
///   id: 'node1',
///   position: const Offset(100, 100),
///   ports: [
///     NodePort(id: 'out1', type: PortType.output),
///   ],
///   child: Container(
///     padding: const EdgeInsets.all(16),
///     child: const Text('Start'),
///   ),
/// ));
///
/// controller.addNode(CanvasNode(
///   id: 'node2',
///   position: const Offset(400, 200),
///   ports: [
///     NodePort(id: 'in1', type: PortType.input),
///     NodePort(id: 'out1', type: PortType.output),
///   ],
///   child: Container(
///     padding: const EdgeInsets.all(16),
///     child: const Text('Process'),
///   ),
/// ));
///
/// // Build the canvas
/// VooNodeCanvas(
///   controller: controller,
///   config: const CanvasConfig(
///     gridSize: 20,
///     snapToGrid: true,
///     showGrid: true,
///   ),
///   onNodeMoved: (nodeId, position) {
///     print('Node $nodeId moved to $position');
///   },
///   onConnectionCreated: (connection) {
///     print('Connection created between ${connection.sourceNodeId} and ${connection.targetNodeId}');
///   },
/// )
/// ```

// Domain - Enums
export 'src/domain/enums/connection_style.dart';
export 'src/domain/enums/port_position.dart';
export 'src/domain/enums/port_type.dart';

// Domain - Entities
export 'src/domain/entities/canvas_config.dart';
export 'src/domain/entities/canvas_node.dart';
export 'src/domain/entities/canvas_viewport.dart';
export 'src/domain/entities/node_connection.dart';
export 'src/domain/entities/node_port.dart';
export 'src/domain/entities/node_template.dart';

// Presentation - State
export 'src/presentation/state/canvas_controller.dart';
export 'src/presentation/state/canvas_state.dart';

// Presentation - Widgets
export 'src/presentation/widgets/atoms/grid_painter.dart';
export 'src/presentation/widgets/molecules/node_palette.dart';
export 'src/presentation/widgets/molecules/node_widget.dart';
export 'src/presentation/widgets/organisms/voo_canvas_editor.dart';
export 'src/presentation/widgets/organisms/voo_node_canvas.dart';
