import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_form_field_widget.dart';

/// Horizontal layout for form fields - displays fields in a scrollable row
class VooHorizontalFormLayout extends StatelessWidget {
  final List<VooFormFieldWidget> fields;
  final double spacing;
  final double fieldWidth;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;

  const VooHorizontalFormLayout({
    super.key,
    required this.fields,
    this.spacing = 20.0,
    this.fieldWidth = 280.0,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: IntrinsicHeight(
      child: Row(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: fields.asMap().entries.map((entry) {
          final index = entry.key;
          final field = entry.value;
          final isLast = index == fields.length - 1;

          return Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : spacing),
            child: SizedBox(width: fieldWidth, child: field),
          );
        }).toList(),
      ),
    ),
  );
}
