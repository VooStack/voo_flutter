import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_form_field_widget.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Horizontal layout for form fields - displays fields in a scrollable row
class VooHorizontalFormLayout extends StatelessWidget {
  final List<VooFormFieldWidget> fields;
  final double? spacing;
  final double? fieldWidth;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;

  const VooHorizontalFormLayout({
    super.key,
    required this.fields,
    this.spacing,
    this.fieldWidth,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
  });

  @override
  Widget build(BuildContext context) {
    final gap = context.vooGap;
    final size = context.vooSize;
    final effectiveSpacing = spacing ?? gap.gridItems;
    final effectiveFieldWidth = fieldWidth ?? size.inputHeight * 6; // ~280

    return SingleChildScrollView(
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
              padding: EdgeInsets.only(right: isLast ? 0 : effectiveSpacing),
              child: SizedBox(width: effectiveFieldWidth, child: field),
            );
          }).toList(),
        ),
      ),
    );
  }
}
