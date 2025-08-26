import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

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
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final startRow = currentPage * pageSize + 1;
    final endRow = ((currentPage + 1) * pageSize).clamp(0, totalRows);

    return Container(
      padding: EdgeInsets.all(design.spacingMd),
      decoration: BoxDecoration(
        color: theme.headerBackgroundColor,
        border: Border(
          top: BorderSide(
            color: theme.borderColor,
            width: theme.borderWidth,
          ),
        ),
      ),
      child: Column(
        children: [
          // Row info and page size selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$startRow-$endRow of $totalRows',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              PopupMenuButton<int>(
                onSelected: onPageSizeChanged,
                itemBuilder: (context) => pageSizeOptions
                    .map((size) => PopupMenuItem(
                          value: size,
                          child: Text('$size rows per page'),
                        ))
                    .toList(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: design.spacingMd,
                    vertical: design.spacingXs,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.borderColor),
                    borderRadius: BorderRadius.circular(design.radiusSm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$pageSize rows',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const Icon(Icons.arrow_drop_down, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: design.spacingMd),
          // Navigation controls
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
                onPressed: currentPage > 0
                    ? () => onPageChanged(currentPage - 1)
                    : null,
                tooltip: 'Previous',
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: design.spacingMd),
                child: Text(
                  '${currentPage + 1} / $totalPages',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: currentPage < totalPages - 1
                    ? () => onPageChanged(currentPage + 1)
                    : null,
                tooltip: 'Next',
              ),
              IconButton(
                icon: const Icon(Icons.last_page),
                onPressed: currentPage < totalPages - 1
                    ? () => onPageChanged(totalPages - 1)
                    : null,
                tooltip: 'Last',
              ),
            ],
          ),
        ],
      ),
    );
  }
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
  Widget build(BuildContext context) {
    final design = context.vooDesign;

    final startRow = currentPage * pageSize + 1;
    final endRow = ((currentPage + 1) * pageSize).clamp(0, totalRows);

    return Container(
      height: 56,
      padding: EdgeInsets.symmetric(horizontal: design.spacingLg),
      decoration: BoxDecoration(
        color: theme.headerBackgroundColor,
        border: Border(
          top: BorderSide(
            color: theme.borderColor,
            width: theme.borderWidth,
          ),
        ),
      ),
      child: Row(
        children: [
          // Page size selector
          Text(
            'Rows per page:',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(width: design.spacingSm),
          SizedBox(
            width: 80,
            child: VooDropdown<int>(
              value: pageSize,
              items: pageSizeOptions
                  .map(
                    (size) => VooDropdownItem(
                      value: size,
                      label: size.toString(),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  onPageSizeChanged(value);
                }
              },
            ),
          ),

          const Spacer(),

          // Row info
          Text(
            '$startRow-$endRow of $totalRows',
            style: Theme.of(context).textTheme.bodySmall,
          ),

          SizedBox(width: design.spacingLg),

          // Navigation buttons
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

          // Page number input
          SizedBox(
            width: 60,
            child: TextField(
              controller: TextEditingController(text: '${currentPage + 1}'),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: design.spacingSm,
                  vertical: design.spacingXs,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(design.radiusSm),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onSubmitted: (value) {
                final page = int.tryParse(value);
                if (page != null && page > 0 && page <= totalPages) {
                  onPageChanged(page - 1);
                }
              },
            ),
          ),

          Text(
            ' / $totalPages',
            style: Theme.of(context).textTheme.bodySmall,
          ),

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
}
