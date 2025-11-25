import 'package:flutter/material.dart';
import 'package:voo_devtools_extension/core/utils/debouncer.dart';
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
class UniversalFilterBar extends StatefulWidget {
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

  /// Debounce delay for search input in milliseconds
  final int searchDebounceMs;

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
    this.searchDebounceMs = 300,
  });

  @override
  State<UniversalFilterBar> createState() => _UniversalFilterBarState();
}

class _UniversalFilterBarState extends State<UniversalFilterBar> {
  late final Debouncer _searchDebouncer;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchDebouncer = Debouncer(
      delay: Duration(milliseconds: widget.searchDebounceMs),
    );
    _searchController = TextEditingController(text: widget.searchQuery);
  }

  @override
  void didUpdateWidget(UniversalFilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the controller if the external search query changed
    if (widget.searchQuery != oldWidget.searchQuery &&
        widget.searchQuery != _searchController.text) {
      _searchController.text = widget.searchQuery ?? '';
    }
  }

  @override
  void dispose() {
    _searchDebouncer.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebouncer.call(() {
      widget.onSearchChanged(value.isEmpty ? null : value);
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _searchDebouncer.cancel();
    widget.onSearchChanged(null);
  }

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
          if (widget.showSearch) ...[
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
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: widget.searchHint,
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
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              size: 16,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            onPressed: _clearSearch,
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
          if (widget.showFilters && widget.filterOptions.isNotEmpty) ...[
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
                      isSelected: widget.selectedFilter == null,
                      onSelected: (_) => widget.onFilterChanged(null),
                    ),
                    ...widget.filterOptions.map(
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
                          isSelected: widget.selectedFilter == option.value,
                          onSelected: (_) => widget.onFilterChanged(option.value),
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
          ...widget.additionalActions.map(
            (action) => Padding(
              padding: const EdgeInsets.only(left: AppTheme.spacingSm),
              child: action,
            ),
          ),

          // Clear button
          if (widget.onClear != null) ...[
            const SizedBox(width: AppTheme.spacingSm),
            IconButton(
              icon: const Icon(Icons.clear_all, size: 20),
              onPressed: widget.onClear,
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
