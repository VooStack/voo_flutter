import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_logging/features/logging/data/models/log_entry_model.dart';

class LogExportDialog extends StatefulWidget {
  final List<LogEntryModel> logs;

  const LogExportDialog({super.key, required this.logs});

  @override
  State<LogExportDialog> createState() => _LogExportDialogState();
}

class _LogExportDialogState extends State<LogExportDialog> {
  ExportFormat _selectedFormat = ExportFormat.json;
  bool _includeMetadata = true;
  bool _includeStackTrace = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Export Logs'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.logs.length} logs will be exported',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Export Format',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            ...ExportFormat.values.map(
              (format) => RadioListTile<ExportFormat>(
                title: Text(format.displayName),
                subtitle: Text(format.description),
                value: format,
                groupValue: _selectedFormat,
                onChanged: (value) {
                  setState(() {
                    _selectedFormat = value!;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Options',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              title: const Text('Include metadata'),
              value: _includeMetadata,
              onChanged: (value) {
                setState(() {
                  _includeMetadata = value!;
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              title: const Text('Include stack traces'),
              value: _includeStackTrace,
              onChanged: (value) {
                setState(() {
                  _includeStackTrace = value!;
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          icon: const Icon(Icons.content_copy),
          label: const Text('Copy to Clipboard'),
          onPressed: () => _exportToClipboard(context),
        ),
      ],
    );
  }

  Future<void> _exportToClipboard(BuildContext context) async {
    final exportedData = _exportLogs();
    await Clipboard.setData(ClipboardData(text: exportedData));
    
    if (context.mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.logs.length} logs copied to clipboard'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  String _exportLogs() {
    switch (_selectedFormat) {
      case ExportFormat.json:
        return _exportAsJson();
      case ExportFormat.csv:
        return _exportAsCsv();
      case ExportFormat.plainText:
        return _exportAsPlainText();
    }
  }

  String _exportAsJson() {
    final logs = widget.logs.map((log) {
      final json = {
        'id': log.id,
        'timestamp': log.timestamp.toIso8601String(),
        'level': log.level.name,
        'message': log.message,
        'category': log.category,
        'tag': log.tag,
      };

      if (_includeMetadata && log.metadata != null) {
        json['metadata'] = log.metadata!.toString();
      }

      if (_includeStackTrace && log.stackTrace != null) {
        json['stackTrace'] = log.stackTrace;
      }

      if (log.error != null) {
        json['error'] = log.error.toString();
      }

      return json;
    }).toList();

    return const JsonEncoder.withIndent('  ').convert({
      'exportedAt': DateTime.now().toIso8601String(),
      'totalLogs': logs.length,
      'logs': logs,
    });
  }

  String _exportAsCsv() {
    final buffer = StringBuffer();
    
    // Header
    buffer.write('Timestamp,Level,Category,Tag,Message');
    if (_includeMetadata) buffer.write(',Metadata');
    if (_includeStackTrace) buffer.write(',StackTrace');
    buffer.writeln();

    // Data
    for (final log in widget.logs) {
      buffer.write(_escapeCsv(log.timestamp.toIso8601String()));
      buffer.write(',${_escapeCsv(log.level.name)}');
      buffer.write(',${_escapeCsv(log.category ?? '')}');
      buffer.write(',${_escapeCsv(log.tag ?? '')}');
      buffer.write(',${_escapeCsv(log.message)}');
      
      if (_includeMetadata) {
        buffer.write(',${_escapeCsv(log.metadata?.toString() ?? '')}');
      }
      
      if (_includeStackTrace) {
        buffer.write(',${_escapeCsv(log.stackTrace ?? '')}');
      }
      
      buffer.writeln();
    }

    return buffer.toString();
  }

  String _exportAsPlainText() {
    final buffer = StringBuffer();
    
    buffer.writeln('=== Log Export ===');
    buffer.writeln('Exported at: ${DateTime.now()}');
    buffer.writeln('Total logs: ${widget.logs.length}');
    buffer.writeln('');

    for (final log in widget.logs) {
      buffer.writeln('[$log.timestamp}] [${log.level.name.toUpperCase()}] ${log.category ?? 'General'} - ${log.message}');
      
      if (log.tag != null) {
        buffer.writeln('  Tag: ${log.tag}');
      }
      
      if (_includeMetadata && log.metadata != null) {
        buffer.writeln('  Metadata: ${log.metadata}');
      }
      
      if (_includeStackTrace && log.stackTrace != null) {
        buffer.writeln('  Stack trace:');
        buffer.writeln('  ${log.stackTrace!.split('\n').join('\n  ')}');
      }
      
      if (log.error != null) {
        buffer.writeln('  Error: ${log.error}');
      }
      
      buffer.writeln();
    }

    return buffer.toString();
  }

  String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}

enum ExportFormat {
  json('JSON', 'Structured format for programmatic use'),
  csv('CSV', 'Spreadsheet compatible format'),
  plainText('Plain Text', 'Human-readable text format');

  final String displayName;
  final String description;

  const ExportFormat(this.displayName, this.description);
}