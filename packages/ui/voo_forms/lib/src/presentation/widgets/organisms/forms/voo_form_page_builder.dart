import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form.dart' as domain;
import 'package:voo_forms/src/domain/entities/form_config.dart';
import 'package:voo_forms/src/presentation/config/theme/form_theme.dart';
import 'package:voo_forms/src/presentation/state/voo_form_controller.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/progress/voo_form_progress.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/actions/voo_form_actions.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/containers/voo_side_panel_provider.dart';
import 'package:voo_forms/src/presentation/widgets/organisms/forms/voo_form.dart';

/// Page builder for VooForm that handles layout, actions, and callbacks
/// This is a higher-level organism that composes VooForm with additional UI elements
class VooFormPageBuilder extends StatefulWidget {
  /// The form to build a page for
  final VooForm form;

  /// Optional form controller that propagates to VooForm
  final VooFormController? controller;

  /// Default configuration that propagates to form
  final VooFormConfig? defaultConfig;

  /// Callback when form is submitted with valid data
  final void Function(Map<String, dynamic>)? onSubmit;

  /// Callback when form is cancelled
  final VoidCallback? onCancel;

  /// Callback on successful submission
  final VoidCallback? onSuccess;

  /// Callback on submission error
  final void Function(dynamic)? onError;

  /// Whether to show submit button
  final bool showSubmitButton;

  /// Whether to show cancel button
  final bool showCancelButton;

  /// Submit button text
  final String submitText;

  /// Cancel button text
  final String cancelText;

  /// Optional header widget
  final Widget? header;

  /// Optional footer widget
  final Widget? footer;

  /// Whether to show progress indicator
  final bool showProgress;

  /// Spacing between elements
  final double spacing;

  /// Padding around the page
  final EdgeInsetsGeometry? padding;

  /// Scroll physics for the page
  final ScrollPhysics? physics;

  /// Whether fields are editable
  final bool isEditable;

  /// Custom actions builder
  final Widget Function(BuildContext, VooFormController)? actionsBuilder;

  /// Main axis alignment for actions
  final MainAxisAlignment actionsAlignment;

  /// Whether to wrap form in a card
  final bool wrapInCard;

  /// Card elevation if wrapped in card
  final double? cardElevation;

  /// Card margin if wrapped in card
  final EdgeInsetsGeometry? cardMargin;

  const VooFormPageBuilder({
    super.key,
    required this.form,
    this.controller,
    this.defaultConfig,
    this.onSubmit,
    this.onCancel,
    this.onSuccess,
    this.onError,
    this.showSubmitButton = true,
    this.showCancelButton = false,
    this.submitText = 'Submit',
    this.cancelText = 'Cancel',
    this.header,
    this.footer,
    this.showProgress = false,
    this.spacing = 16.0,
    this.padding,
    this.physics,
    this.isEditable = true,
    this.actionsBuilder,
    this.actionsAlignment = MainAxisAlignment.end,
    this.wrapInCard = false,
    this.cardElevation,
    this.cardMargin,
  });

  @override
  State<VooFormPageBuilder> createState() => _VooFormPageBuilderState();
}

class _VooFormPageBuilderState extends State<VooFormPageBuilder> {
  VooFormController? _controller;
  late ScrollController _scrollController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Use provided controller if available
    _controller = widget.controller;
    _controller?.addListener(_handleControllerChange);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller?.removeListener(_handleControllerChange);
    super.dispose();
  }

  void _handleControllerChange() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _handleSubmit() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      // For now, just call onSubmit with empty values if no controller
      // The actual form values will be handled by VooForm internally
      if (_controller != null) {
        // Always validate on submit, controller will handle error display based on errorDisplayMode
        final isValid = _controller!.validateAll(force: true);
        if (!isValid) {
          setState(() => _isSubmitting = false);
          return;
        }
        final values = _controller!.values;
        widget.onSubmit?.call(values);
      } else {
        widget.onSubmit?.call({});
      }
      widget.onSuccess?.call();
    } catch (error) {
      widget.onError?.call(error);
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Widget _buildForm() => widget.isEditable
      ? widget.form
      : AbsorbPointer(
          child: Opacity(
            opacity: 0.6,
            child: widget.form,
          ),
        );

  Widget _buildActions(BuildContext context) {
    if (widget.actionsBuilder != null) {
      // Create a dummy controller if needed for custom actions builder
      final effectiveController = _controller ??
          VooFormController(
            form: domain.VooForm(
              id: 'temp_form_${DateTime.now().millisecondsSinceEpoch}',
              fields: const [],
            ),
          );
      return widget.actionsBuilder!(context, effectiveController);
    }

    return VooFormActions(
      onSubmit: _handleSubmit,
      onCancel: widget.onCancel,
      submitText: widget.submitText,
      cancelText: widget.cancelText,
      showSubmit: widget.showSubmitButton,
      showCancel: widget.showCancelButton || widget.onCancel != null,
      alignment: widget.actionsAlignment,
      submitEnabled: widget.isEditable,
      cancelEnabled: widget.isEditable,
      isLoading: _isSubmitting,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveConfig = widget.defaultConfig ?? const VooFormConfig();

    // Generate form theme
    final formTheme = VooFormTheme.generateFormTheme(
      colorScheme: theme.colorScheme,
      textTheme: theme.textTheme,
    );

    // Build page content with footer layout
    Widget content = Column(
      children: [
        // Scrollable form content
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: widget.physics ?? const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                if (widget.header != null) ...[
                  widget.header!,
                  SizedBox(height: widget.spacing * 1.5),
                ],

                // Progress indicator
                if (widget.showProgress) ...[
                  VooFormProgress(
                    isIndeterminate: _isSubmitting,
                    value: _isSubmitting ? null : 0.0,
                  ),
                  SizedBox(height: widget.spacing),
                ],

                // Form
                _buildForm(),

                // Add spacing at bottom to ensure content isn't hidden behind actions
                SizedBox(height: widget.spacing * 2),
              ],
            ),
          ),
        ),

        // Fixed footer with actions
        if (widget.showSubmitButton || widget.showCancelButton || widget.actionsBuilder != null) ...[
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: widget.spacing,
              vertical: widget.spacing,
            ),
            child: _buildActions(context),
          ),
        ],

        // Footer
        if (widget.footer != null) widget.footer!,
      ],
    );

    // Apply theme
    content = Theme(
      data: formTheme,
      child: content,
    );

    // Wrap in card if requested
    if (widget.wrapInCard) {
      content = Card(
        elevation: widget.cardElevation ?? 2.0,
        margin: widget.cardMargin ?? const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: widget.padding ?? const EdgeInsets.all(24.0),
          child: content,
        ),
      );
    } else if (widget.padding != null) {
      content = Padding(
        padding: widget.padding!,
        child: content,
      );
    } else {
      // Default padding if not wrapped in card and no padding specified
      content = Padding(
        padding: const EdgeInsets.all(16.0),
        child: content,
      );
    }

    // Apply config decoration
    if (effectiveConfig.decoration != null) {
      content = DecoratedBox(
        decoration: effectiveConfig.decoration!,
        child: content,
      );
    }

    // Apply background color
    if (effectiveConfig.backgroundColor != null) {
      content = ColoredBox(
        color: effectiveConfig.backgroundColor!,
        child: content,
      );
    }

    // Wrap with VooSidePanelProvider for side panel support
    content = VooSidePanelProvider(
      child: content,
    );

    // Provide controller to form via InheritedWidget pattern if available
    if (_controller != null) {
      return _FormControllerProvider(
        controller: _controller!,
        child: content,
      );
    }
    return content;
  }
}

/// InheritedWidget to provide controller down the tree
class _FormControllerProvider extends InheritedWidget {
  final VooFormController controller;

  const _FormControllerProvider({required this.controller, required super.child});

  @override
  bool updateShouldNotify(_FormControllerProvider oldWidget) => controller != oldWidget.controller;
}
