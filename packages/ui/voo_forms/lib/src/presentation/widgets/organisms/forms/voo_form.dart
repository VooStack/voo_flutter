import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/enums/form_error_display_mode.dart';
import 'package:voo_forms/src/domain/enums/form_layout.dart';
import 'package:voo_forms/src/presentation/state/voo_form_controller.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_field_base.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_form_field_widget.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/layouts/voo_dynamic_form_layout.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/layouts/voo_grid_form_layout.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/layouts/voo_horizontal_form_layout.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/layouts/voo_vertical_form_layout.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/layouts/voo_wrapped_form_layout.dart';

/// InheritedWidget to provide form-level configuration to all fields
class VooFormScope extends InheritedWidget {
  final bool isReadOnly;
  final bool isLoading;
  final VooFormController? controller;

  const VooFormScope({
    super.key,
    required this.isReadOnly,
    required this.isLoading,
    this.controller,
    required super.child,
  });

  static VooFormScope? of(BuildContext context) => 
      context.dependOnInheritedWidgetOfExactType<VooFormScope>();

  @override
  bool updateShouldNotify(VooFormScope oldWidget) => 
      isReadOnly != oldWidget.isReadOnly || 
      isLoading != oldWidget.isLoading ||
      controller != oldWidget.controller;
}

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

  /// When to display validation errors
  final VooFormErrorDisplayMode errorDisplayMode;

  /// Whether all fields in the form should be read-only
  final bool isReadOnly;

  /// Whether the form is in a loading state
  final bool isLoading;

  /// Custom widget to show when form is loading
  final Widget? loadingWidget;

  const VooForm({
    super.key,
    required this.fields,
    this.controller,
    this.layout = FormLayout.dynamic,
    this.gridColumns = 2,
    this.spacing = 24.0,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
    this.onChanged,
    this.errorDisplayMode = VooFormErrorDisplayMode.onTyping,
    this.isReadOnly = false,
    this.isLoading = false,
    this.loadingWidget,
  });

  @override
  State<VooForm> createState() => _VooFormState();
}

class _VooFormState extends State<VooForm> {
  late VooFormController _controller;

  @override
  void initState() {
    super.initState();
    
    // Use provided controller or create a new one
    _controller = widget.controller ?? VooFormController(
      errorDisplayMode: widget.errorDisplayMode,
    );
    
    // Register all fields with the controller
    _registerFieldsWithController();
    
    _controller.addListener(_handleControllerChange);
  }
  
  void _registerFieldsWithController() {
    for (final field in widget.fields) {
      _controller.registerField(
        field.name,
        initialValue: field.initialValue,
        validators: field is VooFieldBase ? (field.validators ?? []) : [],
      );
      
      if (field.initialValue != null) {
        _controller.setValue(field.name, field.initialValue);
      }
    }
  }

  @override
  void didUpdateWidget(VooForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Always clear and re-register fields when widget updates
    // This ensures that new initial values are properly set
    _controller.clear();
    _registerFieldsWithController();
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChange);
    // Only dispose if we created the controller
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleControllerChange() {
    if (mounted) {
      setState(() {});
      widget.onChanged?.call(_controller.values);
    }
  }


  /// Prepare fields with readonly state applied
  List<VooFormFieldWidget> _prepareFields() {
    if (!widget.isReadOnly) return widget.fields;
    
    return widget.fields.map((field) {
      if (field is VooFieldBase) {
        return field.copyWith(
          readOnly: true,
          label: field.label,
          layout: field.layout,
        );
      }
      return field;
    }).toList();
  }

  Widget _buildFormContent() {
    final preparedFields = _prepareFields();

    switch (widget.layout) {
      case FormLayout.vertical:
        return VooVerticalFormLayout(
          fields: preparedFields,
          spacing: widget.spacing,
          crossAxisAlignment: widget.crossAxisAlignment,
          mainAxisAlignment: widget.mainAxisAlignment,
          mainAxisSize: widget.mainAxisSize,
        );
      case FormLayout.horizontal:
        return VooHorizontalFormLayout(
          fields: preparedFields,
          spacing: widget.spacing,
          mainAxisAlignment: widget.mainAxisAlignment,
          mainAxisSize: widget.mainAxisSize,
        );
      case FormLayout.grid:
        return VooGridFormLayout(
          fields: preparedFields,
          columns: widget.gridColumns,
          spacing: widget.spacing,
          crossAxisAlignment: widget.crossAxisAlignment,
          mainAxisAlignment: widget.mainAxisAlignment,
          mainAxisSize: widget.mainAxisSize,
        );
      case FormLayout.wrapped:
        return VooWrappedFormLayout(
          fields: preparedFields,
          spacing: widget.spacing,
          runSpacing: widget.spacing,
        );
      case FormLayout.dynamic:
        return VooDynamicFormLayout(
          fields: preparedFields,
          spacing: widget.spacing,
          crossAxisAlignment: widget.crossAxisAlignment,
          mainAxisAlignment: widget.mainAxisAlignment,
          mainAxisSize: widget.mainAxisSize,
        );
      case FormLayout.stepped:
      case FormLayout.tabbed:
        // TODO: Implement stepped and tabbed layouts
        return VooVerticalFormLayout(
          fields: preparedFields,
          spacing: widget.spacing,
          crossAxisAlignment: widget.crossAxisAlignment,
          mainAxisAlignment: widget.mainAxisAlignment,
          mainAxisSize: widget.mainAxisSize,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator if form is loading
    if (widget.isLoading) {
      return widget.loadingWidget ??
          const Center(
            child: CircularProgressIndicator(),
          );
    }

    // Show the form with controller in scope
    return VooFormScope(
      isReadOnly: widget.isReadOnly,
      isLoading: widget.isLoading,
      controller: _controller,
      child: _buildFormContent(),
    );
  }
}

