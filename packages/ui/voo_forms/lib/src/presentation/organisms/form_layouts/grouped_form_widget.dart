import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form.dart';
import 'package:voo_forms/src/domain/entities/form_config.dart';
import 'package:voo_forms/src/presentation/controllers/voo_form_controller.dart';
import 'package:voo_forms/src/presentation/molecules/field_group_widget.dart';

/// Widget that renders a form with grouped fields
class GroupedFormWidget extends StatelessWidget {
  final VooForm form;
  final VooFormController controller;
  final VooFormConfig config;
  final double screenWidth;
  final List<FieldGroup> fieldGroups;

  const GroupedFormWidget({
    super.key,
    required this.form,
    required this.controller,
    required this.config,
    required this.screenWidth,
    required this.fieldGroups,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: fieldGroups.map((group) => FieldGroupWidget(
        form: form,
        controller: controller,
        config: config,
        group: group,
        screenWidth: screenWidth,
      )).toList(),
    );
  }
}