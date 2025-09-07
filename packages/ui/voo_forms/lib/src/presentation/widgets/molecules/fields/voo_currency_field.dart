import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_field_base.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_read_only_field.dart';
import 'package:voo_forms/voo_forms.dart';

/// Currency field molecule with proper currency formatting
/// Displays values with currency symbols, thousand separators, and decimal places
/// Supports multiple currency formats (USD, EUR, GBP, JPY)
class VooCurrencyField extends VooFieldBase<double> {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final double? min;
  final double? max;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  
  /// Currency symbol to display (default: $)
  final String currencySymbol;
  
  /// Currency code for locale-specific formatting
  final String? currencyCode;
  
  /// Number of decimal places (default: 2)
  final int decimalDigits;
  
  /// Locale for number formatting (default: en_US)
  final String locale;

  const VooCurrencyField({
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
    super.prefixIcon,
    super.suffixIcon,
    super.gridColumns,
    super.error,
    super.showError,
    this.controller,
    this.focusNode,
    this.min = 0,
    this.max,
    this.onEditingComplete,
    this.onSubmitted,
    this.autofocus = false,
    this.currencySymbol = '\$',
    this.currencyCode,
    this.decimalDigits = 2,
    this.locale = 'en_US',
  }) : super(placeholder: placeholder ?? '\$0.00');

  @override
  String? validate(double? value) {
    // Call base validation first for required check
    final baseError = super.validate(value);
    if (baseError != null) return baseError;

    // Check min/max constraints
    if (value != null) {
      if (min != null && value < min!) {
        final formatted = _formatCurrencyValue(min!);
        return '${label ?? name} must be at least $formatted';
      }
      if (max != null && value > max!) {
        final formatted = _formatCurrencyValue(max!);
        return '${label ?? name} must be at most $formatted';
      }
    }

    return null;
  }
  
  String _formatCurrencyValue(double value) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: currencySymbol,
      decimalDigits: decimalDigits,
    );
    return formatter.format(value);
  }
  
  CurrencyFormatter _getCurrencyFormatter() {
    // Use predefined formatters for common currencies
    switch (currencySymbol.toLowerCase()) {
      case '€':
      case 'eur':
        return CurrencyFormatter.eur();
      case '£':
      case 'gbp':
        return CurrencyFormatter.gbp();
      case '¥':
      case 'jpy':
        return CurrencyFormatter.jpy();
      default:
        return CurrencyFormatter(
          symbol: currencySymbol,
          decimalDigits: decimalDigits,
          locale: locale,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Return empty widget if hidden
    if (isHidden) return const SizedBox.shrink();

    final effectiveReadOnly = getEffectiveReadOnly(context);

    // If read-only, show formatted currency value
    if (effectiveReadOnly) {
      String displayValue = '';
      if (initialValue != null) {
        displayValue = _formatCurrencyValue(initialValue!);
      }
      
      Widget readOnlyContent = VooReadOnlyField(
        value: displayValue,
        icon: _getCurrencyIcon(),
      );
      
      // Apply standard field building pattern
      readOnlyContent = buildWithHelper(context, readOnlyContent);
      readOnlyContent = buildWithError(context, readOnlyContent);
      readOnlyContent = buildWithLabel(context, readOnlyContent);
      readOnlyContent = buildWithActions(context, readOnlyContent);
      
      return buildFieldContainer(context, readOnlyContent);
    }

    // Create controller if not provided
    final TextEditingController effectiveController = controller ?? TextEditingController();
    
    // Set initial value if provided
    if (controller == null && initialValue != null) {
      effectiveController.text = _formatCurrencyValue(initialValue!);
    }

    final currencyInput = TextFormField(
      controller: effectiveController,
      focusNode: focusNode,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
      ),
      textInputAction: TextInputAction.next,
      inputFormatters: [
        _getCurrencyFormatter(),
      ],
      onChanged: (text) {
        if (onChanged != null) {
          // Parse the formatted currency value back to double
          final value = CurrencyFormatter.parse(text);
          onChanged!(value);
        }
      },
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onSubmitted,
      enabled: enabled,
      autofocus: autofocus,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: getInputDecoration(context).copyWith(
        prefixIcon: prefixIcon ?? _getCurrencyIcon(),
        suffixIcon: suffixIcon,
      ),
    );

    // Compose with label, helper, error and actions using base class methods
    return buildWithLabel(
      context,
      buildWithHelper(
        context,
        buildWithError(
          context,
          buildWithActions(
            context,
            currencyInput,
          ),
        ),
      ),
    );
  }
  
  Widget _getCurrencyIcon() {
    IconData iconData;
    switch (currencySymbol.toLowerCase()) {
      case '€':
      case 'eur':
        iconData = Icons.euro;
        break;
      case '£':
      case 'gbp':
        iconData = Icons.currency_pound;
        break;
      case '¥':
      case 'jpy':
        iconData = Icons.currency_yen;
        break;
      case '₹':
      case 'inr':
        iconData = Icons.currency_rupee;
        break;
      case '₽':
      case 'rub':
        iconData = Icons.currency_ruble;
        break;
      case '₣':
      case 'chf':
        iconData = Icons.currency_franc;
        break;
      case '₩':
      case 'krw':
        iconData = Icons.monetization_on;
        break;
      case '₺':
      case 'try':
        iconData = Icons.currency_lira;
        break;
      case '฿':
      case 'thb':
        iconData = Icons.payments;
        break;
      case '\$':
      case 'usd':
      default:
        iconData = Icons.attach_money;
        break;
    }
    return Icon(iconData);
  }

  @override
  VooCurrencyField copyWith({
    double? initialValue,
    String? label,
    VooFieldLayout? layout,
    String? name,
    bool? readOnly,
  }) =>
      VooCurrencyField(
        key: key,
        name: name ?? this.name,
        label: label ?? this.label,
        labelWidget: labelWidget,
        hint: hint,
        helper: helper,
        placeholder: placeholder,
        initialValue: initialValue ?? this.initialValue,
        enabled: enabled,
        readOnly: readOnly ?? this.readOnly,
        validators: validators,
        onChanged: onChanged,
        actions: actions,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        gridColumns: gridColumns,
        error: error,
        showError: showError,
        controller: controller,
        focusNode: focusNode,
        min: min,
        max: max,
        onEditingComplete: onEditingComplete,
        onSubmitted: onSubmitted,
        autofocus: autofocus,
        currencySymbol: currencySymbol,
        currencyCode: currencyCode,
        decimalDigits: decimalDigits,
        locale: locale,
      );
}