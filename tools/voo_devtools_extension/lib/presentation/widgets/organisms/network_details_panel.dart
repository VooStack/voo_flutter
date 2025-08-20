import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:voo_logging_devtools_extension/core/models/log_entry_model.dart';
import 'package:voo_logging_devtools_extension/core/models/network_request_model.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/universal_details_panel.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/method_badge.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/status_badge.dart';
import 'package:voo_logging_devtools_extension/presentation/theme/app_theme.dart';

class NetworkDetailsPanel extends StatelessWidget {
  final LogEntryModel? log;
  final NetworkRequestModel? request;
  final VoidCallback onClose;

  const NetworkDetailsPanel({
    super.key,
    this.log,
    this.request,
    required this.onClose,
  }) : assert(
         log != null || request != null,
         'Either log or request must be provided',
       );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Use request if available, otherwise convert log to request
    final networkRequest =
        request ??
        (log != null ? NetworkRequestModel.fromLogEntry(log!) : null);
    if (networkRequest == null) {
      return Container(); // Should never happen due to assert
    }

    final method = networkRequest.method;
    final url = networkRequest.url;
    final statusCode = networkRequest.statusCode;
    final duration = networkRequest.duration;
    final requestHeaders = networkRequest.requestHeaders;
    final responseHeaders = networkRequest.responseHeaders;
    final requestBody = networkRequest.requestBody;
    final responseBody = networkRequest.responseBody;
    final error = networkRequest.error;

    // Determine accent color based on status
    final accentColor = _getStatusColor(statusCode);

    // Build sections
    final sections = <DetailSection>[];

    // Request Overview section
    sections.add(
      DetailSection(
        title: 'Request Overview',
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                MethodBadge(method: method),
                const SizedBox(width: AppTheme.spacingSm),
                if (statusCode != null) StatusBadge(statusCode: statusCode),
                if (networkRequest.isInProgress) ...[
                  const SizedBox(width: AppTheme.spacingSm),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: networkRequest.hasTimedOut 
                          ? Colors.orange.withValues(alpha: 0.1)
                          : Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      border: Border.all(
                        color: networkRequest.hasTimedOut
                            ? Colors.orange.withValues(alpha: 0.3)
                            : Colors.blue.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!networkRequest.hasTimedOut) ...[
                          SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.blue,
                            ),
                          ),
                        ] else ...[
                          Icon(
                            Icons.timer_off_outlined,
                            size: 14,
                            color: Colors.orange,
                          ),
                        ],
                        const SizedBox(width: 6),
                        Text(
                          networkRequest.hasTimedOut ? 'Timeout' : 'Pending',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: networkRequest.hasTimedOut 
                                ? Colors.orange 
                                : Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            UniversalDetailsPanel.buildKeyValueRow('URL', url, monospace: true),
            if (duration != null)
              UniversalDetailsPanel.buildKeyValueRow(
                'Duration',
                '${duration}ms',
              ),
            UniversalDetailsPanel.buildKeyValueRow(
              'Timestamp',
              networkRequest.timestamp.toIso8601String(),
            ),
          ],
        ),
      ),
    );

    // Request Headers section
    if (requestHeaders != null && requestHeaders.isNotEmpty) {
      sections.add(
        DetailSection(
          title: 'Request Headers',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: requestHeaders.entries.map((entry) {
              return UniversalDetailsPanel.buildKeyValueRow(
                entry.key,
                entry.value.toString(),
                monospace: true,
              );
            }).toList(),
          ),
          collapsible: true,
          initiallyExpanded: false,
        ),
      );
    }

    // Request Body section
    if (requestBody != null && requestBody.isNotEmpty) {
      sections.add(
        DetailSection(
          title: 'Request Body',
          content: UniversalDetailsPanel.buildCodeBlock(
            context,
            _formatBody(requestBody),
          ),
          collapsible: true,
          initiallyExpanded: false,
        ),
      );
    }

    // Response Headers section
    if (responseHeaders != null && responseHeaders.isNotEmpty) {
      sections.add(
        DetailSection(
          title: 'Response Headers',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: responseHeaders.entries.map((entry) {
              return UniversalDetailsPanel.buildKeyValueRow(
                entry.key,
                entry.value.toString(),
                monospace: true,
              );
            }).toList(),
          ),
          collapsible: true,
          initiallyExpanded: false,
        ),
      );
    }

    // Response Body section
    if (responseBody != null && responseBody.isNotEmpty) {
      sections.add(
        DetailSection(
          title: 'Response Body',
          content: UniversalDetailsPanel.buildCodeBlock(
            context,
            _formatBody(responseBody),
          ),
          collapsible: true,
          initiallyExpanded: true,
        ),
      );
    }

    // Error section
    if (error != null) {
      sections.add(
        DetailSection(
          title: 'Error',
          content: Container(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              border: Border.all(
                color: theme.colorScheme.error.withValues(alpha: 0.5),
              ),
            ),
            child: SelectableText(
              error,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ),
      );
    }

    return UniversalDetailsPanel(
      title: _getTitle(method, statusCode),
      headerBadges: [
        MethodBadge(method: method),
        if (statusCode != null) StatusBadge(statusCode: statusCode),
        if (duration != null) _buildDurationBadge(context, duration),
      ],
      sections: sections,
      onClose: onClose,
      accentColor: accentColor,
    );
  }

  String _getTitle(String method, int? statusCode) {
    if (statusCode != null) {
      return '$method Request - $statusCode';
    }
    return '$method Request';
  }

  Widget _buildDurationBadge(BuildContext context, int duration) {
    final theme = Theme.of(context);
    final color = _getDurationColor(duration);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            '${duration}ms',
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(int? statusCode) {
    if (statusCode == null) return Colors.grey;
    if (statusCode >= 200 && statusCode < 300) return Colors.green;
    if (statusCode >= 300 && statusCode < 400) return Colors.blue;
    if (statusCode >= 400 && statusCode < 500) return Colors.orange;
    if (statusCode >= 500) return Colors.red;
    return Colors.grey;
  }

  Color _getDurationColor(int duration) {
    if (duration < 200) return Colors.green;
    if (duration < 500) return Colors.blue;
    if (duration < 1000) return Colors.amber;
    if (duration < 3000) return Colors.orange;
    return Colors.red;
  }

  String _formatBody(dynamic body) {
    if (body == null) return '';
    
    final bodyStr = body.toString();
    if (bodyStr.isEmpty) return '';
    
    try {
      // Try to parse as JSON for pretty printing
      final json = jsonDecode(bodyStr);
      return UniversalDetailsPanel.formatJson(json);
    } catch (_) {
      // Return as-is if not JSON
      return bodyStr;
    }
  }
}
