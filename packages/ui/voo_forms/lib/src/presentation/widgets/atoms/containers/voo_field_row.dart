import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/field_layout.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_field_base.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_form_field_widget.dart';

/// Row container for form fields - arranges fields horizontally
/// Implements VooFormFieldWidget so it can be used in VooForm fields list
/// Allows nesting and grouping of fields with row layout
/// Follows atomic design and KISS principle
class VooFieldRow extends StatelessWidget implements VooFormFieldWidget {
  @override
  final String name;

  /// Fields to display in this row
  final List<VooFormFieldWidget> fields;

  /// Optional label for the row (displayed as title)
  @override
  final String? label;

  /// Optional title for the row (deprecated, use label instead)
  final String? title;

  /// Custom widget to display as header
  final Widget? headerWidget;

  /// Spacing between fields
  final double spacing;

  /// Padding around the row
  final EdgeInsetsGeometry? padding;

  /// Background decoration
  final BoxDecoration? decoration;

  /// Cross axis alignment for fields
  final CrossAxisAlignment crossAxisAlignment;

  /// Main axis alignment for fields
  final MainAxisAlignment mainAxisAlignment;

  /// Main axis size
  final MainAxisSize? mainAxisSize;

  /// Whether to wrap fields when they overflow
  final bool wrap;

  /// Run spacing for wrapped layout
  final double runSpacing;

  /// Whether to expand fields equally
  final bool expandFields;

  /// Flex values for each field (if provided)
  final List<int>? fieldFlex;

  /// Whether to wrap fields in Flexible widgets to prevent overflow
  /// Set to false when fields have their own size constraints
  /// When true, fields without explicit width constraints will be wrapped in Flexible
  final bool flexibleFields;

  /// Layout configuration for the row
  @override
  final VooFieldLayout layout;

  bool get required => false;

  dynamic get value => null;

  @override
  dynamic get initialValue => null;

  const VooFieldRow({
    super.key,
    required this.name,
    required this.fields,
    this.label,
    this.title,
    this.headerWidget,
    this.spacing = 16.0,
    this.padding,
    this.decoration,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize,
    this.wrap = false,
    this.runSpacing = 16.0,
    this.expandFields = false,
    this.fieldFlex,
    this.flexibleFields = true,
    this.layout = VooFieldLayout.wide,
  }) : assert(label == null || title == null, 'Cannot provide both label and title. Use label instead.');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Build fields with appropriate wrapping/expanding
    final List<Widget> fieldWidgets = [];
    for (int i = 0; i < fields.length; i++) {
      Widget field = fields[i];

      // Check if field has explicit width constraints
      // If it does, we should not wrap it in Flexible to avoid constraint conflicts
      bool hasWidthConstraints = false;
      if (field is VooFieldBase) {
        hasWidthConstraints = field.minWidth != null || field.maxWidth != null;
      }

      // Apply flex if expanding fields
      if (expandFields || (fieldFlex != null && i < fieldFlex!.length)) {
        final flex = fieldFlex != null && i < fieldFlex!.length ? fieldFlex![i] : 1;
        field = Expanded(
          flex: flex,
          child: field,
        );
      } else if (!wrap && flexibleFields && !hasWidthConstraints) {
        // Only wrap in Flexible if:
        // 1. Not using Wrap layout
        // 2. flexibleFields is true
        // 3. Field doesn't have its own width constraints
        field = Flexible(
          child: field,
        );
      }
      // Fields with width constraints or when flexibleFields is false
      // manage their own constraints

      fieldWidgets.add(field);

      // Add spacing between fields
      if (i < fields.length - 1) {
        fieldWidgets.add(SizedBox(width: spacing));
      }
    }

    Widget content;

    // Use Wrap if wrapping is enabled
    if (wrap) {
      content = Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: fields, // Use original fields for Wrap, not expanded versions
      );
    } else {
      // Use MainAxisSize.min by default when not expanding to avoid unbounded constraints
      // Use MainAxisSize.max when expanding fields or if explicitly specified
      final effectiveMainAxisSize = mainAxisSize ?? (expandFields || fieldFlex != null ? MainAxisSize.max : MainAxisSize.min);

      content = Row(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: effectiveMainAxisSize,
        children: fieldWidgets,
      );
    }

    // Build the complete widget with optional title
    Widget result = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header widget or title
        if (headerWidget != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: headerWidget,
          )
        else if (label != null || title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              label ?? title ?? '',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),

        // Row content
        content,
      ],
    );

    // Apply decoration if provided
    if (decoration != null || padding != null) {
      result = Container(
        padding: padding,
        decoration: decoration,
        child: result,
      );
    }

    return result;
  }

  @override
  VooFormFieldWidget copyWith() => VooFieldRow(
        key: key,
        name: name,
        fields: fields.map((field) => field.copyWith()).toList(),
        label: label,
        title: title,
        headerWidget: headerWidget,
        spacing: spacing,
        padding: padding,
        decoration: decoration,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        layout: layout,
      );
}
