import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

class VooSwitchFieldWidget extends StatelessWidget {
  final VooFormField field;
  final VooFieldOptions options;
  final ValueChanged<dynamic>? onChanged;
  final String? error;
  final bool showError;

  const VooSwitchFieldWidget({
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
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: field.prefixIcon != null
              ? Icon(
                  field.prefixIcon,
                  size: design.iconSizeMd,
                  color: hasError
                      ? theme.colorScheme.error
                      : theme.colorScheme.onSurfaceVariant,
                )
              : field.prefix,
          title: Text(
            field.label ?? field.name,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: hasError
                  ? theme.colorScheme.error
                  : theme.colorScheme.onSurface,
            ),
          ),
          subtitle: field.helper != null
              ? Text(
                  field.helper!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
              : null,
          trailing: VooSwitch(
            value: (field.value as bool?) ?? false,
            onChanged: field.enabled && !field.readOnly
                ? (value) {
                    onChanged?.call(value);
                    field.onChanged?.call(value);
                  }
                : null,
            isError: hasError,
          ),
        ),
        if (hasError)
          Padding(
            padding: EdgeInsets.only(
              left: design.spacingLg,
              top: design.spacingXs,
            ),
            child: Text(
              errorText,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}