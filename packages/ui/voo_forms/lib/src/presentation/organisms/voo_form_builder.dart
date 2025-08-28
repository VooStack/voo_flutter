import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form.dart';
import 'package:voo_forms/src/presentation/controllers/voo_form_controller.dart';
import 'package:voo_forms/src/presentation/molecules/voo_form_actions.dart';
import 'package:voo_forms/src/presentation/molecules/voo_form_progress.dart';
import 'package:voo_forms/src/presentation/organisms/voo_form_grid_layout.dart';
import 'package:voo_forms/src/presentation/organisms/voo_form_horizontal_layout.dart';
import 'package:voo_forms/src/presentation/organisms/voo_form_stepped_layout.dart';
import 'package:voo_forms/src/presentation/organisms/voo_form_tabbed_layout.dart';
import 'package:voo_forms/src/presentation/organisms/voo_form_vertical_layout.dart';
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
    
    // Make responsive optional
    final responsive = VooResponsive.maybeOf(context);
    final spacing = responsive?.device(
      phone: design.spacingMd,
      tablet: design.spacingLg,
      desktop: design.spacingXl,
      defaultValue: design.spacingMd,
    ) ?? design.spacingMd;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VooFormProgress(
          form: widget.form,
          controller: _controller,
          showProgress: widget.showProgress,
        ),
        if (widget.header != null) widget.header!,
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: widget.physics,
            padding: widget.padding ?? EdgeInsets.all(spacing),
            child: _buildFormLayout(context),
          ),
        ),
        if (widget.footer != null) widget.footer!,
        VooFormActions(
          controller: _controller,
          onSubmit: widget.onSubmit != null ? () => _handleSubmit() : null,
          onCancel: widget.onCancel,
          showCancel: widget.onCancel != null,
          customBuilder: widget.actionsBuilder,
        ),
      ],
    );
  }

  Widget _buildFormLayout(BuildContext context) {
    switch (widget.form.layout) {
      case FormLayout.vertical:
        return VooFormVerticalLayout(
          form: widget.form,
          controller: _controller,
          showValidation: widget.showValidation,
        );
      case FormLayout.horizontal:
        return VooFormHorizontalLayout(
          form: widget.form,
          controller: _controller,
          showValidation: widget.showValidation,
        );
      case FormLayout.grid:
        return VooFormGridLayout(
          form: widget.form,
          controller: _controller,
          showValidation: widget.showValidation,
        );
      case FormLayout.stepped:
        return VooFormSteppedLayout(
          form: widget.form,
          controller: _controller,
          showValidation: widget.showValidation,
        );
      case FormLayout.tabbed:
        return VooFormTabbedLayout(
          form: widget.form,
          controller: _controller,
          showValidation: widget.showValidation,
        );
    }
  }

  void _handleSubmit() async {
    if (widget.onSubmit != null) {
      await _controller.submit(
        onSubmit: (values) async {
          widget.onSubmit!(values);
        },
        onSuccess: () {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Form submitted successfully'),
                backgroundColor: Theme.of(context).colorScheme.tertiary,
              ),
            );
          }
        },
        onError: (error) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: $error'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
      );
    }
  }

}