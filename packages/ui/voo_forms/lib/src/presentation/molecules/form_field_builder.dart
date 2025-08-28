import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/field_type.dart';
import 'package:voo_forms/src/domain/entities/form.dart';
import 'package:voo_forms/src/domain/entities/form_config.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/atoms/voo_text_form_field.dart';
import 'package:voo_forms/src/presentation/controllers/form_controller.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart' hide VooFieldOptions;

/// Enhanced form field builder with consistent theming
class VooFormFieldBuilder extends StatelessWidget {
  final VooFormField field;
  final VooFormController controller;
  final VooFormConfig? config;
  final bool showError;
  final EdgeInsetsGeometry? padding;

  const VooFormFieldBuilder({
    super.key,
    required this.field,
    required this.controller,
    this.config,
    this.showError = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (!field.visible) {
      return const SizedBox.shrink();
    }

    final formConfig = config ?? const VooFormConfig();

    Widget fieldWidget = _buildFieldWidget(context, formConfig);
    
    if (padding != null || formConfig.padding != null) {
      fieldWidget = Padding(
        padding: padding ?? formConfig.padding!,
        child: fieldWidget,
      );
    }

    return fieldWidget;
  }

  Widget _buildFieldWidget(BuildContext context, VooFormConfig config) {
    final theme = Theme.of(context);
    
    switch (field.type) {
      case VooFieldType.text:
      case VooFieldType.number:
      case VooFieldType.email:
      case VooFieldType.password:
      case VooFieldType.phone:
      case VooFieldType.url:
      case VooFieldType.multiline:
        return VooTextFormField(
          field: _applyConfigToField(context, config, field),
          controller: controller.getTextController(field.id),
          focusNode: controller.getFocusNode(field.id),
          onChanged: (value) => controller.setValue(field.id, value),
          onEditingComplete: () => controller.focusNextField(field.id),
          onSubmitted: (value) {
            controller.setValue(field.id, value);
            if (controller.form.validationMode == FormValidationMode.onSubmit) {
              controller.validateField(field.id);
            }
          },
          error: controller.getError(field.id),
          showError: showError && config.errorDisplayMode != ErrorDisplayMode.none,
          decoration: _buildDecoration(context, config),
        );
        
      case VooFieldType.boolean:
        return _buildSwitchField(context, config);
        
      case VooFieldType.checkbox:
        return _buildCheckboxField(context, config);
        
      case VooFieldType.dropdown:
        return _buildDropdownField(context, config);
        
      case VooFieldType.radio:
        return _buildRadioField(context, config);
        
      case VooFieldType.slider:
        return _buildSliderField(context, config);
        
      case VooFieldType.date:
        return _buildDateField(context, config);
        
      case VooFieldType.time:
        return _buildTimeField(context, config);
        
      case VooFieldType.dateTime:
        return _buildDateTimeField(context, config);
        
      case VooFieldType.multiSelect:
        return _buildMultiSelectField(context, config);
        
      case VooFieldType.file:
        return _buildFileField(context, config);
        
      case VooFieldType.color:
        return _buildColorField(context, config);
        
      case VooFieldType.rating:
        return _buildRatingField(context, config);
        
      case VooFieldType.custom:
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            'Custom field: ${field.customWidgetType ?? field.type}',
            style: theme.textTheme.bodyMedium,
          ),
        );
    }
  }

  InputDecoration _buildDecoration(BuildContext context, VooFormConfig config) {
    final theme = Theme.of(context);
    
    // Build label with required indicator
    String? labelText = field.label;
    if (labelText != null && field.required && config.showRequiredIndicator) {
      labelText = '$labelText ${config.requiredIndicator}';
    }

    // Apply label position
    if (config.labelPosition == LabelPosition.hidden) {
      labelText = null;
    }

    final baseDecoration = InputDecoration(
      labelText: config.labelPosition == LabelPosition.floating ? labelText : null,
      hintText: field.hint,
      helperText: field.helper,
      errorText: showError ? controller.getError(field.id) : null,
      prefixIcon: field.prefixIcon != null && config.showFieldIcons 
          ? Icon(field.prefixIcon) 
          : null,
      suffixIcon: field.suffixIcon != null ? Icon(field.suffixIcon) : null,
      contentPadding: config.getFieldPadding(),
    );

    // Apply field variant styling
    switch (config.fieldVariant) {
      case FieldVariant.filled:
        return baseDecoration.copyWith(
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
        );
        
      case FieldVariant.underlined:
        return baseDecoration.copyWith(
          border: const UnderlineInputBorder(),
        );
        
      case FieldVariant.ghost:
        return baseDecoration.copyWith(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2.0,
            ),
          ),
        );
        
      case FieldVariant.outlined:
        return baseDecoration;
        
      case FieldVariant.rounded:
        return baseDecoration.copyWith(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: BorderSide(
              color: theme.colorScheme.outline,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2.0,
            ),
          ),
        );
        
      case FieldVariant.sharp:
        return baseDecoration.copyWith(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(
              color: theme.colorScheme.outline,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2.0,
            ),
          ),
        );
    }
  }

  Widget _buildLabel(BuildContext context, VooFormConfig config) {
    if (field.label == null || config.labelPosition == LabelPosition.hidden) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    String labelText = field.label!;
    
    if (field.required && config.showRequiredIndicator) {
      labelText = '$labelText ${config.requiredIndicator}';
    }

    return Padding(
      padding: EdgeInsets.only(bottom: config.fieldSpacing / 2),
      child: Text(
        labelText,
        style: config.getLabelStyle(context) ?? theme.textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildSwitchField(BuildContext context, VooFormConfig config) {
    final theme = Theme.of(context);
    final value = controller.getValue(field.id) as bool? ?? false;
    
    return Row(
      children: [
        Expanded(
          child: config.labelPosition != LabelPosition.floating
              ? _buildLabel(context, config)
              : Text(
                  field.label ?? '',
                  style: theme.textTheme.bodyLarge,
                ),
        ),
        Switch.adaptive(
          value: value,
          onChanged: field.enabled && !field.readOnly
              ? (value) => controller.setValue(field.id, value)
              : null,
          activeTrackColor: theme.colorScheme.primary.withValues(alpha: 0.5),
          inactiveThumbColor: theme.colorScheme.outline,
          inactiveTrackColor: theme.colorScheme.surfaceContainerHighest,
        ),
      ],
    );
  }

  Widget _buildCheckboxField(BuildContext context, VooFormConfig config) {
    final theme = Theme.of(context);
    final value = controller.getValue(field.id) as bool? ?? false;
    
    return CheckboxListTile(
      value: value,
      onChanged: field.enabled && !field.readOnly
          ? (value) => controller.setValue(field.id, value)
          : null,
      title: Text(
        field.label ?? '',
        style: theme.textTheme.bodyLarge,
      ),
      subtitle: field.helper != null 
          ? Text(
              field.helper!,
              style: theme.textTheme.bodySmall,
            )
          : null,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      activeColor: theme.colorScheme.primary,
      checkColor: theme.colorScheme.onPrimary,
    );
  }

  Widget _buildDropdownField(BuildContext context, VooFormConfig config) {
    final theme = Theme.of(context);
    final value = controller.getValue(field.id);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (config.labelPosition == LabelPosition.above)
          _buildLabel(context, config),
        DropdownButtonFormField<dynamic>(
          initialValue: field.options?.any((o) => o.value == value) ?? false ? value : null,
          decoration: _buildDecoration(context, config),
          items: field.options?.map((option) {
            return DropdownMenuItem(
              value: option.value,
              enabled: option.enabled,
              child: Row(
                children: [
                  if (option.icon != null) ...[
                    Icon(option.icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(option.label),
                ],
              ),
            );
          }).toList(),
          onChanged: field.enabled && !field.readOnly
              ? (value) => controller.setValue(field.id, value)
              : null,
          style: theme.textTheme.bodyLarge,
          dropdownColor: theme.colorScheme.surface,
          icon: Icon(
            Icons.arrow_drop_down,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildRadioField(BuildContext context, VooFormConfig config) {
    final theme = Theme.of(context);
    final value = controller.getValue(field.id);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (config.labelPosition != LabelPosition.hidden)
          _buildLabel(context, config),
        ...?field.options?.map((option) {
          return RadioListTile<dynamic>(
            value: option.value,
            groupValue: value,
            onChanged: field.enabled && !field.readOnly && option.enabled
                ? (value) => controller.setValue(field.id, value)
                : null,
            title: Text(
              option.label,
              style: theme.textTheme.bodyLarge,
            ),
            subtitle: option.subtitle != null
                ? Text(
                    option.subtitle!,
                    style: theme.textTheme.bodySmall,
                  )
                : null,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            activeColor: theme.colorScheme.primary,
          );
        }),
        if (showError && controller.getError(field.id) != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              controller.getError(field.id)!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSliderField(BuildContext context, VooFormConfig config) {
    final theme = Theme.of(context);
    final value = (controller.getValue(field.id) as num?)?.toDouble() ?? 
                   field.min?.toDouble() ?? 0.0;
    final min = field.min?.toDouble() ?? 0.0;
    final max = field.max?.toDouble() ?? 100.0;
    final divisions = ((max - min) / (field.step?.toDouble() ?? 1.0)).round();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (config.labelPosition != LabelPosition.hidden)
          _buildLabel(context, config),
        Slider.adaptive(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          label: value.toStringAsFixed(1),
          onChanged: field.enabled && !field.readOnly
              ? (value) => controller.setValue(field.id, value)
              : null,
          activeColor: theme.colorScheme.primary,
          inactiveColor: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
        if (field.helper != null)
          Text(
            field.helper!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }

  Widget _buildDateField(BuildContext context, VooFormConfig config) {
    final theme = Theme.of(context);
    final value = controller.getValue(field.id) as DateTime?;
    final displayValue = value != null 
        ? '${value.month}/${value.day}/${value.year}'
        : '';
    
    return TextFormField(
      controller: TextEditingController(text: displayValue),
      decoration: _buildDecoration(context, config).copyWith(
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: field.enabled && !field.readOnly
          ? () async {
              final date = await showDatePicker(
                context: context,
                initialDate: value ?? DateTime.now(),
                firstDate: field.minDate ?? DateTime(1900),
                lastDate: field.maxDate ?? DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: theme,
                    child: child!,
                  );
                },
              );
              if (date != null) {
                controller.setValue(field.id, date);
              }
            }
          : null,
    );
  }

  Widget _buildTimeField(BuildContext context, VooFormConfig config) {
    final theme = Theme.of(context);
    final value = controller.getValue(field.id) as TimeOfDay?;
    final displayValue = value != null 
        ? value.format(context)
        : '';
    
    return TextFormField(
      controller: TextEditingController(text: displayValue),
      decoration: _buildDecoration(context, config).copyWith(
        suffixIcon: const Icon(Icons.access_time),
      ),
      readOnly: true,
      onTap: field.enabled && !field.readOnly
          ? () async {
              final time = await showTimePicker(
                context: context,
                initialTime: value ?? TimeOfDay.now(),
                builder: (context, child) {
                  return Theme(
                    data: theme,
                    child: child!,
                  );
                },
              );
              if (time != null) {
                controller.setValue(field.id, time);
              }
            }
          : null,
    );
  }

  Widget _buildDateTimeField(BuildContext context, VooFormConfig config) {
    final theme = Theme.of(context);
    final value = controller.getValue(field.id) as DateTime?;
    final displayValue = value != null 
        ? '${value.month}/${value.day}/${value.year} ${value.hour}:${value.minute.toString().padLeft(2, '0')}'
        : '';
    
    return TextFormField(
      controller: TextEditingController(text: displayValue),
      decoration: _buildDecoration(context, config).copyWith(
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: field.enabled && !field.readOnly
          ? () async {
              final date = await showDatePicker(
                context: context,
                initialDate: value ?? DateTime.now(),
                firstDate: field.minDate ?? DateTime(1900),
                lastDate: field.maxDate ?? DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: theme,
                    child: child!,
                  );
                },
              );
              if (date != null && context.mounted) {
                final time = await showTimePicker(
                  context: context,
                  initialTime: value != null 
                      ? TimeOfDay.fromDateTime(value)
                      : TimeOfDay.now(),
                  builder: (context, child) {
                    return Theme(
                      data: theme,
                      child: child!,
                    );
                  },
                );
                if (time != null) {
                  final dateTime = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    time.hour,
                    time.minute,
                  );
                  controller.setValue(field.id, dateTime);
                }
              }
            }
          : null,
    );
  }

  Widget _buildMultiSelectField(BuildContext context, VooFormConfig config) {
    final theme = Theme.of(context);
    final selectedValues = (controller.getValue(field.id) as List?) ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (config.labelPosition != LabelPosition.hidden)
          _buildLabel(context, config),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: field.options?.map((option) {
            final isSelected = selectedValues.contains(option.value);
            return FilterChip(
              label: Text(option.label),
              selected: isSelected,
              onSelected: field.enabled && !field.readOnly && option.enabled
                  ? (selected) {
                      final newValues = List.from(selectedValues);
                      if (selected) {
                        newValues.add(option.value);
                      } else {
                        newValues.remove(option.value);
                      }
                      controller.setValue(field.id, newValues);
                    }
                  : null,
              avatar: option.icon != null
                  ? Icon(option.icon, size: 16)
                  : null,
              selectedColor: theme.colorScheme.primaryContainer,
              checkmarkColor: theme.colorScheme.onPrimaryContainer,
              backgroundColor: theme.colorScheme.surface,
            );
          }).toList() ?? [],
        ),
        if (field.helper != null || controller.getError(field.id) != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              controller.getError(field.id) ?? field.helper!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: controller.getError(field.id) != null
                    ? theme.colorScheme.error
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFileField(BuildContext context, VooFormConfig config) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outline,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Icon(
            Icons.cloud_upload_outlined,
            size: 48,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            field.label ?? 'Choose file',
            style: theme.textTheme.bodyMedium,
          ),
          if (field.helper != null) ...[
            const SizedBox(height: 8),
            Text(
              field.helper!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildColorField(BuildContext context, VooFormConfig config) {
    final theme = Theme.of(context);
    final color = controller.getValue(field.id) as Color? ?? theme.colorScheme.primary;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (config.labelPosition != LabelPosition.hidden)
          _buildLabel(context, config),
        InkWell(
          onTap: field.enabled && !field.readOnly
              ? () async {
                  // Color picker would go here
                  // For now, just cycle through theme colors
                  final colors = <Color>[
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                    theme.colorScheme.tertiary,
                    theme.colorScheme.error,
                    theme.colorScheme.onSurface,
                  ];
                  final currentIndex = colors.indexOf(color);
                  final nextColor = colors[(currentIndex + 1) % colors.length];
                  controller.setValue(field.id, nextColor);
                }
              : null,
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(7),
                      bottomLeft: Radius.circular(7),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '#${((color.r * 255).round() << 16 | (color.g * 255).round() << 8 | (color.b * 255).round()).toRadixString(16).padLeft(6, '0').toUpperCase()}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingField(BuildContext context, VooFormConfig config) {
    final theme = Theme.of(context);
    final rating = (controller.getValue(field.id) as num?)?.toInt() ?? 0;
    final maxRating = field.max?.toInt() ?? 5;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (config.labelPosition != LabelPosition.hidden)
          _buildLabel(context, config),
        Row(
          children: List.generate(maxRating, (index) {
            final filled = index < rating;
            return IconButton(
              icon: Icon(
                filled ? Icons.star : Icons.star_border,
                color: filled 
                    ? theme.colorScheme.primary 
                    : theme.colorScheme.outline,
              ),
              onPressed: field.enabled && !field.readOnly
                  ? () => controller.setValue(field.id, index + 1)
                  : null,
            );
          }),
        ),
        if (field.helper != null)
          Text(
            field.helper!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }

  VooFormField _applyConfigToField(
    BuildContext context,
    VooFormConfig config,
    VooFormField field,
  ) {
    // Build label with required indicator
    String? label = field.label;
    if (label != null && field.required && config.showRequiredIndicator) {
      label = '$label ${config.requiredIndicator}';
    }

    // Apply label position
    if (config.labelPosition == LabelPosition.hidden) {
      label = null;
    }

    return field.copyWith(
      label: config.labelPosition != LabelPosition.floating ? label : field.label,
      padding: config.getFieldPadding(),
    );
  }
}