import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/presentation/widgets/atoms/page_info_display.dart';
import 'package:voo_data_grid/src/presentation/widgets/atoms/page_input_field.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Mobile-optimized pagination controls for VooDataGrid
class VooDataGridMobilePagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int pageSize;
  final int totalRows;
  final void Function(int page) onPageChanged;
  final void Function(int pageSize) onPageSizeChanged;
  final VooDataGridTheme theme;
  final List<int> pageSizeOptions;

  const VooDataGridMobilePagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.totalRows,
    required this.onPageChanged,
    required this.onPageSizeChanged,
    required this.theme,
    this.pageSizeOptions = const [10, 20, 50, 100],
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(context.vooSpacing.md),
        decoration: BoxDecoration(
          color: theme.headerBackgroundColor,
          border: Border(
            top: BorderSide(color: theme.borderColor, width: theme.borderWidth),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PageInfoDisplay(currentPage: currentPage, pageSize: pageSize, totalRows: totalRows),
                PopupMenuButton<int>(
                  onSelected: onPageSizeChanged,
                  itemBuilder: (context) =>
                      pageSizeOptions.map((size) => PopupMenuItem<int>(value: size, child: Text('$size rows per page'))).toList(),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.vooSpacing.md,
                      vertical: context.vooSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.borderColor),
                      borderRadius: BorderRadius.circular(context.vooRadius.sm),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('$pageSize rows', style: context.vooTypography.bodySmall),
                        Icon(Icons.arrow_drop_down, size: context.vooSize.iconSmall),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.vooSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.first_page),
                  onPressed: currentPage > 0 ? () => onPageChanged(0) : null,
                  tooltip: 'First',
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: currentPage > 0 ? () => onPageChanged(currentPage - 1) : null,
                  tooltip: 'Previous',
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.vooSpacing.md),
                  child: Text(
                    '${currentPage + 1} / $totalPages',
                    style: context.vooTypography.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: currentPage < totalPages - 1 ? () => onPageChanged(currentPage + 1) : null,
                  tooltip: 'Next',
                ),
                IconButton(
                  icon: const Icon(Icons.last_page),
                  onPressed: currentPage < totalPages - 1 ? () => onPageChanged(totalPages - 1) : null,
                  tooltip: 'Last',
                ),
              ],
            ),
          ],
        ),
      );
}

/// Pagination controls for VooDataGrid
class VooDataGridPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int pageSize;
  final int totalRows;
  final void Function(int page) onPageChanged;
  final void Function(int pageSize) onPageSizeChanged;
  final VooDataGridTheme theme;
  final List<int> pageSizeOptions;

  const VooDataGridPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.totalRows,
    required this.onPageChanged,
    required this.onPageSizeChanged,
    required this.theme,
    this.pageSizeOptions = const [10, 20, 50, 100],
  });

  @override
  Widget build(BuildContext context) => Container(
        height: 56,
        padding: EdgeInsets.symmetric(horizontal: context.vooSpacing.lg),
        decoration: BoxDecoration(
          color: theme.headerBackgroundColor,
          border: Border(
            top: BorderSide(color: theme.borderColor, width: theme.borderWidth),
          ),
        ),
        child: Row(
          children: [
            Text('Rows per page:', style: context.vooTypography.bodySmall),
            SizedBox(width: context.vooSpacing.sm),
            DropdownButton<int>(
              value: pageSize,
              isDense: true,
              underline: const SizedBox.shrink(),
              items: pageSizeOptions
                  .map((size) => DropdownMenuItem<int>(value: size, child: Text(size.toString())))
                  .toList(),
              onChanged: (value) {
                if (value != null) onPageSizeChanged(value);
              },
            ),
            const Spacer(),
            PageInfoDisplay(currentPage: currentPage, pageSize: pageSize, totalRows: totalRows),
            SizedBox(width: context.vooSpacing.lg),
            IconButton(
              icon: const Icon(Icons.first_page),
              onPressed: currentPage > 0 ? () => onPageChanged(0) : null,
              tooltip: 'First page',
            ),
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: currentPage > 0 ? () => onPageChanged(currentPage - 1) : null,
              tooltip: 'Previous page',
            ),
            PageInputField(currentPage: currentPage, totalPages: totalPages, onPageChanged: onPageChanged),
            Text(' / $totalPages', style: context.vooTypography.bodySmall),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: currentPage < totalPages - 1 ? () => onPageChanged(currentPage + 1) : null,
              tooltip: 'Next page',
            ),
            IconButton(
              icon: const Icon(Icons.last_page),
              onPressed: currentPage < totalPages - 1 ? () => onPageChanged(totalPages - 1) : null,
              tooltip: 'Last page',
            ),
          ],
        ),
      );
}
