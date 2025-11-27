import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/mobile_filter_input.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_tokens/voo_tokens.dart';

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
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(column.label, style: context.vooTypography.labelLarge),
          SizedBox(height: context.vooSpacing.xs),
          MobileFilterInput(
            column: column,
            tempFilters: tempFilters,
            textControllers: textControllers,
            onFilterChanged: onFilterChanged,
          ),
        ],
      );
}
