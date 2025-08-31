import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/advanced_filter_header_molecule.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/advanced_filter_row.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Advanced filter widget for complex filtering UI
class AdvancedFilterWidget extends StatefulWidget {
  final AdvancedRemoteDataSource dataSource;
  final void Function(AdvancedFilterRequest)? onFilterApplied;
  final List<FilterFieldConfig> fields;

  const AdvancedFilterWidget({
    super.key,
    required this.dataSource,
    required this.fields,
    this.onFilterApplied,
  });

  @override
  State<AdvancedFilterWidget> createState() => _AdvancedFilterWidgetState();
}

class _AdvancedFilterWidgetState extends State<AdvancedFilterWidget> {
  final List<FilterEntry> _filters = [];
  FilterLogic _globalLogic = FilterLogic.and;

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(design.spacingMd),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(design.radiusMd),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with logic toggle
          AdvancedFilterHeaderMolecule(
            filterLogic: _globalLogic,
            onLogicChanged: (logic) {
              setState(() {
                _globalLogic = logic;
              });
            },
          ),
          SizedBox(height: design.spacingMd),
          // Filter list
          Container(
            constraints: const BoxConstraints(maxHeight: 300),
            child: ListView(
              shrinkWrap: true,
              children: [
                ..._filters.map((filter) => Padding(
                  padding: EdgeInsets.only(bottom: design.spacingSm),
                  child: AdvancedFilterRow(
                    filter: filter,
                    fields: widget.fields,
                    onFieldChanged: (field) {
                      setState(() {
                        filter.field = field;
                        filter.value = null;
                        filter.secondaryValue = null;
                        filter.operator = field?.defaultOperator ?? 'equals';
                      });
                    },
                    onOperatorChanged: (operator) {
                      setState(() {
                        filter.operator = operator;
                        if (operator != null && !operator.requiresSecondaryValue) {
                          filter.secondaryValue = null;
                        }
                      });
                    },
                    onValueChanged: (value) {
                      setState(() {
                        filter.value = value;
                      });
                    },
                    onSecondaryValueChanged: (value) {
                      setState(() {
                        filter.secondaryValue = value;
                      });
                    },
                    onRemove: () {
                      setState(() {
                        _filters.remove(filter);
                      });
                    },
                  ),
                )),
                // Add filter button
                TextButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Filter'),
                  onPressed: () {
                    setState(() {
                      _filters.add(FilterEntry(
                        field: widget.fields.first,
                        operator: widget.fields.first.defaultOperator ?? 'equals',
                        logic: FilterLogic.and,
                      ));
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: design.spacingMd),
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _filters.clear();
                  });
                  widget.dataSource.clearFilters();
                },
                child: const Text('Clear All'),
              ),
              SizedBox(width: design.spacingSm),
              FilledButton(
                onPressed: _applyFilters,
                child: const Text('Apply Filters'),
              ),
            ],
          ),
        ],
      ),
    );
  }


  void _applyFilters() {
    final stringFilters = <StringFilter>[];
    final intFilters = <IntFilter>[];
    final decimalFilters = <DecimalFilter>[];
    final dateFilters = <DateFilter>[];
    final boolFilters = <BoolFilter>[];

    for (final filter in _filters) {
      if (filter.field == null || filter.operator == null || filter.value == null) {
        continue;
      }

      final field = filter.field!;
      SecondaryFilter? secondaryFilter;

      if (filter.operator!.requiresSecondaryValue && filter.secondaryValue != null) {
        secondaryFilter = SecondaryFilter(
          logic: FilterLogic.and,
          value: filter.secondaryValue,
          operator: 'LessThanOrEqual',
        );
      }

      switch (field.type) {
        case FilterType.string:
          stringFilters.add(
            StringFilter(
              fieldName: field.fieldName,
              value: filter.value.toString(),
              operator: filter.operator!,
              secondaryFilter: secondaryFilter,
            ),
          );
          break;

        case FilterType.int:
          intFilters.add(
            IntFilter(
              fieldName: field.fieldName,
              value: filter.value as int,
              operator: filter.operator!,
              secondaryFilter: secondaryFilter,
            ),
          );
          break;

        case FilterType.decimal:
          decimalFilters.add(
            DecimalFilter(
              fieldName: field.fieldName,
              value: (filter.value as num).toDouble(),
              operator: filter.operator!,
              secondaryFilter: secondaryFilter,
            ),
          );
          break;

        case FilterType.date:
        case FilterType.dateTime:
          dateFilters.add(
            DateFilter(
              fieldName: field.fieldName,
              value: filter.value as DateTime,
              operator: filter.operator!,
              secondaryFilter: secondaryFilter,
            ),
          );
          break;

        case FilterType.bool:
          boolFilters.add(
            BoolFilter(
              fieldName: field.fieldName,
              value: filter.value as bool,
              operator: filter.operator!,
            ),
          );
          break;
      }
    }

    final request = AdvancedFilterRequest(
      stringFilters: stringFilters,
      intFilters: intFilters,
      decimalFilters: decimalFilters,
      dateFilters: dateFilters,
      boolFilters: boolFilters,
      logic: _globalLogic,
    );

    widget.dataSource.setAdvancedFilterRequest(request);
    widget.onFilterApplied?.call(request);
  }
}

/// Filter field configuration
class FilterFieldConfig {
  final String fieldName;
  final String displayName;
  final FilterType type;
  final List<String>? options; // For dropdown fields
  final String? defaultOperator;

  const FilterFieldConfig({
    required this.fieldName,
    required this.displayName,
    required this.type,
    this.options,
    this.defaultOperator,
  });
}

/// Internal filter entry model
class FilterEntry {
  FilterFieldConfig? field;
  String? operator;
  dynamic value;
  dynamic secondaryValue; // For range operations
  FilterLogic logic;

  FilterEntry({
    this.field,
    this.operator,
    this.value,
    this.secondaryValue,
    this.logic = FilterLogic.and,
  });
}
