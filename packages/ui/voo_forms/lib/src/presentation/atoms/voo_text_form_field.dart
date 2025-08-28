import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_forms/src/domain/entities/field_type.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

class VooTextFormField extends StatefulWidget {
  final VooFormField field;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final String? error;
  final bool showError;

  const VooTextFormField({
    super.key,
    required this.field,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.error,
    this.showError = true,
  });

  @override
  State<VooTextFormField> createState() => _VooTextFormFieldState();
}

class _VooTextFormFieldState extends State<VooTextFormField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        TextEditingController(text: widget.field.value?.toString() ?? '');
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.field.type == VooFieldType.password;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;

    // Build suffix icon for password field
    Widget? suffixIcon;
    if (widget.field.type == VooFieldType.password) {
      suffixIcon = IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          size: design.iconSizeMd,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    } else if (widget.field.suffixIcon != null) {
      suffixIcon = Icon(
        widget.field.suffixIcon,
        size: design.iconSizeMd,
      );
    } else {
      suffixIcon = widget.field.suffix;
    }

    // Determine max lines based on field type
    int? maxLines = widget.field.maxLines;
    if (widget.field.type == VooFieldType.multiline) {
      maxLines = widget.field.maxLines ?? 4;
    } else if (widget.field.type == VooFieldType.password) {
      maxLines = 1;
    }

    // Build input formatters
    final List<TextInputFormatter> inputFormatters = [
      ...?widget.field.inputFormatters,
    ];

    if (widget.field.maxLength != null) {
      inputFormatters.add(
        LengthLimitingTextInputFormatter(widget.field.maxLength),
      );
    }

    if (widget.field.type == VooFieldType.number) {
      inputFormatters.add(
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.\-]')),
      );
    } else if (widget.field.type == VooFieldType.phone) {
      inputFormatters.add(
        FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\(\) ]')),
      );
    }

    // Determine text input action
    TextInputAction? textInputAction = widget.field.textInputAction;
    if (textInputAction == null) {
      if (widget.field.type == VooFieldType.multiline) {
        textInputAction = TextInputAction.newline;
      } else {
        textInputAction = TextInputAction.next;
      }
    }

    // Get error text
    final errorText =
        widget.showError ? (widget.error ?? widget.field.error) : null;

    return VooTextField(
      controller: _controller,
      focusNode: _focusNode,
      label: widget.field.label,
      hint: widget.field.hint,
      helper: widget.field.helper,
      error: errorText,
      prefix: widget.field.prefix,
      suffix: suffixIcon,
      prefixIcon: widget.field.prefixIcon,
      obscureText: _obscureText,
      enabled: widget.field.enabled,
      readOnly: widget.field.readOnly,
      autofocus: false,
      maxLines: maxLines,
      minLines: widget.field.minLines,
      maxLength: widget.field.maxLength,
      keyboardType: widget.field.type.keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters.isNotEmpty ? inputFormatters : null,
      onChanged: (value) {
        widget.onChanged?.call(value);
        widget.field.onChanged?.call(value);
      },
      onEditingComplete: () {
        widget.onEditingComplete?.call();
      },
      onSubmitted: (value) {
        widget.onSubmitted?.call(value);
      },
      onTap: widget.field.onTap,
      textCapitalization: widget.field.textCapitalization ??
          (widget.field.type == VooFieldType.email
              ? TextCapitalization.none
              : TextCapitalization.sentences),
    );
  }
}
