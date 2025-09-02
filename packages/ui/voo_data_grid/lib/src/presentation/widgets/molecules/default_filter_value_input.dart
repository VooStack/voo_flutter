import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/presentation/widgets/atoms/filter_input_decoration.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

/// Default value input widget for filter rows
class DefaultFilterValueInput extends StatelessWidget {
  final FilterEntry filter;
  final void Function(String)? onChanged;
  
  const DefaultFilterValueInput({
    super.key,
    required this.filter,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return TextField(
      decoration: FilterInputDecoration.standard(
        context: context,
        hintText: 'Value...',
      ),
      style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color),
      controller: TextEditingController(text: filter.value?.toString() ?? ''),
      onChanged: onChanged,
    );
  }
}