import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:voo_data_grid/src/domain/entities/data_grid_column.dart';
import 'package:voo_data_grid/src/domain/entities/export_config.dart';

/// Abstract strategy for PDF layout generation
/// Following Strategy pattern for clean architecture
abstract class PdfLayoutStrategy {
  /// Build the PDF content for the given data
  List<pw.Widget> buildContent({
    required List<String> headers,
    required List<List<String>> rows,
    required List<VooDataColumn> columns,
    required ExportConfig config,
    required Map<String, dynamic>? activeFilters,
  });

  /// Get the recommended page format for this layout
  PdfPageFormat getPageFormat(ExportConfig config);

  /// Check if this layout supports the given data size
  bool supportsDataSize(int rowCount, int columnCount);

  /// Get the layout description
  String get description;

  /// Get the layout name
  String get name;
}
