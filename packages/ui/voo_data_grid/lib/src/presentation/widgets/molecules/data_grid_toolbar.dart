import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/desktop_toolbar.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/mobile_toolbar.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

/// A molecule component for the data grid toolbar
class DataGridToolbar extends StatelessWidget {
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
  
  const DataGridToolbar({
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
    if (isMobile) {
      return MobileToolbar(
        onRefresh: onRefresh,
        onFilterToggle: onFilterToggle,
        activeFilterCount: activeFilterCount,
        displayMode: displayMode,
        onDisplayModeChanged: onDisplayModeChanged,
        showViewModeToggle: showViewModeToggle,
        additionalActions: additionalActions,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        onShowMobileFilters: onShowMobileFilters,
      );
    }
    
    return DesktopToolbar(
      onRefresh: onRefresh,
      onFilterToggle: onFilterToggle,
      filtersVisible: filtersVisible,
      activeFilterCount: activeFilterCount,
      displayMode: displayMode,
      onDisplayModeChanged: onDisplayModeChanged,
      showViewModeToggle: showViewModeToggle,
      additionalActions: additionalActions,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
    );
  }
}