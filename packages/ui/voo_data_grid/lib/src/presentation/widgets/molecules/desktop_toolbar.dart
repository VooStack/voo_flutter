import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/presentation/widgets/atoms/toolbar_button_atom.dart';
import 'package:voo_data_grid/src/presentation/widgets/atoms/view_mode_toggle_atom.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Desktop toolbar widget for data grid
class DesktopToolbar extends StatelessWidget {
  final VoidCallback? onRefresh;
  final VoidCallback? onFilterToggle;
  final bool filtersVisible;
  final int activeFilterCount;
  final VooDataGridDisplayMode? displayMode;
  final void Function(VooDataGridDisplayMode)? onDisplayModeChanged;
  final bool showViewModeToggle;
  final List<Widget>? additionalActions;
  final Color? backgroundColor;
  final Color? borderColor;

  const DesktopToolbar({
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
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);

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
}