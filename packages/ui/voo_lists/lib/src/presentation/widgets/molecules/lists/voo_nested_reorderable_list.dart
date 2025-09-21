import 'package:flutter/material.dart';
import 'package:voo_lists/src/domain/entities/list_config.dart';
import 'package:voo_lists/src/domain/entities/list_item.dart';
import 'package:voo_lists/src/presentation/widgets/atoms/base/voo_list_base.dart';

class VooNestedReorderableList<T> extends VooListBase<T> {
  final void Function(List<ListItem<T>> reorderedItems)? onNestedReorder;
  final void Function(ListItem<T> item, ListItem<T>? newParent)? onItemMoved;
  final bool allowCrossLevelDrag;
  final int maxNestingDepth;
  final bool startExpanded;
  final bool showTreeLines;
  final bool showDepthIndicator;

  const VooNestedReorderableList({
    super.key,
    required super.items,
    super.config = const ListConfig(),
    super.onItemTap,
    super.onItemLongPress,
    super.onSelectionChanged,
    super.onRefresh,
    super.onReorder,
    this.onNestedReorder,
    this.onItemMoved,
    this.allowCrossLevelDrag = true,
    this.maxNestingDepth = 5,
    this.startExpanded = false,
    this.showTreeLines = true,
    this.showDepthIndicator = true,
  });

  @override
  State<VooNestedReorderableList<T>> createState() => _VooNestedReorderableListState<T>();
}

class _VooNestedReorderableListState<T> extends State<VooNestedReorderableList<T>> with TickerProviderStateMixin {
  late List<ListItem<T>> _items;
  final Set<String> _expandedItems = {};
  final Map<String, AnimationController> _expandControllers = {};
  final Map<String, Animation<double>> _expandAnimations = {};
  String? _draggingItemId;
  String? _dragOverItemId;
  bool _isDragOverAsChild = false;

  // Color palette for depth levels
  final List<Color> _depthColors = [
    Colors.blue.shade50,
    Colors.indigo.shade50,
    Colors.purple.shade50,
    Colors.deepPurple.shade50,
    Colors.pink.shade50,
  ];

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);
    _initializeExpandedState();
  }

  @override
  void dispose() {
    for (final controller in _expandControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(VooNestedReorderableList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      setState(() {
        _items = List.from(widget.items);
      });
    }
  }

  void _initializeExpandedState() {
    void expandAll(List<ListItem<T>> items) {
      for (final item in items) {
        if (item.isExpandable && item.children != null && item.children!.isNotEmpty) {
          _expandedItems.add(item.id);
          _createExpandAnimation(item.id, isExpanded: true);
          expandAll(item.children!);
        }
      }
    }

    if (widget.startExpanded) {
      expandAll(_items);
    }
  }

  void _createExpandAnimation(String itemId, {required bool isExpanded}) {
    if (!_expandControllers.containsKey(itemId)) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );
      _expandControllers[itemId] = controller;
      _expandAnimations[itemId] = CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOutCubic,
      );
    }

    if (isExpanded) {
      _expandControllers[itemId]!.forward();
    } else {
      _expandControllers[itemId]!.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_items.isEmpty && widget.config.emptyStateWidget != null) {
      return Center(child: widget.config.emptyStateWidget);
    }

    return widget.config.enablePullToRefresh && widget.onRefresh != null
        ? RefreshIndicator(
            onRefresh: widget.onRefresh!,
            child: _buildNestedReorderableList(theme),
          )
        : _buildNestedReorderableList(theme);
  }

  Widget _buildNestedReorderableList(ThemeData theme) => ListView.builder(
        padding: widget.config.padding,
        itemCount: _items.length + 1, // Add extra item for bottom drop zone
        itemBuilder: (context, index) {
          if (index == _items.length) {
            // Bottom drop zone
            return _buildBottomDropZone();
          }
          final item = _items[index];
          return _buildNestedItem(
            item: item,
            depth: 0,
            index: index,
            parentExpanded: true,
            isLastChild: index == _items.length - 1,
            isFirstChild: false,
          );
        },
      );

  Widget _buildNestedItem({
    required ListItem<T> item,
    required int depth,
    required int index,
    required bool parentExpanded,
    required bool isLastChild,
    required bool isFirstChild,
    String? parentId,
  }) {
    final hasChildren = item.children != null && item.children!.isNotEmpty;
    final isExpanded = _expandedItems.contains(item.id);
    final isDragging = _draggingItemId == item.id;
    final isDragOver = _dragOverItemId == item.id;

    if (!_expandControllers.containsKey(item.id) && hasChildren) {
      _createExpandAnimation(item.id, isExpanded: isExpanded);
    }

    return Column(
      children: [
        // Drop zone indicator above item
        if (isDragOver && !_isDragOverAsChild)
          Container(
            height: 4,
            margin: EdgeInsets.only(left: depth * 40.0 + 16, right: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

        DragTarget<ListItem<T>>(
          onWillAcceptWithDetails: (details) => _canAcceptDrop(details.data, item, depth),
          onAcceptWithDetails: (details) => _handleDrop(details.data, item),
          onLeave: (_) {
            setState(() {
              _dragOverItemId = null;
              _isDragOverAsChild = false;
            });
          },
          onMove: (details) {
            setState(() {
              _dragOverItemId = item.id;
              // Determine if hovering over the item as a child or sibling
              final renderBox = context.findRenderObject() as RenderBox?;
              if (renderBox != null) {
                final localPosition = renderBox.globalToLocal(details.offset);
                _isDragOverAsChild = localPosition.dx > 60 + (depth * 40);
              }
            });
          },
          builder: (context, candidateData, rejectedData) => _buildItemTile(
            item: item,
            depth: depth,
            hasChildren: hasChildren,
            isExpanded: isExpanded,
            isDragging: isDragging,
            isDragOver: isDragOver && _isDragOverAsChild,
            isLastChild: isLastChild,
            parentId: parentId,
          ),
        ),

        // Animated children container
        if (hasChildren && _expandAnimations.containsKey(item.id))
          SizeTransition(
            sizeFactor: _expandAnimations[item.id]!,
            child: Column(
              children: item.children!.asMap().entries.map((entry) {
                final childIndex = entry.key;
                final childItem = entry.value;
                return _buildNestedItem(
                  item: childItem,
                  depth: depth + 1,
                  index: childIndex,
                  parentExpanded: isExpanded,
                  isLastChild: childIndex == item.children!.length - 1,
                  isFirstChild: childIndex == 0,
                  parentId: item.id,
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildItemTile({
    required ListItem<T> item,
    required int depth,
    required bool hasChildren,
    required bool isExpanded,
    required bool isDragging,
    required bool isDragOver,
    required bool isLastChild,
    String? parentId,
  }) {
    final theme = Theme.of(context);
    final indentation = depth * 40.0;
    final depthColor = widget.showDepthIndicator && depth < _depthColors.length ? _depthColors[depth] : Colors.transparent;

    final Widget tile = Container(
      margin: EdgeInsets.only(
        left: 8.0 + indentation,
        right: 8.0,
        top: 2.0,
        bottom: 2.0,
      ),
      child: Material(
        elevation: isDragging ? 8 : (isDragOver ? 4 : 1),
        borderRadius: BorderRadius.circular(12),
        color: isDragOver ? theme.colorScheme.primary.withValues(alpha: 0.1) : depthColor,
        child: InkWell(
          onTap: hasChildren && !isDragging ? () => _toggleExpanded(item.id) : () => _handleItemTap(item),
          onLongPress: () => _handleItemLongPress(item),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDragOver ? theme.colorScheme.primary.withValues(alpha: 0.5) : Colors.transparent,
                width: isDragOver ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Drag handle (left side for better UX)
                if (item.isReorderable) _buildDragHandle(item, isDragging),

                // Expand/collapse indicator
                if (hasChildren || item.isExpandable) _buildExpandIndicator(item.id, isExpanded) else const SizedBox(width: 40),

                // Leading widget
                if (item.leading != null) ...[
                  item.leading!,
                  const SizedBox(width: 12),
                ],

                // Title and subtitle
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (item.subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            item.subtitle!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                        if (hasChildren && !isExpanded) ...[
                          const SizedBox(height: 4),
                          Text(
                            '${item.children!.length} items',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Trailing widget
                if (item.trailing != null) ...[
                  item.trailing!,
                  const SizedBox(width: 12),
                ],

                // Depth indicator
                if (widget.showDepthIndicator && depth > 0)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'L$depth',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    return tile;
  }

  Widget _buildDragHandle(ListItem<T> item, bool isDragging) => Draggable<ListItem<T>>(
        data: item,
        feedback: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.drag_indicator,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        childWhenDragging: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: Icon(
            Icons.drag_indicator,
            color: Theme.of(context).disabledColor,
          ),
        ),
        onDragStarted: () {
          setState(() {
            _draggingItemId = item.id;
          });
        },
        onDragEnd: (_) {
          setState(() {
            _draggingItemId = null;
            _dragOverItemId = null;
            _isDragOverAsChild = false;
          });
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.move,
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            child: Icon(
              Icons.drag_indicator,
              color: isDragging ? Theme.of(context).colorScheme.primary : Theme.of(context).iconTheme.color?.withValues(alpha: 0.5),
            ),
          ),
        ),
      );

  Widget _buildExpandIndicator(String itemId, bool isExpanded) => IconButton(
        icon: AnimatedRotation(
          turns: isExpanded ? 0.5 : 0,
          duration: const Duration(milliseconds: 300),
          child: Icon(
            Icons.expand_more,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        onPressed: () => _toggleExpanded(itemId),
        tooltip: isExpanded ? 'Collapse' : 'Expand',
      );

  Widget _buildBottomDropZone() {
    final isDragOver = _dragOverItemId == '__bottom__';

    return DragTarget<ListItem<T>>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) {
        setState(() {
          _removeItemFromTree(details.data.id);
          _items.add(details.data);
          _dragOverItemId = null;
        });
        widget.onNestedReorder?.call(_items);
      },
      onLeave: (_) {
        setState(() {
          _dragOverItemId = null;
        });
      },
      onMove: (_) {
        setState(() {
          _dragOverItemId = '__bottom__';
        });
      },
      builder: (context, candidateData, rejectedData) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: candidateData.isNotEmpty || isDragOver ? 60 : 20,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDragOver ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDragOver ? Theme.of(context).colorScheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: isDragOver || candidateData.isNotEmpty
              ? Text(
                  'Drop here to add at the bottom',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }

  void _toggleExpanded(String itemId) {
    setState(() {
      if (_expandedItems.contains(itemId)) {
        _expandedItems.remove(itemId);
        _expandControllers[itemId]?.reverse();
      } else {
        _expandedItems.add(itemId);
        _expandControllers[itemId]?.forward();
      }
    });
  }

  void _handleItemTap(ListItem<T> item) {
    item.onTap?.call();
    widget.onItemTap?.call(item);
  }

  void _handleItemLongPress(ListItem<T> item) {
    item.onLongPress?.call();
    widget.onItemLongPress?.call(item);
  }

  bool _canAcceptDrop(ListItem<T>? draggedItem, ListItem<T> targetItem, int targetDepth) {
    if (draggedItem == null) return false;
    if (draggedItem.id == targetItem.id) return false;

    if (!widget.allowCrossLevelDrag && draggedItem.id != targetItem.id) {
      return false;
    }

    if (_isDragOverAsChild && targetDepth >= widget.maxNestingDepth - 1) {
      return false;
    }

    // Check if dragged item is an ancestor of target
    bool isAncestor(ListItem<T> item, String targetId) {
      if (item.children == null) return false;
      for (final child in item.children!) {
        if (child.id == targetId) return true;
        if (isAncestor(child, targetId)) return true;
      }
      return false;
    }

    return !isAncestor(draggedItem, targetItem.id);
  }

  void _handleDrop(ListItem<T> draggedItem, ListItem<T> targetItem) {
    setState(() {
      // Remove dragged item from its current position
      _removeItemFromTree(draggedItem.id);

      if (_isDragOverAsChild) {
        // Add dragged item as child of target
        final updatedTarget = targetItem.copyWith(
          children: [
            ...(targetItem.children ?? []),
            draggedItem,
          ],
        );

        _updateItemInTree(updatedTarget);

        // Ensure target is expanded to show the newly added item
        _expandedItems.add(targetItem.id);
        _createExpandAnimation(targetItem.id, isExpanded: true);
      } else {
        // Add dragged item as sibling of target
        _insertItemAsSibling(draggedItem, targetItem.id);
      }

      _dragOverItemId = null;
      _isDragOverAsChild = false;
    });

    widget.onItemMoved?.call(draggedItem, _isDragOverAsChild ? targetItem : null);
    widget.onNestedReorder?.call(_items);
  }

  void _insertItemAsSibling(ListItem<T> item, String targetId) {
    void insertInList(List<ListItem<T>> list) {
      for (int i = 0; i < list.length; i++) {
        if (list[i].id == targetId) {
          list.insert(i, item);
          return;
        }
        if (list[i].children != null) {
          insertInList(list[i].children!);
        }
      }
    }

    insertInList(_items);
  }

  void _removeItemFromTree(String itemId) {
    void removeFromList(List<ListItem<T>> list) {
      for (int i = 0; i < list.length; i++) {
        if (list[i].id == itemId) {
          list.removeAt(i);
          return;
        }
        if (list[i].children != null && list[i].children!.isNotEmpty) {
          // Create a mutable copy of children if it's not already mutable
          final children = List<ListItem<T>>.from(list[i].children!);
          removeFromList(children);

          if (children.length != list[i].children!.length) {
            // Item was removed from children, update parent
            list[i] = list[i].copyWith(children: children.isEmpty ? null : children);
          }
        }
      }
    }

    removeFromList(_items);
  }

  void _updateItemInTree(ListItem<T> updatedItem) {
    void updateInList(List<ListItem<T>> list) {
      for (int i = 0; i < list.length; i++) {
        if (list[i].id == updatedItem.id) {
          list[i] = updatedItem;
          return;
        }
        if (list[i].children != null) {
          updateInList(list[i].children!);
        }
      }
    }

    updateInList(_items);
  }
}
