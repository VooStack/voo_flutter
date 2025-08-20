import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_logging_devtools_extension/presentation/theme/app_theme.dart';

/// Section configuration for the details panel
class DetailSection {
  final String title;
  final Widget content;
  final List<Widget> actions;
  final bool collapsible;
  final bool initiallyExpanded;

  const DetailSection({
    required this.title,
    required this.content,
    this.actions = const [],
    this.collapsible = false,
    this.initiallyExpanded = true,
  });
}

/// Universal details panel with consistent styling
class UniversalDetailsPanel extends StatelessWidget {
  final String title;
  final List<Widget> headerBadges;
  final List<DetailSection> sections;
  final VoidCallback onClose;
  final Color? accentColor;

  const UniversalDetailsPanel({
    super.key,
    required this.title,
    this.headerBadges = const [],
    required this.sections,
    required this.onClose,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          left: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(context),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: sections
                    .map(
                      (section) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppTheme.spacingLg,
                        ),
                        child: _buildSection(context, section),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: AppTheme.headerHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          if (accentColor != null) ...[
            Container(
              width: 3,
              height: 24,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
            const SizedBox(width: AppTheme.spacingMd),
          ],
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.getTitleStyle(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (headerBadges.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: headerBadges
                        .map(
                          (badge) => Padding(
                            padding: const EdgeInsets.only(
                              right: AppTheme.spacingSm,
                            ),
                            child: badge,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 18),
            onPressed: () => _copyAllToClipboard(context),
            tooltip: 'Copy all',
            splashRadius: 18,
          ),
          const SizedBox(width: AppTheme.spacingXs),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: onClose,
            tooltip: 'Close',
            splashRadius: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, DetailSection section) {
    final theme = Theme.of(context);

    if (section.collapsible) {
      return Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: _buildSectionTitle(context, section),
          initiallyExpanded: section.initiallyExpanded,
          childrenPadding: const EdgeInsets.only(top: AppTheme.spacingSm),
          tilePadding: EdgeInsets.zero,
          children: [section.content],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, section),
        const SizedBox(height: AppTheme.spacingSm),
        section.content,
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, DetailSection section) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          section.title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: accentColor ?? theme.colorScheme.primary,
          ),
        ),
        const Spacer(),
        ...section.actions,
      ],
    );
  }

  void _copyAllToClipboard(BuildContext context) {
    final buffer = StringBuffer();
    buffer.writeln('=== $title ===');

    for (final section in sections) {
      buffer.writeln('\n${section.title}:');
      // Extract text from section content
      // This is simplified - in production you'd want a more robust text extraction
      buffer.writeln(section.content.toString());
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Helper method to create a key-value row
  static Widget buildKeyValueRow(
    String key,
    String value, {
    bool monospace = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              key,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: TextStyle(
                fontSize: 12,
                fontFamily: monospace ? 'monospace' : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper method to create a code block
  static Widget buildCodeBlock(
    BuildContext context,
    String code, {
    String? language,
  }) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: SelectableText(code, style: AppTheme.getMonospaceStyle(context)),
    );
  }

  /// Helper to format JSON
  static String formatJson(dynamic json) {
    try {
      if (json is String) {
        return json;
      }
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(json);
    } catch (_) {
      return json.toString();
    }
  }
}
