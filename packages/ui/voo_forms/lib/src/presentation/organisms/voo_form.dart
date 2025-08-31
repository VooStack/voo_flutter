import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:voo_forms/src/domain/entities/form.dart';
import 'package:voo_forms/src/domain/entities/form_config.dart';
import 'package:voo_forms/src/presentation/controllers/voo_form_controller.dart';
import 'package:voo_forms/src/presentation/molecules/form_header_widget.dart';
import 'package:voo_forms/src/presentation/molecules/submit_section_widget.dart';
import 'package:voo_forms/src/presentation/organisms/form_content_widget.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';

/// Enhanced VooForm widget with improved theming and layout
class VooFormWidget extends HookWidget {
  final VooForm form;
  final VooFormConfig? config;
  final VooFormController? controller;
  final Future<void> Function(Map<String, dynamic>)? onSubmit;
  final VoidCallback? onSuccess;
  final void Function(dynamic)? onError;
  final bool showErrors;
  final bool showSubmitButton;
  final String submitButtonText;
  final Widget? submitButtonIcon;
  final Widget? header;
  final Widget? footer;
  final List<FieldGroup>? fieldGroups;
  final ScrollController? scrollController;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;

  const VooFormWidget({
    super.key,
    required this.form,
    this.config,
    this.controller,
    this.onSubmit,
    this.onSuccess,
    this.onError,
    this.showErrors = true,
    this.showSubmitButton = true,
    this.submitButtonText = 'Submit',
    this.submitButtonIcon,
    this.header,
    this.footer,
    this.fieldGroups,
    this.scrollController,
    this.shrinkWrap = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final formConfig = config ?? const VooFormConfig();
    final formController = controller ?? useVooFormController(form);

    useListenable(formController);

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isMobile = screenWidth < formConfig.mobileBreakpoint;
        final isTablet = screenWidth < formConfig.tabletBreakpoint && !isMobile;
        final isDesktop = !isMobile && !isTablet;

        // Calculate form width
        double formWidth = screenWidth;
        if (formConfig.maxFormWidth != null &&
            screenWidth > formConfig.maxFormWidth!) {
          formWidth = formConfig.maxFormWidth!;
        }

        // Build form content
        Widget formContent = FormContentWidget(
          form: form,
          controller: formController,
          config: formConfig,
          screenWidth: screenWidth,
          fieldGroups: fieldGroups,
        );

        // Wrap with field options provider if default options are provided
        if (formConfig.defaultFieldOptions != null) {
          formContent = VooFieldOptionsProvider(
            options: formConfig.defaultFieldOptions!,
            child: formContent,
          );
        }

        // Apply form decoration
        if (formConfig.decoration != null) {
          formContent = DecoratedBox(
            decoration: formConfig.decoration!,
            child: formContent,
          );
        }

        // Apply background color
        if (formConfig.backgroundColor != null) {
          formContent = Container(
            color: formConfig.backgroundColor,
            child: formContent,
          );
        }

        // Apply padding and margin
        final effectivePadding = padding ?? formConfig.padding;
        if (effectivePadding != null) {
          formContent = Padding(
            padding: effectivePadding,
            child: formContent,
          );
        }

        if (formConfig.margin != null) {
          formContent = Container(
            margin: formConfig.margin,
            child: formContent,
          );
        }

        // Center on large screens if configured
        if (formConfig.centerOnLargeScreens && isDesktop) {
          formContent = Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: formWidth),
              child: formContent,
            ),
          );
        }

        // Build complete form
        return Column(
          mainAxisSize: shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (header != null) header!,
            if (form.title != null || form.description != null)
              FormHeaderWidget(
                form: form,
                config: formConfig,
                padding: padding,
              ),
            if (shrinkWrap)
              formContent
            else
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: formContent,
                ),
              ),
            if (showSubmitButton)
              SubmitSectionWidget(
                controller: formController,
                config: formConfig,
                onSubmit: onSubmit,
                onSuccess: onSuccess,
                onError: onError,
                submitButtonText: submitButtonText,
                submitButtonIcon: submitButtonIcon,
                padding: padding,
              ),
            if (footer != null) footer!,
          ],
        );
      },
    );
  }

}

// Simplified form widget with builder pattern
class VooFormWidgetBuilder extends HookWidget {
  final VooForm form;
  final Widget Function(BuildContext, VooFormController) builder;
  final VooFormController? controller;

  const VooFormWidgetBuilder({
    super.key,
    required this.form,
    required this.builder,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final formController = controller ?? useVooFormController(form);
    useListenable(formController);

    return builder(context, formController);
  }
}

/// Provides form configuration through context
class VooFormConfigProvider extends InheritedWidget {
  final VooFormConfig config;

  const VooFormConfigProvider({
    super.key,
    required this.config,
    required super.child,
  });

  static VooFormConfig? of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<VooFormConfigProvider>();
    return provider?.config;
  }

  @override
  bool updateShouldNotify(VooFormConfigProvider oldWidget) =>
    config != oldWidget.config;
}
