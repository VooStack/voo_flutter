import 'package:flutter/material.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// A read-only field widget that displays a value in a clean, detail view format
/// This is used when fields are in read-only mode to provide a better UX than disabled inputs
/// Note: Labels should be handled by the parent field widget, not here
class VooReadOnlyField extends StatelessWidget {
  final String value;
  final Widget? icon;
  final bool showBorder;

  const VooReadOnlyField({super.key, required this.value, this.icon, this.showBorder = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.vooSpacing;
    final radius = context.vooRadius;
    final size = context.vooSize;

    return Container(
      height: size.inputHeight,
      padding: EdgeInsets.symmetric(horizontal: spacing.inputPadding),
      decoration: BoxDecoration(
        color: showBorder ? theme.colorScheme.surface : Colors.transparent,
        borderRadius: radius.input,
        border: showBorder ? Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)) : null,
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            IconTheme(
              data: IconThemeData(size: size.iconMedium, color: theme.colorScheme.onSurfaceVariant),
              child: icon!,
            ),
            SizedBox(width: spacing.inputPadding),
          ],
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                value.isEmpty ? '—' : value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: value.isEmpty ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5) : theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
