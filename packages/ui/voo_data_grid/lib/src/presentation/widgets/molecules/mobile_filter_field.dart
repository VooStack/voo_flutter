import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/mobile_filter_input.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Individual mobile filter field widget
class MobileFilterField extends StatelessWidget {
  final VooDataColumn column;
  final Map<String, dynamic> tempFilters;
  final Map<String, TextEditingController> textControllers;
  final void Function(String field, dynamic value) onFilterChanged;

  const MobileFilterField({
    super.key,
    required this.column,
    required this.tempFilters,
    required this.textControllers,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          column.label,
          style: theme.textTheme.labelLarge,
        ),
        SizedBox(height: design.spacingXs),
        MobileFilterInput(
          column: column,
          tempFilters: tempFilters,
          textControllers: textControllers,
          onFilterChanged: onFilterChanged,
        ),
      ],
    );
  }
}
