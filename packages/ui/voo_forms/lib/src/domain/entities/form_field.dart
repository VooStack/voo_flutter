import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_forms/src/domain/entities/field_type.dart';
import 'package:voo_forms/src/domain/entities/validation_rule.dart';

class VooFormField<T> extends Equatable {
  final String id;
  final String name;
  final String? label;
  final String? hint;
  final String? placeholder;
  final String? helper;
  final T? value;
  final T? initialValue;
  final VooFieldType type;
  final bool required;
  final bool enabled;
  final bool visible;
  final bool readOnly;
  final List<VooValidationRule<T>> validators;
  final ValueChanged<T?>? onChanged;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  
  // For selection fields
  final List<VooFieldOption<T>>? options;
  final bool allowMultiple;
  final List<VooFieldOption>? items;
  final Future<List<VooFieldOption<T>>> Function(String)? asyncOptionsLoader;
  final bool enableSearch;
  final String? searchHint;
  final Duration? searchDebounce;
  final int? minSearchLength;
  
  // For numeric fields
  final num? min;
  final num? max;
  final num? step;
  final int? divisions;
  
  // For text fields
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final String? pattern;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final bool? autocorrect;
  final bool? enableSuggestions;
  
  // For date/time fields
  final DateTime? minDate;
  final DateTime? maxDate;
  final TimeOfDay? minTime;
  final TimeOfDay? maxTime;
  
  // Styling
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? prefix;
  final Widget? suffix;
  final EdgeInsetsGeometry? padding;
  final InputDecoration? decoration;
  
  // Layout
  final int? gridColumns;
  final double? width;
  final double? height;
  final bool expanded;
  
  // List field specific
  final VooFormField? itemTemplate;
  final List<VooFormField>? listItems;
  final int? minItems;
  final int? maxItems;
  final bool canAddItems;
  final bool canRemoveItems;
  final bool canReorderItems;
  final String? addButtonText;
  final String? removeButtonText;
  final Widget? addButtonIcon;
  final Widget? removeButtonIcon;
  
  // Validation
  final String? error;
  final bool showError;
  final bool validateOnChange;
  final bool validateOnFocusLost;
  
  // Custom
  final Map<String, dynamic>? metadata;
  final String? customWidgetType;
  final Map<String, dynamic>? customWidgetData;
  final Widget? customWidget;
  final Widget Function(BuildContext context, VooFormField field, dynamic value)? customBuilder;
  final Widget? readOnlyWidget;

  const VooFormField({
    required this.id,
    required this.name,
    this.label,
    this.hint,
    this.placeholder,
    this.helper,
    this.value,
    this.initialValue,
    required this.type,
    this.required = false,
    this.enabled = true,
    this.visible = true,
    this.readOnly = false,
    this.validators = const [],
    this.onChanged,
    this.onTap,
    this.focusNode,
    this.controller,
    this.options,
    this.allowMultiple = false,
    this.items,
    this.asyncOptionsLoader,
    this.enableSearch = false,
    this.searchHint,
    this.searchDebounce,
    this.minSearchLength,
    this.min,
    this.max,
    this.step,
    this.divisions,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.pattern,
    this.inputFormatters,
    this.textCapitalization,
    this.textInputAction,
    this.keyboardType,
    this.obscureText,
    this.autocorrect,
    this.enableSuggestions,
    this.minDate,
    this.maxDate,
    this.minTime,
    this.maxTime,
    this.prefixIcon,
    this.suffixIcon,
    this.prefix,
    this.suffix,
    this.padding,
    this.decoration,
    this.gridColumns,
    this.width,
    this.height,
    this.expanded = false,
    this.itemTemplate,
    this.listItems,
    this.minItems,
    this.maxItems,
    this.canAddItems = true,
    this.canRemoveItems = true,
    this.canReorderItems = false,
    this.addButtonText,
    this.removeButtonText,
    this.addButtonIcon,
    this.removeButtonIcon,
    this.error,
    this.showError = true,
    this.validateOnChange = false,
    this.validateOnFocusLost = true,
    this.metadata,
    this.customWidgetType,
    this.customWidgetData,
    this.customWidget,
    this.customBuilder,
    this.readOnlyWidget,
  });

  VooFormField<T> copyWith({
    String? id,
    String? name,
    String? label,
    String? hint,
    String? placeholder,
    String? helper,
    T? value,
    T? initialValue,
    VooFieldType? type,
    bool? required,
    bool? enabled,
    bool? visible,
    bool? readOnly,
    List<VooValidationRule<T>>? validators,
    ValueChanged<T?>? onChanged,
    VoidCallback? onTap,
    FocusNode? focusNode,
    TextEditingController? controller,
    List<VooFieldOption<T>>? options,
    bool? allowMultiple,
    Future<List<VooFieldOption<T>>> Function(String)? asyncOptionsLoader,
    bool? enableSearch,
    String? searchHint,
    Duration? searchDebounce,
    int? minSearchLength,
    num? min,
    num? max,
    num? step,
    int? maxLength,
    int? maxLines,
    int? minLines,
    String? pattern,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization? textCapitalization,
    TextInputAction? textInputAction,
    TextInputType? keyboardType,
    bool? obscureText,
    bool? autocorrect,
    bool? enableSuggestions,
    int? divisions,
    List<VooFieldOption>? items,
    DateTime? minDate,
    DateTime? maxDate,
    TimeOfDay? minTime,
    TimeOfDay? maxTime,
    IconData? prefixIcon,
    IconData? suffixIcon,
    Widget? prefix,
    Widget? suffix,
    EdgeInsetsGeometry? padding,
    InputDecoration? decoration,
    int? gridColumns,
    double? width,
    double? height,
    bool? expanded,
    VooFormField? itemTemplate,
    List<VooFormField>? listItems,
    int? minItems,
    int? maxItems,
    bool? canAddItems,
    bool? canRemoveItems,
    bool? canReorderItems,
    String? addButtonText,
    String? removeButtonText,
    Widget? addButtonIcon,
    Widget? removeButtonIcon,
    String? error,
    bool? showError,
    bool? validateOnChange,
    bool? validateOnFocusLost,
    Map<String, dynamic>? metadata,
    String? customWidgetType,
    Map<String, dynamic>? customWidgetData,
    Widget? customWidget,
    Widget Function(BuildContext context, VooFormField field, dynamic value)? customBuilder,
    Widget? readOnlyWidget,
  }) =>
      VooFormField<T>(
        id: id ?? this.id,
        name: name ?? this.name,
        label: label ?? this.label,
        hint: hint ?? this.hint,
        placeholder: placeholder ?? this.placeholder,
        helper: helper ?? this.helper,
        value: value ?? this.value,
        initialValue: initialValue ?? this.initialValue,
        type: type ?? this.type,
        required: required ?? this.required,
        enabled: enabled ?? this.enabled,
        visible: visible ?? this.visible,
        readOnly: readOnly ?? this.readOnly,
        validators: validators ?? this.validators,
        onChanged: onChanged ?? this.onChanged,
        onTap: onTap ?? this.onTap,
        focusNode: focusNode ?? this.focusNode,
        controller: controller ?? this.controller,
        options: options ?? this.options,
        allowMultiple: allowMultiple ?? this.allowMultiple,
        items: items ?? this.items,
        asyncOptionsLoader: asyncOptionsLoader ?? this.asyncOptionsLoader,
        enableSearch: enableSearch ?? this.enableSearch,
        searchHint: searchHint ?? this.searchHint,
        searchDebounce: searchDebounce ?? this.searchDebounce,
        minSearchLength: minSearchLength ?? this.minSearchLength,
        min: min ?? this.min,
        max: max ?? this.max,
        step: step ?? this.step,
        divisions: divisions ?? this.divisions,
        maxLength: maxLength ?? this.maxLength,
        maxLines: maxLines ?? this.maxLines,
        minLines: minLines ?? this.minLines,
        pattern: pattern ?? this.pattern,
        inputFormatters: inputFormatters ?? this.inputFormatters,
        textCapitalization: textCapitalization ?? this.textCapitalization,
        textInputAction: textInputAction ?? this.textInputAction,
        keyboardType: keyboardType ?? this.keyboardType,
        obscureText: obscureText ?? this.obscureText,
        autocorrect: autocorrect ?? this.autocorrect,
        enableSuggestions: enableSuggestions ?? this.enableSuggestions,
        minDate: minDate ?? this.minDate,
        maxDate: maxDate ?? this.maxDate,
        minTime: minTime ?? this.minTime,
        maxTime: maxTime ?? this.maxTime,
        prefixIcon: prefixIcon ?? this.prefixIcon,
        suffixIcon: suffixIcon ?? this.suffixIcon,
        prefix: prefix ?? this.prefix,
        suffix: suffix ?? this.suffix,
        padding: padding ?? this.padding,
        decoration: decoration ?? this.decoration,
        gridColumns: gridColumns ?? this.gridColumns,
        width: width ?? this.width,
        height: height ?? this.height,
        expanded: expanded ?? this.expanded,
        itemTemplate: itemTemplate ?? this.itemTemplate,
        listItems: listItems ?? this.listItems,
        minItems: minItems ?? this.minItems,
        maxItems: maxItems ?? this.maxItems,
        canAddItems: canAddItems ?? this.canAddItems,
        canRemoveItems: canRemoveItems ?? this.canRemoveItems,
        canReorderItems: canReorderItems ?? this.canReorderItems,
        addButtonText: addButtonText ?? this.addButtonText,
        removeButtonText: removeButtonText ?? this.removeButtonText,
        addButtonIcon: addButtonIcon ?? this.addButtonIcon,
        removeButtonIcon: removeButtonIcon ?? this.removeButtonIcon,
        error: error ?? this.error,
        showError: showError ?? this.showError,
        validateOnChange: validateOnChange ?? this.validateOnChange,
        validateOnFocusLost: validateOnFocusLost ?? this.validateOnFocusLost,
        metadata: metadata ?? this.metadata,
        customWidgetType: customWidgetType ?? this.customWidgetType,
        customWidgetData: customWidgetData ?? this.customWidgetData,
        customWidget: customWidget ?? this.customWidget,
        customBuilder: customBuilder ?? this.customBuilder,
        readOnlyWidget: readOnlyWidget ?? this.readOnlyWidget,
      );

  String? validate() {
    // ignore: cast_nullable_to_non_nullable
    if (required && (value == null || (value is String && (value as String).isEmpty))) {
      return '${label ?? name} is required';
    }
    
    for (final validator in validators) {
      final error = validator.validate(value);
      if (error != null) {
        return error;
      }
    }
    
    return null;
  }

  bool get isValid => validate() == null;

  @override
  List<Object?> get props => [
    id,
    name,
    label,
    value,
    type,
    required,
    enabled,
    visible,
    readOnly,
    error,
    customWidget,
    customWidgetType,
    customWidgetData,
    // Note: customBuilder is not included as functions aren't suitable for equality
  ];
}

class VooFieldOption<T> extends Equatable {
  final T value;
  final String label;
  final String? subtitle;
  final IconData? icon;
  final bool enabled;
  final Map<String, dynamic>? metadata;

  const VooFieldOption({
    required this.value,
    required this.label,
    this.subtitle,
    this.icon,
    this.enabled = true,
    this.metadata,
  });

  @override
  List<Object?> get props => [value, label, subtitle, icon, enabled];
}

/// Type alias for dropdown children items
typedef VooDropdownChild<T> = VooFieldOption<T>;