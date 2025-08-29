import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form.dart';
import 'package:voo_forms/src/domain/entities/form_config.dart';
import 'package:voo_forms/src/presentation/controllers/voo_form_controller.dart';
import 'package:voo_forms/src/presentation/molecules/form_section.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Tabbed layout organism for forms
class VooFormTabbedLayout extends StatelessWidget {
  final VooForm form;
  final VooFormController controller;
  final bool showValidation;
  final TabController? tabController;
  final VooFormConfig? config;

  const VooFormTabbedLayout({
    super.key,
    required this.form,
    required this.controller,
    this.showValidation = true,
    this.tabController,
    this.config,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    
    if (form.sections == null || form.sections!.isEmpty) {
      return const Center(
        child: Text('No sections configured for tabbed layout'),
      );
    }
    
    final tabContent = Column(
      children: [
        TabBar(
          controller: tabController,
          tabs: form.sections!.map((section) {
            return Tab(
              text: section.title ?? 'Section',
              icon: section.icon != null ? Icon(section.icon) : null,
            );
          }).toList(),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: form.sections!.map((section) {
              final sectionFields = form.fields
                  .where((field) => section.fieldIds.contains(field.id))
                  .toList();
              
              return Padding(
                padding: EdgeInsets.all(design.spacingMd),
                child: FormSectionWidget(
                  section: section,
                  fields: sectionFields,
                  controller: controller,
                  showErrors: showValidation,
                  config: config,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
    
    // If no external tab controller provided, wrap with DefaultTabController
    if (tabController == null) {
      return DefaultTabController(
        length: form.sections!.length,
        child: tabContent,
      );
    }
    
    return tabContent;
  }
}