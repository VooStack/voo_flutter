import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_forms/src/domain/entities/field_type.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/domain/entities/validation_rule.dart';
import 'package:voo_forms/src/presentation/formatters/strict_number_formatter.dart';

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
    int? maxLines,
    bool expanded = false,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization? textCapitalization,
    TextInputAction? textInputAction,
    IconData? prefixIcon,
    IconData? suffixIcon,
    Widget? prefix,
    Widget? suffix,
    int? gridColumns,
    ValueChanged<String?>? onChanged,
    Widget? readOnlyWidget,
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
        maxLines: maxLines ?? 1,
        expanded: expanded,
        inputFormatters: inputFormatters,
        textCapitalization: textCapitalization,
        textInputAction: textInputAction ?? TextInputAction.next,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        prefix: prefix,
        suffix: suffix,
        gridColumns: gridColumns,
        onChanged: onChanged,
        readOnlyWidget: readOnlyWidget,
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
    Widget? readOnlyWidget,
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
        readOnlyWidget: readOnlyWidget,
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
    Widget? readOnlyWidget,
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
        readOnlyWidget: readOnlyWidget,
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
    Widget? readOnlyWidget,
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
        readOnlyWidget: readOnlyWidget,
      );

  /// Number field factory with strict type enforcement
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
    bool allowDecimals = true,
    bool allowNegative = true,
    int? maxDecimalPlaces,
    IconData? prefixIcon,
    IconData? suffixIcon,
    int? gridColumns,
    ValueChanged<num?>? onChanged,
    Widget? readOnlyWidget,
  }) =>
      VooFormField<num>(
        id: name,
        name: name,
        type: VooFieldType.number,
        label: label,
        hint: hint,
        placeholder: placeholder ?? '0',
        helper: helper,
        initialValue: initialValue ?? defaultValue,
        required: required,
        enabled: enabled,
        readOnly: readOnly,
        validators: validators ?? [],
        keyboardType: const TextInputType.numberWithOptions(
          signed: true,
          decimal: true,
        ),
        inputFormatters: [
          StrictNumberFormatter(
            allowDecimals: allowDecimals,
            allowNegative: allowNegative,
            maxDecimalPlaces: maxDecimalPlaces,
            minValue: min,
            maxValue: max,
          ),
        ],
        min: min,
        max: max,
        step: step,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        gridColumns: gridColumns,
        onChanged: onChanged,
        readOnlyWidget: readOnlyWidget,
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
    bool expanded = false,
    IconData? prefixIcon,
    int? gridColumns,
    ValueChanged<String?>? onChanged,
    Widget? readOnlyWidget,
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
        expanded: expanded,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        prefixIcon: prefixIcon,
        gridColumns: gridColumns,
        onChanged: onChanged,
        readOnlyWidget: readOnlyWidget,
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
    Widget? readOnlyWidget,
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
        readOnlyWidget: readOnlyWidget,
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
    Widget? readOnlyWidget,
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
        readOnlyWidget: readOnlyWidget,
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
    Widget? readOnlyWidget,
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
        readOnlyWidget: readOnlyWidget,
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
    Widget? readOnlyWidget,
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
        readOnlyWidget: readOnlyWidget,
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
    Widget? readOnlyWidget,
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
        readOnlyWidget: readOnlyWidget,
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
    Widget? readOnlyWidget,
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
        readOnlyWidget: readOnlyWidget,
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
    Widget? readOnlyWidget,
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
        readOnlyWidget: readOnlyWidget,
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
    Widget? readOnlyWidget,
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
        readOnlyWidget: readOnlyWidget,
      );

  /// Integer field factory with strict integer-only input
  static VooFormField<int> integer({
    required String name,
    String? label,
    String? hint,
    String? placeholder,
    String? helper,
    int? initialValue,
    int? defaultValue,
    List<VooValidationRule<int>>? validators,
    bool required = false,
    bool enabled = true,
    bool readOnly = false,
    int? min,
    int? max,
    bool allowNegative = true,
    IconData? prefixIcon,
    IconData? suffixIcon,
    int? gridColumns,
    ValueChanged<int?>? onChanged,
    Widget? readOnlyWidget,
  }) =>
      VooFormField<int>(
        id: name,
        name: name,
        type: VooFieldType.number,
        label: label,
        hint: hint,
        placeholder: placeholder ?? '0',
        helper: helper,
        initialValue: initialValue ?? defaultValue,
        required: required,
        enabled: enabled,
        readOnly: readOnly,
        validators: validators ?? [],
        keyboardType: const TextInputType.numberWithOptions(
          signed: true,
        ),
        inputFormatters: [
          StrictIntegerFormatter(
            allowNegative: allowNegative,
            minValue: min,
            maxValue: max,
          ),
        ],
        min: min,
        max: max,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        gridColumns: gridColumns,
        onChanged: onChanged,
        readOnlyWidget: readOnlyWidget,
      );

  /// Decimal field factory with configurable decimal places
  static VooFormField<double> decimal({
    required String name,
    String? label,
    String? hint,
    String? placeholder,
    String? helper,
    double? initialValue,
    double? defaultValue,
    List<VooValidationRule<double>>? validators,
    bool required = false,
    bool enabled = true,
    bool readOnly = false,
    double? min,
    double? max,
    int maxDecimalPlaces = 2,
    bool allowNegative = true,
    IconData? prefixIcon,
    IconData? suffixIcon,
    int? gridColumns,
    ValueChanged<double?>? onChanged,
    Widget? readOnlyWidget,
  }) =>
      VooFormField<double>(
        id: name,
        name: name,
        type: VooFieldType.number,
        label: label,
        hint: hint,
        placeholder: placeholder ?? '0.00',
        helper: helper,
        initialValue: initialValue ?? defaultValue,
        required: required,
        enabled: enabled,
        readOnly: readOnly,
        validators: validators ?? [],
        keyboardType: const TextInputType.numberWithOptions(
          signed: true,
          decimal: true,
        ),
        inputFormatters: [
          StrictNumberFormatter(
            allowNegative: allowNegative,
            maxDecimalPlaces: maxDecimalPlaces,
            minValue: min,
            maxValue: max,
          ),
        ],
        min: min,
        max: max,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        gridColumns: gridColumns,
        onChanged: onChanged,
        readOnlyWidget: readOnlyWidget,
      );

  /// Currency field factory with 2 decimal places and no negative values
  static VooFormField<double> currency({
    required String name,
    String? label,
    String? hint,
    String? placeholder,
    String? helper,
    double? initialValue,
    double? defaultValue,
    List<VooValidationRule<double>>? validators,
    bool required = false,
    bool enabled = true,
    bool readOnly = false,
    double? max,
    IconData? prefixIcon,
    IconData? suffixIcon,
    String? prefix,
    int? gridColumns,
    ValueChanged<double?>? onChanged,
    Widget? readOnlyWidget,
  }) =>
      VooFormField<double>(
        id: name,
        name: name,
        type: VooFieldType.number,
        label: label,
        hint: hint,
        placeholder: placeholder ?? '0.00',
        helper: helper,
        initialValue: initialValue ?? defaultValue,
        required: required,
        enabled: enabled,
        readOnly: readOnly,
        validators: validators ?? [],
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
        ),
        inputFormatters: [
          CurrencyFormatter(maxValue: max),
        ],
        min: 0,
        max: max,
        prefixIcon: prefixIcon ?? Icons.attach_money,
        suffixIcon: suffixIcon,
        prefix: prefix != null ? Text(prefix) : null,
        gridColumns: gridColumns,
        onChanged: onChanged,
        readOnlyWidget: readOnlyWidget,
      );

  /// Percentage field factory (0-100)
  static VooFormField<double> percentage({
    required String name,
    String? label,
    String? hint,
    String? placeholder,
    String? helper,
    double? initialValue,
    double? defaultValue,
    List<VooValidationRule<double>>? validators,
    bool required = false,
    bool enabled = true,
    bool readOnly = false,
    bool allowDecimals = true,
    IconData? prefixIcon,
    IconData? suffixIcon,
    int? gridColumns,
    ValueChanged<double?>? onChanged,
    Widget? readOnlyWidget,
  }) =>
      VooFormField<double>(
        id: name,
        name: name,
        type: VooFieldType.number,
        label: label,
        hint: hint,
        placeholder: placeholder ?? (allowDecimals ? '0.00' : '0'),
        helper: helper ?? 'Enter a value between 0 and 100',
        initialValue: initialValue ?? defaultValue,
        required: required,
        enabled: enabled,
        readOnly: readOnly,
        validators: validators ?? [],
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
        ),
        inputFormatters: [
          PercentageFormatter(allowDecimals: allowDecimals),
        ],
        min: 0,
        max: 100,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon ?? Icons.percent,
        gridColumns: gridColumns,
        onChanged: onChanged,
        readOnlyWidget: readOnlyWidget,
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
    Widget? readOnlyWidget,
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
        readOnlyWidget: readOnlyWidget,
      );

  /// List field factory for dynamic collections of fields
  /// 
  /// Creates a field that can contain multiple instances of the same field type.
  /// Supports adding, removing, and optionally reordering items.
  /// 
  /// Example:
  /// ```dart
  /// VooField.list<String>(
  ///   name: 'emails',
  ///   label: 'Email Addresses',
  ///   itemTemplate: VooField.email(
  ///     name: 'email',
  ///     label: 'Email',
  ///     validators: [EmailValidator()],
  ///   ),
  ///   minItems: 1,
  ///   maxItems: 5,
  ///   initialItems: ['john@example.com'],
  /// )
  /// ```
  static VooFormField<List<T>> list<T>({
    required String name,
    String? label,
    String? hint,
    String? helper,
    required VooFormField<T> itemTemplate,
    List<T>? initialItems,
    int? minItems,
    int? maxItems,
    bool canAddItems = true,
    bool canRemoveItems = true,
    bool canReorderItems = false,
    String? addButtonText,
    String? removeButtonText,
    IconData? addButtonIcon,
    IconData? removeButtonIcon,
    List<VooValidationRule<List<T>>>? validators,
    bool required = false,
    bool enabled = true,
    bool readOnly = false,
    int? gridColumns,
    ValueChanged<List<T>?>? onChanged,
    Widget? readOnlyWidget,
  }) {
    // Create initial list items based on initialItems
    final List<VooFormField> listItems = [];
    if (initialItems != null) {
      for (int i = 0; i < initialItems.length; i++) {
        listItems.add(
          itemTemplate.copyWith(
            id: '${name}_item_$i',
            name: '${name}_$i',
            value: initialItems[i],
          ),
        );
      }
    } else if (minItems != null && minItems > 0) {
      // Add minimum required items
      for (int i = 0; i < minItems; i++) {
        listItems.add(
          itemTemplate.copyWith(
            id: '${name}_item_$i',
            name: '${name}_$i',
          ),
        );
      }
    }
    
    return VooFormField<List<T>>(
      id: name,
      name: name,
      type: VooFieldType.list,
      label: label,
      hint: hint,
      helper: helper,
      initialValue: initialItems,
      required: required,
      enabled: enabled,
      readOnly: readOnly,
      validators: validators ?? [],
      itemTemplate: itemTemplate,
      listItems: listItems,
      minItems: minItems,
      maxItems: maxItems,
      canAddItems: canAddItems && !readOnly,
      canRemoveItems: canRemoveItems && !readOnly,
      canReorderItems: canReorderItems && !readOnly,
      addButtonText: addButtonText ?? 'Add ${itemTemplate.label ?? 'Item'}',
      removeButtonText: removeButtonText ?? 'Remove',
      addButtonIcon: Icon(addButtonIcon ?? Icons.add_circle_outline),
      removeButtonIcon: Icon(removeButtonIcon ?? Icons.remove_circle_outline),
      gridColumns: gridColumns,
      onChanged: onChanged,
      readOnlyWidget: readOnlyWidget,
    );
  }
}