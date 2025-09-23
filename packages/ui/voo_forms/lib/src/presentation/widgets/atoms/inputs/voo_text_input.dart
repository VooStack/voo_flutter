import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Pure text input atom - just the input field with no decoration
/// Used as a building block for text-based field molecules
class VooTextInput extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? initialValue;
  final String? placeholder;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool expands;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final TextStyle? style;
  final TextAlign textAlign;
  final InputDecoration? decoration;

  const VooTextInput({
    super.key,
    this.controller,
    this.focusNode,
    this.initialValue,
    this.placeholder,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.inputFormatters,
    this.obscureText = false,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.expands = false,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.style,
    this.textAlign = TextAlign.start,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    focusNode: focusNode,
    initialValue: controller != null ? null : initialValue,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    inputFormatters: inputFormatters,
    obscureText: obscureText,
    enableSuggestions: enableSuggestions,
    autocorrect: autocorrect,
    maxLines: expands ? null : maxLines,
    minLines: expands ? null : minLines,
    maxLength: maxLength,
    expands: expands,
    textCapitalization: textCapitalization,
    onChanged: onChanged,
    onEditingComplete: onEditingComplete,
    onFieldSubmitted: onSubmitted,
    enabled: enabled,
    readOnly: readOnly,
    autofocus: autofocus,
    style: style,
    textAlign: textAlign,
    decoration: decoration ?? InputDecoration(hintText: placeholder),
  );
}
