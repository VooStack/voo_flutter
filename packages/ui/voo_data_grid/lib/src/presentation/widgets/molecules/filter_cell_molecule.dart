import 'package:flutter/material.dart';

import 'package:voo_data_grid/src/domain/entities/data_grid_column.dart';

/// A molecule component that renders a filter cell container
class FilterCellMolecule<T> extends StatelessWidget {
  /// The column configuration
  final VooDataColumn<T> column;
  
  /// The cell width
  final double width;
  
  /// The cell child widget (filter input)
  final Widget child;
  
  /// The grid line color
  final Color gridLineColor;
  
  /// Whether to show grid lines
  final bool showGridLines;
  
  /// The horizontal padding
  final double horizontalPadding;
  
  /// The vertical padding
  final double verticalPadding;

  const FilterCellMolecule({
    super.key,
    required this.column,
    required this.width,
    required this.child,
    required this.gridLineColor,
    required this.showGridLines,
    this.horizontalPadding = 8.0,
    this.verticalPadding = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    // Empty cell for non-filterable or excluded columns
    if (!column.filterable || column.excludeFromApi) {
      return Container(
        width: width,
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: gridLineColor,
              width: showGridLines ? 1 : 0,
            ),
          ),
        ),
      );
    }

    return Container(
      width: width,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: gridLineColor,
            width: showGridLines ? 1 : 0,
          ),
        ),
      ),
      child: child,
    );
  }
}