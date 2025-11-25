import 'package:flutter/material.dart';
import 'package:voo_devtools_extension/core/services/export_service.dart';
import 'package:voo_devtools_extension/presentation/theme/app_theme.dart';

/// Dialog for exporting data with format selection and preview
class ExportDialog extends StatefulWidget {
  final String title;
  final int itemCount;
  final String Function(ExportFormat format, bool pretty) getPreview;
  final void Function(ExportFormat format) onExport;
  final Future<bool> Function(String content) onCopy;

  const ExportDialog({
    super.key,
    required this.title,
    required this.itemCount,
    required this.getPreview,
    required this.onExport,
    required this.onCopy,
  });

  /// Show export dialog for logs
  static Future<void> showForLogs(
    BuildContext context,
    List<dynamic> logs,
  ) async {
    if (logs.isEmpty) {
      _showEmptyMessage(context, 'logs');
      return;
    }

    return showDialog(
      context: context,
      builder: (context) => ExportDialog(
        title: 'Export Logs',
        itemCount: logs.length,
        getPreview: (format, pretty) {
          switch (format) {
            case ExportFormat.json:
              return ExportService.logsToJson(
                logs.cast(),
                pretty: pretty,
              );
            case ExportFormat.csv:
              return ExportService.logsToCsv(logs.cast());
          }
        },
        onExport: (format) {
          ExportService.exportLogs(logs: logs.cast(), format: format);
        },
        onCopy: ExportService.copyToClipboard,
      ),
    );
  }

  /// Show export dialog for network requests
  static Future<void> showForNetwork(
    BuildContext context,
    List<dynamic> requests,
  ) async {
    if (requests.isEmpty) {
      _showEmptyMessage(context, 'network requests');
      return;
    }

    return showDialog(
      context: context,
      builder: (context) => ExportDialog(
        title: 'Export Network',
        itemCount: requests.length,
        getPreview: (format, pretty) {
          switch (format) {
            case ExportFormat.json:
              return ExportService.networkToJson(
                requests.cast(),
                pretty: pretty,
              );
            case ExportFormat.csv:
              return ExportService.networkToCsv(requests.cast());
          }
        },
        onExport: (format) {
          ExportService.exportNetwork(requests: requests.cast(), format: format);
        },
        onCopy: ExportService.copyToClipboard,
      ),
    );
  }

  /// Show export dialog for analytics events
  static Future<void> showForAnalytics(
    BuildContext context,
    List<dynamic> events,
  ) async {
    if (events.isEmpty) {
      _showEmptyMessage(context, 'analytics events');
      return;
    }

    return showDialog(
      context: context,
      builder: (context) => ExportDialog(
        title: 'Export Analytics',
        itemCount: events.length,
        getPreview: (format, pretty) {
          switch (format) {
            case ExportFormat.json:
              return ExportService.analyticsToJson(
                events.cast(),
                pretty: pretty,
              );
            case ExportFormat.csv:
              return ExportService.analyticsToCsv(events.cast());
          }
        },
        onExport: (format) {
          ExportService.exportAnalytics(events: events.cast(), format: format);
        },
        onCopy: ExportService.copyToClipboard,
      ),
    );
  }

  /// Show export dialog for performance metrics
  static Future<void> showForPerformance(
    BuildContext context,
    List<dynamic> metrics,
  ) async {
    if (metrics.isEmpty) {
      _showEmptyMessage(context, 'performance metrics');
      return;
    }

    return showDialog(
      context: context,
      builder: (context) => ExportDialog(
        title: 'Export Performance',
        itemCount: metrics.length,
        getPreview: (format, pretty) {
          switch (format) {
            case ExportFormat.json:
              return ExportService.performanceToJson(
                metrics.cast(),
                pretty: pretty,
              );
            case ExportFormat.csv:
              return ExportService.performanceToCsv(metrics.cast());
          }
        },
        onExport: (format) {
          ExportService.exportPerformance(
            metrics: metrics.cast(),
            format: format,
          );
        },
        onCopy: ExportService.copyToClipboard,
      ),
    );
  }

  static void _showEmptyMessage(BuildContext context, String dataType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('No $dataType to export'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  ExportFormat _selectedFormat = ExportFormat.json;
  bool _prettyPrint = true;
  bool _showPreview = false;
  bool _isCopying = false;

  String get _preview => widget.getPreview(_selectedFormat, _prettyPrint);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: _showPreview ? 700 : 400,
          maxHeight: 600,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            _buildHeader(theme, colorScheme),
            const Divider(height: 1),
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item count info
                    _buildInfoBanner(colorScheme),
                    const SizedBox(height: AppTheme.spacingLg),
                    // Format selection
                    Text(
                      'Export Format',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingSm),
                    _buildFormatSelection(colorScheme),
                    const SizedBox(height: AppTheme.spacingLg),
                    // Options
                    if (_selectedFormat == ExportFormat.json) ...[
                      _buildPrettyPrintOption(theme),
                      const SizedBox(height: AppTheme.spacingLg),
                    ],
                    // Preview toggle
                    _buildPreviewToggle(theme, colorScheme),
                    // Preview content
                    if (_showPreview) ...[
                      const SizedBox(height: AppTheme.spacingMd),
                      _buildPreviewContent(theme, colorScheme),
                    ],
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            // Actions
            _buildActions(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Row(
        children: [
          Icon(
            Icons.download,
            color: colorScheme.primary,
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Text(
            widget.title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: colorScheme.primary,
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Text(
            '${widget.itemCount} items will be exported',
            style: TextStyle(color: colorScheme.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatSelection(ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: _FormatCard(
            icon: Icons.code,
            label: 'JSON',
            description: 'Structured data format',
            isSelected: _selectedFormat == ExportFormat.json,
            onTap: () => setState(() => _selectedFormat = ExportFormat.json),
          ),
        ),
        const SizedBox(width: AppTheme.spacingMd),
        Expanded(
          child: _FormatCard(
            icon: Icons.table_chart,
            label: 'CSV',
            description: 'Spreadsheet compatible',
            isSelected: _selectedFormat == ExportFormat.csv,
            onTap: () => setState(() => _selectedFormat = ExportFormat.csv),
          ),
        ),
      ],
    );
  }

  Widget _buildPrettyPrintOption(ThemeData theme) {
    return Row(
      children: [
        Checkbox(
          value: _prettyPrint,
          onChanged: (value) => setState(() => _prettyPrint = value ?? true),
        ),
        const SizedBox(width: AppTheme.spacingSm),
        Text('Pretty print (formatted)', style: theme.textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildPreviewToggle(ThemeData theme, ColorScheme colorScheme) {
    return InkWell(
      onTap: () => setState(() => _showPreview = !_showPreview),
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingSm),
        child: Row(
          children: [
            Icon(
              _showPreview ? Icons.visibility_off : Icons.visibility,
              size: 20,
              color: colorScheme.primary,
            ),
            const SizedBox(width: AppTheme.spacingMd),
            Text(
              _showPreview ? 'Hide Preview' : 'Show Preview',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(
              _showPreview ? Icons.expand_less : Icons.expand_more,
              color: colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewContent(ThemeData theme, ColorScheme colorScheme) {
    final preview = _preview;
    final lines = preview.split('\n');
    final truncatedPreview =
        lines.length > 50 ? '${lines.take(50).join('\n')}\n\n... (truncated)' : preview;

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: SelectableText(
          truncatedPreview,
          style: theme.textTheme.bodySmall?.copyWith(
            fontFamily: 'monospace',
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  Widget _buildActions(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton.icon(
            onPressed: _isCopying
                ? null
                : () async {
                    setState(() => _isCopying = true);
                    final success = await widget.onCopy(_preview);
                    if (mounted) {
                      setState(() => _isCopying = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success
                                ? 'Copied to clipboard'
                                : 'Failed to copy',
                          ),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
            icon: _isCopying
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.primary,
                    ),
                  )
                : const Icon(Icons.copy),
            label: const Text('Copy'),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          FilledButton.icon(
            onPressed: () {
              widget.onExport(_selectedFormat);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Exported ${widget.itemCount} items as ${_selectedFormat.name.toUpperCase()}',
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.download),
            label: const Text('Download'),
          ),
        ],
      ),
    );
  }
}

class _FormatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _FormatCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: isSelected
          ? colorScheme.primaryContainer.withValues(alpha: 0.5)
          : colorScheme.surface,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppTheme.spacingSm),
              Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppTheme.spacingXs),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
