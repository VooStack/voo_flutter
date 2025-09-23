/// Data grid operation mode
enum VooDataGridMode {
  /// All operations (filtering, sorting, pagination) are handled locally
  local,

  /// All operations are handled remotely via API
  remote,

  /// Filtering and sorting are local, but data fetching is remote
  mixed,
}

/// Selection mode for data grid
enum VooSelectionMode { none, single, multiple }
