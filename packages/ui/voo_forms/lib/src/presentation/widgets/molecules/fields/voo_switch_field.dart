import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/core/utils/config/voo_field_options.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

class VooSwitchFieldWidget extends StatefulWidget {
  final VooFormField field;
  final VooFieldOptions options;
  final ValueChanged<bool?>? onChanged;
  final String? error;
  final bool showError;

  const VooSwitchFieldWidget({
    super.key,
    required this.field,
    required this.options,
    this.onChanged,
    this.error,
    this.showError = true,
  });

  @override
  State<VooSwitchFieldWidget> createState() => _VooSwitchFieldWidgetState();
}

class _VooSwitchFieldWidgetState extends State<VooSwitchFieldWidget> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = (widget.field.value as bool?) ?? false;
  }

  @override
  void didUpdateWidget(VooSwitchFieldWidget oldWidget) {
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
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: widget.field.prefixIcon != null
              ? Icon(
                  widget.field.prefixIcon,
                  size: design.iconSizeMd,
                  color: hasError ? theme.colorScheme.error : theme.colorScheme.onSurfaceVariant,
                )
              : widget.field.prefix,
          title: Text(
            widget.field.label ?? widget.field.name,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: hasError ? theme.colorScheme.error : theme.colorScheme.onSurface,
            ),
          ),
          subtitle: widget.field.helper != null
              ? Text(
                  widget.field.helper!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
              : null,
          trailing: VooSwitch(
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
            isError: hasError,
          ),
        ),
        if (hasError)
          Padding(
            padding: EdgeInsets.only(
              left: design.spacingLg,
              top: design.spacingXs,
            ),
            child: Text(
              errorText,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}
