import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/options/error_display_mode.dart';
import 'package:voo_forms/src/presentation/options/field_variant.dart';
import 'package:voo_forms/src/presentation/options/focus_behavior.dart';
import 'package:voo_forms/src/presentation/options/label_position.dart';
import 'package:voo_forms/src/presentation/options/validation_trigger.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Field options that can be applied to form fields
/// Uses VooDesignSystemData from voo_ui_core for sizing and spacing
class VooFieldOptions {
  final LabelPosition? labelPosition;
  final FieldVariant? fieldVariant;
  final VooSpacingSize? fieldSize; // Use voo_ui_core's spacing size
  final VooSpacingSize? fieldDensity; // Use voo_ui_core's spacing size
  final ErrorDisplayMode? errorDisplayMode;
  final ValidationTrigger? validationTrigger;
  final FocusBehavior? focusBehavior;
  final bool? showRequiredIndicator;
  final bool? showTooltip;
  final bool? showHelperText;
  final bool? showCounter;
  final bool? enableFloatingLabel;
  final bool? autoFocus;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final TextStyle? helperStyle;
  final BorderRadius? borderRadius;
  final double? borderWidth;
  final Color? fillColor;
  final Color? focusColor;
  final Color? errorColor;
  final Color? successColor;
  final EdgeInsetsGeometry? contentPadding;
  final Duration? animationDuration;
  final Curve? animationCurve;

  const VooFieldOptions({
    this.labelPosition,
    this.fieldVariant,
    this.fieldSize,
    this.fieldDensity,
    this.errorDisplayMode,
    this.validationTrigger,
    this.focusBehavior,
    this.showRequiredIndicator,
    this.showTooltip,
    this.showHelperText,
    this.showCounter,
    this.enableFloatingLabel,
    this.autoFocus,
    this.textStyle,
    this.labelStyle,
    this.hintStyle,
    this.errorStyle,
    this.helperStyle,
    this.borderRadius,
    this.borderWidth,
    this.fillColor,
    this.focusColor,
    this.errorColor,
    this.successColor,
    this.contentPadding,
    this.animationDuration,
    this.animationCurve,
  });

  /// Material design preset - uses Material 3 defaults
  static const VooFieldOptions material = VooFieldOptions(
    labelPosition: LabelPosition.floating,
    fieldVariant: FieldVariant.outlined,
    fieldSize: VooSpacingSize.md,
    fieldDensity: VooSpacingSize.md,
    errorDisplayMode: ErrorDisplayMode.below,
    validationTrigger: ValidationTrigger.onBlur,
    focusBehavior: FocusBehavior.next,
    showRequiredIndicator: true,
    showHelperText: true,
    showCounter: false,
    enableFloatingLabel: true,
  );

  /// Compact preset - minimal spacing
  static const VooFieldOptions compact = VooFieldOptions(
    labelPosition: LabelPosition.above,
    fieldVariant: FieldVariant.outlined,
    fieldSize: VooSpacingSize.sm,
    fieldDensity: VooSpacingSize.sm,
    errorDisplayMode: ErrorDisplayMode.icon,
    validationTrigger: ValidationTrigger.onBlur,
    focusBehavior: FocusBehavior.next,
    showRequiredIndicator: false,
    showHelperText: false,
    showCounter: false,
    enableFloatingLabel: false,
  );

  /// Comfortable preset - extra spacing
  static const VooFieldOptions comfortable = VooFieldOptions(
    labelPosition: LabelPosition.above,
    fieldVariant: FieldVariant.filled,
    fieldSize: VooSpacingSize.lg,
    fieldDensity: VooSpacingSize.lg,
    errorDisplayMode: ErrorDisplayMode.below,
    validationTrigger: ValidationTrigger.onChange,
    focusBehavior: FocusBehavior.next,
    showRequiredIndicator: true,
    showHelperText: true,
    showCounter: true,
    enableFloatingLabel: false,
  );

  /// Minimal preset - ghost fields with minimal UI
  static const VooFieldOptions minimal = VooFieldOptions(
    labelPosition: LabelPosition.placeholder,
    fieldVariant: FieldVariant.ghost,
    fieldSize: VooSpacingSize.md,
    fieldDensity: VooSpacingSize.sm,
    errorDisplayMode: ErrorDisplayMode.tooltip,
    validationTrigger: ValidationTrigger.onSubmit,
    focusBehavior: FocusBehavior.next,
    showRequiredIndicator: false,
    showHelperText: false,
    showCounter: false,
    enableFloatingLabel: false,
  );

  /// Merge with another options object
  VooFieldOptions merge(VooFieldOptions? other) {
    if (other == null) return this;
    
    return VooFieldOptions(
      labelPosition: other.labelPosition ?? labelPosition,
      fieldVariant: other.fieldVariant ?? fieldVariant,
      fieldSize: other.fieldSize ?? fieldSize,
      fieldDensity: other.fieldDensity ?? fieldDensity,
      errorDisplayMode: other.errorDisplayMode ?? errorDisplayMode,
      validationTrigger: other.validationTrigger ?? validationTrigger,
      focusBehavior: other.focusBehavior ?? focusBehavior,
      showRequiredIndicator: other.showRequiredIndicator ?? showRequiredIndicator,
      showTooltip: other.showTooltip ?? showTooltip,
      showHelperText: other.showHelperText ?? showHelperText,
      showCounter: other.showCounter ?? showCounter,
      enableFloatingLabel: other.enableFloatingLabel ?? enableFloatingLabel,
      autoFocus: other.autoFocus ?? autoFocus,
      textStyle: other.textStyle ?? textStyle,
      labelStyle: other.labelStyle ?? labelStyle,
      hintStyle: other.hintStyle ?? hintStyle,
      errorStyle: other.errorStyle ?? errorStyle,
      helperStyle: other.helperStyle ?? helperStyle,
      borderRadius: other.borderRadius ?? borderRadius,
      borderWidth: other.borderWidth ?? borderWidth,
      fillColor: other.fillColor ?? fillColor,
      focusColor: other.focusColor ?? focusColor,
      errorColor: other.errorColor ?? errorColor,
      successColor: other.successColor ?? successColor,
      contentPadding: other.contentPadding ?? contentPadding,
      animationDuration: other.animationDuration ?? animationDuration,
      animationCurve: other.animationCurve ?? animationCurve,
    );
  }

  /// Create a copy with optional overrides
  VooFieldOptions copyWith({
    LabelPosition? labelPosition,
    FieldVariant? fieldVariant,
    VooSpacingSize? fieldSize,
    VooSpacingSize? fieldDensity,
    ErrorDisplayMode? errorDisplayMode,
    ValidationTrigger? validationTrigger,
    FocusBehavior? focusBehavior,
    bool? showRequiredIndicator,
    bool? showTooltip,
    bool? showHelperText,
    bool? showCounter,
    bool? enableFloatingLabel,
    bool? autoFocus,
    TextStyle? textStyle,
    TextStyle? labelStyle,
    TextStyle? hintStyle,
    TextStyle? errorStyle,
    TextStyle? helperStyle,
    BorderRadius? borderRadius,
    double? borderWidth,
    Color? fillColor,
    Color? focusColor,
    Color? errorColor,
    Color? successColor,
    EdgeInsetsGeometry? contentPadding,
    Duration? animationDuration,
    Curve? animationCurve,
  }) => VooFieldOptions(
      labelPosition: labelPosition ?? this.labelPosition,
      fieldVariant: fieldVariant ?? this.fieldVariant,
      fieldSize: fieldSize ?? this.fieldSize,
      fieldDensity: fieldDensity ?? this.fieldDensity,
      errorDisplayMode: errorDisplayMode ?? this.errorDisplayMode,
      validationTrigger: validationTrigger ?? this.validationTrigger,
      focusBehavior: focusBehavior ?? this.focusBehavior,
      showRequiredIndicator: showRequiredIndicator ?? this.showRequiredIndicator,
      showTooltip: showTooltip ?? this.showTooltip,
      showHelperText: showHelperText ?? this.showHelperText,
      showCounter: showCounter ?? this.showCounter,
      enableFloatingLabel: enableFloatingLabel ?? this.enableFloatingLabel,
      autoFocus: autoFocus ?? this.autoFocus,
      textStyle: textStyle ?? this.textStyle,
      labelStyle: labelStyle ?? this.labelStyle,
      hintStyle: hintStyle ?? this.hintStyle,
      errorStyle: errorStyle ?? this.errorStyle,
      helperStyle: helperStyle ?? this.helperStyle,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      fillColor: fillColor ?? this.fillColor,
      focusColor: focusColor ?? this.focusColor,
      errorColor: errorColor ?? this.errorColor,
      successColor: successColor ?? this.successColor,
      contentPadding: contentPadding ?? this.contentPadding,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
    );
}