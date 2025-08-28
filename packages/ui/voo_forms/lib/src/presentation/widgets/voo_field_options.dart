import 'package:flutter/material.dart';

/// Field options that can be applied to form fields
/// Can be set at form level and overridden at field level
class VooFieldOptions {
  final LabelStyle? labelStyle;
  final LabelPosition? labelPosition;
  final FieldVariant? fieldVariant;
  final FieldSize? fieldSize;
  final FieldDensity? fieldDensity;
  final bool? showRequiredIndicator;
  final String? requiredIndicator;
  final bool? showFieldIcons;
  final bool? showHelperText;
  final bool? showErrorText;
  final ErrorDisplayMode? errorDisplayMode;
  final ValidationTrigger? validationTrigger;
  final FocusBehavior? focusBehavior;
  final EdgeInsetsGeometry? contentPadding;
  final double? borderRadius;
  final InputBorder? border;
  final Color? fillColor;
  final bool? filled;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final TextStyle? helperStyle;
  final double? spacing;
  
  const VooFieldOptions({
    this.labelStyle,
    this.labelPosition,
    this.fieldVariant,
    this.fieldSize,
    this.fieldDensity,
    this.showRequiredIndicator,
    this.requiredIndicator,
    this.showFieldIcons,
    this.showHelperText,
    this.showErrorText,
    this.errorDisplayMode,
    this.validationTrigger,
    this.focusBehavior,
    this.contentPadding,
    this.borderRadius,
    this.border,
    this.fillColor,
    this.filled,
    this.textStyle,
    this.hintStyle,
    this.errorStyle,
    this.helperStyle,
    this.spacing,
  });
  
  /// Default options with Material design
  static const VooFieldOptions material = VooFieldOptions(
    labelPosition: LabelPosition.floating,
    fieldVariant: FieldVariant.outlined,
    fieldSize: FieldSize.medium,
    fieldDensity: FieldDensity.normal,
    showRequiredIndicator: true,
    requiredIndicator: '*',
    showFieldIcons: true,
    showHelperText: true,
    showErrorText: true,
    errorDisplayMode: ErrorDisplayMode.below,
    validationTrigger: ValidationTrigger.onSubmit,
    focusBehavior: FocusBehavior.next,
  );
  
  /// Compact options for dense forms
  static const VooFieldOptions compact = VooFieldOptions(
    labelPosition: LabelPosition.inline,
    fieldVariant: FieldVariant.outlined,
    fieldSize: FieldSize.small,
    fieldDensity: FieldDensity.dense,
    showRequiredIndicator: true,
    requiredIndicator: '*',
    showFieldIcons: false,
    showHelperText: false,
    showErrorText: true,
    errorDisplayMode: ErrorDisplayMode.tooltip,
    spacing: 8.0,
  );
  
  /// Comfortable options with more spacing
  static const VooFieldOptions comfortable = VooFieldOptions(
    labelPosition: LabelPosition.above,
    fieldVariant: FieldVariant.filled,
    fieldSize: FieldSize.large,
    fieldDensity: FieldDensity.comfortable,
    showRequiredIndicator: true,
    requiredIndicator: '*',
    showFieldIcons: true,
    showHelperText: true,
    showErrorText: true,
    errorDisplayMode: ErrorDisplayMode.below,
    spacing: 20.0,
  );
  
  /// Minimal options for clean forms
  static const VooFieldOptions minimal = VooFieldOptions(
    labelPosition: LabelPosition.hidden,
    fieldVariant: FieldVariant.ghost,
    fieldSize: FieldSize.medium,
    fieldDensity: FieldDensity.normal,
    showRequiredIndicator: false,
    showFieldIcons: false,
    showHelperText: false,
    showErrorText: true,
    errorDisplayMode: ErrorDisplayMode.inline,
  );
  
  /// Merge with another options object, with other taking precedence
  VooFieldOptions merge(VooFieldOptions? other) {
    if (other == null) return this;
    
    return VooFieldOptions(
      labelStyle: other.labelStyle ?? labelStyle,
      labelPosition: other.labelPosition ?? labelPosition,
      fieldVariant: other.fieldVariant ?? fieldVariant,
      fieldSize: other.fieldSize ?? fieldSize,
      fieldDensity: other.fieldDensity ?? fieldDensity,
      showRequiredIndicator: other.showRequiredIndicator ?? showRequiredIndicator,
      requiredIndicator: other.requiredIndicator ?? requiredIndicator,
      showFieldIcons: other.showFieldIcons ?? showFieldIcons,
      showHelperText: other.showHelperText ?? showHelperText,
      showErrorText: other.showErrorText ?? showErrorText,
      errorDisplayMode: other.errorDisplayMode ?? errorDisplayMode,
      validationTrigger: other.validationTrigger ?? validationTrigger,
      focusBehavior: other.focusBehavior ?? focusBehavior,
      contentPadding: other.contentPadding ?? contentPadding,
      borderRadius: other.borderRadius ?? borderRadius,
      border: other.border ?? border,
      fillColor: other.fillColor ?? fillColor,
      filled: other.filled ?? filled,
      textStyle: other.textStyle ?? textStyle,
      hintStyle: other.hintStyle ?? hintStyle,
      errorStyle: other.errorStyle ?? errorStyle,
      helperStyle: other.helperStyle ?? helperStyle,
      spacing: other.spacing ?? spacing,
    );
  }
  
  VooFieldOptions copyWith({
    LabelStyle? labelStyle,
    LabelPosition? labelPosition,
    FieldVariant? fieldVariant,
    FieldSize? fieldSize,
    FieldDensity? fieldDensity,
    bool? showRequiredIndicator,
    String? requiredIndicator,
    bool? showFieldIcons,
    bool? showHelperText,
    bool? showErrorText,
    ErrorDisplayMode? errorDisplayMode,
    ValidationTrigger? validationTrigger,
    FocusBehavior? focusBehavior,
    EdgeInsetsGeometry? contentPadding,
    double? borderRadius,
    InputBorder? border,
    Color? fillColor,
    bool? filled,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? errorStyle,
    TextStyle? helperStyle,
    double? spacing,
  }) {
    return VooFieldOptions(
      labelStyle: labelStyle ?? this.labelStyle,
      labelPosition: labelPosition ?? this.labelPosition,
      fieldVariant: fieldVariant ?? this.fieldVariant,
      fieldSize: fieldSize ?? this.fieldSize,
      fieldDensity: fieldDensity ?? this.fieldDensity,
      showRequiredIndicator: showRequiredIndicator ?? this.showRequiredIndicator,
      requiredIndicator: requiredIndicator ?? this.requiredIndicator,
      showFieldIcons: showFieldIcons ?? this.showFieldIcons,
      showHelperText: showHelperText ?? this.showHelperText,
      showErrorText: showErrorText ?? this.showErrorText,
      errorDisplayMode: errorDisplayMode ?? this.errorDisplayMode,
      validationTrigger: validationTrigger ?? this.validationTrigger,
      focusBehavior: focusBehavior ?? this.focusBehavior,
      contentPadding: contentPadding ?? this.contentPadding,
      borderRadius: borderRadius ?? this.borderRadius,
      border: border ?? this.border,
      fillColor: fillColor ?? this.fillColor,
      filled: filled ?? this.filled,
      textStyle: textStyle ?? this.textStyle,
      hintStyle: hintStyle ?? this.hintStyle,
      errorStyle: errorStyle ?? this.errorStyle,
      helperStyle: helperStyle ?? this.helperStyle,
      spacing: spacing ?? this.spacing,
    );
  }
}

/// Label style variations
enum LabelStyle {
  normal,
  bold,
  uppercase,
  minimal,
  emphasized,
}

/// Label position relative to field
enum LabelPosition {
  above,      // Label above the field
  floating,   // Material floating label
  inline,     // Label inside the field
  left,       // Label to the left of field
  hidden,     // No label shown
  placeholder, // Label as placeholder text
}

/// Field visual variants
enum FieldVariant {
  outlined,   // Border all around
  filled,     // Filled background
  underlined, // Only bottom border
  ghost,      // No visible border until focused
  rounded,    // Fully rounded borders
  sharp,      // Sharp corners
}

/// Field size presets
enum FieldSize {
  small,
  medium,
  large,
  xlarge,
}

/// Field density for spacing
enum FieldDensity {
  dense,      // Minimal padding
  normal,     // Standard padding
  comfortable, // Extra padding
  spacious,   // Maximum padding
}

/// Error display modes
enum ErrorDisplayMode {
  below,      // Show error below field
  tooltip,    // Show as tooltip on hover/focus
  inline,     // Show inline with field
  icon,       // Show only error icon
  none,       // Don't show errors
}

/// Validation trigger modes
enum ValidationTrigger {
  onChange,   // Validate on every change
  onBlur,     // Validate when field loses focus
  onSubmit,   // Validate only on form submit
  manual,     // Manual validation only
  instant,    // Real-time validation
}

/// Focus behavior
enum FocusBehavior {
  next,       // Move to next field
  submit,     // Submit form
  none,       // Do nothing
  custom,     // Custom behavior
}

/// Extension methods for enums
extension LabelPositionExtension on LabelPosition {
  String get label {
    switch (this) {
      case LabelPosition.above:
        return 'Above';
      case LabelPosition.floating:
        return 'Floating';
      case LabelPosition.inline:
        return 'Inline';
      case LabelPosition.left:
        return 'Left';
      case LabelPosition.hidden:
        return 'Hidden';
      case LabelPosition.placeholder:
        return 'Placeholder';
    }
  }
}

extension FieldVariantExtension on FieldVariant {
  String get label {
    switch (this) {
      case FieldVariant.outlined:
        return 'Outlined';
      case FieldVariant.filled:
        return 'Filled';
      case FieldVariant.underlined:
        return 'Underlined';
      case FieldVariant.ghost:
        return 'Ghost';
      case FieldVariant.rounded:
        return 'Rounded';
      case FieldVariant.sharp:
        return 'Sharp';
    }
  }
}

extension FieldSizeExtension on FieldSize {
  double get height {
    switch (this) {
      case FieldSize.small:
        return 36.0;
      case FieldSize.medium:
        return 48.0;
      case FieldSize.large:
        return 56.0;
      case FieldSize.xlarge:
        return 64.0;
    }
  }
  
  EdgeInsetsGeometry get padding {
    switch (this) {
      case FieldSize.small:
        return const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);
      case FieldSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
      case FieldSize.large:
        return const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0);
      case FieldSize.xlarge:
        return const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0);
    }
  }
  
  double get fontSize {
    switch (this) {
      case FieldSize.small:
        return 13.0;
      case FieldSize.medium:
        return 14.0;
      case FieldSize.large:
        return 16.0;
      case FieldSize.xlarge:
        return 18.0;
    }
  }
}