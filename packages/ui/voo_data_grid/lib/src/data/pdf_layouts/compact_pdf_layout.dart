import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:voo_data_grid/src/domain/entities/data_grid_column.dart';
import 'package:voo_data_grid/src/domain/entities/export_config.dart';
import 'package:voo_data_grid/src/domain/strategies/pdf_layout_strategy.dart';

/// Compact layout strategy - maximum data density
class CompactPdfLayout extends PdfLayoutStrategy {
  @override
  String get name => 'Compact Layout';

  @override
  String get description => 'Minimal spacing with abbreviated columns for maximum data density. Best for overview reports.';

  @override
  // Compact layout can handle any size
  bool supportsDataSize(int rowCount, int columnCount) => true;

  @override
  // Always use landscape for compact layout to fit more columns
  PdfPageFormat getPageFormat(ExportConfig config) => PdfPageFormat.a4.landscape;

  @override
  List<pw.Widget> buildContent({
    required List<String> headers,
    required List<List<String>> rows,
    required List<VooDataColumn> columns,
    required ExportConfig config,
    required Map<String, dynamic>? activeFilters,
  }) {
    final widgets = <pw.Widget>[];

    // Add compact filter info if needed
    if (config.includeFilters && activeFilters != null && activeFilters.isNotEmpty) {
      widgets.add(_buildCompactFilterInfo(activeFilters));
      widgets.add(pw.SizedBox(height: 10));
    }

    // Add the compact table
    widgets.add(_buildCompactTable(headers, rows, columns, config));

    return widgets;
  }

  pw.Widget _buildCompactFilterInfo(Map<String, dynamic> filters) {
    final filterText = filters.entries.map((e) => '${e.key}: ${e.value}').join(' | ');
    return pw.Text('Filters: $filterText', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700));
  }

  pw.Widget _buildCompactTable(List<String> headers, List<List<String>> rows, List<VooDataColumn> columns, ExportConfig config) {
    // Calculate column widths with minimal padding
    final columnCount = headers.length;
    final columnWidths = <int, pw.TableColumnWidth>{};

    if (config.showRowNumbers) {
      columnWidths[0] = const pw.FixedColumnWidth(25); // Smaller row number column
    }

    // Use fixed widths based on column type for compact layout
    final dataColumnStart = config.showRowNumbers ? 1 : 0;
    for (var i = dataColumnStart; i < columnCount; i++) {
      final columnIndex = i - dataColumnStart;
      if (columnIndex < columns.length) {
        // Determine width based on column field name and type
        final column = columns[columnIndex];
        columnWidths[i] = _getCompactColumnWidth(column);
      } else {
        columnWidths[i] = const pw.FixedColumnWidth(60); // Default compact width
      }
    }

    return pw.Table(
      columnWidths: columnWidths,
      border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.3),
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
      children: [
        // Compact header row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: headers.asMap().entries.map((entry) {
            final index = entry.key;
            final header = entry.value;
            return pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 3),
              child: pw.Text(_abbreviateHeader(header, index == 0 && config.showRowNumbers), style: const pw.TextStyle(fontSize: 7, color: PdfColors.black)),
            );
          }).toList(),
        ),
        // Compact data rows
        ...rows.asMap().entries.take(config.maxRows ?? rows.length).map((entry) {
          final rowIndex = entry.key;
          final row = entry.value;
          return pw.TableRow(
            decoration: pw.BoxDecoration(color: rowIndex % 2 == 0 ? PdfColors.white : PdfColors.grey50),
            children: row.asMap().entries.map((cellEntry) {
              final cellIndex = cellEntry.key;
              final cell = cellEntry.value;
              return pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                child: pw.Text(_truncateText(cell, cellIndex), style: const pw.TextStyle(fontSize: 7), maxLines: 1, overflow: pw.TextOverflow.clip),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  pw.TableColumnWidth _getCompactColumnWidth(VooDataColumn column) {
    // Assign width based on field type
    final field = column.field.toLowerCase();

    if (field.contains('id') || field.contains('number')) {
      return const pw.FixedColumnWidth(40);
    } else if (field.contains('status') || field.contains('priority')) {
      return const pw.FixedColumnWidth(35);
    } else if (field.contains('date')) {
      return const pw.FixedColumnWidth(50);
    } else if (field.contains('cost') || field.contains('price') || field.contains('amount')) {
      return const pw.FixedColumnWidth(45);
    } else if (field.contains('name') || field.contains('company')) {
      return const pw.FixedColumnWidth(80);
    } else if (field.contains('address') || field.contains('notes')) {
      return const pw.FixedColumnWidth(100);
    } else {
      return const pw.FixedColumnWidth(60);
    }
  }

  String _abbreviateHeader(String header, bool isRowNumber) {
    if (isRowNumber) return '#';

    // Common abbreviations for space saving
    final abbreviations = {
      'Site Number': 'Site#',
      'Site Name': 'Site',
      'Client Company': 'Client',
      'Project Manager': 'PM',
      'Order Date': 'Order',
      'Due Date': 'Due',
      'Order Status': 'Status',
      'Priority': 'Pri',
      'Address': 'Addr',
      'Cost': '\$',
      'Notes': 'Note',
    };

    return abbreviations[header] ?? (header.length > 8 ? '${header.substring(0, 6)}..' : header);
  }

  String _truncateText(String text, int columnIndex) {
    // Different truncation lengths based on column
    const maxLengths = [
      5, // Row number
      15, // First data column
      20, // Second data column
      15, // Third data column
      10, // Fourth data column
      8, // Fifth data column
      8, // Sixth data column
      10, // Seventh data column
      10, // Eighth data column
      8, // Ninth data column
      20, // Tenth+ columns
    ];

    final maxLength = columnIndex < maxLengths.length ? maxLengths[columnIndex] : 15;

    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - 2)}..';
  }
}
