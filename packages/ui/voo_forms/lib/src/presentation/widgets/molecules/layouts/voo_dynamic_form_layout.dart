import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/utils/screen_size.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_form_field_widget.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/layouts/voo_grid_form_layout.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/layouts/voo_vertical_form_layout.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/layouts/voo_wrapped_form_layout.dart';

/// Dynamic layout that adapts beautifully to any screen size
/// Uses VooScreenSize for consistent breakpoints
class VooDynamicFormLayout extends StatelessWidget {
  final List<VooFormFieldWidget> fields;
  final double spacing;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;

  const VooDynamicFormLayout({
    super.key,
    required this.fields,
    this.spacing = 24.0,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
  });

  int _getOptimalColumns(ScreenType screenType, int fieldCount) {
    // Mobile: always single column
    if (screenType == ScreenType.mobile) return 1;

    // Only use grid for specific field counts
    if (fieldCount == 4) return 2; // Perfect 2x2 grid
    if (fieldCount == 6 && screenType != ScreenType.mobile) return 2; // 3x2 grid

    // For all other cases, return 0 to indicate wrapped layout should be used
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final screenType = VooScreenSize.getType(context);
    final fieldCount = fields.length;
    final columns = _getOptimalColumns(screenType, fieldCount);

    // Mobile or single column layout
    if (screenType == ScreenType.mobile) {
      return VooVerticalFormLayout(
        fields: fields,
        spacing: spacing,
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
        spacing: spacing,
        horizontalSpacing: spacing * 1.2,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
      );
    }

    // Default to wrapped layout for all other cases
    return VooWrappedFormLayout(fields: fields, spacing: spacing, runSpacing: spacing);
  }
}
