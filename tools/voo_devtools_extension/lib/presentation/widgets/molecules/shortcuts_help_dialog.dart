import 'package:flutter/material.dart';
import 'package:voo_devtools_extension/core/models/keyboard_shortcut.dart';
import 'package:voo_devtools_extension/presentation/theme/app_theme.dart';

/// Dialog showing all available keyboard shortcuts
class ShortcutsHelpDialog extends StatelessWidget {
  const ShortcutsHelpDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const ShortcutsHelpDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 500,
          maxHeight: 600,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppTheme.radiusLg),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.keyboard,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: AppTheme.spacingMd),
                  Text(
                    'Keyboard Shortcuts',
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
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),
            // Shortcuts list
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final entry in AppShortcuts.allShortcuts.entries) ...[
                      _ShortcutCategory(
                        title: entry.key,
                        shortcuts: entry.value,
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                    ],
                  ],
                ),
              ),
            ),
            // Footer hint
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(AppTheme.radiusLg),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                  Text(
                    'Press Esc to close this dialog',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShortcutCategory extends StatelessWidget {
  final String title;
  final List<KeyboardShortcut> shortcuts;

  const _ShortcutCategory({
    required this.title,
    required this.shortcuts,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            children: [
              for (var i = 0; i < shortcuts.length; i++) ...[
                _ShortcutRow(shortcut: shortcuts[i]),
                if (i < shortcuts.length - 1)
                  Divider(
                    height: 1,
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ShortcutRow extends StatelessWidget {
  final KeyboardShortcut shortcut;

  const _ShortcutRow({required this.shortcut});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shortcut.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  shortcut.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          _KeyboardKey(keyLabel: shortcut.displayString),
        ],
      ),
    );
  }
}

class _KeyboardKey extends StatelessWidget {
  final String keyLabel;

  const _KeyboardKey({required this.keyLabel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Split by + for non-Mac style or by empty for Mac symbols
    final parts = keyLabel.contains('+')
        ? keyLabel.split('+')
        : keyLabel.split('');

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < parts.length; i++) ...[
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingSm,
              vertical: AppTheme.spacingXs,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  offset: const Offset(0, 1),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Text(
              parts[i].trim(),
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          if (i < parts.length - 1 && keyLabel.contains('+'))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                '+',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
              ),
            ),
        ],
      ],
    );
  }
}
