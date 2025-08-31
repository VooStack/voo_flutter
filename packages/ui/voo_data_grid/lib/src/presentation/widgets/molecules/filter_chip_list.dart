import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/presentation/widgets/atoms/clear_all_chip.dart';
import 'package:voo_data_grid/src/presentation/widgets/atoms/filter_chip.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/filter_chip_data.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// A molecule component that displays a list of filter chips
class FilterChipList extends StatelessWidget {
  /// Map of filters where key is field name and value is the filter data
  final Map<String, FilterChipData> filters;

  /// Callback when a filter is removed
  final void Function(String field)? onFilterRemoved;

  /// Callback when all filters are cleared
  final VoidCallback? onClearAll;

  /// Whether to show the clear all button
  final bool showClearAll;

  /// Minimum number of filters before showing clear all
  final int clearAllThreshold;

  /// Background color for the container
  final Color? backgroundColor;

  /// Border color
  final Color? borderColor;

  const FilterChipList({
    super.key,
    required this.filters,
    this.onFilterRemoved,
    this.onClearAll,
    this.showClearAll = true,
    this.clearAllThreshold = 2,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    if (filters.isEmpty) return const SizedBox.shrink();

    final design = context.vooDesign;
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(design.spacingSm),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(
            color: borderColor ?? theme.dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          spacing: design.spacingXs,
          runSpacing: design.spacingXs,
          children: [
            ...filters.entries.map(
              (entry) => VooFilterChip(
                label: entry.value.label,
                value: entry.value.displayValue,
                onDeleted: onFilterRemoved != null ? () => onFilterRemoved!(entry.key) : null,
              ),
            ),
            if (showClearAll && filters.length >= clearAllThreshold)
              ClearAllChip(
                onPressed: onClearAll,
              ),
          ],
        ),
      ),
    );
  }
}