import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form.dart';
import 'package:voo_forms/src/presentation/controllers/form_controller.dart';
import 'package:voo_forms/src/presentation/molecules/form_field_builder.dart';
import 'package:voo_forms/src/presentation/molecules/form_section.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Main form builder widget that renders a complete form
class VooFormBuilder extends StatefulWidget {
  final VooForm form;
  final VooFormController? controller;
  final void Function(Map<String, dynamic>)? onSubmit;
  final VoidCallback? onCancel;
  final Widget? header;
  final Widget? footer;
  final bool showProgress;
  final bool showValidation;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final Widget Function(BuildContext, VooFormController)? actionsBuilder;

  const VooFormBuilder({
    super.key,
    required this.form,
    this.controller,
    this.onSubmit,
    this.onCancel,
    this.header,
    this.footer,
    this.showProgress = true,
    this.showValidation = true,
    this.padding,
    this.physics,
    this.actionsBuilder,
  });

  @override
  State<VooFormBuilder> createState() => _VooFormBuilderState();
}

class _VooFormBuilderState extends State<VooFormBuilder> {
  late VooFormController _controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? VooFormController(form: widget.form);
    _controller.addListener(_handleControllerChange);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _controller.removeListener(_handleControllerChange);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleControllerChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final responsive = context.responsive;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showProgress) _buildProgress(context),
        if (widget.header != null) widget.header!,
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: widget.physics,
            padding: widget.padding ??
                EdgeInsets.all(
                  responsive.device(
                    phone: design.spacingMd,
                    tablet: design.spacingLg,
                    desktop: design.spacingXl,
                    defaultValue: design.spacingMd,
                  ),
                ),
            child: _buildFormContent(context),
          ),
        ),
        if (widget.footer != null) widget.footer!,
        _buildActions(context),
      ],
    );
  }

  Widget _buildProgress(BuildContext context) {
    final theme = Theme.of(context);
    final progress = _calculateProgress();

    return SizedBox(
      height: 4,
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        valueColor: AlwaysStoppedAnimation<Color>(
          progress >= 1.0 ? Colors.green : theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildFormContent(BuildContext context) {
    switch (widget.form.layout) {
      case FormLayout.vertical:
        return _buildVerticalLayout(context);
      case FormLayout.horizontal:
        return _buildHorizontalLayout(context);
      case FormLayout.grid:
        return _buildGridLayout(context);
      case FormLayout.stepped:
        return _buildSteppedLayout(context);
      case FormLayout.tabbed:
        return _buildTabbedLayout(context);
    }
  }

  Widget _buildVerticalLayout(BuildContext context) {
    final design = context.vooDesign;
    
    if (widget.form.sections != null && widget.form.sections!.isNotEmpty) {
      // Sectioned form
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widget.form.sections!.map((section) {
          final sectionFields = widget.form.fields
              .where((field) => section.fieldIds.contains(field.id))
              .toList();
          
          return Padding(
            padding: EdgeInsets.only(bottom: design.spacingLg),
            child: FormSectionWidget(
              section: section,
              fields: sectionFields,
              controller: _controller,
              showErrors: widget.showValidation,
            ),
          );
        }).toList(),
      );
    } else {
      // Simple vertical layout
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widget.form.fields.map((field) {
          return Padding(
            padding: EdgeInsets.only(bottom: design.spacingMd),
            child: VooFormFieldBuilder(
              field: field,
              controller: _controller,
              showError: widget.showValidation,
            ),
          );
        }).toList(),
      );
    }
  }

  Widget _buildHorizontalLayout(BuildContext context) {
    final design = context.vooDesign;
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.form.fields.map((field) {
          return Container(
            width: 300,
            padding: EdgeInsets.only(right: design.spacingMd),
            child: VooFormFieldBuilder(
              field: field,
              controller: _controller,
              showError: widget.showValidation,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGridLayout(BuildContext context) {
    final design = context.vooDesign;
    final responsive = context.responsive;
    
    final columns = responsive.device(
      phone: 1,
      tablet: 2,
      desktop: 3,
      defaultValue: 2,
    );
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - (columns - 1) * design.spacingMd) / columns;
        
        return Wrap(
          spacing: design.spacingMd,
          runSpacing: design.spacingMd,
          children: widget.form.fields.map((field) {
            return SizedBox(
              width: field.gridColumns != null
                  ? (itemWidth * field.gridColumns! + design.spacingMd * (field.gridColumns! - 1))
                  : itemWidth,
              child: VooFormFieldBuilder(
                field: field,
                controller: _controller,
                showError: widget.showValidation,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildSteppedLayout(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);
    
    // Extract steps from metadata
    final steps = widget.form.metadata?['steps'] as List?;
    final currentStep = _controller.getValue('_currentStep') ?? 0;
    
    if (steps == null || steps.isEmpty) {
      return _buildVerticalLayout(context);
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Step indicators
        Container(
          padding: EdgeInsets.symmetric(vertical: design.spacingLg),
          child: Row(
            children: List.generate(steps.length, (index) {
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
                              ? Colors.green
                              : theme.colorScheme.surfaceContainerHighest,
                      child: isCompleted
                          ? const Icon(Icons.check, size: 16, color: Colors.white)
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: isActive
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                    ),
                    if (index < steps.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isCompleted
                              ? Colors.green
                              : theme.colorScheme.surfaceContainerHighest,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ),
        // Current step content
        if (widget.form.sections != null && currentStep < widget.form.sections!.length)
          FormSectionWidget(
            section: widget.form.sections![currentStep],
            fields: widget.form.fields
                .where((field) => widget.form.sections![currentStep].fieldIds.contains(field.id))
                .toList(),
            controller: _controller,
            showErrors: widget.showValidation,
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
                    _controller.setValue('_currentStep', currentStep - 1);
                  },
                  variant: VooButtonVariant.outlined,
                  child: const Text('Previous'),
                ),
              const Spacer(),
              if (currentStep < steps.length - 1)
                VooButton(
                  onPressed: () {
                    if (_validateCurrentStep(currentStep)) {
                      _controller.setValue('_currentStep', currentStep + 1);
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

  Widget _buildTabbedLayout(BuildContext context) {
    final design = context.vooDesign;
    
    if (widget.form.sections == null || widget.form.sections!.isEmpty) {
      return _buildVerticalLayout(context);
    }
    
    return DefaultTabController(
      length: widget.form.sections!.length,
      child: Column(
        children: [
          TabBar(
            tabs: widget.form.sections!.map((section) {
              return Tab(
                text: section.title ?? 'Section',
                icon: section.icon != null ? Icon(section.icon) : null,
              );
            }).toList(),
          ),
          Expanded(
            child: TabBarView(
              children: widget.form.sections!.map((section) {
                final sectionFields = widget.form.fields
                    .where((field) => section.fieldIds.contains(field.id))
                    .toList();
                
                return Padding(
                  padding: EdgeInsets.all(design.spacingMd),
                  child: FormSectionWidget(
                    section: section,
                    fields: sectionFields,
                    controller: _controller,
                    showErrors: widget.showValidation,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final design = context.vooDesign;
    
    if (widget.actionsBuilder != null) {
      return widget.actionsBuilder!(context, _controller);
    }
    
    return Container(
      padding: EdgeInsets.all(design.spacingMd),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (widget.onCancel != null)
            VooButton(
              onPressed: widget.onCancel,
              variant: VooButtonVariant.text,
              child: const Text('Cancel'),
            ),
          SizedBox(width: design.spacingMd),
          VooButton(
            onPressed: _controller.isSubmitting
                ? null
                : () async {
                    if (widget.onSubmit != null) {
                      await _controller.submit(
                        onSubmit: (values) async {
                          widget.onSubmit!(values);
                        },
                        onSuccess: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Form submitted successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        onError: (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $error'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                      );
                    }
                  },
            child: _controller.isSubmitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Submit'),
          ),
        ],
      ),
    );
  }

  double _calculateProgress() {
    final requiredFields = widget.form.fields.where((f) => f.required).toList();
    if (requiredFields.isEmpty) return 1.0;
    
    int filledCount = 0;
    for (final field in requiredFields) {
      final value = _controller.getValue(field.id);
      if (value != null &&
          !(value is String && value.isEmpty) &&
          !(value is List && value.isEmpty)) {
        filledCount++;
      }
    }
    
    return filledCount / requiredFields.length;
  }

  bool _validateCurrentStep(int step) {
    if (widget.form.sections == null || step >= widget.form.sections!.length) {
      return true;
    }
    
    final section = widget.form.sections![step];
    final sectionFields = widget.form.fields
        .where((field) => section.fieldIds.contains(field.id))
        .toList();
    
    bool isValid = true;
    for (final field in sectionFields) {
      if (!_controller.validateField(field.id)) {
        isValid = false;
      }
    }
    
    return isValid;
  }
}