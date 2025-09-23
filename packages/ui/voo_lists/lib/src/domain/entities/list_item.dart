import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ListItem<T> extends Equatable {
  final String id;
  final T data;
  final Widget? leading;
  final Widget? trailing;
  final String title;
  final String? subtitle;
  final bool isSelectable;
  final bool isDismissible;
  final bool isReorderable;
  final bool isExpandable;
  final List<ListItem<T>>? children;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Map<String, dynamic>? metadata;

  const ListItem({
    required this.id,
    required this.data,
    this.leading,
    this.trailing,
    required this.title,
    this.subtitle,
    this.isSelectable = false,
    this.isDismissible = false,
    this.isReorderable = false,
    this.isExpandable = false,
    this.children,
    this.onTap,
    this.onLongPress,
    this.metadata,
  });

  ListItem<T> copyWith({
    String? id,
    T? data,
    Widget? leading,
    Widget? trailing,
    String? title,
    String? subtitle,
    bool? isSelectable,
    bool? isDismissible,
    bool? isReorderable,
    bool? isExpandable,
    List<ListItem<T>>? children,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    Map<String, dynamic>? metadata,
  }) => ListItem<T>(
    id: id ?? this.id,
    data: data ?? this.data,
    leading: leading ?? this.leading,
    trailing: trailing ?? this.trailing,
    title: title ?? this.title,
    subtitle: subtitle ?? this.subtitle,
    isSelectable: isSelectable ?? this.isSelectable,
    isDismissible: isDismissible ?? this.isDismissible,
    isReorderable: isReorderable ?? this.isReorderable,
    isExpandable: isExpandable ?? this.isExpandable,
    children: children ?? this.children,
    onTap: onTap ?? this.onTap,
    onLongPress: onLongPress ?? this.onLongPress,
    metadata: metadata ?? this.metadata,
  );

  @override
  List<Object?> get props => [id, data, title, subtitle, isSelectable, isDismissible, isReorderable, isExpandable, children, metadata];
}
