import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_config.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/controllers/voo_form_controller.dart';
import 'package:voo_forms/src/presentation/molecules/form_field_builder.dart';

/// Widget that renders the content of a field group
class FieldGroupContentWidget extends StatelessWidget {
  final VooFormController controller;
  final VooFormConfig config;
  final List<VooFormField> fields;
  final int columns;
  final double screenWidth;

  const FieldGroupContentWidget({
    super.key,
    required this.controller,
    required this.config,
    required this.fields,
    required this.columns,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColumns =
        screenWidth < config.mobileBreakpoint ? 1 : columns;

    if (effectiveColumns == 1) {
      return Column(
        children: fields.map((field) => Padding(
          padding: EdgeInsets.only(bottom: config.fieldSpacing),
          child: VooFormFieldBuilder(
            field: field,
            controller: controller,
            config: config,
          ),
        )).toList(),
      );
    }

    // Multi-column layout
    return LayoutBuilder(
      builder: (context, constraints) {
        final columnWidth = (constraints.maxWidth -
                (effectiveColumns - 1) * config.fieldSpacing) /
            effectiveColumns;

        return Wrap(
          spacing: config.fieldSpacing,
          runSpacing: config.fieldSpacing,
          children: fields.map((field) {
            final fieldColumns = field.gridColumns ?? 1;
            final width = fieldColumns > effectiveColumns
                ? constraints.maxWidth
                : (columnWidth * fieldColumns +
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