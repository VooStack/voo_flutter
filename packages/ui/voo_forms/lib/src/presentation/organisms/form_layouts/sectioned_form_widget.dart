import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form.dart';
import 'package:voo_forms/src/domain/entities/form_config.dart';
import 'package:voo_forms/src/domain/entities/form_section.dart';
import 'package:voo_forms/src/presentation/controllers/voo_form_controller.dart';
import 'package:voo_forms/src/presentation/molecules/form_section.dart';

/// Widget that renders a form with sections
class SectionedFormWidget extends StatelessWidget {
  final VooForm form;
  final VooFormController controller;
  final VooFormConfig config;
  final double screenWidth;
  final List<VooFormSection> sections;
  final bool showErrors;

  const SectionedFormWidget({
    super.key,
    required this.form,
    required this.controller,
    required this.config,
    required this.screenWidth,
    required this.sections,
    this.showErrors = true,
  });

  @override
  Widget build(BuildContext context) => Column(
      children: sections.map((section) {
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