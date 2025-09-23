import 'package:flutter/material.dart';

/// A simple widget that displays pagination row information
class PageInfoDisplay extends StatelessWidget {
  final int currentPage;
  final int pageSize;
  final int totalRows;

  const PageInfoDisplay({super.key, required this.currentPage, required this.pageSize, required this.totalRows});

  @override
  Widget build(BuildContext context) {
    final startRow = currentPage * pageSize + 1;
    final endRow = ((currentPage + 1) * pageSize).clamp(0, totalRows);

    return Text('$startRow-$endRow of $totalRows', style: Theme.of(context).textTheme.bodySmall);
  }
}
