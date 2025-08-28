import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/domain/entities/form_section.dart';
import 'package:voo_forms/src/presentation/controllers/voo_form_controller.dart';
import 'package:voo_forms/src/presentation/molecules/voo_form_actions.dart';
import 'package:voo_forms/src/presentation/organisms/voo_form_builder.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';

/// Simplified form builder that works seamlessly with VooField API
///
/// Example usage:
/// ```dart
/// VooSimpleForm(
///   fields: [
///     VooField.text(name: 'name', label: 'Name'),
///     VooField.email(name: 'email', label: 'Email'),
///     VooField.dropdown(
///       name: 'country',
///       label: 'Country',
///       options: ['USA', 'Canada', 'Mexico'],
///     ),
///   ],
///   onSubmit: (values) => print(values),
/// )
/// ```
class VooSimpleForm extends StatefulWidget {
  /// List of form fields created using VooField factory constructors
  final List<VooFormField> fields;

  /// Layout for the form
  final FormLayout layout;

  /// Form sections for organizing fields
  final List<VooFormSection>? sections;

  /// Default field options that apply to all fields
  final VooFieldOptions? defaultFieldOptions;

  /// Callback when form is submitted
  final void Function(Map<String, dynamic>)? onSubmit;

  /// Callback when form is cancelled
  final VoidCallback? onCancel;

  /// Whether to show progress indicator
  final bool showProgress;

  /// Whether to show validation errors
  final bool showValidation;

  /// Custom header widget
  final Widget? header;

  /// Custom footer widget
  final Widget? footer;

  /// Padding around the form
  final EdgeInsetsGeometry? padding;

  /// Submit button label
  final String submitLabel;

  /// Cancel button label
  final String cancelLabel;

  /// Whether to show cancel button
  final bool showCancel;

  /// Form metadata for stepped/wizard forms
  final Map<String, dynamic>? metadata;

  /// Custom actions builder
  final Widget Function(BuildContext, VooFormController)? actionsBuilder;

  const VooSimpleForm({
    super.key,
    required this.fields,
    this.layout = FormLayout.vertical,
    this.sections,
    this.defaultFieldOptions,
    this.onSubmit,
    this.onCancel,
    this.showProgress = false,
    this.showValidation = true,
    this.header,
    this.footer,
    this.padding,
    this.submitLabel = 'Submit',
    this.cancelLabel = 'Cancel',
    this.showCancel = true,
    this.metadata,
    this.actionsBuilder,
  });

  @override
  State<VooSimpleForm> createState() => _VooSimpleFormState();
}

class _VooSimpleFormState extends State<VooSimpleForm> {
  late VooForm _form;
  late VooFormController _controller;

  @override
  void initState() {
    super.initState();

    // Create VooForm from fields
    _form = VooForm(
      id: 'simple_form_${DateTime.now().millisecondsSinceEpoch}',
      title: null,
      fields: widget.fields,
      layout: widget.layout,
      sections: widget.sections,
      metadata: widget.metadata,
    );

    _controller = VooFormController(form: _form);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget formContent = VooFormBuilder(
      form: _form,
      controller: _controller,
      onSubmit: widget.onSubmit,
      onCancel: widget.onCancel,
      header: widget.header,
      footer: widget.footer,
      showProgress: widget.showProgress,
      showValidation: widget.showValidation,
      padding: widget.padding,
      actionsBuilder: widget.actionsBuilder ??
          (context, controller) {
            return VooFormActions(
              controller: controller,
              onSubmit:
                  widget.onSubmit != null ? () => _handleSubmit(context) : null,
              onCancel: widget.onCancel,
              submitLabel: widget.submitLabel,
              cancelLabel: widget.cancelLabel,
              showCancel: widget.showCancel && widget.onCancel != null,
            );
          },
    );

    // Wrap with field options provider if default options provided
    if (widget.defaultFieldOptions != null) {
      return VooFieldOptionsProvider(
        options: widget.defaultFieldOptions!,
        child: formContent,
      );
    }

    return formContent;
  }

  void _handleSubmit(BuildContext context) async {
    if (widget.onSubmit != null) {
      await _controller.submit(
        onSubmit: (values) async {
          widget.onSubmit!(values);
        },
        onSuccess: () {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Form submitted successfully'),
                backgroundColor: Theme.of(context).colorScheme.tertiary,
              ),
            );
          }
        },
        onError: (error) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: $error'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
      );
    }
  }
}

/// Extension to make form building even more convenient
extension VooSimpleFormExtensions on List<VooFormField> {
  /// Create a simple form from a list of fields
  ///
  /// Example:
  /// ```dart
  /// [
  ///   VooField.text(name: 'name'),
  ///   VooField.email(name: 'email'),
  /// ].toForm(onSubmit: (values) => print(values))
  /// ```
  Widget toForm({
    FormLayout layout = FormLayout.vertical,
    List<VooFormSection>? sections,
    VooFieldOptions? defaultFieldOptions,
    void Function(Map<String, dynamic>)? onSubmit,
    VoidCallback? onCancel,
    bool showProgress = false,
    bool showValidation = true,
    Widget? header,
    Widget? footer,
    EdgeInsetsGeometry? padding,
    String submitLabel = 'Submit',
    String cancelLabel = 'Cancel',
    bool showCancel = true,
  }) {
    return VooSimpleForm(
      fields: this,
      layout: layout,
      sections: sections,
      defaultFieldOptions: defaultFieldOptions,
      onSubmit: onSubmit,
      onCancel: onCancel,
      showProgress: showProgress,
      showValidation: showValidation,
      header: header,
      footer: footer,
      padding: padding,
      submitLabel: submitLabel,
      cancelLabel: cancelLabel,
      showCancel: showCancel,
    );
  }
}
