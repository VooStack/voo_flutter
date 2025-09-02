import 'package:flutter/material.dart';

/// Pure checkbox input atom - just the checkbox with no decoration
/// Used as a building block for checkbox field molecules
class VooCheckboxInput extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final bool enabled;
  final bool tristate;
  final Color? activeColor;
  final Color? checkColor;
  final MaterialTapTargetSize? materialTapTargetSize;

  const VooCheckboxInput({
    super.key,
    required this.value,
    this.onChanged,
    this.enabled = true,
    this.tristate = false,
    this.activeColor,
    this.checkColor,
    this.materialTapTargetSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Checkbox(
      value: value,
      onChanged: enabled ? onChanged : null,
      tristate: tristate,
      activeColor: activeColor ?? theme.colorScheme.primary,
      checkColor: checkColor,
      materialTapTargetSize: materialTapTargetSize,
    );
  }
}