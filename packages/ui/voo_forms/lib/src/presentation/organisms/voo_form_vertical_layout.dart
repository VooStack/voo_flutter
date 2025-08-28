import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form.dart';
import 'package:voo_forms/src/presentation/controllers/voo_form_controller.dart';
import 'package:voo_forms/src/presentation/molecules/form_field_builder.dart';
import 'package:voo_forms/src/presentation/molecules/form_section.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Vertical layout organism for forms
class VooFormVerticalLayout extends StatelessWidget {
  final VooForm form;
  final VooFormController controller;
  final bool showValidation;
  final EdgeInsetsGeometry? padding;

  const VooFormVerticalLayout({
    super.key,
    required this.form,
    required this.controller,
    this.showValidation = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    
    if (form.sections != null && form.sections!.isNotEmpty) {
      // Sectioned form
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
              showErrors: showValidation,
            ),
          );
        }).toList(),
      );
    } else {
      // Simple vertical layout
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: form.fields.map((field) {
          return Padding(
            padding: EdgeInsets.only(bottom: design.spacingMd),
            child: VooFormFieldBuilder(
              field: field,
              controller: controller,
              showError: showValidation,
            ),
          );
        }).toList(),
      );
    }
  }
}