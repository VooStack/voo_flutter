import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form.dart';
import 'package:voo_forms/src/presentation/controllers/voo_form_controller.dart';
import 'package:voo_forms/src/presentation/organisms/voo_form_builder.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// A responsive wrapper for forms that adapts to different screen sizes
/// following Material 3 design principles
class VooResponsiveFormWrapper extends StatelessWidget {
  final VooForm form;
  final VooFormController? controller;
  final void Function(Map<String, dynamic>)? onSubmit;
  final VoidCallback? onCancel;
  final Widget? header;
  final Widget? footer;
  final bool showProgress;
  final bool showValidation;

  // Responsive breakpoints
  final double? phoneMaxWidth;
  final double? tabletMaxWidth;
  final double? desktopMaxWidth;

  // Content alignment
  final FormAlignment alignment;

  // Custom padding per device type
  final EdgeInsetsGeometry? phonePadding;
  final EdgeInsetsGeometry? tabletPadding;
  final EdgeInsetsGeometry? desktopPadding;

  // Custom column counts per device type
  final int phoneColumns;
  final int tabletColumns;
  final int desktopColumns;

  // Material 3 surface tint
  final bool useSurfaceTint;
  final double? elevation;

  const VooResponsiveFormWrapper({
    super.key,
    required this.form,
    this.controller,
    this.onSubmit,
    this.onCancel,
    this.header,
    this.footer,
    this.showProgress = true,
    this.showValidation = true,
    this.phoneMaxWidth,
    this.tabletMaxWidth,
    this.desktopMaxWidth = 1200,
    this.alignment = FormAlignment.center,
    this.phonePadding,
    this.tabletPadding,
    this.desktopPadding,
    this.phoneColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.useSurfaceTint = true,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);
    final responsive = VooResponsive.maybeOf(context);

    // Determine the current device type and calculate appropriate values
    final isPhone =
        responsive?.isPhone ?? (MediaQuery.of(context).size.width < 600);
    final isTablet = responsive?.isTablet ??
        (MediaQuery.of(context).size.width >= 600 &&
            MediaQuery.of(context).size.width < 1024);
    final isDesktop =
        responsive?.isDesktop ?? (MediaQuery.of(context).size.width >= 1024);

    // Calculate max width based on device type
    double? maxWidth;
    EdgeInsetsGeometry padding;
    int columns;

    if (isPhone) {
      maxWidth = phoneMaxWidth;
      padding = phonePadding ?? EdgeInsets.all(design.spacingMd);
      columns = phoneColumns;
    } else if (isTablet) {
      maxWidth = tabletMaxWidth ?? 768;
      padding = tabletPadding ?? EdgeInsets.all(design.spacingLg);
      columns = tabletColumns;
    } else {
      maxWidth = desktopMaxWidth ?? 1200;
      padding = desktopPadding ?? EdgeInsets.all(design.spacingXl);
      columns = desktopColumns;
    }

    // Build the form with appropriate container
    Widget formContent = VooFormBuilder(
      form: _configureFormForDevice(columns),
      controller: controller,
      onSubmit: onSubmit,
      onCancel: onCancel,
      header: header,
      footer: footer,
      showProgress: showProgress,
      showValidation: showValidation,
      padding: EdgeInsets.zero, // We'll handle padding in the wrapper
    );

    // Apply Material 3 surface container
    if (useSurfaceTint) {
      formContent = Material(
        elevation: elevation ?? (isDesktop ? 1 : 0),
        surfaceTintColor: theme.colorScheme.surfaceTint,
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(
          isDesktop ? design.radiusLg : design.radiusMd,
        ),
        child: formContent,
      );
    }

    // Apply padding
    formContent = Padding(
      padding: padding,
      child: formContent,
    );

    // Apply max width constraint and alignment
    if (maxWidth != null) {
      formContent = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: formContent,
        ),
      );
    }

    // Handle alignment
    switch (alignment) {
      case FormAlignment.start:
        return Align(
          alignment: Alignment.topCenter,
          child: formContent,
        );
      case FormAlignment.end:
        return Align(
          alignment: Alignment.bottomCenter,
          child: formContent,
        );
      case FormAlignment.center:
        return Center(child: formContent);
    }
  }

  VooForm _configureFormForDevice(int columns) {
    // Adjust form layout based on columns
    if (columns == 1) {
      return form.copyWith(layout: FormLayout.vertical);
    } else if (columns >= 2 && form.layout == FormLayout.vertical) {
      // Convert vertical layout to grid for multi-column display
      return form.copyWith(layout: FormLayout.grid);
    }
    return form;
  }
}

/// Alignment options for the form within its container
enum FormAlignment {
  start,
  center,
  end,
}

/// Extension to make responsive form wrapper easier to use
extension ResponsiveFormExtension on VooForm {
  Widget responsive({
    VooFormController? controller,
    void Function(Map<String, dynamic>)? onSubmit,
    VoidCallback? onCancel,
    Widget? header,
    Widget? footer,
    bool showProgress = true,
    bool showValidation = true,
    FormAlignment alignment = FormAlignment.center,
  }) {
    return VooResponsiveFormWrapper(
      form: this,
      controller: controller,
      onSubmit: onSubmit,
      onCancel: onCancel,
      header: header,
      footer: footer,
      showProgress: showProgress,
      showValidation: showValidation,
      alignment: alignment,
    );
  }
}
