import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/advanced_remote_data_source.dart';
import 'package:voo_data_grid/src/models/advanced_filters.dart';
import 'package:voo_data_grid/src/models/filter_type_extensions.dart';
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
    final theme = Theme.of(context);
    
    return Card(
      margin: EdgeInsets.only(bottom: design.spacingSm),
      child: Padding(
        padding: EdgeInsets.all(design.spacingSm),
        child: Row(
          children: [
            // Field selector
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<FilterFieldConfig>(
                decoration: InputDecoration(
                  labelText: 'Field',
                  border: const OutlineInputBorder(),
                  prefixIcon: Icon(filter.field?.type.icon),
                ),
                initialValue: filter.field,
                items: widget.fields.map((field) {
                  return DropdownMenuItem(
                    value: field,
                    child: Text(field.displayName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    filter.field = value;
                    filter.operator = value?.type.defaultOperator;
                    filter.value = null;
                    filter.secondaryValue = null;
                  });
                },
              ),
            ),
            SizedBox(width: design.spacingSm),
            
            // Operator selector
            if (filter.field != null) ...[
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Operator',
                    border: OutlineInputBorder(),
                  ),
                  initialValue: filter.operator,
                  items: filter.field!.type.operators.map((op) {
                    return DropdownMenuItem(
                      value: op,
                      child: Text(op.displayText),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      filter.operator = value;
                      if (value != null && !value.requiresSecondaryValue) {
                        filter.secondaryValue = null;
                      }
                    });
                  },
                ),
              ),
              SizedBox(width: design.spacingSm),
            ],
            
            // Value input
            if (filter.field != null && filter.operator != null) ...[
              Expanded(
                flex: 3,
                child: _buildValueInput(filter, design),
              ),
              SizedBox(width: design.spacingSm),
            ],
            
            // Secondary value for range operations
            if (filter.operator?.requiresSecondaryValue == true) ...[
              Expanded(
                flex: 3,
                child: _buildSecondaryValueInput(filter, design),
              ),
              SizedBox(width: design.spacingSm),
            ],
            
            // Remove button
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              color: theme.colorScheme.error,
              onPressed: () {
                setState(() {
                  _filters.remove(filter);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueInput(FilterEntry filter, VooDesignSystemData design) {
    final type = filter.field!.type;
    
    switch (type.inputType) {
      case FilterInputType.text:
        return TextFormField(
          decoration: const InputDecoration(
            labelText: 'Value',
            border: OutlineInputBorder(),
          ),
          initialValue: filter.value?.toString(),
          onChanged: (value) {
            filter.value = value;
          },
        );
        
      case FilterInputType.number:
        return TextFormField(
          decoration: const InputDecoration(
            labelText: 'Value',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          initialValue: filter.value?.toString(),
          onChanged: (value) {
            filter.value = int.tryParse(value);
          },
        );
        
      case FilterInputType.decimal:
        return TextFormField(
          decoration: const InputDecoration(
            labelText: 'Value',
            border: OutlineInputBorder(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          initialValue: filter.value?.toString(),
          onChanged: (value) {
            filter.value = double.tryParse(value);
          },
        );
        
      case FilterInputType.datePicker:
        return InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: filter.value as DateTime? ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              setState(() {
                filter.value = date;
              });
            }
          },
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Date',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            child: Text(
              filter.value != null 
                ? type.formatValue(filter.value)
                : 'Select date',
            ),
          ),
        );
        
      case FilterInputType.dateTimePicker:
        return InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: filter.value as DateTime? ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (date != null && mounted) {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(
                  filter.value as DateTime? ?? DateTime.now(),
                ),
              );
              if (time != null) {
                setState(() {
                  filter.value = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    time.hour,
                    time.minute,
                  );
                });
              }
            }
          },
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Date & Time',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.access_time),
            ),
            child: Text(
              filter.value != null 
                ? type.formatValue(filter.value)
                : 'Select date & time',
            ),
          ),
        );
        
      case FilterInputType.checkbox:
        return DropdownButtonFormField<bool>(
          decoration: const InputDecoration(
            labelText: 'Value',
            border: OutlineInputBorder(),
          ),
          initialValue: filter.value as bool?,
          items: const [
            DropdownMenuItem(value: true, child: Text('Yes')),
            DropdownMenuItem(value: false, child: Text('No')),
          ],
          onChanged: (value) {
            setState(() {
              filter.value = value;
            });
          },
        );
        
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSecondaryValueInput(FilterEntry filter, VooDesignSystemData design) {
    final type = filter.field!.type;
    
    switch (type.inputType) {
      case FilterInputType.number:
        return TextFormField(
          decoration: const InputDecoration(
            labelText: 'To',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          initialValue: filter.secondaryValue?.toString(),
          onChanged: (value) {
            filter.secondaryValue = int.tryParse(value);
          },
        );
        
      case FilterInputType.decimal:
        return TextFormField(
          decoration: const InputDecoration(
            labelText: 'To',
            border: OutlineInputBorder(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          initialValue: filter.secondaryValue?.toString(),
          onChanged: (value) {
            filter.secondaryValue = double.tryParse(value);
          },
        );
        
      case FilterInputType.datePicker:
        return InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: filter.secondaryValue as DateTime? ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              setState(() {
                filter.secondaryValue = date;
              });
            }
          },
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'To Date',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            child: Text(
              filter.secondaryValue != null 
                ? type.formatValue(filter.secondaryValue)
                : 'Select end date',
            ),
          ),
        );
        
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildAddFilterButton(VooDesignSystemData design) {
    return TextButton.icon(
      icon: const Icon(Icons.add_circle_outline),
      label: const Text('Add Filter'),
      onPressed: () {
        setState(() {
          _filters.add(FilterEntry());
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
          icon: const Icon(Icons.search),
          label: const Text('Apply Filters'),
          onPressed: _applyFilters,
        ),
      ],
    );
  }

  void _applyFilters() {
    final stringFilters = <StringFilter>[];
    final intFilters = <IntFilter>[];
    final decimalFilters = <DecimalFilter>[];
    final dateFilters = <DateFilter>[];
    final boolFilters = <BoolFilter>[];
    
    for (final filter in _filters) {
      if (filter.field == null || 
          filter.operator == null || 
          filter.value == null) {
        continue;
      }
      
      final field = filter.field!;
      SecondaryFilter? secondaryFilter;
      
      if (filter.operator!.requiresSecondaryValue && 
          filter.secondaryValue != null) {
        secondaryFilter = SecondaryFilter(
          logic: FilterLogic.and,
          value: filter.secondaryValue,
          operator: 'LessThanOrEqual',
        );
      }
      
      switch (field.type) {
        case FilterType.string:
          stringFilters.add(StringFilter(
            fieldName: field.fieldName,
            value: filter.value.toString(),
            operator: filter.operator!,
            secondaryFilter: secondaryFilter,
          ));
          break;
          
        case FilterType.int:
          intFilters.add(IntFilter(
            fieldName: field.fieldName,
            value: filter.value as int,
            operator: filter.operator!,
            secondaryFilter: secondaryFilter,
          ));
          break;
          
        case FilterType.decimal:
          decimalFilters.add(DecimalFilter(
            fieldName: field.fieldName,
            value: (filter.value as num).toDouble(),
            operator: filter.operator!,
            secondaryFilter: secondaryFilter,
          ));
          break;
          
        case FilterType.date:
        case FilterType.dateTime:
          dateFilters.add(DateFilter(
            fieldName: field.fieldName,
            value: filter.value as DateTime,
            operator: filter.operator!,
            secondaryFilter: secondaryFilter,
          ));
          break;
          
        case FilterType.bool:
          boolFilters.add(BoolFilter(
            fieldName: field.fieldName,
            value: filter.value as bool,
            operator: filter.operator!,
          ));
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
      pageNumber: 1,
      pageSize: 20,
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
  
  const FilterFieldConfig({
    required this.fieldName,
    required this.displayName,
    required this.type,
    this.options,
  });
}

/// Internal filter entry model
class FilterEntry {
  FilterFieldConfig? field;
  String? operator;
  dynamic value;
  dynamic secondaryValue; // For range operations
  
  FilterEntry({
    this.field,
    this.operator,
    this.value,
    this.secondaryValue,
  });
}