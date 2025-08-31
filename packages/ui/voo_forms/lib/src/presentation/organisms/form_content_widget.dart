import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form.dart';
import 'package:voo_forms/src/domain/entities/form_config.dart';
import 'package:voo_forms/src/presentation/controllers/voo_form_controller.dart';
import 'package:voo_forms/src/presentation/organisms/form_layouts/grid_layout_widget.dart';
import 'package:voo_forms/src/presentation/organisms/form_layouts/grouped_form_widget.dart';
import 'package:voo_forms/src/presentation/organisms/form_layouts/horizontal_layout_widget.dart';
import 'package:voo_forms/src/presentation/organisms/form_layouts/sectioned_form_widget.dart';
import 'package:voo_forms/src/presentation/organisms/form_layouts/vertical_layout_widget.dart';

/// Widget that handles form content rendering based on layout configuration
class FormContentWidget extends StatelessWidget {
  final VooForm form;
  final VooFormController controller;
  final VooFormConfig config;
  final double screenWidth;
  final List<FieldGroup>? fieldGroups;

  const FormContentWidget({
    super.key,
    required this.form,
    required this.controller,
    required this.config,
    required this.screenWidth,
    this.fieldGroups,
  });

  @override
  Widget build(BuildContext context) {
    // Use field groups if provided
    if (fieldGroups != null && fieldGroups!.isNotEmpty) {
      return GroupedFormWidget(
        form: form,
        controller: controller,
        config: config,
        screenWidth: screenWidth,
        fieldGroups: fieldGroups!,
      );
    }

    // Use sections if provided
    if (form.sections != null && form.sections!.isNotEmpty) {
      return SectionedFormWidget(
        form: form,
        controller: controller,
        config: config,
        screenWidth: screenWidth,
        sections: form.sections!,
      );
    }

    // Build based on layout
    switch (form.layout) {
      case FormLayout.grid:
        return GridLayoutWidget(
          form: form,
          controller: controller,
          config: config,
          screenWidth: screenWidth,
        );
      case FormLayout.horizontal:
        return HorizontalLayoutWidget(
          form: form,
          controller: controller,
          config: config,
        );
      default:
        return VerticalLayoutWidget(
          form: form,
          controller: controller,
          config: config,
        );
    }
  }
}