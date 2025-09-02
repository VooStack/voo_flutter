import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/field_layout.dart';
import 'package:voo_forms/src/domain/entities/validation_rule.dart';
import 'package:voo_forms/src/domain/utils/screen_size.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_form_field_widget.dart';
import 'package:voo_forms/src/presentation/widgets/organisms/forms/voo_form.dart';

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
  /// Optional minimum width for the field
  final double? minWidth;
  /// Optional maximum width for the field
  final double? maxWidth;
  /// Optional minimum height for the field
  final double? minHeight;
  /// Optional maximum height for the field
  final double? maxHeight;

  const VooFieldBase({
    super.key,
    required this.name,
    this.label,
    this.labelWidget,
    this.hint,
    this.helper,
    this.placeholder,
    this.initialValue,
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
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
  });

  /// Get effective readonly state considering form-level configuration
  bool getEffectiveReadOnly(BuildContext context) {
    // Check if form scope provides a readonly override
    final formScope = VooFormScope.of(context);
    if (formScope != null && formScope.isReadOnly) {
      return true;
    }
    // Otherwise use the field's own readonly state
    return readOnly;
  }
  
  /// Get effective loading state from form-level configuration
  bool getEffectiveLoading(BuildContext context) {
    final formScope = VooFormScope.of(context);
    return formScope?.isLoading ?? false;
  }
  
  /// Get responsive padding based on screen size
  EdgeInsets getFieldPadding(BuildContext context) {
    final screenType = VooScreenSize.getType(context);
    
    switch (screenType) {
      case ScreenType.mobile:
        return const EdgeInsets.symmetric(vertical: 6.0);
      case ScreenType.tablet:
        return const EdgeInsets.symmetric(vertical: 8.0);
      case ScreenType.desktop:
      case ScreenType.extraLarge:
        return const EdgeInsets.symmetric(vertical: 10.0);
    }
  }

  /// Builds the field container with standard decoration
  /// Note: Only width constraints are applied at container level
  /// Height constraints should be applied by individual fields to their input widgets
  Widget buildFieldContainer(BuildContext context, Widget child) {
    // Return empty widget if field is hidden
    if (isHidden) return const SizedBox.shrink();
    
    Widget fieldWidget = child;
    
    // Apply width constraints at container level (affects entire field)
    if (minWidth != null || maxWidth != null) {
      fieldWidget = ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minWidth ?? 0.0,
          maxWidth: maxWidth ?? double.infinity,
        ),
        child: fieldWidget,
      );
    }
    
    // Apply padding
    return Padding(
      padding: getFieldPadding(context),
      child: fieldWidget,
    );
  }
  
  /// Helper method to apply height constraints to input widgets
  /// Individual fields should use this for their input controls
  Widget applyInputHeightConstraints(Widget input) {
    if (minHeight != null || maxHeight != null) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: minHeight ?? 0.0,
          maxHeight: maxHeight ?? double.infinity,
        ),
        child: input,
      );
    }
    return input;
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
