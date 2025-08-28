import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form.dart';
import 'package:voo_forms/src/presentation/controllers/voo_form_controller.dart';
import 'package:voo_forms/src/presentation/molecules/form_field_builder.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Horizontal layout organism for forms
class VooFormHorizontalLayout extends StatelessWidget {
  final VooForm form;
  final VooFormController controller;
  final bool showValidation;
  final double fieldWidth;

  const VooFormHorizontalLayout({
    super.key,
    required this.form,
    required this.controller,
    this.showValidation = true,
    this.fieldWidth = 300,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: form.fields.map((field) {
          return Container(
            width: fieldWidth,
            padding: EdgeInsets.only(right: design.spacingMd),
            child: VooFormFieldBuilder(
              field: field,
              controller: controller,
              showError: showValidation,
            ),
          );
        }).toList(),
      ),
    );
  }
}