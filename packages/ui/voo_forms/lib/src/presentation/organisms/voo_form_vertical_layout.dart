import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form.dart';
import 'package:voo_forms/src/domain/entities/form_config.dart';
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
  final VooFormConfig? config;

  const VooFormVerticalLayout({
    super.key,
    required this.form,
    required this.controller,
    this.showValidation = true,
    this.padding,
    this.config,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);
    
    if (form.sections != null && form.sections!.isNotEmpty) {
      // Sectioned form with enhanced visual grouping
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: form.sections!.asMap().entries.map((entry) {
          final index = entry.key;
          final section = entry.value;
          final sectionFields = form.fields
              .where((field) => section.fieldIds.contains(field.id))
              .toList();
          
          return AnimatedContainer(
            duration: Duration(milliseconds: 300 + (index * 50)),
            margin: EdgeInsets.only(bottom: design.spacingXl),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
                width: 1.0,
              ),
            ),
            child: FormSectionWidget(
              section: section,
              fields: sectionFields,
              controller: controller,
              showErrors: showValidation,
              config: config,
            ),
          );
        }).toList(),
      );
    } else {
      // Enhanced simple vertical layout with better spacing
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: form.fields.asMap().entries.map((entry) {
          final index = entry.key;
          final field = entry.value;
          final isLast = index == form.fields.length - 1;
          
          return AnimatedContainer(
            duration: Duration(milliseconds: 200 + (index * 50)),
            curve: Curves.easeOutCubic,
            margin: EdgeInsets.only(
              bottom: isLast ? 0 : design.spacingLg * 1.2,
            ),
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 300 + (index * 50)),
              opacity: 1.0,
              child: Transform.translate(
                offset: Offset.zero,
                child: VooFormFieldBuilder(
                  field: field,
                  controller: controller,
                  showError: showValidation,
                  config: config,
                ),
              ),
            ),
          );
        }).toList(),
      );
    }
  }
}