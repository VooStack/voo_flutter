import 'package:flutter/material.dart';

/// Field group configuration for grouping related fields
class FieldGroup {
  final String? title;
  final String? description;
  final List<String> fieldIds;
  final int columns;
  final bool collapsible;
  final bool initiallyExpanded;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const FieldGroup({
    this.title,
    this.description,
    required this.fieldIds,
    this.columns = 1,
    this.collapsible = false,
    this.initiallyExpanded = true,
    this.decoration,
    this.padding,
    this.margin,
  });
}
