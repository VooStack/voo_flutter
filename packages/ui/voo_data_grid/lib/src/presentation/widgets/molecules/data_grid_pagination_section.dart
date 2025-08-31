import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

/// A section widget that displays pagination controls
class DataGridPaginationSection<T> extends StatelessWidget {
  /// The data grid controller
  final VooDataGridController<T> controller;

  /// The theme configuration
  final VooDataGridTheme theme;

  /// The width of the widget
  final double width;

  /// Whether the view is mobile
  final bool isMobile;

  const DataGridPaginationSection({
    super.key,
    required this.controller,
    required this.theme,
    required this.width,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return VooDataGridMobilePagination(
        currentPage: controller.dataSource.currentPage,
        totalPages: controller.dataSource.totalPages,
        pageSize: controller.dataSource.pageSize,
        totalRows: controller.dataSource.totalRows,
        onPageChanged: controller.dataSource.changePage,
        onPageSizeChanged: controller.dataSource.changePageSize,
        theme: theme,
      );
    } else {
      return VooDataGridPagination(
        currentPage: controller.dataSource.currentPage,
        totalPages: controller.dataSource.totalPages,
        pageSize: controller.dataSource.pageSize,
        totalRows: controller.dataSource.totalRows,
        onPageChanged: controller.dataSource.changePage,
        onPageSizeChanged: controller.dataSource.changePageSize,
        theme: theme,
      );
    }
  }
}
