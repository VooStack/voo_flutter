import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:voo_lists/src/domain/entities/list_item.dart';

class ListGroup<T> extends Equatable {
  final String id;
  final String title;
  final String? subtitle;
  final List<ListItem<T>> items;
  final bool isExpanded;
  final bool isCollapsible;
  final Widget? leading;
  final Widget? trailing;
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final EdgeInsets? padding;
  final Map<String, dynamic>? metadata;

  const ListGroup({
    required this.id,
    required this.title,
    required this.items,
    this.subtitle,
    this.isExpanded = true,
    this.isCollapsible = true,
    this.leading,
    this.trailing,
    this.backgroundColor,
    this.titleStyle,
    this.subtitleStyle,
    this.padding,
    this.metadata,
  });

  ListGroup<T> copyWith({
    String? id,
    String? title,
    String? subtitle,
    List<ListItem<T>>? items,
    bool? isExpanded,
    bool? isCollapsible,
    Widget? leading,
    Widget? trailing,
    Color? backgroundColor,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    EdgeInsets? padding,
    Map<String, dynamic>? metadata,
  }) {
    return ListGroup<T>(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      items: items ?? this.items,
      isExpanded: isExpanded ?? this.isExpanded,
      isCollapsible: isCollapsible ?? this.isCollapsible,
      leading: leading ?? this.leading,
      trailing: trailing ?? this.trailing,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      titleStyle: titleStyle ?? this.titleStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      padding: padding ?? this.padding,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        items,
        isExpanded,
        isCollapsible,
        backgroundColor,
        metadata,
      ];
}