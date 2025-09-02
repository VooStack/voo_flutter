import 'package:equatable/equatable.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/domain/enums/form_validation_mode.dart';

class VooForm extends Equatable {
  final String id;
  final String? title;
  final String? description;
  final List<VooFormField> fields;
  final bool enabled;
  final bool readOnly;
  final Map<String, dynamic> values;
  final Map<String, String> errors;
  final bool isValid;
  final bool isDirty;
  final bool isSubmitting;
  final bool isSubmitted;
  final FormValidationMode validationMode;

  const VooForm({
    required this.id,
    this.title,
    this.description,
    required this.fields,
    this.enabled = true,
    this.readOnly = false,
    this.values = const {},
    this.errors = const {},
    this.isValid = true,
    this.isDirty = false,
    this.isSubmitting = false,
    this.isSubmitted = false,
    this.validationMode = FormValidationMode.onSubmit,
  });

  VooForm copyWith({
    String? id,
    String? title,
    String? description,
    List<VooFormField>? fields,
    bool? enabled,
    bool? readOnly,
    Map<String, dynamic>? values,
    Map<String, String>? errors,
    bool? isValid,
    bool? isDirty,
    bool? isSubmitting,
    bool? isSubmitted,
    FormValidationMode? validationMode,
  }) =>
      VooForm(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        fields: fields ?? this.fields,
        enabled: enabled ?? this.enabled,
        readOnly: readOnly ?? this.readOnly,
        values: values ?? this.values,
        errors: errors ?? this.errors,
        isValid: isValid ?? this.isValid,
        isDirty: isDirty ?? this.isDirty,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isSubmitted: isSubmitted ?? this.isSubmitted,
        validationMode: validationMode ?? this.validationMode,
      );

  VooFormField? getField(String fieldId) {
    try {
      return fields.firstWhere((field) => field.id == fieldId);
    } catch (_) {
      return null;
    }
  }

  dynamic getValue(String fieldId) => values[fieldId];

  String? getError(String fieldId) => errors[fieldId];

  bool hasError(String fieldId) => errors.containsKey(fieldId) && errors[fieldId]!.isNotEmpty;

  Map<String, String> validateAll() {
    final Map<String, String> allErrors = {};

    for (final field in fields) {
      final error = field.validate();
      if (error != null) {
        allErrors[field.id] = error;
      }
    }

    return allErrors;
  }

  bool validate() {
    final allErrors = validateAll();
    return allErrors.isEmpty;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    for (final field in fields) {
      if (values.containsKey(field.id)) {
        json[field.name] = values[field.id];
      }
    }

    return json;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        fields,
        values,
        errors,
        isValid,
        isDirty,
        isSubmitting,
        isSubmitted,
        validationMode,
      ];
}
