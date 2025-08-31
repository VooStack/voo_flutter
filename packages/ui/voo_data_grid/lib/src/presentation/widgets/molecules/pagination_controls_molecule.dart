import 'package:flutter/material.dart';

import 'package:voo_data_grid/src/presentation/widgets/atoms/page_indicator_atom.dart';
import 'package:voo_data_grid/src/presentation/widgets/atoms/pagination_button_atom.dart';

/// A molecule component for pagination controls
class PaginationControlsMolecule extends StatelessWidget {
  /// Current page (0-indexed)
  final int currentPage;
  
  /// Total number of pages
  final int totalPages;
  
  /// Callback when page changes
  final void Function(int page) onPageChanged;
  
  /// Whether to show first/last buttons
  final bool showFirstLast;
  
  /// Whether to show page indicator
  final bool showPageIndicator;
  
  const PaginationControlsMolecule({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.showFirstLast = true,
    this.showPageIndicator = true,
  });

  @override
  Widget build(BuildContext context) {
    final canGoBack = currentPage > 0;
    final canGoForward = currentPage < totalPages - 1;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showFirstLast)
          PaginationButtonAtom(
            icon: Icons.first_page,
            onPressed: canGoBack ? () => onPageChanged(0) : null,
            tooltip: 'First',
          ),
        PaginationButtonAtom(
          icon: Icons.chevron_left,
          onPressed: canGoBack ? () => onPageChanged(currentPage - 1) : null,
          tooltip: 'Previous',
        ),
        if (showPageIndicator)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PageIndicatorAtom(
              currentPage: currentPage + 1, // Display as 1-indexed
              totalPages: totalPages,
            ),
          ),
        PaginationButtonAtom(
          icon: Icons.chevron_right,
          onPressed: canGoForward ? () => onPageChanged(currentPage + 1) : null,
          tooltip: 'Next',
        ),
        if (showFirstLast)
          PaginationButtonAtom(
            icon: Icons.last_page,
            onPressed: canGoForward ? () => onPageChanged(totalPages - 1) : null,
            tooltip: 'Last',
          ),
      ],
    );
  }
}