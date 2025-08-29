import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form.dart';
import 'package:voo_forms/src/domain/entities/form_config.dart';
import 'package:voo_forms/src/presentation/controllers/voo_form_controller.dart';
import 'package:voo_forms/src/presentation/molecules/form_section.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Stepped/Wizard layout organism for forms
class VooFormSteppedLayout extends StatelessWidget {
  final VooForm form;
  final VooFormController controller;
  final bool showValidation;
  final Widget Function(int step, int totalSteps)? stepIndicatorBuilder;
  final VooFormConfig? config;

  const VooFormSteppedLayout({
    super.key,
    required this.form,
    required this.controller,
    this.showValidation = true,
    this.stepIndicatorBuilder,
    this.config,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    
    // Extract steps from metadata
    final steps = form.metadata?['steps'] as List?;
    final currentStep = controller.getValue('_currentStep') ?? 0;
    
    if (steps == null || steps.isEmpty || form.sections == null) {
      return const Center(
        child: Text('No steps configured for stepped layout'),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Step indicators
        if (stepIndicatorBuilder != null)
          stepIndicatorBuilder!(currentStep, steps.length)
        else
          _buildDefaultStepIndicator(context, currentStep, steps.length),
        
        // Current step content
        if (currentStep < form.sections!.length)
          Expanded(
            child: FormSectionWidget(
              section: form.sections![currentStep],
              fields: form.fields
                  .where((field) => form.sections![currentStep].fieldIds.contains(field.id))
                  .toList(),
              controller: controller,
              showErrors: showValidation,
              config: config,
            ),
          ),
        
        // Step navigation
        Padding(
          padding: EdgeInsets.only(top: design.spacingLg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (currentStep > 0)
                VooButton(
                  onPressed: () {
                    controller.setValue('_currentStep', currentStep - 1);
                  },
                  variant: VooButtonVariant.outlined,
                  child: const Text('Previous'),
                ),
              const Spacer(),
              if (currentStep < steps.length - 1)
                VooButton(
                  onPressed: () {
                    if (_validateCurrentStep(currentStep)) {
                      controller.setValue('_currentStep', currentStep + 1);
                    }
                  },
                  child: const Text('Next'),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultStepIndicator(BuildContext context, int currentStep, int totalSteps) {
    final design = context.vooDesign;
    final theme = Theme.of(context);
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: design.spacingLg),
      child: Row(
        children: List.generate(totalSteps, (index) {
          final isActive = index == currentStep;
          final isCompleted = index < currentStep;
          
          return Expanded(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: isActive
                      ? theme.colorScheme.primary
                      : isCompleted
                          ? theme.colorScheme.tertiary
                          : theme.colorScheme.surfaceContainerHighest,
                  child: isCompleted
                      ? Icon(Icons.check, size: 16, color: theme.colorScheme.onTertiary)
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isActive
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                ),
                if (index < totalSteps - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: isCompleted
                          ? theme.colorScheme.tertiary
                          : theme.colorScheme.surfaceContainerHighest,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  bool _validateCurrentStep(int step) {
    if (form.sections == null || step >= form.sections!.length) {
      return true;
    }
    
    final section = form.sections![step];
    final sectionFields = form.fields
        .where((field) => section.fieldIds.contains(field.id))
        .toList();
    
    bool isValid = true;
    for (final field in sectionFields) {
      if (!controller.validateField(field.id)) {
        isValid = false;
      }
    }
    
    return isValid;
  }
}