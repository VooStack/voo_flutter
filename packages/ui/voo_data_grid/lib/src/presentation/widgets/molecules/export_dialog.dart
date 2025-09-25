import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/data/services/data_grid_export_service.dart';
import 'package:voo_data_grid/src/domain/entities/export_config.dart';
import 'package:voo_data_grid/src/presentation/controllers/data_grid_controller.dart';

/// Advanced export dialog for configuring export options
class ExportDialog<T> extends StatefulWidget {
  /// The data grid controller
  final VooDataGridController<T> controller;

  /// Initial export configuration
  final ExportConfig? initialConfig;

  /// Company logo bytes
  final Uint8List? companyLogo;

  const ExportDialog({super.key, required this.controller, this.initialConfig, this.companyLogo});

  @override
  State<ExportDialog<T>> createState() => _ExportDialogState<T>();
}

class _ExportDialogState<T> extends State<ExportDialog<T>> {
  late ExportFormat _selectedFormat;
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late TextEditingController _companyNameController;
  late TextEditingController _filenameController;
  bool _includeFilters = true;
  bool _includeTimestamp = true;
  bool _showRowNumbers = false;
  bool _isLandscape = true;
  int? _maxRows;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    final config = widget.initialConfig;
    _selectedFormat = config?.format ?? ExportFormat.pdf;
    _titleController = TextEditingController(text: config?.title ?? 'Data Export');
    _subtitleController = TextEditingController(text: config?.subtitle ?? '');
    _companyNameController = TextEditingController(text: config?.companyName ?? '');
    _filenameController = TextEditingController(text: config?.filename ?? '');
    _includeFilters = config?.includeFilters ?? true;
    _includeTimestamp = config?.includeTimestamp ?? true;
    _showRowNumbers = config?.showRowNumbers ?? false;
    _isLandscape = config?.isLandscape ?? true;
    _maxRows = config?.maxRows;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _companyNameController.dispose();
    _filenameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Dialog(
    child: Container(
      constraints: const BoxConstraints(maxWidth: 500),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.download, size: 28),
              const SizedBox(width: 12),
              const Text('Export Data', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
            ],
          ),
          const Divider(height: 24),

          // Format selection
          const Text('Export Format', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildFormatChip(ExportFormat.pdf, Icons.picture_as_pdf, 'PDF'),
              const SizedBox(width: 12),
              _buildFormatChip(ExportFormat.excel, Icons.table_chart, 'Excel'),
            ],
          ),
          const SizedBox(height: 16),

          // Document details
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Document Title', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _subtitleController,
            decoration: const InputDecoration(labelText: 'Subtitle (Optional)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _companyNameController,
            decoration: const InputDecoration(labelText: 'Company Name (Optional)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _filenameController,
            decoration: const InputDecoration(labelText: 'Filename (Optional)', border: OutlineInputBorder(), hintText: 'Leave empty for auto-generated name'),
          ),
          const SizedBox(height: 16),

          // Options
          const Text('Options', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          CheckboxListTile(
            value: _includeFilters,
            onChanged: (value) => setState(() => _includeFilters = value ?? true),
            title: const Text('Include active filters'),
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
          CheckboxListTile(
            value: _includeTimestamp,
            onChanged: (value) => setState(() => _includeTimestamp = value ?? true),
            title: const Text('Include timestamp'),
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
          CheckboxListTile(
            value: _showRowNumbers,
            onChanged: (value) => setState(() => _showRowNumbers = value ?? false),
            title: const Text('Show row numbers'),
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
          if (_selectedFormat == ExportFormat.pdf)
            CheckboxListTile(
              value: _isLandscape,
              onChanged: (value) => setState(() => _isLandscape = value ?? true),
              title: const Text('Landscape orientation'),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),

          // Row limit
          Row(
            children: [
              const Text('Max rows to export: '),
              const SizedBox(width: 12),
              SizedBox(
                width: 100,
                child: TextField(
                  decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'All'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _maxRows = value.isEmpty ? null : int.tryParse(value);
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: _isExporting ? null : () => Navigator.of(context).pop(), child: const Text('Cancel')),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _isExporting ? null : _handleExport,
                icon: _isExporting ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.download),
                label: Text(_isExporting ? 'Exporting...' : 'Export'),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _buildFormatChip(ExportFormat format, IconData icon, String label) {
    final isSelected = _selectedFormat == format;
    return ChoiceChip(
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() => _selectedFormat = format);
        }
      },
      avatar: Icon(icon, size: 18),
      label: Text(label),
    );
  }

  Future<void> _handleExport() async {
    setState(() => _isExporting = true);

    try {
      // Get current data from controller
      final data = widget.controller.dataSource.rows;
      final columns = widget.controller.columns;
      final filters = widget.controller.dataSource.filters;

      // Create export configuration
      final config = ExportConfig(
        format: _selectedFormat,
        title: _titleController.text.isNotEmpty ? _titleController.text : null,
        subtitle: _subtitleController.text.isNotEmpty ? _subtitleController.text : null,
        companyName: _companyNameController.text.isNotEmpty ? _companyNameController.text : null,
        companyLogo: widget.companyLogo,
        filename: _filenameController.text.isNotEmpty ? _filenameController.text : null,
        includeFilters: _includeFilters,
        includeTimestamp: _includeTimestamp,
        showRowNumbers: _showRowNumbers,
        isLandscape: _isLandscape,
        maxRows: _maxRows,
        primaryColor: Theme.of(context).primaryColor,
        accentColor: Theme.of(context).colorScheme.secondary,
      );

      // Create export service
      final exportService = DataGridExportService<T>();

      // Export data
      final exportedData = await exportService.export(data: data, columns: columns, config: config, activeFilters: filters.isNotEmpty ? filters : null);

      // Get filename
      final filename = exportService.getSuggestedFilename(config);

      // Share or save the file
      await exportService.shareOrPrint(data: exportedData, filename: filename, format: _selectedFormat);

      // Close dialog and show success
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Export completed successfully'), backgroundColor: Colors.green));
      }
    } catch (error) {
      // Show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export failed: $error'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }
}
