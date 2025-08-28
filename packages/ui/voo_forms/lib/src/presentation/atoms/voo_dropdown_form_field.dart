import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

class VooDropdownFormField<T> extends StatelessWidget {
  final VooFormField<T> field;
  final ValueChanged<T?>? onChanged;
  final String? error;
  final bool showError;

  const VooDropdownFormField({
    super.key,
    required this.field,
    this.onChanged,
    this.error,
    this.showError = true,
  });

  @override
  Widget build(BuildContext context) {
    final errorText = showError ? (error ?? field.error) : null;

    // Build dropdown items
    final items = field.options?.map<VooDropdownItem<T>>((option) {
          return VooDropdownItem<T>(
            value: option.value,
            label: option.label,
            subtitle: option.subtitle,
            icon: option.icon,
            enabled: option.enabled,
          );
        }).toList() ??
        [];

    return VooDropdown<T>(
      value: field.value,
      items: items,
      onChanged: field.enabled && !field.readOnly
          ? (value) {
              onChanged?.call(value);
              field.onChanged?.call(value);
            }
          : null,
      label: field.label,
      hint: field.hint,
      helper: field.helper,
      error: errorText,
      prefixIcon: field.prefixIcon,
      enabled: field.enabled && !field.readOnly,
    );
  }
}
