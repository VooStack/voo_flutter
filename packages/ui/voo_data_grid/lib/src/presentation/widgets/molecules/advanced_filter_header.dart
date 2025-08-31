import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// A molecule component for the advanced filter header
class AdvancedFilterHeader extends StatelessWidget {
  /// The current filter logic (AND/OR)
  final FilterLogic filterLogic;
  
  /// Callback when filter logic changes
  final void Function(FilterLogic) onLogicChanged;
  
  /// Title text
  final String title;
  
  /// Icon to display
  final IconData? icon;
  
  /// Icon color
  final Color? iconColor;
  
  const AdvancedFilterHeader({
    super.key,
    required this.filterLogic,
    required this.onLogicChanged,
    this.title = 'Advanced Filters',
    this.icon = Icons.filter_alt,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = context.vooDesign;
    
    return Row(
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            color: iconColor ?? theme.colorScheme.primary,
          ),
          SizedBox(width: design.spacingSm),
        ],
        Text(
          title,
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
          selected: {filterLogic},
          onSelectionChanged: (value) {
            onLogicChanged(value.first);
          },
        ),
      ],
    );
  }
}