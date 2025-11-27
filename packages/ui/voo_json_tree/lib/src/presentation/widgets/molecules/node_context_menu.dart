import 'package:flutter/material.dart';

import 'package:voo_json_tree/src/domain/entities/json_node.dart';
import 'package:voo_json_tree/src/domain/entities/json_tree_theme.dart';

/// Actions available in the context menu.
enum NodeContextAction { copyValue, copyPath, copyJsonPath, expandAll, collapseAll }

/// A context menu for JSON tree nodes.
class NodeContextMenu extends StatelessWidget {
  /// Creates a new [NodeContextMenu].
  const NodeContextMenu({super.key, required this.node, required this.theme, required this.onAction, this.isExpanded = false});

  /// The node this menu is for.
  final JsonNode node;

  /// The theme to use for styling.
  final VooJsonTreeTheme theme;

  /// Callback when an action is selected.
  final void Function(NodeContextAction action) onAction;

  /// Whether the node is expanded (for showing collapse option).
  final bool isExpanded;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minWidth: 180),
    decoration: BoxDecoration(
      color: theme.backgroundColor ?? Theme.of(context).popupMenuTheme.color,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 2))],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _MenuItem(icon: Icons.copy, label: 'Copy value', theme: theme, onTap: () => onAction(NodeContextAction.copyValue)),
        _MenuItem(icon: Icons.link, label: 'Copy path', theme: theme, onTap: () => onAction(NodeContextAction.copyPath)),
        _MenuItem(icon: Icons.code, label: 'Copy JSONPath', theme: theme, onTap: () => onAction(NodeContextAction.copyJsonPath)),
        if (node.isExpandable) ...[
          const Divider(height: 1),
          if (!isExpanded)
            _MenuItem(icon: Icons.unfold_more, label: 'Expand all', theme: theme, onTap: () => onAction(NodeContextAction.expandAll))
          else
            _MenuItem(icon: Icons.unfold_less, label: 'Collapse all', theme: theme, onTap: () => onAction(NodeContextAction.collapseAll)),
        ],
      ],
    ),
  );
}

class _MenuItem extends StatefulWidget {
  const _MenuItem({required this.icon, required this.label, required this.theme, required this.onTap});

  final IconData icon;
  final String label;
  final VooJsonTreeTheme theme;
  final VoidCallback onTap;

  @override
  State<_MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<_MenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _isHovered = true),
    onExit: (_) => setState(() => _isHovered = false),
    child: GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: _isHovered ? widget.theme.hoverColor : null),
        child: Row(
          children: [
            Icon(widget.icon, size: 16, color: widget.theme.expandIconColor),
            const SizedBox(width: 12),
            Text(
              widget.label,
              style: TextStyle(fontFamily: widget.theme.fontFamily, fontSize: widget.theme.fontSize, color: widget.theme.keyColor),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Shows a context menu at the given position.
Future<NodeContextAction?> showNodeContextMenu({
  required BuildContext context,
  required Offset position,
  required JsonNode node,
  required VooJsonTreeTheme theme,
  bool isExpanded = false,
}) => showMenu<NodeContextAction>(
  context: context,
  position: RelativeRect.fromLTRB(position.dx, position.dy, position.dx, position.dy),
  items: [
    PopupMenuItem(
      value: NodeContextAction.copyValue,
      child: Row(
        children: [
          Icon(Icons.copy, size: 16, color: theme.expandIconColor),
          const SizedBox(width: 12),
          const Text('Copy value'),
        ],
      ),
    ),
    PopupMenuItem(
      value: NodeContextAction.copyPath,
      child: Row(
        children: [
          Icon(Icons.link, size: 16, color: theme.expandIconColor),
          const SizedBox(width: 12),
          const Text('Copy path'),
        ],
      ),
    ),
    PopupMenuItem(
      value: NodeContextAction.copyJsonPath,
      child: Row(
        children: [
          Icon(Icons.code, size: 16, color: theme.expandIconColor),
          const SizedBox(width: 12),
          const Text('Copy JSONPath'),
        ],
      ),
    ),
    if (node.isExpandable) ...[
      const PopupMenuDivider(),
      PopupMenuItem(
        value: isExpanded ? NodeContextAction.collapseAll : NodeContextAction.expandAll,
        child: Row(
          children: [
            Icon(isExpanded ? Icons.unfold_less : Icons.unfold_more, size: 16, color: theme.expandIconColor),
            const SizedBox(width: 12),
            Text(isExpanded ? 'Collapse all' : 'Expand all'),
          ],
        ),
      ),
    ],
  ],
);
