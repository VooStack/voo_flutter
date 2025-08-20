import 'package:flutter/material.dart';

class SearchFilterBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onSearchChanged;
  final List<FilterChipData> filters;
  final VoidCallback? onClearAll;

  const SearchFilterBar({
    super.key,
    this.hintText = 'Search...',
    this.onSearchChanged,
    this.filters = const [],
    this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Search field
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                onChanged: onSearchChanged,
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Filter chips
          if (filters.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              children: filters.map((filter) {
                return FilterChip(
                  label: Text(filter.label),
                  selected: filter.isSelected,
                  onSelected: filter.onSelected,
                  avatar: filter.icon != null
                      ? Icon(filter.icon, size: 16)
                      : null,
                  showCheckmark: false,
                  side: BorderSide(
                    color: filter.isSelected
                        ? colorScheme.primary
                        : colorScheme.outlineVariant,
                  ),
                  backgroundColor: colorScheme.surface,
                  selectedColor: colorScheme.primaryContainer,
                  labelStyle: theme.textTheme.labelMedium,
                );
              }).toList(),
            ),
            const SizedBox(width: 8),
          ],
          // Clear all button
          if (onClearAll != null)
            TextButton.icon(
              onPressed: onClearAll,
              icon: const Icon(Icons.clear, size: 18),
              label: const Text('Clear'),
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}

class FilterChipData {
  final String label;
  final bool isSelected;
  final ValueChanged<bool>? onSelected;
  final IconData? icon;

  const FilterChipData({
    required this.label,
    required this.isSelected,
    this.onSelected,
    this.icon,
  });
}