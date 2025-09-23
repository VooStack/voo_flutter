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
    super.layout,
    super.isHidden,
    super.minWidth,
    super.maxWidth,
    super.minHeight,
    super.maxHeight,
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
    final formatter = NumberFormat.currency(locale: locale, symbol: currencySymbol, decimalDigits: decimalDigits);
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
        final formatter = CurrencyFormatter(symbol: currencySymbol, decimalDigits: decimalDigits, locale: locale, minValue: min, maxValue: max);
        // Set initial value if provided
        if (initialValue != null) {
          formatter.setInitialValue(initialValue!);
        }
        return formatter;
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

      Widget readOnlyContent = VooReadOnlyField(value: displayValue, icon: _getCurrencyIcon());

      // Apply standard field building pattern
      readOnlyContent = buildWithHelper(context, readOnlyContent);
      readOnlyContent = buildWithError(context, readOnlyContent);
      readOnlyContent = buildWithLabel(context, readOnlyContent);
      readOnlyContent = buildWithActions(context, readOnlyContent);

      return buildFieldContainer(context, readOnlyContent);
    }

    // Use the stateful widget with a stable key based on field name
    // This ensures the widget survives parent rebuilds
    return _VooCurrencyFieldStateful(key: ValueKey('voo_currency_field_$name'), field: this);
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
  VooCurrencyField copyWith({double? initialValue, String? label, VooFieldLayout? layout, String? name, bool? readOnly}) => VooCurrencyField(
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

/// Stateful widget to manage currency field state and prevent keyboard dismissal
class _VooCurrencyFieldStateful extends StatefulWidget {
  final VooCurrencyField field;

  const _VooCurrencyFieldStateful({super.key, required this.field});

  @override
  State<_VooCurrencyFieldStateful> createState() => _VooCurrencyFieldStatefulState();
}

class _VooCurrencyFieldStatefulState extends State<_VooCurrencyFieldStateful> with AutomaticKeepAliveClientMixin {
  TextEditingController? _effectiveController;
  FocusNode? _effectiveFocusNode;
  VooFormController? _formController;
  CurrencyFormatter? _currencyFormatter;

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get the form controller from scope if available
    final formScope = VooFormScope.of(context);
    _formController = formScope?.controller;

    // Initialize or update controllers
    _initializeControllers();
  }

  @override
  void didUpdateWidget(_VooCurrencyFieldStateful oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Preserve focus state during widget updates
    final hadFocus = _effectiveFocusNode?.hasFocus ?? false;

    // If the field name changed, we need to get the correct controller
    if (oldWidget.field.name != widget.field.name) {
      _initializeControllers();
    }

    // Restore focus if the field had it before the update
    if (hadFocus && _effectiveFocusNode != null && !_effectiveFocusNode!.hasFocus) {
      // Schedule focus restoration after the build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _effectiveFocusNode != null) {
          _effectiveFocusNode!.requestFocus();
        }
      });
    }
  }

  void _initializeControllers() {
    // Initialize currency formatter once (persistent across keystrokes)
    _currencyFormatter ??= widget.field._getCurrencyFormatter();

    // Create controller if not provided (only create if we don't already have one)
    if (widget.field.controller != null) {
      _effectiveController = widget.field.controller;
    } else if (_effectiveController == null) {
      _effectiveController = TextEditingController();
      // Set initial value if provided
      if (widget.field.initialValue != null) {
        _effectiveController!.text = widget.field._formatCurrencyValue(widget.field.initialValue!);
      }
    }

    // Use provided focus node or get one from form controller if available
    _effectiveFocusNode = widget.field.focusNode;
    if (_effectiveFocusNode == null && _formController != null) {
      _effectiveFocusNode = _formController!.getFocusNode(widget.field.name);
    }
  }

  @override
  void dispose() {
    // Only dispose the controller if we created it
    if (widget.field.controller == null) {
      _effectiveController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    // Create wrapped onChanged that updates both controller and calls user callback
    void handleChanged(String text) {
      // Parse the formatted currency value back to double
      final value = CurrencyFormatter.parse(text, symbol: widget.field.currencySymbol);

      // Update form controller if available
      if (_formController != null) {
        // Check if we should validate based on error display mode and current error state
        final hasError = _formController!.hasError(widget.field.name);
        final shouldValidate =
            hasError || _formController!.errorDisplayMode == VooFormErrorDisplayMode.onTyping || _formController!.validationMode == FormValidationMode.onChange;

        _formController!.setValue(widget.field.name, value, validate: shouldValidate);
      }

      // Call user's onChanged if provided
      widget.field.onChanged?.call(value);
    }

    // Listen to form controller for error state changes only
    if (_formController != null) {
      return AnimatedBuilder(
        animation: _formController!,
        builder: (context, child) {
          // Get the current error from the form controller
          final error = _formController!.getError(widget.field.name);

          // Create decoration with error text included
          final decoration = widget.field
              .getInputDecoration(context)
              .copyWith(
                prefixIcon: widget.field.prefixIcon ?? widget.field._getCurrencyIcon(),
                suffixIcon: widget.field.suffixIcon,
                errorText: widget.field.showError != false ? error : null,
              );

          // Build the currency input widget with the error in the decoration
          final currencyInput = TextFormField(
            controller: _effectiveController,
            focusNode: _effectiveFocusNode,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            inputFormatters: [_currencyFormatter!],
            onChanged: handleChanged,
            onEditingComplete: widget.field.onEditingComplete,
            onFieldSubmitted: widget.field.onSubmitted,
            enabled: widget.field.enabled,
            autofocus: widget.field.autofocus,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: decoration, // Use decoration with error
          );

          // Apply height constraints to the input widget
          final constrainedInput = widget.field.applyInputHeightConstraints(currencyInput);

          // Build with label, helper, and actions (but NOT error - it's in the decoration now)
          return widget.field.buildFieldContainer(
            context,
            widget.field.buildWithLabel(context, widget.field.buildWithHelper(context, widget.field.buildWithActions(context, constrainedInput))),
          );
        },
      );
    }

    // If no form controller, build without AnimatedBuilder
    final currencyInput = TextFormField(
      controller: _effectiveController,
      focusNode: _effectiveFocusNode,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.done,
      inputFormatters: [_currencyFormatter!],
      onChanged: handleChanged,
      onEditingComplete: widget.field.onEditingComplete,
      onFieldSubmitted: widget.field.onSubmitted,
      enabled: widget.field.enabled,
      autofocus: widget.field.autofocus,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: widget.field
          .getInputDecoration(context)
          .copyWith(
            prefixIcon: widget.field.prefixIcon ?? widget.field._getCurrencyIcon(),
            suffixIcon: widget.field.suffixIcon,
            errorText: widget.field.showError != false ? widget.field.error : null,
          ),
    );

    // Apply height constraints to the input widget
    final constrainedInput = widget.field.applyInputHeightConstraints(currencyInput);

    return widget.field.buildFieldContainer(
      context,
      widget.field.buildWithLabel(context, widget.field.buildWithHelper(context, widget.field.buildWithActions(context, constrainedInput))),
    );
  }
}
