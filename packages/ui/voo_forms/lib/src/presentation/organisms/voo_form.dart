import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:voo_forms/src/domain/entities/form.dart';
import 'package:voo_forms/src/domain/entities/form_config.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/controllers/form_controller.dart';
import 'package:voo_forms/src/presentation/molecules/form_field_builder.dart';
import 'package:voo_forms/src/presentation/molecules/form_section.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart'
    hide LabelStyle, FieldSize, FieldDensity, ValidationTrigger, FocusBehavior;

/// Enhanced VooForm widget with improved theming and layout
class VooFormWidget extends HookWidget {
  final VooForm form;
  final VooFormConfig? config;
  final VooFormController? controller;
  final Future<void> Function(Map<String, dynamic>)? onSubmit;
  final VoidCallback? onSuccess;
  final Function(dynamic)? onError;
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
        Widget formContent = _buildFormContent(
          context,
          formController,
          formConfig,
          screenWidth,
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
          formContent = Container(
            decoration: formConfig.decoration,
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
              _buildFormHeader(context, formConfig),
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
              _buildSubmitSection(context, formController, formConfig),
            if (footer != null) footer!,
          ],
        );
      },
    );
  }

  Widget _buildFormHeader(BuildContext context, VooFormConfig config) {
    final theme = Theme.of(context);
    final effectivePadding =
        padding ?? config.padding ?? const EdgeInsets.all(16.0);

    return Padding(
      padding: effectivePadding,
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
            const SizedBox(height: 8.0),
            Text(
              form.description!,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFormContent(
    BuildContext context,
    VooFormController controller,
    VooFormConfig config,
    double screenWidth,
  ) {
    // Use field groups if provided
    if (fieldGroups != null && fieldGroups!.isNotEmpty) {
      return _buildGroupedForm(context, controller, config, screenWidth);
    }

    // Use sections if provided
    if (form.sections != null && form.sections!.isNotEmpty) {
      return _buildSectionedForm(context, controller, config, screenWidth);
    }

    // Build based on layout
    switch (form.layout) {
      case FormLayout.grid:
        return _buildGridLayout(context, controller, config, screenWidth);
      case FormLayout.horizontal:
        return _buildHorizontalLayout(context, controller, config);
      default:
        return _buildVerticalLayout(context, controller, config);
    }
  }

  Widget _buildGroupedForm(
    BuildContext context,
    VooFormController controller,
    VooFormConfig config,
    double screenWidth,
  ) {
    return Column(
      children: fieldGroups!.map((group) {
        return _buildFieldGroup(
            context, controller, config, group, screenWidth);
      }).toList(),
    );
  }

  Widget _buildFieldGroup(
    BuildContext context,
    VooFormController controller,
    VooFormConfig config,
    FieldGroup group,
    double screenWidth,
  ) {
    final theme = Theme.of(context);
    final groupFields = form.fields
        .where((field) => group.fieldIds.contains(field.id))
        .toList();

    Widget content = _buildFieldGroupContent(
      context,
      controller,
      config,
      groupFields,
      group.columns,
      screenWidth,
    );

    if (group.title != null || group.description != null) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (group.title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                group.title!,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (group.description != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                group.description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          content,
        ],
      );
    }

    if (group.collapsible) {
      content = _buildCollapsibleGroup(context, group, content);
    }

    return Container(
      decoration: group.decoration,
      padding: group.padding ?? const EdgeInsets.all(16.0),
      margin: group.margin ?? EdgeInsets.only(bottom: config.sectionSpacing),
      child: content,
    );
  }

  Widget _buildCollapsibleGroup(
    BuildContext context,
    FieldGroup group,
    Widget content,
  ) {
    final theme = Theme.of(context);

    return ExpansionTile(
      title: Text(
        group.title ?? 'Section',
        style: theme.textTheme.titleMedium,
      ),
      initiallyExpanded: group.initiallyExpanded,
      children: [content],
    );
  }

  Widget _buildFieldGroupContent(
    BuildContext context,
    VooFormController controller,
    VooFormConfig config,
    List<VooFormField> fields,
    int columns,
    double screenWidth,
  ) {
    final effectiveColumns =
        screenWidth < config.mobileBreakpoint ? 1 : columns;

    if (effectiveColumns == 1) {
      return Column(
        children: fields.map((field) {
          return Padding(
            padding: EdgeInsets.only(bottom: config.fieldSpacing),
            child: _buildField(context, controller, config, field),
          );
        }).toList(),
      );
    }

    // Multi-column layout
    return LayoutBuilder(
      builder: (context, constraints) {
        final columnWidth = (constraints.maxWidth -
                (effectiveColumns - 1) * config.fieldSpacing) /
            effectiveColumns;

        return Wrap(
          spacing: config.fieldSpacing,
          runSpacing: config.fieldSpacing,
          children: fields.map((field) {
            final fieldColumns = field.gridColumns ?? 1;
            final width = fieldColumns > effectiveColumns
                ? constraints.maxWidth
                : (columnWidth * fieldColumns +
                    config.fieldSpacing * (fieldColumns - 1));

            return SizedBox(
              width: width,
              child: _buildField(context, controller, config, field),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildSectionedForm(
    BuildContext context,
    VooFormController controller,
    VooFormConfig config,
    double screenWidth,
  ) {
    return Column(
      children: form.sections!.map((section) {
        final sectionFields = form.fields
            .where((field) => section.fieldIds.contains(field.id))
            .toList();

        return Padding(
          padding: EdgeInsets.only(bottom: config.sectionSpacing),
          child: FormSectionWidget(
            section: section,
            fields: sectionFields,
            controller: controller,
            showErrors: showErrors,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVerticalLayout(
    BuildContext context,
    VooFormController controller,
    VooFormConfig config,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: form.fields.map((field) {
        return Padding(
          padding: EdgeInsets.only(bottom: config.fieldSpacing),
          child: _buildField(context, controller, config, field),
        );
      }).toList(),
    );
  }

  Widget _buildHorizontalLayout(
    BuildContext context,
    VooFormController controller,
    VooFormConfig config,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: form.fields.map((field) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: config.fieldSpacing),
            child: _buildField(context, controller, config, field),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGridLayout(
    BuildContext context,
    VooFormController controller,
    VooFormConfig config,
    double screenWidth,
  ) {
    final columns = config.getColumnCount(screenWidth);

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth =
            (constraints.maxWidth - (columns - 1) * config.fieldSpacing) /
                columns;

        return Wrap(
          spacing: config.fieldSpacing,
          runSpacing: config.fieldSpacing,
          children: form.fields.map((field) {
            final fieldColumns = field.gridColumns ?? 1;
            final width = fieldColumns > columns
                ? constraints.maxWidth
                : (itemWidth * fieldColumns +
                    config.fieldSpacing * (fieldColumns - 1));

            return SizedBox(
              width: width,
              child: _buildField(context, controller, config, field),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildField(
    BuildContext context,
    VooFormController controller,
    VooFormConfig config,
    VooFormField field,
  ) {
    // Apply configuration to field
    final configuredField = _applyConfigToField(context, config, field);

    return VooFormFieldBuilder(
      field: configuredField,
      controller: controller,
      config: config,
      showError: showErrors && config.errorDisplayMode != ErrorDisplayMode.none,
    );
  }

  VooFormField _applyConfigToField(
    BuildContext context,
    VooFormConfig config,
    VooFormField field,
  ) {
    final theme = Theme.of(context);

    // Build label with required indicator
    String? label = field.label;
    if (label != null && field.required && config.showRequiredIndicator) {
      label = '$label ${config.requiredIndicator}';
    }

    // Apply label position
    InputDecoration? decoration = field.decoration;
    if (config.labelPosition == LabelPosition.hidden) {
      label = null;
    } else if (config.labelPosition == LabelPosition.floating) {
      decoration = InputDecoration(
        labelText: label,
        hintText: field.hint,
        helperText: field.helper,
        errorText: field.error,
        prefixIcon: field.prefixIcon != null ? Icon(field.prefixIcon) : null,
        suffixIcon: field.suffixIcon != null ? Icon(field.suffixIcon) : null,
        contentPadding: config.getFieldPadding(),
      );
    }

    // Apply field variant
    if (decoration != null) {
      switch (config.fieldVariant) {
        case FieldVariant.filled:
          decoration = decoration.copyWith(
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
          );
          break;
        case FieldVariant.underlined:
          decoration = decoration.copyWith(
            border: const UnderlineInputBorder(),
          );
          break;
        case FieldVariant.ghost:
          decoration = decoration.copyWith(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: Colors.transparent,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: Colors.transparent,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2.0,
              ),
            ),
          );
          break;
        default:
          // Keep outlined
          break;
      }
    }

    return field.copyWith(
      label: config.labelPosition != LabelPosition.floating ? label : null,
      decoration: decoration,
      padding: config.getFieldPadding(),
    );
  }

  Widget _buildSubmitSection(
    BuildContext context,
    VooFormController controller,
    VooFormConfig config,
  ) {
    final theme = Theme.of(context);

    Widget submitButton = ElevatedButton.icon(
      onPressed: controller.isSubmitting || onSubmit == null
          ? null
          : () async {
              await controller.submit(
                onSubmit: onSubmit!,
                onSuccess: onSuccess,
                onError: onError,
              );
            },
      icon: submitButtonIcon ?? const SizedBox.shrink(),
      label: controller.isSubmitting
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.onPrimary,
                ),
              ),
            )
          : Text(submitButtonText),
      style: config.submitButtonStyle ??
          ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 12.0,
            ),
          ),
    );

    Widget resetButton = TextButton(
      onPressed: controller.isSubmitting
          ? null
          : () {
              controller.clearErrors();
              controller.reset();
            },
      child: const Text('Reset'),
    );

    Widget buttonRow;
    switch (config.submitButtonPosition) {
      case ButtonPosition.bottomLeft:
        buttonRow = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [submitButton, const SizedBox(width: 8), resetButton],
        );
        break;
      case ButtonPosition.bottomCenter:
        buttonRow = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [resetButton, const SizedBox(width: 8), submitButton],
        );
        break;
      case ButtonPosition.bottomRight:
      default:
        buttonRow = Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [resetButton, const SizedBox(width: 8), submitButton],
        );
        break;
    }

    final effectivePadding =
        padding ?? config.padding ?? const EdgeInsets.all(16.0);

    return Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(child: buttonRow),
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
  bool updateShouldNotify(VooFormConfigProvider oldWidget) {
    return config != oldWidget.config;
  }
}
