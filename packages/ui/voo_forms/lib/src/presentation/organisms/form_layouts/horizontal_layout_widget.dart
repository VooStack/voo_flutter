import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form.dart';
import 'package:voo_forms/src/domain/entities/form_config.dart';
import 'package:voo_forms/src/presentation/controllers/voo_form_controller.dart';
import 'package:voo_forms/src/presentation/molecules/form_field_builder.dart';

/// Widget that renders form fields in a horizontal layout
class HorizontalLayoutWidget extends StatelessWidget {
  final VooForm form;
  final VooFormController controller;
  final VooFormConfig config;

  const HorizontalLayoutWidget({
    super.key,
    required this.form,
    required this.controller,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: form.fields.map((field) => Expanded(
        child: Padding(
          padding: EdgeInsets.only(right: config.fieldSpacing),
          child: VooFormFieldBuilder(
            field: field,
            controller: controller,
            config: config,
          ),
        ),
      )).toList(),
    );
  }
}