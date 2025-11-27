import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:voo_data_grid/src/domain/entities/data_grid_column.dart';
import 'package:voo_data_grid/src/domain/entities/export_config.dart';
import 'package:voo_data_grid/src/domain/strategies/pdf_layout_strategy.dart';

/// Grid layout strategy - traditional table format
class GridPdfLayout extends PdfLayoutStrategy {
  @override
  String get name => 'Grid Layout';

  @override
  String get description => 'Traditional table layout with all data in a grid. Best for small to medium datasets.';

  @override
  bool supportsDataSize(int rowCount, int columnCount) {
    // Grid layout works best with reasonable column counts
    return columnCount <= 15;
  }

  @override
  PdfPageFormat getPageFormat(ExportConfig config) => config.isLandscape ? PdfPageFormat.a4.landscape : PdfPageFormat.a4;

  @override
  List<pw.Widget> buildContent({
    required List<String> headers,
    required List<List<String>> rows,
    required List<VooDataColumn> columns,
    required ExportConfig config,
    required Map<String, dynamic>? activeFilters,
  }) {
    final widgets = <pw.Widget>[];

    // Add filter info if needed
    if (config.includeFilters && activeFilters != null && activeFilters.isNotEmpty) {
      widgets.add(_buildFilterInfo(activeFilters, config));
      widgets.add(pw.SizedBox(height: 20));
    }

    // Add the table
    widgets.add(_buildTable(headers, rows, columns, config));

    return widgets;
  }

  pw.Widget _buildFilterInfo(Map<String, dynamic> filters, ExportConfig config) {
    final filterTexts = filters.entries.map((entry) => '${entry.key}: ${entry.value}').toList();

    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(color: PdfColors.grey200, borderRadius: pw.BorderRadius.circular(4)),
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

  pw.Widget _buildTable(List<String> headers, List<List<String>> rows, List<VooDataColumn> columns, ExportConfig config) {
    // Calculate column widths
    final columnCount = headers.length;
    final columnWidths = <int, pw.TableColumnWidth>{};

    if (config.showRowNumbers) {
      columnWidths[0] = const pw.FixedColumnWidth(40);
    }

    // Calculate optimal column widths based on content
    final dataColumnStart = config.showRowNumbers ? 1 : 0;

    if (config.autoSizeColumns) {
      final calculatedWidths = _calculateColumnWidths(headers, rows, dataColumnStart, config);
      for (var i = dataColumnStart; i < columnCount; i++) {
        final columnIndex = i - dataColumnStart;
        columnWidths[i] = pw.FlexColumnWidth(calculatedWidths[columnIndex]);
      }
    } else {
      // Use flex for all columns
      for (var i = dataColumnStart; i < columnCount; i++) {
        columnWidths[i] = const pw.FlexColumnWidth();
      }
    }

    return pw.Table(
      columnWidths: columnWidths,
      border: pw.TableBorder.all(color: _pdfColorFromFlutter(config.accentColor) ?? PdfColors.grey400, width: 0.5),
      children: [
        // Header row
        pw.TableRow(
          decoration: pw.BoxDecoration(color: _pdfColorFromFlutter(config.primaryColor) ?? PdfColors.blue100),
          children: headers
              .map(
                (header) => pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    header,
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      color: _getContrastingTextColor(_pdfColorFromFlutter(config.primaryColor) ?? PdfColors.blue100),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        // Data rows
        ...rows.asMap().entries.map((entry) {
          final index = entry.key;
          final row = entry.value;
          return pw.TableRow(
            decoration: pw.BoxDecoration(color: index % 2 == 0 ? PdfColors.white : _pdfColorFromFlutter(config.accentColor)?.shade(0.1) ?? PdfColors.grey100),
            children: row
                .map(
                  (cell) => pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(cell, style: const pw.TextStyle(fontSize: 9), maxLines: 3, overflow: pw.TextOverflow.clip),
                  ),
                )
                .toList(),
          );
        }),
      ],
    );
  }

  List<double> _calculateColumnWidths(List<String> headers, List<List<String>> rows, int dataColumnStart, ExportConfig config) {
    final columnCount = headers.length - dataColumnStart;
    final maxWidths = List<double>.filled(columnCount, 1.0);

    // Calculate max character count for each column
    for (var i = dataColumnStart; i < headers.length; i++) {
      final columnIndex = i - dataColumnStart;
      // Header width
      final headerLength = headers[i].length.toDouble();
      maxWidths[columnIndex] = headerLength;

      // Check first 100 rows for content width
      final samplesToCheck = rows.length > 100 ? 100 : rows.length;
      for (var j = 0; j < samplesToCheck; j++) {
        if (i < rows[j].length) {
          final cellLength = rows[j][i].length.toDouble();
          if (cellLength > maxWidths[columnIndex]) {
            maxWidths[columnIndex] = cellLength;
          }
        }
      }
    }

    // Convert to relative widths (flex values)
    final totalWidth = maxWidths.reduce((a, b) => a + b);
    final flexWidths = maxWidths.map((w) {
      // Calculate flex value with minimum of 0.5 and maximum of 3.0
      final flex = (w / totalWidth) * columnCount;
      if (flex < 0.5) return 0.5;
      if (flex > 3.0) return 3.0;
      return flex;
    }).toList();

    return flexWidths;
  }

  PdfColor? _pdfColorFromFlutter(Color? color) {
    if (color == null) return null;
    return PdfColor.fromInt(color.toARGB32());
  }

  PdfColor _getContrastingTextColor(PdfColor backgroundColor) {
    final luminance = 0.299 * backgroundColor.red + 0.587 * backgroundColor.green + 0.114 * backgroundColor.blue;
    return luminance > 0.5 ? PdfColors.black : PdfColors.white;
  }
}
