import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_form_field_widget.dart';

/// Grid layout for form fields - displays fields in a responsive grid
class VooGridFormLayout extends StatelessWidget {
  final List<VooFormFieldWidget> fields;
  final int columns;
  final double spacing;
  final double horizontalSpacing;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;

  const VooGridFormLayout({
    super.key,
    required this.fields,
    this.columns = 2,
    this.spacing = 20.0,
    this.horizontalSpacing = 24.0,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    int i = 0;

    while (i < fields.length) {
      final field = fields[i];

      // Check if field should take full width
      if (field.layout.fullWidth) {
        // Add full width field on its own row
        rows.add(field);
        if (i < fields.length - 1) {
          rows.add(SizedBox(height: spacing));
        }
        i++;
        continue;
      }

      // Build a row with fields that fit
      final rowChildren = <Widget>[];
      int columnsUsed = 0;

      while (i < fields.length && columnsUsed < columns) {
        final currentField = fields[i];

        // Skip if this field needs full width (will be handled in next iteration)
        if (currentField.layout.fullWidth) {
          break;
        }

        final currentSpan = currentField.layout.gridSpan?.clamp(1, columns - columnsUsed) ?? 1;

        // Check if this field fits in the current row
        if (columnsUsed + currentSpan > columns) {
          break;
        }

        // Add the field with appropriate flex
        // Use Expanded to ensure fields fill their grid cells
        rowChildren.add(
          Expanded(
            flex: currentSpan,
            child: Padding(
              padding: EdgeInsets.only(
                right: columnsUsed + currentSpan >= columns ? 0 : horizontalSpacing / 2,
                left: columnsUsed == 0 ? 0 : horizontalSpacing / 2,
              ),
              child: currentField,
            ),
          ),
        );

        columnsUsed += currentSpan;
        i++;
      }

      // Add empty slots if row is not full
      if (columnsUsed < columns && rowChildren.isNotEmpty) {
        rowChildren.add(
          Expanded(
            flex: columns - columnsUsed,
            child: const SizedBox.shrink(),
          ),
        );
      }

      if (rowChildren.isNotEmpty) {
        rows.add(
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: rowChildren,
            ),
          ),
        );

        if (i < fields.length) {
          rows.add(SizedBox(height: spacing));
        }
      }
    }

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: rows,
    );
  }
}
