import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_form_field_widget.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/layouts/voo_grid_form_layout.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/layouts/voo_vertical_form_layout.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/layouts/voo_wrapped_form_layout.dart';
import 'package:voo_responsive/voo_responsive.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Dynamic layout that adapts beautifully to any screen size
/// Uses voo_responsive for consistent breakpoints
class VooDynamicFormLayout extends StatelessWidget {
  final List<VooFormFieldWidget> fields;
  final double? spacing;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;

  const VooDynamicFormLayout({
    super.key,
    required this.fields,
    this.spacing,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
  });

  int _getOptimalColumns(ScreenSize screenSize, int fieldCount) {
    // Mobile: always single column
    if (screenSize == ScreenSize.small || screenSize == ScreenSize.extraSmall) return 1;

    // Only use grid for specific field counts
    if (fieldCount == 4) return 2; // Perfect 2x2 grid
    if (fieldCount == 6) return 2; // 3x2 grid

    // For all other cases, return 0 to indicate wrapped layout should be used
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveHelper.getScreenSize(context);
    final gap = context.vooGap;
    final effectiveSpacing = spacing ?? gap.formFields;
    final fieldCount = fields.length;
    final columns = _getOptimalColumns(screenSize, fieldCount);
    final isMobile = screenSize == ScreenSize.small || screenSize == ScreenSize.extraSmall;

    // Mobile or single column layout
    if (isMobile) {
      return VooVerticalFormLayout(
        fields: fields,
        spacing: effectiveSpacing,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
      );
    }

    // Grid layout for specific field counts
    if (columns > 0) {
      return VooGridFormLayout(
        fields: fields,
        columns: columns,
        spacing: effectiveSpacing,
        horizontalSpacing: effectiveSpacing * 1.2,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
      );
    }

    // Default to wrapped layout for all other cases
    return VooWrappedFormLayout(fields: fields, spacing: effectiveSpacing, runSpacing: effectiveSpacing);
  }
}
