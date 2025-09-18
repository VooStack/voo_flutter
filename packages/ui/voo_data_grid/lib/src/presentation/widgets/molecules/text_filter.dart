import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/domain/entities/data_grid_column.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_filter.dart';
import 'package:voo_data_grid/src/presentation/widgets/atoms/filter_input_decoration.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/operator_selector.dart';
import 'package:voo_data_grid/src/utils/debouncer.dart';

/// A molecule component for text filter input with operator selector support
class TextFilter<T> extends StatefulWidget {
  /// The column configuration
  final VooDataColumn<T> column;

  /// The current filter value
  final VooDataFilter? currentFilter;

  /// Callback when filter value changes
  final void Function(dynamic) onFilterChanged;

  /// Callback to clear filter
  final void Function() onFilterCleared;

  /// Text controllers map for maintaining state
  final Map<String, TextEditingController> textControllers;

  const TextFilter({
    super.key,
    required this.column,
    this.currentFilter,
    required this.onFilterChanged,
    required this.onFilterCleared,
    required this.textControllers,
  });

  @override
  State<TextFilter<T>> createState() => _TextFilterState<T>();
}

class _TextFilterState<T> extends State<TextFilter<T>> {
  late Debouncer _debouncer;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer();
    _controller = widget.textControllers.putIfAbsent(
      widget.column.field,
      () => TextEditingController(text: widget.currentFilter?.value?.toString() ?? ''),
    );
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  void _handleChange(String value) {
    _debouncer.run(() {
      widget.onFilterChanged(value.isEmpty ? null : value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        if (widget.column.showFilterOperator)
          OperatorSelector<T>(
            column: widget.column,
            currentFilter: widget.currentFilter,
            onOperatorChanged: (operator) {
              // Apply filter with new operator but keep current value
              widget.onFilterChanged({
                'operator': operator,
                'value': widget.currentFilter?.value,
                'valueTo': widget.currentFilter?.valueTo,
              });
            },
          ),
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: FilterInputDecoration.standard(
              context: context,
              hintText: widget.column.filterHint ?? 'Filter...',
              suffixIcon: widget.currentFilter != null
                  ? InkWell(
                      onTap: () {
                        _controller.clear();
                        widget.onFilterCleared();
                      },
                      child: Icon(Icons.clear, size: 16, color: theme.iconTheme.color),
                    )
                  : null,
            ),
            style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color),
            onChanged: _handleChange,
          ),
        ),
      ],
    );
  }
}
