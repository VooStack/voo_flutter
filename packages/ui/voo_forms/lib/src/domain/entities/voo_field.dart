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
///     VooFormField.text(name: 'firstName', label: 'First Name'),
///     VooFormField.email(name: 'email', label: 'Email'),
///     VooFormField.dropdown(name: 'country', options: ['USA', 'Canada']),
///   ],
/// )
/// ```
/// 
/// Note: VooField static methods are now available as factory constructors on VooFormField.
/// VooField is maintained for backward compatibility.
class VooField {
  // Private constructor to prevent instantiation
  VooField._();

  /// Text field factory
  /// @deprecated Use VooFormField.text() instead
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
    ValueChanged<String?>? onChanged,
  }) =>
      VooFormField<String>(
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
        onChanged: onChanged,
      );

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
    ValueChanged<String?>? onChanged,
  }) =>
      VooFormField<String>(
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
        onChanged: onChanged,
      );

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
    ValueChanged<String?>? onChanged,
  }) =>
      VooFormField<String>(
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
        onChanged: onChanged,
      );

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
    ValueChanged<String?>? onChanged,
  }) =>
      VooFormField<String>(
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
        onChanged: onChanged,
      );

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
    ValueChanged<num?>? onChanged,
  }) =>
      VooFormField<num>(
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
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.-]'))],
        min: min,
        max: max,
        step: step,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        gridColumns: gridColumns,
        onChanged: onChanged,
      );

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
    ValueChanged<String?>? onChanged,
  }) =>
      VooFormField<String>(
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
        onChanged: onChanged,
      );

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
    ValueChanged<T?>? onChanged,
  }) =>
      VooFormField<T>(
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
        onChanged: onChanged,
      );

  /// Async dropdown field factory with dynamic loading
  /// 
  /// Example:
  /// ```dart
  /// VooField.dropdownAsync<User>(
  ///   name: 'user',
  ///   label: 'Select User',
  ///   asyncOptionsLoader: (query) async {
  ///     final users = await api.searchUsers(query);
  ///     return users;
  ///   },
  ///   converter: (user) => VooDropdownChild(
  ///     value: user,
  ///     label: user.name,
  ///     subtitle: user.email,
  ///     icon: Icons.person,
  ///   ),
  ///   searchHint: 'Search users...',
  /// )
  /// ```
  static VooFormField<T> dropdownAsync<T>({
    required String name,
    String? label,
    String? hint,
    String? helper,
    T? initialValue,
    required Future<List<T>> Function(String) asyncOptionsLoader,
    required VooDropdownChild<T> Function(T) converter,
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
    ValueChanged<T?>? onChanged,
  }) =>
      VooFormField<T>(
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
        asyncOptionsLoader: (query) async {
          final items = await asyncOptionsLoader(query);
          return items.map(converter).toList();
        },
        enableSearch: true,
        searchHint: searchHint,
        searchDebounce: searchDebounce,
        minSearchLength: minSearchLength,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon ?? Icons.arrow_drop_down,
        gridColumns: gridColumns,
        onChanged: onChanged,
      );
  
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
    ValueChanged? onChanged,
  }) =>
      VooFormField(
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
        options: options
            .map(
                (option) => VooFieldOption(
                  value: option,
                  label: option,
                ),
              )
            .toList(),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon ?? Icons.arrow_drop_down,
        gridColumns: gridColumns,
        enableSearch: enableSearch,
        searchHint: searchHint,
        onChanged: onChanged,
      );

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
    ValueChanged<bool?>? onChanged,
  }) =>
      VooFormField<bool>(
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
        onChanged: onChanged,
      );

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
    ValueChanged<bool?>? onChanged,
  }) =>
      VooFormField<bool>(
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
        onChanged: onChanged,
      );

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
    ValueChanged? onChanged,
  }) =>
      VooFormField(
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
        options: options
            .map(
                (option) => VooFieldOption(
                  value: option,
                  label: option,
                ),
              )
            .toList(),
        onChanged: onChanged,
      );

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
    ValueChanged<DateTime?>? onChanged,
  }) =>
      VooFormField<DateTime>(
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
        onChanged: onChanged,
      );

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
    ValueChanged<TimeOfDay?>? onChanged,
  }) =>
      VooFormField<TimeOfDay>(
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
        onChanged: onChanged,
      );

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
    ValueChanged<double?>? onChanged,
  }) =>
      VooFormField<double>(
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
        onChanged: onChanged,
      );
}