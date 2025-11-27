import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/presentation/widgets/atoms/clear_all_chip.dart';
import 'package:voo_data_grid/src/presentation/widgets/atoms/filter_chip.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/filter_chip_data.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// A molecule component that displays a list of filter chips
class FilterChipList extends StatelessWidget {
  final Map<String, FilterChipData> filters;
  final void Function(String field)? onFilterRemoved;
  final VoidCallback? onClearAll;
  final bool showClearAll;
  final int clearAllThreshold;
  final Color? backgroundColor;
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

    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.vooSpacing.sm),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: Border(bottom: BorderSide(color: borderColor ?? theme.dividerColor, width: 0.5)),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          spacing: context.vooSpacing.xs,
          runSpacing: context.vooSpacing.xs,
          children: [
            ...filters.entries.map(
              (entry) => VooFilterChip(
                label: entry.value.label,
                value: entry.value.displayValue,
                onDeleted: onFilterRemoved != null ? () => onFilterRemoved!(entry.key) : null,
              ),
            ),
            if (showClearAll && filters.length >= clearAllThreshold) ClearAllChip(onPressed: onClearAll),
          ],
        ),
      ),
    );
  }
}
