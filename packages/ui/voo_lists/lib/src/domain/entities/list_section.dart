import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:voo_lists/src/domain/entities/list_item.dart';

class ListSection<T> extends Equatable {
  final String id;
  final String? title;
  final String? subtitle;
  final List<ListItem<T>> items;
  final Widget? header;
  final Widget? footer;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final bool isSticky;
  final Map<String, dynamic>? metadata;

  const ListSection({
    required this.id,
    required this.items,
    this.title,
    this.subtitle,
    this.header,
    this.footer,
    this.padding,
    this.backgroundColor,
    this.isSticky = false,
    this.metadata,
  });

  ListSection<T> copyWith({
    String? id,
    String? title,
    String? subtitle,
    List<ListItem<T>>? items,
    Widget? header,
    Widget? footer,
    EdgeInsets? padding,
    Color? backgroundColor,
    bool? isSticky,
    Map<String, dynamic>? metadata,
  }) => ListSection<T>(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      items: items ?? this.items,
      header: header ?? this.header,
      footer: footer ?? this.footer,
      padding: padding ?? this.padding,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      isSticky: isSticky ?? this.isSticky,
      metadata: metadata ?? this.metadata,
    );

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        items,
        isSticky,
        backgroundColor,
        metadata,
      ];
}