import 'package:flutter/material.dart';
import 'package:voo_lists/src/presentation/widgets/atoms/base/voo_list_base.dart';

class VooReorderableList<T> extends VooListBase<T> {
  const VooReorderableList({super.key, required super.items, required super.config, super.onReorder});

  @override
  State<VooReorderableList<T>> createState() => _VooReorderableListState<T>();
}

class _VooReorderableListState<T> extends State<VooReorderableList<T>> {
  @override
  Widget build(BuildContext context) => ReorderableListView.builder(
    itemCount: widget.items.length,
    itemBuilder: (context, index) {
      final item = widget.items[index];
      return ListTile(key: ValueKey(item.id), title: Text(item.title), subtitle: item.subtitle != null ? Text(item.subtitle!) : null);
    },
    onReorder: (oldIndex, newIndex) {
      widget.onReorder?.call(newIndex);
    },
  );
}
