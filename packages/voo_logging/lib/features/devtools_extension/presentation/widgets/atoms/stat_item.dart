import 'package:flutter/material.dart';

/// Atomic widget for displaying a single statistic
class StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Widget? leading;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const StatItem({super.key, required this.label, required this.value, this.leading, this.labelStyle, this.valueStyle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 8)],
          Expanded(child: Text(label, style: labelStyle ?? theme.textTheme.bodyMedium)),
          Text(value, style: valueStyle ?? theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
