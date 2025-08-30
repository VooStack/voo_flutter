import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Atomic widget for file upload form field
class VooFileFieldWidget extends StatelessWidget {
  final VooFormField field;
  final VooFieldOptions options;
  final ValueChanged<dynamic>? onChanged;
  final VoidCallback? onTap;
  final String? error;
  final bool showError;

  const VooFileFieldWidget({
    super.key,
    required this.field,
    required this.options,
    this.onChanged,
    this.onTap,
    this.error,
    this.showError = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = context.vooDesign;
    
    final errorText = showError ? (error ?? field.error) : null;
    final hasError = errorText != null && errorText.isNotEmpty;
    
    // Get file info from value
    final fileValue = field.value;
    String? fileName;
    if (fileValue != null) {
      if (fileValue is String) {
        fileName = fileValue.split('/').last;
      } else if (fileValue is Map && fileValue['name'] != null) {
        fileName = fileValue['name'];
      }
    }
    
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
        InkWell(
          onTap: field.enabled && !field.readOnly
              ? () {
                  // This would typically trigger file picker
                  // For now, just call the callbacks
                  onTap?.call();
                  // In a real implementation, you would use a file picker
                  // and then call onChanged with the selected file
                }
              : null,
          borderRadius: BorderRadius.circular(design.radiusMd),
          child: Container(
            padding: EdgeInsets.all(design.spacingMd),
            decoration: BoxDecoration(
              border: Border.all(
                color: hasError
                    ? theme.colorScheme.error
                    : theme.colorScheme.outline,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(design.radiusMd),
              color: field.enabled
                  ? null
                  : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            ),
            child: Row(
              children: [
                Icon(
                  fileName != null ? Icons.insert_drive_file : Icons.cloud_upload,
                  color: hasError
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                  size: design.iconSizeLg,
                ),
                SizedBox(width: design.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileName ?? field.hint ?? 'Choose file',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: fileName != null
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurfaceVariant,
                        ),
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
                ),
                if (fileName != null && field.enabled && !field.readOnly)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      onChanged?.call(null);
                      // Safely call field.onChanged with type checking
                      try {
                        final dynamic dynField = field;
                        final callback = dynField.onChanged;
                        if (callback != null) {
                          callback(null);
                        }
                      } catch (_) {
                        // Silently ignore type casting errors
                      }
                    },
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
              ],
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
}