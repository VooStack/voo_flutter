import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

class VooRadioFieldWidget<T> extends StatelessWidget {
  final VooFormField<T> field;
  final VooFieldOptions options;
  final ValueChanged<T?>? onChanged;
  final String? error;
  final bool showError;

  const VooRadioFieldWidget({
    super.key,
    required this.field,
    required this.options,
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
          decoration: hasError
              ? BoxDecoration(
                  border: Border.all(color: theme.colorScheme.error),
                  borderRadius: BorderRadius.circular(design.radiusMd),
                )
              : null,
          child: Column(
            children: field.options?.map<Widget>((option) {
                  return VooRadioListTile<T>(
                    value: option.value,
                    groupValue: field.value,
                    onChanged:
                        field.enabled && !field.readOnly && option.enabled
                            ? (value) {
                                onChanged?.call(value);
                                field.onChanged?.call(value);
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
                    isError: hasError,
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
