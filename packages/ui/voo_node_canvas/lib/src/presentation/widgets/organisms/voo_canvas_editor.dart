import 'package:flutter/material.dart';

import 'package:voo_node_canvas/src/domain/entities/canvas_config.dart';
import 'package:voo_node_canvas/src/domain/entities/canvas_node.dart';
import 'package:voo_node_canvas/src/domain/entities/node_connection.dart';
import 'package:voo_node_canvas/src/domain/entities/node_template.dart';
import 'package:voo_node_canvas/src/presentation/state/canvas_controller.dart';
import 'package:voo_node_canvas/src/presentation/widgets/molecules/node_palette.dart';
import 'package:voo_node_canvas/src/presentation/widgets/organisms/voo_node_canvas.dart';

/// A complete canvas editor with palette and toolbar.
///
/// This widget provides a ready-to-use node graph editor that includes:
/// - A [NodePalette] for selecting node types to add
/// - A [VooNodeCanvas] for the main editing area
/// - Optional toolbar for common actions
///
/// Example:
/// ```dart
/// VooCanvasEditor(
///   controller: controller,
///   templates: [
///     NodeTemplate(type: 'start', label: 'Start', icon: Icons.play_arrow),
///     NodeTemplate(type: 'process', label: 'Process', icon: Icons.settings),
///     NodeTemplate(type: 'end', label: 'End', icon: Icons.stop),
///   ],
///   nodeBuilder: (template, node) {
///     return MyCustomNodeContent(type: template.type);
///   },
/// )
/// ```
class VooCanvasEditor extends StatefulWidget {
  /// Creates a canvas editor.
  const VooCanvasEditor({
    required this.controller,
    required this.templates,
    this.nodeBuilder,
    this.config = const CanvasConfig(),
    this.palettePosition = PalettePosition.left,
    this.paletteWidth = 200.0,
    this.showToolbar = true,
    this.toolbarPosition = ToolbarPosition.top,
    this.onNodeTap,
    this.onNodeCreated,
    this.onNodeMoved,
    this.onConnectionCreated,
    this.onConnectionRemoved,
    this.onConnectionTap,
    this.onCanvasTap,
    this.onViewportChanged,
    super.key,
  });

  /// The controller managing canvas state.
  final CanvasController controller;

  /// Available node templates for the palette.
  final List<NodeTemplate> templates;

  /// Builder function to create the content widget for nodes.
  ///
  /// This is called when a node is created from a template.
  /// The builder receives the template used and the node being created.
  final Widget Function(NodeTemplate template, CanvasNode node)? nodeBuilder;

  /// Configuration options for the canvas.
  final CanvasConfig config;

  /// Position of the palette relative to the canvas.
  final PalettePosition palettePosition;

  /// Width of the palette panel.
  final double paletteWidth;

  /// Whether to show the toolbar.
  final bool showToolbar;

  /// Position of the toolbar.
  final ToolbarPosition toolbarPosition;

  /// Called when a node is tapped.
  final void Function(CanvasNode)? onNodeTap;

  /// Called when a new node is created from a template.
  final void Function(CanvasNode, NodeTemplate)? onNodeCreated;

  /// Called when a node is moved.
  final void Function(String nodeId, Offset newPosition)? onNodeMoved;

  /// Called when a connection is created.
  final void Function(NodeConnection)? onConnectionCreated;

  /// Called when a connection is removed.
  final void Function(String connectionId)? onConnectionRemoved;

  /// Called when a connection is tapped.
  final void Function(NodeConnection)? onConnectionTap;

  /// Called when the canvas background is tapped.
  final VoidCallback? onCanvasTap;

  /// Called when the viewport changes.
  final void Function(Offset offset, double zoom)? onViewportChanged;

  @override
  State<VooCanvasEditor> createState() => _VooCanvasEditorState();
}

class _VooCanvasEditorState extends State<VooCanvasEditor> {
  int _nodeCounter = 0;
  Set<String> _collapsedCategories = {};
  NodeTemplate? _draggingTemplate;

  @override
  void initState() {
    super.initState();
    // Initialize counter based on existing nodes
    _nodeCounter = widget.controller.state.nodes.length;
  }

  String _generateNodeId() {
    _nodeCounter++;
    return 'node_${DateTime.now().millisecondsSinceEpoch}_$_nodeCounter';
  }

  void _handleTemplateTap(NodeTemplate template) {
    // Add node at center of visible canvas
    final viewport = widget.controller.state.viewport;
    final centerX = (-viewport.offset.dx + 200) / viewport.zoom;
    final centerY = (-viewport.offset.dy + 200) / viewport.zoom;

    _createNode(template, Offset(centerX, centerY));
  }

  void _createNode(NodeTemplate template, Offset position) {
    final nodeId = _generateNodeId();

    // Build the node content
    Widget? child;
    if (widget.nodeBuilder != null) {
      final tempNode = template.createNode(id: nodeId, position: position);
      child = widget.nodeBuilder!(template, tempNode);
    }

    final node = template.createNode(
      id: nodeId,
      position: position,
      child: child ?? _DefaultNodeContent(template: template),
    );

    widget.controller.addNode(node);
    widget.onNodeCreated?.call(node, template);
  }

  void _handleDelete() {
    widget.controller.deleteSelected();
  }

  void _handleResetView() {
    widget.controller.resetViewport();
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_collapsedCategories.contains(category)) {
        _collapsedCategories = Set.from(_collapsedCategories)..remove(category);
      } else {
        _collapsedCategories = Set.from(_collapsedCategories)..add(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = _buildPalette();

    // Wrap canvas in DragTarget to receive dropped templates
    final canvas = DragTarget<NodeTemplate>(
      onAcceptWithDetails: (details) {
        if (_draggingTemplate != null) {
          // Convert global position to canvas position
          final renderBox = context.findRenderObject() as RenderBox;
          final localPosition = renderBox.globalToLocal(details.offset);
          final viewport = widget.controller.state.viewport;
          final canvasPosition = viewport.screenToCanvas(localPosition);

          _createNode(_draggingTemplate!, canvasPosition);
          _draggingTemplate = null;
        }
      },
      builder: (context, candidateData, rejectedData) {
        return _buildCanvas();
      },
    );

    Widget content;
    if (widget.palettePosition == PalettePosition.left) {
      content = Row(
        children: [
          SizedBox(width: widget.paletteWidth, child: palette),
          Expanded(child: canvas),
        ],
      );
    } else if (widget.palettePosition == PalettePosition.right) {
      content = Row(
        children: [
          Expanded(child: canvas),
          SizedBox(width: widget.paletteWidth, child: palette),
        ],
      );
    } else if (widget.palettePosition == PalettePosition.top) {
      content = Column(
        children: [
          SizedBox(height: 80, child: palette),
          Expanded(child: canvas),
        ],
      );
    } else {
      content = Column(
        children: [
          Expanded(child: canvas),
          SizedBox(height: 80, child: palette),
        ],
      );
    }

    if (widget.showToolbar) {
      final toolbar = _buildToolbar();
      if (widget.toolbarPosition == ToolbarPosition.top) {
        content = Column(
          children: [
            toolbar,
            Expanded(child: content),
          ],
        );
      } else {
        content = Column(
          children: [
            Expanded(child: content),
            toolbar,
          ],
        );
      }
    }

    return content;
  }

  Widget _buildPalette() {
    final isHorizontal = widget.palettePosition == PalettePosition.top ||
        widget.palettePosition == PalettePosition.bottom;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        border: Border(
          right: widget.palettePosition == PalettePosition.left
              ? BorderSide(color: Theme.of(context).dividerColor)
              : BorderSide.none,
          left: widget.palettePosition == PalettePosition.right
              ? BorderSide(color: Theme.of(context).dividerColor)
              : BorderSide.none,
          bottom: widget.palettePosition == PalettePosition.top
              ? BorderSide(color: Theme.of(context).dividerColor)
              : BorderSide.none,
          top: widget.palettePosition == PalettePosition.bottom
              ? BorderSide(color: Theme.of(context).dividerColor)
              : BorderSide.none,
        ),
      ),
      child: NodePalette(
        templates: widget.templates,
        direction: isHorizontal ? Axis.horizontal : Axis.vertical,
        showCategories: !isHorizontal,
        collapsedCategories: _collapsedCategories,
        onCategoryToggle: _toggleCategory,
        onTemplateTap: _handleTemplateTap,
        onTemplateDragStarted: (template) {
          _draggingTemplate = template;
        },
        onTemplateDragEnded: (template) {
          _draggingTemplate = null;
        },
        itemBuilder: isHorizontal
            ? (context, template) => CompactPaletteItem(template: template)
            : null,
      ),
    );
  }

  Widget _buildCanvas() {
    return VooNodeCanvas(
      controller: widget.controller,
      config: widget.config,
      onNodeTap: widget.onNodeTap,
      onNodeMoved: widget.onNodeMoved,
      onConnectionCreated: widget.onConnectionCreated,
      onConnectionRemoved: widget.onConnectionRemoved,
      onConnectionTap: widget.onConnectionTap,
      onCanvasTap: widget.onCanvasTap,
      onViewportChanged: widget.onViewportChanged,
    );
  }

  Widget _buildToolbar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        border: Border(
          bottom: widget.toolbarPosition == ToolbarPosition.top
              ? BorderSide(color: Theme.of(context).dividerColor)
              : BorderSide.none,
          top: widget.toolbarPosition == ToolbarPosition.bottom
              ? BorderSide(color: Theme.of(context).dividerColor)
              : BorderSide.none,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.center_focus_strong),
            tooltip: 'Reset View',
            onPressed: _handleResetView,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete Selected',
            onPressed: _handleDelete,
          ),
          const Spacer(),
          _ZoomIndicator(controller: widget.controller),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

/// A widget showing the current zoom level.
class _ZoomIndicator extends StatelessWidget {
  const _ZoomIndicator({required this.controller});

  final CanvasController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final zoom = controller.state.viewport.zoom;
        return Text(
          '${(zoom * 100).round()}%',
          style: Theme.of(context).textTheme.bodySmall,
        );
      },
    );
  }
}

/// Default content widget for nodes created from templates.
class _DefaultNodeContent extends StatelessWidget {
  const _DefaultNodeContent({required this.template});

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
            color.withValues(alpha: 0.8),
            color.withValues(alpha: 0.6),
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
        ],
      ),
    );
  }
}

/// Position of the palette relative to the canvas.
enum PalettePosition {
  /// Palette on the left side.
  left,

  /// Palette on the right side.
  right,

  /// Palette at the top.
  top,

  /// Palette at the bottom.
  bottom,
}

/// Position of the toolbar.
enum ToolbarPosition {
  /// Toolbar at the top.
  top,

  /// Toolbar at the bottom.
  bottom,
}
