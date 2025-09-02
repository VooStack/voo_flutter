import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_form_field_widget.dart';

/// Vertical layout for form fields - displays fields in a column
class VooVerticalFormLayout extends StatelessWidget {
  final List<VooFormFieldWidget> fields;
  final double spacing;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;

  const VooVerticalFormLayout({
    super.key,
    required this.fields,
    this.spacing = 20.0,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: fields.asMap().entries.map((entry) {
          final index = entry.key;
          final field = entry.value;
          final isLast = index == fields.length - 1;
          
          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : spacing),
            child: field,
          );
        }).toList(),
      );
}