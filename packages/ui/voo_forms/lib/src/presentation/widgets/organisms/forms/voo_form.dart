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
  final int rebuildKey; // Add a key that changes when controller state changes

  const VooFormScope({super.key, required this.isReadOnly, required this.isLoading, this.controller, this.rebuildKey = 0, required super.child});

  static VooFormScope? of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<VooFormScope>();

  @override
  bool updateShouldNotify(VooFormScope oldWidget) =>
      isReadOnly != oldWidget.isReadOnly || isLoading != oldWidget.isLoading || controller != oldWidget.controller || rebuildKey != oldWidget.rebuildKey; // Notify when rebuild key changes
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
  int _rebuildKey = 0;
  final Set<String> _fieldsWithLoadedValues = {};

  @override
  void initState() {
    super.initState();

    // Use provided controller or create a new one
    _controller = widget.controller ?? VooFormController(errorDisplayMode: widget.errorDisplayMode);

    // Register all fields with the controller
    _registerFieldsWithController();

    _controller.addListener(_handleControllerChange);
  }

  void _registerFieldsWithController() {
    // Begin initialization to batch all field registrations
    _controller.beginInitialization();

    for (final field in widget.fields) {
      _controller.registerField(field.name, initialValue: field.initialValue, validators: field is VooFieldBase ? (field.validators ?? []) : []);

      // Set initial value if provided and field hasn't been touched by user
      if (field.initialValue != null && !_controller.isFieldTouched(field.name)) {
        final currentValue = _controller.getValue(field.name);

        // Check if we should update the value
        bool shouldUpdate = false;

        if (currentValue == null) {
          // No value set yet
          shouldUpdate = true;
        } else if (currentValue is String && currentValue.isEmpty) {
          // Empty string - consider as unset
          shouldUpdate = true;
        } else if (currentValue is List && currentValue.isEmpty && field.initialValue is List && (field.initialValue as List).isNotEmpty) {
          // Empty list being replaced with non-empty list
          shouldUpdate = true;
        } else if (currentValue is bool && currentValue == false && field.initialValue == true) {
          // Special case for checkboxes: false -> true likely means async data arrived
          // This handles the common pattern where forms start with false and async loads true
          shouldUpdate = true;
        }
        // Note: We generally don't update fields with existing values to preserve form state
        // Exception: During initial form setup (not a field change scenario)

        if (shouldUpdate) {
          _controller.setValue(field.name, field.initialValue, isUserInput: false);
          // Mark this field as having loaded a value
          if (field.initialValue != null &&
              !(field.initialValue is String && (field.initialValue as String).isEmpty) &&
              !(field.initialValue is List && (field.initialValue as List).isEmpty)) {
            _fieldsWithLoadedValues.add(field.name);
          }
        }
      }
    }

    // End initialization and send a single notification
    _controller.endInitialization();
  }

  @override
  void didUpdateWidget(VooForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if fields have actually changed (compare lengths and field names)
    bool fieldsChanged = oldWidget.fields.length != widget.fields.length;
    if (!fieldsChanged) {
      for (int i = 0; i < widget.fields.length; i++) {
        if (oldWidget.fields[i].name != widget.fields[i].name) {
          fieldsChanged = true;
          break;
        }
      }
    }

    // Only clear and re-register if fields have actually changed
    if (fieldsChanged) {
      // Clear and re-register fields when widget updates
      // This ensures that new initial values are properly set
      _controller.clear();
      _fieldsWithLoadedValues.clear();
      _registerFieldsWithController();
    } else {
      // Fields haven't changed structurally, just a rebuild (e.g., from BLoC state change)
      // Use batching to avoid setState during build
      _controller.beginInitialization();

      // Re-register fields to update callbacks and validators
      for (final field in widget.fields) {
        _controller.registerField(field.name, initialValue: field.initialValue, validators: field is VooFieldBase ? (field.validators ?? []) : []);

        // Update value if:
        // 1. Field hasn't been touched by the user (preserve user input)
        // 2. Either no value loaded yet OR form hasn't been touched at all
        if (field.initialValue != null && !_controller.isFieldTouched(field.name)) {
          final currentValue = _controller.getValue(field.name);
          final hasLoadedValue = _fieldsWithLoadedValues.contains(field.name);
          final formHasBeenTouched = _controller.hasAnyFieldBeenTouched();

          // If form has been touched and field has loaded value, preserve it
          if (hasLoadedValue && formHasBeenTouched) {
            continue;
          }

          // Check if we should load/update the value
          bool shouldUpdate = false;

          if (currentValue == null) {
            // No value set yet
            shouldUpdate = true;
          } else if (currentValue is String && currentValue.isEmpty && field.initialValue is String && (field.initialValue as String).isNotEmpty) {
            // Empty string being replaced with non-empty string
            shouldUpdate = true;
          } else if (currentValue is List && currentValue.isEmpty && field.initialValue is List && (field.initialValue as List).isNotEmpty) {
            // Empty list being replaced with non-empty list
            shouldUpdate = true;
          } else if (currentValue is bool && currentValue == false && field.initialValue == true) {
            // Special case for checkboxes: false -> true likely means async data arrived
            shouldUpdate = true;
          } else if (!formHasBeenTouched && currentValue != field.initialValue) {
            // Form hasn't been touched, allow updates (for async data loading)
            shouldUpdate = true;
          }

          if (shouldUpdate) {
            _controller.setValue(field.name, field.initialValue, isUserInput: false);
            // Mark this field as having loaded a value (only for non-empty values)
            if (field.initialValue != null &&
                !(field.initialValue is String && (field.initialValue as String).isEmpty) &&
                !(field.initialValue is List && (field.initialValue as List).isEmpty)) {
              _fieldsWithLoadedValues.add(field.name);
            }
          }
        }
      }

      _controller.endInitialization();
    }
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
      widget.onChanged?.call(_controller.values);

      // Increment rebuild key and rebuild when the controller notifies listeners
      // This ensures that error states are properly reflected in the UI
      setState(() {
        _rebuildKey++;
      });
    }
  }

  /// Prepare fields with readonly state applied
  List<VooFormFieldWidget> _prepareFields() {
    if (!widget.isReadOnly) return widget.fields;

    return widget.fields.map((field) {
      if (field is VooFieldBase) {
        return field.copyWith(readOnly: true, label: field.label, layout: field.layout);
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
        return VooWrappedFormLayout(fields: preparedFields, spacing: widget.spacing, runSpacing: widget.spacing);
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
      return widget.loadingWidget ?? const Center(child: CircularProgressIndicator());
    }

    // Show the form with controller in scope
    return VooFormScope(
      isReadOnly: widget.isReadOnly,
      isLoading: widget.isLoading,
      controller: _controller,
      rebuildKey: _rebuildKey,
      child: _buildFormContent(),
    );
  }
}
