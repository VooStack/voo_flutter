import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_ui/src/data/data_grid.dart';
import 'package:voo_ui/src/foundations/design_system.dart';
import 'package:voo_ui/src/inputs/dropdown.dart';

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
