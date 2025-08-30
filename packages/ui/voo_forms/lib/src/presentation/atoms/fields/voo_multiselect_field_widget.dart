import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Atomic widget for multi-select form field
class VooMultiSelectFieldWidget<T> extends StatelessWidget {
  final VooFormField field;
  final ValueChanged<List<T>?>? onChanged;
  final String? error;
  final bool showError;

  const VooMultiSelectFieldWidget({
    super.key,
    required this.field,
    this.onChanged,
    this.error,
    this.showError = true,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);

    final errorText = showError ? (error ?? field.error) : null;
    final hasError = errorText != null && errorText.isNotEmpty;
    final selectedValues = (field.value as List<T>?) ?? <T>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (field.label != null) ...[
          Text(
            field.label!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: hasError
                  ? theme.colorScheme.error
                  : theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: design.spacingSm),
        ],
        if (field.helper != null) ...[
          Text(
            field.helper!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: design.spacingSm),
        ],
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: hasError 
                  ? theme.colorScheme.error
                  : theme.colorScheme.outline,
            ),
            borderRadius: BorderRadius.circular(design.radiusMd),
          ),
          child: Column(
            children: field.options?.map<Widget>((option) {
                  final isSelected = selectedValues.contains(option.value);
                  return CheckboxListTile(
                    value: isSelected,
                    onChanged: field.enabled && !field.readOnly && option.enabled
                        ? (bool? checked) {
                            final newValues = List<T>.from(selectedValues);
                            if (checked == true) {
                              if (!newValues.contains(option.value)) {
                                newValues.add(option.value);
                              }
                            } else {
                              newValues.remove(option.value);
                            }
                            onChanged?.call(newValues);
                            // Safely call field.onChanged with type checking
                            try {
                              final dynamic dynField = field;
                              final callback = dynField.onChanged;
                              if (callback != null) {
                                callback(newValues);
                              }
                            } catch (_) {
                              // Silently ignore type casting errors
                            }
                          }
                        : null,
                    title: Text(option.label),
                    subtitle:
                        option.subtitle != null ? Text(option.subtitle!) : null,
                    secondary: option.icon != null
                        ? Icon(
                            option.icon,
                            size: design.iconSizeMd,
                          )
                        : null,
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                  );
                }).toList() ??
                [],
          ),
        ),
        if (hasError) ...[
          SizedBox(height: design.spacingXs),
          Padding(
            padding: EdgeInsets.only(left: design.spacingLg),
            child: Text(
              errorText,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ],
    );
  }
}