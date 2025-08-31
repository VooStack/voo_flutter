/// Response from data source
///
/// Generic type parameter T represents the row data type.
class VooDataGridResponse<T> {
  /// The list of rows returned for the current page
  final List<T> rows;
  
  /// Total number of rows available (for pagination)
  final int totalRows;
  
  /// Current page number (0-based)
  final int page;
  
  /// Number of rows per page
  final int pageSize;

  const VooDataGridResponse({
    required this.rows,
    required this.totalRows,
    required this.page,
    required this.pageSize,
  });
}