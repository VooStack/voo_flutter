import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

/// An atomic view mode toggle button for switching between table and card views
class ViewModeToggleAtom extends StatelessWidget {
  /// Current display mode
  final VooDataGridDisplayMode currentMode;
  
  /// Callback when mode changes
  final void Function(VooDataGridDisplayMode mode)? onModeChanged;
  
  /// Tooltip for table view
  final String tableTooltip;
  
  /// Tooltip for card view
  final String cardTooltip;
  
  const ViewModeToggleAtom({
    super.key,
    required this.currentMode,
    this.onModeChanged,
    this.tableTooltip = 'Switch to Table View',
    this.cardTooltip = 'Switch to Card View',
  });

  @override
  Widget build(BuildContext context) {
    final isTableMode = currentMode == VooDataGridDisplayMode.table;
    
    return IconButton(
      icon: Icon(
        isTableMode ? Icons.view_agenda : Icons.table_chart,
      ),
      onPressed: onModeChanged != null 
          ? () => onModeChanged!(
              isTableMode 
                  ? VooDataGridDisplayMode.cards 
                  : VooDataGridDisplayMode.table,
            )
          : null,
      tooltip: isTableMode ? cardTooltip : tableTooltip,
    );
  }
}