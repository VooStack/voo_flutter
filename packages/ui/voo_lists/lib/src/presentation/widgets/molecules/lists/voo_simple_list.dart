import 'package:flutter/material.dart';
import 'package:voo_lists/src/domain/entities/list_config.dart';
import 'package:voo_lists/src/domain/entities/list_item.dart';
import 'package:voo_lists/src/presentation/widgets/atoms/base/voo_list_base.dart';

class VooSimpleList<T> extends VooListBase<T> {
  const VooSimpleList({
    super.key,
    required super.items,
    super.config = const ListConfig(),
    super.onItemTap,
    super.onItemLongPress,
    super.onSelectionChanged,
    super.onRefresh,
    super.onLoadMore,
    super.itemBuilder,
    super.header,
    super.footer,
    super.scrollController,
  });

  @override
  State<VooSimpleList<T>> createState() => _VooSimpleListState<T>();
}

class _VooSimpleListState<T> extends State<VooSimpleList<T>> {
  late ScrollController _scrollController;
  final Set<String> _selectedItems = {};

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    if (widget.config.enableInfiniteScroll && widget.onLoadMore != null) {
      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
          widget.onLoadMore!();
        }
      });
    }
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  Widget _buildItem(BuildContext context, ListItem<T> item, int index) {
    if (widget.itemBuilder != null) {
      return widget.itemBuilder!(context, item, index);
    }

    final isSelected = _selectedItems.contains(item.id);

    return ListTile(
      key: ValueKey(item.id),
      leading: item.leading,
      trailing: item.trailing,
      title: Text(item.title),
      subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
      selected: isSelected,
      onTap: () => _handleItemTap(item),
      onLongPress: () => _handleItemLongPress(item),
    );
  }

  void _handleItemTap(ListItem<T> item) {
    if (widget.config.enableSelection) {
      setState(() {
        if (_selectedItems.contains(item.id)) {
          _selectedItems.remove(item.id);
        } else {
          if (!widget.config.enableMultiSelection) {
            _selectedItems.clear();
          }
          _selectedItems.add(item.id);
        }
      });

      if (widget.onSelectionChanged != null) {
        final selectedItems = widget.items
            .where((item) => _selectedItems.contains(item.id))
            .toList();
        widget.onSelectionChanged!(selectedItems);
      }
    }

    widget.onItemTap?.call(item);
  }

  void _handleItemLongPress(ListItem<T> item) {
    widget.onItemLongPress?.call(item);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty && widget.config.emptyStateWidget != null) {
      return widget.config.emptyStateWidget!;
    }

    Widget listView = ListView.separated(
      controller: _scrollController,
      physics: widget.config.physics,
      scrollDirection: widget.config.scrollDirection,
      reverse: widget.config.reverse,
      shrinkWrap: widget.config.shrinkWrap,
      padding: widget.config.padding,
      itemCount: widget.items.length + (widget.header != null ? 1 : 0) + (widget.footer != null ? 1 : 0),
      separatorBuilder: (context, index) {
        if (widget.config.showDividers) {
          return const Divider();
        }
        return SizedBox(
          height: widget.config.scrollDirection == Axis.vertical
              ? widget.config.itemSpacing ?? 0
              : 0,
          width: widget.config.scrollDirection == Axis.horizontal
              ? widget.config.itemSpacing ?? 0
              : 0,
        );
      },
      itemBuilder: (context, index) {
        if (widget.header != null && index == 0) {
          return widget.header!;
        }

        final itemIndex = widget.header != null ? index - 1 : index;

        if (itemIndex >= widget.items.length) {
          return widget.footer!;
        }

        return _buildItem(context, widget.items[itemIndex], itemIndex);
      },
    );

    if (widget.config.enablePullToRefresh && widget.onRefresh != null) {
      listView = RefreshIndicator(
        onRefresh: widget.onRefresh!,
        child: listView,
      );
    }

    return listView;
  }
}