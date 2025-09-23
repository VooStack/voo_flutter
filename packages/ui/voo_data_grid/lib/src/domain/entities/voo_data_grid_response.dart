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

  const VooDataGridResponse({required this.rows, required this.totalRows, required this.page, required this.pageSize});

  /// Calculate total number of pages
  int get totalPages => pageSize > 0 ? (totalRows / pageSize).ceil() : 0;

  /// Check if there is a next page
  bool get hasNextPage => page < totalPages - 1;

  /// Check if there is a previous page
  bool get hasPreviousPage => page > 0;

  /// Check if the response is empty
  bool get isEmpty => rows.isEmpty;

  /// Check if the response is not empty
  bool get isNotEmpty => rows.isNotEmpty;

  /// Create a copy with updated values
  VooDataGridResponse<T> copyWith({List<T>? rows, int? totalRows, int? page, int? pageSize}) =>
      VooDataGridResponse<T>(rows: rows ?? this.rows, totalRows: totalRows ?? this.totalRows, page: page ?? this.page, pageSize: pageSize ?? this.pageSize);
}
