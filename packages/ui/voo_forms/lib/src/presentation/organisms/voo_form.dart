import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:voo_forms/src/domain/entities/form.dart';
import 'package:voo_forms/src/presentation/controllers/form_controller.dart';
import 'package:voo_forms/src/presentation/molecules/form_field_builder.dart';
import 'package:voo_forms/src/presentation/molecules/form_section.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

class VooFormWidget extends HookWidget {
  final VooForm form;
  final VooFormController? controller;
  final Future<void> Function(Map<String, dynamic>)? onSubmit;
  final VoidCallback? onSuccess;
  final Function(dynamic)? onError;
  final bool showErrors;
  final bool showSubmitButton;
  final String submitButtonText;
  final Widget? submitButtonIcon;
  final EdgeInsetsGeometry? padding;
  final Widget? header;
  final Widget? footer;

  const VooFormWidget({
    super.key,
    required this.form,
    this.controller,
    this.onSubmit,
    this.onSuccess,
    this.onError,
    this.showErrors = true,
    this.showSubmitButton = true,
    this.submitButtonText = 'Submit',
    this.submitButtonIcon,
    this.padding,
    this.header,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);
    final responsive = context.responsive;

    // Use provided controller or create a new one
    final formController = controller ?? useVooFormController(form);

    // Listen to form changes
    useListenable(formController);

    // Build form content based on layout
    Widget content;
    switch (form.layout) {
      case FormLayout.vertical:
        content = _buildVerticalLayout(context, formController);
        break;
      case FormLayout.horizontal:
        content = _buildHorizontalLayout(context, formController);
        break;
      case FormLayout.grid:
        content = _buildGridLayout(context, formController);
        break;
      case FormLayout.stepped:
        content = _buildSteppedLayout(context, formController);
        break;
      case FormLayout.tabbed:
        content = _buildTabbedLayout(context, formController);
        break;
    }

    // Build the complete form
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (header != null) header!,
        if (form.title != null || form.description != null)
          Padding(
            padding: padding ??
                EdgeInsets.all(
                  responsive.device(
                    phone: design.spacingMd,
                    tablet: design.spacingLg,
                    desktop: design.spacingXl,
                    defaultValue: design.spacingLg,
                  ),
                ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (form.title != null)
                  Text(
                    form.title!,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (form.description != null) ...[
                  SizedBox(height: design.spacingSm),
                  Text(
                    form.description!,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        Expanded(
          child: SingleChildScrollView(
            padding: padding ??
                EdgeInsets.all(
                  responsive.device(
                    phone: design.spacingMd,
                    tablet: design.spacingLg,
                    desktop: design.spacingXl,
                    defaultValue: design.spacingLg,
                  ),
                ),
            child: content,
          ),
        ),
        if (showSubmitButton) _buildSubmitButton(context, formController),
        if (footer != null) footer!,
      ],
    );
  }

  Widget _buildVerticalLayout(BuildContext context, VooFormController controller) {
    final design = context.vooDesign;
    
    if (form.sections != null && form.sections!.isNotEmpty) {
      // Build with sections
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: form.sections!.map((section) {
          final sectionFields = form.fields
              .where((field) => section.fieldIds.contains(field.id))
              .toList();
          
          return Padding(
            padding: EdgeInsets.only(bottom: design.spacingLg),
            child: FormSectionWidget(
              section: section,
              fields: sectionFields,
              controller: controller,
              showErrors: showErrors,
            ),
          );
        }).toList(),
      );
    } else {
      // Build without sections
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: form.fields.map((field) {
          return Padding(
            padding: EdgeInsets.only(bottom: design.spacingMd),
            child: VooFormFieldBuilder(
              field: field,
              controller: controller,
              showError: showErrors,
            ),
          );
        }).toList(),
      );
    }
  }

  Widget _buildHorizontalLayout(BuildContext context, VooFormController controller) {
    final design = context.vooDesign;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: form.fields.map((field) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: design.spacingMd),
            child: VooFormFieldBuilder(
              field: field,
              controller: controller,
              showError: showErrors,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGridLayout(BuildContext context, VooFormController controller) {
    final design = context.vooDesign;
    final responsive = context.responsive;
    
    final columns = responsive.device(
      phone: 1,
      tablet: 2,
      desktop: 3,
      defaultValue: 2,
    );
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - (columns - 1) * design.spacingMd) / columns;
        
        return Wrap(
          spacing: design.spacingMd,
          runSpacing: design.spacingMd,
          children: form.fields.map((field) {
            return SizedBox(
              width: field.gridColumns != null
                  ? (itemWidth * field.gridColumns! + design.spacingMd * (field.gridColumns! - 1))
                  : itemWidth,
              child: VooFormFieldBuilder(
                field: field,
                controller: controller,
                showError: showErrors,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildSteppedLayout(BuildContext context, VooFormController controller) {
    // Simplified stepped layout - would need proper state management for steps
    return _buildVerticalLayout(context, controller);
  }

  Widget _buildTabbedLayout(BuildContext context, VooFormController controller) {
    // Simplified tabbed layout - would need proper tab controller
    return _buildVerticalLayout(context, controller);
  }

  Widget _buildSubmitButton(BuildContext context, VooFormController controller) {
    final design = context.vooDesign;
    final theme = Theme.of(context);
    final responsive = context.responsive;
    
    return Container(
      padding: EdgeInsets.all(
        responsive.device(
          phone: design.spacingMd,
          tablet: design.spacingLg,
          desktop: design.spacingXl,
          defaultValue: design.spacingLg,
        ),
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            VooButton(
              onPressed: controller.isSubmitting
                  ? null
                  : () {
                      controller.clearErrors();
                      controller.reset();
                    },
              variant: VooButtonVariant.outlined,
              child: const Text('Reset'),
            ),
            SizedBox(width: design.spacingMd),
            VooButton(
              onPressed: controller.isSubmitting || onSubmit == null
                  ? null
                  : () async {
                      await controller.submit(
                        onSubmit: onSubmit!,
                        onSuccess: onSuccess,
                        onError: onError,
                      );
                    },
              loading: controller.isSubmitting,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (submitButtonIcon != null) ...[
                    submitButtonIcon!,
                    SizedBox(width: design.spacingXs),
                  ],
                  Text(submitButtonText),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Simplified form widget with builder pattern
class VooFormBuilder extends HookWidget {
  final VooForm form;
  final Widget Function(BuildContext, VooFormController) builder;
  final VooFormController? controller;

  const VooFormBuilder({
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