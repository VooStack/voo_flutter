import 'package:flutter/material.dart';

/// An atomic action chip for clearing all filters
class ClearAllChip extends StatelessWidget {
  /// Callback when the chip is pressed
  final VoidCallback? onPressed;
  
  /// Custom label text
  final String label;
  
  /// Text style for the label
  final TextStyle? labelStyle;
  
  const ClearAllChip({
    super.key,
    this.onPressed,
    this.label = 'Clear All',
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) => ActionChip(
      label: Text(
        label,
        style: labelStyle ?? const TextStyle(fontSize: 12),
      ),
      onPressed: onPressed,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
}