import 'package:flutter/material.dart';

/// Pure switch input atom - just the switch with no decoration
/// Used as a building block for boolean field molecules
class VooSwitchInput extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;
  final Color? activeThumbColor;
  final Color? inactiveThumbColor;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;

  const VooSwitchInput({
    super.key,
    required this.value,
    this.onChanged,
    this.enabled = true,
    this.activeThumbColor,
    this.inactiveThumbColor,
    this.activeTrackColor,
    this.inactiveTrackColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Switch(
      value: value,
      onChanged: enabled ? onChanged : null,
      activeThumbColor: activeThumbColor ?? theme.colorScheme.primary,
      inactiveThumbColor: inactiveThumbColor,
      activeTrackColor: activeTrackColor,
      inactiveTrackColor: inactiveTrackColor,
    );
  }
}