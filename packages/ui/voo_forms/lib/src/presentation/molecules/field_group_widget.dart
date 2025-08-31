import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form.dart';
import 'package:voo_forms/src/domain/entities/form_config.dart';
import 'package:voo_forms/src/presentation/controllers/voo_form_controller.dart';
import 'package:voo_forms/src/presentation/molecules/collapsible_group_widget.dart';
import 'package:voo_forms/src/presentation/molecules/field_group_content_widget.dart';

/// Widget that renders a group of form fields
class FieldGroupWidget extends StatelessWidget {
  final VooForm form;
  final VooFormController controller;
  final VooFormConfig config;
  final FieldGroup group;
  final double screenWidth;

  const FieldGroupWidget({
    super.key,
    required this.form,
    required this.controller,
    required this.config,
    required this.group,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groupFields = form.fields
        .where((field) => group.fieldIds.contains(field.id))
        .toList();

    Widget content = FieldGroupContentWidget(
      controller: controller,
      config: config,
      fields: groupFields,
      columns: group.columns,
      screenWidth: screenWidth,
    );

    if (group.title != null || group.description != null) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (group.title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                group.title!,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (group.description != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                group.description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          content,
        ],
      );
    }

    if (group.collapsible) {
      content = CollapsibleGroupWidget(
        group: group,
        child: content,
      );
    }

    return Container(
      decoration: group.decoration,
      padding: group.padding ?? const EdgeInsets.all(16.0),
      margin: group.margin ?? EdgeInsets.only(bottom: config.sectionSpacing),
      child: content,
    );
  }
}