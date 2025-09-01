import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_filter.dart';
import 'package:voo_data_grid/src/presentation/widgets/atoms/primary_filter_button.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/primary_filter.dart';

/// A molecule component that displays a horizontal scrollable list of primary filter buttons
class PrimaryFiltersBar extends StatelessWidget {
  /// List of available primary filters
  final List<PrimaryFilter> filters;
  
  /// Currently selected filter (null means "All" is selected)
  final VooDataFilter? selectedFilter;
  
  /// Callback when a filter is changed - same signature as regular filters
  final void Function(String field, VooDataFilter? filter)? onFilterChanged;
  
  /// Whether to show an "All" option
  final bool showAllOption;
  
  /// Label for the "All" option
  final String allOptionLabel;
  
  /// Icon for the "All" option
  final IconData? allOptionIcon;
  
  const PrimaryFiltersBar({
    super.key,
    required this.filters,
    this.selectedFilter,
    this.onFilterChanged,
    this.showAllOption = true,
    this.allOptionLabel = 'All',
    this.allOptionIcon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.95),
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              if (showAllOption) ...[
                PrimaryFilterButton(
                  label: allOptionLabel,
                  icon: allOptionIcon,
                  isSelected: selectedFilter == null,
                  onPressed: () {
                    // Clear the primary filter
                    if (filters.isNotEmpty) {
                      onFilterChanged?.call(filters.first.field, null);
                    }
                  },
                ),
                const SizedBox(width: 6),
              ],
              ...filters.map((filter) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: PrimaryFilterButton(
                  label: filter.label,
                  icon: filter.icon,
                  count: filter.count,
                  isSelected: selectedFilter == filter.filter,
                  onPressed: () => onFilterChanged?.call(filter.field, filter.filter),
                ),
              ),),
            ],
          ),
        ),
      ),
    );
  }
}