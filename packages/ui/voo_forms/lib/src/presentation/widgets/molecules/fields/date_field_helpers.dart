import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/domain/enums/field_variant.dart';
import 'package:voo_forms/src/domain/enums/label_position.dart';
import 'package:voo_forms/src/presentation/config/options/voo_field_options.dart';

/// Helper class for building date field decorations
class DateFieldDecorationBuilder {
  const DateFieldDecorationBuilder();

  InputDecoration build({
    required BuildContext context,
    required VooFormField field,
    required VooFieldOptions options,
    String? error,
    bool showError = true,
  }) {
    final theme = Theme.of(context);

    // Build base decoration based on label position
    InputDecoration decoration;

    if (options.labelPosition == LabelPosition.floating) {
      decoration = InputDecoration(
        labelText: field.label,
        hintText: field.hint ?? 'Select date',
        errorText: showError && error != null ? error : null,
        helperText: field.helper,
        prefixIcon: field.prefixIcon != null ? Icon(field.prefixIcon) : null,
        suffixIcon: Icon(field.suffixIcon ?? Icons.calendar_today),
      );
    } else if (options.labelPosition == LabelPosition.placeholder) {
      decoration = InputDecoration(
        hintText: field.label ?? field.hint ?? 'Select date',
        errorText: showError && error != null ? error : null,
        helperText: field.helper,
        prefixIcon: field.prefixIcon != null ? Icon(field.prefixIcon) : null,
        suffixIcon: Icon(field.suffixIcon ?? Icons.calendar_today),
      );
    } else {
      // For above, left, or hidden positions, don't include label
      // as VooFieldWidget handles it externally
      decoration = InputDecoration(
        hintText: field.hint ?? 'Select date',
        errorText: showError && error != null ? error : null,
        helperText: field.helper,
        prefixIcon: field.prefixIcon != null ? Icon(field.prefixIcon) : null,
        suffixIcon: Icon(field.suffixIcon ?? Icons.calendar_today),
      );
    }

    // Apply field variant styling
    switch (options.fieldVariant) {
      case FieldVariant.filled:
        return decoration.copyWith(
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        );
      case FieldVariant.underlined:
        return decoration.copyWith(
          border: const UnderlineInputBorder(),
        );
      case FieldVariant.ghost:
        return decoration.copyWith(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.colorScheme.primary),
          ),
        );
      case FieldVariant.rounded:
        return decoration.copyWith(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
        );
      case FieldVariant.sharp:
        return decoration.copyWith(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
          ),
        );
      default:
        return decoration;
    }
  }
}

/// Helper class for building time field decorations
class TimeFieldDecorationBuilder {
  const TimeFieldDecorationBuilder();

  InputDecoration build({
    required BuildContext context,
    required VooFormField field,
    required VooFieldOptions options,
    String? error,
    bool showError = true,
  }) {
    final theme = Theme.of(context);

    // Build base decoration based on label position
    InputDecoration decoration;

    if (options.labelPosition == LabelPosition.floating) {
      decoration = InputDecoration(
        labelText: field.label,
        hintText: field.hint ?? 'Select time',
        errorText: showError && error != null ? error : null,
        helperText: field.helper,
        prefixIcon: field.prefixIcon != null ? Icon(field.prefixIcon) : null,
        suffixIcon: Icon(field.suffixIcon ?? Icons.access_time),
      );
    } else if (options.labelPosition == LabelPosition.placeholder) {
      decoration = InputDecoration(
        hintText: field.label ?? field.hint ?? 'Select time',
        errorText: showError && error != null ? error : null,
        helperText: field.helper,
        prefixIcon: field.prefixIcon != null ? Icon(field.prefixIcon) : null,
        suffixIcon: Icon(field.suffixIcon ?? Icons.access_time),
      );
    } else {
      // For above, left, or hidden positions, don't include label
      // as VooFieldWidget handles it externally
      decoration = InputDecoration(
        hintText: field.hint ?? 'Select time',
        errorText: showError && error != null ? error : null,
        helperText: field.helper,
        prefixIcon: field.prefixIcon != null ? Icon(field.prefixIcon) : null,
        suffixIcon: Icon(field.suffixIcon ?? Icons.access_time),
      );
    }

    // Apply field variant styling
    switch (options.fieldVariant) {
      case FieldVariant.filled:
        return decoration.copyWith(
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        );
      case FieldVariant.underlined:
        return decoration.copyWith(
          border: const UnderlineInputBorder(),
        );
      case FieldVariant.ghost:
        return decoration.copyWith(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.colorScheme.primary),
          ),
        );
      case FieldVariant.rounded:
        return decoration.copyWith(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
        );
      case FieldVariant.sharp:
        return decoration.copyWith(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
          ),
        );
      default:
        return decoration;
    }
  }
}
