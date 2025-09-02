import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Pure number input atom - just the numeric input field with no decoration
/// Used as a building block for number-based field molecules
class VooNumberInput extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final num? initialValue;
  final String? placeholder;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final TextStyle? style;
  final TextAlign textAlign;
  final InputDecoration? decoration;
  final bool signed;
  final bool decimal;

  const VooNumberInput({
    super.key,
    this.controller,
    this.focusNode,
    this.initialValue,
    this.placeholder,
    this.inputFormatters,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.style,
    this.textAlign = TextAlign.start,
    this.decoration,
    this.signed = true,
    this.decimal = true,
  });

  @override
  Widget build(BuildContext context) => TextFormField(
      controller: controller,
      focusNode: focusNode,
      initialValue: controller == null && initialValue != null 
          ? initialValue.toString() 
          : null,
      keyboardType: TextInputType.numberWithOptions(
        signed: signed,
        decimal: decimal,
      ),
      textInputAction: TextInputAction.next,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onSubmitted,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      style: style,
      textAlign: textAlign,
      decoration: decoration ?? InputDecoration(
        hintText: placeholder,
      ),
    );
}