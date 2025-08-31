import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';

/// Slider form field widget
class VooSliderFieldWidget extends StatefulWidget {
  final VooFormField field;
  final VooFieldOptions options;
  final ValueChanged<double>? onChanged;
  final String? error;
  final bool showError;

  const VooSliderFieldWidget({
    super.key,
    required this.field,
    required this.options,
    this.onChanged,
    this.error,
    this.showError = true,
  });

  @override
  State<VooSliderFieldWidget> createState() => _VooSliderFieldWidgetState();
}

class _VooSliderFieldWidgetState extends State<VooSliderFieldWidget> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = (widget.field.value as num?)?.toDouble() ?? 
             widget.field.min?.toDouble() ?? 
             0.0;
  }

  @override
  void didUpdateWidget(VooSliderFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.field.value != widget.field.value) {
      _value = (widget.field.value as num?)?.toDouble() ?? 
               widget.field.min?.toDouble() ?? 
               0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final min = widget.field.min?.toDouble() ?? 0.0;
    final max = widget.field.max?.toDouble() ?? 100.0;
    final divisions = widget.field.divisions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.field.label != null &&
            widget.options.labelPosition != LabelPosition.hidden)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.field.label!,
                  style: widget.options.textStyle ?? theme.textTheme.bodyMedium,
                ),
                Text(
                  _value.toStringAsFixed(1),
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
            value: _value,
            min: min,
            max: max,
            divisions: divisions,
            label: _value.toStringAsFixed(1),
            onChanged: widget.field.enabled ? (value) {
              setState(() {
                _value = value;
              });
              widget.onChanged?.call(value);
              // Safely call field.onChanged with type checking
              try {
                final dynamic dynField = widget.field;
                final callback = dynField.onChanged;
                if (callback != null) {
                  callback(value);
                }
              } catch (_) {
                // Silently ignore type casting errors
              }
            } : null,
          ),
        ),
        if (widget.field.helper != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              widget.field.helper!,
              style: widget.options.helperStyle ??
                  theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        if (widget.showError && widget.error != null && widget.options.errorDisplayMode != ErrorDisplayMode.none)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.error!,
              style: widget.options.errorStyle ??
                  theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
            ),
          ),
      ],
    );
  }
}
