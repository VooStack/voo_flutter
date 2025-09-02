import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form.dart' as domain;
import 'package:voo_forms/src/domain/enums/form_layout.dart';
import 'package:voo_forms/src/presentation/state/voo_form_controller.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_form_field_widget.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/layouts/voo_dynamic_form_layout.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/layouts/voo_grid_form_layout.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/layouts/voo_horizontal_form_layout.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/layouts/voo_vertical_form_layout.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/layouts/voo_wrapped_form_layout.dart';

/// Simple, atomic form widget that manages field collection and validation
/// Layout, actions, and callbacks are handled by VooFormPageBuilder
/// Follows KISS principle and atomic design
class VooForm extends StatefulWidget {
  /// List of field widgets - any widget that implements VooFormFieldWidget
  final List<VooFormFieldWidget> fields;

  /// Optional form controller for external control
  final VooFormController? controller;

  /// Layout type for the form
  final FormLayout layout;

  /// Number of columns for grid layout
  final int gridColumns;

  /// Spacing between fields
  final double spacing;

  /// Cross axis alignment for fields
  final CrossAxisAlignment crossAxisAlignment;

  /// Main axis alignment for fields
  final MainAxisAlignment mainAxisAlignment;

  /// Main axis size
  final MainAxisSize mainAxisSize;

  /// Optional callback when form values change
  final void Function(Map<String, dynamic>)? onChanged;

  /// Whether to show validation errors inline
  final bool showValidationErrors;

  const VooForm({
    super.key,
    required this.fields,
    this.controller,
    this.layout = FormLayout.dynamic,
    this.gridColumns = 2,
    this.spacing = 16.0,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
    this.onChanged,
    this.showValidationErrors = true,
  });

  @override
  State<VooForm> createState() => _VooFormState();
}

class _VooFormState extends State<VooForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _values = {};
  final Map<String, TextEditingController> _controllers = {};
  late VooFormController _controller;

  @override
  void initState() {
    super.initState();
    _initializeValues();

    // Create or use provided controller
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      // Create a minimal controller for value management
      _controller = VooFormController(
        form: domain.VooForm(
          id: 'voo_form_${DateTime.now().millisecondsSinceEpoch}',
          fields: const [],
        ),
      );
    }
    _controller.addListener(_handleControllerChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChange);
    if (widget.controller == null) {
      _controller.dispose();
    }
    // Clean up controllers
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleControllerChange() {
    if (mounted) {
      setState(() {});
      // Notify parent of changes
      widget.onChanged?.call(_controller.values);
    }
  }

  void _initializeValues() {
    // Initialize values from field initial values
    for (final field in widget.fields) {
      _values[field.name] = field.initialValue ?? field.value;
    }
  }

  /// Public method to validate the form
  bool validate() => _formKey.currentState?.validate() ?? false;

  /// Public method to save the form
  void save() {
    _formKey.currentState?.save();
  }

  /// Public method to reset the form
  void reset() {
    _formKey.currentState?.reset();
    _controller.reset();
  }

  /// Public method to get current values
  Map<String, dynamic> get values => _values;

  Widget _buildFormContent() {
    switch (widget.layout) {
      case FormLayout.vertical:
        return VooVerticalFormLayout(
          fields: widget.fields,
          spacing: widget.spacing,
          crossAxisAlignment: widget.crossAxisAlignment,
          mainAxisAlignment: widget.mainAxisAlignment,
          mainAxisSize: widget.mainAxisSize,
        );
      case FormLayout.horizontal:
        return VooHorizontalFormLayout(
          fields: widget.fields,
          spacing: widget.spacing,
          mainAxisAlignment: widget.mainAxisAlignment,
          mainAxisSize: widget.mainAxisSize,
        );
      case FormLayout.grid:
        return VooGridFormLayout(
          fields: widget.fields,
          columns: widget.gridColumns,
          spacing: widget.spacing,
          crossAxisAlignment: widget.crossAxisAlignment,
          mainAxisAlignment: widget.mainAxisAlignment,
          mainAxisSize: widget.mainAxisSize,
        );
      case FormLayout.wrapped:
        return VooWrappedFormLayout(
          fields: widget.fields,
          spacing: widget.spacing,
          runSpacing: widget.spacing,
        );
      case FormLayout.dynamic:
        return VooDynamicFormLayout(
          fields: widget.fields,
          spacing: widget.spacing,
          crossAxisAlignment: widget.crossAxisAlignment,
          mainAxisAlignment: widget.mainAxisAlignment,
          mainAxisSize: widget.mainAxisSize,
        );
      case FormLayout.stepped:
      case FormLayout.tabbed:
        // TODO: Implement stepped and tabbed layouts
        // For now, fallback to vertical
        return VooVerticalFormLayout(
          fields: widget.fields,
          spacing: widget.spacing,
          crossAxisAlignment: widget.crossAxisAlignment,
          mainAxisAlignment: widget.mainAxisAlignment,
          mainAxisSize: widget.mainAxisSize,
        );
    }
  }

  @override
  Widget build(BuildContext context) => Form(
        key: _formKey,
        child: _buildFormContent(),
      );
}

/// Extension to access VooForm methods from State
extension VooFormStateExtension on State {
  /// Find and validate the nearest VooForm
  bool? validateForm() {
    final formState = context.findAncestorStateOfType<_VooFormState>();
    return formState?.validate();
  }

  /// Find and save the nearest VooForm
  void saveForm() {
    final formState = context.findAncestorStateOfType<_VooFormState>();
    formState?.save();
  }

  /// Find and reset the nearest VooForm
  void resetForm() {
    final formState = context.findAncestorStateOfType<_VooFormState>();
    formState?.reset();
  }

  /// Get values from the nearest VooForm
  Map<String, dynamic>? getFormValues() {
    final formState = context.findAncestorStateOfType<_VooFormState>();
    return formState?.values;
  }
}
