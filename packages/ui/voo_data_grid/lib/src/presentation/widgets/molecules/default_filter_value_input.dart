import 'package:flutter/material.dart';
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
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Value',
        border: OutlineInputBorder(),
      ),
      initialValue: filter.value?.toString() ?? '',
      onChanged: onChanged,
    );
  }
}