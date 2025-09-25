import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voo_data_grid/src/domain/entities/data_grid_column.dart';
import 'package:voo_data_grid/src/domain/entities/export_config.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_filter.dart';
import 'package:voo_data_grid/src/domain/services/export_service.dart';

/// Excel export service implementation
class ExcelExportService<T> extends ExportService<T> {
  @override
  Future<Uint8List> export({
    required List<T> data,
    required List<VooDataColumn> columns,
    required ExportConfig config,
    Map<String, VooDataFilter>? activeFilters,
  }) async {
    final excel = Excel.createExcel();

    // Create new sheet with desired name
    final sheetName = config.title ?? 'Data Export';
    final sheet = excel[sheetName];

    // Remove default Sheet1 if it exists and it's not our sheet
    if (sheetName != 'Sheet1' && excel.tables.containsKey('Sheet1')) {
      excel.delete('Sheet1');
    }

    // Filter columns based on selection and visibility
    List<VooDataColumn> columnsToExport;
    if (config.selectedColumns != null && config.selectedColumns!.isNotEmpty) {
      columnsToExport = columns
          .where((col) => config.selectedColumns!.contains(col.field) && col.visible && !(config.excludeColumns?.contains(col.field) ?? false))
          .toList();
    } else {
      columnsToExport = columns.where((col) => col.visible && !(config.excludeColumns?.contains(col.field) ?? false)).toList();
    }

    var currentRow = 0;

    // Add title and metadata if configured
    if (config.title != null) {
      sheet.merge(
        CellIndex.indexByString('A${currentRow + 1}'),
        CellIndex.indexByString('${_getColumnLetter(columnsToExport.length + (config.showRowNumbers ? 1 : 0) - 1)}${currentRow + 1}'),
      );
      final titleCell = sheet.cell(CellIndex.indexByString('A${currentRow + 1}'));
      titleCell.value = TextCellValue(config.title!);
      titleCell.cellStyle = CellStyle(fontSize: 16, bold: true, horizontalAlign: HorizontalAlign.Center);
      currentRow += 2;
    }

    if (config.subtitle != null) {
      sheet.merge(
        CellIndex.indexByString('A${currentRow + 1}'),
        CellIndex.indexByString('${_getColumnLetter(columnsToExport.length + (config.showRowNumbers ? 1 : 0) - 1)}${currentRow + 1}'),
      );
      final subtitleCell = sheet.cell(CellIndex.indexByString('A${currentRow + 1}'));
      subtitleCell.value = TextCellValue(config.subtitle!);
      subtitleCell.cellStyle = CellStyle(fontSize: 12, horizontalAlign: HorizontalAlign.Center);
      currentRow += 2;
    }

    // Add filter information if configured
    if (config.includeFilters && activeFilters != null && activeFilters.isNotEmpty) {
      final filterCell = sheet.cell(CellIndex.indexByString('A${currentRow + 1}'));
      filterCell.value = TextCellValue('Active Filters:');
      filterCell.cellStyle = CellStyle(bold: true);
      currentRow++;

      for (final entry in activeFilters.entries) {
        final filter = entry.value;
        final filterText = '${entry.key}: ${filter.operator.name} ${filter.value?.toString() ?? ''}';
        sheet.cell(CellIndex.indexByString('A${currentRow + 1}')).value = TextCellValue(filterText);
        currentRow++;
      }
      currentRow++;
    }

    // Add timestamp if configured
    if (config.includeTimestamp) {
      final timestampCell = sheet.cell(CellIndex.indexByString('A${currentRow + 1}'));
      timestampCell.value = TextCellValue('Generated: ${DateFormat(config.dateFormat).format(DateTime.now())}');
      timestampCell.cellStyle = CellStyle(italic: true);
      currentRow += 2;
    }

    // Add headers
    var colIndex = 0;
    if (config.showRowNumbers) {
      final cell = sheet.cell(CellIndex.indexByString('${_getColumnLetter(colIndex)}${currentRow + 1}'));
      cell.value = TextCellValue('#');
      cell.cellStyle = _getHeaderStyle(config);
      colIndex++;
    }

    for (final column in columnsToExport) {
      final cell = sheet.cell(CellIndex.indexByString('${_getColumnLetter(colIndex)}${currentRow + 1}'));
      cell.value = TextCellValue(column.label);
      cell.cellStyle = _getHeaderStyle(config);
      colIndex++;
    }
    currentRow++;

    // Add data rows
    final dataToExport = config.maxRows != null ? data.take(config.maxRows!).toList() : data;
    for (var rowIndex = 0; rowIndex < dataToExport.length; rowIndex++) {
      colIndex = 0;

      // Determine if this row should have alternate coloring
      final shouldApplyAlternateColor = rowIndex % 2 == 1;
      ExcelColor? rowBackgroundColor;
      if (shouldApplyAlternateColor) {
        // Use a light gray for alternating rows
        rowBackgroundColor = ExcelColor.fromHexString('#F5F5F5');
      }

      if (config.showRowNumbers) {
        final cell = sheet.cell(CellIndex.indexByString('${_getColumnLetter(colIndex)}${currentRow + 1}'));
        cell.value = IntCellValue(rowIndex + 1);
        if (shouldApplyAlternateColor && rowBackgroundColor != null) {
          cell.cellStyle = CellStyle(backgroundColorHex: rowBackgroundColor);
        }
        colIndex++;
      }

      for (final column in columnsToExport) {
        final value = _getCellValue(dataToExport[rowIndex], column);
        final cell = sheet.cell(CellIndex.indexByString('${_getColumnLetter(colIndex)}${currentRow + 1}'));
        _setCellValue(cell, value, column, config);

        // Apply alternating row colors for better readability
        // Create new style with background color if needed
        if (shouldApplyAlternateColor && rowBackgroundColor != null) {
          // The excel package's CellStyle doesn't support copying styles
          // So we just set a basic style with background color
          cell.cellStyle = CellStyle(backgroundColorHex: rowBackgroundColor);
        }

        colIndex++;
      }
      currentRow++;
    }

    // Calculate optimal column widths based on content
    final columnMaxWidths = <int, double>{};

    // Start with header widths
    colIndex = 0;
    if (config.showRowNumbers) {
      columnMaxWidths[colIndex] = 3.0; // Width for row numbers
      colIndex++;
    }

    for (final column in columnsToExport) {
      columnMaxWidths[colIndex] = column.label.length * 1.2;
      colIndex++;
    }

    // Check data widths
    for (var rowIndex = 0; rowIndex < dataToExport.length && rowIndex < 100; rowIndex++) {
      colIndex = 0;

      if (config.showRowNumbers) {
        final numWidth = (rowIndex + 1).toString().length * 1.5;
        columnMaxWidths[colIndex] = columnMaxWidths[colIndex]!.clamp(numWidth, 50);
        colIndex++;
      }

      for (final column in columnsToExport) {
        final value = _getCellValue(dataToExport[rowIndex], column);
        final stringValue = value?.toString() ?? '';
        final cellWidth = stringValue.length * 1.1;

        if (columnMaxWidths[colIndex] == null || cellWidth > columnMaxWidths[colIndex]!) {
          columnMaxWidths[colIndex] = cellWidth.clamp(10, 50); // Min 10, Max 50
        }
        colIndex++;
      }
    }

    // Apply calculated widths
    columnMaxWidths.forEach(sheet.setColumnWidth);

    // Set column widths if specified
    if (config.columnWidths != null) {
      for (var i = 0; i < columnsToExport.length; i++) {
        final column = columnsToExport[i];
        final width = config.columnWidths![column.field];
        if (width != null) {
          sheet.setColumnWidth(config.showRowNumbers ? i + 1 : i, width / 7);
        }
      }
    }

    // Add footer if configured
    if (config.footerText != null) {
      currentRow++;
      sheet.merge(
        CellIndex.indexByString('A${currentRow + 1}'),
        CellIndex.indexByString('${_getColumnLetter(columnsToExport.length + (config.showRowNumbers ? 1 : 0) - 1)}${currentRow + 1}'),
      );
      final footerCell = sheet.cell(CellIndex.indexByString('A${currentRow + 1}'));
      footerCell.value = TextCellValue(config.footerText!);
      footerCell.cellStyle = CellStyle(italic: true, horizontalAlign: HorizontalAlign.Center);
    }

    // Convert to bytes
    final bytes = excel.save();
    return Uint8List.fromList(bytes!);
  }

  String _getColumnLetter(int index) {
    var letter = '';
    var tempIndex = index;
    while (tempIndex >= 0) {
      letter = String.fromCharCode(65 + (tempIndex % 26)) + letter;
      tempIndex = (tempIndex ~/ 26) - 1;
      if (tempIndex < 0) break;
    }
    return letter;
  }

  CellStyle _getHeaderStyle(ExportConfig config) {
    // Use primary color if available, fallback to accent color, then default blue
    ExcelColor bgColor;
    if (config.primaryColor != null) {
      bgColor = ExcelColor.fromHexString(_colorToHex(config.primaryColor!));
    } else if (config.accentColor != null) {
      bgColor = ExcelColor.fromHexString(_colorToHex(config.accentColor!));
    } else {
      bgColor = ExcelColor.fromHexString('#4A90E2'); // Default blue
    }

    // Determine text color based on background luminance
    final textColor = _getContrastingTextColor(config.primaryColor ?? config.accentColor);

    return CellStyle(
      bold: true,
      backgroundColorHex: bgColor,
      fontColorHex: textColor,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );
  }

  String _colorToHex(Color color) => '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';

  /// Get contrasting text color for better readability
  ExcelColor _getContrastingTextColor(Color? backgroundColor) {
    if (backgroundColor == null) {
      return ExcelColor.fromHexString('#000000'); // Default to black
    }

    // Calculate luminance
    final argb = backgroundColor.toARGB32();
    final r = ((argb >> 16) & 0xFF) / 255.0;
    final g = ((argb >> 8) & 0xFF) / 255.0;
    final b = (argb & 0xFF) / 255.0;

    final luminance = 0.299 * r + 0.587 * g + 0.114 * b;

    // Return white for dark backgrounds, black for light backgrounds
    return luminance > 0.5 ? ExcelColor.fromHexString('#000000') : ExcelColor.fromHexString('#FFFFFF');
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

  void _setCellValue(Data cell, dynamic value, VooDataColumn column, ExportConfig config) {
    if (value == null) {
      cell.value = TextCellValue('');
      return;
    }

    String formattedValue;
    if (column.valueFormatter != null) {
      formattedValue = column.valueFormatter!(value);
      cell.value = TextCellValue(formattedValue);
    } else if (value is DateTime) {
      formattedValue = DateFormat(config.dateFormat).format(value);
      cell.value = TextCellValue(formattedValue);
    } else if (value is num) {
      if (config.numberFormat != null) {
        final formatter = NumberFormat(config.numberFormat);
        formattedValue = formatter.format(value);
        cell.value = TextCellValue(formattedValue);
      } else if (value is int) {
        cell.value = IntCellValue(value);
      } else {
        cell.value = DoubleCellValue(value.toDouble());
      }
    } else if (value is bool) {
      cell.value = BoolCellValue(value);
    } else {
      cell.value = TextCellValue(value.toString());
    }
  }

  @override
  Future<String> saveToFile({required Uint8List data, required String filename, required ExportFormat format}) async {
    // This would typically save to device storage
    // Implementation depends on platform (mobile vs web)
    throw UnimplementedError('Save to file not implemented in base service');
  }

  @override
  Future<void> shareOrPrint({required Uint8List data, required String filename, required ExportFormat format}) async {
    // This would typically use share_plus or similar package
    // Implementation depends on platform
    throw UnimplementedError('Share not implemented in base service');
  }

  @override
  bool isExportAvailable() => true;

  @override
  String getSuggestedFilename(ExportConfig config) {
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final base = config.filename ?? config.title?.replaceAll(' ', '_') ?? 'export';
    return '${base}_$timestamp.xlsx';
  }
}
