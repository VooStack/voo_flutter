import 'package:flutter/material.dart';

/// An atomic page indicator component showing current page and total
class PageIndicatorAtom extends StatelessWidget {
  /// Current page number (1-indexed for display)
  final int currentPage;
  
  /// Total number of pages
  final int totalPages;
  
  /// Text style
  final TextStyle? textStyle;
  
  const PageIndicatorAtom({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$currentPage / $totalPages',
      style: textStyle ?? Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w500,
      ),
    );
  }
}