import 'dart:typed_data';

import 'package:voo_data_grid/src/domain/entities/data_grid_column.dart';
import 'package:voo_data_grid/src/domain/entities/export_config.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_filter.dart';

/// Abstract service for exporting data grid content
abstract class ExportService<T> {
  /// Export data to the specified format
  ///
  /// Returns the exported file as bytes
  Future<Uint8List> export({
    required List<T> data,
    required List<VooDataColumn> columns,
    required ExportConfig config,
    Map<String, VooDataFilter>? activeFilters,
  });

  /// Save exported data to a file
  ///
  /// Returns the file path where it was saved
  Future<String> saveToFile({
    required Uint8List data,
    required String filename,
    required ExportFormat format,
  });

  /// Share or print the exported document
  Future<void> shareOrPrint({
    required Uint8List data,
    required String filename,
    required ExportFormat format,
  });

  /// Check if export is available on the current platform
  bool isExportAvailable();

  /// Get suggested filename based on config
  String getSuggestedFilename(ExportConfig config);
}