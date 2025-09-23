import 'package:flutter/material.dart';

/// A molecule component for checkbox filter input
class CheckboxFilterField extends StatelessWidget {
  /// The current checkbox value
  final bool value;

  /// Callback when value changes
  final void Function(bool?) onChanged;

  /// Label text for the checkbox
  final String? label;

  /// Whether the checkbox is enabled
  final bool enabled;

  /// Position of the checkbox control
  final ListTileControlAffinity controlAffinity;

  /// Content padding
  final EdgeInsets? contentPadding;

  /// Custom height for filter styling
  final double? height;

  /// Whether to use compact filter styling (no label, just checkbox)
  final bool compactStyle;

  const CheckboxFilterField({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.enabled = true,
    this.controlAffinity = ListTileControlAffinity.leading,
    this.contentPadding,
    this.height,
    this.compactStyle = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compactStyle) {
      return SizedBox(
        height: height ?? 32,
        child: Center(
          child: Checkbox(value: value, onChanged: enabled ? onChanged : null, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
        ),
      );
    }

    return CheckboxListTile(
      title: label != null ? Text(label!) : null,
      value: value,
      onChanged: enabled ? onChanged : null,
      controlAffinity: controlAffinity,
      contentPadding: contentPadding ?? EdgeInsets.zero,
    );
  }
}
