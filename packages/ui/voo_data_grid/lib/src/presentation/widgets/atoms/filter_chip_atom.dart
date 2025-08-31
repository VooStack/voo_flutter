import 'package:flutter/material.dart';

/// An atomic filter chip component for displaying active filters
class FilterChipAtom extends StatelessWidget {
  /// The label text to display
  final String label;
  
  /// Optional value to display alongside the label
  final String? value;
  
  /// Callback when the delete button is pressed
  final VoidCallback? onDeleted;
  
  /// Text style for the label
  final TextStyle? labelStyle;
  
  /// Size of the delete icon
  final double deleteIconSize;
  
  const FilterChipAtom({
    super.key,
    required this.label,
    this.value,
    this.onDeleted,
    this.labelStyle,
    this.deleteIconSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    final displayText = value != null ? '$label: $value' : label;
    
    return InputChip(
      label: Text(
        displayText,
        style: labelStyle ?? const TextStyle(fontSize: 12),
      ),
      deleteIcon: Icon(Icons.close, size: deleteIconSize),
      onDeleted: onDeleted,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}