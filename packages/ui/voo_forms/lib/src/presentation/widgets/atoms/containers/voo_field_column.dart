import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/field_layout.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_form_field_widget.dart';

/// Column container for form fields - arranges fields vertically
/// Implements VooFormFieldWidget so it can be used in VooForm fields list
/// Allows nesting and grouping of fields with column layout
/// Follows atomic design and KISS principle
class VooFieldColumn extends StatelessWidget implements VooFormFieldWidget {
  @override
  final String name;

  /// Fields to display in this column
  final List<VooFormFieldWidget> fields;

  /// Optional label for the column (displayed as title)
  @override
  final String? label;

  /// Optional title for the column (deprecated, use label instead)
  final String? title;

  /// Custom widget to display as header
  final Widget? headerWidget;

  /// Spacing between fields
  final double spacing;

  /// Padding around the column
  final EdgeInsetsGeometry? padding;

  /// Background decoration
  final BoxDecoration? decoration;

  /// Cross axis alignment for fields
  final CrossAxisAlignment crossAxisAlignment;

  /// Main axis alignment for fields
  final MainAxisAlignment mainAxisAlignment;

  /// Main axis size
  final MainAxisSize mainAxisSize;

  /// Whether to expand to fill available space
  final bool expanded;

  /// Flex value when expanded
  final int flex;

  /// Layout configuration for the column
  @override
  final VooFieldLayout layout;

  bool get required => false;

  dynamic get value => null;

  @override
  dynamic get initialValue => null;

  const VooFieldColumn({
    super.key,
    required this.name,
    required this.fields,
    this.label,
    this.title,
    this.headerWidget,
    this.spacing = 16.0,
    this.padding,
    this.decoration,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
    this.expanded = false,
    this.flex = 1,
    this.layout = VooFieldLayout.standard,
  }) : assert(label == null || title == null, 'Cannot provide both label and title. Use label instead.');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget column = Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: [
        // Header widget or title
        if (headerWidget != null)
          headerWidget!
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

        // Fields with spacing
        for (int i = 0; i < fields.length; i++) ...[
          fields[i],
          if (i < fields.length - 1) SizedBox(height: spacing),
        ],
      ],
    );

    // Apply decoration if provided
    if (decoration != null || padding != null) {
      column = Container(
        padding: padding,
        decoration: decoration,
        child: column,
      );
    }

    // Apply expansion if needed
    if (expanded) {
      return Expanded(
        flex: flex,
        child: column,
      );
    }

    return column;
  }

  @override
  VooFormFieldWidget copyWith() => VooFieldColumn(
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
        expanded: expanded,
        flex: flex,
        layout: layout,
      );
}
