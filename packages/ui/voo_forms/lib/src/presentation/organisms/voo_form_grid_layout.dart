import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form.dart';
import 'package:voo_forms/src/presentation/controllers/voo_form_controller.dart';
import 'package:voo_forms/src/presentation/molecules/form_field_builder.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Grid layout organism for forms
class VooFormGridLayout extends StatelessWidget {
  final VooForm form;
  final VooFormController controller;
  final bool showValidation;
  final int? columns;

  const VooFormGridLayout({
    super.key,
    required this.form,
    required this.controller,
    this.showValidation = true,
    this.columns,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final responsive = VooResponsive.maybeOf(context);
    
    final gridColumns = columns ?? responsive?.device(
      phone: 1,
      tablet: 2,
      desktop: 3,
      defaultValue: 2,
    ) ?? 2;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - (gridColumns - 1) * design.spacingMd) / gridColumns;
        
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
                showError: showValidation,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}