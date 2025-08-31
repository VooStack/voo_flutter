import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/presentation/widgets/atoms/toolbar_button_atom.dart';
import 'package:voo_data_grid/src/presentation/widgets/atoms/view_mode_toggle_atom.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// A molecule component for the data grid toolbar
class DataGridToolbarMolecule extends StatelessWidget {
  /// Callback for refresh action
  final VoidCallback? onRefresh;
  
  /// Callback for filter toggle
  final VoidCallback? onFilterToggle;
  
  /// Whether filters are currently shown
  final bool filtersVisible;
  
  /// Number of active filters
  final int activeFilterCount;
  
  /// Current display mode
  final VooDataGridDisplayMode? displayMode;
  
  /// Callback when display mode changes
  final void Function(VooDataGridDisplayMode)? onDisplayModeChanged;
  
  /// Whether to show view mode toggle
  final bool showViewModeToggle;
  
  /// Additional action widgets
  final List<Widget>? additionalActions;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Border color
  final Color? borderColor;
  
  /// Whether this is mobile layout
  final bool isMobile;
  
  /// Callback to show mobile filter sheet
  final VoidCallback? onShowMobileFilters;
  
  const DataGridToolbarMolecule({
    super.key,
    this.onRefresh,
    this.onFilterToggle,
    this.filtersVisible = false,
    this.activeFilterCount = 0,
    this.displayMode,
    this.onDisplayModeChanged,
    this.showViewModeToggle = false,
    this.additionalActions,
    this.backgroundColor,
    this.borderColor,
    this.isMobile = false,
    this.onShowMobileFilters,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);
    
    if (isMobile) {
      return _buildMobileToolbar(context, design, theme);
    }
    
    return _buildDesktopToolbar(context, design, theme);
  }
  
  Widget _buildDesktopToolbar(
    BuildContext context,
    VooDesignSystemData design,
    ThemeData theme,
  ) {
    return Container(
      height: 48,
      padding: EdgeInsets.symmetric(horizontal: design.spacingMd),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: borderColor ?? theme.dividerColor,
          ),
        ),
      ),
      child: Row(
        children: [
          ToolbarButtonAtom(
            icon: Icons.refresh,
            onPressed: onRefresh,
            tooltip: 'Refresh',
          ),
          ToolbarButtonAtom(
            icon: filtersVisible 
                ? Icons.filter_alt 
                : Icons.filter_alt_outlined,
            onPressed: onFilterToggle,
            tooltip: 'Toggle Filters',
            isActive: filtersVisible,
            badgeCount: activeFilterCount > 0 ? activeFilterCount : null,
          ),
          if (showViewModeToggle && displayMode != null)
            ViewModeToggleAtom(
              currentMode: displayMode!,
              onModeChanged: onDisplayModeChanged,
            ),
          const Spacer(),
          if (additionalActions != null)
            ...additionalActions!,
        ],
      ),
    );
  }
  
  Widget _buildMobileToolbar(
    BuildContext context,
    VooDesignSystemData design,
    ThemeData theme,
  ) {
    return Container(
      padding: EdgeInsets.all(design.spacingSm),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: borderColor ?? theme.dividerColor,
          ),
        ),
      ),
      child: Row(
        children: [
          ToolbarButtonAtom(
            icon: Icons.refresh,
            onPressed: onRefresh,
            tooltip: 'Refresh',
          ),
          ToolbarButtonAtom(
            icon: activeFilterCount > 0
                ? Icons.filter_alt
                : Icons.filter_alt_outlined,
            onPressed: onShowMobileFilters ?? onFilterToggle,
            tooltip: 'Filters',
            isActive: activeFilterCount > 0,
            badgeCount: activeFilterCount > 0 ? activeFilterCount : null,
          ),
          if (showViewModeToggle && displayMode != null)
            ViewModeToggleAtom(
              currentMode: displayMode!,
              onModeChanged: onDisplayModeChanged,
            ),
          const Spacer(),
          if (additionalActions != null && additionalActions!.isNotEmpty)
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => additionalActions!
                  .map((action) => PopupMenuItem<Widget>(
                        child: action,
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }
}