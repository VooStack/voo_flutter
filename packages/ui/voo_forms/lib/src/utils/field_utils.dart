import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_forms/src/domain/entities/field_type.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/domain/entities/validation_rule.dart';

/// Utility class for working with form fields
class VooFieldUtils {
  VooFieldUtils._();

  /// Create a text field with common configurations
  static VooFormField<String> textField({
    required String id,
    required String name,
    String? label,
    String? hint,
    String? helper,
    bool required = false,
    int? maxLength,
    List<VooValidationRule<String>>? validators,
    IconData? prefixIcon,
    TextCapitalization? textCapitalization,
  }) {
    return VooFormField<String>(
      id: id,
      name: name,
      label: label ?? name,
      hint: hint,
      helper: helper,
      type: VooFieldType.text,
      required: required,
      maxLength: maxLength,
      validators: validators ?? [],
      prefixIcon: prefixIcon,
      textCapitalization: textCapitalization,
    );
  }

  /// Create an email field with validation
  static VooFormField<String> emailField({
    required String id,
    String? name,
    String? label,
    String? hint,
    bool required = true,
    List<VooValidationRule<String>>? additionalValidators,
  }) {
    return VooFormField<String>(
      id: id,
      name: name ?? 'email',
      label: label ?? 'Email Address',
      hint: hint ?? 'example@email.com',
      type: VooFieldType.email,
      required: required,
      validators: [
        if (required) const RequiredValidation<String>(),
        const EmailValidation(),
        ...?additionalValidators,
      ],
      prefixIcon: Icons.email,
    );
  }

  /// Create a password field with validation
  static VooFormField<String> passwordField({
    required String id,
    String? name,
    String? label,
    String? helper,
    bool required = true,
    int minLength = 8,
    bool requireUppercase = true,
    bool requireNumbers = true,
    List<VooValidationRule<String>>? additionalValidators,
  }) {
    return VooFormField<String>(
      id: id,
      name: name ?? 'password',
      label: label ?? 'Password',
      helper: helper ?? 'Must be at least $minLength characters',
      type: VooFieldType.password,
      required: required,
      validators: [
        if (required) const RequiredValidation<String>(),
        MinLengthValidation(minLength: minLength),
        if (requireUppercase)
          PatternValidation(
            pattern: r'[A-Z]',
            errorMessage: 'Password must contain uppercase letters',
          ),
        if (requireNumbers)
          PatternValidation(
            pattern: r'[0-9]',
            errorMessage: 'Password must contain numbers',
          ),
        ...?additionalValidators,
      ],
      prefixIcon: Icons.lock,
    );
  }

  /// Create a phone field with formatting
  static VooFormField<String> phoneField({
    required String id,
    String? name,
    String? label,
    String? hint,
    bool required = false,
    TextInputFormatter? formatter,
    List<VooValidationRule<String>>? additionalValidators,
  }) {
    return VooFormField<String>(
      id: id,
      name: name ?? 'phone',
      label: label ?? 'Phone Number',
      hint: hint ?? '(123) 456-7890',
      type: VooFieldType.phone,
      required: required,
      inputFormatters: formatter != null ? [formatter] : null,
      validators: [
        if (required) const RequiredValidation<String>(),
        const PhoneValidation(),
        ...?additionalValidators,
      ],
      prefixIcon: Icons.phone,
    );
  }

  /// Create a number field
  static VooFormField<num> numberField({
    required String id,
    required String name,
    String? label,
    String? hint,
    bool required = false,
    num? min,
    num? max,
    num? step,
    List<VooValidationRule<num>>? validators,
    IconData? prefixIcon,
  }) {
    return VooFormField<num>(
      id: id,
      name: name,
      label: label ?? name,
      hint: hint,
      type: VooFieldType.number,
      required: required,
      min: min,
      max: max,
      step: step,
      validators: validators ?? [],
      prefixIcon: prefixIcon,
    );
  }

  /// Create a date field
  static VooFormField<DateTime> dateField({
    required String id,
    required String name,
    String? label,
    bool required = false,
    DateTime? minDate,
    DateTime? maxDate,
    DateTime? initialValue,
    List<VooValidationRule<DateTime>>? validators,
    IconData? prefixIcon,
  }) {
    return VooFormField<DateTime>(
      id: id,
      name: name,
      label: label ?? name,
      type: VooFieldType.date,
      required: required,
      minDate: minDate,
      maxDate: maxDate,
      initialValue: initialValue,
      validators: validators ?? [],
      prefixIcon: prefixIcon ?? Icons.calendar_today,
    );
  }

  /// Create a dropdown field
  static VooFormField<T> dropdownField<T>({
    required String id,
    required String name,
    String? label,
    String? hint,
    bool required = false,
    required List<VooFieldOption<T>> options,
    T? initialValue,
    List<VooValidationRule<T>>? validators,
    IconData? prefixIcon,
  }) {
    return VooFormField<T>(
      id: id,
      name: name,
      label: label ?? name,
      hint: hint,
      type: VooFieldType.dropdown,
      required: required,
      options: options,
      initialValue: initialValue,
      validators: validators ?? [],
      prefixIcon: prefixIcon,
    );
  }

  /// Create a checkbox field
  static VooFormField<bool> checkboxField({
    required String id,
    required String name,
    String? label,
    String? helper,
    bool initialValue = false,
    ValueChanged<bool?>? onChanged,
  }) {
    return VooFormField<bool>(
      id: id,
      name: name,
      label: label ?? name,
      helper: helper,
      type: VooFieldType.checkbox,
      initialValue: initialValue,
      onChanged: onChanged,
    );
  }

  /// Create a switch field
  static VooFormField<bool> switchField({
    required String id,
    required String name,
    String? label,
    String? helper,
    bool initialValue = false,
    IconData? prefixIcon,
    ValueChanged<bool?>? onChanged,
  }) {
    return VooFormField<bool>(
      id: id,
      name: name,
      label: label ?? name,
      helper: helper,
      type: VooFieldType.boolean,
      initialValue: initialValue,
      prefixIcon: prefixIcon,
      onChanged: onChanged,
    );
  }

  /// Create a radio group field
  static VooFormField<T> radioField<T>({
    required String id,
    required String name,
    String? label,
    String? helper,
    bool required = false,
    required List<VooFieldOption<T>> options,
    T? initialValue,
    List<VooValidationRule<T>>? validators,
  }) {
    return VooFormField<T>(
      id: id,
      name: name,
      label: label ?? name,
      helper: helper,
      type: VooFieldType.radio,
      required: required,
      options: options,
      initialValue: initialValue,
      validators: validators ?? [],
    );
  }

  /// Create a multi-select field
  static VooFormField<List<String>> multiSelectField({
    required String id,
    required String name,
    String? label,
    String? helper,
    bool required = false,
    required List<VooFieldOption<String>> options,
    List<String>? initialValue,
    List<VooValidationRule<List<String>>>? validators,
  }) {
    // Note: This is a workaround for the type system. Multi-select fields have
    // List<String> as their value type, but the options are individual strings.
    // The form field builder knows how to handle this correctly.
    return VooFormField<List<String>>(
      id: id,
      name: name,
      label: label ?? name,
      helper: helper,
      type: VooFieldType.multiSelect,
      required: required,
      options: options as dynamic,  // Safe cast - runtime handles this correctly
      initialValue: initialValue,
      validators: validators ?? [],
      allowMultiple: true,
    );
  }

  /// Create a slider field
  static VooFormField<double> sliderField({
    required String id,
    required String name,
    String? label,
    String? helper,
    double min = 0,
    double max = 100,
    double? step,
    double? initialValue,
    List<VooValidationRule<double>>? validators,
  }) {
    return VooFormField<double>(
      id: id,
      name: name,
      label: label ?? name,
      helper: helper,
      type: VooFieldType.slider,
      min: min,
      max: max,
      step: step,
      initialValue: initialValue ?? min,
      validators: validators ?? [],
    );
  }

  /// Create a rating field
  static VooFormField<int> ratingField({
    required String id,
    required String name,
    String? label,
    String? helper,
    int max = 5,
    int? initialValue,
    bool required = false,
    List<VooValidationRule<int>>? validators,
  }) {
    return VooFormField<int>(
      id: id,
      name: name,
      label: label ?? name,
      helper: helper,
      type: VooFieldType.rating,
      max: max,
      initialValue: initialValue ?? 0,
      required: required,
      validators: validators ?? [],
    );
  }

  /// Create a multiline text field
  static VooFormField<String> textAreaField({
    required String id,
    required String name,
    String? label,
    String? hint,
    String? helper,
    bool required = false,
    int? maxLength,
    int? minLines,
    int? maxLines,
    List<VooValidationRule<String>>? validators,
  }) {
    return VooFormField<String>(
      id: id,
      name: name,
      label: label ?? name,
      hint: hint,
      helper: helper,
      type: VooFieldType.multiline,
      required: required,
      maxLength: maxLength,
      minLines: minLines ?? 3,
      maxLines: maxLines ?? 5,
      validators: validators ?? [],
    );
  }

  /// Create a URL field
  static VooFormField<String> urlField({
    required String id,
    String? name,
    String? label,
    String? hint,
    bool required = false,
    List<VooValidationRule<String>>? additionalValidators,
  }) {
    return VooFormField<String>(
      id: id,
      name: name ?? 'url',
      label: label ?? 'Website URL',
      hint: hint ?? 'https://example.com',
      type: VooFieldType.url,
      required: required,
      validators: [
        if (required) const RequiredValidation<String>(),
        const UrlValidation(),
        ...?additionalValidators,
      ],
      prefixIcon: Icons.link,
    );
  }

  /// Create a color picker field
  static VooFormField<Color> colorField({
    required String id,
    required String name,
    String? label,
    String? helper,
    Color? initialValue,
    List<VooValidationRule<Color>>? validators,
  }) {
    return VooFormField<Color>(
      id: id,
      name: name,
      label: label ?? name,
      helper: helper,
      type: VooFieldType.color,
      initialValue: initialValue ?? Colors.blue,
      validators: validators ?? [],
    );
  }

  /// Create field options from a map
  static List<VooFieldOption<T>> optionsFromMap<T>(
    Map<T, String> map, {
    Map<T, IconData>? icons,
    Map<T, String>? subtitles,
  }) {
    return map.entries.map((entry) {
      return VooFieldOption<T>(
        value: entry.key,
        label: entry.value,
        icon: icons?[entry.key],
        subtitle: subtitles?[entry.key],
      );
    }).toList();
  }

  /// Create field options from an enum
  static List<VooFieldOption<T>> optionsFromEnum<T extends Enum>(
    List<T> values, {
    String Function(T)? labelBuilder,
    IconData Function(T)? iconBuilder,
    String? Function(T)? subtitleBuilder,
  }) {
    return values.map((value) {
      return VooFieldOption<T>(
        value: value,
        label: labelBuilder?.call(value) ?? value.name,
        icon: iconBuilder?.call(value),
        subtitle: subtitleBuilder?.call(value),
      );
    }).toList();
  }
}
