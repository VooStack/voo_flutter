import 'package:flutter/material.dart';

/// Atomic widget for displaying a key-value pair as a row
class StatRow extends StatelessWidget {
  final String label;
  final String value;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment? mainAxisAlignment;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const StatRow({
    super.key,
    required this.label,
    required this.value,
    this.padding,
    this.mainAxisAlignment,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: labelStyle ?? theme.textTheme.bodyMedium),
          Text(
            value,
            style:
                valueStyle ??
                theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
