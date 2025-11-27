import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:voo_json_tree/src/data/services/json_path_service.dart';
import 'package:voo_json_tree/src/domain/entities/json_node.dart';
import 'package:voo_json_tree/src/domain/entities/json_search_result.dart';
import 'package:voo_json_tree/src/domain/entities/json_tree_builders.dart';
import 'package:voo_json_tree/src/domain/entities/json_tree_config.dart';
import 'package:voo_json_tree/src/domain/entities/json_tree_theme.dart';
import 'package:voo_json_tree/src/presentation/controllers/json_tree_controller.dart';
import 'package:voo_json_tree/src/presentation/widgets/molecules/closing_bracket.dart';
import 'package:voo_json_tree/src/presentation/widgets/molecules/node_context_menu.dart';
import 'package:voo_json_tree/src/presentation/widgets/molecules/tree_node.dart';

/// The main tree view widget displaying the JSON structure.
class JsonTreeView extends StatefulWidget {
  /// Creates a new [JsonTreeView].
  const JsonTreeView({
    super.key,
    required this.controller,
    required this.theme,
    required this.config,
    this.builders,
    this.onNodeTap,
    this.onNodeDoubleTap,
    this.onValueChanged,
  });

  /// The controller managing tree state.
  final JsonTreeController controller;

  /// The theme to use for styling.
  final VooJsonTreeTheme theme;

  /// The configuration.
  final JsonTreeConfig config;

  /// Custom builders for node rendering.
  final JsonTreeBuilders? builders;

  /// Callback when a node is tapped.
  final void Function(JsonNode node)? onNodeTap;

  /// Callback when a node is double-tapped.
  final void Function(JsonNode node)? onNodeDoubleTap;

  /// Callback when a value is changed (editing mode).
  final void Function(String path, dynamic newValue)? onValueChanged;

  @override
  State<JsonTreeView> createState() => _JsonTreeViewState();
}

class _JsonTreeViewState extends State<JsonTreeView> {
  final ScrollController _scrollController = ScrollController();
  final JsonPathService _pathService = const JsonPathService();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _handleContextMenu(JsonNode node, Offset position) async {
    if (!widget.config.enableContextMenu) return;

    final action = await showNodeContextMenu(
      context: context,
      position: position,
      node: node,
      theme: widget.theme,
      isExpanded: widget.controller.isExpanded(node.path),
    );

    if (action == null) return;

    switch (action) {
      case NodeContextAction.copyValue:
        final content = _pathService.formatValueForCopy(node.value);
        await Clipboard.setData(ClipboardData(text: content));
        break;

      case NodeContextAction.copyPath:
        final path = _pathService.formatPath(node.path);
        await Clipboard.setData(ClipboardData(text: path));
        break;

      case NodeContextAction.copyJsonPath:
        final jsonPath = _pathService.toJsonPath(node.path);
        await Clipboard.setData(ClipboardData(text: jsonPath));
        break;

      case NodeContextAction.expandAll:
        widget.controller.expandAll();
        break;

      case NodeContextAction.collapseAll:
        widget.controller.collapseAll();
        break;
    }
  }

  void _handleKeyEvent(KeyEvent event) {
    if (!widget.config.enableKeyboardNavigation) return;
    if (event is! KeyDownEvent) return;

    final selectedPath = widget.controller.selectedPath;
    if (selectedPath == null) return;

    final nodes = widget.controller.getVisibleNodes(includeRoot: widget.config.showRootNode);

    final currentIndex = nodes.indexWhere((n) => n.path == selectedPath);
    if (currentIndex < 0) return;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowUp:
        if (currentIndex > 0) {
          widget.controller.selectNode(nodes[currentIndex - 1].path);
        }
        break;

      case LogicalKeyboardKey.arrowDown:
        if (currentIndex < nodes.length - 1) {
          widget.controller.selectNode(nodes[currentIndex + 1].path);
        }
        break;

      case LogicalKeyboardKey.arrowRight:
        final node = nodes[currentIndex];
        if (node.isExpandable && !widget.controller.isExpanded(node.path)) {
          widget.controller.expandNode(node.path);
        }
        break;

      case LogicalKeyboardKey.arrowLeft:
        final node = nodes[currentIndex];
        if (node.isExpandable && widget.controller.isExpanded(node.path)) {
          widget.controller.collapseNode(node.path);
        }
        break;

      case LogicalKeyboardKey.enter:
        final node = nodes[currentIndex];
        if (node.isExpandable) {
          widget.controller.toggleNode(node.path);
        }
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) => KeyboardListener(
    focusNode: _focusNode,
    onKeyEvent: _handleKeyEvent,
    child: GestureDetector(
      onTap: _focusNode.requestFocus,
      child: ListenableBuilder(listenable: widget.controller, builder: (context, _) => _buildTree()),
    ),
  );

  Widget _buildTree() {
    final rootNode = widget.controller.rootNode;
    if (rootNode == null) {
      return Center(
        child: Text(
          'No data',
          style: TextStyle(fontFamily: widget.theme.fontFamily, fontSize: widget.theme.fontSize, color: widget.theme.nullColor),
        ),
      );
    }

    final visibleNodes = widget.controller.getVisibleNodes(includeRoot: widget.config.showRootNode);

    // Build the list of widgets including closing brackets
    final items = <Widget>[];
    final expandedContainers = <JsonNode>[];

    for (final node in visibleNodes) {
      // Add closing brackets for containers that have ended
      while (expandedContainers.isNotEmpty) {
        final lastContainer = expandedContainers.last;
        if (!node.path.startsWith(lastContainer.path)) {
          items.add(ClosingBracket(key: ValueKey('close_${lastContainer.path}'), node: lastContainer, theme: widget.theme, config: widget.config));
          expandedContainers.removeLast();
        } else {
          break;
        }
      }

      // Get search result for this node
      JsonSearchResult? searchResult;
      for (final result in widget.controller.searchResults) {
        if (result.node.path == node.path) {
          searchResult = result;
          break;
        }
      }

      // Add the node
      Widget nodeWidget = GestureDetector(
        onSecondaryTapUp: (details) {
          _handleContextMenu(node, details.globalPosition);
        },
        onDoubleTap: () => widget.onNodeDoubleTap?.call(node),
        child: TreeNode(
          key: ValueKey(node.path),
          node: node,
          theme: widget.theme,
          config: widget.config,
          builders: widget.builders,
          isExpanded: widget.controller.isExpanded(node.path),
          isSelected: widget.controller.isSelected(node.path),
          isHovered: widget.controller.isHovered(node.path),
          searchResult: searchResult,
          onToggle: () => widget.controller.toggleNode(node.path),
          onSelect: () {
            widget.controller.selectNode(node.path);
            widget.onNodeTap?.call(node);
          },
          onHover: (hovered) {
            widget.controller.setHoveredPath(hovered ? node.path : null);
          },
        ),
      );

      // Apply custom node builder if provided
      if (widget.builders?.nodeBuilder != null) {
        nodeWidget = widget.builders!.nodeBuilder!(context, node, nodeWidget);
      }

      items.add(nodeWidget);

      // Track expanded containers
      if (node.isExpandable && widget.controller.isExpanded(node.path)) {
        expandedContainers.add(node);
      }
    }

    // Add remaining closing brackets
    while (expandedContainers.isNotEmpty) {
      final container = expandedContainers.removeLast();
      items.add(ClosingBracket(key: ValueKey('close_${container.path}'), node: container, theme: widget.theme, config: widget.config));
    }

    return ListView.builder(controller: _scrollController, itemCount: items.length, itemBuilder: (context, index) => items[index]);
  }
}
