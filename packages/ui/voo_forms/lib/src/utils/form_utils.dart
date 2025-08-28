import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/field_change.dart';
import 'package:voo_forms/src/domain/entities/field_type.dart';
import 'package:voo_forms/src/domain/entities/form.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/domain/entities/form_section.dart';

/// Utility class for working with forms
class VooFormUtils {
  VooFormUtils._();

  /// Create a simple form with fields
  static VooForm createForm({
    required String id,
    String? title,
    String? description,
    required List<VooFormField> fields,
    FormLayout layout = FormLayout.vertical,
    FormValidationMode validationMode = FormValidationMode.onChange,
    Map<String, dynamic>? metadata,
  }) {
    return VooForm(
      id: id,
      title: title,
      description: description,
      fields: fields,
      layout: layout,
      validationMode: validationMode,
      metadata: metadata,
    );
  }

  /// Create a form with sections
  static VooForm createSectionedForm({
    required String id,
    String? title,
    String? description,
    required Map<VooFormSection, List<VooFormField>> sections,
    FormLayout layout = FormLayout.vertical,
    FormValidationMode validationMode = FormValidationMode.onChange,
    Map<String, dynamic>? metadata,
  }) {
    final allFields = <VooFormField>[];
    final formSections = <VooFormSection>[];
    
    sections.forEach((section, fields) {
      allFields.addAll(fields);
      formSections.add(
        section.copyWith(
          fieldIds: fields.map((f) => f.id).toList(),
        ),
      );
    });
    
    return VooForm(
      id: id,
      title: title,
      description: description,
      fields: allFields,
      sections: formSections,
      layout: layout,
      validationMode: validationMode,
      metadata: metadata,
    );
  }

  /// Create a stepped/wizard form
  static VooForm createSteppedForm({
    required String id,
    String? title,
    String? description,
    required List<FormStep> steps,
    FormValidationMode validationMode = FormValidationMode.onSubmit,
    Map<String, dynamic>? metadata,
  }) {
    final allFields = <VooFormField>[];
    final sections = <VooFormSection>[];
    
    for (int i = 0; i < steps.length; i++) {
      final step = steps[i];
      allFields.addAll(step.fields);
      sections.add(
        VooFormSection(
          id: 'step_$i',
          title: step.title,
          subtitle: step.subtitle,
          description: step.description,
          fieldIds: step.fields.map((f) => f.id).toList(),
          icon: step.icon,
        ),
      );
    }
    
    return VooForm(
      id: id,
      title: title,
      description: description,
      fields: allFields,
      sections: sections,
      layout: FormLayout.stepped,
      validationMode: validationMode,
      metadata: {
        'steps': steps.map((s) => s.toMap()).toList(),
        ...?metadata,
      },
    );
  }

  /// Validate form data against a form definition
  static Map<String, String> validateFormData({
    required VooForm form,
    required Map<String, dynamic> data,
  }) {
    final errors = <String, String>{};
    
    for (final field in form.fields) {
      final value = data[field.id];
      
      // Check required fields
      if (field.required) {
        if (value == null || 
            (value is String && value.isEmpty) ||
            (value is List && value.isEmpty)) {
          errors[field.id] = '${field.label ?? field.name} is required';
          continue;
        }
      }
      
      // Run field validators
      final fieldWithValue = field.copyWith(value: value);
      final error = fieldWithValue.validate();
      if (error != null) {
        errors[field.id] = error;
      }
    }
    
    return errors;
  }

  /// Serialize form data to JSON
  static Map<String, dynamic> serializeFormData({
    required VooForm form,
    required Map<String, dynamic> values,
    bool includeEmpty = false,
    bool useFieldNames = true,
  }) {
    final json = <String, dynamic>{};
    
    for (final field in form.fields) {
      final value = values[field.id];
      
      if (!includeEmpty && (value == null || 
          (value is String && value.isEmpty) ||
          (value is List && value.isEmpty))) {
        continue;
      }
      
      final key = useFieldNames ? field.name : field.id;
      
      // Transform value based on field type
      if (field.type == VooFieldType.date && value is DateTime) {
        json[key] = value.toIso8601String();
      } else if (field.type == VooFieldType.time && value is TimeOfDay) {
        json[key] = '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
      } else if (field.type == VooFieldType.color && value is Color) {
        json[key] = '#${(((value.r * 255.0).round() & 0xff) << 16 | ((value.g * 255.0).round() & 0xff) << 8 | ((value.b * 255.0).round() & 0xff)).toRadixString(16).padLeft(6, '0')}';
      } else {
        json[key] = value;
      }
    }
    
    return json;
  }

  /// Deserialize JSON data to form values
  static Map<String, dynamic> deserializeFormData({
    required VooForm form,
    required Map<String, dynamic> json,
    bool useFieldNames = true,
  }) {
    final values = <String, dynamic>{};
    
    for (final field in form.fields) {
      final key = useFieldNames ? field.name : field.id;
      final value = json[key];
      
      if (value == null) continue;
      
      // Transform value based on field type
      if (field.type == VooFieldType.date && value is String) {
        values[field.id] = DateTime.tryParse(value);
      } else if (field.type == VooFieldType.time && value is String) {
        final parts = value.split(':');
        if (parts.length == 2) {
          values[field.id] = TimeOfDay(
            hour: int.tryParse(parts[0]) ?? 0,
            minute: int.tryParse(parts[1]) ?? 0,
          );
        }
      } else if (field.type == VooFieldType.color && value is String) {
        if (value.startsWith('#') && value.length >= 7) {
          values[field.id] = Color(int.parse(value.substring(1), radix: 16) | 0xFF000000);
        }
      } else {
        values[field.id] = value;
      }
    }
    
    return values;
  }

  /// Get form progress (percentage of filled required fields)
  static double getFormProgress({
    required VooForm form,
    required Map<String, dynamic> values,
  }) {
    if (form.fields.isEmpty) return 0.0;
    
    final requiredFields = form.fields.where((f) => f.required).toList();
    if (requiredFields.isEmpty) return 1.0;
    
    int filledCount = 0;
    for (final field in requiredFields) {
      final value = values[field.id];
      if (value != null && 
          !(value is String && value.isEmpty) &&
          !(value is List && value.isEmpty)) {
        filledCount++;
      }
    }
    
    return filledCount / requiredFields.length;
  }

  /// Get unfilled required fields
  static List<VooFormField> getUnfilledRequiredFields({
    required VooForm form,
    required Map<String, dynamic> values,
  }) {
    return form.fields.where((field) {
      if (!field.required) return false;
      
      final value = values[field.id];
      return value == null || 
          (value is String && value.isEmpty) ||
          (value is List && value.isEmpty);
    }).toList();
  }

  /// Clone form with new values
  static VooForm cloneFormWithValues({
    required VooForm form,
    required Map<String, dynamic> values,
  }) {
    final updatedFields = form.fields.map((field) {
      if (values.containsKey(field.id)) {
        return field.copyWith(value: values[field.id]);
      }
      return field;
    }).toList();
    
    return form.copyWith(
      fields: updatedFields,
      values: values,
    );
  }

  /// Reset form to initial values
  static Map<String, dynamic> getInitialValues(VooForm form) {
    final values = <String, dynamic>{};
    
    for (final field in form.fields) {
      if (field.initialValue != null) {
        values[field.id] = field.initialValue;
      } else if (field.type == VooFieldType.boolean || 
                 field.type == VooFieldType.checkbox) {
        values[field.id] = false;
      } else if (field.type == VooFieldType.multiSelect) {
        values[field.id] = <dynamic>[];
      } else if (field.type == VooFieldType.rating) {
        values[field.id] = 0;
      } else if (field.type == VooFieldType.slider) {
        values[field.id] = field.min ?? 0;
      }
    }
    
    return values;
  }

  /// Check if form has unsaved changes
  static bool hasChanges({
    required VooForm form,
    required Map<String, dynamic> currentValues,
    Map<String, dynamic>? initialValues,
  }) {
    final initial = initialValues ?? getInitialValues(form);
    
    for (final field in form.fields) {
      final currentValue = currentValues[field.id];
      final initialValue = initial[field.id];
      
      if (currentValue != initialValue) {
        return true;
      }
    }
    
    return false;
  }

  /// Get field dependencies (fields that depend on other fields)
  static Map<String, List<String>> getFieldDependencies(VooForm form) {
    final dependencies = <String, List<String>>{};
    
    // This would be extended to support actual dependency definitions
    // For now, returning empty map
    return dependencies;
  }

  /// Filter visible fields based on conditions
  static List<VooFormField> getVisibleFields({
    required VooForm form,
    required Map<String, dynamic> values,
    Map<String, bool Function(dynamic)>? conditions,
  }) {
    if (conditions == null || conditions.isEmpty) {
      return form.fields.where((f) => f.visible).toList();
    }
    
    return form.fields.where((field) {
      if (!field.visible) return false;
      
      final condition = conditions[field.id];
      if (condition != null) {
        final dependencyValue = values[field.id];
        return condition(dependencyValue);
      }
      
      return true;
    }).toList();
  }

  /// Generate form summary
  static String generateFormSummary({
    required VooForm form,
    required Map<String, dynamic> values,
    bool includeEmpty = false,
  }) {
    final buffer = StringBuffer();
    
    if (form.title != null) {
      buffer.writeln('# ${form.title}');
      buffer.writeln();
    }
    
    for (final field in form.fields) {
      final value = values[field.id];
      
      if (!includeEmpty && (value == null || 
          (value is String && value.isEmpty) ||
          (value is List && value.isEmpty))) {
        continue;
      }
      
      final label = field.label ?? field.name;
      buffer.write('**$label**: ');
      
      if (value == null) {
        buffer.writeln('Not provided');
      } else if (value is List) {
        buffer.writeln(value.join(', '));
      } else if (value is bool) {
        buffer.writeln(value ? 'Yes' : 'No');
      } else if (value is DateTime) {
        buffer.writeln(value.toString().split(' ')[0]);
      } else {
        buffer.writeln(value.toString());
      }
    }
    
    return buffer.toString();
  }

  /// Merge form values from multiple sources
  static Map<String, dynamic> mergeFormValues({
    required List<Map<String, dynamic>> sources,
    bool overwriteNulls = false,
  }) {
    final merged = <String, dynamic>{};
    
    for (final source in sources) {
      source.forEach((key, value) {
        if (value != null || overwriteNulls) {
          merged[key] = value;
        }
      });
    }
    
    return merged;
  }

  /// Get changed fields between two value sets
  static Map<String, FieldChange> getChangedFields({
    required Map<String, dynamic> original,
    required Map<String, dynamic> current,
  }) {
    final changes = <String, FieldChange>{};
    
    final allKeys = {...original.keys, ...current.keys};
    
    for (final key in allKeys) {
      final originalValue = original[key];
      final currentValue = current[key];
      
      if (originalValue != currentValue) {
        changes[key] = FieldChange(
          fieldId: key,
          oldValue: originalValue,
          newValue: currentValue,
        );
      }
    }
    
    return changes;
  }

  /// Calculate form completeness percentage
  static double getFormCompleteness({
    required VooForm form,
    required Map<String, dynamic> values,
    bool includeOptional = false,
  }) {
    if (form.fields.isEmpty) return 1.0;
    
    final fieldsToCheck = includeOptional
        ? form.fields
        : form.fields.where((f) => f.required).toList();
    
    if (fieldsToCheck.isEmpty) return 1.0;
    
    int filledCount = 0;
    for (final field in fieldsToCheck) {
      final value = values[field.id];
      if (value != null &&
          !(value is String && value.isEmpty) &&
          !(value is List && value.isEmpty)) {
        filledCount++;
      }
    }
    
    return filledCount / fieldsToCheck.length;
  }

  /// Export form configuration as JSON
  static Map<String, dynamic> exportFormConfiguration(VooForm form) {
    return {
      'id': form.id,
      'title': form.title,
      'description': form.description,
      'layout': form.layout.toString(),
      'validationMode': form.validationMode.toString(),
      'fields': form.fields.map((field) => {
        'id': field.id,
        'name': field.name,
        'type': field.type.toString(),
        'label': field.label,
        'required': field.required,
        'enabled': field.enabled,
        'visible': field.visible,
        'readOnly': field.readOnly,
        'hint': field.hint,
        'helper': field.helper,
        'min': field.min,
        'max': field.max,
        'maxLength': field.maxLength,
        'minLines': field.minLines,
        'maxLines': field.maxLines,
      },).toList(),
      'sections': form.sections?.map((section) => {
        'id': section.id,
        'title': section.title,
        'subtitle': section.subtitle,
        'description': section.description,
        'fieldIds': section.fieldIds,
        'collapsed': section.collapsed,
        'collapsible': section.collapsible,
      },).toList(),
      'metadata': form.metadata,
    };
  }

  /// Group fields by section
  static Map<VooFormSection?, List<VooFormField>> groupFieldsBySection(VooForm form) {
    final grouped = <VooFormSection?, List<VooFormField>>{};
    
    if (form.sections == null || form.sections!.isEmpty) {
      grouped[null] = form.fields;
      return grouped;
    }
    
    for (final section in form.sections!) {
      final sectionFields = form.fields
          .where((field) => section.fieldIds.contains(field.id))
          .toList();
      grouped[section] = sectionFields;
    }
    
    // Add fields not in any section
    final fieldIdsInSections = form.sections!
        .expand((section) => section.fieldIds)
        .toSet();
    final orphanFields = form.fields
        .where((field) => !fieldIdsInSections.contains(field.id))
        .toList();
    
    if (orphanFields.isNotEmpty) {
      grouped[null] = orphanFields;
    }
    
    return grouped;
  }

  /// Apply conditional visibility rules
  static List<VooFormField> applyConditionalVisibility({
    required List<VooFormField> fields,
    required Map<String, dynamic> values,
    required Map<String, bool Function(Map<String, dynamic>)> rules,
  }) {
    return fields.map((field) {
      if (rules.containsKey(field.id)) {
        final rule = rules[field.id]!;
        final shouldShow = rule(values);
        return field.copyWith(visible: shouldShow);
      }
      return field;
    }).toList();
  }

  /// Generate form from JSON schema
  static VooForm fromJsonSchema(Map<String, dynamic> schema) {
    final fields = <VooFormField>[];
    final properties = schema['properties'] as Map<String, dynamic>?;
    final required = (schema['required'] as List<dynamic>?)?.cast<String>() ?? [];
    
    properties?.forEach((key, value) {
      final fieldSchema = value as Map<String, dynamic>;
      final type = fieldSchema['type'] as String?;
      final fieldType = _mapJsonTypeToFieldType(type);
      
      fields.add(VooFormField(
        id: key,
        name: key,
        label: fieldSchema['title'] as String?,
        hint: fieldSchema['description'] as String?,
        type: fieldType,
        required: required.contains(key),
        min: fieldSchema['minimum'],
        max: fieldSchema['maximum'],
        maxLength: fieldSchema['maxLength'] as int?,
        options: _parseOptions(fieldSchema['enum']),
      ),);
    });
    
    return VooForm(
      id: schema['id'] as String? ?? 'form_${DateTime.now().millisecondsSinceEpoch}',
      title: schema['title'] as String?,
      description: schema['description'] as String?,
      fields: fields,
    );
  }

  static VooFieldType _mapJsonTypeToFieldType(String? type) {
    switch (type) {
      case 'string':
        return VooFieldType.text;
      case 'number':
      case 'integer':
        return VooFieldType.number;
      case 'boolean':
        return VooFieldType.boolean;
      case 'array':
        return VooFieldType.multiSelect;
      default:
        return VooFieldType.text;
    }
  }

  static List<VooFieldOption>? _parseOptions(dynamic enumValues) {
    if (enumValues == null || enumValues is! List) return null;
    
    return enumValues.map((value) => VooFieldOption(
      value: value,
      label: value.toString(),
    ),).toList();
  }
}

/// Represents a step in a multi-step form
class FormStep {
  final String title;
  final String? subtitle;
  final String? description;
  final List<VooFormField> fields;
  final IconData? icon;
  final bool optional;

  const FormStep({
    required this.title,
    this.subtitle,
    this.description,
    required this.fields,
    this.icon,
    this.optional = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'fieldCount': fields.length,
      'optional': optional,
    };
  }
}