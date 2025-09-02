import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/field_layout.dart';
import 'package:voo_forms/src/domain/entities/validation_rule.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_form_field_widget.dart';

/// Base abstract class for all form fields following atomic design
/// Contains all common field properties and methods to ensure zero code duplication
/// Implements VooFormFieldWidget so it can be used with VooForm and VooFormBuilder
abstract class VooFieldBase<T> extends StatelessWidget implements VooFormFieldWidget {
  @override
  final String name;
  @override
  final String? label;
  /// Custom widget to use instead of the default label
  final Widget? labelWidget;
  final String? hint;
  final String? helper;
  final String? placeholder;
  @override
  final T? initialValue;
  @override
  final T? value;
  @override
  final bool required;
  final bool enabled;
  final bool readOnly;
  final List<VooValidationRule<T>>? validators;
  final ValueChanged<T?>? onChanged;
  final List<Widget>? actions;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? gridColumns;
  final String? error;
  final bool showError;
  @override
  final VooFieldLayout layout;
  /// Whether this field should be hidden
  final bool isHidden;

  const VooFieldBase({
    super.key,
    required this.name,
    this.label,
    this.labelWidget,
    this.hint,
    this.helper,
    this.placeholder,
    this.initialValue,
    this.value,
    this.required = false,
    this.enabled = true,
    this.readOnly = false,
    this.validators,
    this.onChanged,
    this.actions,
    this.prefixIcon,
    this.suffixIcon,
    this.gridColumns,
    this.error,
    this.showError = true,
    this.layout = VooFieldLayout.standard,
    this.isHidden = false,
  });

  /// Builds the field container with standard decoration
  Widget buildFieldContainer(BuildContext context, Widget child) {
    // Return empty widget if field is hidden
    if (isHidden) return const SizedBox.shrink();
    return Container(child: child);
  }

  /// Builds the field with label if provided
  Widget buildWithLabel(BuildContext context, Widget child) {
    if (label == null && labelWidget == null && (actions == null || actions!.isEmpty)) return child;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelWidget != null || label != null || (actions != null && actions!.isNotEmpty))
          buildLabelWithActions(context),
        if (labelWidget != null || label != null) const SizedBox(height: 8),
        child,
      ],
    );
  }

  /// Builds the label with actions aligned to the right
  Widget buildLabelWithActions(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (labelWidget != null)
          Expanded(child: labelWidget!)
        else if (label != null)
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                if (required)
                  Text(
                    ' *',
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        if (actions != null && actions!.isNotEmpty)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: actions!,
          ),
      ],
    );
  }

  /// Builds just the label widget (deprecated, use buildLabelWithActions)
  Widget buildLabel(BuildContext context) {
    if (labelWidget != null) return labelWidget!;
    if (label == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          label!,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
        if (required)
          Text(
            ' *',
            style: TextStyle(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  /// Builds the field with error display
  Widget buildWithError(BuildContext context, Widget child) {
    if (!showError || error == null) return child;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        const SizedBox(height: 4),
        buildError(context),
      ],
    );
  }

  /// Builds just the error widget
  Widget buildError(BuildContext context) {
    if (error == null || !showError) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Text(
        error!,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.error,
        ),
      ),
    );
  }

  /// Builds the field with helper text
  Widget buildWithHelper(BuildContext context, Widget child) {
    if (helper == null) return child;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        const SizedBox(height: 4),
        buildHelper(context),
      ],
    );
  }

  /// Builds just the helper widget
  Widget buildHelper(BuildContext context) {
    if (helper == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Text(
        helper!,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  /// Builds the field with actions
  /// Note: Actions are now added to the label row in buildLabelWithActions
  Widget buildWithActions(BuildContext context, Widget child) => child;

  /// Standard decoration for input fields
  InputDecoration getInputDecoration(BuildContext context) {
    final theme = Theme.of(context);

    return InputDecoration(
      hintText: placeholder ?? hint,
      // Don't include labelText since we use buildWithLabel separately
      // Don't include helperText since we use buildWithHelper separately  
      // Don't include errorText since we use buildWithError separately
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: enabled ? theme.colorScheme.surface : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: theme.colorScheme.primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: theme.colorScheme.error,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
    );
  }

  /// Validates the field value
  String? validate(T? value) {
    if (required && (value == null || (value is String && value.isEmpty))) {
      return '${label ?? name} is required';
    }

    if (validators != null) {
      for (final validator in validators!) {
        final error = validator.validate(value);
        if (error != null) return error;
      }
    }

    return null;
  }
}
