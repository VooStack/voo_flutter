import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:voo_adaptive_overlay/voo_adaptive_overlay.dart';
import 'package:voo_data_grid/src/data/services/data_grid_export_service.dart';
import 'package:voo_data_grid/src/domain/entities/export_config.dart';
import 'package:voo_data_grid/src/presentation/controllers/data_grid_controller.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Shows the export dialog using adaptive overlay
Future<void> showExportDialog<T>({
  required BuildContext context,
  required VooDataGridController<T> controller,
  ExportConfig? initialConfig,
  Uint8List? companyLogo,
}) =>
    VooAdaptiveOverlay.show(
      context: context,
      title: const Row(
        children: [
          Icon(Icons.download),
          SizedBox(width: 8),
          Text('Export Data'),
        ],
      ),
      builder: (ctx, scrollController) => _ExportDialogContent<T>(
        controller: controller,
        initialConfig: initialConfig,
        companyLogo: companyLogo,
        scrollController: scrollController,
      ),
      config: const VooOverlayConfig(
        constraints: VooOverlayConstraints(
          maxWidth: 500,
          maxHeight: 600,
        ),
      ),
    );

/// Export dialog content widget
class _ExportDialogContent<T> extends StatefulWidget {
  final VooDataGridController<T> controller;
  final ExportConfig? initialConfig;
  final Uint8List? companyLogo;
  final ScrollController? scrollController;

  const _ExportDialogContent({
    required this.controller,
    this.initialConfig,
    this.companyLogo,
    this.scrollController,
  });

  @override
  State<_ExportDialogContent<T>> createState() => _ExportDialogContentState<T>();
}

class _ExportDialogContentState<T> extends State<_ExportDialogContent<T>> {
  late ExportFormat _selectedFormat;
  late PdfLayoutType _selectedPdfLayout;
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late TextEditingController _companyNameController;
  late TextEditingController _filenameController;
  late TextEditingController _maxRowsController;
  bool _includeFilters = true;
  bool _includeTimestamp = true;
  bool _showRowNumbers = false;
  bool _isLandscape = true;
  bool _isExporting = false;
  List<String> _selectedColumns = [];
  bool _selectAllColumns = true;

  @override
  void initState() {
    super.initState();
    final config = widget.initialConfig;
    _selectedFormat = config?.format ?? ExportFormat.pdf;
    _selectedPdfLayout = config?.pdfLayoutType ?? PdfLayoutType.grid;
    _titleController = TextEditingController(text: config?.title ?? 'Data Export');
    _subtitleController = TextEditingController(text: config?.subtitle ?? '');
    _companyNameController = TextEditingController(text: config?.companyName ?? '');
    _filenameController = TextEditingController(text: config?.filename ?? '');
    _maxRowsController = TextEditingController(text: config?.maxRows?.toString() ?? '');
    _includeFilters = config?.includeFilters ?? true;
    _includeTimestamp = config?.includeTimestamp ?? true;
    _showRowNumbers = config?.showRowNumbers ?? false;
    _isLandscape = config?.isLandscape ?? true;
    _selectedColumns = widget.controller.columns.where((col) => col.visible).map((col) => col.field).toList();
    _selectAllColumns = true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _companyNameController.dispose();
    _filenameController.dispose();
    _maxRowsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: SingleChildScrollView(
            controller: widget.scrollController,
            padding: EdgeInsets.symmetric(horizontal: context.vooSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFormatSection(context, theme),
                SizedBox(height: context.vooSpacing.md),
                if (_selectedFormat == ExportFormat.pdf) ...[
                  _buildPdfLayoutSection(context, theme),
                  SizedBox(height: context.vooSpacing.md),
                ],
                _buildColumnSelection(context, theme),
                SizedBox(height: context.vooSpacing.md),
                _buildDocumentDetails(context),
                SizedBox(height: context.vooSpacing.md),
                _buildOptionsSection(context, theme),
                SizedBox(height: context.vooSpacing.md),
              ],
            ),
          ),
        ),
        const Divider(height: 1),
        _buildActions(context),
      ],
    );
  }

  Widget _buildFormatSection(BuildContext context, ThemeData theme) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Export Format', style: context.vooTypography.labelMedium),
          SizedBox(height: context.vooSpacing.xs),
          Wrap(
            spacing: context.vooSpacing.sm,
            children: [
              _buildFormatChip(ExportFormat.pdf, Icons.picture_as_pdf, 'PDF'),
              _buildFormatChip(ExportFormat.excel, Icons.table_chart, 'Excel'),
            ],
          ),
        ],
      );

  Widget _buildFormatChip(ExportFormat format, IconData icon, String label) => ChoiceChip(
        selected: _selectedFormat == format,
        onSelected: (selected) {
          if (selected) setState(() => _selectedFormat = format);
        },
        avatar: Icon(icon, size: context.vooSize.iconSmall),
        label: Text(label),
      );

  Widget _buildPdfLayoutSection(BuildContext context, ThemeData theme) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('PDF Layout', style: context.vooTypography.labelMedium),
          SizedBox(height: context.vooSpacing.xs),
          Wrap(
            spacing: context.vooSpacing.xs,
            runSpacing: context.vooSpacing.xs,
            children: [
              _buildLayoutChip(PdfLayoutType.grid, Icons.grid_on, 'Grid', 'Traditional table'),
              _buildLayoutChip(PdfLayoutType.list, Icons.view_list, 'List', 'Card-based'),
              _buildLayoutChip(PdfLayoutType.compact, Icons.compress, 'Compact', 'Dense'),
            ],
          ),
        ],
      );

  Widget _buildLayoutChip(PdfLayoutType layout, IconData icon, String label, String tooltip) => Tooltip(
        message: tooltip,
        child: ChoiceChip(
          selected: _selectedPdfLayout == layout,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _selectedPdfLayout = layout;
                if (layout == PdfLayoutType.compact) _isLandscape = true;
              });
            }
          },
          avatar: Icon(icon, size: context.vooSize.iconSmall),
          label: Text(label),
        ),
      );

  Widget _buildColumnSelection(BuildContext context, ThemeData theme) {
    final visibleColumns = widget.controller.columns.where((col) => col.visible).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Columns to Export', style: context.vooTypography.labelMedium),
        SizedBox(height: context.vooSpacing.xs),
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: theme.dividerColor),
            borderRadius: BorderRadius.circular(context.vooRadius.sm),
          ),
          child: Column(
            children: [
              CheckboxListTile(
                value: _selectAllColumns,
                onChanged: (value) {
                  setState(() {
                    _selectAllColumns = value ?? true;
                    _selectedColumns = _selectAllColumns ? visibleColumns.map((col) => col.field).toList() : [];
                  });
                },
                title: Text('Select All', style: context.vooTypography.labelSmall.copyWith(fontWeight: FontWeight.bold)),
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const Divider(height: 1),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 120),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: visibleColumns.length,
                  itemBuilder: (context, index) {
                    final column = visibleColumns[index];
                    return CheckboxListTile(
                      value: _selectedColumns.contains(column.field),
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _selectedColumns.add(column.field);
                          } else {
                            _selectedColumns.remove(column.field);
                          }
                          _selectAllColumns = _selectedColumns.length == visibleColumns.length;
                        });
                      },
                      title: Text(column.label, style: context.vooTypography.labelSmall),
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentDetails(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Document Details', style: context.vooTypography.labelMedium),
          SizedBox(height: context.vooSpacing.xs),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              border: const OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.all(context.vooSpacing.sm),
            ),
          ),
          SizedBox(height: context.vooSpacing.sm),
          TextField(
            controller: _subtitleController,
            decoration: InputDecoration(
              labelText: 'Subtitle',
              border: const OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.all(context.vooSpacing.sm),
            ),
          ),
          SizedBox(height: context.vooSpacing.sm),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _companyNameController,
                  decoration: InputDecoration(
                    labelText: 'Company',
                    border: const OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.all(context.vooSpacing.sm),
                  ),
                ),
              ),
              SizedBox(width: context.vooSpacing.sm),
              Expanded(
                child: TextField(
                  controller: _filenameController,
                  decoration: InputDecoration(
                    labelText: 'Filename',
                    hintText: 'Auto',
                    border: const OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.all(context.vooSpacing.sm),
                  ),
                ),
              ),
            ],
          ),
        ],
      );

  Widget _buildOptionsSection(BuildContext context, ThemeData theme) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Options', style: context.vooTypography.labelMedium),
          SizedBox(height: context.vooSpacing.xs),
          Wrap(
            spacing: context.vooSpacing.md,
            children: [
              _buildCheckbox('Include filters', _includeFilters, (v) => setState(() => _includeFilters = v ?? true)),
              _buildCheckbox('Include timestamp', _includeTimestamp, (v) => setState(() => _includeTimestamp = v ?? true)),
              _buildCheckbox('Show row numbers', _showRowNumbers, (v) => setState(() => _showRowNumbers = v ?? false)),
              if (_selectedFormat == ExportFormat.pdf)
                _buildCheckbox('Landscape', _isLandscape, (v) => setState(() => _isLandscape = v ?? true)),
            ],
          ),
          SizedBox(height: context.vooSpacing.sm),
          Row(
            children: [
              Text('Max rows:', style: context.vooTypography.labelSmall),
              SizedBox(width: context.vooSpacing.sm),
              SizedBox(
                width: 80,
                child: TextField(
                  controller: _maxRowsController,
                  decoration: InputDecoration(
                    hintText: 'All',
                    border: const OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.all(context.vooSpacing.xs),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      );

  Widget _buildCheckbox(String label, bool value, ValueChanged<bool?> onChanged) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(value: value, onChanged: onChanged, visualDensity: VisualDensity.compact),
          Text(label, style: context.vooTypography.labelSmall),
        ],
      );

  Widget _buildActions(BuildContext context) => Padding(
        padding: EdgeInsets.all(context.vooSpacing.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: _isExporting ? null : () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            SizedBox(width: context.vooSpacing.sm),
            FilledButton.icon(
              onPressed: _isExporting ? null : _handleExport,
              icon: _isExporting
                  ? SizedBox(
                      width: context.vooSize.iconSmall,
                      height: context.vooSize.iconSmall,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.download),
              label: Text(_isExporting ? 'Exporting...' : 'Export'),
            ),
          ],
        ),
      );

  Future<void> _handleExport() async {
    setState(() => _isExporting = true);

    try {
      final data = widget.controller.dataSource.rows;
      final columns = widget.controller.columns;
      final filters = widget.controller.dataSource.filters;
      final maxRows = _maxRowsController.text.isEmpty ? null : int.tryParse(_maxRowsController.text);

      final config = ExportConfig(
        format: _selectedFormat,
        pdfLayoutType: _selectedPdfLayout,
        selectedColumns: _selectedColumns.isEmpty ? null : _selectedColumns,
        title: _titleController.text.isNotEmpty ? _titleController.text : null,
        subtitle: _subtitleController.text.isNotEmpty ? _subtitleController.text : null,
        companyName: _companyNameController.text.isNotEmpty ? _companyNameController.text : null,
        companyLogo: widget.companyLogo,
        filename: _filenameController.text.isNotEmpty ? _filenameController.text : null,
        includeFilters: _includeFilters,
        includeTimestamp: _includeTimestamp,
        showRowNumbers: _showRowNumbers,
        isLandscape: _isLandscape,
        maxRows: maxRows,
        primaryColor: Theme.of(context).primaryColor,
        accentColor: Theme.of(context).colorScheme.secondary,
      );

      final exportService = DataGridExportService<T>();
      final exportedData = await exportService.export(
        data: data,
        columns: columns,
        config: config,
        activeFilters: filters.isNotEmpty ? filters : null,
      );
      final filename = exportService.getSuggestedFilename(config);
      await exportService.shareOrPrint(data: exportedData, filename: filename, format: _selectedFormat);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Export completed'), backgroundColor: Colors.green),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $error'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }
}

/// Legacy export dialog class for backwards compatibility
@Deprecated('Use showExportDialog instead')
class ExportDialog<T> extends StatelessWidget {
  final VooDataGridController<T> controller;
  final ExportConfig? initialConfig;
  final Uint8List? companyLogo;

  const ExportDialog({
    super.key,
    required this.controller,
    this.initialConfig,
    this.companyLogo,
  });

  @override
  Widget build(BuildContext context) {
    // Redirect to adaptive overlay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pop();
      showExportDialog(
        context: context,
        controller: controller,
        initialConfig: initialConfig,
        companyLogo: companyLogo,
      );
    });
    return const SizedBox.shrink();
  }
}
