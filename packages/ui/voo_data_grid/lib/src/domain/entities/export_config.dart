import 'dart:typed_data';

import 'package:flutter/material.dart';

/// Enumeration for export formats
enum ExportFormat {
  pdf,
  excel,
}

/// Enumeration for PDF layout types
enum PdfLayoutType {
  /// Traditional grid/table layout - best for small to medium datasets
  grid,

  /// List layout - each record displayed as a card, best for large datasets
  list,

  /// Report layout - detailed view with headers and grouped data
  report,

  /// Compact layout - minimal spacing, maximum data density
  compact,
}

/// Configuration for data grid export
class ExportConfig {
  /// The export format
  final ExportFormat format;

  /// Title for the document
  final String? title;

  /// Subtitle for the document
  final String? subtitle;

  /// Company name
  final String? companyName;

  /// Company logo as bytes (for PDF)
  final Uint8List? companyLogo;

  /// Author name
  final String? author;

  /// Document subject
  final String? subject;

  /// Keywords for document metadata
  final String? keywords;

  /// Creator application name
  final String? creator;

  /// Whether to include filters information in export
  final bool includeFilters;

  /// Whether to include timestamp
  final bool includeTimestamp;

  /// Custom header text
  final String? headerText;

  /// Custom footer text
  final String? footerText;

  /// Page orientation for PDF (portrait or landscape)
  final bool isLandscape;

  /// Theme colors
  final Color? primaryColor;
  final Color? accentColor;

  /// Column widths (optional)
  final Map<String, double>? columnWidths;

  /// Columns to exclude from export
  final List<String>? excludeColumns;

  /// Custom filename (without extension)
  final String? filename;

  /// Whether to show row numbers
  final bool showRowNumbers;

  /// Maximum rows to export (null for all)
  final int? maxRows;

  /// Date format for date columns
  final String dateFormat;

  /// Number format for numeric columns
  final String? numberFormat;

  /// PDF layout type
  final PdfLayoutType pdfLayoutType;

  /// Selected columns to export (null means all visible columns)
  final List<String>? selectedColumns;

  /// Whether to auto-size columns based on content
  final bool autoSizeColumns;

  /// Maximum column width for auto-sizing (in PDF units)
  final double? maxColumnWidth;

  const ExportConfig({
    required this.format,
    this.title,
    this.subtitle,
    this.companyName,
    this.companyLogo,
    this.author,
    this.subject,
    this.keywords,
    this.creator,
    this.includeFilters = true,
    this.includeTimestamp = true,
    this.headerText,
    this.footerText,
    this.isLandscape = true,
    this.primaryColor,
    this.accentColor,
    this.columnWidths,
    this.excludeColumns,
    this.filename,
    this.showRowNumbers = false,
    this.maxRows,
    this.dateFormat = 'yyyy-MM-dd HH:mm',
    this.numberFormat,
    this.pdfLayoutType = PdfLayoutType.grid,
    this.selectedColumns,
    this.autoSizeColumns = true,
    this.maxColumnWidth,
  });

  /// Creates a copy with modified fields
  ExportConfig copyWith({
    ExportFormat? format,
    String? title,
    String? subtitle,
    String? companyName,
    Uint8List? companyLogo,
    String? author,
    String? subject,
    String? keywords,
    String? creator,
    bool? includeFilters,
    bool? includeTimestamp,
    String? headerText,
    String? footerText,
    bool? isLandscape,
    Color? primaryColor,
    Color? accentColor,
    Map<String, double>? columnWidths,
    List<String>? excludeColumns,
    String? filename,
    bool? showRowNumbers,
    int? maxRows,
    String? dateFormat,
    String? numberFormat,
    PdfLayoutType? pdfLayoutType,
    List<String>? selectedColumns,
    bool? autoSizeColumns,
    double? maxColumnWidth,
  }) => ExportConfig(
      format: format ?? this.format,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      companyName: companyName ?? this.companyName,
      companyLogo: companyLogo ?? this.companyLogo,
      author: author ?? this.author,
      subject: subject ?? this.subject,
      keywords: keywords ?? this.keywords,
      creator: creator ?? this.creator,
      includeFilters: includeFilters ?? this.includeFilters,
      includeTimestamp: includeTimestamp ?? this.includeTimestamp,
      headerText: headerText ?? this.headerText,
      footerText: footerText ?? this.footerText,
      isLandscape: isLandscape ?? this.isLandscape,
      primaryColor: primaryColor ?? this.primaryColor,
      accentColor: accentColor ?? this.accentColor,
      columnWidths: columnWidths ?? this.columnWidths,
      excludeColumns: excludeColumns ?? this.excludeColumns,
      filename: filename ?? this.filename,
      showRowNumbers: showRowNumbers ?? this.showRowNumbers,
      maxRows: maxRows ?? this.maxRows,
      dateFormat: dateFormat ?? this.dateFormat,
      numberFormat: numberFormat ?? this.numberFormat,
      pdfLayoutType: pdfLayoutType ?? this.pdfLayoutType,
      selectedColumns: selectedColumns ?? this.selectedColumns,
      autoSizeColumns: autoSizeColumns ?? this.autoSizeColumns,
      maxColumnWidth: maxColumnWidth ?? this.maxColumnWidth,
    );
}