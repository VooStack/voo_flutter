import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/error_display_mode.dart';
import 'package:voo_forms/src/domain/entities/field_type.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/atoms/fields/text_field_helpers.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';

/// Enhanced text form field that uses Flutter's default theme
class VooTextFormField extends StatefulWidget {
  final VooFormField field;
  final VooFieldOptions options;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final String? error;
  final bool showError;
  final InputDecoration? decoration;
  final bool autoFocus;
  final VooFormErrorConfig? errorConfig;

  const VooTextFormField({
    super.key,
    required this.field,
    required this.options,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.error,
    this.showError = true,
    this.decoration,
    this.autoFocus = false,
    this.errorConfig,
  });

  @override
  State<VooTextFormField> createState() => _VooTextFormFieldState();
}

class _VooTextFormFieldState extends State<VooTextFormField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  
  bool _obscureText = false;
  bool _hasBeenFocused = false;
  
  // Helper instances
  static const _prefixBuilder = TextFieldPrefixBuilder();
  static const _suffixBuilder = TextFieldSuffixBuilder();
  static const _formattersBuilder = TextFieldFormattersBuilder();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        TextEditingController(text: widget.field.value?.toString() ?? widget.field.initialValue?.toString() ?? '');
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
    final theme = Theme.of(context);
    
    // If a decoration was explicitly provided, use it as-is with minimal changes
    if (widget.decoration != null) {
      final errorText = widget.showError 
          ? (widget.error ?? widget.field.error) 
          : null;
      
      return widget.decoration!.copyWith(
        errorText: errorText,
        // Only add prefix/suffix if not already in decoration
        prefixIcon: widget.decoration!.prefixIcon ?? 
            (widget.field.prefixIcon != null ? Icon(widget.field.prefixIcon) : null),
        suffixIcon: widget.decoration!.suffixIcon ?? _suffixBuilder.build(
          field: widget.field,
          obscureText: _obscureText,
          onToggleObscureText: widget.field.type == VooFieldType.password
              ? () => setState(() => _obscureText = !_obscureText)
              : null,
        ),
      );
    }
    
    // Build decoration based on label position from options
    InputDecoration decoration;
    
    // Build label with required indicator
    String? labelText = widget.field.label;
    if (labelText != null && widget.field.required) {
      labelText = '$labelText *';
    }
    
    final prefixWidget = _prefixBuilder.build(widget.field);
    final suffixWidget = _suffixBuilder.build(
      field: widget.field,
      obscureText: _obscureText,
      onToggleObscureText: widget.field.type == VooFieldType.password
          ? () => setState(() => _obscureText = !_obscureText)
          : null,
    );
    
    if (widget.options.labelPosition == LabelPosition.floating) {
      decoration = InputDecoration(
        labelText: labelText,
        hintText: widget.field.hint,
        errorText: widget.showError ? (widget.error ?? widget.field.error) : null,
        helperText: widget.field.helper,
        prefixIcon: prefixWidget,
        suffixIcon: suffixWidget,
        contentPadding: widget.field.padding,
      );
    } else if (widget.options.labelPosition == LabelPosition.placeholder) {
      decoration = InputDecoration(
        hintText: labelText ?? widget.field.hint,
        errorText: widget.showError ? (widget.error ?? widget.field.error) : null,
        helperText: widget.field.helper,
        prefixIcon: prefixWidget,
        suffixIcon: suffixWidget,
        contentPadding: widget.field.padding,
      );
    } else {
      // For above/left/hidden positions
      decoration = InputDecoration(
        hintText: widget.field.hint,
        errorText: widget.showError ? (widget.error ?? widget.field.error) : null,
        helperText: widget.field.helper,
        prefixIcon: prefixWidget,
        suffixIcon: suffixWidget,
        contentPadding: widget.field.padding,
      );
    }
    
    // Apply field variant styling
    switch (widget.options.fieldVariant) {
      case FieldVariant.filled:
        return decoration.copyWith(
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        );
      case FieldVariant.underlined:
        return decoration.copyWith(
          border: const UnderlineInputBorder(),
        );
      case FieldVariant.ghost:
        return decoration.copyWith(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.colorScheme.primary),
          ),
        );
      case FieldVariant.rounded:
        return decoration.copyWith(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
        );
      case FieldVariant.sharp:
        return decoration.copyWith(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
          ),
        );
      default:
        return decoration;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputFormatters = _formattersBuilder.build(widget.field);
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
      style: widget.options.textStyle ?? theme.textTheme.bodyLarge,
      cursorColor: theme.colorScheme.primary,
      validator: (_) => widget.field.validate(),
      autovalidateMode: widget.field.validateOnChange 
          ? AutovalidateMode.onUserInteraction 
          : AutovalidateMode.disabled,
      onChanged: (value) {
        // Always call widget.onChanged with the string value
        widget.onChanged?.call(value);
        
        // For field.onChanged, parse the value if needed
        dynamic callbackValue = value;
        if (widget.field.type == VooFieldType.number && value.isNotEmpty) {
          callbackValue = num.tryParse(value) ?? value;
        }
        
        // Safely call field.onChanged with type checking
        try {
          final dynamic dynField = widget.field;
          final callback = dynField.onChanged;
          if (callback != null) {
            callback(callbackValue);
          }
        } catch (_) {
          // Silently ignore type casting errors
        }
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