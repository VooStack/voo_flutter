import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_forms/src/domain/entities/field_type.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';

/// Enhanced text form field that uses Flutter's default theme
class VooTextFormFieldV2 extends StatefulWidget {
  final VooFormField field;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final String? error;
  final bool showError;
  final InputDecoration? decoration;
  final bool autoFocus;

  const VooTextFormFieldV2({
    super.key,
    required this.field,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.error,
    this.showError = true,
    this.decoration,
    this.autoFocus = false,
  });

  @override
  State<VooTextFormFieldV2> createState() => _VooTextFormFieldV2State();
}

class _VooTextFormFieldV2State extends State<VooTextFormFieldV2> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _obscureText = false;
  bool _hasBeenFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        TextEditingController(text: widget.field.value?.toString() ?? '');
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.field.type == VooFieldType.password;

    // Add focus listener for validation on focus lost
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus && _hasBeenFocused) {
      // Field lost focus, trigger validation if configured
      if (widget.field.validateOnFocusLost) {
        // Trigger validation through controller if needed
        setState(() {});
      }
    }
    if (_focusNode.hasFocus) {
      _hasBeenFocused = true;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  Widget? _buildPrefixWidget() {
    if (widget.field.prefix != null) {
      return widget.field.prefix;
    }
    if (widget.field.prefixIcon != null) {
      return Icon(widget.field.prefixIcon);
    }
    return null;
  }

  Widget? _buildSuffixWidget() {
    if (widget.field.type == VooFieldType.password) {
      return IconButton(
        icon: Icon(
          _obscureText 
              ? Icons.visibility_outlined 
              : Icons.visibility_off_outlined,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        tooltip: _obscureText ? 'Show password' : 'Hide password',
      );
    }
    if (widget.field.suffix != null) {
      return widget.field.suffix;
    }
    if (widget.field.suffixIcon != null) {
      return Icon(widget.field.suffixIcon);
    }
    return null;
  }

  List<TextInputFormatter> _buildInputFormatters() {
    final List<TextInputFormatter> formatters = [];

    // Add custom formatters
    if (widget.field.inputFormatters != null) {
      formatters.addAll(widget.field.inputFormatters!);
    }

    // Add length formatter
    if (widget.field.maxLength != null) {
      formatters.add(LengthLimitingTextInputFormatter(widget.field.maxLength));
    }

    // Add type-specific formatters
    switch (widget.field.type) {
      case VooFieldType.number:
        formatters.add(FilteringTextInputFormatter.allow(RegExp(r'[0-9.\-]')));
        break;
      case VooFieldType.phone:
        formatters.add(FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\(\) ]')));
        break;
      default:
        break;
    }

    return formatters;
  }

  TextInputAction _getTextInputAction() {
    if (widget.field.textInputAction != null) {
      return widget.field.textInputAction!;
    }
    
    switch (widget.field.type) {
      case VooFieldType.multiline:
        return TextInputAction.newline;
      case VooFieldType.email:
      case VooFieldType.password:
        return TextInputAction.next;
      default:
        return TextInputAction.next;
    }
  }

  int? _getMaxLines() {
    if (widget.field.type == VooFieldType.multiline) {
      return widget.field.maxLines ?? 4;
    }
    if (widget.field.type == VooFieldType.password || _obscureText) {
      return 1;
    }
    return widget.field.maxLines;
  }

  TextCapitalization _getTextCapitalization() {
    if (widget.field.textCapitalization != null) {
      return widget.field.textCapitalization!;
    }
    
    switch (widget.field.type) {
      case VooFieldType.email:
      case VooFieldType.password:
      case VooFieldType.url:
        return TextCapitalization.none;
      case VooFieldType.text:
        return TextCapitalization.sentences;
      default:
        return TextCapitalization.sentences;
    }
  }

  InputDecoration _buildDecoration(BuildContext context) {
    
    // Use provided decoration or create default
    InputDecoration baseDecoration = widget.decoration ?? 
        widget.field.decoration ?? 
        const InputDecoration();

    // Get error text
    final errorText = widget.showError 
        ? (widget.error ?? widget.field.error) 
        : null;

    // Build label with required indicator
    String? labelText = widget.field.label;
    if (labelText != null && widget.field.required) {
      labelText = '$labelText *';
    }

    return baseDecoration.copyWith(
      labelText: baseDecoration.labelText ?? labelText,
      hintText: baseDecoration.hintText ?? widget.field.hint,
      helperText: baseDecoration.helperText ?? widget.field.helper,
      errorText: errorText,
      prefixIcon: baseDecoration.prefixIcon ?? _buildPrefixWidget(),
      suffixIcon: baseDecoration.suffixIcon ?? _buildSuffixWidget(),
      contentPadding: baseDecoration.contentPadding ?? widget.field.padding,
      counter: widget.field.maxLength != null 
          ? null // Let TextField handle counter
          : baseDecoration.counter,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputFormatters = _buildInputFormatters();
    final decoration = _buildDecoration(context);
    final maxLines = _getMaxLines();
    final textInputAction = _getTextInputAction();
    final textCapitalization = _getTextCapitalization();

    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      decoration: decoration,
      obscureText: _obscureText,
      enabled: widget.field.enabled,
      readOnly: widget.field.readOnly,
      autofocus: widget.autoFocus,
      maxLines: maxLines,
      minLines: widget.field.minLines,
      maxLength: widget.field.maxLength,
      keyboardType: widget.field.type.keyboardType ?? TextInputType.text,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters.isNotEmpty ? inputFormatters : null,
      style: theme.textTheme.bodyLarge,
      cursorColor: theme.colorScheme.primary,
      validator: (_) => widget.field.validate(),
      autovalidateMode: widget.field.validateOnChange 
          ? AutovalidateMode.onUserInteraction 
          : AutovalidateMode.disabled,
      onChanged: (value) {
        widget.onChanged?.call(value);
        widget.field.onChanged?.call(value);
      },
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.field.onTap,
      onSaved: (value) {
        // Handle save if needed
      },
    );
  }
}