import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:voo_data_grid/src/domain/entities/data_grid_column.dart';
import 'package:voo_data_grid/src/domain/entities/export_config.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_filter.dart';
import 'package:voo_data_grid/src/domain/services/export_service.dart';

/// PDF export service implementation
class PdfExportService<T> extends ExportService<T> {
  @override
  Future<Uint8List> export({
    required List<T> data,
    required List<VooDataColumn> columns,
    required ExportConfig config,
    Map<String, VooDataFilter>? activeFilters,
  }) async {
    final pdf = pw.Document(
      title: config.title ?? 'Data Export',
      author: config.author ?? 'VooDataGrid',
      subject: config.subject,
      keywords: config.keywords,
      creator: config.creator ?? 'VooDataGrid Export',
    );

    final theme = pw.ThemeData.withFont(base: await PdfGoogleFonts.nunitoRegular(), bold: await PdfGoogleFonts.nunitoBold());

    final pageFormat = config.isLandscape ? PdfPageFormat.a4.landscape : PdfPageFormat.a4;

    // Filter visible and non-excluded columns
    final visibleColumns = columns.where((col) => col.visible && !(config.excludeColumns?.contains(col.field) ?? false)).toList();

    // Prepare headers
    final headers = <String>[];
    if (config.showRowNumbers) headers.add('#');
    headers.addAll(visibleColumns.map((col) => col.label));

    // Prepare rows
    final rows = <List<String>>[];
    final dataToExport = config.maxRows != null ? data.take(config.maxRows!).toList() : data;

    for (var i = 0; i < dataToExport.length; i++) {
      final row = <String>[];
      if (config.showRowNumbers) row.add((i + 1).toString());

      for (final column in visibleColumns) {
        final value = _getCellValue(dataToExport[i], column);
        row.add(_formatValue(value, column, config));
      }
      rows.add(row);
    }

    // Build PDF pages
    pdf.addPage(
      pw.MultiPage(
        pageFormat: pageFormat,
        theme: theme,
        margin: const pw.EdgeInsets.all(20),
        header: (context) => _buildHeader(config, context),
        footer: (context) => _buildFooter(config, context),
        build: (context) => [
          if (config.includeFilters && activeFilters != null && activeFilters.isNotEmpty) _buildFilterInfo(activeFilters),
          pw.SizedBox(height: 20),
          _buildTable(headers, rows, config),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildHeader(ExportConfig config, pw.Context context) {
    final widgets = <pw.Widget>[];

    if (config.companyLogo != null) {
      widgets.add(pw.Container(height: 50, child: pw.Image(pw.MemoryImage(config.companyLogo!))));
      widgets.add(pw.SizedBox(width: 20));
    }

    final textWidgets = <pw.Widget>[];
    if (config.companyName != null) {
      textWidgets.add(pw.Text(config.companyName!, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)));
    }
    if (config.title != null) {
      textWidgets.add(pw.Text(config.title!, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)));
    }
    if (config.subtitle != null) {
      textWidgets.add(pw.Text(config.subtitle!, style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)));
    }
    if (config.includeTimestamp) {
      textWidgets.add(
        pw.Text('Generated: ${DateFormat(config.dateFormat).format(DateTime.now())}', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
      );
    }

    widgets.add(
      pw.Expanded(
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: textWidgets),
      ),
    );

    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 20),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300)),
      ),
      child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: widgets),
    );
  }

  pw.Widget _buildFooter(ExportConfig config, pw.Context context) {
    final widgets = <pw.Widget>[];

    if (config.footerText != null) {
      widgets.add(pw.Text(config.footerText!, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)));
    }

    widgets.add(pw.Text('Page ${context.pageNumber} of ${context.pagesCount}', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)));

    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.grey300)),
      ),
      child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: widgets),
    );
  }

  pw.Widget _buildFilterInfo(Map<String, VooDataFilter> filters) {
    final filterTexts = filters.entries.map((entry) {
      final filter = entry.value;
      final operator = filter.operator.name;
      final value = filter.value?.toString() ?? '';
      return '${entry.key}: $operator $value';
    }).toList();

    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(color: PdfColors.grey100, borderRadius: pw.BorderRadius.circular(4)),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Active Filters:', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 5),
          ...filterTexts.map((text) => pw.Text(text, style: const pw.TextStyle(fontSize: 10))),
        ],
      ),
    );
  }

  pw.Widget _buildTable(List<String> headers, List<List<String>> rows, ExportConfig config) {
    // Calculate column widths
    final columnCount = headers.length;
    final columnWidths = <int, pw.TableColumnWidth>{};

    if (config.showRowNumbers) {
      columnWidths[0] = const pw.FixedColumnWidth(40);
    }

    // Distribute remaining width among columns
    final dataColumnStart = config.showRowNumbers ? 1 : 0;
    for (var i = dataColumnStart; i < columnCount; i++) {
      columnWidths[i] = const pw.FlexColumnWidth();
    }

    return pw.Table(
      columnWidths: columnWidths,
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      children: [
        // Header row
        pw.TableRow(
          decoration: pw.BoxDecoration(color: _pdfColorFromFlutter(config.primaryColor) ?? PdfColors.blue50),
          children: headers
              .map(
                (header) => pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(header, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                ),
              )
              .toList(),
        ),
        // Data rows
        ...rows.asMap().entries.map((entry) {
          final index = entry.key;
          final row = entry.value;
          return pw.TableRow(
            decoration: pw.BoxDecoration(color: index % 2 == 0 ? PdfColors.white : PdfColors.grey50),
            children: row
                .map(
                  (cell) => pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(cell, style: const pw.TextStyle(fontSize: 9)),
                  ),
                )
                .toList(),
          );
        }),
      ],
    );
  }

  dynamic _getCellValue<R>(R row, VooDataColumn column) {
    // Try to use valueGetter if available
    try {
      // Access valueGetter through dynamic to avoid type checking issues
      final dynamicColumn = column as dynamic;
      if (dynamicColumn.valueGetter != null) {
        try {
          // Try to call the getter with the row
          return dynamicColumn.valueGetter(row);
        } catch (_) {
          // If that fails, try with dynamic row
          try {
            return dynamicColumn.valueGetter(row as dynamic);
          } catch (_) {
            // Continue to fallback methods
          }
        }
      }
    } catch (_) {
      // valueGetter access failed, continue with fallbacks
    }

    // Fallback to Map access
    if (row is Map) {
      return row[column.field];
    }

    // For other object types, try reflection
    try {
      final mirror = row as dynamic;
      return mirror.toJson()[column.field];
    } catch (_) {
      return '';
    }
  }

  String _formatValue(dynamic value, VooDataColumn column, ExportConfig config) {
    if (value == null) return '';

    if (column.valueFormatter != null) {
      return column.valueFormatter!(value);
    }

    if (value is DateTime) {
      return DateFormat(config.dateFormat).format(value);
    }

    if (value is num && config.numberFormat != null) {
      final formatter = NumberFormat(config.numberFormat);
      return formatter.format(value);
    }

    if (value is bool) {
      return value ? 'Yes' : 'No';
    }

    return value.toString();
  }

  PdfColor? _pdfColorFromFlutter(Color? color) {
    if (color == null) return null;
    return PdfColor.fromInt(color.toARGB32());
  }

  @override
  Future<String> saveToFile({required Uint8List data, required String filename, required ExportFormat format}) async {
    // This would typically save to device storage
    // Implementation depends on platform (mobile vs web)
    throw UnimplementedError('Save to file not implemented in base service');
  }

  @override
  Future<void> shareOrPrint({required Uint8List data, required String filename, required ExportFormat format}) async {
    // This would typically use printing package to share/print
    // Implementation depends on platform
    throw UnimplementedError('Share or print not implemented in base service');
  }

  @override
  bool isExportAvailable() => true;

  @override
  String getSuggestedFilename(ExportConfig config) {
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final base = config.filename ?? config.title?.replaceAll(' ', '_') ?? 'export';
    return '${base}_$timestamp.pdf';
  }
}

/// Helper to load Google Fonts for PDF
class PdfGoogleFonts {
  static Future<pw.Font> nunitoRegular() async =>
      // In a real implementation, you would load the font from assets or network
      // For now, return the default font
      pw.Font.helvetica();

  static Future<pw.Font> nunitoBold() async =>
      // In a real implementation, you would load the font from assets or network
      // For now, return the default bold font
      pw.Font.helveticaBold();
}
