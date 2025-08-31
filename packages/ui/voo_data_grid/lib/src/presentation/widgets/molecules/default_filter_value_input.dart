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
    final theme = Theme.of(context);
    
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Filter...',
          hintStyle: TextStyle(fontSize: 12, color: theme.hintColor),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          border: InputBorder.none,
        ),
        style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color),
        onChanged: onChanged,
      ),
    );
  }
}