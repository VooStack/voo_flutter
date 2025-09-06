import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_decimal_field.dart';

/// Currency field molecule - extends VooDecimalField with currency-specific defaults
/// Automatically sets 2 decimal places, no negative values, and currency icon
class VooCurrencyField extends VooDecimalField {
  VooCurrencyField({
    super.key,
    required super.name,
    super.label,
    super.labelWidget,
    super.hint,
    super.helper,
    String? placeholder,
    super.initialValue,
    super.enabled,
    super.readOnly,
    super.validators,
    super.onChanged,
    super.actions,
    Widget? prefixIcon,
    super.suffixIcon,
    super.gridColumns,
    super.error,
    super.showError,
    super.controller,
    super.focusNode,
    super.max,
    super.onEditingComplete,
    super.onSubmitted,
    super.autofocus,
    String? currencySymbol,
  }) : super(
          placeholder: placeholder ?? '0.00',
          min: 0,
          maxDecimalPlaces: 2, // Standard for currency
          allowNegative: false,
          prefixIcon: prefixIcon ??
              Icon(
                currencySymbol == '€'
                    ? Icons.euro
                    : currencySymbol == '£'
                        ? Icons.currency_pound
                        : currencySymbol == '¥'
                            ? Icons.currency_yen
                            : Icons.attach_money,
              ),
        );
}
