import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_data_grid/src/domain/entities/data_grid_column.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_filter.dart';
import 'package:voo_data_grid/src/presentation/widgets/atoms/filter_input_decoration.dart';
import 'package:voo_data_grid/src/utils/debouncer.dart';

/// A molecule component for number filter input
class NumberFilter<T> extends StatefulWidget {
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

  const NumberFilter({
    super.key,
    required this.column,
    this.currentFilter,
    required this.onFilterChanged,
    required this.onFilterCleared,
    required this.textControllers,
  });

  @override
  State<NumberFilter<T>> createState() => _NumberFilterState<T>();
}

class _NumberFilterState<T> extends State<NumberFilter<T>> {
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
      if (value.isEmpty) {
        widget.onFilterChanged(null);
      } else {
        final number = num.tryParse(value);
        widget.onFilterChanged(number);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: _controller,
      decoration: FilterInputDecoration.standard(
        context: context,
        hintText: widget.column.filterHint ?? 'Number...',
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
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9.-]')),
      ],
      onChanged: _handleChange,
    );
  }
}