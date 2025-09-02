import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/enums/label_position.dart';

/// Widget that wraps a field with a label based on label position
/// Following atomic design principles - this is a molecule component
class FieldLabelWrapper extends StatelessWidget {
  final Widget child;
  final String label;
  final LabelPosition labelPosition;
  final TextStyle? textStyle;

  const FieldLabelWrapper({
    super.key,
    required this.child,
    required this.label,
    required this.labelPosition,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelWidget = Text(
      label,
      style: textStyle ?? theme.textTheme.bodyMedium,
    );

    switch (labelPosition) {
      case LabelPosition.left:
        return Row(
          children: [
            SizedBox(
              width: 120,
              child: labelWidget,
            ),
            const SizedBox(width: 16),
            Expanded(child: child),
          ],
        );
      case LabelPosition.above:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            labelWidget,
            const SizedBox(height: 8),
            child,
          ],
        );
      case LabelPosition.floating:
      case LabelPosition.placeholder:
      default:
        // For floating and placeholder positions, the label is handled by the field itself
        return child;
    }
  }
}
