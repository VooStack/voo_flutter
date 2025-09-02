import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

/// Default secondary value input widget for filter range operations
class DefaultFilterSecondaryInput extends StatelessWidget {
  final FilterEntry filter;
  final void Function(String)? onChanged;
  
  const DefaultFilterSecondaryInput({
    super.key,
    required this.filter,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'To',
        border: OutlineInputBorder(),
      ),
      initialValue: filter.secondaryValue?.toString() ?? '',
      onChanged: onChanged,
    );
  }
}