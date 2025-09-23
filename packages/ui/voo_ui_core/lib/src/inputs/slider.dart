import 'package:flutter/material.dart';
import 'package:voo_ui_core/src/foundations/design_system.dart';

/// Material 3 slider component
class VooSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final SemanticFormatterCallback? semanticFormatterCallback;
  final FocusNode? focusNode;
  final bool autofocus;
  final MouseCursor? mouseCursor;
  final SliderInteraction? allowedInteraction;
  final bool isError;

  const VooSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.semanticFormatterCallback,
    this.focusNode,
    this.autofocus = false,
    this.mouseCursor,
    this.allowedInteraction,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: isError ? colorScheme.error : activeColor,
        inactiveTrackColor: isError ? colorScheme.error.withValues(alpha: 0.3) : inactiveColor,
        thumbColor: isError ? colorScheme.error : thumbColor,
        overlayColor: isError ? colorScheme.error.withValues(alpha: 0.12) : null,
      ),
      child: Slider(
        value: value,
        onChanged: onChanged,
        onChangeStart: onChangeStart,
        onChangeEnd: onChangeEnd,
        min: min,
        max: max,
        divisions: divisions,
        label: label,
        activeColor: isError ? colorScheme.error : activeColor,
        inactiveColor: isError ? colorScheme.error.withValues(alpha: 0.3) : inactiveColor,
        thumbColor: isError ? colorScheme.error : thumbColor,
        semanticFormatterCallback: semanticFormatterCallback,
        focusNode: focusNode,
        autofocus: autofocus,
        mouseCursor: mouseCursor,
        allowedInteraction: allowedInteraction,
      ),
    );
  }
}

/// Material 3 range slider component
class VooRangeSlider extends StatelessWidget {
  final RangeValues values;
  final ValueChanged<RangeValues>? onChanged;
  final ValueChanged<RangeValues>? onChangeStart;
  final ValueChanged<RangeValues>? onChangeEnd;
  final double min;
  final double max;
  final int? divisions;
  final RangeLabels? labels;
  final Color? activeColor;
  final Color? inactiveColor;
  final SemanticFormatterCallback? semanticFormatterCallback;
  final bool isError;

  const VooRangeSlider({
    super.key,
    required this.values,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.labels,
    this.activeColor,
    this.inactiveColor,
    this.semanticFormatterCallback,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: isError ? colorScheme.error : activeColor,
        inactiveTrackColor: isError ? colorScheme.error.withValues(alpha: 0.3) : inactiveColor,
        thumbColor: isError ? colorScheme.error : null,
        overlayColor: isError ? colorScheme.error.withValues(alpha: 0.12) : null,
      ),
      child: RangeSlider(
        values: values,
        onChanged: onChanged,
        onChangeStart: onChangeStart,
        onChangeEnd: onChangeEnd,
        min: min,
        max: max,
        divisions: divisions,
        labels: labels,
        activeColor: isError ? colorScheme.error : activeColor,
        inactiveColor: isError ? colorScheme.error.withValues(alpha: 0.3) : inactiveColor,
        semanticFormatterCallback: semanticFormatterCallback,
      ),
    );
  }
}

/// Labeled slider with value display
class VooLabeledSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final String? helperText;
  final String? errorText;
  final Widget? leading;
  final Widget? trailing;
  final bool enabled;
  final bool showValue;
  final String Function(double)? valueFormatter;
  final Color? activeColor;
  final Color? inactiveColor;

  const VooLabeledSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.helperText,
    this.errorText,
    this.leading,
    this.trailing,
    this.enabled = true,
    this.showValue = true,
    this.valueFormatter,
    this.activeColor,
    this.inactiveColor,
  });

  String _formatValue(double value) {
    if (valueFormatter != null) {
      return valueFormatter!(value);
    }
    if (divisions != null) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final colorScheme = Theme.of(context).colorScheme;
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: hasError ? colorScheme.error : colorScheme.onSurfaceVariant)),
              if (showValue)
                Text(
                  _formatValue(value),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: hasError ? colorScheme.error : colorScheme.primary),
                ),
            ],
          ),
          SizedBox(height: design.spacingXs),
        ],
        Row(
          children: [
            if (leading != null) ...[leading!, SizedBox(width: design.spacingSm)],
            Expanded(
              child: VooSlider(
                value: value,
                onChanged: enabled ? onChanged : null,
                min: min,
                max: max,
                divisions: divisions,
                label: showValue ? _formatValue(value) : null,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                isError: hasError,
              ),
            ),
            if (trailing != null) ...[SizedBox(width: design.spacingSm), trailing!],
          ],
        ),
        if (helperText != null || errorText != null) ...[
          SizedBox(height: design.spacingXs),
          Text(
            errorText ?? helperText!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: hasError ? colorScheme.error : colorScheme.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}

/// Labeled range slider with value display
class VooLabeledRangeSlider extends StatelessWidget {
  final RangeValues values;
  final ValueChanged<RangeValues>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final String? helperText;
  final String? errorText;
  final Widget? leading;
  final Widget? trailing;
  final bool enabled;
  final bool showValues;
  final String Function(double)? valueFormatter;
  final Color? activeColor;
  final Color? inactiveColor;

  const VooLabeledRangeSlider({
    super.key,
    required this.values,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.helperText,
    this.errorText,
    this.leading,
    this.trailing,
    this.enabled = true,
    this.showValues = true,
    this.valueFormatter,
    this.activeColor,
    this.inactiveColor,
  });

  String _formatValue(double value) {
    if (valueFormatter != null) {
      return valueFormatter!(value);
    }
    if (divisions != null) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final colorScheme = Theme.of(context).colorScheme;
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: hasError ? colorScheme.error : colorScheme.onSurfaceVariant)),
              if (showValues)
                Text(
                  '${_formatValue(values.start)} - ${_formatValue(values.end)}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: hasError ? colorScheme.error : colorScheme.primary),
                ),
            ],
          ),
          SizedBox(height: design.spacingXs),
        ],
        Row(
          children: [
            if (leading != null) ...[leading!, SizedBox(width: design.spacingSm)],
            Expanded(
              child: VooRangeSlider(
                values: values,
                onChanged: enabled ? onChanged : null,
                min: min,
                max: max,
                divisions: divisions,
                labels: showValues ? RangeLabels(_formatValue(values.start), _formatValue(values.end)) : null,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                isError: hasError,
              ),
            ),
            if (trailing != null) ...[SizedBox(width: design.spacingSm), trailing!],
          ],
        ),
        if (helperText != null || errorText != null) ...[
          SizedBox(height: design.spacingXs),
          Text(
            errorText ?? helperText!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: hasError ? colorScheme.error : colorScheme.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}

/// Discrete slider with step indicators
class VooDiscreteSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int divisions;
  final List<String>? labels;
  final String? label;
  final bool enabled;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool showLabels;

  const VooDiscreteSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    required this.divisions,
    this.labels,
    this.label,
    this.enabled = true,
    this.activeColor,
    this.inactiveColor,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final steps = divisions + 1;
    final stepValue = (max - min) / divisions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[Text(label!, style: Theme.of(context).textTheme.bodyMedium), SizedBox(height: design.spacingSm)],
        VooSlider(
          value: value,
          onChanged: enabled ? onChanged : null,
          min: min,
          max: max,
          divisions: divisions,
          label: labels != null && labels!.isNotEmpty ? labels![((value - min) / stepValue).round()] : value.toStringAsFixed(0),
          activeColor: activeColor,
          inactiveColor: inactiveColor,
        ),
        if (showLabels && labels != null && labels!.length == steps) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: labels!.map((label) => Text(label, style: Theme.of(context).textTheme.labelSmall)).toList(),
            ),
          ),
        ],
      ],
    );
  }
}

/// Custom slider with tick marks
class VooTickMarkSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int tickCount;
  final String? label;
  final bool showTickLabels;
  final List<String>? tickLabels;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool enabled;

  const VooTickMarkSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 100.0,
    this.tickCount = 11,
    this.label,
    this.showTickLabels = false,
    this.tickLabels,
    this.activeColor,
    this.inactiveColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[Text(label!, style: Theme.of(context).textTheme.bodyMedium), SizedBox(height: design.spacingSm)],
        Stack(
          alignment: Alignment.center,
          children: [
            // Tick marks
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(tickCount, (index) {
                    final tickValue = min + (max - min) * index / (tickCount - 1);
                    final isActive = value >= tickValue;
                    return Container(
                      width: 2,
                      height: 8,
                      color: isActive ? (activeColor ?? colorScheme.primary) : (inactiveColor ?? colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
                    );
                  }),
                ),
              ),
            ),
            // Slider
            VooSlider(
              value: value,
              onChanged: enabled ? onChanged : null,
              min: min,
              max: max,
              divisions: tickCount - 1,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
            ),
          ],
        ),
        if (showTickLabels && tickLabels != null && tickLabels!.length == tickCount) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: tickLabels!.map((label) => Text(label, style: Theme.of(context).textTheme.labelSmall)).toList(),
            ),
          ),
        ],
      ],
    );
  }
}

/// Volume/intensity slider with icon indicators
class VooIconSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final IconData? startIcon;
  final IconData? endIcon;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final bool enabled;
  final Color? activeColor;
  final Color? inactiveColor;

  const VooIconSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.startIcon,
    this.endIcon,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.enabled = true,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[Text(label!, style: Theme.of(context).textTheme.bodyMedium), SizedBox(height: design.spacingSm)],
        Row(
          children: [
            if (startIcon != null) ...[
              Icon(startIcon, size: 20, color: enabled ? colorScheme.onSurfaceVariant : colorScheme.onSurface.withValues(alpha: 0.38)),
              SizedBox(width: design.spacingMd),
            ],
            Expanded(
              child: VooSlider(
                value: value,
                onChanged: enabled ? onChanged : null,
                min: min,
                max: max,
                divisions: divisions,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
              ),
            ),
            if (endIcon != null) ...[
              SizedBox(width: design.spacingMd),
              Icon(endIcon, size: 20, color: enabled ? colorScheme.onSurfaceVariant : colorScheme.onSurface.withValues(alpha: 0.38)),
            ],
          ],
        ),
      ],
    );
  }
}
