import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_form_field_widget.dart';

/// Wrapped layout for form fields - displays fields in a responsive wrap
/// Fields flow naturally and wrap to the next line when needed
class VooWrappedFormLayout extends StatelessWidget {
  final List<VooFormFieldWidget> fields;
  final double spacing;
  final double runSpacing;
  final double minFieldWidth;
  final WrapAlignment alignment;
  final WrapAlignment runAlignment;
  final WrapCrossAlignment crossAxisAlignment;

  const VooWrappedFormLayout({
    super.key,
    required this.fields,
    this.spacing = 20.0,
    this.runSpacing = 20.0,
    this.minFieldWidth = 280.0,
    this.alignment = WrapAlignment.start,
    this.runAlignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
  });

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          // Calculate optimal field width based on available space
          final availableWidth = constraints.maxWidth;

          // Calculate how many fields can fit in a row
          final fieldsPerRow = (availableWidth / (minFieldWidth + spacing)).floor();
          final effectiveFieldsPerRow = fieldsPerRow > 0 ? fieldsPerRow : 1;

          // Calculate actual field width to use
          final defaultFieldWidth = effectiveFieldsPerRow == 1
              ? availableWidth // Full width for single column
              : (availableWidth - (spacing * (effectiveFieldsPerRow - 1))) / effectiveFieldsPerRow;

          final children = <Widget>[];
          
          for (final field in fields) {
            // Check if field should take full width
            if (field.layout.fullWidth) {
              // Add a full width field
              children.add(
                SizedBox(
                  width: availableWidth,
                  child: field,
                ),
              );
            } else {
              // Use calculated width for normal fields
              final fieldMinWidth = field.layout.minWidth ?? minFieldWidth;
              final fieldMaxWidth = field.layout.maxWidth;
              
              var width = defaultFieldWidth;
              if (fieldMaxWidth != null && width > fieldMaxWidth) {
                width = fieldMaxWidth;
              }
              if (width < fieldMinWidth) {
                width = fieldMinWidth.clamp(0, availableWidth);
              }
              
              children.add(
                SizedBox(
                  width: width,
                  child: field,
                ),
              );
            }
          }

          return Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            alignment: alignment,
            runAlignment: runAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: children,
          );
        },
      );
}
