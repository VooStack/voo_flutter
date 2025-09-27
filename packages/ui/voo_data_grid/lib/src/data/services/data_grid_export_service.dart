import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:voo_data_grid/src/data/services/excel_export_service.dart';
import 'package:voo_data_grid/src/data/services/export_helper.dart';
import 'package:voo_data_grid/src/data/services/pdf_export_service.dart';
import 'package:voo_data_grid/src/domain/entities/data_grid_column.dart';
import 'package:voo_data_grid/src/domain/entities/export_config.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_filter.dart';
import 'package:voo_data_grid/src/domain/services/export_service.dart';

/// Unified export service for VooDataGrid
class DataGridExportService<T> extends ExportService<T> {
  final PdfExportService<T> _pdfService = PdfExportService<T>();
  final ExcelExportService<T> _excelService = ExcelExportService<T>();

  @override
  Future<Uint8List> export({
    required List<T> data,
    required List<VooDataColumn> columns,
    required ExportConfig config,
    Map<String, VooDataFilter>? activeFilters,
  }) async {
    switch (config.format) {
      case ExportFormat.pdf:
        return _pdfService.export(data: data, columns: columns, config: config, activeFilters: activeFilters);
      case ExportFormat.excel:
        return _excelService.export(data: data, columns: columns, config: config, activeFilters: activeFilters);
    }
  }

  @override
  Future<String> saveToFile({required Uint8List data, required String filename, required ExportFormat format}) async {
    if (kIsWeb) {
      // On web, we can't save to file system directly
      // Instead, trigger a download
      // This would typically use dart:html but we're keeping it platform-agnostic
      throw UnsupportedError('Direct file saving not supported on web. Use shareOrPrint instead.');
    }

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename');
    await file.writeAsBytes(data);
    return file.path;
  }

  @override
  Future<void> shareOrPrint({required Uint8List data, required String filename, required ExportFormat format}) async {
    if (format == ExportFormat.pdf) {
      await Printing.sharePdf(bytes: data, filename: filename);
    } else {
      // For Excel files, we need to save and share differently
      if (kIsWeb) {
        // On web, trigger download using proper web download method
        downloadFile(bytes: data, filename: filename);
      } else if (Platform.isAndroid || Platform.isIOS) {
        // On mobile, save to temp and share using a different method
        // Note: Printing.sharePdf doesn't work well for Excel files
        final directory = await getTemporaryDirectory();
        final file = File('${directory.path}/$filename');
        await file.writeAsBytes(data);
        // For Excel files on mobile, we'd need a different sharing mechanism
        // For now, just save the file
        if (kDebugMode) {
          print('Excel file saved to: ${file.path}');
        }
      } else {
        // On desktop, save to documents
        final path = await saveToFile(data: data, filename: filename, format: format);
        if (kDebugMode) {
          print('File saved to: $path');
        }
      }
    }
  }

  @override
  bool isExportAvailable() {
    // Check if we're on a supported platform
    if (kIsWeb) return true;
    if (Platform.isAndroid || Platform.isIOS) return true;
    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) return true;
    return false;
  }

  @override
  String getSuggestedFilename(ExportConfig config) {
    switch (config.format) {
      case ExportFormat.pdf:
        return _pdfService.getSuggestedFilename(config);
      case ExportFormat.excel:
        return _excelService.getSuggestedFilename(config);
    }
  }
}
