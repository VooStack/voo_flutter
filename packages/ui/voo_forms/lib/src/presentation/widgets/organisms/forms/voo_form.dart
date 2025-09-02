import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form.dart' as domain;
import 'package:voo_forms/src/domain/entities/form_config.dart';
import 'package:voo_forms/src/presentation/state/voo_form_controller.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_form_field_widget.dart';
import 'package:voo_forms/src/presentation/config/theme/form_theme.dart';

/// Clean, simple form widget that accepts field widgets directly
/// No factories, no complex builders - just widgets
/// Follows KISS principle and rules.md
class VooForm extends StatefulWidget {
  /// List of field widgets - any widget that implements VooFormFieldWidget
  final List<VooFormFieldWidget> fields;

  /// Optional form controller for external control
  final VooFormController? controller;

  /// Default configuration that propagates to all fields
  final VooFormConfig? defaultConfig;

  /// Callback when form is submitted with valid data
  final void Function(Map<String, dynamic>)? onSubmit;

  /// Callback when form is cancelled
  final VoidCallback? onCancel;

  /// Callback on successful submission
  final VoidCallback? onSuccess;

  /// Callback on submission error
  final void Function(dynamic)? onError;

  /// Whether to show submit button
  final bool showSubmitButton;

  /// Whether to show cancel button
  final bool showCancelButton;

  /// Submit button text
  final String submitText;

  /// Cancel button text
  final String cancelText;

  /// Optional header widget
  final Widget? header;

  /// Optional footer widget
  final Widget? footer;

  /// Whether to show progress indicator
  final bool showProgress;

  /// Spacing between fields
  final double spacing;

  /// Padding around the form
  final EdgeInsetsGeometry? padding;

  /// Scroll physics for the form
  final ScrollPhysics? physics;

  /// Whether to validate on submit
  final bool validateOnSubmit;

  /// Whether to show validation errors
  final bool showValidationErrors;

  /// Whether fields are editable
  final bool isEditable;

  /// Custom actions builder
  final Widget Function(BuildContext, VooFormController)? actionsBuilder;

  const VooForm({
    super.key,
    required this.fields,
    this.controller,
    this.defaultConfig,
    this.onSubmit,
    this.onCancel,
    this.onSuccess,
    this.onError,
    this.showSubmitButton = true,
    this.showCancelButton = false,
    this.submitText = 'Submit',
    this.cancelText = 'Cancel',
    this.header,
    this.footer,
    this.showProgress = false,
    this.spacing = 16.0,
    this.padding,
    this.physics,
    this.validateOnSubmit = true,
    this.showValidationErrors = true,
    this.isEditable = true,
    this.actionsBuilder,
  });

  @override
  State<VooForm> createState() => _VooFormState();
}

class _VooFormState extends State<VooForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _values = {};
  final Map<String, TextEditingController> _controllers = {};
  late VooFormController _controller;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _initializeValues();

    // Create or use provided controller
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      // Create a simple controller for value management
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
    _scrollController.dispose();
    // Clean up controllers
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleControllerChange() {
    if (mounted) {
      setState(() {});
    }
  }

  void _initializeValues() {
    // Initialize values from field initial values
    for (final field in widget.fields) {
      _values[field.name] = field.initialValue ?? field.value;
    }
  }

  void _handleSubmit() {
    if (widget.validateOnSubmit) {
      if (_formKey.currentState?.validate() ?? false) {
        _formKey.currentState?.save();
        try {
          widget.onSubmit?.call(_values);
          widget.onSuccess?.call();
        } catch (error) {
          widget.onError?.call(error);
        }
      }
    } else {
      try {
        widget.onSubmit?.call(_values);
        widget.onSuccess?.call();
      } catch (error) {
        widget.onError?.call(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Apply form theme if config provides theme generation
    final effectiveConfig = widget.defaultConfig ?? const VooFormConfig();
    final formTheme = VooFormTheme.generateFormTheme(
      colorScheme: theme.colorScheme,
      textTheme: theme.textTheme,
    );

    // Build form content
    Widget formContent = Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          if (widget.header != null) ...[
            widget.header!,
            SizedBox(height: widget.spacing),
          ],

          // Progress indicator
          if (widget.showProgress) ...[
            LinearProgressIndicator(
              backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
            SizedBox(height: widget.spacing),
          ],

          // Fields
          ...widget.fields.map((field) {
            // Wrap field with config provider if needed
            final Widget fieldWidget = field;

            // Each field is already a widget, just render it with spacing
            return Padding(
              padding: EdgeInsets.only(bottom: widget.spacing),
              child: widget.isEditable
                  ? fieldWidget
                  : AbsorbPointer(
                      child: Opacity(
                        opacity: 0.6,
                        child: fieldWidget,
                      ),
                    ),
            );
          }),

          // Actions
          if (widget.actionsBuilder != null) ...[
            SizedBox(height: widget.spacing),
            widget.actionsBuilder!(context, _controller),
          ] else if ((widget.showSubmitButton || widget.showCancelButton) && widget.isEditable) ...[
            SizedBox(height: widget.spacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.showCancelButton && widget.onCancel != null) ...[
                  TextButton(
                    onPressed: widget.onCancel,
                    child: Text(widget.cancelText),
                  ),
                  const SizedBox(width: 8),
                ],
                if (widget.showSubmitButton)
                  FilledButton(
                    onPressed: _handleSubmit,
                    child: Text(widget.submitText),
                  ),
              ],
            ),
          ],

          // Footer
          if (widget.footer != null) ...[
            SizedBox(height: widget.spacing),
            widget.footer!,
          ],
        ],
      ),
    );

    // Apply theme
    formContent = Theme(
      data: formTheme,
      child: formContent,
    );

    // Wrap with scrollable if physics provided
    if (widget.physics != null) {
      formContent = SingleChildScrollView(
        controller: _scrollController,
        physics: widget.physics,
        padding: widget.padding,
        child: formContent,
      );
    } else if (widget.padding != null) {
      formContent = Padding(
        padding: widget.padding!,
        child: formContent,
      );
    }

    // Apply config decoration if provided
    if (effectiveConfig.decoration != null) {
      formContent = DecoratedBox(
        decoration: effectiveConfig.decoration!,
        child: formContent,
      );
    }

    // Apply background color if provided
    if (effectiveConfig.backgroundColor != null) {
      formContent = Container(
        color: effectiveConfig.backgroundColor,
        child: formContent,
      );
    }

    return formContent;
  }
}

/// Extension to create forms easily from field lists
extension VooFormExtension on List<VooFormFieldWidget> {
  /// Create a form from a list of field widgets
  ///
  /// Example:
  /// ```dart
  /// [
  ///   VooTextField(name: 'username', label: 'Username'),
  ///   VooEmailField(name: 'email', label: 'Email'),
  /// ].toForm(onSubmit: (values) => print(values))
  /// ```
  Widget toForm({
    void Function(Map<String, dynamic>)? onSubmit,
    VoidCallback? onCancel,
    bool showSubmitButton = true,
    bool showCancelButton = false,
    String submitText = 'Submit',
    String cancelText = 'Cancel',
    Widget? header,
    Widget? footer,
    double spacing = 16.0,
    EdgeInsetsGeometry? padding,
  }) =>
      VooForm(
        fields: this,
        onSubmit: onSubmit,
        onCancel: onCancel,
        showSubmitButton: showSubmitButton,
        showCancelButton: showCancelButton,
        submitText: submitText,
        cancelText: cancelText,
        header: header,
        footer: footer,
        spacing: spacing,
        padding: padding,
      );
}
