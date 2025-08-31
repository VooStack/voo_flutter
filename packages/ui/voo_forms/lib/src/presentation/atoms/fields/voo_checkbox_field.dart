import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

class VooCheckboxFieldWidget extends StatefulWidget {
  final VooFormField field;
  final VooFieldOptions options;
  final ValueChanged<bool?>? onChanged;
  final String? error;
  final bool showError;

  const VooCheckboxFieldWidget({
    super.key,
    required this.field,
    required this.options,
    this.onChanged,
    this.error,
    this.showError = true,
  });

  @override
  State<VooCheckboxFieldWidget> createState() => _VooCheckboxFieldWidgetState();
}

class _VooCheckboxFieldWidgetState extends State<VooCheckboxFieldWidget> {
  late bool? _value;

  @override
  void initState() {
    super.initState();
    _value = (widget.field.value as bool?) ?? false;
  }

  @override
  void didUpdateWidget(VooCheckboxFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.field.value != widget.field.value) {
      _value = (widget.field.value as bool?) ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);

    final errorText = widget.showError ? (widget.error ?? widget.field.error) : null;
    final hasError = errorText != null && errorText.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        VooLabeledCheckbox(
          value: _value,
          onChanged: widget.field.enabled && !widget.field.readOnly
              ? (value) {
                  setState(() {
                    _value = value;
                  });
                  widget.onChanged?.call(value);
                  // Safely call field.onChanged with type checking
                  try {
                    final dynamic dynField = widget.field;
                    final callback = dynField.onChanged;
                    if (callback != null) {
                      callback(value);
                    }
                  } catch (_) {
                    // Silently ignore type casting errors
                  }
                }
              : null,
          label: widget.field.label ?? widget.field.name,
          subtitle: widget.field.helper,
          isError: hasError,
        ),
        if (hasError)
          Padding(
            padding: EdgeInsets.only(
              left: design.spacingLg,
              top: design.spacingXs,
            ),
            child: Text(
              errorText,
              style: widget.options.errorStyle ?? theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}
