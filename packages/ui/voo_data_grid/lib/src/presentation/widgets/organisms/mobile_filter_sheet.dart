import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/mobile_filter_field.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Mobile filter sheet widget for filtering data on mobile devices
class MobileFilterSheet extends StatefulWidget {
  final VooDataGridController controller;
  final VooDataGridTheme theme;
  final VoidCallback onApply;

  const MobileFilterSheet({
    super.key,
    required this.controller,
    required this.theme,
    required this.onApply,
  });

  @override
  State<MobileFilterSheet> createState() => _MobileFilterSheetState();
}

class _MobileFilterSheetState extends State<MobileFilterSheet> {
  final Map<String, TextEditingController> _textControllers = {};
  final Map<String, dynamic> _tempFilters = {};

  @override
  void initState() {
    super.initState();
    for (final entry in widget.controller.dataSource.filters.entries) {
      _tempFilters[entry.key] = entry.value.value;
    }
  }

  @override
  void dispose() {
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filterableColumns = widget.controller.columns.where((col) => col.filterable).toList();
    final activeFilterCount = _tempFilters.values.where((v) => v != null).length;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: context.vooSpacing.md),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          _buildHeader(context, theme, activeFilterCount),
          const Divider(height: 1),
          // Filter list
          Expanded(
            child: ListView.separated(
              controller: scrollController,
              padding: EdgeInsets.all(context.vooSpacing.lg),
              itemCount: filterableColumns.length,
              separatorBuilder: (context, index) => SizedBox(height: context.vooSpacing.md),
              itemBuilder: (context, index) {
                final column = filterableColumns[index];
                return MobileFilterField(
                  column: column,
                  tempFilters: _tempFilters,
                  textControllers: _textControllers,
                  onFilterChanged: (field, value) => setState(() => _tempFilters[field] = value),
                );
              },
            ),
          ),
          // Bottom buttons
          _buildBottomBar(context, theme),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, int activeFilterCount) => Padding(
        padding: EdgeInsets.all(context.vooSpacing.lg),
        child: Row(
          children: [
            Text('Filters', style: context.vooTypography.titleMedium),
            if (activeFilterCount > 0) ...[
              SizedBox(width: context.vooSpacing.sm),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.vooSpacing.sm,
                  vertical: context.vooSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(context.vooRadius.sm),
                ),
                child: Text(
                  '$activeFilterCount active',
                  style: context.vooTypography.labelSmall.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
            const Spacer(),
            if (activeFilterCount > 0)
              TextButton(
                onPressed: () {
                  setState(() {
                    _tempFilters.clear();
                    for (final controller in _textControllers.values) {
                      controller.clear();
                    }
                  });
                },
                child: const Text('Clear All'),
              ),
          ],
        ),
      );

  Widget _buildBottomBar(BuildContext context, ThemeData theme) => Container(
        padding: EdgeInsets.all(context.vooSpacing.lg),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
          ),
        ),
        child: FilledButton.tonal(
          onPressed: _applyFilters,
          child: const Text('Apply Filters'),
        ),
      );

  void _applyFilters() {
    for (final entry in _tempFilters.entries) {
      final column = widget.controller.columns.firstWhere((col) => col.field == entry.key);
      if (entry.value != null) {
        widget.controller.dataSource.applyFilter(
          entry.key,
          VooDataFilter(
            value: entry.value,
            operator: VooFilterOperator.equals,
            odataCollectionProperty: column.odataCollectionProperty,
          ),
        );
      } else {
        widget.controller.dataSource.applyFilter(entry.key, null);
      }
    }

    final tempKeys = _tempFilters.keys.toSet();
    for (final existingKey in widget.controller.dataSource.filters.keys) {
      if (!tempKeys.contains(existingKey)) {
        widget.controller.dataSource.applyFilter(existingKey, null);
      }
    }

    widget.onApply();
  }
}
