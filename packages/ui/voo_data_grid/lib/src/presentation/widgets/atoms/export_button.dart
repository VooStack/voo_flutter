import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/data/services/data_grid_export_service.dart';
import 'package:voo_data_grid/src/domain/entities/export_config.dart';
import 'package:voo_data_grid/src/presentation/controllers/data_grid_controller.dart';

/// Export button widget for VooDataGrid
class ExportButton<T> extends StatelessWidget {
  /// The data grid controller
  final VooDataGridController<T> controller;

  /// Export configuration
  final ExportConfig? defaultConfig;

  /// Callback when export starts
  final VoidCallback? onExportStart;

  /// Callback when export completes
  final void Function(Uint8List data, String filename)? onExportComplete;

  /// Callback when export fails
  final void Function(Object error)? onExportError;

  /// Custom icon widget
  final Widget? icon;

  /// Button label
  final String? label;

  /// Whether to show dropdown for format selection
  final bool showFormatDropdown;

  /// Available export formats
  final List<ExportFormat> availableFormats;

  /// Custom button style
  final ButtonStyle? style;

  const ExportButton({
    super.key,
    required this.controller,
    this.defaultConfig,
    this.onExportStart,
    this.onExportComplete,
    this.onExportError,
    this.icon,
    this.label,
    this.showFormatDropdown = true,
    this.availableFormats = const [ExportFormat.pdf, ExportFormat.excel],
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    if (showFormatDropdown && availableFormats.length > 1) {
      return _buildDropdownButton(context);
    } else {
      return _buildSingleButton(context, availableFormats.first);
    }
  }

  Widget _buildDropdownButton(BuildContext context) =>
      PopupMenuButton<ExportFormat>(
      tooltip: 'Export data',
      icon: icon ?? const Icon(Icons.download),
      itemBuilder: (context) => availableFormats.map((format) =>
        PopupMenuItem<ExportFormat>(
          value: format,
          child: Row(
            children: [
              Icon(_getFormatIcon(format), size: 20),
              const SizedBox(width: 12),
              Text(_getFormatLabel(format)),
            ],
          ),
        )
      ).toList(),
      onSelected: (format) => _handleExport(context, format),
    );

  Widget _buildSingleButton(BuildContext context, ExportFormat format) {
    final buttonIcon = icon ?? Icon(_getFormatIcon(format));
    final buttonLabel = label ?? _getFormatLabel(format);

    if (label != null) {
      return ElevatedButton.icon(
        onPressed: () => _handleExport(context, format),
        icon: buttonIcon,
        label: Text(buttonLabel),
        style: style,
      );
    } else {
      return IconButton(
        onPressed: () => _handleExport(context, format),
        icon: buttonIcon,
        tooltip: 'Export as ${_getFormatLabel(format)}',
      );
    }
  }

  Future<void> _handleExport(BuildContext context, ExportFormat format) async {
    try {
      onExportStart?.call();

      // Get current data from controller
      final data = controller.dataSource.rows;
      final columns = controller.columns;
      final filters = controller.dataSource.filters;

      // Create export configuration
      final config = (defaultConfig ?? ExportConfig(format: format)).copyWith(
        format: format,
      );

      // Create export service
      final exportService = DataGridExportService<T>();

      // Export data
      final exportedData = await exportService.export(
        data: data,
        columns: columns,
        config: config,
        activeFilters: filters.isNotEmpty ? filters : null,
      );

      // Get filename
      final filename = exportService.getSuggestedFilename(config);

      // Handle export complete
      if (onExportComplete != null) {
        onExportComplete!(exportedData, filename);
      } else {
        // Default behavior: share or print
        await exportService.shareOrPrint(
          data: exportedData,
          filename: filename,
          format: format,
        );
      }

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully exported as ${_getFormatLabel(format)}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      onExportError?.call(error);

      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  IconData _getFormatIcon(ExportFormat format) => switch (format) {
        ExportFormat.pdf => Icons.picture_as_pdf,
        ExportFormat.excel => Icons.table_chart,
      };

  String _getFormatLabel(ExportFormat format) => switch (format) {
        ExportFormat.pdf => 'Export as PDF',
        ExportFormat.excel => 'Export as Excel',
      };
}