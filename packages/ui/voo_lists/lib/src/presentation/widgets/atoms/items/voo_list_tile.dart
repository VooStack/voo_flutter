import 'package:flutter/material.dart';
import 'package:voo_lists/src/domain/entities/list_item.dart';

class VooListTile<T> extends StatelessWidget {
  final ListItem<T> item;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const VooListTile({super.key, required this.item, this.isSelected = false, this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) => ListTile(
    key: ValueKey(item.id),
    leading: item.leading,
    trailing: item.trailing,
    title: Text(item.title),
    subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
    selected: isSelected,
    onTap: onTap ?? item.onTap,
    onLongPress: onLongPress ?? item.onLongPress,
  );
}
