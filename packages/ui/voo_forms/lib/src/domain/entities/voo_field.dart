import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_forms/src/domain/entities/field_type.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/domain/entities/validation_rule.dart';

/// Seamless field creation API using factory constructors
/// Returns VooFormField objects that can be used directly with forms
/// 
/// Example:
/// ```dart
/// VooSimpleForm(
///   fields: [
///     VooField.text(name: 'firstName', label: 'First Name'),
///     VooField.email(name: 'email', label: 'Email'),
///     VooField.dropdown(name: 'country', options: ['USA', 'Canada']),
///   ],
/// )
/// ```
class VooField {
  // Private constructor to prevent instantiation
  VooField._();

  /// Text field factory
  static VooFormField<String> text({
    required String name,
    String? label,
    String? hint,
    String? placeholder,
    String? helper,
    String? initialValue,
    List<VooValidationRule<String>>? validators,
    bool required = false,
    bool enabled = true,
    bool readOnly = false,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization? textCapitalization,
    TextInputAction? textInputAction,
    IconData? prefixIcon,
    IconData? suffixIcon,
    Widget? prefix,
    Widget? suffix,
    int? gridColumns,
  }) {
    return VooFormField<String>(
      id: name,
      name: name,
      type: VooFieldType.text,
      label: label,
      hint: hint,
      placeholder: placeholder,
      helper: helper,
      initialValue: initialValue,
      required: required,
      enabled: enabled,
      readOnly: readOnly,
      validators: validators ?? [],
      maxLength: maxLength,
      maxLines: 1,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction ?? TextInputAction.next,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      prefix: prefix,
      suffix: suffix,
      gridColumns: gridColumns,
    );
  }

  /// Email field factory
  static VooFormField<String> email({
    required String name,
    String? label,
    String? hint,
    String? placeholder,
    String? helper,
    String? initialValue,
    List<VooValidationRule<String>>? validators,
    bool required = false,
    bool enabled = true,
    bool readOnly = false,
    IconData? prefixIcon,
    IconData? suffixIcon,
    int? gridColumns,
  }) {
    return VooFormField<String>(
      id: name,
      name: name,
      type: VooFieldType.email,
      label: label,
      hint: hint,
      placeholder: placeholder ?? 'user@example.com',
      helper: helper,
      initialValue: initialValue,
      required: required,
      enabled: enabled,
      readOnly: readOnly,
      validators: validators ?? [],
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      prefixIcon: prefixIcon ?? Icons.email,
      suffixIcon: suffixIcon,
      gridColumns: gridColumns,
    );
  }

  /// Password field factory
  static VooFormField<String> password({
    required String name,
    String? label,
    String? hint,
    String? placeholder,
    String? helper,
    String? initialValue,
    List<VooValidationRule<String>>? validators,
    bool required = false,
    bool enabled = true,
    bool readOnly = false,
    IconData? prefixIcon,
    IconData? suffixIcon,
    int? gridColumns,
  }) {
    return VooFormField<String>(
      id: name,
      name: name,
      type: VooFieldType.password,
      label: label,
      hint: hint,
      placeholder: placeholder,
      helper: helper,
      initialValue: initialValue,
      required: required,
      enabled: enabled,
      readOnly: readOnly,
      validators: validators ?? [],
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      prefixIcon: prefixIcon ?? Icons.lock,
      suffixIcon: suffixIcon ?? Icons.visibility,
      gridColumns: gridColumns,
    );
  }

  /// Phone field factory
  static VooFormField<String> phone({
    required String name,
    String? label,
    String? hint,
    String? placeholder,
    String? helper,
    String? initialValue,
    List<VooValidationRule<String>>? validators,
    bool required = false,
    bool enabled = true,
    bool readOnly = false,
    List<TextInputFormatter>? inputFormatters,
    IconData? prefixIcon,
    IconData? suffixIcon,
    int? gridColumns,
  }) {
    return VooFormField<String>(
      id: name,
      name: name,
      type: VooFieldType.phone,
      label: label,
      hint: hint,
      placeholder: placeholder ?? '(555) 123-4567',
      helper: helper,
      initialValue: initialValue,
      required: required,
      enabled: enabled,
      readOnly: readOnly,
      validators: validators ?? [],
      keyboardType: TextInputType.phone,
      inputFormatters: inputFormatters,
      textInputAction: TextInputAction.next,
      prefixIcon: prefixIcon ?? Icons.phone,
      suffixIcon: suffixIcon,
      gridColumns: gridColumns,
    );
  }

  /// Number field factory
  static VooFormField<num> number({
    required String name,
    String? label,
    String? hint,
    String? placeholder,
    String? helper,
    num? initialValue,
    num? defaultValue,
    List<VooValidationRule<num>>? validators,
    bool required = false,
    bool enabled = true,
    bool readOnly = false,
    num? min,
    num? max,
    num? step,
    IconData? prefixIcon,
    IconData? suffixIcon,
    int? gridColumns,
  }) {
    return VooFormField<num>(
      id: name,
      name: name,
      type: VooFieldType.number,
      label: label,
      hint: hint,
      placeholder: placeholder,
      helper: helper,
      initialValue: initialValue ?? defaultValue,
      required: required,
      enabled: enabled,
      readOnly: readOnly,
      validators: validators ?? [],
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]'))],
      min: min,
      max: max,
      step: step,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      gridColumns: gridColumns,
    );
  }

  /// Multiline text field factory
  static VooFormField<String> multiline({
    required String name,
    String? label,
    String? hint,
    String? placeholder,
    String? helper,
    String? initialValue,
    List<VooValidationRule<String>>? validators,
    bool required = false,
    bool enabled = true,
    bool readOnly = false,
    int? maxLength,
    int? maxLines,
    int? minLines,
    IconData? prefixIcon,
    int? gridColumns,
  }) {
    return VooFormField<String>(
      id: name,
      name: name,
      type: VooFieldType.multiline,
      label: label,
      hint: hint,
      placeholder: placeholder,
      helper: helper,
      initialValue: initialValue,
      required: required,
      enabled: enabled,
      readOnly: readOnly,
      validators: validators ?? [],
      maxLength: maxLength,
      maxLines: maxLines ?? 5,
      minLines: minLines ?? 3,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      prefixIcon: prefixIcon,
      gridColumns: gridColumns,
    );
  }

  /// Generic dropdown field factory with custom type and converter
  /// 
  /// Example:
  /// ```dart
  /// class Country {
  ///   final String code;
  ///   final String name;
  ///   final String flag;
  ///   
  ///   const Country({required this.code, required this.name, required this.flag});
  /// }
  /// 
  /// VooField.dropdown<Country>(
  ///   name: 'country',
  ///   label: 'Select Country',
  ///   options: countries,
  ///   converter: (country) => VooDropdownChild(
  ///     value: country,
  ///     label: country.name,
  ///     subtitle: country.code,
  ///     icon: Icons.flag,
  ///   ),
  ///   initialValue: countries.first,
  ///   enableSearch: true,  // Enable search bar
  /// )
  /// ```
  static VooFormField<T> dropdown<T>({
    required String name,
    String? label,
    String? hint,
    String? helper,
    T? initialValue,
    T? defaultValue,
    required List<T> options,
    required VooDropdownChild<T> Function(T) converter,
    List<VooValidationRule<T>>? validators,
    bool required = false,
    bool enabled = true,
    bool readOnly = false,
    IconData? prefixIcon,
    IconData? suffixIcon,
    int? gridColumns,
    bool enableSearch = false,
    String? searchHint,
  }) {
    return VooFormField<T>(
      id: name,
      name: name,
      type: VooFieldType.dropdown,
      label: label,
      hint: hint,
      helper: helper,
      initialValue: initialValue ?? defaultValue,
      required: required,
      enabled: enabled,
      readOnly: readOnly,
      validators: validators ?? [],
      options: options.map(converter).toList(),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon ?? Icons.arrow_drop_down,
      gridColumns: gridColumns,
      enableSearch: enableSearch,
      searchHint: searchHint,
    );
  }

  /// Async dropdown field factory with dynamic loading
  /// 
  /// Example:
  /// ```dart
  /// VooField.dropdownAsync<User>(
  ///   name: 'user',
  ///   label: 'Select User',
  ///   asyncOptionsLoader: (query) async {
  ///     final users = await api.searchUsers(query);
  ///     return users.map((user) => VooFieldOption(
  ///       value: user,
  ///       label: user.name,
  ///       subtitle: user.email,
  ///       icon: Icons.person,
  ///     )).toList();
  ///   },
  ///   searchHint: 'Search users...',
  /// )
  /// ```
  static VooFormField<T> dropdownAsync<T>({
    required String name,
    String? label,
    String? hint,
    String? helper,
    T? initialValue,
    required Future<List<VooFieldOption<T>>> Function(String) asyncOptionsLoader,
    List<VooValidationRule<T>>? validators,
    bool required = false,
    bool enabled = true,
    bool readOnly = false,
    IconData? prefixIcon,
    IconData? suffixIcon,
    int? gridColumns,
    String? searchHint,
    Duration? searchDebounce,
    int minSearchLength = 0,
  }) {
    return VooFormField<T>(
      id: name,
      name: name,
      type: VooFieldType.dropdown,
      label: label,
      hint: hint,
      helper: helper,
      initialValue: initialValue,
      required: required,
      enabled: enabled,
      readOnly: readOnly,
      validators: validators ?? [],
      asyncOptionsLoader: asyncOptionsLoader,
      enableSearch: true,
      searchHint: searchHint,
      searchDebounce: searchDebounce,
      minSearchLength: minSearchLength,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon ?? Icons.arrow_drop_down,
      gridColumns: gridColumns,
    );
  }
  
  /// Simple dropdown field factory with strings
  /// 
  /// Example:
  /// ```dart
  /// VooField.dropdownSimple(
  ///   name: 'country',
  ///   options: ['USA', 'Canada', 'Mexico'],
  /// )
  /// ```
  static VooFormField dropdownSimple({
    required String name,
    String? label,
    String? hint,
    String? helper,
    String? initialValue,
    String? defaultValue,
    required List<String> options,
    List<VooValidationRule>? validators,
    bool required = false,
    bool enabled = true,
    bool readOnly = false,
    IconData? prefixIcon,
    IconData? suffixIcon,
    int? gridColumns,
    bool enableSearch = false,
    String? searchHint,
  }) {
    return VooFormField(
      id: name,
      name: name,
      type: VooFieldType.dropdown,
      label: label,
      hint: hint,
      helper: helper,
      initialValue: initialValue ?? defaultValue,
      required: required,
      enabled: enabled,
      readOnly: readOnly,
      validators: validators ?? [],
      options: options.map((option) => VooFieldOption(
        value: option,
        label: option,
      ),).toList(),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon ?? Icons.arrow_drop_down,
      gridColumns: gridColumns,
      enableSearch: enableSearch,
      searchHint: searchHint,
    );
  }

  /// Boolean/Switch field factory
  static VooFormField<bool> boolean({
    required String name,
    String? label,
    String? helper,
    bool initialValue = false,
    bool defaultValue = false,
    List<VooValidationRule<bool>>? validators,
    bool required = false,
    bool enabled = true,
    bool readOnly = false,
  }) {
    return VooFormField<bool>(
      id: name,
      name: name,
      type: VooFieldType.boolean,
      label: label,
      helper: helper,
      initialValue: initialValue || defaultValue,
      required: required,
      enabled: enabled,
      readOnly: readOnly,
      validators: validators ?? [],
    );
  }

  /// Checkbox field factory
  static VooFormField<bool> checkbox({
    required String name,
    String? label,
    String? helper,
    bool initialValue = false,
    List<VooValidationRule<bool>>? validators,
    bool required = false,
    bool enabled = true,
    bool readOnly = false,
  }) {
    return VooFormField<bool>(
      id: name,
      name: name,
      type: VooFieldType.checkbox,
      label: label,
      helper: helper,
      initialValue: initialValue,
      required: required,
      enabled: enabled,
      readOnly: readOnly,
      validators: validators ?? [],
    );
  }

  /// Radio field factory - simple version with strings
  static VooFormField radio({
    required String name,
    String? label,
    String? helper,
    String? initialValue,
    String? defaultValue,
    required List<String> options,
    List<VooValidationRule>? validators,
    bool required = false,
    bool enabled = true,
    bool readOnly = false,
  }) {
    return VooFormField(
      id: name,
      name: name,
      type: VooFieldType.radio,
      label: label,
      helper: helper,
      initialValue: initialValue ?? defaultValue,
      required: required,
      enabled: enabled,
      readOnly: readOnly,
      validators: validators ?? [],
      options: options.map((option) => VooFieldOption(
        value: option,
        label: option,
      ),).toList(),
    );
  }

  /// Date field factory
  static VooFormField<DateTime> date({
    required String name,
    String? label,
    String? hint,
    String? placeholder,
    String? helper,
    DateTime? initialValue,
    List<VooValidationRule<DateTime>>? validators,
    bool required = false,
    bool enabled = true,
    bool readOnly = false,
    DateTime? min,
    DateTime? max,
    IconData? prefixIcon,
    IconData? suffixIcon,
    int? gridColumns,
  }) {
    return VooFormField<DateTime>(
      id: name,
      name: name,
      type: VooFieldType.date,
      label: label,
      hint: hint,
      placeholder: placeholder ?? 'MM/DD/YYYY',
      helper: helper,
      initialValue: initialValue,
      required: required,
      enabled: enabled,
      readOnly: readOnly,
      validators: validators ?? [],
      minDate: min,
      maxDate: max,
      prefixIcon: prefixIcon ?? Icons.calendar_today,
      suffixIcon: suffixIcon,
      gridColumns: gridColumns,
    );
  }

  /// Time field factory
  static VooFormField<TimeOfDay> time({
    required String name,
    String? label,
    String? hint,
    String? placeholder,
    String? helper,
    TimeOfDay? initialValue,
    List<VooValidationRule<TimeOfDay>>? validators,
    bool required = false,
    bool enabled = true,
    bool readOnly = false,
    IconData? prefixIcon,
    IconData? suffixIcon,
    int? gridColumns,
  }) {
    return VooFormField<TimeOfDay>(
      id: name,
      name: name,
      type: VooFieldType.time,
      label: label,
      hint: hint,
      placeholder: placeholder ?? 'HH:MM',
      helper: helper,
      initialValue: initialValue,
      required: required,
      enabled: enabled,
      readOnly: readOnly,
      validators: validators ?? [],
      prefixIcon: prefixIcon ?? Icons.access_time,
      suffixIcon: suffixIcon,
      gridColumns: gridColumns,
    );
  }

  /// Slider field factory
  static VooFormField<double> slider({
    required String name,
    String? label,
    String? helper,
    double? initialValue,
    double? defaultValue,
    double min = 0,
    double max = 100,
    int? divisions,
    List<VooValidationRule<double>>? validators,
    bool required = false,
    bool enabled = true,
    bool readOnly = false,
  }) {
    return VooFormField<double>(
      id: name,
      name: name,
      type: VooFieldType.slider,
      label: label,
      helper: helper,
      initialValue: initialValue ?? defaultValue ?? min,
      required: required,
      enabled: enabled,
      readOnly: readOnly,
      validators: validators ?? [],
      min: min,
      max: max,
      divisions: divisions,
    );
  }
}