import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Atomic widget for custom form field
/// This widget allows for completely custom field implementations
class VooCustomFieldWidget extends StatelessWidget {
  final VooFormField field;
  final VooFieldOptions options;
  final ValueChanged<dynamic>? onChanged;
  final String? error;
  final bool showError;
  final Widget Function(
    BuildContext context,
    VooFormField field,
    ValueChanged<dynamic>? onChanged,
  )? customBuilder;

  const VooCustomFieldWidget({
    super.key,
    required this.field,
    required this.options,
    this.onChanged,
    this.error,
    this.showError = true,
    this.customBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = context.vooDesign;
    
    final errorText = showError ? (error ?? field.error) : null;
    final hasError = errorText != null && errorText.isNotEmpty;
    
    // If a custom builder is provided, use it
    if (customBuilder != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (field.label != null && options.labelPosition != LabelPosition.hidden)
            Padding(
              padding: EdgeInsets.only(bottom: design.spacingSm),
              child: Text(
                field.label!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: hasError
                      ? theme.colorScheme.error
                      : theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          customBuilder!(
            context,
            field,
            (value) {
              onChanged?.call(value);
              field.onChanged?.call(value);
            },
          ),
          if (field.helper != null)
            Padding(
              padding: EdgeInsets.only(top: design.spacingXs),
              child: Text(
                field.helper!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
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
    
    // Default custom field implementation
    return Container(
      padding: EdgeInsets.all(design.spacingMd),
      decoration: BoxDecoration(
        border: Border.all(
          color: hasError
              ? theme.colorScheme.error
              : theme.colorScheme.outline,
        ),
        borderRadius: BorderRadius.circular(design.radiusMd),
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (field.label != null)
            Text(
              field.label!,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          SizedBox(height: design.spacingSm),
          Text(
            'Custom field implementation required',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
          if (field.helper != null) ...[
            SizedBox(height: design.spacingSm),
            Text(
              field.helper!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (hasError) ...[
            SizedBox(height: design.spacingSm),
            Text(
              errorText,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }
}