import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/field_type.dart';
import 'package:voo_forms/src/domain/entities/form.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/atoms/voo_checkbox_form_field.dart';
import 'package:voo_forms/src/presentation/atoms/voo_dropdown_form_field.dart';
import 'package:voo_forms/src/presentation/atoms/voo_radio_form_field.dart';
import 'package:voo_forms/src/presentation/atoms/voo_switch_form_field.dart';
import 'package:voo_forms/src/presentation/atoms/voo_text_form_field.dart';
import 'package:voo_forms/src/presentation/controllers/form_controller.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

class VooFormFieldBuilder extends StatelessWidget {
  final VooFormField field;
  final VooFormController controller;
  final bool showError;
  final EdgeInsetsGeometry? padding;

  const VooFormFieldBuilder({
    super.key,
    required this.field,
    required this.controller,
    this.showError = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (!field.visible) {
      return const SizedBox.shrink();
    }

    Widget fieldWidget = _buildFieldWidget(context);
    
    if (padding != null) {
      fieldWidget = Padding(
        padding: padding!,
        child: fieldWidget,
      );
    }

    return fieldWidget;
  }

  Widget _buildFieldWidget(BuildContext context) {
    final design = context.vooDesign;
    
    switch (field.type) {
      case VooFieldType.text:
      case VooFieldType.number:
      case VooFieldType.email:
      case VooFieldType.password:
      case VooFieldType.phone:
      case VooFieldType.url:
      case VooFieldType.multiline:
        return VooTextFormField(
          field: field,
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
          showError: showError,
        );
        
      case VooFieldType.boolean:
        return VooSwitchFormField(
          field: field as VooFormField<bool>,
          onChanged: (value) => controller.setValue(field.id, value),
          error: controller.getError(field.id),
          showError: showError,
        );
        
      case VooFieldType.checkbox:
        return VooCheckboxFormField(
          field: field as VooFormField<bool>,
          onChanged: (value) => controller.setValue(field.id, value),
          error: controller.getError(field.id),
          showError: showError,
        );
        
      case VooFieldType.dropdown:
        return VooDropdownFormField(
          field: field,
          onChanged: (value) => controller.setValue(field.id, value),
          error: controller.getError(field.id),
          showError: showError,
        );
        
      case VooFieldType.radio:
        return VooRadioFormField(
          field: field,
          onChanged: (value) => controller.setValue(field.id, value),
          error: controller.getError(field.id),
          showError: showError,
        );
        
      case VooFieldType.slider:
        return _buildSliderField(context);
        
      case VooFieldType.date:
        return _buildDateField(context);
        
      case VooFieldType.time:
        return _buildTimeField(context);
        
      case VooFieldType.dateTime:
        return _buildDateTimeField(context);
        
      case VooFieldType.multiSelect:
        return _buildMultiSelectField(context);
        
      case VooFieldType.file:
        return _buildFileField(context);
        
      case VooFieldType.color:
        return _buildColorField(context);
        
      case VooFieldType.rating:
        return _buildRatingField(context);
        
      case VooFieldType.custom:
        return Container(
          padding: EdgeInsets.all(design.spacingMd),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(design.radiusMd),
          ),
          child: Text(
            'Unsupported field type: ${field.type}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
    }
  }

  Widget _buildSliderField(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);
    final value = (controller.getValue(field.id) as num?)?.toDouble() ?? 
                   field.min?.toDouble() ?? 0.0;
    final min = field.min?.toDouble() ?? 0.0;
    final max = field.max?.toDouble() ?? 100.0;
    final divisions = ((max - min) / (field.step?.toDouble() ?? 1.0)).round();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field.label != null) ...[
          Text(
            field.label!,
            style: theme.textTheme.bodyMedium,
          ),
          SizedBox(height: design.spacingXs),
        ],
        VooSlider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          label: value.toStringAsFixed(1),
          onChanged: field.enabled && !field.readOnly
              ? (value) => controller.setValue(field.id, value)
              : null,
        ),
        if (field.helper != null) ...[
          SizedBox(height: design.spacingXs),
          Text(
            field.helper!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDateField(BuildContext context) {
    final value = controller.getValue(field.id) as DateTime?;
    
    return VooDateTimePicker(
      value: value,
      onChanged: field.enabled && !field.readOnly
          ? (date) => controller.setValue(field.id, date)
          : null,
      label: field.label,
      hintText: field.hint,
      showTime: false,
      firstDate: field.minDate ?? DateTime(1900),
      lastDate: field.maxDate ?? DateTime(2100),
    );
  }

  Widget _buildTimeField(BuildContext context) {
    final value = controller.getValue(field.id) as TimeOfDay?;
    
    return VooTimePicker(
      initialTime: value,
      onTimeChanged: field.enabled && !field.readOnly
          ? (time) => controller.setValue(field.id, time)
          : null,
      labelText: field.label,
      helperText: field.helper,
      errorText: controller.getError(field.id),
    );
  }

  Widget _buildDateTimeField(BuildContext context) {
    final value = controller.getValue(field.id) as DateTime?;
    
    return VooDateTimePicker(
      value: value,
      onChanged: field.enabled && !field.readOnly
          ? (dateTime) => controller.setValue(field.id, dateTime)
          : null,
      label: field.label,
      hintText: field.hint,
      showTime: true,
      firstDate: field.minDate ?? DateTime(1900),
      lastDate: field.maxDate ?? DateTime(2100),
    );
  }

  Widget _buildMultiSelectField(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);
    final selectedValues = (controller.getValue(field.id) as List?) ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field.label != null) ...[
          Text(
            field.label!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: design.spacingSm),
        ],
        Wrap(
          spacing: design.spacingSm,
          runSpacing: design.spacingSm,
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
                  ? Icon(option.icon, size: design.iconSizeSm)
                  : null,
            );
          }).toList() ?? [],
        ),
        if (field.helper != null || controller.getError(field.id) != null) ...[
          SizedBox(height: design.spacingXs),
          Text(
            controller.getError(field.id) ?? field.helper!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: controller.getError(field.id) != null
                  ? theme.colorScheme.error
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFileField(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);
    
    return Container(
      padding: EdgeInsets.all(design.spacingLg),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outline,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(design.radiusMd),
      ),
      child: Column(
        children: [
          Icon(
            Icons.cloud_upload_outlined,
            size: design.iconSizeXl,
            color: theme.colorScheme.primary,
          ),
          SizedBox(height: design.spacingMd),
          Text(
            field.label ?? 'Choose file',
            style: theme.textTheme.bodyMedium,
          ),
          if (field.helper != null) ...[
            SizedBox(height: design.spacingXs),
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

  Widget _buildColorField(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);
    final color = controller.getValue(field.id) as Color? ?? Colors.blue;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field.label != null) ...[
          Text(
            field.label!,
            style: theme.textTheme.bodyMedium,
          ),
          SizedBox(height: design.spacingXs),
        ],
        InkWell(
          onTap: field.enabled && !field.readOnly
              ? () async {
                  // Color picker would go here
                  // For now, just cycle through some colors
                  final colors = <Color>[
                    Colors.red,
                    Colors.blue,
                    Colors.green,
                    Colors.orange,
                    Colors.purple,
                  ];
                  final currentIndex = colors.indexOf(color);
                  final nextColor = colors[(currentIndex + 1) % colors.length];
                  controller.setValue(field.id, nextColor);
                }
              : null,
          borderRadius: BorderRadius.circular(design.radiusMd),
          child: Container(
            height: design.inputHeight,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(design.radiusMd),
            ),
            child: Row(
              children: [
                Container(
                  width: design.inputHeight,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(design.radiusMd - 1),
                      bottomLeft: Radius.circular(design.radiusMd - 1),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '#${(((color.r * 255.0).round() & 0xff) << 16 | ((color.g * 255.0).round() & 0xff) << 8 | ((color.b * 255.0).round() & 0xff)).toRadixString(16).padLeft(6, '0').toUpperCase()}',
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

  Widget _buildRatingField(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);
    final rating = (controller.getValue(field.id) as num?)?.toInt() ?? 0;
    final maxRating = field.max?.toInt() ?? 5;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field.label != null) ...[
          Text(
            field.label!,
            style: theme.textTheme.bodyMedium,
          ),
          SizedBox(height: design.spacingXs),
        ],
        Row(
          children: List.generate(maxRating, (index) {
            final filled = index < rating;
            return IconButton(
              icon: Icon(
                filled ? Icons.star : Icons.star_border,
                color: filled ? Colors.amber : theme.colorScheme.outline,
              ),
              onPressed: field.enabled && !field.readOnly
                  ? () => controller.setValue(field.id, index + 1)
                  : null,
            );
          }),
        ),
        if (field.helper != null) ...[
          SizedBox(height: design.spacingXs),
          Text(
            field.helper!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}