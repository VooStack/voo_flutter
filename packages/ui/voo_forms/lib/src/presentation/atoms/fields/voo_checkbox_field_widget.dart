import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

class VooCheckboxFieldWidget extends StatelessWidget {
  final VooFormField field;
  final VooFieldOptions options;
  final ValueChanged<dynamic>? onChanged;
  final String? error;
  final bool showError;

  const VooCheckboxFieldWidget({
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
        VooLabeledCheckbox(
          value: (field.value as bool?) ?? false,
          onChanged: field.enabled && !field.readOnly
              ? (value) {
                  onChanged?.call(value ?? false);
                  field.onChanged?.call(value ?? false);
                }
              : null,
          label: field.label ?? field.name,
          subtitle: field.helper,
          isError: hasError,
        ),
        if (hasError)
          Padding(
            padding: EdgeInsets.only(
              left: design.spacingLg,
              top: design.spacingXs,
            ),
            child: Text(
              errorText,
              style: options.errorStyle ?? theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}
