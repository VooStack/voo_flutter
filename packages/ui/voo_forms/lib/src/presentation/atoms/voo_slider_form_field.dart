import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';

/// Atomic widget for slider form field
class VooSliderFormField extends StatelessWidget {
  final VooFormField field;
  final VooFieldOptions options;
  final ValueChanged<double>? onChanged;
  final String? error;
  final bool showError;

  const VooSliderFormField({
    super.key,
    required this.field,
    required this.options,
    this.onChanged,
    this.error,
    this.showError = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final value = (field.value as num?)?.toDouble() ?? 
                   field.min?.toDouble() ?? 0.0;
    final min = field.min?.toDouble() ?? 0.0;
    final max = field.max?.toDouble() ?? 100.0;
    final divisions = field.step != null 
        ? ((max - min) / field.step!).round()
        : null;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field.label != null && options.labelPosition != LabelPosition.hidden)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  field.label!,
                  style: options.textStyle ?? theme.textTheme.bodyMedium,
                ),
                Text(
                  value.toStringAsFixed(1),
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: theme.colorScheme.primary,
            inactiveTrackColor: theme.colorScheme.surfaceContainerHighest,
            thumbColor: theme.colorScheme.primary,
            overlayColor: theme.colorScheme.primary.withValues(alpha: 0.12),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: value.toStringAsFixed(1),
            onChanged: field.enabled ? (value) => onChanged?.call(value) : null,
          ),
        ),
        if (field.helper != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              field.helper!,
              style: options.helperStyle ?? 
                  theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        if (showError && error != null && (options.showErrorText ?? true))
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              error!,
              style: options.errorStyle ?? 
                  theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
            ),
          ),
      ],
    );
  }
}