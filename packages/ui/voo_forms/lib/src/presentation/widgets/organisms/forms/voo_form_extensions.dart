import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_form_field_widget.dart';
import 'package:voo_forms/src/presentation/widgets/organisms/forms/voo_form.dart';
import 'package:voo_forms/src/presentation/widgets/organisms/forms/voo_form_page_builder.dart';

/// Extension to create forms easily from field lists
extension VooFormExtension on List<VooFormFieldWidget> {
  /// Create a simple form from a list of field widgets
  /// For basic form functionality without layout or actions
  ///
  /// Example:
  /// ```dart
  /// [
  ///   VooTextField(name: 'username', label: 'Username'),
  ///   VooEmailField(name: 'email', label: 'Email'),
  /// ].toForm()
  /// ```
  Widget toForm({
    double spacing = 16.0,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.stretch,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.min,
  }) =>
      VooForm(
        fields: this,
        spacing: spacing,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
      );

  /// Create a full form page with layout, actions, and callbacks
  ///
  /// Example:
  /// ```dart
  /// [
  ///   VooTextField(name: 'username', label: 'Username'),
  ///   VooEmailField(name: 'email', label: 'Email'),
  /// ].toFormPage(
  ///   onSubmit: (values) => print(values),
  ///   showSubmitButton: true,
  /// )
  /// ```
  Widget toFormPage({
    void Function(Map<String, dynamic>)? onSubmit,
    VoidCallback? onCancel,
    VoidCallback? onSuccess,
    void Function(dynamic)? onError,
    bool showSubmitButton = true,
    bool showCancelButton = false,
    String submitText = 'Submit',
    String cancelText = 'Cancel',
    Widget? header,
    Widget? footer,
    double spacing = 16.0,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    bool validateOnSubmit = true,
    bool isEditable = true,
    bool showProgress = false,
    bool wrapInCard = false,
    double? cardElevation,
    EdgeInsetsGeometry? cardMargin,
  }) =>
      VooFormPageBuilder(
        form: VooForm(fields: this, spacing: spacing),
        onSubmit: onSubmit,
        onCancel: onCancel,
        onSuccess: onSuccess,
        onError: onError,
        showSubmitButton: showSubmitButton,
        showCancelButton: showCancelButton,
        submitText: submitText,
        cancelText: cancelText,
        header: header,
        footer: footer,
        spacing: spacing,
        padding: padding,
        physics: physics,
        validateOnSubmit: validateOnSubmit,
        isEditable: isEditable,
        showProgress: showProgress,
        wrapInCard: wrapInCard,
        cardElevation: cardElevation,
        cardMargin: cardMargin,
      );
}
