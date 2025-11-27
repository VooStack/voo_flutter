import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:voo_data_grid/src/domain/entities/data_grid_column.dart';
import 'package:voo_data_grid/src/domain/entities/export_config.dart';
import 'package:voo_data_grid/src/domain/strategies/pdf_layout_strategy.dart';

/// List layout strategy - card-based format for large datasets
class ListPdfLayout extends PdfLayoutStrategy {
  @override
  String get name => 'List Layout';

  @override
  String get description => 'Each record displayed as a card with key-value pairs. Ideal for large datasets with many columns.';

  @override
  bool supportsDataSize(int rowCount, int columnCount) {
    // List layout works well with any size dataset
    return true;
  }

  @override
  PdfPageFormat getPageFormat(ExportConfig config) {
    // List layout usually works better in portrait
    return config.isLandscape ? PdfPageFormat.a4.landscape : PdfPageFormat.a4;
  }

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

    // Build cards for each row
    int recordNumber = 1;
    final cardsToAdd = <pw.Widget>[];

    for (final row in rows) {
      if (config.maxRows != null && recordNumber > config.maxRows!) break;

      // Skip empty rows or rows with only row number
      final hasData = _rowHasData(row, config.showRowNumbers);
      if (!hasData) {
        continue;
      }

      final card = _buildRecordCard(headers, row, recordNumber, config);
      // Only add the card if it has content
      if (card != null) {
        cardsToAdd.add(card);
        recordNumber++;
      }
    }

    // Add cards with proper spacing
    for (var i = 0; i < cardsToAdd.length; i++) {
      widgets.add(cardsToAdd[i]);
      if (i < cardsToAdd.length - 1) {
        widgets.add(pw.SizedBox(height: 10));
      }
    }

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

  pw.Widget? _buildRecordCard(List<String> headers, List<String> row, int recordNumber, ExportConfig config) {
    final cardContent = <pw.Widget>[];

    // Add record number if configured
    if (config.showRowNumbers) {
      cardContent.add(
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: pw.BoxDecoration(color: _pdfColorFromFlutter(config.primaryColor) ?? PdfColors.blue100, borderRadius: pw.BorderRadius.circular(4)),
          child: pw.Text(
            'Record #$recordNumber',
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              color: _getContrastingTextColor(_pdfColorFromFlutter(config.primaryColor) ?? PdfColors.blue100),
            ),
          ),
        ),
      );
      cardContent.add(pw.SizedBox(height: 8));
    }

    // Build key-value pairs in two columns for better space usage
    final pairs = <pw.Widget>[];
    final startIndex = config.showRowNumbers ? 1 : 0;

    for (var i = startIndex; i < headers.length && i < row.length; i++) {
      final header = headers[i];
      final value = row[i].trim();

      // Skip empty values to save space
      if (value.isEmpty) continue;

      pairs.add(
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(vertical: 2),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 120,
                child: pw.Text(
                  '$header:',
                  style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700),
                ),
              ),
              pw.Expanded(
                child: pw.Text(value, style: const pw.TextStyle(fontSize: 9), maxLines: 3, overflow: pw.TextOverflow.clip),
              ),
            ],
          ),
        ),
      );
    }

    // If no pairs were added (all values were empty), return null
    if (pairs.isEmpty) {
      return null;
    }

    // Arrange pairs in two columns if there are many fields
    if (pairs.length > 6) {
      final halfLength = (pairs.length / 2).ceil();
      final leftColumn = pairs.sublist(0, halfLength);
      final rightColumn = pairs.sublist(halfLength);

      cardContent.add(
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: leftColumn),
            ),
            pw.SizedBox(width: 20),
            pw.Expanded(
              child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: rightColumn),
            ),
          ],
        ),
      );
    } else {
      cardContent.addAll(pairs);
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _pdfColorFromFlutter(config.accentColor) ?? PdfColors.grey400, width: 0.5),
        borderRadius: pw.BorderRadius.circular(4),
        color: PdfColors.white,
      ),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: cardContent),
    );
  }

  PdfColor? _pdfColorFromFlutter(Color? color) {
    if (color == null) return null;
    return PdfColor.fromInt(color.toARGB32());
  }

  PdfColor _getContrastingTextColor(PdfColor backgroundColor) {
    final luminance = 0.299 * backgroundColor.red + 0.587 * backgroundColor.green + 0.114 * backgroundColor.blue;
    return luminance > 0.5 ? PdfColors.black : PdfColors.white;
  }

  /// Check if a row has actual data beyond just row number
  bool _rowHasData(List<String> row, bool showRowNumbers) {
    if (row.isEmpty) return false;

    // If showing row numbers, check if there's data beyond the row number
    if (showRowNumbers) {
      if (row.length <= 1) return false;
      // Check if any field after row number has meaningful non-empty data
      for (var i = 1; i < row.length; i++) {
        final cleanValue = row[i].trim();
        // Check if it's not empty and not just whitespace or special characters
        if (cleanValue.isNotEmpty && cleanValue != '' && cleanValue != ' ') {
          return true;
        }
      }
      return false;
    }

    // If not showing row numbers, check if any field has data (after trimming)
    for (final value in row) {
      final cleanValue = value.trim();
      if (cleanValue.isNotEmpty && cleanValue != '' && cleanValue != ' ') {
        return true;
      }
    }
    return false;
  }
}
