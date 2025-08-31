import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/presentation/widgets/atoms/toolbar_button_atom.dart';
import 'package:voo_data_grid/src/presentation/widgets/atoms/view_mode_toggle_atom.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Mobile toolbar widget for data grid
class MobileToolbar extends StatelessWidget {
  final VoidCallback? onRefresh;
  final VoidCallback? onFilterToggle;
  final int activeFilterCount;
  final VooDataGridDisplayMode? displayMode;
  final void Function(VooDataGridDisplayMode)? onDisplayModeChanged;
  final bool showViewModeToggle;
  final List<Widget>? additionalActions;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback? onShowMobileFilters;

  const MobileToolbar({
    super.key,
    this.onRefresh,
    this.onFilterToggle,
    this.activeFilterCount = 0,
    this.displayMode,
    this.onDisplayModeChanged,
    this.showViewModeToggle = false,
    this.additionalActions,
    this.backgroundColor,
    this.borderColor,
    this.onShowMobileFilters,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);

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