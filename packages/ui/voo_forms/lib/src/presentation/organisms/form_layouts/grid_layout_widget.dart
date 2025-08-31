import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form.dart';
import 'package:voo_forms/src/domain/entities/form_config.dart';
import 'package:voo_forms/src/presentation/controllers/voo_form_controller.dart';
import 'package:voo_forms/src/presentation/molecules/form_field_builder.dart';

/// Widget that renders form fields in a grid layout
class GridLayoutWidget extends StatelessWidget {
  final VooForm form;
  final VooFormController controller;
  final VooFormConfig config;
  final double screenWidth;

  const GridLayoutWidget({
    super.key,
    required this.form,
    required this.controller,
    required this.config,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
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
              child: VooFormFieldBuilder(
                field: field,
                controller: controller,
                config: config,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}