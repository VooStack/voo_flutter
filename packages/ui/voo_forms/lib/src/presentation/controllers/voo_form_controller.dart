import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:voo_forms/src/domain/entities/field_type.dart';
import 'package:voo_forms/src/domain/entities/form.dart';

class VooFormController extends ChangeNotifier {
  VooForm _form;
  final Map<String, TextEditingController> _textControllers = {};
  final Map<String, FocusNode> _focusNodes = {};
  final Map<String, dynamic> _fieldValues = {};
  final Map<String, String> _fieldErrors = {};
  final Map<String, GlobalKey> _fieldKeys = {};

  VooFormController({required VooForm form}) : _form = form {
    _initializeForm();
  }

  VooForm get form => _form;
  Map<String, dynamic> get values => Map.unmodifiable(_fieldValues);
  Map<String, String> get errors => Map.unmodifiable(_fieldErrors);
  bool get isValid => _fieldErrors.isEmpty && validate(silent: true);
  bool get isDirty => _form.isDirty;
  bool get isSubmitting => _form.isSubmitting;
  bool get isSubmitted => _form.isSubmitted;

  void _initializeForm() {
    for (final field in _form.fields) {
      // Initialize values
      if (field.initialValue != null) {
        _fieldValues[field.id] = field.initialValue;
      } else if (_form.values.containsKey(field.id)) {
        _fieldValues[field.id] = _form.values[field.id];
      }

      // Create text controllers for text fields
      if (field.type.isTextInput) {
        final controller = TextEditingController(
          text: _fieldValues[field.id]?.toString() ?? '',
        );
        controller.addListener(() {
          _handleFieldChange(field.id, controller.text);
        });
        _textControllers[field.id] = controller;
      }

      // Create focus nodes
      _focusNodes[field.id] = field.focusNode ?? FocusNode();
      _focusNodes[field.id]!.addListener(() {
        if (!_focusNodes[field.id]!.hasFocus && field.validateOnFocusLost) {
          validateField(field.id);
        }
      });

      // Create field keys for form field widgets
      _fieldKeys[field.id] = GlobalKey();
    }
  }

  TextEditingController? getTextController(String fieldId) => _textControllers[fieldId];

  FocusNode? getFocusNode(String fieldId) => _focusNodes[fieldId];

  GlobalKey? getFieldKey(String fieldId) => _fieldKeys[fieldId];

  dynamic getValue(String fieldId) => _fieldValues[fieldId];

  T? getTypedValue<T>(String fieldId) {
    final value = _fieldValues[fieldId];
    if (value is T) return value;
    return null;
  }

  String? getError(String fieldId) => _fieldErrors[fieldId];

  void setValue(String fieldId, dynamic value, {bool validate = false}) {
    _fieldValues[fieldId] = value;

    if (!_form.isDirty) {
      _form = _form.copyWith(isDirty: true);
    }

    // Update text controller if it exists
    if (_textControllers.containsKey(fieldId)) {
      final text = value?.toString() ?? '';
      if (_textControllers[fieldId]!.text != text) {
        _textControllers[fieldId]!.text = text;
      }
    }

    if (validate || _form.validationMode == FormValidationMode.onChange) {
      validateField(fieldId);
    }

    notifyListeners();
  }

  void setValues(Map<String, dynamic> values, {bool validate = false}) {
    values.forEach((key, value) {
      if (_form.fields.any((field) => field.id == key)) {
        _fieldValues[key] = value;

        // Update text controller if it exists
        if (_textControllers.containsKey(key)) {
          final text = value?.toString() ?? '';
          if (_textControllers[key]!.text != text) {
            _textControllers[key]!.text = text;
          }
        }
      }
    });

    if (!_form.isDirty) {
      _form = _form.copyWith(isDirty: true);
    }

    if (validate || _form.validationMode == FormValidationMode.onChange) {
      validateAll();
    }

    notifyListeners();
  }

  void _handleFieldChange(String fieldId, dynamic value) {
    if (_fieldValues[fieldId] != value) {
      setValue(fieldId, value);

      final field = _form.getField(fieldId);
      field?.onChanged?.call(value);
    }
  }

  bool validateField(String fieldId) {
    final field = _form.getField(fieldId);
    if (field == null) return true;

    // Create a field with the current value
    final fieldWithValue = field.copyWith(value: _fieldValues[fieldId]);
    final error = fieldWithValue.validate();

    if (error != null) {
      _fieldErrors[fieldId] = error;
    } else {
      _fieldErrors.remove(fieldId);
    }

    notifyListeners();
    return error == null;
  }

  bool validateAll() {
    _fieldErrors.clear();
    bool isValid = true;

    for (final field in _form.fields) {
      // Create a field with the current value
      final fieldWithValue = field.copyWith(value: _fieldValues[field.id]);
      final error = fieldWithValue.validate();

      if (error != null) {
        _fieldErrors[field.id] = error;
        isValid = false;
      }
    }

    _form = _form.copyWith(
      isValid: isValid,
      errors: _fieldErrors,
    );

    notifyListeners();
    return isValid;
  }

  bool validate({bool silent = false}) {
    if (silent) {
      for (final field in _form.fields) {
        final fieldWithValue = field.copyWith(value: _fieldValues[field.id]);
        final error = fieldWithValue.validate();
        if (error != null) return false;
      }
      return true;
    }
    return validateAll();
  }

  void clearErrors() {
    _fieldErrors.clear();
    _form = _form.copyWith(errors: {}, isValid: true);
    notifyListeners();
  }

  void clearError(String fieldId) {
    _fieldErrors.remove(fieldId);
    _form = _form.copyWith(errors: _fieldErrors);
    notifyListeners();
  }

  void reset() {
    _fieldValues.clear();
    _fieldErrors.clear();

    // Reset to initial values
    for (final field in _form.fields) {
      if (field.initialValue != null) {
        _fieldValues[field.id] = field.initialValue;
      }

      // Reset text controllers
      if (_textControllers.containsKey(field.id)) {
        _textControllers[field.id]!.text = field.initialValue?.toString() ?? '';
      }
    }

    _form = _form.copyWith(
      isDirty: false,
      isSubmitting: false,
      isSubmitted: false,
      errors: {},
      isValid: true,
    );

    notifyListeners();
  }

  void clear() {
    _fieldValues.clear();
    _fieldErrors.clear();

    // Clear text controllers
    for (final controller in _textControllers.values) {
      controller.clear();
    }

    _form = _form.copyWith(
      isDirty: false,
      isSubmitting: false,
      isSubmitted: false,
      errors: {},
      isValid: true,
    );

    notifyListeners();
  }

  Future<bool> submit({
    required Future<void> Function(Map<String, dynamic> values) onSubmit,
    VoidCallback? onSuccess,
    void Function(dynamic error)? onError,
  }) async {
    if (_form.isSubmitting) return false;

    // Validate all fields
    if (!validateAll()) {
      return false;
    }

    _form = _form.copyWith(isSubmitting: true);
    notifyListeners();

    try {
      await onSubmit(_fieldValues);
      _form = _form.copyWith(
        isSubmitting: false,
        isSubmitted: true,
        isDirty: false,
      );
      onSuccess?.call();
      notifyListeners();
      return true;
    } catch (error) {
      _form = _form.copyWith(isSubmitting: false);
      onError?.call(error);
      notifyListeners();
      return false;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    for (final field in _form.fields) {
      if (_fieldValues.containsKey(field.id)) {
        json[field.name] = _fieldValues[field.id];
      }
    }

    return json;
  }

  void focusField(String fieldId) {
    _focusNodes[fieldId]?.requestFocus();
  }

  void focusNextField(String currentFieldId) {
    final fields = _form.fields.where((f) => f.visible && f.enabled).toList();
    final currentIndex = fields.indexWhere((f) => f.id == currentFieldId);

    if (currentIndex >= 0 && currentIndex < fields.length - 1) {
      final nextField = fields[currentIndex + 1];
      focusField(nextField.id);
    }
  }

  void focusPreviousField(String currentFieldId) {
    final fields = _form.fields.where((f) => f.visible && f.enabled).toList();
    final currentIndex = fields.indexWhere((f) => f.id == currentFieldId);

    if (currentIndex > 0) {
      final previousField = fields[currentIndex - 1];
      focusField(previousField.id);
    }
  }

  void updateForm(VooForm form) {
    _form = form;
    _initializeForm();
    notifyListeners();
  }

  void enableField(String fieldId) {
    final field = _form.getField(fieldId);
    if (field != null) {
      final updatedField = field.copyWith(enabled: true);
      final updatedFields = _form.fields.map((f) => f.id == fieldId ? updatedField : f).toList();
      _form = _form.copyWith(fields: updatedFields);
      notifyListeners();
    }
  }

  void disableField(String fieldId) {
    final field = _form.getField(fieldId);
    if (field != null) {
      final updatedField = field.copyWith(enabled: false);
      final updatedFields = _form.fields.map((f) => f.id == fieldId ? updatedField : f).toList();
      _form = _form.copyWith(fields: updatedFields);
      notifyListeners();
    }
  }

  void showField(String fieldId) {
    final field = _form.getField(fieldId);
    if (field != null) {
      final updatedField = field.copyWith(visible: true);
      final updatedFields = _form.fields.map((f) => f.id == fieldId ? updatedField : f).toList();
      _form = _form.copyWith(fields: updatedFields);
      notifyListeners();
    }
  }

  void hideField(String fieldId) {
    final field = _form.getField(fieldId);
    if (field != null) {
      final updatedField = field.copyWith(visible: false);
      final updatedFields = _form.fields.map((f) => f.id == fieldId ? updatedField : f).toList();
      _form = _form.copyWith(fields: updatedFields);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes.values) {
      if (_form.fields.every((field) => field.focusNode != focusNode)) {
        focusNode.dispose();
      }
    }
    super.dispose();
  }
}

// Hook for easy form controller usage
VooFormController useVooFormController(VooForm form) => use(_VooFormControllerHook(form: form));

class _VooFormControllerHook extends Hook<VooFormController> {
  final VooForm form;

  const _VooFormControllerHook({required this.form});

  @override
  _VooFormControllerHookState createState() => _VooFormControllerHookState();
}

class _VooFormControllerHookState extends HookState<VooFormController, _VooFormControllerHook> {
  late VooFormController _controller;

  @override
  void initHook() {
    super.initHook();
    _controller = VooFormController(form: hook.form);
  }

  @override
  VooFormController build(BuildContext context) => _controller;

  @override
  void dispose() {
    _controller.dispose();
  }
}
