import 'package:flutter/material.dart';

/// A molecule component for checkbox filter input
class CheckboxFilterFieldMolecule extends StatelessWidget {
  /// The current checkbox value
  final bool value;
  
  /// Callback when value changes
  final void Function(bool?) onChanged;
  
  /// Label text for the checkbox
  final String label;
  
  /// Whether the checkbox is enabled
  final bool enabled;
  
  /// Position of the checkbox control
  final ListTileControlAffinity controlAffinity;
  
  /// Content padding
  final EdgeInsets? contentPadding;
  
  const CheckboxFilterFieldMolecule({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.enabled = true,
    this.controlAffinity = ListTileControlAffinity.leading,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(label),
      value: value,
      onChanged: enabled ? onChanged : null,
      controlAffinity: controlAffinity,
      contentPadding: contentPadding ?? EdgeInsets.zero,
    );
  }
}