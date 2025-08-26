import 'package:flutter/material.dart';
import 'package:voo_ui_core/voo_ui_core.dart';
import '../models/advanced_filters.dart';
import '../advanced_remote_data_source.dart';

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
          _buildHeader(design),
          SizedBox(height: design.spacingMd),
          _buildFilterList(design),
          SizedBox(height: design.spacingMd),
          _buildActions(design),
        ],
      ),
    );
  }

  Widget _buildHeader(VooDesignSystemData design) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(Icons.filter_alt, color: theme.colorScheme.primary),
        SizedBox(width: design.spacingSm),
        Text(
          'Advanced Filters',
          style: theme.textTheme.titleMedium,
        ),
        const Spacer(),
        SegmentedButton<FilterLogic>(
          segments: const [
            ButtonSegment(
              value: FilterLogic.and,
              label: Text('AND'),
              icon: Icon(Icons.merge_type),
            ),
            ButtonSegment(
              value: FilterLogic.or,
              label: Text('OR'),
              icon: Icon(Icons.alt_route),
            ),
          ],
          selected: {_globalLogic},
          onSelectionChanged: (value) {
            setState(() {
              _globalLogic = value.first;
            });
          },
        ),
      ],
    );
  }

  Widget _buildFilterList(VooDesignSystemData design) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      child: ListView(
        shrinkWrap: true,
        children: [
          ..._filters.map((filter) => _buildFilterRow(filter, design)),
          _buildAddFilterButton(design),
        ],
      ),
    );
  }

  Widget _buildFilterRow(FilterEntry filter, VooDesignSystemData design) {
    return Container(
      margin: EdgeInsets.only(bottom: design.spacingSm),
      padding: EdgeInsets.all(design.spacingSm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(design.radiusSm),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Field selector
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  initialValue: filter.fieldName,
                  decoration: InputDecoration(
                    labelText: 'Field',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: design.spacingSm,
                      vertical: design.spacingXs,
                    ),
                  ),
                  items: widget.fields.map((field) {
                    return DropdownMenuItem(
                      value: field.fieldName,
                      child: Text(field.displayName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      filter.fieldName = value!;
                      final config = widget.fields.firstWhere(
                        (f) => f.fieldName == value,
                      );
                      filter.type = config.type;
                    });
                  },
                ),
              ),
              SizedBox(width: design.spacingXs),
              
              // Operator selector
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: filter.operator,
                  decoration: InputDecoration(
                    labelText: 'Operator',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: design.spacingSm,
                      vertical: design.spacingXs,
                    ),
                  ),
                  items: _getOperatorsForType(filter.type).map((op) {
                    return DropdownMenuItem(
                      value: op,
                      child: Text(_getOperatorDisplayName(op)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      filter.operator = value!;
                    });
                  },
                ),
              ),
              SizedBox(width: design.spacingXs),
              
              // Value input
              Expanded(
                flex: 2,
                child: _buildValueInput(filter, design),
              ),
              SizedBox(width: design.spacingXs),
              
              // Remove button
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                color: Theme.of(context).colorScheme.error,
                onPressed: () {
                  setState(() {
                    _filters.remove(filter);
                  });
                },
              ),
            ],
          ),
          
          // Secondary filter (if enabled)
          if (filter.hasSecondaryFilter)
            Container(
              margin: EdgeInsets.only(top: design.spacingSm),
              padding: EdgeInsets.all(design.spacingXs),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(design.radiusXs),
              ),
              child: Row(
                children: [
                  // Logic selector
                  SegmentedButton<FilterLogic>(
                    segments: const [
                      ButtonSegment(value: FilterLogic.and, label: Text('AND')),
                      ButtonSegment(value: FilterLogic.or, label: Text('OR')),
                    ],
                    selected: {filter.secondaryLogic},
                    onSelectionChanged: (value) {
                      setState(() {
                        filter.secondaryLogic = value.first;
                      });
                    },
                  ),
                  SizedBox(width: design.spacingXs),
                  
                  // Secondary operator
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: filter.secondaryOperator,
                      decoration: InputDecoration(
                        labelText: 'Operator',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: design.spacingSm,
                          vertical: design.spacingXs,
                        ),
                      ),
                      items: _getOperatorsForType(filter.type).map((op) {
                        return DropdownMenuItem(
                          value: op,
                          child: Text(_getOperatorDisplayName(op)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          filter.secondaryOperator = value!;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: design.spacingXs),
                  
                  // Secondary value
                  Expanded(
                    flex: 2,
                    child: _buildSecondaryValueInput(filter, design),
                  ),
                ],
              ),
            ),
          
          // Add secondary filter button
          if (!filter.hasSecondaryFilter)
            TextButton.icon(
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Add Secondary Filter'),
              onPressed: () {
                setState(() {
                  filter.hasSecondaryFilter = true;
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildValueInput(FilterEntry filter, VooDesignSystemData design) {
    switch (filter.type) {
      case FilterType.string:
        return TextFormField(
          initialValue: filter.value?.toString() ?? '',
          decoration: const InputDecoration(labelText: 'Value'),
          onChanged: (value) {
            filter.value = value;
          },
        );
      
      case FilterType.int:
        return TextFormField(
          initialValue: filter.value?.toString() ?? '',
          decoration: const InputDecoration(labelText: 'Value'),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            filter.value = int.tryParse(value) ?? 0;
          },
        );
      
      case FilterType.decimal:
        return TextFormField(
          initialValue: filter.value?.toString() ?? '',
          decoration: const InputDecoration(labelText: 'Value'),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) {
            filter.value = double.tryParse(value) ?? 0.0;
          },
        );
      
      case FilterType.date:
        return InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              setState(() {
                filter.value = date.toIso8601String();
              });
            }
          },
          child: InputDecorator(
            decoration: const InputDecoration(labelText: 'Date'),
            child: Text(
              filter.value?.toString() ?? 'Select date',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        );
    }
  }

  Widget _buildSecondaryValueInput(FilterEntry filter, VooDesignSystemData design) {
    switch (filter.type) {
      case FilterType.string:
        return TextFormField(
          initialValue: filter.secondaryValue?.toString() ?? '',
          decoration: const InputDecoration(labelText: 'Secondary Value'),
          onChanged: (value) {
            filter.secondaryValue = value;
          },
        );
      
      case FilterType.int:
        return TextFormField(
          initialValue: filter.secondaryValue?.toString() ?? '',
          decoration: const InputDecoration(labelText: 'Secondary Value'),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            filter.secondaryValue = int.tryParse(value) ?? 0;
          },
        );
      
      case FilterType.decimal:
        return TextFormField(
          initialValue: filter.secondaryValue?.toString() ?? '',
          decoration: const InputDecoration(labelText: 'Secondary Value'),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) {
            filter.secondaryValue = double.tryParse(value) ?? 0.0;
          },
        );
      
      case FilterType.date:
        return InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              setState(() {
                filter.secondaryValue = date.toIso8601String();
              });
            }
          },
          child: InputDecorator(
            decoration: const InputDecoration(labelText: 'Secondary Date'),
            child: Text(
              filter.secondaryValue?.toString() ?? 'Select date',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        );
    }
  }

  Widget _buildAddFilterButton(VooDesignSystemData design) {
    return OutlinedButton.icon(
      icon: const Icon(Icons.add),
      label: const Text('Add Filter'),
      onPressed: () {
        setState(() {
          _filters.add(FilterEntry(
            fieldName: widget.fields.first.fieldName,
            type: widget.fields.first.type,
            operator: 'Equals',
          ));
        });
      },
    );
  }

  Widget _buildActions(VooDesignSystemData design) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              _filters.clear();
            });
            widget.dataSource.clearAdvancedFilters();
          },
          child: const Text('Clear All'),
        ),
        SizedBox(width: design.spacingSm),
        FilledButton.icon(
          icon: const Icon(Icons.check),
          label: const Text('Apply Filters'),
          onPressed: _applyFilters,
        ),
      ],
    );
  }

  void _applyFilters() {
    final stringFilters = <StringFilter>[];
    final intFilters = <IntFilter>[];
    final dateFilters = <DateFilter>[];
    final decimalFilters = <DecimalFilter>[];

    for (final filter in _filters) {
      SecondaryFilter? secondaryFilter;
      if (filter.hasSecondaryFilter && filter.secondaryValue != null) {
        secondaryFilter = SecondaryFilter(
          logic: filter.secondaryLogic,
          value: filter.secondaryValue,
          operator: filter.secondaryOperator ?? 'Equals',
        );
      }

      switch (filter.type) {
        case FilterType.string:
          stringFilters.add(StringFilter(
            fieldName: filter.fieldName!,
            value: filter.value?.toString() ?? '',
            operator: filter.operator ?? 'Equals',
            secondaryFilter: secondaryFilter,
          ));
          break;
        
        case FilterType.int:
          intFilters.add(IntFilter(
            fieldName: filter.fieldName!,
            value: filter.value as int? ?? 0,
            operator: filter.operator ?? 'Equals',
            secondaryFilter: secondaryFilter,
          ));
          break;
        
        case FilterType.decimal:
          decimalFilters.add(DecimalFilter(
            fieldName: filter.fieldName!,
            value: filter.value as double? ?? 0.0,
            operator: filter.operator ?? 'Equals',
            secondaryFilter: secondaryFilter,
          ));
          break;
        
        case FilterType.date:
          dateFilters.add(DateFilter(
            fieldName: filter.fieldName!,
            value: filter.value?.toString() ?? '',
            operator: filter.operator ?? 'Equals',
            secondaryFilter: secondaryFilter,
          ));
          break;
      }
    }

    final request = AdvancedFilterRequest(
      stringFilters: stringFilters,
      intFilters: intFilters,
      dateFilters: dateFilters,
      decimalFilters: decimalFilters,
      logic: _globalLogic,
      pageNumber: 1,
      pageSize: widget.dataSource.pageSize,
    );

    widget.dataSource.setAdvancedFilterRequest(request);
    widget.onFilterApplied?.call(request);
  }

  List<String> _getOperatorsForType(FilterType type) {
    switch (type) {
      case FilterType.string:
        return ['Equals', 'NotEquals', 'Contains', 'NotContains', 'StartsWith', 'EndsWith'];
      case FilterType.int:
      case FilterType.decimal:
        return ['Equals', 'NotEquals', 'GreaterThan', 'GreaterThanOrEqual', 'LessThan', 'LessThanOrEqual'];
      case FilterType.date:
        return ['Equals', 'NotEquals', 'After', 'AfterOrEqual', 'Before', 'BeforeOrEqual'];
    }
  }

  String _getOperatorDisplayName(String operator) {
    final map = {
      'Equals': '=',
      'NotEquals': '≠',
      'Contains': 'Contains',
      'NotContains': 'Not Contains',
      'StartsWith': 'Starts With',
      'EndsWith': 'Ends With',
      'GreaterThan': '>',
      'GreaterThanOrEqual': '≥',
      'LessThan': '<',
      'LessThanOrEqual': '≤',
      'After': 'After',
      'AfterOrEqual': 'After or Equal',
      'Before': 'Before',
      'BeforeOrEqual': 'Before or Equal',
    };
    return map[operator] ?? operator;
  }
}

/// Configuration for a filterable field
class FilterFieldConfig {
  final String fieldName;
  final String displayName;
  final FilterType type;

  const FilterFieldConfig({
    required this.fieldName,
    required this.displayName,
    required this.type,
  });
}

/// Internal filter entry model
class FilterEntry {
  String? fieldName;
  FilterType type;
  String? operator;
  dynamic value;
  bool hasSecondaryFilter = false;
  FilterLogic secondaryLogic = FilterLogic.and;
  String? secondaryOperator;
  dynamic secondaryValue;

  FilterEntry({
    this.fieldName,
    required this.type,
    this.operator,
    this.value,
  });
}