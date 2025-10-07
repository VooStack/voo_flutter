import 'package:flutter/material.dart';
import 'package:voo_devtools_extension/presentation/theme/app_theme.dart';

/// Configuration for a filter option
class FilterOption {
  final String label;
  final String value;
  final IconData? icon;
  final Color? color;

  const FilterOption({
    required this.label,
    required this.value,
    this.icon,
    this.color,
  });
}

/// Universal filter bar that can be configured for different tabs
class UniversalFilterBar extends StatelessWidget {
  final String searchHint;
  final String? searchQuery;
  final ValueChanged<String?> onSearchChanged;
  final List<FilterOption> filterOptions;
  final String? selectedFilter;
  final ValueChanged<String?> onFilterChanged;
  final List<Widget> additionalActions;
  final VoidCallback? onClear;
  final bool showSearch;
  final bool showFilters;

  const UniversalFilterBar({
    super.key,
    this.searchHint = 'Search...',
    this.searchQuery,
    required this.onSearchChanged,
    this.filterOptions = const [],
    this.selectedFilter,
    required this.onFilterChanged,
    this.additionalActions = const [],
    this.onClear,
    this.showSearch = true,
    this.showFilters = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Search field
          if (showSearch) ...[
            Expanded(
              flex: 2,
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: TextField(
                  onChanged: onSearchChanged,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: searchHint,
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.5,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 18,
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.5,
                      ),
                    ),
                    suffixIcon: searchQuery?.isNotEmpty == true
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              size: 16,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            onPressed: () => onSearchChanged(null),
                            splashRadius: 16,
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMd,
                      vertical: AppTheme.spacingSm,
                    ),
                    isDense: true,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppTheme.spacingMd),
          ],

          // Filter chips
          if (showFilters && filterOptions.isNotEmpty) ...[
            Expanded(
              flex: 3,
              child: SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildFilterChip(
                      context,
                      label: 'All',
                      value: null,
                      isSelected: selectedFilter == null,
                      onSelected: (_) => onFilterChanged(null),
                    ),
                    ...filterOptions.map(
                      (option) => Padding(
                        padding: const EdgeInsets.only(
                          left: AppTheme.spacingSm,
                        ),
                        child: _buildFilterChip(
                          context,
                          label: option.label,
                          value: option.value,
                          icon: option.icon,
                          color: option.color,
                          isSelected: selectedFilter == option.value,
                          onSelected: (_) => onFilterChanged(option.value),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppTheme.spacingMd),
          ],

          // Additional actions
          ...additionalActions.map(
            (action) => Padding(
              padding: const EdgeInsets.only(left: AppTheme.spacingSm),
              child: action,
            ),
          ),

          // Clear button
          if (onClear != null) ...[
            const SizedBox(width: AppTheme.spacingSm),
            IconButton(
              icon: const Icon(Icons.clear_all, size: 20),
              onPressed: onClear,
              tooltip: 'Clear all',
              splashRadius: 20,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required String? value,
    IconData? icon,
    Color? color,
    required bool isSelected,
    required ValueChanged<bool> onSelected,
  }) {
    final theme = Theme.of(context);
    final chipColor = color ?? theme.colorScheme.primary;

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 14,
              color: isSelected
                  ? chipColor
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: isSelected
                  ? chipColor
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: chipColor.withValues(alpha: 0.15),
      backgroundColor: theme.colorScheme.surface,
      side: BorderSide(
        color: isSelected
            ? chipColor.withValues(alpha: 0.5)
            : theme.colorScheme.outline.withValues(alpha: 0.3),
        width: isSelected ? 1.5 : 1,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSm,
        vertical: 2,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}
