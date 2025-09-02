import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/domain/enums/field_variant.dart';
import 'package:voo_forms/src/domain/enums/label_position.dart';
import 'package:voo_forms/src/presentation/config/options/voo_field_options.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Helper class for building dropdown field decorations
class DropdownFieldDecorationBuilder {
  const DropdownFieldDecorationBuilder();

  InputDecoration build<T>({
    required BuildContext context,
    required VooFormField field,
    required VooFieldOptions options,
    required bool hasError,
    required bool isFocused,
    required bool isOpen,
    String? error,
    VooFieldOption<T>? selectedOption,
  }) {
    final theme = Theme.of(context);
    final design = context.vooDesign;

    // Build input decoration based on label position and field variant
    InputDecoration decoration;

    // Handle label based on position
    String? labelText;
    String? hintText = field.hint;

    if (options.labelPosition == LabelPosition.floating && field.label != null) {
      labelText = field.label;
    } else if (options.labelPosition == LabelPosition.placeholder && field.label != null) {
      hintText = field.label;
    }

    // Create base decoration
    decoration = InputDecoration(
      labelText: labelText,
      hintText: hintText,
      helperText: field.helper,
      errorText: hasError ? error ?? field.error : null,
      prefixIcon: field.prefixIcon != null
          ? Icon(
              field.prefixIcon,
              color: (isFocused || isOpen) ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
            )
          : selectedOption?.icon != null
              ? Icon(
                  selectedOption!.icon,
                  color: theme.colorScheme.onSurface,
                )
              : null,
      suffixIcon: Icon(
        isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
        color: field.enabled ? theme.colorScheme.onSurfaceVariant : theme.colorScheme.onSurface.withOpacity(0.38),
      ),
      enabled: field.enabled && !field.readOnly,
    );

    // Apply field variant styling
    switch (options.fieldVariant) {
      case FieldVariant.filled:
        decoration = decoration.copyWith(
          filled: true,
          fillColor: field.enabled
              ? theme.colorScheme.surfaceContainerHighest.withOpacity(0.5)
              : theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        );
        break;
      case FieldVariant.underlined:
        decoration = decoration.copyWith(
          border: const UnderlineInputBorder(),
        );
        break;
      case FieldVariant.ghost:
        decoration = decoration.copyWith(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(design.radiusMd),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(design.radiusMd),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(design.radiusMd),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2,
            ),
          ),
        );
        break;
      case FieldVariant.rounded:
        decoration = decoration.copyWith(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
        );
        break;
      case FieldVariant.sharp:
        decoration = decoration.copyWith(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
          ),
        );
        break;
      case FieldVariant.outlined:
      default:
        // Outlined is the default for TextFormField
        break;
    }

    return decoration;
  }
}