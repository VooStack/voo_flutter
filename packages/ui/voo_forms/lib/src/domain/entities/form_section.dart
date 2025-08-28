import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_header.dart';

class VooFormSection extends Equatable {
  final String id;
  final String? title;
  final String? subtitle;
  final String? description;
  final List<String> fieldIds;
  final bool collapsible;
  final bool collapsed;
  final IconData? icon;
  final Color? color;
  final int? columns;
  final VooFormHeader? header;
  final Map<String, dynamic>? metadata;

  const VooFormSection({
    required this.id,
    this.title,
    this.subtitle,
    this.description,
    required this.fieldIds,
    this.collapsible = false,
    this.collapsed = false,
    this.icon,
    this.color,
    this.columns,
    this.header,
    this.metadata,
  });

  VooFormSection copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    List<String>? fieldIds,
    bool? collapsible,
    bool? collapsed,
    IconData? icon,
    Color? color,
    int? columns,
    VooFormHeader? header,
    Map<String, dynamic>? metadata,
  }) {
    return VooFormSection(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      fieldIds: fieldIds ?? this.fieldIds,
      collapsible: collapsible ?? this.collapsible,
      collapsed: collapsed ?? this.collapsed,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      columns: columns ?? this.columns,
      header: header ?? this.header,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    subtitle,
    description,
    fieldIds,
    collapsible,
    collapsed,
    icon,
    color,
    columns,
    header,
  ];
}