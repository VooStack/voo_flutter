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
    final theme = Theme.of(context);
    
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'To...',
          hintStyle: TextStyle(fontSize: 12, color: theme.hintColor),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          border: InputBorder.none,
        ),
        style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color),
        controller: TextEditingController(text: filter.secondaryValue?.toString() ?? ''),
        onChanged: onChanged,
      ),
    );
  }
}