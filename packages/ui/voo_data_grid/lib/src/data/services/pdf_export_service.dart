import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:voo_data_grid/src/data/pdf_layouts/compact_pdf_layout.dart';
import 'package:voo_data_grid/src/data/pdf_layouts/grid_pdf_layout.dart';
import 'package:voo_data_grid/src/data/pdf_layouts/list_pdf_layout.dart';
import 'package:voo_data_grid/src/domain/entities/data_grid_column.dart';
import 'package:voo_data_grid/src/domain/entities/export_config.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_filter.dart';
import 'package:voo_data_grid/src/domain/services/export_service.dart';
import 'package:voo_data_grid/src/domain/strategies/pdf_layout_strategy.dart';

/// PDF export service implementation
class PdfExportService<T> extends ExportService<T> {
  /// Get the appropriate layout strategy based on config
  PdfLayoutStrategy _getLayoutStrategy(ExportConfig config) {
    switch (config.pdfLayoutType) {
      case PdfLayoutType.grid:
        return GridPdfLayout();
      case PdfLayoutType.list:
        return ListPdfLayout();
      case PdfLayoutType.compact:
        return CompactPdfLayout();
      case PdfLayoutType.report:
        // Report layout not yet implemented, fallback to list
        return ListPdfLayout();
    }
  }

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

    // Get the appropriate layout strategy
    final layoutStrategy = _getLayoutStrategy(config);
    final pageFormat = layoutStrategy.getPageFormat(config);

    // Filter columns based on selection and visibility
    List<VooDataColumn> columnsToExport;
    if (config.selectedColumns != null && config.selectedColumns!.isNotEmpty) {
      columnsToExport = columns.where((col) =>
        config.selectedColumns!.contains(col.field) &&
        col.visible &&
        !(config.excludeColumns?.contains(col.field) ?? false)
      ).toList();
    } else {
      columnsToExport = columns.where((col) =>
        col.visible &&
        !(config.excludeColumns?.contains(col.field) ?? false)
      ).toList();
    }

    // Prepare headers
    final headers = <String>[];
    if (config.showRowNumbers) headers.add('#');
    headers.addAll(columnsToExport.map((col) => col.label));

    // Prepare rows
    final rows = <List<String>>[];
    final dataToExport = config.maxRows != null ? data.take(config.maxRows!).toList() : data;

    for (var i = 0; i < dataToExport.length; i++) {
      final row = <String>[];
      if (config.showRowNumbers) row.add((i + 1).toString());

      for (final column in columnsToExport) {
        final value = _getCellValue(dataToExport[i], column);
        row.add(_formatValue(value, column, config));
      }
      rows.add(row);
    }

    // Build content using the layout strategy
    final content = layoutStrategy.buildContent(
      headers: headers,
      rows: rows,
      columns: columnsToExport,
      config: config,
      activeFilters: activeFilters,
    );

    // Build PDF pages
    pdf.addPage(
      pw.MultiPage(
        pageFormat: pageFormat,
        theme: theme,
        margin: const pw.EdgeInsets.all(20),
        header: (context) => _buildHeader(config, context),
        footer: (context) => _buildFooter(config, context),
        build: (context) => content,
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
      decoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: _pdfColorFromFlutter(config.accentColor)?.shade(0.3) ?? PdfColors.grey400,
          ),
        ),
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
      decoration: pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(
            color: _pdfColorFromFlutter(config.accentColor)?.shade(0.3) ?? PdfColors.grey400,
          ),
        ),
      ),
      child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: widgets),
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
