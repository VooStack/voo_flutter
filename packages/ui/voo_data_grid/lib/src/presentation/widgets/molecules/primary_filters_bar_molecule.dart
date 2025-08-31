import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/presentation/widgets/atoms/primary_filter_button_atom.dart';

/// Represents a primary filter option
class PrimaryFilter {
  /// Unique identifier for the filter
  final String id;
  
  /// Display label for the filter
  final String label;
  
  /// Optional icon to display
  final IconData? icon;
  
  /// Optional count/badge value
  final int? count;
  
  /// The filter value to apply when selected
  final dynamic value;
  
  /// Optional custom filter function
  final bool Function(dynamic item)? filterFunction;
  
  const PrimaryFilter({
    required this.id,
    required this.label,
    this.icon,
    this.count,
    this.value,
    this.filterFunction,
  });
}

/// A molecule component that displays a horizontal scrollable list of primary filter buttons
class PrimaryFiltersBarMolecule extends StatelessWidget {
  /// List of available primary filters
  final List<PrimaryFilter> filters;
  
  /// Currently selected filter ID (null means "All" is selected)
  final String? selectedFilterId;
  
  /// Callback when a filter is selected
  final void Function(String? filterId) onFilterSelected;
  
  /// Whether to show an "All" option
  final bool showAllOption;
  
  /// Label for the "All" option
  final String allOptionLabel;
  
  /// Icon for the "All" option
  final IconData? allOptionIcon;
  
  const PrimaryFiltersBarMolecule({
    super.key,
    required this.filters,
    this.selectedFilterId,
    required this.onFilterSelected,
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
                PrimaryFilterButtonAtom(
                  label: allOptionLabel,
                  icon: allOptionIcon,
                  isSelected: selectedFilterId == null,
                  onPressed: () => onFilterSelected(null),
                ),
                const SizedBox(width: 6),
              ],
              ...filters.map((filter) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: PrimaryFilterButtonAtom(
                  label: filter.label,
                  icon: filter.icon,
                  count: filter.count,
                  isSelected: selectedFilterId == filter.id,
                  onPressed: () => onFilterSelected(filter.id),
                ),
              ),),
            ],
          ),
        ),
      ),
    );
  }
}