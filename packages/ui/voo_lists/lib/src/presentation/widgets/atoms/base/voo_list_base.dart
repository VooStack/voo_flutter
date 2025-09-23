import 'package:flutter/material.dart';
import 'package:voo_lists/src/domain/entities/list_config.dart';
import 'package:voo_lists/src/domain/entities/list_item.dart';

abstract class VooListBase<T> extends StatefulWidget {
  final List<ListItem<T>> items;
  final ListConfig config;
  final ValueChanged<ListItem<T>>? onItemTap;
  final ValueChanged<ListItem<T>>? onItemLongPress;
  final ValueChanged<List<ListItem<T>>>? onSelectionChanged;
  final ValueChanged<int>? onReorder;
  final RefreshCallback? onRefresh;
  final VoidCallback? onLoadMore;
  final Widget Function(BuildContext, ListItem<T>, int)? itemBuilder;
  final Widget? header;
  final Widget? footer;
  final ScrollController? scrollController;

  const VooListBase({
    super.key,
    required this.items,
    required this.config,
    this.onItemTap,
    this.onItemLongPress,
    this.onSelectionChanged,
    this.onReorder,
    this.onRefresh,
    this.onLoadMore,
    this.itemBuilder,
    this.header,
    this.footer,
    this.scrollController,
  });
}
