import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:voo_forms/src/domain/entities/validation_rule.dart';
import 'package:voo_forms/src/domain/enums/form_error_display_mode.dart';
import 'package:voo_forms/src/domain/enums/form_validation_mode.dart';

/// Configuration for a form field used by the controller
class FormFieldConfig {
  final String name;
  final dynamic initialValue;
  final List<dynamic> validators; // Can be functions or VooValidationRule objects
  final ValueChanged<dynamic>? onChanged;
  final bool enabled;
  final bool visible;
  
  const FormFieldConfig({
    required this.name,
    this.initialValue,
    this.validators = const [],
    this.onChanged,
    this.enabled = true,
    this.visible = true,
  });
}

/// Form controller that manages form state without depending on domain entities
class VooFormController extends ChangeNotifier {
  final Map<String, TextEditingController> _textControllers = {};
  final Map<String, FocusNode> _focusNodes = {};
  final Map<String, dynamic> _fieldValues = {};
  final Map<String, String> _fieldErrors = {};
  final Map<String, List<dynamic>> _validators = {}; // Can be functions or VooValidationRule objects
  final Map<String, ValueChanged<dynamic>?> _onChangedCallbacks = {};
  final Map<String, bool> _fieldEnabled = {};
  final Map<String, bool> _fieldVisible = {};
  
  final VooFormErrorDisplayMode errorDisplayMode;
  final FormValidationMode validationMode;
  
  bool _hasSubmitted = false;
  bool _isDirty = false;
  bool _isSubmitting = false;
  bool _isSubmitted = false;
  bool _isResetting = false;  // Track when we're resetting to avoid validation
  bool _isInitializing = false;  // Track when we're initializing to avoid triggering changes

  VooFormController({
    this.errorDisplayMode = VooFormErrorDisplayMode.onTyping,
    this.validationMode = FormValidationMode.onSubmit,
    Map<String, FormFieldConfig>? fields,
  }) {
    if (fields != null) {
      registerFields(fields);
    }
  }

  // Public getters
  Map<String, dynamic> get values => Map.unmodifiable(_fieldValues);
  Map<String, String> get errors => Map.unmodifiable(_fieldErrors);
  bool get isValid => validate(silent: true);
  bool get isDirty => _isDirty;
  bool get isSubmitting => _isSubmitting;
  bool get isSubmitted => _isSubmitted;
  bool get hasSubmitted => _hasSubmitted;

  /// Register fields with the controller
  void registerFields(Map<String, FormFieldConfig> fields) {
    fields.forEach((fieldName, config) {
      registerField(
        fieldName,
        initialValue: config.initialValue,
        validators: config.validators,
        onChanged: config.onChanged,
        enabled: config.enabled,
        visible: config.visible,
      );
    });
  }

  /// Register a single field with the controller
  void registerField(
    String fieldName, {
    dynamic initialValue,
    List<dynamic> validators = const [], // Can be functions or VooValidationRule objects
    ValueChanged<dynamic>? onChanged,
    bool enabled = true,
    bool visible = true,
  }) {
    // Store field configuration
    _validators[fieldName] = validators;
    _onChangedCallbacks[fieldName] = onChanged;
    _fieldEnabled[fieldName] = enabled;
    _fieldVisible[fieldName] = visible;
    
    // Initialize value
    if (initialValue != null) {
      _fieldValues[fieldName] = initialValue;
    }
    
    // Create focus node if not exists
    _focusNodes.putIfAbsent(fieldName, FocusNode.new);
  }

  /// Create and register a text controller for a field
  TextEditingController registerTextController(String fieldName, {String? initialText}) {
    if (_textControllers.containsKey(fieldName)) {
      final existingController = _textControllers[fieldName]!;
      // Update the text if initialText is provided and different
      if (initialText != null && existingController.text != initialText) {
        _isInitializing = true;  // Prevent triggering changes during initialization
        existingController.text = initialText;
        _isInitializing = false;
      }
      return existingController;
    }
    
    final controller = TextEditingController(
      text: initialText ?? _fieldValues[fieldName]?.toString() ?? '',
    );
    
    controller.addListener(() {
      _handleFieldChange(fieldName, controller.text);
    });
    
    _textControllers[fieldName] = controller;
    return controller;
  }

  /// Get or create a text controller for a field
  TextEditingController? getTextController(String fieldName) => _textControllers[fieldName];

  /// Get or create a focus node for a field
  FocusNode getFocusNode(String fieldName) =>
      _focusNodes.putIfAbsent(fieldName, FocusNode.new);

  /// Get the current value of a field
  dynamic getValue(String fieldName) => _fieldValues[fieldName];

  /// Get the current value of a field with type safety
  T? getTypedValue<T>(String fieldName) {
    final value = _fieldValues[fieldName];
    if (value is T) return value;
    return null;
  }

  /// Get the current error for a field
  String? getError(String fieldName) => _fieldErrors[fieldName];

  /// Check if a field has an error
  bool hasError(String fieldName) => _fieldErrors.containsKey(fieldName) && _fieldErrors[fieldName]!.isNotEmpty;

  /// Set the value of a field
  void setValue(String fieldName, dynamic value, {bool validate = false}) {
    _fieldValues[fieldName] = value;
    
    if (!_isDirty) {
      _isDirty = true;
      notifyListeners();
    }
    
    // Update text controller if it exists
    if (_textControllers.containsKey(fieldName)) {
      final text = value?.toString() ?? '';
      if (_textControllers[fieldName]!.text != text) {
        _textControllers[fieldName]!.text = text;
      }
    }
    
    // Validate if requested or based on mode
    if (validate || (validationMode == FormValidationMode.onChange && errorDisplayMode == VooFormErrorDisplayMode.onTyping)) {
      validateField(fieldName);
    }
    
    notifyListeners();
  }

  /// Set multiple field values at once
  void setValues(Map<String, dynamic> values, {bool validate = false}) {
    values.forEach((fieldName, value) {
      _fieldValues[fieldName] = value;
      
      // Update text controller if it exists
      if (_textControllers.containsKey(fieldName)) {
        final text = value?.toString() ?? '';
        if (_textControllers[fieldName]!.text != text) {
          _textControllers[fieldName]!.text = text;
        }
      }
    });
    
    if (!_isDirty) {
      _isDirty = true;
    }
    
    if (validate || validationMode == FormValidationMode.onChange) {
      validateAll();
    }
    
    notifyListeners();
  }

  void _handleFieldChange(String fieldName, dynamic value) {
    // Skip handling changes during initialization or reset
    if (_isInitializing || _isResetting) {
      return;
    }
    
    if (_fieldValues[fieldName] != value) {
      // Only validate onChange if errorDisplayMode is onTyping
      final shouldValidate = errorDisplayMode == VooFormErrorDisplayMode.onTyping;
      setValue(fieldName, value, validate: shouldValidate);
      
      // Call field's onChange callback
      _onChangedCallbacks[fieldName]?.call(value);
    }
  }

  /// Validate a single field
  bool validateField(String fieldName, {bool force = false}) {
    final validators = _validators[fieldName];
    if (validators == null || validators.isEmpty) return true;
    
    // Check if we should show errors based on errorDisplayMode
    final shouldShowError = force || 
        errorDisplayMode == VooFormErrorDisplayMode.onTyping ||
        (errorDisplayMode == VooFormErrorDisplayMode.onSubmit && _hasSubmitted);
    
    final value = _fieldValues[fieldName];
    String? fieldError;
    
    // Run through validators until we find an error
    for (final validator in validators) {
      String? error;
      
      // Handle both function validators and VooValidationRule objects
      if (validator is Function) {
        try {
          final result = validator(value);
          if (result is String && result.isNotEmpty) {
            error = result;
          }
        } catch (e) {
          // Validator threw an exception
          error = 'Validation error';
        }
      } else if (validator is VooValidationRule) {
        error = validator.validate(value);
      }
      
      if (error != null && error.isNotEmpty) {
        fieldError = error;
        break;
      }
    }
    
    if (shouldShowError) {
      if (fieldError != null) {
        _fieldErrors[fieldName] = fieldError;
      } else {
        _fieldErrors.remove(fieldName);
      }
      notifyListeners();
    }
    
    return fieldError == null;
  }

  /// Validate all fields
  bool validateAll({bool force = false}) {
    // Check if we should show errors based on errorDisplayMode
    final shouldShowError = force || 
        errorDisplayMode == VooFormErrorDisplayMode.onTyping ||
        (errorDisplayMode == VooFormErrorDisplayMode.onSubmit && _hasSubmitted) ||
        errorDisplayMode == VooFormErrorDisplayMode.none;
    
    // Clear errors when we're about to re-validate with error display
    if (shouldShowError) {
      _fieldErrors.clear();
    }
    
    bool allFieldsValid = true;
    
    for (final entry in _validators.entries) {
      final fieldName = entry.key;
      final validators = entry.value;
      
      if (validators.isEmpty) continue;
      
      final value = _fieldValues[fieldName];
      String? fieldError;
      
      // Run through validators until we find an error
      for (final validator in validators) {
        String? error;
        
        // Handle both function validators and VooValidationRule objects
        if (validator is Function) {
          try {
            final result = validator(value);
            if (result is String && result.isNotEmpty) {
              error = result;
            }
          } catch (e) {
            // Validator threw an exception
            error = 'Validation error';
          }
        } else if (validator is VooValidationRule) {
          error = validator.validate(value);
        }
        
        if (error != null && error.isNotEmpty) {
          fieldError = error;
          break; // Stop checking validators for this field
        }
      }
      
      if (fieldError != null) {
        if (shouldShowError) {
          _fieldErrors[fieldName] = fieldError;
        }
        allFieldsValid = false;
      }
    }
    
    if (shouldShowError) {
      notifyListeners();
    }
    
    return allFieldsValid;
  }

  /// Validate the form (optionally silent)
  bool validate({bool silent = false}) {
    if (silent) {
      // Silent validation - check all validators without updating UI
      bool allValid = true;
      
      for (final entry in _validators.entries) {
        final fieldName = entry.key;
        final validators = entry.value;
        if (validators.isEmpty) continue;
        
        final value = _fieldValues[fieldName];
        
        for (final validator in validators) {
          String? error;
          
          // Handle both function validators and VooValidationRule objects
          if (validator is Function) {
            try {
              final result = validator(value);
              if (result is String && result.isNotEmpty) {
                error = result;
              }
            } catch (e) {
              // Validator threw an exception, treat as invalid
              error = 'Validation error';
            }
          } else if (validator is VooValidationRule) {
            error = validator.validate(value);
          }
          
          if (error != null && error.isNotEmpty) {
            allValid = false;
            break; // No need to check more validators for this field
          }
        }
        
        if (!allValid) break; // Exit early if we found an invalid field
      }
      
      return allValid;
    }
    
    // Non-silent validation updates the UI based on display mode
    // Only force display if we're in onTyping mode or if the form has been submitted
    final shouldForce = errorDisplayMode == VooFormErrorDisplayMode.onTyping || _hasSubmitted;
    return validateAll(force: shouldForce);
  }

  /// Clear all errors
  void clearErrors() {
    _fieldErrors.clear();
    notifyListeners();
  }

  /// Clear error for a specific field
  void clearError(String fieldName) {
    _fieldErrors.remove(fieldName);
    notifyListeners();
  }

  /// Reset form to initial values
  void reset() {
    _isResetting = true;  // Set flag to prevent validation during reset
    _fieldValues.clear();
    _fieldErrors.clear();
    _hasSubmitted = false;
    _isDirty = false;
    _isSubmitting = false;
    _isSubmitted = false;
    
    // Reset text controllers
    for (final controller in _textControllers.values) {
      controller.clear();
    }
    
    _isResetting = false;  // Clear flag after reset
    notifyListeners();
  }

  /// Clear all form values
  void clear() {
    _fieldValues.clear();
    _fieldErrors.clear();
    _hasSubmitted = false;
    _isDirty = false;
    
    // Clear text controllers
    for (final controller in _textControllers.values) {
      controller.clear();
    }
    
    notifyListeners();
  }

  /// Submit the form
  Future<bool> submit({
    required Future<void> Function(Map<String, dynamic> values) onSubmit,
    VoidCallback? onSuccess,
    void Function(dynamic error)? onError,
  }) async {
    if (_isSubmitting) return false;
    
    // Mark as submitted for error display
    _hasSubmitted = true;
    
    // Validate all fields (force display of errors on submit)
    if (!validateAll(force: true)) {
      return false;
    }
    
    _isSubmitting = true;
    notifyListeners();
    
    try {
      await onSubmit(_fieldValues);
      _isSubmitting = false;
      _isSubmitted = true;
      _isDirty = false;
      onSuccess?.call();
      notifyListeners();
      return true;
    } catch (error) {
      _isSubmitting = false;
      onError?.call(error);
      notifyListeners();
      return false;
    }
  }

  /// Convert form values to JSON
  Map<String, dynamic> toJson() => Map.from(_fieldValues);

  /// Focus a specific field
  void focusField(String fieldName) {
    _focusNodes[fieldName]?.requestFocus();
  }

  /// Focus the next field in the tab order
  void focusNextField(String currentFieldName) {
    final visibleFields = _fieldVisible.entries
        .where((e) => e.value && _fieldEnabled[e.key] == true)
        .map((e) => e.key)
        .toList();
    
    final currentIndex = visibleFields.indexOf(currentFieldName);
    if (currentIndex >= 0 && currentIndex < visibleFields.length - 1) {
      focusField(visibleFields[currentIndex + 1]);
    }
  }

  /// Focus the previous field in the tab order
  void focusPreviousField(String currentFieldName) {
    final visibleFields = _fieldVisible.entries
        .where((e) => e.value && _fieldEnabled[e.key] == true)
        .map((e) => e.key)
        .toList();
    
    final currentIndex = visibleFields.indexOf(currentFieldName);
    if (currentIndex > 0) {
      focusField(visibleFields[currentIndex - 1]);
    }
  }

  /// Enable a field
  void enableField(String fieldName) {
    _fieldEnabled[fieldName] = true;
    notifyListeners();
  }

  /// Disable a field
  void disableField(String fieldName) {
    _fieldEnabled[fieldName] = false;
    notifyListeners();
  }

  /// Check if a field is enabled
  bool isFieldEnabled(String fieldName) => _fieldEnabled[fieldName] ?? true;

  /// Show a field
  void showField(String fieldName) {
    _fieldVisible[fieldName] = true;
    notifyListeners();
  }

  /// Hide a field
  void hideField(String fieldName) {
    _fieldVisible[fieldName] = false;
    notifyListeners();
  }

  /// Check if a field is visible
  bool isFieldVisible(String fieldName) => _fieldVisible[fieldName] ?? true;

  /// Add validators to a field
  void addValidators(String fieldName, List<dynamic> validators) {
    _validators[fieldName] = [...(_validators[fieldName] ?? []), ...validators];
  }

  /// Set validators for a field (replaces existing)
  void setValidators(String fieldName, List<dynamic> validators) {
    _validators[fieldName] = validators;
  }

  /// Remove all validators from a field
  void removeValidators(String fieldName) {
    _validators.remove(fieldName);
  }

  @override
  void dispose() {
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }
}

/// Hook for easy form controller usage
VooFormController useVooFormController({
  VooFormErrorDisplayMode errorDisplayMode = VooFormErrorDisplayMode.onTyping,
  FormValidationMode validationMode = FormValidationMode.onSubmit,
  Map<String, FormFieldConfig>? fields,
}) => use(
      _VooFormControllerHook(
        errorDisplayMode: errorDisplayMode,
        validationMode: validationMode,
        fields: fields,
      ),
    );

class _VooFormControllerHook extends Hook<VooFormController> {
  final VooFormErrorDisplayMode errorDisplayMode;
  final FormValidationMode validationMode;
  final Map<String, FormFieldConfig>? fields;

  const _VooFormControllerHook({
    required this.errorDisplayMode,
    required this.validationMode,
    this.fields,
  });

  @override
  _VooFormControllerHookState createState() => _VooFormControllerHookState();
}

class _VooFormControllerHookState extends HookState<VooFormController, _VooFormControllerHook> {
  late VooFormController _controller;

  @override
  void initHook() {
    super.initHook();
    _controller = VooFormController(
      errorDisplayMode: hook.errorDisplayMode,
      validationMode: hook.validationMode,
      fields: hook.fields,
    );
  }

  @override
  VooFormController build(BuildContext context) => _controller;

  @override
  void dispose() {
    _controller.dispose();
  }
}